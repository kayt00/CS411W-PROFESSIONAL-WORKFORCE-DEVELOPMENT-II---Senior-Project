const repository = require('./userRepository');

module.exports = {
    async getUserProfile(id) {
        let profile = await repository.fetchUserProfileById(id);
        if (profile.length === 1){
            return profile[0];
        }
        else return null;
    },

    async getAllUsers() {
        return await repository.fetchAllUsers();
    },

    async adminExists() {
        const admins = await repository.fetchUsersByRole('ADMIN');
        return admins.length > 0
    }
};