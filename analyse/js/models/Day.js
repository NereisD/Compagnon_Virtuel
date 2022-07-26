class Day{

	constructor(date){
		this.date = date;
		this.physically = 0;
		this.mentally = 0;
		this.sociability = 0;
		this.cumulatedPhysically = 0;
		this.cumulatedMentally = 0;
		this.cumulatedSociability = 0;
	}

	getYear(){
		return this.date.substr(0,4)
	}

	getMonth(){
		return this.date.substr(5,2);
	}

	getDay(){
		return this.date.substr(8,2);
	}

}