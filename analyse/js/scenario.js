
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
displayEdit_reply(false);

var ID_SCENARIO = 3;

list_questions = [
	new Question(ID_SCENARIO*10,ID_SCENARIO),
	new Question(ID_SCENARIO*10+1,ID_SCENARIO),
];

list_replies = [
	new Reply(ID_SCENARIO*10, ID_SCENARIO, 30, 31),	
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

/* Renvoie une reply de la liste en fonction
 * de son id
 */
function findReply(id){
	for(var i=0; i<list_replies.length; i++){
		if(list_replies[i].id == id){
			return list_replies[i];
		}
	}
	print("Error findReply("+id+") not found");
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
	element.parentNode.remove();

	//On trouve la question
	var q = findQuestion(id);

	//On trouve l'indice dans la liste
	var index = list_questions.indexOf(q);

	//On retire l'objet a cet indice
	list_questions.splice(index,1);

	//On supprime les réponses associées à la question
	for(var i=0; i<list_replies.length; i++){
		if(list_replies[i].idQuestion == id){
			list_replies.splice(i,1);
		}
	}

}

/* Affiche ou non le pop-up edit_reply
*/
function displayEdit_reply(display){
	var element = document.querySelector("[class='edit_reply']");
	if(display){
		element.style.display='';
	}else{
		element.style.display='none';
		clearEdit_reply();
	}
}

/* Vide le pop-up edit_reply
*/
function clearEdit_reply(){
	var edit_reply_id = document.getElementById("edit_reply_id");
	edit_reply_id.innerText="Id reply : ";

	var edit_reply_previous = document.getElementById("edit_reply_previous");
	edit_reply_previous.value="";

	var edit_reply_next = document.getElementById("edit_reply_next");
	edit_reply_next.value="";

	var edit_reply_type = document.getElementById("edit_reply_type");
	edit_reply_type.value="";

	var edit_reply_value = document.getElementById("edit_reply_value");
	edit_reply_value.value="";

	var edit_reply_textarea = document.querySelector("[id='edit_reply_textarea']");
	edit_reply_textarea.children[0].value="";
	edit_reply_textarea.children[1].value="";
	edit_reply_textarea.children[2].value="";
	
}

/* Ouvre le pop-up de modification d'une Reply
 */
function editEdit_reply(id){
	var r = findReply(id);

	var edit_reply_id = document.getElementById("edit_reply_id");
	edit_reply_id.innerText="Id reply : "+r.id;

	var edit_reply_previous = document.getElementById("edit_reply_previous");
	edit_reply_previous.value=r.idQuestion;

	var edit_reply_next = document.getElementById("edit_reply_next");
	edit_reply_next.value=r.idNextQuestion;

	var edit_reply_type = document.getElementById("edit_reply_type");
	edit_reply_type.value=r.dataType;

	var edit_reply_value = document.getElementById("edit_reply_value");
	edit_reply_value.value=r.dataValue;

	var edit_reply_textarea = document.querySelector("[id='edit_reply_textarea']");
	edit_reply_textarea.children[0].value=r.textEN;
	edit_reply_textarea.children[1].value=r.textFR;
	edit_reply_textarea.children[2].value=r.textJP;

	displayEdit_reply(true);
}


/* Supprime une réponse dans le DOM et en objet
 */
function deleteReply(id){
	var element = document.querySelector("[idReply='"+id+"']");
	element.remove();

	//On trouve la réponse
	var r = findReply(id);

	//On trouve l'indice dans la liste
	var index = list_replies.indexOf(r);

	//On retire l'objet a cet indice
	list_replies.splice(index,1);
}

/* Ouvre la fenètre d'une nouvelle reply 
 * avec l'id incrémenté
 */
function newReply(){

	var id = ID_SCENARIO*10;

	for(var i=0; i<list_replies.length; i++){
		if(list_replies[i].id >= id){
			id = list_replies[i].id + 1;
		}
	}

	var edit_reply_id = document.getElementById("edit_reply_id");
	edit_reply_id.innerText="Id reply : "+id;

	displayEdit_reply(true);

}

/* Renvoie le dernier mot d'un string
 */
function returnLastWord(text){
	var n = text.split(" ");
    return n[n.length - 1];
}


/* Récupère l'id reply et vérifie si il est déjà existant
 * si oui : modifie
 * si non : créer
 */
function validateReply(){

	//On récupère l'id dans le DOM
	var edit_reply_id = document.getElementById("edit_reply_id");
	var id = parseInt(returnLastWord(edit_reply_id.innerText));

	//On vérifie si il existe ou non
	var exist = false;
	for(var i=0; i<list_replies.length; i++){
		if(list_replies[i].id == id){
			exist = true;
		}
	}

	if(exist){
		//Fonction modifie
	}else{
		//Fonction créer 
	}

}




/* ------------------
 * A faire :
 * Fonction qui créer une question en DOM
 * Ajouter choix ID_SCENARIO
 * 
 * Fonction New Reply (displayEdit_reply) V
 * Fonction Edit Reply V
 * Fonction Delete Reply V
 * Fonction Validate Reply : V
 *  - Si déja existant, modifie
 *  - Sinon créer 
 * Fonction qui créer une Reply en DOM
 * Fonction qui modifie une Reply en DOM
 * 
 * implémenter les Replies - pop up new reply V
 * possibilité de mettre les replies en dessous des questions V
 * generer le fichier Json :
 *  - Enregistrer les textEN FR JP dans le modèle
 *  - Enregistrer les variables dans le modèle
 *  - Generer Question, Reply, RelationQR pour Bob San
 *  - optionnel : générer Question, Reply pour Mei Chan
 * 
 * -------------------
 */


/* -------------------
 * Méthode agile :
 * découper en petit bout, générer Json 
 * étape suivante
 * 
 * -------------------
 */

