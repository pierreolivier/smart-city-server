var url = require("url"),
	https = require('https');
	querystring = require("querystring"),
	port = 80,
	fs = require('fs');
	// options = {
 //  		key: fs.readFileSync('privatekey.pem'),
 //  		cert: fs.readFileSync('certificate.pem')
	// };

function start(route, handle)
{
	function onRequest(handle, request, response)
	{
		var pathname = url.parse(request.url).pathname;
		var url_parts = url.parse(request.url, true);
    	var query = url_parts.query;
    	//console.log("pathname:"+pathname+" url_parts: "+url_parts+" query: "+query);
    	//console.log("Welcome to private area - " + username + "!");
		route(handle, pathname, response, request);
	}

	// httpProxy.createServer(function(req, res, proxy) {
 //    	//digest.apply(req, res, function(username) {
 //    		// onRequest(handle, req, res);
 // 			//console.log("Welcome to private area - " + username + "!");
 //        	proxy.proxyRequest(req, res, {
 //            	host : 'localhost',
 //            	port : 8887
 //        	});
 //    	//});
	// }).listen(80);

	// http.createServer(function(req, res) {
	// 		onRequest(handle, req, res);
	// }).listen(port);

	// tests pour socket.io
	// var io = require('socket.io');
	var app = require('http').createServer(function(req, res){ 
	 	onRequest(handle, req, res);
	}).listen(port);

	/*
	var io = require("socket.io");
	var io = io.listen(app);
	io.set('log level', 1); // logs d'erreurs et warning uniquement
	io.sockets.on('connection', function (socket) {
	    socket.on('nouvelleDeclaration', function (mess) {
	        socket.broadcast.emit('newDec', mess);
	    });
	    socket.on('nouveauMedia', function (mess) {
	        socket.broadcast.emit('newMed', mess);
	    });

	});
	
*/
	// https.createServer(options, function (req, res) {
 //  		onRequest(handle, req, res);
	// }).listen(port);

	console.log("Démarrage du serveur"); //s'affiche dès le lancement su script
}
exports.start = start;
