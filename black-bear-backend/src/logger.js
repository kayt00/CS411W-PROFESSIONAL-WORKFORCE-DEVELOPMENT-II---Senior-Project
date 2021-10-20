const randomString = require('crypto-random-string');

const logger = (req, res, next) => {
    let nonce = randomString({length: 5, type: "numeric"});
    console.log(String(new Date().toISOString()) + " | "+ nonce + " | " + req.method + " " + req.path);

    next(req, res);

    // Promise.resolve(() => {
    //     next();
    // }).then(() => {
    //     console.log(String(new Date().toISOString()) + " | "+ nonce + " | Completed");
    // }).catch(ex => {
    //     console.log(String(new Date().toISOString()) + " | "+ nonce + " | " + ex);
    //     res.status(500).json(ex);
    // });

};

module.exports = logger;