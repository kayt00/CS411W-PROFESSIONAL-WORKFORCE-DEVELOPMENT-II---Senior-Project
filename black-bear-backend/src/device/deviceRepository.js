const db = require('mysql');
const util = require('util');

const connection = db.createConnection({
    host     : 'localhost',
    port: 13306,
    user     : 'root',
    password : 'example',
    database : 'BlackBear'
});

const query = util.promisify(connection.query).bind(connection);

module.exports = {

    async findAllDevices() {
        return await query('SELECT * FROM Device');
    },

    async findAllDevicesByStatus(status) {
        return await query('SELECT * FROM Device WHERE Status = ?', [status]);
    },

    async approveDevice(id, vlan, userId) {
        await query('UPDATE Device SET Vlan = ?, Creator = ?, Status = ? WHERE DeviceRecordIdentifier = ?', [vlan, userId, 'connected', id]);
    },

    async insertNewDevice(body, userId, status) {
        let date = new Date();
        await query('INSERT INTO Device SET ?', {
            DeviceName: body.name,
            MacAddress: body.MacAddress,
            IPAddress: body.IPAddress,
            OperatingSystem: body.operatingSystem,
            Manufacturer: body.manufacturer,
            Status: status,
            ConnectedSince: date,
            UploadLimitMB: body.uploadLimit,
            DownloadLimitMB: body.downloadLimit,
            Creator: null,
            Vlan: body.vlan
        });
    },

    async moveAllDevicesByVlan(fromVlan, toVlan) {
        await query('UPDATE Device SET Vlan = ? WHERE Vlan = ?', [toVlan, fromVlan]);
    },

    async disconnectDevicesByVlan(Vlan) {
        let date = new Date();
        await query ('UPDATE Device SET Vlan = NULL, Status = ?, ConnectedSince = NULL, LastConnected = ? WHERE Vlan = ?', ['disconnected', date, Vlan]);
    },

    async disconnectDeviceById(id) {
        var date = new Date();
        await query ('UPDATE Device SET Status = ?, ConnectedSince = NULL, LastConnected = ? WHERE DeviceRecordIdentifier = ?', ['disconnected',date, id]);
    },

    async deleteDevice(id) {
        let result = await query('DELETE FROM Device WHERE DeviceRecordIdentifier = ?', [id]);
        return result.affectedRows;
    },

    async moveDeviceById(id, toVlan) {
        await query('UPDATE Device SET Vlan = ? WHERE DeviceRecordIdentifier = ?', [toVlan, id]);
    }

}