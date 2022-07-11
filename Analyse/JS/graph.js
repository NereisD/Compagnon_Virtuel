

function createLabels(){
  labels = [
    'Physically',
    'Mentally',
    'Sociability',
  ];
  return labels;
}

function createDates(){

  dates = [];
  dates.push(listOfMessages[1].getDay());

  for(var i=1; i<listOfMessages.length;i++){
    if(listOfMessages[i].getDay() != dates[dates.length-1]){
      dates.push(listOfMessages[i].getDay());
    }

    //ICI créer les objets Days au fur et a mesure 

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

function createData(){
  data = {
    labels: dates,
    datasets: [{
      label: 'Physically',
      backgroundColor: [
      'rgba(255, 99, 132, 1)'
    ],
      borderColor: 'rgb(255, 0, 0)',
      data: [0, -2, -4, -5, -3, 0, 4],

    },
    {
      label: 'Mentally',
      backgroundColor: [
      'rgba(0, 255, 0, 1)'
    ],
      borderColor: 'rgb(24, 179, 34)',
      data: [0, 2, 1, 3, 5, 8, 4],

    },
    {
      label: 'Sociability',
      backgroundColor: [
      'rgba(31, 179, 208, 1)'
    ],
      borderColor: 'rgb(0, 0, 255)',
      data: [0, -1, -3, -3, -2, -3, -5],

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

