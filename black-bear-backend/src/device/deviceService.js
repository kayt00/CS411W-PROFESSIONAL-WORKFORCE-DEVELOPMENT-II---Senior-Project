const repository = require('./deviceRepository');
const auth = require('../auth/authService');

module.exports = {

    async getAllDevices(){
        return await repository.findAllDevices();
    },

    async getAllPendingDevices() {
        return await repository.findAllDevicesByStatus('pending_approval');
    },

    async approveDevice(body, token) {
        let userId = auth.getUserIdFromToken(token);
        await repository.approveDevice(body.deviceId, body.vlan, userId);
    },

    async addNewDevice(body, userId, status){
        return await repository.insertNewDevice(body, userId, status);
    },

    async disconnectDeviceById(id) {
        await repository.disconnectDeviceById(id);
    },

    async deleteDeviceById(id) {
        return await repository.deleteDevice(id)
    },

    async moveDeviceById(id, toVlan) {
        await repository.moveDeviceById(id, toVlan);
    }

}