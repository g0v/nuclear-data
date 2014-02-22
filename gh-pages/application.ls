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
.factory 'API', <[
       $http 
]> ++ ($http) ->
  intervalData: (start, end) ->
    $http(
      url: ''
      method: 'get'
      cache: true
    ).then (response) ->
      console.log response

.controller 'LineChartFormCtrl' do ->

  const prototype = LineChartFormCtrl::

  prototype.plants =
    * name: '核一'
    * name: '核二'
    * name: '核三'

  LineChartFormCtrl.$inject = <[ $scope  API ]>

  !function LineChartFormCtrl ($scope, API)
    void

