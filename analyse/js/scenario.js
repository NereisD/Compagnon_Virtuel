
/* Site utile pour les selecteurs du DOM 
 * https://www.w3schools.com/cssref/css_selectors.asp
*/


/* Variable langue
 * 0 = En
 * 1 = Fr
 0 2 = Jp
 */
var lang = 0;
changeLanguage(lang)



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





