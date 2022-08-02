
/* Site utile pour les selecteurs du DOM 
 * https://www.w3schools.com/cssref/css_selectors.asp
*/


/* Variable langue
 * 0 = En
 * 1 = Fr
 0 2 = Jp
 */
var lang = 0;
changeLanguage(lang);

var ID_SCENARIO = 3;

list_questions = [
	new Question(ID_SCENARIO*10,ID_SCENARIO),
	new Question(ID_SCENARIO*10+1,ID_SCENARIO),
];


/* Renvoie une question de la liste en fonction
 * de son id
 */
function findQuestion(id){
	for(var i=0; i<list_questions.length; i++){
		if(list_questions[i].id == id){
			return list_questions[i];
		}
	}
	print("Error findQuestion("+id+") not found");
	return 1;
}



/* Change la langue pour afficher le 
 * textEN / textFR / textJP approprié
 */
function changeLanguage(l){
	lang = l;
	var element = document.getElementById("btn_lang");
	element.children.item(0).setAttribute("id","");
	element.children.item(1).setAttribute("id","");
	element.children.item(2).setAttribute("id","");
	element.children.item(l).setAttribute("id","btn_selected");

	//Récupère les input de chaque langue
	var elementsEN = document.querySelectorAll("[id='textEN']");
	var elementsFR = document.querySelectorAll("[id='textFR']");
	var elementsJP = document.querySelectorAll("[id='textJP']");

	//Change les display de chaque input en fonction de la langue
	if(l==0){
		for(var i = 0; i < elementsEN.length; i++){
			elementsEN[i].style.display = "";
		}
	}else{
		for(var i = 0; i < elementsEN.length; i++){
			elementsEN[i].style.display = "none";
		}
	}
	if(l==1){
		for(var i = 0; i < elementsFR.length; i++){
			elementsFR[i].style.display = "";
		}
	}else{
		for(var i = 0; i < elementsFR.length; i++){
			elementsFR[i].style.display = "none";
		}
	}
	if(l==2){
		for(var i = 0; i < elementsJP.length; i++){
			elementsJP[i].style.display = "";
		}
	}else{
		for(var i = 0; i < elementsJP.length; i++){
			elementsJP[i].style.display = "none";
		}
	}

}

/* Passe une question à isFirst
 * retire le isEnd si nécessaire
 * retire le isFirst si il est déjà existant
 */
function setIsFirst(id){
	var element = document.getElementById(id);
	var text = element.getAttribute("class");
	var q = findQuestion(id);

	//Si déjà isFirst on retire le isFirst
	if(text == "question isFirst"){
		element.setAttribute("class","question");
		q.isFirst = false;
	//Sinon on ajoute le isFirst et retire le isEnd
	}else{
		element.setAttribute("class","question isFirst");
		q.isEnd = false;
		q.isFirst = true;
	}
}

/* Passe une question à isEnd
 * retire le isFirst si nécessaire
 * retire le isEnd si il est déjà existant
 */
function setIsEnd(id){
	var element = document.getElementById(id);
	var text = element.getAttribute("class");
	var q = findQuestion(id);

	//Si déjà isEnd on retire le isEnd
	if(text == "question isEnd"){
		element.setAttribute("class","question");
		q.isEnd = false;
		
	//Sinon on ajoute le isEnd
	}else{
		element.setAttribute("class","question isEnd");
		q.isFirst = false;
		q.isEnd = true;
	}
}

/* Supprime une question 
 */
function deleteQuestion(id){
	var element = document.getElementById(id);
	element.remove();

	//On trouve la question
	var q = findQuestion(id);

	//On trouve l'indice dans la liste
	var index = list_questions.indexOf(q);

	//On retire l'objet a cet indice
	list_questions.splice(index,1);

}


/* A faire :
 * Fonction qui créer une question
 * Enregistrer les textEN FR JP dans le modèle
 * Enregistrer les variables dans le modèle
 * Ajouter choix ID_SCENARIO
 * 
 * Fonction New Reply
 * Fonction Edit Reply
 * Fonction Delete Reply
 * 
 * Plus tard :
 * implémenter les Replies - pop up new reply V
 * possibilité de mettre les replies en dessous des questions V
 * generer le fichier Json
 */


