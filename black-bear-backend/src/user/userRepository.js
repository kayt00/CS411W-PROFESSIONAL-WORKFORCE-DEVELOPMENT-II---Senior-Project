var db = require('mysql');
var util = require('util');

var connection = db.createConnection({
    host     : 'localhost',
    port: 13306,
    user     : 'root',
    password : 'example',
    database : 'BlackBear'
});

const query = util.promisify(connection.query).bind(connection);

module.exports = {
    async fetchUserByUsername(username, password){
        return await query('SELECT * FROM UserAccount WHERE Username = ?', [username]);
    },

    async fetchRoleByUserId(id) {
        return await query('SELECT UserRole FROM UserAccount WHERE UserAccountRecordIdentifier = ?', [id]);
    },

    async saveNewUser(firstName = null, lastName = null, username, email = null, password, userRole, phone = null) {
        await query('INSERT INTO UserAccount SET ?', {
            FirstName: firstName,
            LastName: lastName,
            Username: username,
            Password: password,
            UserRole: userRole,
            Email: email,
            Phone: phone
        });
    },

    async fetchUsersByRole(type) {
        return await query('SELECT * FROM UserAccount WHERE UserRole = ?', [type]);
    },

    async fetchUserProfileById(id) {
        return await query(
            `SELECT FirstName
            ,LastName
            ,UserName
            ,UserRole
            ,Email
            ,Phone
            ,SmsOutageAlerts
            ,WeeklySummary,
            MonthlySummary
            FROM UserAccount
            WHERE UserAccountRecordIdentifier = ?`, [id]
            );
    },

    async fetchAllUsers() {
        return await query('SELECT Username, Email, UserRole FROM UserAccount');
    }
}