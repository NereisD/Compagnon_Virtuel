
class Reply{
	
	constructor(id, idScenario, idPreviousQuestion, idNextQuestion){
		this.id = id;
		this.idScenario = idScenario;
		this.textEN = ""; //Bob san
		this.textFR = ""; //Bob san
		this.textJP = ""; //Bob san
		this.analysisEN = ""; //Mei chan
		this.analysisFR = ""; //Mei chan
		this.analysisJP = ""; //Mei chan
		this.idQuestion = idPreviousQuestion; //Pour Bob : relationQR
		this.idNextQuestion = idNextQuestion;
		this.nameVariable = ""; //Bob san
		this.dataType = "";
		this.dataValue = 0;


	}


}


