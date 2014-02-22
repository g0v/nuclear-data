google.load 'visualization', '1.0', 'packages': <[ corechart ]>

angular.module 'demo' <[ checklist-model ]>
.factory 'GChart' <[
       $q
]> ++ ($q) ->

  const defer = $q.defer!
  
  
  google.setOnLoadCallback !-> defer.resolve google.visualization

  defer.promise

.factory 'API', <[
       $http  $q 
]> ++ ($http, $q) ->
  const mock = { 'data': [ {'t': 1393082562, 'powersets': [
    {'planet': '\u6838\u4e00', 'aec': 656.0, 'capacity': 636.0, 'powerset': '1', 'tai': 627.5}, {'planet': '\u6838\u4e00', 'aec': 636.0, 'capacity': 636.0, 'powerset': '2', 'tai': 597.7}, {'planet': '\u6838\u4e8c', 'aec': 1028.0, 'capacity': 985.0, 'powerset': '1', 'tai': 993.3}, {'planet': '\u6838\u4e8c', 'aec': 693.0, 'capacity': 985.0, 'powerset': '2', 'tai': 664.9}, {'planet': '\u6838\u4e09', 'aec': 980.0, 'capacity': 951.0, 'powerset': '1', 'tai': 941.5}, {'planet': '\u6838\u4e09', 'aec': 976.0, 'capacity': 951.0, 'powerset': '2', 'tai': 938.1}]}, ... ] }

  intervalData: (query) ->
    query = angular.copy query || {}
    # $http(
    #   url: ''
    #   method: 'get'
    #   cache: true
    # ).then (response) ->
    #   console.log response

    $q.when data: mock .then ({data}) ->
      angular.copy data .data.map ->
        it.powersets.= filter (powerset) ->
          const [plant] = query.plants.filter -> it.name is powerset.planet and it.powerset is powerset.powerset
          !!plant
          
        it


.controller 'LineChartFormCtrl' do ->

  const prototype = LineChartFormCtrl::

  prototype.plants = 
    * name: '核一'
      powerset: '1'
    * name: '核一'
      powerset: '2'
    * name: '核二'
      powerset: '1'
    * name: '核二'
      powerset: '2'
    * name: '核三'
      powerset: '1'
    * name: '核三'
      powerset: '2'

  prototype.updateChart = ([query, data, gvis]) ->
    const aec-data = [['Time'] ++ query.plants.map -> "#{ it.name }##{ it.powerset }"]
    const tai-data = [['Time'] ++ query.plants.map -> "#{ it.name }##{ it.powerset }"]

    data.forEach !->
      aec-data.push [it.t] ++ it.powersets.map (.aec)
      tai-data.push [it.t] ++ it.powersets.map (.tai)

    new gvis.LineChart document.getElementById 'aec-chart'
      ..draw gvis.arrayToDataTable(aec-data), do
        title: '原能會'
        hAxis:
          direction: -1

    new gvis.LineChart document.getElementById 'tai-chart'
      ..draw gvis.arrayToDataTable(tai-data), do
        title: '台電'


  LineChartFormCtrl.$inject = <[ $scope  $q  API  GChart ]>

  !function LineChartFormCtrl ($scope, $q, API, GChart)
    $scope.query = plants: []

    $scope.$watch 'query' !~>
      $q.all [
        angular.copy it
        API.intervalData it
        GChart
      ] .then @updateChart

    , true

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