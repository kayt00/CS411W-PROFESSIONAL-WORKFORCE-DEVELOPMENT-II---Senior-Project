var express = require('express');
var router = express.Router();

router.get('/', function(req, res, next) {
    res.send({message: "Server is running!"});
  });


module.exports = router;