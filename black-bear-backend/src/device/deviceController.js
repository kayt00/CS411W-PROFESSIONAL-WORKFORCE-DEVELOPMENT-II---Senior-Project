var express = require('express');
var router = express.Router();
var service = require('./deviceService');
const auth = require('../auth/authService');

router.get('/all', async (req, res) => {
    auth.validateAccess(req.headers.authorization, 'STANDARD', res).then(async () =>{
        res.json(await service.getAllDevices());
    }).catch(err => {
        console.log(err);
        res.status(401).json(err);
    });
});

router.get('/pending', async (req, res) => {
    auth.validateAccess(req.headers.authorization, 'STANDARD', res).then(async () =>{
        res.json(await service.getAllPendingDevices());
    }).catch(err => {
        console.log(err);
        res.status(401).json(err);
    });
});

router.post('/approve', async (req, res) => {
    auth.validateAccess(
        req.headers.authorization,
        req.body.vlan === 0 ? 'STANDARD' : 'ADMIN',
        res
    ).then(async () =>{
        await service.approveDevice(req.body, req.headers.authorization)
        res.json("Permanently added device to VLAN "+ req.body.vlan);
    }).catch(err => {
        console.log(err);
        res.status(401).json(err);
    });
});

router.post('/add', async (req, res) => {
    auth.validateAccess(req.headers.authorization, 'ADMIN', res).then(async (userId) => {
        await service.addNewDevice(req.body, userId, 'pending_approval');
        res.send("Successfully added device "+ req.body.name);
    }).catch(err => {
        console.log(err);
        res.status(401).json(err);
    });
});

router.post('/disconnect', async (req, res) => {
    auth.validateAccess(req.headers.authorization, 'ADMIN', res).then(async () => {
        await service.disconnectDeviceById(req.body.id);
        res.send("Successfully disconnected device with id="+ req.body.id);
    }).catch(err => {
        console.log(err);
        res.status(401).json(err);
    });
});

router.delete('/:id', async (req, res) => {
    auth.validateAccess(req.headers.authorization, 'ADMIN', res).then(async () => {
        const affectedRows = await service.deleteDeviceById(req.params.id);
        res.send(affectedRows === 0 ?
            "Device with id = " + req.params.id + " did not exist"
            : "Successfully deleted device with id = " + req.params.id
        );
    }).catch(err => {
        console.log(err);
        res.status(401).json(err);
    });
});

router.post('/move', async (req, res) => {
    auth.validateAccess(req.headers.authorization, 'ADMIN', res).then(async () => {
        await service.moveDeviceById(req.body.id, req.body.toVlan);
        res.send("Successfully moved device with id=" + req.body.id + ' to VLAN with id='+req.body.toVlan);
    }).catch(err => {
        console.log(err);
        res.status(401).json(err);
    });
});

module.exports = router;