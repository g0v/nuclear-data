google.load 'visualization', '1.0', 'packages': <[ corechart ]>
google.setOnLoadCallback !->
  const data = google.visualization.arrayToDataTable [
    <[ Year Sales Expenses ]>
    ['2004' 1000 400]
    ['2005' 1170 460]
    ['2006' 660 1120]
    ['2007' 1030 540]
  ]

  const options = do
    title: 'Company Perf'

  const chart = new google.visualization.LineChart document.getElementById 'sample-chart'
  chart.draw data, options


angular.module 'demo' <[]>

