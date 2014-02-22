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

.controller 'CalenderCtrl', <[
       $scope 
]> ++ ($scope) ->

.directive 'generateCal', ->
  (scope, el, attrs) ->
    scope.$watch 'calYear', ->
      $('.wrapper').html('')
      arrDay = [
        "Sun"
        "Mon"
        "Tue"
        "Wed"
        "Thu"
        "Fri"
        "Sat"
      ]
      nextday = (today) ->
        new Date(today.getTime() + 86400000)

      getweekday = (day) ->
        arrDay[day.getDay()]

      add_cal = (today, $cal) ->
        month = today.getMonth() + 1
        day = today.getDate()
        weekday = getweekday(today)
        strfullday = today.getFullYear() + "-" + month + "-" + day
        isfirst = ""
        if day is 1
          i = 0

          while i < today.getDay()
            $choose_month($cal, month).append $("<div class=\"day none\">")
            i++
          isfirst = " firstday"
        $("<div class=\"day day-" + strfullday + " week-" + weekday + isfirst + "\">").html("<p>" + day + "</p>").attr("data-date", strfullday).appendTo $choose_month($cal, month)
        return


      #如果沒有月份，插入月份的div
      $choose_month = ($cal, month) ->
        if $(cal).children(".month-" + month).length is 0
          $month = $("<div class=\"month month-" + month + "\">").html("<h2>" + month + "月</h2>").appendTo($(cal))
          $month
        else
          $(cal).children ".month-" + month

      $ ->
        today = new Date(attrs.year+"-01-01")
        $cal = $("<div id=\"cal\"></div>").appendTo(".wrapper").append($("<h1>"+attrs.year+"年</h1>"))
        
        # console.log(choose_month($cal, 1).text('1234'));
        i = 0

        while i < 365
          add_cal today, $cal
          today = nextday(today)
          i++
        i = 1

        while i <= 12
          $(".month-" + i).addClass "lastday"
          i++
        return