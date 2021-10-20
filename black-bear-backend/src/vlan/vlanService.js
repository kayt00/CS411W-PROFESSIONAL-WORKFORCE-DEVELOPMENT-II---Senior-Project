const repository = require('./vlanRepository');
const deviceRepository = require('../device/deviceRepository');
module.exports = {

    async getAllVlans() {
        return await repository.findAllVlans();
    },

    async addNewVlan(body, userId) {
        await repository.insertNewVlan(body, userId);
    },

    async renameVlan(name, id) {
        await repository.renameVlan(name, id);
    },

    async removeVlan(body) {
        if (body.relocateDevicesTo == null) {
            await deviceRepository.disconnectDevicesByVlan(body.id);
        }
        else {
            await deviceRepository.moveAllDevicesByVlan(body.id, body.relocateDevicesTo);
        }
        await repository.removeVlan(body.id);
    },

    async setDefaultVlans() {
        await repository.setDefaultVlans();
    }
}