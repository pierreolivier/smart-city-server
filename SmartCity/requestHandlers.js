var fs = require('fs'),
	//formidable = require("./node_modules/formidable"),
	qs = require("./node_modules/querystring"),
	url = require("./node_modules/url"),
	pg = require("./node_modules/pg"),
	util = require('util'),
	http = require('http'),
	seq = require("seq"),
	passReset =[],
	sha1 = require('sha1'),
	sys = require('sys'),
	crypto = require('crypto'),
	exec = require('child_process').exec,
	program = require('commander'),
	md5 = require('MD5'),
	io = require('socket.io-client'),
	multipart = require('multipart'),
	infos_login = {},
	user_db = 'eric'
	port = 81,
	//domain = '127.0.0.1'
	domain = 'pierreolivier.me'
	QueryBuilder = require('datatable'),


//Fonction interne: A partir de la reqête du client, on détermine son login
function getLogin(request){
	try{
		var	authorization = request.headers.authorization,
  			prelogin = authorization.substring(authorization.indexOf('"')+1);
  		return prelogin.substring(0,prelogin.indexOf('"'));
 	}
 	catch(error){
 		return null;
 	}

}

//Fonction externe: renvoi au client son login
function getLog(response, request){
	//response.end(getLogin(request));
}


//Renvoi les déclarations d'incidents
function maj(response, request){
	//console.log("Le gestionnaire 'maj' est appelé.");
	var url_parts = url.parse(request.url, true),
    	query = url_parts.query,		
	con ="postgres://smart:smart@localhost/postgres",
		rows = [],
		myArray = [],
		client = new pg.Client(con),
		bool = false;
	client.connect();

	req = "SELECT * from declaration d, incidents i, personnel p WHERE d.longitude BETWEEN "+query.minlng+" AND "+query.maxlng+" AND d.latitude BETWEEN "+query.minlat+" AND "+query.maxlat+" AND d.etat & B'"+query.etat+"'=d.etat AND i.id_type = d.type";
		
	console.log(req);  
		var query = client.query(req);

		//exécution de la requête 
		query.on('row', function(row, result) {
				rows.push(row);
				result.addRow(row);
		    	console.log(row);	
		});

		//traitement des résultats 
		query.on('end', function(result) { 
			//console.log(result.rows.length + ' lignes reçues');
			for (i=0;i<rows.length;i++) {
				//console.log(rows[i]);
				myArray.push({"gid":rows[i].gid,
								"lon":rows[i].longitude,
								"lat":rows[i].latitude,
								"etat":rows[i].etat,
								"type": rows[i].intitule,
								"date":rows[i].date_dec,
								"adr":rows[i].adresse,
								"photo":rows[i].photo,
								"texte": rows[i].texte
				});
		  	}
		  	myArray.join(',');
		  	client.end();
		  	response.writeHead(200, {"Content-Type": "application/json",  'Access-Control-Allow-Origin': '*',
             'Access-Control-Allow-Credentials': 'true'})
	      	response.end(JSON.stringify(myArray));	 
		});
	
}

//permet de changer l'état d'un incident via le tableau
function setEtat(response, gid, value){
	console.log("setEtat");
	var con ="postgres://"+user_db+":cire@"+domain+":5432/postgres";
	var client = new pg.Client(con);
	client.connect();
	var DATE = new Date(),
		day = DATE.getDate(),
		month = DATE.getMonth()+1,
		year = DATE.getFullYear(),
		date = day+"/"+month+"/"+year;
	if (value === '1'){
		var etat = '001';
		var req = "UPDATE declaration SET etat='"+etat+"' WHERE gid="+gid
	}
	else if (value === '10'){
		var etat = '010';
		var req = "UPDATE declaration SET etat='"+etat+"', date_priseencharge ='"+date+"' WHERE gid="+gid;
	}
	else if (value === '100'){
		var etat = '100';
		var req = "UPDATE declaration SET etat='"+etat+"',date_fin ='"+date+"' WHERE gid="+gid;
	}
	if (etat && req){
		console.log(req);  
		var query = client.query(req);
		
		//exécution de la requête 
		query.on('row', function(row, result) {
		});  

		//traitement des résultats 
		query.on('end', function(result) { 
			client.end();
			response.end();
		});
	}
	else{
		console.log("etat "+ etat);
		client.end();
		response.end();
	}
}
////////////////// il faut récupérer le login avant, version sans utilisation du portail
function setState(response, request){
	var con ="postgres://"+user_db+":cire@"+domain+":5432/postgres",
		client = new pg.Client(con),
		data = "",
		DATE = new Date(),
		day = DATE.getDate(),
		month = DATE.getMonth()+1,
		year = DATE.getFullYear(),
		date = day+"/"+month+"/"+year;	
	
    request.on("data", function(chunk) {
        data += chunk;
    });

    request.on("end", function() {
        var json = qs.parse(data);
        // var parse = JSON.stringify(json);
        if (value === '1'){
			var etat = '001';
			var req = "UPDATE declaration SET etat='"+json.etat+"' WHERE gid="+json.gid
		}
		else if (value === '10'){
			var etat = '010';
			var req = "UPDATE declaration SET etat='"+json.etat+"', date_priseencharge ='"+date+"'' WHERE gid="+json.gid;
		}
		else if (value === '100'){
			var etat = '100';
			var req = "UPDATE declaration SET etat='"+json.etat+"', date_fin ='"+date+"' WHERE gid="+json.gid;
		}
        if (req && etat){
			console.log(req);  
			var query = client.query(req);

			//exécution de la requête 
			query.on('row', function(row, result) {
			});  

			//traitement des résultats 
			query.on('end', function(result) {
				client.end();
				response.end();
        	});
        }
        else
        	response.end();
        	
    });
}

// A partir du login, récupère l'identifiant d'agent associé
function getInfosLogin(login, response){
  	var con ="postgres://"+user_db+":cire@"+domain+":5432/postgres";
	var client = new pg.Client(con);
	var rows = [];
	client.connect();
	
	req = "SELECT v.nom, p.idpers, p.role, p.idville FROM personnel p, ville v where login='"+login+"' AND v.idville = p.idville";
	console.log(req);  
	var query = client.query(req);

	//exécution de la requête 
	query.on('row', function(row, result) {
		rows.push(row);
		console.log("le res: "+rows);
		result.addRow(row);
	});  

	//traitement des résultats 
	query.on('end', function(result) { 
		console.log(rows[0]);
		infos_login[login+'.id'] = rows[0].idpers;	
		infos_login[login+'.role'] = rows[0].role;	
		infos_login[login+'.ville'] = rows[0].idville;	
		console.log("Ville "+rows[0].idville);
		console.log("Rôle "+rows[0].role);
		client.end();
		if(infos_login[login+'.id'] !== undefined){
			console.log("Login enregistré");
			//on utilise une seule fois la ville associée, donc pas de stockage
			affichagePageVille(rows[0].nom,response);
		}
	});
}

/* fonction à appeler pour afficher la page associée à la ville du login */
function start(response, request){
	affichagePageVille('Lux',response);
  	//var login = getLogin(request);
  	//getInfosLogin(login, response);		
  	//getInfosLogin(getLogin(request), response);	
}

function affichagePageVille(ville, response){
	var page ='';
	if (ville == 'all')
		var page = './index.html';
	else
		var page = './html/'+ville+'.html';

	fs.readFile(page,function(error,content){
		if (error) {
			console.log("La page n'existe pas");
			response.writeHead(500);
			response.end("pas de bol"+ville);
		}
		else {
			//console.log("La page existe");
			response.writeHead(200, {"Content-Type":"text/html"});
			response.end(content, 'utf-8');
		}
	});
}

/* Affiche la page login2.html, il faut rediriger par défaut à cette fonction lors du lancement*/
function login(response, request){
	//console.log("Le gestionnaire 'login' est appelé.");
	fs.readFile('./login.html',function(error,content){
		if (error) {
			console.log("La page n'existe pas");
			response.writeHead(500);
			response.end("pas de bol");
		}
		else {
			//console.log("La page existe");
			response.writeHead(200, {"Content-Type":"text/html"});
			response.end(content, 'utf-8');
		}
	});
}

/* Permet d'afficher la page reset.html pour reseter pour le mdp */
function reset(response, request){
	//console.log("Le gestionnaire 'login' est appelé.");
	fs.readFile('./reset.html',function(error,content){
		if (error) {
			console.log("La page n'existe pas");
			response.writeHead(500);
			response.end("pas de bol");
		}
		else {
			//console.log("La page existe");
			response.writeHead(200, {"Content-Type":"text/html"});
			response.end(content, 'utf-8');
		}
	});
}

/* Affiche la page stat.html pour avoir des stats */
function stat(response, request){
	//console.log("Le gestionnaire 'leaflet' est appelé.");
	fs.readFile('./stat.html',function(error,content){
		if (error) {
			console.log("La page n'existe pas");
			response.writeHead(500);
			response.end("pas de bol");
		}
		else {
			//console.log("La page existe");
			response.writeHead(200, {"Content-Type":"text/html"});
			response.end(content, 'utf-8');
		}
	});
}

/* fonction qui permet d'obtenir les informations associées à la déclaration sélectionnée */
function getData(response, request){
	try{
		//console.log("Le gestionnaire 'getData' est appelé.");
		var url_parts = url.parse(request.url, true),
	         query_from_url = url_parts.query,
			 con ="postgres://"+user_db+":cire@"+domain+":5432/postgres",
			 rows = [],
			 text = new String(),
			 client = new pg.Client(con),
			 bool2 = false,
			 req;
			 //login = getLogin(request);
		
		//si infos_login[login.role] == 'admin', alors on est admin, et on accès à toutes les données
		// n'est plus utilisé par les agents de la ville
		console.log(query_from_url);
		if (query_from_url.login && query_from_url.mdp){
			bool2 = true;
			console.log("application");
			req = "SELECT * FROM declaration d, incidents i WHERE d.gid ="+query_from_url.gid+" AND i.id_type = d.type";
		}
		else if(infos_login[getLogin(request)+'.role'] == 'admin'){
			bool2 = true;
			console.log("admin");
			req = "SELECT * FROM declaration d, incidents i WHERE d.gid ="+query_from_url.gid+" AND i.id_type = d.type AND d.idville ="+infos_login[getLogin(request)+'.ville'];
		}
		else if (infos_login[getLogin(request)+'.id'] !== undefined ){
			bool2 = true;
			console.log("portail");
			req = "SELECT * FROM declaration d, incidents i WHERE d.gid ="+query_from_url.gid+" AND d.persaffectee="+infos_login[getLogin(request)+'.id']+" AND i.id_type = d.type";
		}

		if (bool2){
			console.log(req); 
			client.connect();
			var query = client.query(req);
			//exécution de la requête 
			query.on('row', function(row, result) {
				rows.push(row);
				result.addRow(row);
			    //console.log(row);
			});
			//traitement des résultats 
			query.on('end', function(result) {
				if (rows.length !==0){
					text += '{"type":'+'"'+rows[0].intitule+'"'+
					',"texte":'+'"'+rows[0].texte+'"';
					if (rows[0].photo !== '' && rows[0].photo !== null){
						text += ',"photo":'+'"'+rows[0].photo+'"';
					}
					if (infos_login[getLogin(request)+'.id'] !== undefined){
						text += ',"persaffectee":'+'"'+rows[0].persaffectee+'"';
		            }
		            text += ',"idcitoyen":'+'"'+rows[0].idcitoyen+'"'+
		            ',"nb_notifications":'+'"'+rows[0].nb_notifications+'"';
		            if(rows[0].etat === '001'){
		            	text += ',"etat":'+'"A traiter"';
		            }
		            else if(rows[0].etat === '010'){
		            	text += ',"etat":'+'"En cours de traitement"';
		            }
		            else
		            	text += ',"etat":'+'"Incident résolu"';	
					text +=',"gid":'+'"'+rows[0].gid+'"'+
					',"date":'+'"'+rows[0].date_dec+'"'+
					',"adr":'+'"'+rows[0].adresse+
					'"}'+ '\n';

				  	// text sera au format JSON
				  	client.end();
				  	response.writeHead(200, {"Content-Type": "application/json", 'Access-Control-Allow-Origin': '*',
		         'Access-Control-Allow-Credentials': 'true'})
				  	response.end(text);
					//response.end(JSON.stringify(myArray1));
				}
				else{
					response.writeHead(200, {"Content-Type": "text/html", 'Access-Control-Allow-Origin': '*',
		         'Access-Control-Allow-Credentials': 'true'})
				  	response.end('rien pour toi');
				}
			});
		}
		else{
			response.writeHead(404);
			response.end();
		}
	}
	catch(error){
		console.log(error);
	}
}

/* Permet d'obtenir la liste des différentes agents de la ville */
function getPerso(response, request){
	try{
		//console.log("Le gestionnaire 'getPerso' est appelé.");
		var login = getLogin(request);
		var url_parts = url.parse(request.url, true);
	    var query = url_parts.query;
		
		var con ="postgres://"+user_db+":cire@"+domain+":5432/postgres";
		var rows = [];
		var myArray = [];
		var client = new pg.Client(con);
		client.connect();
		
		//req = "SELECT idpers, nom, prenom FROM personnel WHERE idville ="+infos_login[login];
		req = "SELECT idpers, nom, prenom FROM personnel";
		//console.log(req);  
		var query = client.query(req);

		//exécution de la requête 
		query.on('row', function(row, result) {
			rows.push(row);
			result.addRow(row);
		    //console.log(row);
		});  

		//traitement des résultats 
		query.on('end', function(result) { 
			var text = "{";
			//console.log(result.rows.length + ' lignes reçues');
			for (i=0;i<rows.length;i++) {
				text += '"'+rows[i].idpers+'":'+'"'+rows[i].prenom + ' ' + rows[i].nom+'",';
				// myArray.push({'1': rows[i].prenom + ' ' + rows[i].nom
				// 				// "nom":rows[i].nom,
				// 				// "prenom":rows[i].prenom
				// });
		  	}
		  	text = text.substring(0,text.lastIndexOf(','));
		  	text += "}";
		  	//myArray.join(',');
		  	client.end();
		  	response.writeHead(200, {"Content-Type": "application/json"})
		  	response.end(text);
		});
	}
	catch(error){
		console.log(error);
	}
}

// n'est plus utilisé
/* fonction qui permet d'obtenir la liste des taches non terminées */
function getTaches(response, request){
	try{
		//console.log("Le gestionnaire 'getTaches' est appelé.");
		var url_parts = url.parse(request.url, true),
	    	query = url_parts.query,
			con ="postgres://"+user_db+":cire@"+domain+":5432/postgres",
			rows = [],
			myArray =[],
			client = new pg.Client(con),
			login = getLogin(request);
		client.connect();
		
		//demande des éléments compris dans la zone de l'objet
		//req = "SELECT ST_X(the_geom), ST_Y(the_geom), name, date from pop_pts WHERE ST_MakeEnvelope("+query.minlng+","+query.minlat+","+query.maxlng+","+query.maxlat+",4326) && the_geom AND date > DATE "+"'"+query.dd+"'"+ " AND date < DATE "+"'"+query.df+"'";
		if(login !== undefined){
			if (infos_login[login+'.role'] =='admin'){
				console.log("admin");
				req = "SELECT gid, date_dec from declaration WHERE (etat = B'010' OR etat = B'001') AND idville ="+infos_login[login+'.ville'];
			}
			else{
				console.log("pas admin");
				req = "SELECT gid, date_dec from declaration WHERE (etat = B'010' OR etat = B'001') AND persaffectee="+infos_login[login+'.id'];
			}
			console.log(req);  
			var query = client.query(req);

			//exécution de la requête 
			query.on('row', function(row, result) {
					rows.push(row);
					result.addRow(row);
			    	//console.log(row);	
			});  

			//traitement des résultats 
			query.on('end', function(result) { 
			
				//console.log(result.rows.length + ' lignes reçues');
				for (i=0;i<rows.length;i++) {

					// formatage nécessaire pour paraître comme du json
		 			//text += '{"name":'  +  '"' +  rows[i].name + '"'  + ',"date":' + '"' +  rows[i].date + '"' +  ',"lon":' + '"' +  rows[i].st_x + '"' +  ',"lat":' +  '"' +  rows[i].st_y  + '"}'+ '\n'+ ',';
		 			myArray.push({"gid": rows[i].gid,
		 						  "date_dec": rows[i].date_dec
		 						});
			  	}
		        
		        myArray.join(',');
			  	client.end();
			  	response.writeHead(200, {"Content-Type": "application/json"})
			  	response.end(JSON.stringify(myArray));
			});
		}
	}
	catch(error){
		console.log(error);
	}
}

// en cas de mauvaise affectation, permet d'affecter une déclaration à quelqu'un d'autre
function affecter(response, gid, pers){
	var	con ="postgres://"+user_db+":cire@"+domain+":5432/postgres",
		client = new pg.Client(con);
	client.connect();
	
	req = "UPDATE declaration SET persaffectee="+pers+" WHERE gid="+gid;  
	var query = client.query(req);

	//exécution de la requête 
	query.on('row', function(row, result) {
	});  

	//traitement des résultats 
	query.on('end', function(result){
		client.end();
		response.end();
	});
}

// en cas de mauvaise affectation, permet d'affecter une déclaration à quelqu'un d'autre
function setResp(response, request){
	var url_parts = url.parse(request.url, true),
    	query = url_parts.query,
		con ="postgres://"+user_db+":cire@"+domain+":5432/postgres",
		client = new pg.Client(con);
		login = getLogin(request);
	client.connect();
	
	//il faut récuper la ville associée au login, mais il faut faire une requete avant, donc script pgsql
	//where p.idville = d.id_ville AND p.login = login
	req = "UPDATE declaration SET persaffectee="+pers+" WHERE gid="+gid;  
	var query = client.query(req);

	//exécution de la requête 
	query.on('row', function(row, result) {
	});  

	//traitement des résultats 
	query.on('end', function(result){
		client.end();
		response.end();
	});
}

//ici aussi il faut vérifier les infos du login
// en cas de mauvaise choix du type, permet de le modifier
function setType(response, gid, type){
	var	con ="postgres://"+user_db+":cire@"+domain+":5432/postgres",
		client = new pg.Client(con);
	client.connect();
	
	req = "UPDATE declaration SET type="+type+" WHERE gid="+gid;  
	var query = client.query(req);

	//exécution de la requête 
	query.on('row', function(row, result) {
	});  

	//traitement des résultats 
	query.on('end', function(result){
		client.end();
		response.end();
	});
}

function logina(response, request){
	console.log("Le gestionnaire 'login' est appelé.");
	var url_parts = url.parse(request.url, true),
    	query = url_parts.query,
		con ="postgres://"+user_db+":cire@"+domain+":5432/postgres",
		client = new pg.Client(con),
		myArray =[];
	client.connect();
	
	//demande des éléments compris dans la zone de l'objet
	req = "SELECT * FROM citoyens WHERE login='"+query.login+"' AND mdp='"+query.mdp+"'";		    
	console.log(req);  
	var query = client.query(req);
	var rows = [];

	//exécution de la requête 
	query.on('row', function(row, result) {
			rows.push(row);
			result.addRow(row);
	    	console.log(row);	
	});  

	//traitement des résultats 
	query.on('end', function(result){
		if (rows.length !=1) {
			console.log("erreur");
			// myArray.push({"id_citoyen": false});
			client.end();
			response.writeHead(200, {"Content-Type": "text/html", 'Access-Control-Allow-Origin': '*',
         'Access-Control-Allow-Credentials': 'true'});
	  		response.end('false','utf-8');
	  	}
	  	else {
	  		for (i=0;i<rows.length;i++) {
				// formatage nécessaire pour paraître comme du json
 				//text += '{"name":'  +  '"' +  rows[i].name + '"'  + ',"date":' + '"' +  rows[i].date + '"' +  ',"lon":' + '"' +  rows[i].st_x + '"' +  ',"lat":' +  '"' +  rows[i].st_y  + '"}'+ '\n'+ ',';
 				myArray.push({"id_citoyen": rows[i].id_citoyen});
	  		}
	        myArray.join(',');
		  	client.end();
        	response.writeHead(200, {"Content-Type": "application/json", 'Access-Control-Allow-Origin': '*',
         'Access-Control-Allow-Credentials': 'true'})
		  	response.end(JSON.stringify(myArray),'utf-8');
	  		//response.end(JSON.stringify({url: 'http://"+domain+":8887'}), 'utf-8');
	  	}	
	});
}

// Permet de supprimer l'ensemble d'une déclaration
function supprDec(response, request){
	console.log("Le gestionnaire 'supprDec' est appelé.");
	var url_parts = url.parse(request.url, true),
    	query = url_parts.query,
		con ="postgres://"+user_db+":cire@"+domain+":5432/postgres",
		rows = [],
		client = new pg.Client(con),
		login = getLogin(request);
	client.connect();
	
	if (infos_login[login+'.role'] =='admin')
		req = "DELETE FROM declaration WHERE gid="+query.id+"AND idville ="+infos_login[login+'.ville'];
	else
		req ="DELETE FROM declaration WHERE gid="+query.id+"AND persaffectee ="+infos_login[login+'.id'];
	console.log(req);  
	var query = client.query(req);

	//exécution de la requête 
	query.on('row', function(row, result) {
			rows.push(row);
			result.addRow(row);
	    	console.log(row);	
	});  

	//traitement des résultats 
	query.on('end', function(result){
		client.end();
	  	response.end();
	});
}

// vérification des types, mais pas suffisant
function verifParamCreateDec(lat, long, texte, type, gid){
	return (is_num(parseInt(type)) && is_str(texte) && is_num(parseFloat(long)) && is_num(parseFloat(lat)) && is_num(parseInt(gid)));
}

//Permet de vérifier si le param est un nombre
function is_num(value){
	return (typeof value == 'number' && !isNaN(value)) ;
}

function is_str(value){
	return typeof value == 'string';
}

//Récolte un ensemble de données stockées dans la bd pour l'affichage des statistiques
function getStat(response, request){
	console.log("Le gestionnaire 'getStat' est appelé.");
	var url_parts = url.parse(request.url, true),
    	query = url_parts.query,
		con ="postgres://"+user_db+":cire@"+domain+":5432/postgres",
		rows = [],
		myArray = [],
		client = new pg.Client(con);
	client.connect();
	
	//demande des éléments compris dans la zone de l'objet
	//query.type => type de diagramme => type de requete
	//if (query.type === "pie"){}
	//else if (query.type === "chart"){}	
	req = "SELECT count(*), etat from declaration WHERE date_dec > DATE "+"'"+query.dd+"'"+ " AND date_fin < DATE "+"'"+query.df+"'"+"GROUP BY etat";	
	//req ="SELECT nom_canton FROM nantes where ST_contains(geom,ST_GeomFromText('POINT("+query.lon+" "+query.lat+")',4326))=true";
	console.log(req);  
	var query = client.query(req);

	//exécution de la requête 
	query.on('row', function(row, result) {
			rows.push(row);
			result.addRow(row);
	    	console.log(row);	
	});  

	//traitement des résultats 
	query.on('end', function(result) { 
	
		console.log(result.rows.length + ' lignes reçues');
		for (i=0;i<rows.length;i++) {
			// formatage nécessaire pour paraître comme du json
 			myArray.push({"nb": rows[i].count,
 							"etat": rows[i].etat
 				});
	  	}
        
        myArray.join(',');
	  	client.end();
	  	response.writeHead(200, {"Content-Type": "application/json"})
	  	response.end(JSON.stringify(myArray));
	});
}

//permet d'effectuer une commande système exemple: exec("ls -la", puts);
function puts(error, stdout, stderr) { sys.puts(stdout) }

//modifie le mot de passe dans le fichier
//si il y a un doublon en fin de fichier, il ne sera pas supprimé
function modifPass(file, username, realm, password){

	try {
			var newLine = username + ":" + realm + ":" + password;
				//md5(username + ":" + realm + ":" + password);	
			var writeData = "";
				
			if(this.createFile) {
				fs.openSync(file, "w");
				writeData = "\n" + newLine;				
			} else {
				
				writeData = fs.readFileSync(file, "UTF-8")
				var indexID = writeData.indexOf(username);
				if(indexID !==-1){
					var debut_debID = writeData.substring(0,indexID);
					var premier_saut_ligne_apres_id = writeData.substring(indexID);
					var fin = premier_saut_ligne_apres_id.substring(premier_saut_ligne_apres_id.indexOf("\n")+1);
					writeData = debut_debID+fin;
					console.log("Login existe deja: "+indexID);
				}
				writeData += "\n" + newLine;	
			}
			
			if(writeData.indexOf("\n") == 0) {
				writeData = writeData.substr(1, writeData.length - 1);
			}
			// Writes data to file.
			fs.writeFileSync(file, writeData, "UTF-8");
		} catch(error) {
			console.log(error);
		}
}

//Vérifie qu'il y a bien eu une demande de réinitialisation de mot de passe et le réinitialise
function confirmeReset(response, request){

	console.log("Le gestionnaire 'confirmeReset' est appelé.");
	var url_parts = url.parse(request.url, true),
    	query = url_parts.query,
    	bool = false;

	for (var i=0, len=passReset.length; i<len && !bool;i++) {
		// Vérification des paramètres reçus
		if (passReset[i].login === query.id && passReset[i].key === query.key){
			console.log("C'est bon, le mdp est réinitialisé");
			bool = true;
			response.writeHead(200, {"Content-Type": "text/html; charset=utf-8"});
	  		response.end("Félicitations, votre mot de passe vient d'être réinitialisé<br /> <a href='http://"+domain+"'>Retour Acceuil</a>");
	  		//modification dans le fichier digest du mot de passe
	  		modifPass("./digest",passReset[i].login,"realm",passReset[i].mdp);
	  		passReset.pop(i);
		} 
  	}
  	if (!bool){
  		response.writeHead(200, {"Content-Type": "text/html; charset=utf-8"});
	  	response.end("Mot de passe déjà activé, sinon recommencez la procédure<br /><a href='http://"+domain+"'>Retour Acceuil</a>");
  	}
}

//Si l'id existe on renvoie l'email associé
function resetPassword(response, request){

	var email 	= require("./node_modules/emailjs/email");
	var server 	= email.server.connect({
	   user:	""+user_db+"", 
	   password:"", 
	   host:	"smtp.gmail.com", 
	   ssl:		true
	});

	console.log("Le gestionnaire 'resetPassword' est appelé.");
	var url_parts = url.parse(request.url, true),
    	query = url_parts.query,
		con ="postgres://"+user_db+":cire@"+domain+":5432/postgres",
		rows = [],
		client = new pg.Client(con);
	client.connect();

	req = "SELECT email from personnel WHERE login="+"'"+query.login+"'";
	var id = query.login;

	console.log(id);
	//mot de passe sha1 intact
	var mdp = query.mdp;
	//mot de passe sha1 modifié 
	var key = sha1(mdp+new Date().getTime());	
	//console.log(req);  
	var query = client.query(req);

	//exec("ls -la", puts);

	//exécution de la requête 
	query.on('row', function(row, result) {
			rows.push(row);
			result.addRow(row);
	    	//console.log(row);	
	});  

	//traitement des résultats 
	query.on('end', function(result) { 
		//console.log(result.rows.length + ' lignes reçues');
		if (rows.length !== 1){
			response.writeHead(200, {"Content-Type": "application/json"});
	  		response.end(JSON.stringify({"email": "null"}));
		}
		else{
 			passReset.push({ mdp: mdp, login: id, key: key});
 			passReset.join(',');
 			response.writeHead(200, {"Content-Type": "application/json"});
	  		response.end(JSON.stringify({"email": "notnull"}));
	  		var message	= {
			   text:	"i hope this works", 
			   from:	"", 
			   to:		"<"+rows[0].courriel+">",
			   cc:		"",
			   subject:	"Réinitialisation de mot de passe",
			   attachment: 
			   [
			      {data:"<html>Bonjour, nous avons reçu une demande de réinitialisation de votre mot de passe, si vous êtes bien l'auteur de cette demande, cliquez sur le lien suivant:<a href=http://"+domain+"/confirmeReset?id="+id+"&key="+key+">lien</a><br />Sinon, ignorez ce message</html>", alternative:true}
			      //{path:"./tchat.zip", type:"application/zip", name:"renamed.zip"}
			   ]
			};
 			server.send(message, function(err, message) { console.log(err || message); });
 			console.log("http://"+domain+":80/confirmeReset?id="+id+"&key="+key);
 			//modifPass("./digest",id,"realm",mdp);
 			//modifPass("./digest","username","realm","pass");
	  	}
       	passReset.join(',');
       	//console.log(passReset);
	  	client.end();
	});
}

/*
 * Create multipart parser to parse given request
 */
function parse_multipart(req) {
    var parser = multipart.parser();

    // Des infos dans les headers
    parser.headers = req.headers;

    // Dès que l'on a des données, on les parse
    req.addListener("data", function(chunk) {
        parser.write(chunk);
    });

    req.addListener("end", function() {
        parser.close();
    });

    return parser;
}

//Permet l'upload de médias
function upload(res, req) {
    // La requête est du binaire
    req.setEncoding("binary");

    // On récupère tout le contenu
    var stream = parse_multipart(req);
    //console.log(stream);

    var fileName = null;
    var fileStream = null;
    var sizeUploaded = 0;
    
    // pour empecher une réécriture de la variable gid
    var boolGid = false;
    var gid;
    var ext;
    var name;

    //parcours le stream, certaines informations peuvent être présentes puis disparaitre
    stream.onPartBegin = function(part) {
    	try{
    		if(!boolGid){
    			boolGid = true;
    			var buffer = stream.part.parent.buffer;
    			gid = buffer.substring(0,buffer.indexOf('-'));
    		}
    	}
    	catch(error){
    		console.log(error);
    	}
    	

        sys.debug("Started part, name = " + part.name + ", filename = " + part.filename);
        
        // Contruit le chemin
        fileName = "./uploads/" + stream.part.filename;
        if (stream.part.filename !== undefined){
        	name = stream.part.filename;
        	//pour déterminer le type de média
        	ext = stream.part.filename.substring(stream.part.filename.indexOf('.')+1);
        }
        
        // Construction d'un descripteur de fichier pour écriture sur disque
        fileStream = fs.createWriteStream(fileName);

        // Gestion des erreurs
        fileStream.on("error", function(err) {
            sys.debug("Erreur lors de l'écriture de '" + fileName + "': ", err);
        });

        // Pour que les données en attentes d'écritures soit écrites
        fileStream.on("drain", function() {
            req.resume();
        });
    };

    // Dès que l'on recoit des données
    stream.onData = function(chunk) {
        // Il peut être utile de mettre en pause l'écriture des données, car lues plus vites qu'elles ne sont écrites
        // Je trouve que ca marche mieux sans cela, l'écriture peut rester bloquée
        //req.pause();

        sys.debug("Ecriture");

      	//ecriture sur le disque
        fileStream.write(chunk, "binary");
    };

    // Set handler for request completed
    stream.onEnd = function() {

    	console.log(gid);
        // As this is after request completed, all writes should have been queued by now
        // So following callback will be executed after all the data is written out
        upload_complete(res,gid,ext,name);
        fileStream.addListener("drain", function() {
            // Close file stream
            fileStream.end();
            // Handle request completion, as all chunks were already written
            
        });
    };
}

function upload_complete(res,gid,ext,name) {
	console.log("upload_complete!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
	if (is_num(parseInt(gid))){

		var con ="postgres://"+user_db+":cire@"+domain+":5432/postgres",
			rows =[];
			myArray = [],
			req = "",
			val = "nextval('photos_idphoto_seq'::regclass)";
			client = new pg.Client(con);
		client.connect();
		console.log(ext);
		if (ext === 'png' || ext === 'jpg'){
			req ="UPDATE \"public\".\"declaration\" SET photo='"+name+"' WHERE gid="+gid;
		}
		console.log(req);  
		var query = client.query(req);
		//exécution de la requête 
		query.on('row', function(row, result) {
				rows.push(row);
				result.addRow(row);	
				//console.log(row);
		});  

		//traitement des résultats 
		query.on('end', function(result){
			res.end();
	  	});
	    sys.debug("Request complete");
	    var socket = io.connect('http://'+domain+':'+port);	
		socket.emit('nouveauMedia',gid);
	    //res.writeHead(200, {"Content-Type": "text/plain", 'Access-Control-Allow-Origin': '*', 'Access-Control-Allow-Credentials': 'true'});
	    //res.write("Thanks for playing!");
	    sys.puts("\n=> Done");
	}
}

//service nécessaire à la création d'une déclaration
/* fonction qui permet d'obtenir les informations associées à la déclaration sélectionnée */
function createDec(response, request){
	console.log("Le gestionnaire 'createDec' est appelé.");
	var url_parts = url.parse(request.url, true),
         query_from_url = url_parts.query,
		 con ="postgres://"+user_db+":cire@"+domain+":5432/postgres",
		 rows1 =[],
		 rows2 = [],
		 rows3 = [],
		 myArray = [],
		 client1 = new pg.Client(con),
		 client2 = new pg.Client(con),
		 client3 = new pg.Client(con);
	client1.connect();
	
	 
    //trouve la zone de l'incident
	var findZone = function(){
		try{
			if(query_from_url.lat !== undefined && query_from_url.lon !== undefined){
				req ="SELECT nom_canton, gid, ST_contains(geom,ST_GeomFromText('POINT("+ query_from_url.lat+" "+ query_from_url.lon+")',4326)) from cantons";
				console.log(req);  
				var query = client1.query(req);
				//exécution de la requête 
				query.on('row', function(row, result) {
						rows1.push(row);
						result.addRow(row);	
						//console.log(row);
				});  

				//traitement des résultats 
				query.on('end', function(result){
					console.log(result.rows.length + ' lignes reçues');
					for (i=0,len=rows1.length;i<len;i++) {
						if(rows1[i].st_contains == true){
		 					myArray.push({"nom_canton": rows1[i].nom_canton,
		 									    "gid" : rows1[i].gid
		 								});
		 					console.log("nom_canton: "+rows1[i].nom_canton + " st_contains:"+ rows1[i].st_contains);
		 				}
			  		}
				  	client1.end();
				  	findResp();
				});
			}
			else
				response.end();
		}
		catch(error){
			console.log(error);
		}
	}
	//trouve la personne dédiée à cette zone et type d'incident
	var findResp = function(){
		try{
			console.log("dans requ2()");
			if (rows1.length == 1){
				console.log("personne n'est affecté");
				response.end();
			}
		    client2.connect();
		    if(query_from_url.type !== undefined){
				var req = 'SELECT a.id_personnel, p.login FROM affectations a, personnel p WHERE a.id_zone='+myArray[0].gid+' AND a.id_type_incident='+query_from_url.type+' AND a.id_personnel = p.idpers' ;
				console.log(req); 
				
				var query = client2.query(req);

				//exécution de la requête 
				query.on('row', function(row, result) {
					rows2.push(row);
					result.addRow(row);
				    console.log(rows2);
				});
				//traitement des résultats 
				query.on('end', insertBD);
			}
			else
				response.end();
		}
		catch(error){
			console.log(error);
			response.end();
		}
	}

	//insert le tout dans la BDD
	var insertBD = function(){
		try{
			client2.end();
			client3.connect();
			var pers = rows2[0].id_personnel;
				zone = myArray[0].nom_canton,
				DATE = new Date(),
				day = DATE.getDate(),
				gid = "nextval('serial'::regclass)"
				month = DATE.getMonth()+1,
				year = DATE.getFullYear(),
				date = day+"/"+month+"/"+year,
				etat = "001";
			//if (verifParamCreateDec(query.lat, query.lon, query.texte, query.type, query.gid)){
			req ='INSERT INTO \"public\".\"declaration\" (\"gid\",\"zone\",\"latitude\",\"longitude\",\"type\",\"texte\",\"date_dec\",\"idcitoyen\",\"persaffectee\",\"etat\",\"adresse\", \"suivi\" , \"urgence\" ) VALUES ('+gid+','+zone+','+parseFloat(query_from_url.lon)+','+parseFloat(query_from_url.lat)+','+parseInt(query_from_url.type)+',\''+query_from_url.texte+'\',\''+date+'\',(select id_citoyen from citoyens where login=\''+query_from_url.login+'\'),'+pers+',\''+etat+'\',\''+query_from_url.adresse+'\','+query_from_url.suivi+','+query_from_url.urgence+') returning gid';
			console.log(req);  
			var query = client3.query(req);

			//exécution de la requête 
			query.on('row', function(row, result) {
					rows3.push(row);
					result.addRow(row);
			    	console.log(rows3[0]);	
			});  

			//traitement des résultats 
			query.on('end', function(result){
				client3.end();
				myArray = [];
				myArray.push({"gid" : rows3[0].gid});
				var socket = io.connect('http://'+domain+':'+port);	
				socket.emit('nouvelleDeclaration',rows2[0].login);
			  	response.writeHead(200, {"Content-Type": "application/json", 'Access-Control-Allow-Origin': '*',
         								'Access-Control-Allow-Credentials': 'true'})
		  		response.end(JSON.stringify(myArray),'utf-8');
			});
		}
		catch(error){
			console.log(error);
			response.end();
		}
	}
	
	if ( query_from_url !== undefined){
		//upload(response, request);
		findZone();
	}
}

//permet d'obtenir la liste des incidents traités par une ville
//Cette fonction peut être appelée à chaque lancement de l'application smartphone
function getListIncidentsVille(response, request){
	//select i.nom from traitement_incidents t, ville v, incidents i where v.idville = 1 AND v.idville = t.id_ville and t.id_incident = i.id_type
	var url_parts = url.parse(request.url, true),
         query = url_parts.query,
		 con ="postgres://"+user_db+":cire@"+domain+":5432/postgres",
		 rows1 =[],
		 myArray = [],
		 client1 = new pg.Client(con);
	client1.connect();
	
    //version pour les agents
    if (!query.idville){
    	//pour dataTable
    	try{
    		var login = getLogin(request);
    		if (login != undefined)
    			req ="select i.intitule, i.id_type from traitement_incidents t, ville v, incidents i where v.idville ="+infos_login[login+'.ville']+" AND v.idville = t.id_ville and t.id_incident = i.id_type";
    	}
    	catch (e) {
    		console.log("Error :"+ e);
    	}
    }
    //version pour les citoyens
    else
		req ="select i.intitule, i.id_type from traitement_incidents t, ville v, incidents i where v.idville ="+query.idville+" AND v.idville = t.id_ville and t.id_incident = i.id_type";
	console.log(req);  
	var querya = client1.query(req);
	//exécution de la requête 
	querya.on('row', function(row, result) {
			rows1.push(row);
			result.addRow(row);	
			//console.log(row);
	});  

	//traitement des résultats 
	querya.on('end', function(result){
		console.log(result.rows.length + ' lignes reçues');
		if(!query.idville){
			//pour datatables
			var text = "{";
			for (i=0;i<rows1.length;i++) {
				text += '"'+rows1[i].id_type+'":'+'"'+ rows1[i].intitule+'",';
				// myArray.push({'1': rows[i].prenom + ' ' + rows[i].nom
				// 				// "nom":rows[i].nom,
				// 				// "prenom":rows[i].prenom
				// });
		  	}
		  	text = text.substring(0,text.lastIndexOf(','));
		  	text += "}";
		}
		else {
			for (i=0,len=rows1.length;i<len;i++) {
				myArray.push({"id_type": rows1[i].id_type,
									"nom" : rows1[i].intitule
				});
	  		}
	  		myArray.join(',');
	  		console.log(myArray);
	  	}
	  	client1.end();
	  	response.writeHead(200, {"Content-Type": "application/json", 'Access-Control-Allow-Origin': '*',
         								'Access-Control-Allow-Credentials': 'true'});
	  	if (!query.idville){
	  		response.end(text,'utf-8');
	  	}
	  	else{
	  		response.end(JSON.stringify(myArray),'utf-8');
	  	}
	});
}

/**
* Allows to users to notify the same declaration as someone else
* without making a new statement, just a "+1" on the declaration
* Add a line in "notification" table with the id of the citizen and the id of the statement
* @param login of the citizen
* @param id of the stattement
*/
function plusOneDec(response, request){
	var url_parts = url.parse(request.url, true),
         query = url_parts.query,
		 con ="postgres://"+user_db+":cire@"+domain+":5432/postgres",
		 rows =[],
		 myArray = [],
		 client = new pg.Client(con);
	client.connect();
	//var emitter = new (require('events').EventEmitter)();
	if (query.login && query.gid && query.mdp){
		req ="DO LANGUAGE plpgsql $$"+ 
			"BEGIN "+ 
				"IF (select gid from declaration where idcitoyen=(select id_citoyen from citoyens where login='"+query.login+"' and mdp='"+query.mdp+"') and gid='"+query.gid+"')>0 THEN "+ 
					"null;"+
				"ELSE "+
					"IF (select id from notifications where (id_dec='"+query.gid+"' AND id_utilisateur=(select id_citoyen from citoyens where login='"+query.login+"')))> 0 THEN "+
						"null;"+
					"ELSE "+
						"INSERT INTO notifications(id, id_dec, id_utilisateur)VALUES (nextval('id_notif'),'"+query.gid+"',(select id_citoyen from citoyens where login='"+query.login+"'));"+
						"UPDATE declaration set nb_notifications = nb_notifications+1 WHERE gid ='"+query.gid+"';"+
					"END IF;"+
				"END IF;"+
			"END;"+
		"$$;";
		console.log(req);  
		try{
		var query = client.query(req);
		//emitter.emit("error", new Error("Something went wrong"));

		//traitement des résultats 
		query.on('end', function(){
			//emitter.emit("error", new Error("Something went wrong"));
			client.end();
			//console.log(result);
			//console.log(rows);
			response.writeHead(200,{"Content-Type": "text/html", 'Access-Control-Allow-Origin': '*','Access-Control-Allow-Credentials': 'true'});
			response.end('Merci de votre aide', 'utf-8');
		});
		}
		catch(e){
			console.error(e);
			client.end();
			response.writeHead(200,{"Content-Type": "text/html", 'Access-Control-Allow-Origin': '*','Access-Control-Allow-Credentials': 'true'});
			response.end('Vous avez déjà notifié cet incident', 'utf-8');
		}
	}
	else{
		response.end();
	}
}
/** Allows from the mobile application to register a new citizen
* It will checks if the login is already used or not
* 
*/
function createCitoyen(response, request){
	var url_parts = url.parse(request.url, true),
        query = url_parts.query,
		con ="postgres://"+user_db+":cire@"+domain+":5432/postgres",
		rows =[],
		client = new pg.Client(con);
	client.connect();

	try{
		console.log(query);
		req ="select login from citoyens where login='"+query.login+"'";
		console.log(req);  
		var querya = client.query(req);
		//exécution de la requête 
		querya.on('row', function(row, result) {
				rows.push(row);
				//result.addRow(row);	
				console.log("row "+ row);
		});  

		//traitement des résultats 
		querya.on('end', function(result){
			if (rows.length === 1){
				console.log("existe deja");
				client.end();
				response.writeHead(200, {"Content-Type": "text/html", 'Access-Control-Allow-Origin': '*',
	         								'Access-Control-Allow-Credentials': 'true'});
		  		response.end('Identifiant déjà utilisé','utf-8');
			}
			else{
				console.log("creation");
				req ="INSERT INTO citoyens( id_citoyen, login, mdp) VALUES (nextval('idCitoyen'), '"+query.login+"', '"+query.mdp+"')";
				console.log(req);
				queryb = client.query(req);
				queryb.on('row', function(row, result) {
					//rows.push(row);
				}); 
				queryb.on('end', function(result){
					console.log("insert terminé");
					client.end();
					response.writeHead(200, {"Content-Type": "text/html", 'Access-Control-Allow-Origin': '*',
	         								'Access-Control-Allow-Credentials': 'true'});
		  			response.end('Bienvenue','utf-8');
				});
			}
		});
	}
	catch(e){
		console.log(e);
	}
}

/*
* List all the statements related to one login
* @param login The login of the citizen
* @param mdp The password of the citizen
*/
function getMesDeclarations(response, request){

	var url_parts = url.parse(request.url, true),
		query = url_parts.query,
		text = String("["),
		rows = [],
		con ="postgres://"+user_db+":cire@"+domain+":5432/postgres",
		client = new pg.Client(con);
	client.connect();	

	console.log(query);
	if (query.login && query.mdp ) {
		console.log("mes déclarations");
		req ="SELECT intitule, texte, photo, date_dec, etat, gid, adresse FROM declaration d, citoyens c, incidents i WHERE c.login='"+query.login+"' AND c.mdp='"+query.mdp+"' AND d.idcitoyen = c.id_citoyen AND i.id_type =d.type";
		console.log(req);
		var query = client.query(req);

		query.on('row', function(row, result) {
			rows.push(row);
			result.addRow(row);	
			//console.log(row);
		});  

		//traitement des résultats 
		query.on('end', function(result){
			console.log(result.rows.length + ' lignes reçues');
			for (i=0,len=rows.length;i<len;i++) {
				text += '{"type":'+'"'+rows[i].intitule+'"'+
						',"texte":'+'"'+rows[i].texte+'"';
						if (rows[i].photo !== '' && rows[i].photo !== null){
							text += ',"photo":'+'"'+rows[i].photo+'"';
						}
				if(rows[0].etat === '001'){
            	text += ',"etat":'+'"A traiter"';
	            }
	            else if(rows[0].etat === '010'){
	            	text += ',"etat":'+'"En cours de traitement"';
	            }
	            else
	            	text += ',"etat":'+'"Incident résolu"';	
	            text +=',"gid":'+'"'+rows[i].gid+'"'+
				',"date":'+'"'+rows[i].date_dec+'"'+
				',"adr":'+'"'+rows[i].adresse+
				'"},';
	  		}
	  		text = text.substring(0,text.lastIndexOf(','));
	  		text += "]";
		  	client.end();
		  	response.writeHead(200, {"Content-Type": "application/json", 'Access-Control-Allow-Origin': '*',
	         								'Access-Control-Allow-Credentials': 'true'});
		  	response.end(text,'utf-8');
		});
	}
}
/**
* Appelée par le plugin DataTables utilisé sur le portail 
* Reçoit en GET des paramètres pour afficher les données de la table
* Des données en POST peuvent être envoyées pour modifier une déclaration ou en supprimer
*/
function getDataTable(response, request){
	console.log("Le gestionnaire 'getDataTable' est appelé.");
	var url_parts = url.parse(request.url, true),
    	query = url_parts.query;
    	login = getLogin(request);
    if (request.method == 'POST'){	
    	console.log('POST');
	    var data = "";

	    request.on("data", function(chunk) {
	        data += chunk;
	    });

	    request.on("end", function() {
	        var json = qs.parse(data);
	        var parse = JSON.stringify(json);
	        console.log("parse "+parse);
	        //console.log(json.value);
	        console.log(json.columnName);
	        //console.log('columname '+ parse.columnName);
	        	switch (json.columnName){
	        		case ("Etat"): {setEtat(response,json.id, json.value); break;}
	        		case ("Responsable"):{affecter(response,json.id, json.value); break;}
	        		case ("Type"): {setType(response, json.id, json.value); break;}
	        	}
	    });	
	}		
	else {
		console.log("GET");
		var oDatatableParams = {
		    "sEcho": parseInt(query.sEcho),
		    "sSearch": query.sSearch,
		    "bRegex": query.bRegex,
		    "bRegex_0": query.bRegex_0,
		    "bRegex_1": query.bRegex_1,
		    "bRegex_2": query.bRegex_2,
		    "bRegex_3": query.bRegex_3,
		    "bRegex_4": query.bRegex_4,
		    "bRegex_5": query.bRegex_5,
		    "bRegex_6": query.bRegex_6,
		    "bRegex_7": query.bRegex_7,
		    "bRegex_8": query.bRegex_8,
		    "sSearch_0": query.sSearch_0,
		    "sSearch_1": query.sSearch_1,
		    "sSearch_2": query.sSearch_2,
		    "sSearch_3": query.sSearch_3,
		    "sSearch_4": query.sSearch_4,
		    "sSearch_5": query.sSearch_5,
		    "sSearch_6": query.sSearch_6,
		    "sSearch_7": query.sSearch_7,
		    "sSearch_8": query.sSearch_8,
		    "bSearchable_0": query.bSearchable_0,
		    "bSearchable_1": query.bSearchable_1,
		    "bSearchable_2": query.bSearchable_2,
		    "bSearchable_3": query.bSearchable_3,
		    "bSearchable_4": query.bSearchable_4,
		    "bSearchable_5": query.bSearchable_5,
		    "bSearchable_6": query.bSearchable_6,
		    "bSearchable_7": query.bSearchable_7,
		    "bSearchable_8": query.bSearchable_8,
		    "bSortable_0": query.bSortable_0,
		    "bSortable_1": query.bSortable_1,
		    "bSortable_2": query.bSortable_2,
		    "bSortable_3": query.bSortable_3,
		    "bSortable_4": query.bSortable_4,
		    "bSortable_5": query.bSortable_5,
		    "bSortable_6": query.bSortable_6,
		    "bSortable_7": query.bSortable_7,
		    "bSortable_8": query.bSortable_8,
		    "iColumns": query.iColumns,
		    "iDisplayStart": query.iDisplayStart,
		    "iDisplayLength": query.iDisplayLength,
		    "iSortCol_0": query.iSortCol_0,
		    "sSortDir_0": query.sSortDir_0,
		    "iSortingCols": query.iSortingCols,
		    "sColumns": query.sColumns
		};

		var d = new Date();

		var SearchArray = [];
		SearchArray.push(query.sSearch);
		if (query.sSearch_0 !== undefined)
			SearchArray.push(query.sSearch_0);
		if (query.sSearch_1 !== undefined)
			SearchArray.push(query.sSearch_1);
		if (query.sSearch_2 !== undefined)
			SearchArray.push(query.sSearch_2);
		if (query.sSearch_3 !== undefined)
			SearchArray.push(query.sSearch_3);
		if (query.sSearch_4 !== undefined)
			SearchArray.push(query.sSearch_4);
		if (query.sSearch_5 !== undefined)
			SearchArray.push(query.sSearch_5);
		if (query.sSearch_6 !== undefined)
			SearchArray.push(query.sSearch_6);
		if (query.sSearch_7 !== undefined)
			SearchArray.push(query.sSearch_7);

		if (infos_login[login+'.role'] === 'admin')
			var donnees = "d.type = i.id_type AND d.id_ville = "+infos_login[login+'.ville']+" AND d.etat = e.valeur AND p.idpers = d.persaffectee";
		else if (infos_login[login+'.role'] === 'agent')
			var donnees = "d.type = i.id_type AND d.persaffectee = "+infos_login[login+'.id']+" AND d.etat = e.valeur AND p.idpers ="+infos_login[login+'.id'];

		var tableDefinition = {
			sCountColumnName : "gid",
		    sTableName: "declaration d, incidents i, personnel p, etats e",
		    sDateColumnName : "date_dec",
		    dateTo : d,
		    sSelectSql : ["gid", "etat","intitule", "nom", "prenom", "zone", "adresse", "nb_notifications", "photo", 'date_dec', 'date_priseencharge', 'date_fin'],
		    //sFromSql: ["gid", "etat"],
		    //c'est ce qui est utilisé pour la recherche de terme, ne mettre que les colonnes avec champs de recherche 
		    aSearchColumns: ["gid", "etat", "intitule", "nom", "zone", "adresse", "nb_notifications", "photo", 'date_priseencharge' ],
		    // aSearchColumns : ["*"],
		    aoColumnDefs: [
		        { mData: "gid", bSearchable: false },
		        { mData: "etat", bSearchable: true },
		        { mData: "intitule", bSearchable: true },
		        { mData: "nom", bSearchable: true},
		        { mData: "prenom", bSearchable: true},
		        { mData: "zone", bSearchable: true},
		        { mData: "adresse" , bSearchable: true},
		        { mData: "nb_notifications", bSearchable: false},
		        { mData: "photo" , bSearchable: false},
		        { mData: "date_priseencharge" , bSearchable: false}
		    ],
		    sSearchArray: SearchArray,
		    dbType : 'postgres',
		    sWhereAndSql: donnees,
		    sAjaxDataProp : "aData"
		};
		var queryBuilder = new QueryBuilder( tableDefinition );

		// Build an array of SQL query statements
		console.log(SearchArray[0]);
		var queries = queryBuilder.buildQuery( oDatatableParams);

		var sequelize = new Sequelize('postgres', '"+user_db+"', 'cire', {
		       dialect: 'postgres',
		       port: 5432,
		       pool: { maxConnections: 5, maxIdleTime: 30}
		})
		var aaData =[];
		var nbRecords;
		var result = [];
		tout =[];
		var i = 0;
		// console.log(queries);
		sequelize.query(queries[i])
			.on('success', function(rows) {
				result.push(rows);
				if (queries[++i] !== undefined){
					sequelize.query(queries[i])
						.on('success', function(rows) {
							result.push(rows);
							if (queries[++i] !== undefined){
								sequelize.query(queries[i])
									.on('success', function(rows) {
										result.push(rows);
										if (queries[++i] !== undefined){
											sequelize.query(queries[i])
												.on('success', function(rows) {
													result.push(rows);
													tout = queryBuilder.parseResponse(result);
													collectData();
												});	
										}
										else{
											tout = queryBuilder.parseResponse(result);
											collectData();
										}
									});	
							}
							else{
								tout = queryBuilder.parseResponse(result);
								collectData();
							}
						});	
				}
				else{
					tout = queryBuilder.parseResponse(result);
					collectData();
				}
			});
	}

// console.log(queryBuilder.parseResponse(test));
	var collectData= function(){
		// console.log("data: " +tout.aData);
		var aaData ={"sEcho": parseInt(query.sEcho),
			 "iTotalRecords": tout.iTotalRecords,
	  "iTotalDisplayRecords": tout.iTotalDisplayRecords,
	  				"aaData": tout.aData
		};
		
		response.writeHead(200,{"Content-Type": "application/json",  'Access-Control-Allow-Origin': '*','Access-Control-Allow-Credentials': 'true'});
	 	response.end(JSON.stringify(aaData), 'utf-8');
	}	
}

exports.start = start;
exports.login = login;
exports.logina = logina;
exports.reset = reset;
exports.stat = stat;
exports.maj = maj;
exports.getData = getData;
exports.getPerso = getPerso;
exports.getTaches = getTaches;
exports.affecter = affecter;
exports.supprDec = supprDec;
exports.createDec = createDec;
exports.createCitoyen = createCitoyen;
exports.getMesDeclarations = getMesDeclarations;
exports.getStat = getStat;
exports.resetPassword = resetPassword;
exports.confirmeReset = confirmeReset;
exports.plusOneDec = plusOneDec;
exports.setState = setState;
exports.getLog = getLog;
exports.upload = upload;
exports.getListIncidentsVille = getListIncidentsVille;
exports.getDataTable = getDataTable;
