var server = require("./serveur"), //appel au module
	router = require("./router"),
	http = require('http'),
	url = require('url'),
	fs = require('fs'),
	requestHandlers = require("./requestHandlers"),
	auth = require('http-auth'),
	path = require('path'),
	handle = {};

handle["/"] = requestHandlers.login;
handle["/logina"] = requestHandlers.logina;
handle["/start"] = requestHandlers.start;
handle["/reset"] = requestHandlers.reset;
handle["/stat"] = requestHandlers.stat;
handle["/maj"] = requestHandlers.maj;
handle["/show"] = requestHandlers.show;
handle["/getData"] = requestHandlers.getData;
handle["/getPerso"] = requestHandlers.getPerso;
handle["/getTaches"] = requestHandlers.getTaches;
handle["/affecter"] = requestHandlers.affecter;
handle["/supprDec"] = requestHandlers.supprDec;
handle["/createDec"] = requestHandlers.createDec;
handle["/findAffectation"]= requestHandlers.findAffectation;
handle["/getStat"]= requestHandlers.getStat;
handle["/resetPassword"]= requestHandlers.resetPassword;
handle["/confirmeReset"]= requestHandlers.confirmeReset;
//handle["/determineCSS"]= requestHandlers.determineCSS;
handle["/getInfosLogin"]= requestHandlers.getInfosLogin;
handle["/jadeTest"]= requestHandlers.jadeTest;
handle["/setState"]= requestHandlers.setState;
handle["/getLog"]= requestHandlers.getLog;
handle["/upload"]= requestHandlers.upload;
handle["/getListIncidentsVille"]= requestHandlers.getListIncidentsVille;

server.start(router.route, handle);

