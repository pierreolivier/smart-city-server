var map,
	plotlist,
	plotlayers=[],
	listIdLayers =[],
	infos,
	datDebDef = '1900-1-1',
	today = new Date(),
	year = today.getFullYear(),
	month = today.getMonth() + 1,
	day = today.getDate(),
	datFinDef = ""+year+"-"+month+"-"+day,
	port = 81,
	domain = 'pierreolivier.me'
	//domain = '127.0.0.1',
	// domain = '10.24.192.110',
	gidCourant,
	leafletId = -1,
	myId = -1,
	etatPopup = 000,
	login;
		
	// function loadCSSPerso(css){
	// 	var headID = document.getElementsByTagName("head")[0];
	// 	var cssNode = document.createElement('link');
	// 	cssNode.type = 'text/css';
	// 	cssNode.rel = 'stylesheet';
	// 	cssNode.href = './css/'+css;
	// 	cssNode.media = 'screen';
	// 	headID.appendChild(cssNode);
	// }
	
	// permet de lister l'ensemble du personnel disponible
	function getPersonnel(){
		jQuery.ajax({
			type: 'GET',
			url: 'http://'+domain+':'+port+'/getPerso',
				success: function(data, textStatus, jqXHR) { 
			  		//var perso=JSON.parse(ajaxRequest2.responseText);
					var selectElement = document.createElement('select');
					selectElement.setAttribute('name','personne');
					selectElement.setAttribute('id','personne');		
					var formPerso =document.form1.taches;			

					for (var i=0, len = data.length;i<len;i++){ 
						var element = document.createElement("option");
	                    element.setAttribute('value', data[i].idpers);
	                    element.text = data[i].prenom+" "+data[i].nom;
			            selectElement.appendChild(element);	 
					}
					document.getElementById("listePersonnel").appendChild(selectElement);
			  	},
			  	error: function(jqXHR, textStatus, errorThrown) {
			    //alert(errorThrown);
			}
		});
		
	}

	//permet de lister des taches en cours ou à traiter
	function getListeTaches(){
		jQuery.ajax({
			type: 'GET',
			url: 'http://'+domain+':'+port+'/getTaches',
				success: function(data, textStatus, jqXHR) { 
					//var taches = data;
					document.getElementById("listeTaches").innerHTML ="";
					//document.getElementById("supprimer").innerHTML ="";

					var selectElement = document.createElement('select');
					selectElement.setAttribute('name','taches');
					selectElement.setAttribute('id','taches');		
					var formTaches =document.form1.taches;			
					selectElement.setAttribute('onchange', 'afficherTache(document.form1.taches.options[document.form1.taches.selectedIndex].value)');

					for (var i=0, len = data.length;i<len;i++){
						var element = document.createElement("option");
	                    element.setAttribute('value', data[i].gid);
	                    element.text = data[i].gid;
			            selectElement.appendChild(element);		
					}
					document.getElementById("listeTaches").appendChild(selectElement);
					// nécessaire pour afficher une tache lors du lancement de la page
					afficherTache(document.form1.taches.options[document.form1.taches.selectedIndex].value);
			  	},
			  	error: function(jqXHR, textStatus, errorThrown) {
			    // Une erreur s'est produite lors de la requete
			    //alert(errorThrown);
			}
		});		
	}

	//permet d'obtenir une trace de login dans la page html pour permettre les notifications
	function getLogin(){
		jQuery.ajax({
			type: 'GET',
			url: 'http://'+domain+':'+port+'/getLog',
				success: function(data, textStatus, jqXHR) { 
			  		//on rafraichi les infos
			  		login = data;
			  		//alert(login);
			  	},
			  	error: function(jqXHR, textStatus, errorThrown) {
			    // Une erreur s'est produite lors de la requete
			    //alert(errorThrown);
			}
		});
	}

	// première fonction appelée
	function initmap(lat,lng,zoom){
		
		ajaxRequest=GetXmlHttpObject();
		if (ajaxRequest===null) {
			alert("Navigateur non supporté");
			return;
		}

		// création de la map
		var crs = L.CRS.EPSG4326;
		//var googleLayer = new L.Google('ROADMAP');
		
		var osmUrl='http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
		var osm = new L.TileLayer(osmUrl, {minZoom: 0});
		
		map = new L.Map('map',{});
		map.addLayer(osm);		
		//map.addLayer(googleLayer);

		//on essaye de donner une limite acceptable de déplacement sur la carte
		var southWest = new L.LatLng(47.26292215345572, -1.3531280517578125),
   		 	northEast = new L.LatLng(47.1680099307431, -1.7724822998046877),
    		bounds = new L.LatLngBounds(southWest, northEast);
    		//http://10.24.192.110/maj?minlng=-1.7128372192382812&minlat=47.1680099307431&maxlng=-1.4031600952148435&maxlat=47.26292215345572&etat=001
    		//http://10.24.192.110/maj?minlng=-1.7104339599609375&minlat=47.1680099307431&maxlng=-1.3976669311523435&maxlat=47.26292215345572&etat=000
    	//map.setMaxBounds(bounds);
		map.setView(new L.LatLng(lat,lng),zoom);
		var baseLayers = {
        	"osm" : osm
        	//"google": googleLayer
    	};

   		//layersControl = new L.Control.Layers(baseLayers);
    	//map.addControl(layersControl);

		L.control.layers(baseLayers).addTo(map);
		askForPlots();
		// getPersonnel();
		// getListeTaches();
		getLogin();

		//lors que l'on a terminé de bouger la carte, on affiche les nouveaux points
		map.on('moveend', onMapMove);

		//lors d'un clic sur un marker, les détails sont affichés en dessous
		// Dans la liste des tâches, il n'y n'a plus de tache sélectionnée
		map.on('popupopen', function (e) {
	    	//afficherTache(e.popup._source._myId);
	    	leafletId = e.popup._source._leaflet_id;
	    	myId = e.popup._source._myId;
	    	etatPopup = e.popup._source._etat;
		});

		/*map.on('layeradd', function (e){
			console.log(e.layer);
		});*/

		map.on('popupclose', function (e) {
		    leafletId = -1;
		    myId = -1;
		    etatPopup = 000;
		});
	}

	function askForPlots() {
		// request the marker info with AJAX for the current bounds
		var bounds = map.getBounds();
		var minll = bounds.getSouthWest();
		var maxll = bounds.getNorthEast();
		var etat = 0;
		 
		//var datedeb = document.form1.year1.options[document.form1.year1.selectedIndex].value+"-"+document.form1.month1.options[document.form1.month1.selectedIndex].value+"-"+document.form1.day1.options[document.form1.day1.selectedIndex].value;
		//var datefin = document.form1.year2.options[document.form1.year2.selectedIndex].value+"-"+document.form1.month2.options[document.form1.month2.selectedIndex].value+"-"+document.form1.day2.options[document.form1.day2.selectedIndex].value;

		//Chaque configuration d'affichage sera entre 000 et 111, les choses à faire sont de la forme 001, en cours 010, traitées 100, L'affichage de deux ou 3 paramètres en même temps sera géré comme des bits à 1 ou 0 pour signifier ou non leur affichage
		
		if ($('#todo').is(':checked')){
			etat += 1;
      	}
      	
      	if ($('#inprogress').is(':checked')){
			etat += 10;
      	}

      	if ($('#done').is(':checked')){
			etat += 100;

      	}
      	// convertion en string, nécessaire pour étate suivante
      	etat = etat.toString();
      	// convertion en string sous la forme de 3 bits
      	while (etat.length < 3){
      		etat = "0"+etat;
      	}
      	
      	console.log("etat :"+etat);
      	jQuery.ajax({
			type: 'GET',
			url: 'http://'+domain+':'+port+'/maj?minlng='+minll.lng+'&minlat='+minll.lat+'&maxlng='+maxll.lng+'&maxlat='+maxll.lat+'&etat='+etat,
				success: function(data, textStatus, jqXHR) {
					// si une popup est ouverte et qu'elle correpond à un état qui n'est plus coché, alors on doit passer -1 à removeMarker=> avoir l'état de la popup
					//console.log(etat + " " + etatPopup);
					var bool = etat & etatPopup;
					//console.log("bool "+ bool);
					if (bool !=  etatPopup){
						leafletId = -1;
						myId = -1;
			  			removeMarkers(leafletId);
					}
					else{
			  			removeMarkers(leafletId);
			  		}
			  		//removeMarkers(leafletId);
					for (var i=0, len = data.length;i<len;i++){
						
						var plotll = new L.LatLng(data[i].lat,data[i].lon, true);
						//une couleur de marker sur la carte sera affectée pour chaque type d'avancement de traitement 
						if(data[i].etat =='001')
							var icon ='red';
						else if(data[i].etat =='010')
							var icon ='blue';
						else
							var icon ='green';

						var myIcon = new L.Icon({
						    iconUrl: './media/marker-icon_'+icon+'.png',
						    //iconRetinaUrl: 'my-icon@2x.png',
						    iconSize: [25, 41],
						    iconAnchor:   [12, 41],
						    popupAnchor: [1, -34],
						    shadowUrl: './media/marker-shadow.png',
						    //shadowRetinaUrl: 'my-icon-shadow@2x.png',
						    shadowSize: [41, 41],
						    shadowAnchor: [12, 41]
						});
						// un plotmark est un layer
						var plotmark = new L.Marker(plotll, {icon: myIcon});
						
							plotmark.data=data[i];
							plotmark._myId =data[i].gid;
							plotmark._etat = data[i].etat;
							
							map.addLayer(plotmark);
							// console.log(plotmark._leaflet_id);
							if (myId !== plotmark._myId){
								plotmark.bindPopup("<p>Déclaration n° "+data[i].gid+"<br/>Type :"+data[i].type+"<br />Adresse:"+data[i].adr+"<br />Description:"+data[i].texte+"<br />"+data[i].photo+"</p>",{});
								//plotmark.bindPopup("<h3>"+data[i].gid+"</h3><br />"+"<h3>"+data[i].type+"</h3>"+"<h3>"+data[i].adr+"</h3><br />"+
								//"<a href='javascript:PopupWindow(this,"+'"'+"http://"+domain+":"+port+"/uploads/"+data[i].photo+'"'+")"+"'"+"><img src='http://"+domain+":"+port+"/media/apn.png'  height='100' weight='100' style='cursor: pointer;'/></a>");
								plotlayers[plotmark._leaflet_id]=plotmark;
								listIdLayers.push(plotmark._leaflet_id);
							}
							else{
								map.removeLayer(plotmark);
							}
						
					}
			  	},
			  	error: function(jqXHR, textStatus, errorThrown) {
			    // Une erreur s'est produite lors de la requete
			   // alert(errorThrown);
			    removeMarkers(leafletId);
			}
		});
	}

	function onMapMove(e) { 
		askForPlots(); 
	}

	function onMarkerClick(e){
		alert(e.latlng.toString());
	}

	function GetXmlHttpObject() {
		if (window.XMLHttpRequest) { return new XMLHttpRequest(); }
		if (window.ActiveXObject)  { return new ActiveXObject("Microsoft.XMLHTTP"); }
		return null;
	}

	//si id donné différent de -1, alors le marker en question ne doit pas être supprimé, car sa popup est ouverte
	function removeMarkers(id) {
		cout = 0;
		if (id !== -1){
			for (var i=0; i< listIdLayers.length;i++) {
				if(listIdLayers[i] !== id){
					map.removeLayer(plotlayers[listIdLayers[i]]);
					plotlayers[listIdLayers[i]] = undefined;
				}
			};
			listIdLayers =[];
			listIdLayers[0] = id;
		}
		else{
			//tester avec listIdLayers.size
			for (var i=0;i<listIdLayers.length;i++) {
				map.removeLayer(plotlayers[listIdLayers[i]]);
			}
			plotlayers=[];
			listIdLayers=[];
		}
	}

	/* Permet d'afficher les pièces jointes dans une nouvelle fenêtre */
	function PopupWindow(source, strWindowToOpen){
		var strWindowFeatures = "toolbar=no,resize=no,titlebar=no,";
		strWindowFeatures = strWindowFeatures + "menubar=no,width=413,height=299,maximize=null";
		window.open(strWindowToOpen, '', strWindowFeatures); 
	} 

	/* Permet d'affecter une tache à une personne, une connexion à la BDD pourra être faite,
	met à jour l'état de la tache
	*/
	function affecter(){
		var per = document.form1.personne.options[document.form1.personne.selectedIndex];
		var tache = document.form1.taches.options[document.form1.taches.selectedIndex].value;
		var r=confirm('Voulez vous vraiment affecter '+per.text+' à la tache '+ tache +'?');
		if (r===true){
			jQuery.ajax({
			type: 'POST',
			url: 'http://'+domain+':'+port+'/affecter?per='+per.value+'&tache='+tache, 
				success: function(data, textStatus, jqXHR) { 
			  		//on rafraichi les infos
			  		alert('Modification résussie');
			  		//afficherTache(tache);
			  		askForPlots();
			  		getListeTaches();
			  	},
			  	error: function(jqXHR, textStatus, errorThrown) {
			    // Une erreur s'est produite lors de la requete
			    alert('Soucis'+ errorThrown);
			}
		});
		}
		else
		  	alert("Affectation annulée");
	}

	//permet de modifier l'état d'une déclaration
	function modifStateDec(gid,state){
		jQuery.ajax({
			type: 'POST',
			url: 'http://'+domain+':'+port+'/setState', 
				data: {
				  gid: gid,
				  state: state
				 }, 
				success: function(data, textStatus, jqXHR) { 
			  		//on rafraichi les infos
			  		alert('Modification résussie');
			  	},
			  	error: function(jqXHR, textStatus, errorThrown) {
			    // Une erreur s'est produite lors de la requete
			}
		});
	}
	//Affiche l'état de la modification de l'affectation
	function confirmUpdateAffectation(tache){
		
		// si la requête est terminée
		if (ajaxRequest2.readyState===4) {

			// si la requête s'est bien déroulée
			if (ajaxRequest2.status===200) {
				try 
				{	
					alert('Affectation réussie');
				}
				catch(error)
				{
					alert('error: '+ error);
				}
			}
		}		 
	}

	// Entre 2 affichages, remet à 0 les infos 
	function removeInfos(){
		document.getElementById("photo").innerHTML ="";
		document.getElementById("video").innerHTML ="";
		document.getElementById("son").innerHTML ="";
		document.getElementById("supprimer").innerHTML ="";
	}

	//Permet de donner un lien pour chaque photo
	function listePhotos(photos){
		innerPhotos = [];
		if (photos.length> 0){
			for (var i = 0, len = photos.length; i < len; i++) {
	            innerPhotos.push("<a href='javascript:PopupWindow(this,"+'"'+"http://"+domain+":"+port+"/uploads/"+photos[i]+'"'+")"+"'"+"><img src='http://"+domain+":"+port+"/media/apn.png'  height='50' weight='50' style='cursor: pointer;'/></a>")
			}
	        document.getElementById("photo").innerHTML = innerPhotos.join('');  
        }
	}

	// Affiche tous les détails d'une tache
	function demandeInfos() {

		// si la requête est terminée
		if (ajaxRequest.readyState===4) {

			// si la requête s'est bien déroulée
			if (ajaxRequest.status===200) {
				try 
				{	
					//si eval échoue c'est qu'il n'y a aucun résultat
					infos=JSON.parse(ajaxRequest.responseText);
					//removeInfos();
					// utile pour mettre a jour si besoin la déclaration affichée
					gidCourant = infos.gid;
					document.getElementById("numDeclaration").innerHTML = "<p>Numéro Déclaration: "+infos.gid+"</p>";
					document.getElementById("persAffectee").innerHTML = "<p>Personne affectée: "+infos.persaffectee+"</p>";
					document.getElementById("date").innerHTML = "<p>Date: "+infos.date+"</p>";
					document.getElementById("nature").innerHTML = "<p>Type: "+infos.type+"</p>";
					document.getElementById("adresse").innerHTML = "<p>Adresse: "+infos.adr+"</p>";
					var state;
					if (infos.etat == '001'){
						state = "Nouvelle";
					}
					else if(infos.etat == '010'){
						state = "En cours";
					}
					else
						state = "Terminée";
					document.getElementById("etat").innerHTML = "<p>Etat d'avancement: "+state+"</p>";
					document.getElementById("descriptif").innerHTML = "<p>"+infos.texte+"</p>";

					// on ne peut mettre qu'un seul son et vidéo
					if (infos.video !== undefined){
					document.getElementById("video").innerHTML = "<a href='javascript:PopupWindow(this,"+'"'+"http://"+domain+":"+port+"/uploads/"+infos.video+'"'+")"+"'"+"><img src='http://"+domain+":"+port+"/media/logo.png'  height='50' weight='50' style='cursor: pointer;'/></a>";
					}
					if (infos.son !== undefined){
					document.getElementById("son").innerHTML = "<a href='javascript:PopupWindow(this,"+'"'+"http://"+domain+":"+port+"/uploads/"+infos.son+'"'+")"+"'"+"><img src='http://"+domain+":"+port+"/media/son.jpg'  height='50' weight='50' style='cursor: pointer;'/></a>";
					}
					//traitement pour les photos
					if (infos.photos !== undefined){
						listePhotos(infos.photos);
					}
					document.getElementById("supprimer").innerHTML +="<input type='button' onclick='supprimerTache("+infos.gid+")' value='Supprimer tâche' />";	
				}
				
				catch (error){
					alert('erreur:'+ error);
				}
			}
		}
	}

	/* Appelée lorsqu'une tache est sélectionné sur le grahique ou alors dans la liste
	   la tache sélectionnée sera affichée dans le cadre en bas à gauche
	*/
	function afficherTache(gid){
		//ajaxRequest.onreadystatechange = demandeInfos;
		ajaxRequest.open('GET','http://'+domain+':'+port+'/getData?gid='+gid, false);
		ajaxRequest.send(null); 
	}

	/* Permet de d'afficher ou non les declarations à traiter sur la carte 
	function atraiter(){
		alert($('#todo').is(':checked'));
	}
	*/

	function supprimerTache(gid){
		alert("Suppression de la "+gid);
		jQuery.ajax({
			type: 'POST',
			url: 'http://'+domain+':'+port+'/supprDec?tache='+gid, 
				success: function(data, textStatus, jqXHR) { 
			  		//on rafraichi les infos
			  		alert('Modification résussie');
			  		askForPlots();
					getListeTaches();
			  	},
			  	error: function(jqXHR, textStatus, errorThrown) {
			    // Une erreur s'est produite lors de la requete
			    alert(errorThrown);
			}
		});
	}
