var express = require('express');
const service  = require('./authService');
var router = express.Router();

router.post("/login", async (req, res) => {
    // console.log(JSON.stringify(req.body));
    await service.login(req.body, res);
});

router.post("/logout", async (req, res) => {

});

router.post("/register-initial-admin", async (req, res) => {
    const success = await service.registerInitialAdminUser(
        req.body.firstName,
        req.body.lastName,
        req.body.username,
        req.body.email,
        req.body.password,
        req.body.phone
    );
    success ? res.status(200).send("Successfully added initial admin user")
    : res.status(400).send("Could not add initial admin user");
});

router.post("/add-user", async (req, res) => {
    service.validateAccess(req.headers.authorization, 'ADMIN', res).then(async () => {
        await service.registerNewUser(req.body.email, req.body.userRole);
        res.status(200).send("User created!");
    }).catch(err => {
        console.log(err);
        res.status(401).json(err);
    });
});

module.exports = router;