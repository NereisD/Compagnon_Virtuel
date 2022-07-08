
class Message{
	constructor(id, date, text, isSentByMe, isLiked, isSecret, dataType, dataValue){
		this.id = id;
		this.date = date;
		this.text = text;
		this.isSentByMe = isSentByMe;
		this.isLiked = isLiked;
		this.isSecret = isSecret;
		this.dataType = dataType;
		this.dataValue = dataValue;
	}

	affiche(){
		console.log("id : "+this.id+" date : "+this.date+" text : "+this.text+" isSentByMe : "+this.isSentByMe+" isLiked : "+this.isLiked+" isSecret : "+this.isSecret+" dataType : "+this.dataType+ " dataValue : "+this.dataValue);
	}


	getDate(){
		return this.date;
	}

	getAnnee(){
		return this.date.substr(0,4)
	}

	getMois(){
		return this.date.substr(5,2);
	}

	getJour(){
		return this.date.substr(8,2);
	}

	getDataValue(){
		return this.dataValue;
	}

	getDataValue(){
		return this.dataType;
	}

}