var express = require('express');
var router = express.Router();
var service = require('./vlanService');
const auth = require('../auth/authService');

router.get('/all', async function(req, res) {
    auth.validateAccess(req.headers.authorization, 'STANDARD', res).then(async () => {
        res.json(await service.getAllVlans());
    }).catch(err => {
        console.log(err);
        res.status(401).json(err);
    });
});

router.post('/add', async function(req, res) {
    auth.validateAccess(req.headers.authorization, 'ADMIN', res).then(async (userId) => {
        await service.addNewVlan(req.body, userId);
        res.send("VLAN '" + req.body.name + "' created");
    }).catch(err => {
        console.log(err);
        res.status(401).json(err);
    });
});

router.post('/rename', async (req, res) => {
    auth.validateAccess(req.headers.authorization, 'ADMIN, res').then(async (userId) => {
        await service.renameVlan(req.body.name, req.body.id);
        res.send('VLAN with id='+req.body.id+' rename to '+req.body.name);
    }).catch(err => {
        console.log(err);
        res.status(401).json(err);
    });
});

router.post('/remove', async function(req, res) {
    auth.validateAccess(req.headers.authorization, 'ADMIN', res).then(async () => {
        await service.removeVlan(req.body);
        res.send("VLAN with id=" + req.body.id + " removed");
    }).catch(err => {
        console.log(err);
        res.status(401).json(err);
    });
})

module.exports = router;