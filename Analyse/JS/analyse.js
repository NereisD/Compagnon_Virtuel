
//List des objets messages
var listOfMessages = [];


function analyse(){
	console.log("analyse ...");

	var content = document.getElementById('content').value;
	//console.log("content = "+content);

	var nbMessages = content.count("}");
	//console.log(nbMessages);

	var splitContent = content.split("{");
	//console.log(splitContent);

	//On ajoute chaque objet dans la liste
	for(var i=0; i<nbMessages; i++){
		listOfMessages.push(createMessage(splitContent[i]));
	}

	//ICI appel de la fonction qui génère les graphes
	var labels = createLabels();
	var days = [];
	var dates = createDates();
	var data = createData();
	var config = createConfig();

	createGraph2();

	//On affiche les graphes 
	afficheGraphes();

}

//Fonction qui compte le nombre d'occurences d'un caractère
String.prototype.count=function(c) { 
  var result = 0, i = 0;
  for(i;i<this.length;i++)if(this[i]==c)result++;
  return result;
}

/* Fonction qui récupère une chaine de caractères comprise
 * entre deux strings 
 */
String.prototype.substringBetween = function (string1, string2) {
  if((this.indexOf(string1, 0) == -1) || (this.indexOf(string2, this.indexOf(string1, 0)) == -1)) {
    return (-1);
  }else{
  	return this.substring((this.indexOf(string1, 0) + string1.length), (this.indexOf(string2, this.indexOf(string1,0))));
  }
};

//Créer un objet Message a partir d'une chaine de caractères
function createMessage(s){
	//parser les strings de chaque message 
	var id = s.substringBetween('"_id":',',"date');
	var date = s.substringBetween('date":"','","text');
	var text = s.substringBetween('"text":"','","isSentByMe');
	var isSentByMe = s.substringBetween('isSentByMe":',',"isLiked');
	var isLiked = s.substringBetween('isLiked":',',"isSecret');
	var isSecret = s.substringBetween('isSecret":',',"dataType');
	var dataType = s.substringBetween('dataType":"','","dataValue');
	var dataValue = s.substringBetween('dataValue":','}');

	return new Message(id, date, text, isSentByMe, isLiked, isSecret, dataType, dataValue);
}

/* Fonction qui retire l'affichage de l'analyse pour
 * afficher les graphes
 */
function afficheGraphes(){
	document.getElementById("addJson").style.display = "none";
	document.getElementById("graphics").style.display = "flex";
}





