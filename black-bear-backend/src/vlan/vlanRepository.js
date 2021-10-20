var db = require('mysql');
var util = require('util');

var connection = db.createConnection({
    host     : 'localhost',
    port: 13306,
    user     : 'root',
    password : 'example',
    database : 'BlackBear'
});

const query = util.promisify(connection.query).bind(connection);

module.exports = {
    async findAllVlans() {
        return await query('SELECT * FROM Vlan');
    },

    async insertNewVlan(body, userId) {
        await query('INSERT INTO Vlan SET ?', {
            VlanName: body.name,
            UploadLimitMB: body.uploadLimit,
            DownloadLimitMB: body.downloadLimit,
            PeakUploadLimitMBps: body.peakUpload,
            PeakDownloadLimitMBps: body.peakDownload,
            Creator: userId
        });
    },

    async renameVlan(name, id) {
        await query('UPDATE Vlan SET VlanName = ? where VlanRecordIdentifier = ?', [name, id]);
    },

    async findCountVlanById(id) {
        return await query('SELECT count(*) FROM Vlan WHERE VlanRecordIdentifier = ?', [id])
    },

    async removeVlan(id) {
        await query('DELETE FROM Vlan WHERE VlanRecordIdentifier = ?', [id]);
    },

    async setDefaultVlans() {
        const defaultVlans = [
            {
                VlanRecordIdentifier: 1,
                VlanName: 'Guest',
                UploadLimitMB: null,
                DownloadLimitMB: null,
                PeakUploadLimitMBps: null,
                PeakDownloadLimitMBps: null,
                Creator: null
            },
            {
                VlanRecordIdentifier: 2,
                VlanName: 'Smart Home',
                UploadLimitMB: null,
                DownloadLimitMB: null,
                PeakUploadLimitMBps: null,
                PeakDownloadLimitMBps: null,
                Creator: null
            },
            {
                VlanRecordIdentifier: 3,
                VlanName: 'Computers/Phones',
                UploadLimitMB: null,
                DownloadLimitMB: null,
                PeakUploadLimitMBps: null,
                PeakDownloadLimitMBps: null,
                Creator: null
            },
            {
                VlanRecordIdentifier: 4,
                VlanName: 'Gaming/TV',
                UploadLimitMB: null,
                DownloadLimitMB: null,
                PeakUploadLimitMBps: null,
                PeakDownloadLimitMBps: null,
                Creator: null
            }
        ]


        defaultVlans.forEach(it => {
            this.findCountVlanById(it.VlanRecordIdentifier).then(count => {
                query('DELETE FROM Vlan where VlanRecordIdentifier = ?', [it.VlanRecordIdentifier])
                    .then(() => {
                        query('INSERT INTO Vlan SET ?', [it]);
                    });
            });
        });
    }
}