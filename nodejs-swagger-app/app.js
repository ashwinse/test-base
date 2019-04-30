'use strict';
const dotenv = require('dotenv');
dotenv.config();
var SwaggerRestify = require('swagger-restify-mw'),
    restify = require('restify');
    
var app = restify.createServer(),
port = "8089";
app.use(restify.bodyParser());
app.pre(function(req, res, next) {
    req.log.info({ req: req }, 'REQUEST');
    next();
});

var config = {
    appRoot: __dirname
  };
  
  SwaggerRestify.create(config, function(err, swaggerRestify) {
    if (err) { throw err; }
  
    swaggerRestify.register(app);    
    app.listen(port);
     if (swaggerRestify.runner.swagger.paths['/swagger']) {
      console.log('try this:\ncurl http://127.0.0.1:' + port );
    }
  });

module.exports = app; 
