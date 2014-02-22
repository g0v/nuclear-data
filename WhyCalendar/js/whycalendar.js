var nextday = function (today) {
    return new Date(today.getTime() + 86400000);
}

var getweekday = function (day) {
    var arrDay = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    return arrDay[day.getDay()];
}

var add_cal = function (today, $cal) {
    var month = today.getMonth() + 1;
    var day = today.getDate();
    var weekday = getweekday(today);
    $('<div class="day day-' + day + ' week-' + weekday + '">').html('<p>' + day + '</p>').appendTo($choose_month($cal, month));

}

//如果沒有月份，插入月份的div
$choose_month = function ($cal, month) {
    if ($(cal).children('.month-' + month).length == 0)
        return $('<div class="month month-' + month + '">').html('<h2>' + month + '月</h2>').appendTo($(cal));
    else return $(cal).children('.month-' + month)

}

$(function () {
    var today = new Date("2013-01-01");
    $cal = $('<div id="cal"></div>').appendTo('.wrapper');
    // console.log(choose_month($cal, 1).text('1234'));
    for (var i = 0; i < 365; i++) {

        add_cal(today, $cal);
        today = nextday(today);
    };
});