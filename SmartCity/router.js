var staticHandler = require('./staticHandler'),
	free_access =['/', '/reset', '/resetPassword', '/confirmeReset', '/createDec', '/maj', '/getData', '/logina', '/upload', '/getListIncidentsVille'],
	fs = require('fs'),
	auth = require('./node_modules/http-auth/lib/http-auth');

var digest = auth({
			authRealm : "realm",
			authFile : __dirname + '/digest',
			authType : 'digest'
		}); 

	fs.watchFile(__dirname + '/digest', function (curr, prev) {
		if(curr.mtime !== prev.mtime){
			digest = auth({
				authRealm : "realm",
				authFile : __dirname + '/digest',
				authType : 'digest'
			});
			console.log("fichier modifié");
		}
	});

function route(handle, pathname, response, request)
{
	console.log("Début du traitement de l'URL "+ pathname + ".");
	//vérification si c'est une fonction ou pas
	if (typeof handle[pathname] === 'function'){		
	    for (var i=0, len=free_access.length; i<len;i++){
			if (pathname == free_access[i]){
				//une fonction non protégée a été appelée
				return handle[pathname](response, request);
			}
		}	
		//une fonction protégée a été demandée
		digest.apply(request, response, function(username) {
			console.log("Welcome to private area - " + username + "!");
			return handle[pathname](response, request);
		});
	}
	else {
		//un fichier statique est demandé
		staticHandler.handleStatic(pathname, response);
  	}
}
exports.route = route;
