const labels = [
    'Physically',
    'Mentally',
    'Sociability',
  ];

  const labels2 = [
    '01/07',
    '02/07',
    '03/07',
    '04/07',
    '05/07',
    '06/07',
  ];

  const data = {
    labels: labels2,
    datasets: [{
      label: 'Physically',
      backgroundColor: [
      'rgba(255, 99, 132, 1)',
      'rgba(255, 159, 64, 1)',
      'rgba(255, 205, 86, 1)',
      'rgba(75, 192, 192, 1)',
      'rgba(54, 162, 235, 1)',
      'rgba(153, 102, 255, 1)',
      'rgba(201, 203, 207, 1)'
    ],
      borderColor: 'rgb(255, 0, 0)',
      data: [0, -10, 5, 2, 6, 12, 20],

    },
    {
      label: 'Mentally',
      backgroundColor: [
      'rgba(255, 99, 132, 1)',
      'rgba(255, 159, 64, 1)',
      'rgba(255, 205, 86, 1)',
      'rgba(75, 192, 192, 1)',
      'rgba(54, 162, 235, 1)',
      'rgba(153, 102, 255, 1)',
      'rgba(201, 203, 207, 1)'
    ],
      borderColor: 'rgb(0, 255, 0)',
      data: [0, 10, -5, -2, 10, 1, 8],

    },
    {
      label: 'Sociability',
      backgroundColor: [
      'rgba(255, 99, 132, 1)',
      'rgba(255, 159, 64, 1)',
      'rgba(255, 205, 86, 1)',
      'rgba(75, 192, 192, 1)',
      'rgba(54, 162, 235, 1)',
      'rgba(153, 102, 255, 1)',
      'rgba(201, 203, 207, 1)'
    ],
      borderColor: 'rgb(0, 0, 255)',
      data: [0, 4, 1, -7, 14, 12, 6],

    },
    ]
  };

const config = {
  type: 'line',
  data: data,
};

function countgraph() {
  const i = 0;
  if (i == datas.length) {
    i = 0
  }else{
    console.log(i+1);
    return i+1;
  }
}

const datas =[[6, 5, -8],[6, 5, -8],[6, 5, -8]];

const data2 = {
  labels: labels,
  datasets: [{
    label: 'My First Dataset',
    data: datas[countgraph()],
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
    document.getElementById('barChart'),
    config2
  );
  const barChart2 = new Chart(
    document.getElementById('barChart2'),
    config2
  );
  const barChart3 = new Chart(
    document.getElementById('barChart3'),
    config2
  );
  const barChart4 = new Chart(
    document.getElementById('barChart4'),
    config2
  );