
class Question{

	constructor(id, idScenario){
		this.id = id;
		this.idScenario = idScenario;
		this.textEN = "";
		this.textFR = "";
		this.textJP = "";
		this.idNextQuestion = 0; //Bob san
		this.isOpenQuestion = false; //Bob san
		this.isFirst = false;
		this.isEnd = false;
		this.nameVariable = "";
		this.isUserResponse = false; //Mei chan
	}

}




