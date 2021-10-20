const express = require('express');
const router = express.Router();
const auth = require('../auth/authService');
const service = require('./randomDataService');

router.post('/addRandomVlans/:numberOfVlans', async (req, res) => {
    auth.validateAccess(req.headers.authorization, 'STANDARD', res).then(async (userId) => {
        if (req.params.numberOfVlans == null){
            res.status(400).json({message: "Request must include desired number of VLANs"});
        }
        else {
            await service.insertRandomVlans(req.params.numberOfVlans, userId);
            res.status(200).json({message: "Successfully inserted " + req.params.numberOfVlans + " VLANS"});
        }
    }).catch(err => {
        console.log(err);
        res.status(401).json(err);
    });
});

router.post('/addRandomDevices/:numberOfDevices', async (req, res) => {
    auth.validateAccess(req.headers.authorization, 'STANDARD', res).then(async (userId) => {
        if (req.params.numberOfDevices == null) {
            res.status(400).json({message: "Request must include desired number of devices"});
        }
        else {
            await service.insertRandomDevices(req.params.numberOfDevices, req.query.onVlan, userId, req.query.approved);
            res.status(200).json({message: "Successfully inserted "+req.params.numberOfDevices + " Devices"});
        }
    }).catch(err => {
        console.log(err);
        res.status(401).json(err);
    });
});

module.exports = router;