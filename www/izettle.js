var exec = require('cordova/exec');
var channel = require('cordova/channel');

module.exports = {

    _channels: {},
    createEvent: function(type, data) {
        var event = document.createEvent('Event');
        event.initEvent(type, false, false);
        if (data) {
            for (var i in data) {
                if (data.hasOwnProperty(i)) {
                    event[i] = data[i];
                }
            }
        }
        return event;
    },

    init_iZettle: function (apiKey, success, error) {
        exec(success, error, "iZettle", "init_iZettle", [apiKey]);
    },
        
    charge: function (amount, currency, success, error) {
        exec(success, error, "iZettle", "charge", [amount, currency]);
    },

    settings: function (success, error) {
        exec(success, error, "iZettle", "settings", null);
    },

    lastPaymentInfo: function (success, error) {
        exec(success, error, "iZettle", "lastPaymentInfo", null);
    },
                
    refundLastPayment: function (success, error) {
        exec(success, error, "iZettle", "refundLastPayment", null);
    },
                
    enforceAccount: function (email, success, error) {
        exec(success, error, "iZettle", "enforceAccount", [email]);
    },
    
};
