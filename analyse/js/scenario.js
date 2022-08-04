
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
	console.log("Error findQuestion("+id+") not found");
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
	console.log("Error findReply("+id+") not found");
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
			i=i-1;
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


/* Vérifie si l'id question existe
 * Récupère l'id reply et vérifie si il est déjà existant
 * si oui : modifie
 * si non : créer
 */
function validateReply(){

	//On récupère l'id dans le DOM
	var edit_reply_id = document.getElementById("edit_reply_id");
	var id = parseInt(returnLastWord(edit_reply_id.innerText));

	//On vérifie si l'ID Question est valide
	var edit_reply_previous = document.getElementById("edit_reply_previous");
	var idQuestion = parseInt(edit_reply_previous.value);

	//Renvoie une erreur si ID previous question n'est pas trouvé
	if(findQuestion(idQuestion) == 1){
		console.log("Error : id Previous question is not valid");
		alert("ID Previous question is not valid")
		return 1;
	}

	//On vérifie si il existe ou non
	var exist = false;
	for(var i=0; i<list_replies.length; i++){
		if(list_replies[i].id == id){
			exist = true;
		}
	}

	if(exist){
		//Fonction modifie
		modifyReply(id);
	}else{
		//Fonction créer 
		createReply(id);
	}

	//On ferme la fenètre
	displayEdit_reply(false);

}

/* Modifie le DOM d'une Reply
 * La déplace en dessous de la bonne question - a faire
 */
function modifyReply(id){

	//On récupère l'objet Reply dans la liste
	var r = findReply(id);

	//-----------------------------------
	//On modifie l'objet Reply

	var edit_reply_previous = document.getElementById("edit_reply_previous");
	r.idQuestion=parseInt(edit_reply_previous.value);

	var edit_reply_next = document.getElementById("edit_reply_next");
	r.idNextQuestion=parseInt(edit_reply_next.value);

	var edit_reply_type = document.getElementById("edit_reply_type");
	r.dataType=edit_reply_type.value;

	var edit_reply_value = document.getElementById("edit_reply_value");
	r.dataValue=parseInt(edit_reply_value.value);

	var edit_reply_textarea = document.querySelector("[id='edit_reply_textarea']");
	r.textEN=edit_reply_textarea.children[0].value;
	r.textFR=edit_reply_textarea.children[1].value;
	r.textJP=edit_reply_textarea.children[2].value;
	//-----------------------------------

	//On modifie le DOM Reply
	var elementReply = document.querySelector("[idReply='"+id+"']");

	//console.log(elementReply.children[1].children[0].innerText);
	elementReply.children[1].children[0].innerText = "Previous : "+r.idQuestion;
	elementReply.children[1].children[1].innerText = "Next : "+r.idNextQuestion;

	elementReply.children[2].children[0].innerText = "Type : "+r.dataType;
	elementReply.children[2].children[1].innerText = "Value : "+r.dataValue;

	elementReply.children[3].innerText = r.textEN;
	elementReply.children[4].innerText = r.textFR;
	elementReply.children[5].innerText = r.textJP;

	//Déplace la réponse en DOM
	replaceReply(elementReply,id);

}


/* Deplace une réponse DOM sous la bonne question
 */
function replaceReply(elementReply, id){
	var r = findReply(id);

	var elementZone = document.querySelector("[idZone='"+r.idQuestion+"']");
	elementZone.appendChild(elementReply);
}


/* Créer une réponse en objet et en DOM
 * La place en dessous d'une question 
 */
function createReply(id){

	//-------------------
	//Création en objet
	var edit_reply_previous = document.getElementById("edit_reply_previous");
	var idQuestion = parseInt(edit_reply_previous.value);

	var edit_reply_next = document.getElementById("edit_reply_next");
	var idNextQuestion=parseInt(edit_reply_next.value);
	
	//id, isScenario, previous, next
	var r = new Reply(id,ID_SCENARIO,idQuestion,idNextQuestion);

	var edit_reply_type = document.getElementById("edit_reply_type");
	r.dataType=edit_reply_type.value;

	var edit_reply_value = document.getElementById("edit_reply_value");
	r.dataValue=parseInt(edit_reply_value.value);

	var edit_reply_textarea = document.querySelector("[id='edit_reply_textarea']");
	r.textEN=edit_reply_textarea.children[0].value;
	r.textFR=edit_reply_textarea.children[1].value;
	r.textJP=edit_reply_textarea.children[2].value;

	//On ajoute la réponse dans la liste
	list_replies.push(r);
	//-------------------

	//-------------------
	//Création en DOM

	var elementReply = document.createElement("div");
	elementReply.setAttribute('class','reply');
	elementReply.setAttribute('idReply',r.id);

	var elementBtn_reply = document.createElement("div");
	elementBtn_reply.setAttribute('id','btn_reply');

	var elementP1 = document.createElement("p");
	elementP1.innerText = "Id reply : "+r.id;

	var elementBtn1 = document.createElement("button");
	elementBtn1.innerText = "Edit";
	elementBtn1.setAttribute('onclick','editEdit_reply('+r.id+')');

	var elementBtn2 = document.createElement("button");
	elementBtn2.innerText = "X";
	elementBtn2.setAttribute('onclick','deleteReply('+r.id+')');
	elementBtn2.setAttribute('id','btn_delete');

	elementBtn_reply.appendChild(elementP1);
	elementBtn_reply.appendChild(elementBtn1);
	elementBtn_reply.appendChild(elementBtn2);

	elementReply.appendChild(elementBtn_reply);

	var elementDouble1 = document.createElement("div");
	elementDouble1.setAttribute('class','double');

	var elementP2 = document.createElement("p");
	elementP2.innerText = "Previous : "+r.idQuestion;

	var elementP3 = document.createElement("p");
	elementP3.innerText = "Next : "+r.idNextQuestion;

	elementDouble1.appendChild(elementP2);
	elementDouble1.appendChild(elementP3);

	elementReply.appendChild(elementDouble1);

	var elementDouble2 = document.createElement("div");
	elementDouble2.setAttribute('class','double');

	var elementP4 = document.createElement("p");
	elementP4.innerText = "Type : "+r.dataType;

	var elementP5 = document.createElement("p");
	elementP5.innerText = "Value : "+r.dataValue;

	elementDouble2.appendChild(elementP4);
	elementDouble2.appendChild(elementP5);

	elementReply.appendChild(elementDouble2);

	var elementEN = document.createElement("p");
	elementEN.innerText = r.textEN;
	elementEN.setAttribute('id','textEN');

	var elementFR = document.createElement("p");
	elementFR.innerText = r.textFR;
	elementFR.setAttribute('id','textFR');

	var elementJP = document.createElement("p");
	elementJP.innerText = r.textJP;
	elementJP.setAttribute('id','textJP');

	elementReply.appendChild(elementEN);
	elementReply.appendChild(elementFR);
	elementReply.appendChild(elementJP);

	//ajoute elementReply au DOM
	replaceReply(elementReply,r.id);

	//Permet de reset la langue et ainsi cacher
	//les réponses des autres langues
	changeLanguage(lang);

}

/* Creer une question en DOM et en Objet
 * avec id incrémenté 
 */
function createQuestion(){

	//On trouve l'id de la prochaine question 
	var id = ID_SCENARIO*10;
	for(var i=0; i<list_questions.length; i++){
		if(list_questions[i].id >= id){
			id = list_questions[i].id + 1;
		}
	}

	//Creer la question en Objet
	var q = new Question(id,ID_SCENARIO);
	list_questions.push(q);

	//-----------------------------------
	//Creer la question en DOM

	var elementZone = document.createElement("div");
	elementZone.setAttribute('class','zone_question');
	elementZone.setAttribute('idZone',q.id);

	var elementQuestion = document.createElement("div");
	elementQuestion.setAttribute('class','question');
	elementQuestion.setAttribute('id',q.id);

	/* ---------------------------
	 * ICI on va créer la question
     * ---------------------------
     */

	//On créer l'élément 
	elementZone.appendChild(elementQuestion);
	document.getElementById("scenario_box").appendChild(elementZone);
	
	//-----------------------------------

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
 *  - Si déja existant, modifie V
 *  - Sinon créer V 
 * Fonction qui créer une Reply en DOM V
 * Fonction qui modifie une Reply en DOM V
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

