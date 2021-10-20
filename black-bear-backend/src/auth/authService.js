const repository = require('../user/userRepository');
const vlanService = require('../vlan/vlanService');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const randomString = require('crypto-random-string');
const mailjet = require ('node-mailjet')
    .connect(process.env.MJ_APIKEY_PUBLIC, process.env.MJ_APIKEY_PRIVATE);
const SALT = 10;

module.exports = {

    async login(body, res) {
        repository.fetchUserByUsername(body.username, body.password).then((userResults) => {
            // console.log(JSON.stringify(userResults));
            if (userResults.length !== 0 && bcrypt.compareSync(body.password, userResults[0].Password, 10)) {
                const user = userResults[0];
                const token = jwt.sign({username: user.Username, email: user.Email, _id: user.UserAccountRecordIdentifier}, 'RESTFUL');
                res.json({token: token, userRole: user.UserRole});
            }
            else {
                res.status(401).send('Unauthorized');
            }
        });
    },

    async logout(token) {

    },

    async registerInitialAdminUser(firstName = null, lastName = null, username, email = null, password, phone = null) {
        const existingAdmins = await repository.fetchUsersByRole('ADMIN');
        if (existingAdmins.length === 0){
            await repository.saveNewUser(
                firstName,
                lastName,
                username,
                email,
                bcrypt.hashSync(password, 10),
                'ADMIN',
                phone
            );
            await vlanService.setDefaultVlans();
            return true;
        }
        else {
            return false;
        }
    },

    async registerNewUser(email, userRole) {
        const password = randomString({length: 15, type: 'ascii-printable'});
        const username = randomString({length: 8, type: 'ascii-printable'});
        // console.log("Username: "+username+"\nPassword: "+ password);

        const emailMessage = 'Greetings! \n\nYou have been added as a new user of a Black Bear router with '
        + userRole + ' privileges. To log into your account, first ensure that your are connected to the network.'
        + ' Then, navigate to the Black Bear Web Portal in a browser and enter these credentials: \n'
        + 'Username: ' + username
        + '\nPassword: ' + password;

        const request = mailjet
            .post("send", {
                url: 'api.mailjet.com', version: 'v3.1', perform_api_call: process.env.MJ_SEND_INDICATOR === "true"
            })
            .request({
                "Messages":[
                    {
                        "From": {
                            "Email": "sgall009@odu.edu",
                            "Name": "Black Bear"
                        },
                        "To": [
                            {
                                "Email": email,
                                "Name": ""
                            }
                        ],
                        "Subject": "Welcome to Black Bear",
                        "TextPart": emailMessage
                    }
                ]
            });

        request
            .then(async (result) => {
                // console.log(result);
                await repository.saveNewUser(
                    null,
                    null,
                    username,
                    email,
                    bcrypt.hashSync(password, 10),
                    userRole,
                    null
                );
            })
            .catch((err) => {
                console.log(err.statusCode);
            });
    },

    async validateAccess(token, minimumRole, res) {
        var decoded = jwt.decode(token);
        if (decoded != null){
            const user = await repository.fetchRoleByUserId(decoded._id);
            // console.log(JSON.stringify(user));
            if (user.length !== 0){
                if (user[0].UserRole === minimumRole || user[0].UserRole === 'ADMIN'){
                    return Promise.resolve(user[0].UserAccountRecordIdentifier);
                }
            }
        }
        return Promise.reject("Unauthorized");
    },

    getUserIdFromToken(token) {
        if (token == null){
            throw new Error("No Auth token");
        }

        let decoded = jwt.decode(token);
        if (decoded == null){
            throw new Error("Invalid Auth token");
        }
        if (decoded._id == null){
            throw new Error("Invalid Auth token");
        }

        return decoded._id;
    }

};