const randomString = require('crypto-random-string');
const deviceService = require('../device/deviceService');
const vlanService = require('../vlan/vlanService');

const randomIntLessThan = (upperLimit) => {
    return Math.round(Math.random()*upperLimit)
}

const randomIPAddress = () => {
    return randomIntLessThan(255) + "." +
        randomIntLessThan(255) + "." +
        randomIntLessThan(255) + "." +
        randomIntLessThan(255)
};

const randomHexDigit = () => {
    const digits = ['1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'];
    return digits[randomIntLessThan(digits.length-1)];
};

const randomMACAddress = () => {
    var result = '';
    for (var i =0; i< 5; ++i)  {
        result += randomHexDigit()+randomHexDigit()+":";
    }
    result+= randomHexDigit()+randomHexDigit();
    return result
};

const deviceOwners = [
    "Amy",
    "Bart",
    "Carla",
    "David",
    "Evelyn",
    "Uncle Frank",
    "Georgina",
    "Harry",
    "Irene",
    "Jack"
]

const deviceTypes = [
    "iPhone",
    "iPad",
    "MacBook Pro",
    "Dell Latitude",
    "Samsung Galaxy S9",
    "Kindle",
    "LG 4K TV",
    "XBox One",
    "Nintendo Switch",
    "PS4",
    "Wii",
    "Visio Smart TV",
    "Ring Doorbell",
    "Xfinity Security Camera",
    "Maytag Refrigerator",
    "Fish Tank Thermometer"
]

const randomDeviceName = () => {
    return deviceOwners[randomIntLessThan(deviceOwners.length-1)] + '\'s ' + deviceTypes[randomIntLessThan(deviceTypes.length-1)];
}

module.exports = {
    async insertRandomVlans(count, userId) {
        for (var i = 0; i<count; i++) {
            await vlanService.addNewVlan(
                {
                    name: randomString({length: 10, type: 'distinguishable'}),
                    uploadLimit: randomIntLessThan(1000),
                    downloadLimit: randomIntLessThan(1000),
                    peakUpload: randomIntLessThan(1000),
                    peakDownload: randomIntLessThan(1000)
                },
                userId
            )
        }
    },

    async insertRandomDevices(count, onVlan, userId, approved) {
        let status;
        if (approved == null || approved === false || approved === 'false'){
            status = 'pending_approval';
        }
        else {
            status = 'connected';
        }

        if (onVlan == null){
            const vlans = await vlanService.getAllVlans();
            for (var i = 0; i < count; i++) {
                await deviceService.addNewDevice(
                    {
                        name: randomDeviceName(),
                        MacAddress: randomMACAddress(),
                        IPAddress: randomIPAddress(),
                        operatingSystem: randomString({length: 10, type: 'distinguishable'}),
                        manufacturer: randomString({length: 10, type: 'distinguishable'}),
                        uploadLimit: randomIntLessThan(1000),
                        downloadLimit: randomIntLessThan(1000),
                        vlan: vlans[randomIntLessThan(vlans.length - 1)].VlanRecordIdentifier
                    },
                    userId,
                    status
                )
            }
        }
        else {
            for (var i = 0; i < count; i++) {
                await deviceService.addNewDevice(
                    {
                        name: randomDeviceName(),
                        MacAddress: randomMACAddress(),
                        IPAddress: randomIPAddress(),
                        uploadLimit: randomIntLessThan(1000),
                        downloadLimit: randomIntLessThan(1000),
                        vlan: onVlan
                    },
                    userId,
                    status
                )
            }
        }
    }
};