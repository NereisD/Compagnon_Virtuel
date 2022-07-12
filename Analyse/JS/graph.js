

function createLabels(){
  labels = [
    'Physically',
    'Mentally',
    'Sociability',
  ];
  return labels;
}

function createDates(days){

  dates = [];
  var currentDay = listOfMessages[1].getDay();
  dates.push(currentDay);
  days.push(new Day(listOfMessages[1].date));

  for(var i=1; i<listOfMessages.length;i++){
    currentDay = listOfMessages[i].getDay();

    //On créer un nouveau jour si on change de date
    if(listOfMessages[i].getDay() != dates[dates.length-1]){

      //Création des dates
      dates.push(currentDay);

      //Création des objets Days
      days.push(new Day(listOfMessages[i].date));
      if(days.length>1){
        days[days.length-1].cumulatedPhysically = days[days.length-2].cumulatedPhysically;
        days[days.length-1].cumulatedMentally = days[days.length-2].cumulatedMentally;
        days[days.length-1].cumulatedSociability = days[days.length-2].cumulatedSociability;
      }
    }

    //Update des variables du jour
    if(days.length>0){

      if(listOfMessages[i].dataType.includes("physically")){
        days[days.length-1].physically = parseInt(days[days.length-1].physically) + parseInt(listOfMessages[i].dataValue);
        days[days.length-1].cumulatedPhysically = parseInt(days[days.length-1].cumulatedPhysically) + parseInt(listOfMessages[i].dataValue);
      } 
      if(listOfMessages[i].dataType.includes("mentally")){
        days[days.length-1].mentally = parseInt(days[days.length-1].mentally) + parseInt(listOfMessages[i].dataValue);
        days[days.length-1].cumulatedMentally = parseInt(days[days.length-1].cumulatedMentally) + parseInt(listOfMessages[i].dataValue);
      } 
      if(listOfMessages[i].dataType.includes("sociability")){
        days[days.length-1].sociability = parseInt(days[days.length-1].sociability) + parseInt(listOfMessages[i].dataValue);
        days[days.length-1].cumulatedSociability = parseInt(days[days.length-1].cumulatedSociability) + parseInt(listOfMessages[i].dataValue);
      } 
    }

  }

  /*
  dates = [
    '01/07',
    '02/07',
    '03/07',
    '04/07',
    '05/07',
    '06/07',
  ];*/
  return dates;
}

//Création d'une liste physically cumulée
function createCumulatedPhysically(days){
  var cumulatedPhysically = [];

  for(var i=0; i<days.length; i++){
    cumulatedPhysically[i]=parseInt(days[i].cumulatedPhysically);
  }
  return cumulatedPhysically;
}

//Création d'une liste mentally cumulée
function createCumulatedMentally(days){
  var cumulatedMentally = [];

  for(var i=0; i<days.length; i++){
    cumulatedMentally[i]=parseInt(days[i].cumulatedMentally);
  }
  return cumulatedMentally;
}

//Création d'une liste sociability cumulée 
function createCumulatedSociability(days){
  var cumulatedSociability = [];

  for(var i=0; i<days.length; i++){
    cumulatedSociability[i]=parseInt(days[i].cumulatedSociability);
  }
  return cumulatedSociability;
}

function createData(cumulatedPhysically,cumulatedMentally,cumulatedSociability){
  data = {
    labels: dates,
    datasets: [{
      label: 'Physically',
      backgroundColor: [
      'rgba(255, 99, 132, 1)'
    ],
      borderColor: 'rgb(255, 0, 0)',
      data: cumulatedPhysically,

    },
    {
      label: 'Mentally',
      backgroundColor: [
      'rgba(0, 255, 0, 1)'
    ],
      borderColor: 'rgb(24, 179, 34)',
      data: cumulatedMentally,

    },
    {
      label: 'Sociability',
      backgroundColor: [
      'rgba(31, 179, 208, 1)'
    ],
      borderColor: 'rgb(0, 0, 255)',
      data: cumulatedSociability,

    },
    ]
  };

  return data;
}

function createConfig(){

  config = {
    type: 'line',
    data: data,
  };
  return config;
}



function countgraph(datas) {
  const i = 0;
  if (i == datas.length) {
    i = 0
  }else{
    return i+1;
  }
}

function createGraph2(){

const datas = [[6, 5, -8],[6, 5, -8],[6, 5, -8]];

const data2 = {
  labels: labels,
  datasets: [{
    label: 'My First Dataset',
    data: datas[countgraph(datas)],
    backgroundColor: [
      'rgba(255, 99, 132, 0.2)',
      'rgba(255, 159, 64, 0.2)',
      'rgba(255, 205, 86, 0.2)',

    ],
    borderColor: [
      'rgb(255, 99, 132)',
      'rgb(255, 159, 64)',
      'rgb(255, 205, 86)',

    ],
    borderWidth: 1
  }]
};

const config2 = {
  type: 'bar',
  data: data2,
  options: {
    scales: {
      y: {
        beginAtZero: true
      }
    }
  },
};


const myChart = new Chart(
  document.getElementById('myChart'),
  config
);

const barChart = new Chart(
  document.getElementById('barChart0'),
  config2
);

createDataPlot();

//End of function createGraph2()
}

//fonction permettant de creer la div et le canvas pour une bar Chart
function createDOMChart(params) {
  var carousselDOM = document.getElementById("caroussel");
  //creation de la div carousel item
  var divDOM = document.createElement("div");
  divDOM.setAttribute("class", "carousel-item");
      
  //creation de la balise canvas
  var canvasDOM = document.createElement("canvas");
  canvasDOM.setAttribute("id", "barChart"+params);
  
  divDOM.append(canvasDOM);
  carousselDOM.appendChild(divDOM);
  
  return canvasDOM;
}

//fonction permettant de creer la div et le canvas pour une bar Chart
function createDOMChartActive(params) {
  var carousselDOM = document.getElementById("caroussel");
  //creation de la div carousel item
  var divDOM = document.createElement("div");
  divDOM.setAttribute("class", "carousel-item active");
          
  //creation de la balise canvas
  var canvasDOM = document.createElement("canvas");
  canvasDOM.setAttribute("id", "barChart"+params);
      
  divDOM.append(canvasDOM);
  carousselDOM.appendChild(divDOM);
      
  return canvasDOM;
}


function createDataPlot() {

  //creation de la premiere semaine pour set le caroussel avec un chart active
  new Chart(
    createDOMChartActive(0),
    {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [{
          label: 'semaine 0',
          data: [Math.floor(Math.random() * 50), -Math.floor(Math.random() * 50), Math.floor(Math.random() * 50)],
          backgroundColor: [
            'rgba(255, 99, 132, 0.2)',
            'rgba(255, 159, 64, 0.2)',
            'rgba(255, 205, 86, 0.2)',
          
          ],
          borderColor: [
            'rgb(255, 99, 132)',
            'rgb(255, 159, 64)',
            'rgb(255, 205, 86)',
          
          ],
          borderWidth: 1
        }]
      },
      options: {
        scales: {
          y: {
            beginAtZero: true
          }
        }
      },
    }
  );

  const nbWeeks = 8;
  var tabplot = {};

  //creation des autres semaine pour le caroussel
  for (let i = 1; i < nbWeeks; i++) {

    tabplot[i] = new Chart(
      createDOMChart(i),
      {
        type: 'bar',
        data: {
          labels: labels,
          datasets: [
            {
            label: 'semaine '+ i,
            data: [Math.floor(Math.random() * 50), -Math.floor(Math.random() * 50), Math.floor(Math.random() * 50)],
            backgroundColor: [
              'rgba(255, 99, 132, 0.2)',
              'rgba(255, 159, 64, 0.2)',
              'rgba(255, 205, 86, 0.2)',
              
            ],
            borderColor: [
              'rgb(255, 99, 132)',
              'rgb(255, 159, 64)',
              'rgb(255, 205, 86)',
            
            ],
            borderWidth: 1
          }
          ]
        },
        options: {
          scales: {
            y: {
              beginAtZero: true
            }
          }
        },
      }
    );
  }
}

