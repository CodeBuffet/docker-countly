var countlyConfig = {
    mongodb: {
        host: process.env.MONGO_PORT_27017_TCP_ADDR,
        db: "countly",
        port: process.env.MONGO_PORT_27017_TCP_PORT
    },
    /*  or for a replica set
    mongodb: {
        replSetServers : [
            '192.168.3.1:27017/?auto_reconnect=true',
            '192.168.3.2:27017/?auto_reconnect=true'
        ],
        db: "countly",
    },
    */
    /*  or define as a url
    mongodb: "localhost:27017/countly?auto_reconnect=true",
    */
    web: {
        host: "localhost",
        port: 6001,
        use_intercom: true
    },
    path: "",
    cdn: ""
};

module.exports = countlyConfig;
