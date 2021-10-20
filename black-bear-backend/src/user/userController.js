const express = require('express');
const router = express.Router();
const service = require('./userService');
const auth = require('../auth/authService');

router.get('/user-profile', async function(req, res) {
    let userId = auth.getUserIdFromToken(req.headers.authorization);
    let profile = await service.getUserProfile(userId);
    if (profile == null)
        res.status(401).send("Unauthorized");
    else
        res.status(200).json(profile);
});

router.get('/all', async function(req,res) {
    auth.validateAccess(req.headers.authorization, 'ADMIN', res).then(async () => {
        let users = await service.getAllUsers();
        res.status(200).json(users);
    }).catch(err => {
        console.log(err);
        res.status(401).json(err);
    });
});

router.get('/admin-user-exists', async function(req, res) {
    res.status(200).send(await service.adminExists());
});

module.exports = router;