
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
displayJson(false);
hideControls(true);

var ID_SCENARIO = 1;

list_questions = [
/*
	new Question(ID_SCENARIO*10,ID_SCENARIO),
	new Question(ID_SCENARIO*10+1,ID_SCENARIO), */
];

list_replies = [
/*
	new Reply(ID_SCENARIO*10, ID_SCENARIO, 30, 31),	*/
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

    var elementBtnQuestion = document.createElement("div");
    elementBtnQuestion.setAttribute('id','btn_question');

    var elementP1 = document.createElement("p");
    elementP1.innerText = "Id question : " + q.id;

    var elementBtn1 = document.createElement("button");
    elementBtn1.setAttribute('onclick','setIsFirst('+q.id+')');
    elementBtn1.setAttribute('id','btn_isFirst');
    elementBtn1.innerText = "First";

    var elementBtn2 = document.createElement("button");
    elementBtn2.setAttribute('onclick','setIsEnd('+q.id+')');
    elementBtn2.setAttribute('id','btn_isEnd');
    elementBtn2.innerText = "End";

    var elementBtn3 = document.createElement("button");
    elementBtn3.setAttribute('onclick','deleteQuestion('+q.id+')');
    elementBtn3.setAttribute('id','btn_delete');
    elementBtn3.innerText = "X";

    elementBtnQuestion.appendChild(elementP1);
    elementBtnQuestion.appendChild(elementBtn1);
    elementBtnQuestion.appendChild(elementBtn2);
    elementBtnQuestion.appendChild(elementBtn3);

    elementQuestion.appendChild(elementBtnQuestion);

    var elementEN = document.createElement("textarea");
    elementEN.setAttribute('rows','3');
    elementEN.setAttribute('cols','28');
    elementEN.setAttribute('type','text');
    elementEN.setAttribute('size','50');
    elementEN.setAttribute('rows','3');
    elementEN.setAttribute('id','textEN');
    elementEN.setAttribute('placeholder','Write question');

    var elementFR = document.createElement("textarea");
    elementFR.setAttribute('rows','3');
    elementFR.setAttribute('cols','28');
    elementFR.setAttribute('type','text');
    elementFR.setAttribute('size','50');
    elementFR.setAttribute('rows','3');
    elementFR.setAttribute('id','textFR');
    elementFR.setAttribute('placeholder','Ecrire une question');

    var elementJP = document.createElement("textarea");
    elementJP.setAttribute('rows','3');
    elementJP.setAttribute('cols','28');
    elementJP.setAttribute('type','text');
    elementJP.setAttribute('size','50');
    elementJP.setAttribute('rows','3');
    elementJP.setAttribute('id','textJP');
    elementJP.setAttribute('placeholder','しつもんをする');

    elementQuestion.appendChild(elementEN);
    elementQuestion.appendChild(elementFR);
    elementQuestion.appendChild(elementJP);

    var elementVariable = document.createElement("div");
	elementVariable.setAttribute('id','input_variable');

	var elementLabel = document.createElement("label");
	elementLabel.innerText = "Variable :";

	var elementInput = document.createElement("input");
	elementInput.setAttribute('id','nameVariable');
	elementInput.setAttribute('type','text');

	elementVariable.appendChild(elementLabel);
	elementVariable.appendChild(elementInput);

	elementQuestion.appendChild(elementVariable);

	//On créer l'élément 
	elementZone.appendChild(elementQuestion);
	document.getElementById("scenario_box").appendChild(elementZone);

	//Reset la langue pour cacher les divs de langues multiples 
	changeLanguage(lang);
	
	//-----------------------------------

}

/* Selectionne un ID de scénario puis
 * cache la fenètre 
 */
function selectID_scenario(){

	id = parseInt(document.getElementById("id_selected").value);
	if(id > 0){
		this.ID_SCENARIO = id;
		console.log("id selected : "+this.ID_SCENARIO);

		element = document.querySelector("[class='select_id']");
		element.style.display = "none";

		hideControls(false);
	}else{
		alert("ID Scenario shoud be a number > 0");
	}
	
}

/* Cache ou affiche les controls 
 * True : hide
 * False : affiche
 */
function hideControls(b){
	elementControls = document.querySelector("[class='controls']");
	if(b){
		elementControls.style.display = "none";
	}else{
		elementControls.style.display = "";
	}
}


/* Copie les les TEXTs et Variable d'une question en DOM  
 * dans un objet Question
 */
function collectQuestion(id){
	elementQuestion = document.getElementById(id);
	var textEN = elementQuestion.children.item(1).value;
	var textFR = elementQuestion.children.item(2).value;
	var textJP = elementQuestion.children.item(3).value;
	var variable = elementQuestion.children.item(4).children.item(1).value;

	var q = findQuestion(id);
	q.textEN = textEN;
	q.textFR = textFR;
	q.textJP = textJP;
	q.nameVariable = variable;

	var nbReplies = 0;
	var isOpenQuestion = true;

	//Vérifie si il y a au moins 1 réponse
	for(var i=0;i<list_replies.length;i++){
		if(list_replies[i].idQuestion == id){
			nbReplies++;
			if(list_replies[i].textEN != "" || list_replies[i].textFR != "" || list_replies[i].textJP != ""){
				isOpenQuestion = false;
			}
		}
	}
	if(nbReplies > 0){
		q.isUserResponse = true;
	}else{
		q.isUserResponse = false;
	}

	if(nbReplies == 1){
		q.isOpenQuestion = isOpenQuestion;
	}else{
		q.isOpenQuestion = false;
	}

	/* Trouve idNextQuestion dans le cas où :
	 * -pas isEnd
	 * -pas de réponse
	 */
	 if(q.isEnd == false && nbReplies == 0){
	 	for(var j=0;j<list_questions.length;j++){
	 		if(list_questions[j].id==id){
	 			if((j+1)<list_questions.length){
	 				q.idNextQuestion = list_questions[j+1].id;
	 			}else{
	 				console.log("Error : no idNextQuestion for question "+id);
	 				alert("Error : no next question for question "+id);
	 			}
	 		}
	 	}
	 }else{
	 	q.idNextQuestion = 0;
	 }
	

}

/* Récupère en DOM les données de toutes les questions
 */
function collectAllQuestions(){
	for(var i=0;i<list_questions.length;i++){
		collectQuestion(list_questions[i].id);
	}
}

/* Génère un fichier Json à partir des
 * scénarios créés
 */
function generateJson(){

	//Enregistre les données des questions
	collectAllQuestions();

	var stringQuestions = jsonAllQuestions();
	//console.log(stringQuestions);

	var stringReplies = jsonAllReplies();
	//console.log(stringReplies);

	var stringRelationsQR = jsonAllRelationsQR();
	//console.log(stringRelationsQR);

	clearJson();
	fillJson(stringQuestions, stringReplies, stringRelationsQR);
	displayJson(true);
}

/* ---------------
 * Pour Bob San
 * ---------------
 */

/* Renvoie une chaine de caractères du Json
 * pour une question 
 */
function jsonQuestion(id){

	var chaine = "{\n";

	var q = findQuestion(id);

	chaine = chaine + '"id": '+q.id+',\n';
	chaine = chaine + '"idScenario": '+ID_SCENARIO+',\n';
	chaine = chaine + '"textEN": "'+q.textEN+'",\n';
	chaine = chaine + '"textFR": "'+q.textFR+'",\n';
	chaine = chaine + '"textJP": "'+q.textJP+'",\n';
	chaine = chaine + '"idNextQuestion": '+q.idNextQuestion+',\n';

	if(q.isOpenQuestion){
		chaine = chaine + '"isOpenQuestion": 1,\n';
	}else{
		chaine = chaine + '"isOpenQuestion": 0,\n';
	}
	if(q.isFirst){
		chaine = chaine + '"isFirst": 1,\n';
	}else{
		chaine = chaine + '"isFirst": 0,\n';
	}
	if(q.isEnd){
		chaine = chaine + '"isEnd": 1,\n';
	}else{
		chaine = chaine + '"isEnd": 0,\n';
	}
	chaine = chaine + '"nameVariable": "'+q.nameVariable+'",\n';
	chaine = chaine + '}\n';

	return chaine;
}

/* Retourne une empty question ou reply
 */
function jsonEmptyID(id){
	var chaine = '{\n"id": '+id+',\n}\n';

	return chaine;
}


/* Renvoie une chaine de caractères du Json
 * pour toutes les questions 
 */
function jsonAllQuestions(){

	var chaine = "";

	for(var i=0; i<list_questions.length;i++){
		chaine = chaine + jsonQuestion(list_questions[i].id);

		//On ajoute les empty questions si nécessaire
		if((i+1)<list_questions.length){
			if((list_questions[i+1].id-list_questions[i].id)>1){
				for(var j=list_questions[i].id+1;j<list_questions[i+1].id;j++){
					chaine = chaine + jsonEmptyID(j);
				}
			}
		}
	}

	//Complète les questions vides jusqu'à la dizaine supérieure
	for(var k=list_questions[list_questions.length-1].id; (k % 10) != 9; k++){
		chaine = chaine + jsonEmptyID(k+1);
	}

	return chaine;
}

/* Renvoie la chaine de caractère d'une réponse
 */
function jsonReply(id){
	var chaine = "{\n";

	var r = findReply(id);

	chaine = chaine + '"id": '+r.id+',\n';
	chaine = chaine + '"idScenario": '+ID_SCENARIO+',\n';
	chaine = chaine + '"textEN": "'+r.textEN+'",\n';
	chaine = chaine + '"textFR": "'+r.textFR+'",\n';
	chaine = chaine + '"textJP": "'+r.textJP+'",\n';
	chaine = chaine + '"idQuestion": "'+r.idNextQuestion+'",\n';
	chaine = chaine + '"dataType": "'+r.dataType+'",\n';
	chaine = chaine + '"dataValue": "'+r.dataValue+'",\n';
	chaine = chaine + '}\n';

	return chaine;

}


/* Renvoie une chaine de caractères de toutes les réponses
 */
function jsonAllReplies(){
	var chaine = "";
	for(var i=0; i<list_replies.length;i++){
		chaine = chaine + jsonReply(list_replies[i].id);

		//On ajoute les empty IDs si nécessaire
		if((i+1)<list_replies.length){
			if((list_replies[i+1].id-list_replies[i].id)>1){
				for(var j=list_replies[i].id+1;j<list_replies[i+1].id;j++){
					chaine = chaine + jsonEmptyID(j);
				}
			}
		}
	}

	//Complète les réponses vides jusqu'à la dizaine supérieure
	for(var k=list_replies[list_replies.length-1].id; (k % 10) != 9; k++){
		chaine = chaine + jsonEmptyID(k+1);
	}

	return chaine;
}


/* Génère une relation QR en fonction d'une réponse
 */
function jsonRelationQR(idReply){

	var r = findReply(idReply);

	//Ne créer pas de relationQR si question ouverte
	var q = findQuestion(r.idQuestion);
	if(q.isOpenQuestion){
		return "";
	}

	var chaine = "{\n";
	chaine = chaine + '"idScenario": '+ID_SCENARIO+',\n';
	chaine = chaine + '"idQuestion": '+r.idNextQuestion+',\n';
	chaine = chaine + '"idReply": '+idReply+',\n';
	chaine = chaine + '}\n';

	return chaine;
}


/* Génère les relations QR
 */
function jsonAllRelationsQR(){
	var chaine = "";

	for(var i=0; i<list_replies.length;i++){
		chaine = chaine + jsonRelationQR(list_replies[i].id);
	}

	return chaine;
}

/* Affiche ou non le pop-up Json
*/
function displayJson(display){
	var element = document.querySelector("[class='json']");
	if(display){
		element.style.display='';
	}else{
		element.style.display='none';
		//clearJson();
	}
}

/* Vide le texte du Json
 */
function clearJson(){
	var element_questions = document.getElementById("json_questions");
	element_questions.children.item(1).innerText = "";
	
	var element_replies = document.getElementById("json_replies");
	element_replies.children.item(1).innerText = "";

	var element_relationsQR = document.getElementById("json_relationsQR");
	element_relationsQR.children.item(1).innerText = "";
}

/* Remplit le Json avec des chaines de caractères
 */
function fillJson(questions, replies, relationsQR){
	var element_questions = document.getElementById("json_questions");
	element_questions.children.item(1).innerText = questions;
	
	var element_replies = document.getElementById("json_replies");
	element_replies.children.item(1).innerText = replies;

	var element_relationsQR = document.getElementById("json_relationsQR");
	element_relationsQR.children.item(1).innerText = relationsQR;
}


/* ------------------
 * A faire :
 * Fonction qui créer une question en DOM V
 * Ajouter choix ID_SCENARIO V
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
 *  - Enregistrer les textEN FR JP dans le modèle V
 *  - Enregistrer les variables dans le modèle V
 *  - Generer Question, Reply, RelationQR pour Bob San V 
 *  - optionnel : générer Question, Reply pour Mei Chan X
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

