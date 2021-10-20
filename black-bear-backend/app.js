const express = require('express');
require('dotenv').config();
const bodyParser = require('body-parser');
const swaggerUi = require('swagger-ui-express');
const swaggerDocument = require('./swagger.json');
const cors = require('cors');

const device = require('./src/device/deviceController');
const vlan = require('./src/vlan/vlanController');
const auth = require('./src/auth/authController');
const user = require('./src/user/userController');
const randomData = require('./src/randomData/randomDataController');
const logger = require('./src/logger');
const app = express();

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cors());
app.options('*', cors());
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));


// app.use(logger);
app.use('/device', device);
app.use('/vlan', vlan);
app.use('/auth', auth);
app.use('/user', user);
app.use('/randomData', randomData);

app.listen(8000, () => {console.log("Listening on port 8000")});