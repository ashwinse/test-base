'use strict';
//for checking
//see the changes
var Logger = require('bunyan');


var log = new Logger.createLogger({
    name: 'log-errors',
    streams: [
        {  level: 'info',
            stream: process.stdout
    },
    {
        level: 'error',
        path: '/my-error.log'
    }],
    serializers: { req: Logger.stdSerializers.req }
});
module.exports = {
    printInput : printInput

};


function printInput(req, res) { 
    log.info({"message" : `u have given  ${req.swagger.params.input.value}`})
    res.json({"message" : `u have given  ${req.swagger.params.input.value}`})
       
}


