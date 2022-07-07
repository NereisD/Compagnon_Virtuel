

function analyse(){
	console.log("analyse ...");

	var content = document.getElementById('content').value;
	//console.log("content = "+content);

	var nbMessages = content.count("}");
	//console.log(nbMessages);

	var splitContent = content.split("}");
	//console.log(splitContent);

	for(var i=0; i<nbMessages; i++){
		createMessage(splitContent[i]);
	}

}

//Fonction qui compte le nombre d'occurences d'un caractère
String.prototype.count=function(c) { 
  var result = 0, i = 0;
  for(i;i<this.length;i++)if(this[i]==c)result++;
  return result;
}

//Créer un objet Message a partir d'une chaine de caractères
function createMessage(s){
	console.log(s);
	//parser les strings de chaque message 
}