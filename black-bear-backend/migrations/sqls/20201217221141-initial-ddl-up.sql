use BlackBear;
create table UserNotificationPreferences(
	UserNotificationPreferencesRecordIdentifier bigint NOT NULL auto_increment primary key,
    GenerateReport boolean default false,
    ShowDevicesNotResponding boolean default false,
    ShowAbnormalNetworkActivity boolean default false,
    DaysBeforeUnusedDeviceAlert int default 90,
    ShowUnusedDevices boolean default false
);

create table UserAccount(
	UserAccountRecordIdentifier bigint NOT NULL auto_increment primary key,
	FirstName varchar(20),
    LastName varchar(30),
    Username varchar(30) not null,
    Password varchar(100) not null,
    UserRole varchar(15),
    Email varchar(30),
    Phone varchar(15),
    SmsOutageAlerts boolean default false,
    WeeklySummary bigint references UserNotificationPreferences(UserNotificationPreferencesRecordIdentifier),
    MonthlySummary bigint references UserNotificationPreferences(UserNotificationPreferencesRecordIdentifier)
);

create table Vlan(
	VlanRecordIdentifier bigint NOT NULL auto_increment primary key,
    VlanName varchar(30) not null,
    UploadLimitMB bigint,
    DownloadLimitMB bigint,
    PeakUploadLimitMBps int,
    PeakDownloadLimitMBps int,
    Creator bigint references UserAccount(UserAccountRecordIdentifier),
    CreationTimestamp datetime NOT NULL default CURRENT_TIMESTAMP
);

create table Device(
	DeviceRecordIdentifier bigint NOT NULL auto_increment primary key,
    DeviceName varchar(50),
	MacAddress varchar(25),
    IPAddress varchar(16),
    Status varchar(25),
    OperatingSystem varchar(20),
    Manufacturer varchar(30),
    LastConnected date,
    ConnectedSince date,
    UploadLimitMB int,
    DownloadLimitMB int,
    Creator bigint references UserAccount(UserAccountRecordIdentifier),
    CreationTimestamp datetime NOT NULL default CURRENT_TIMESTAMP,
    Vlan bigint references Vlan(VlanRecordIdentifier)
);