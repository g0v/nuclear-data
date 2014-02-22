var arrDay = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

var nextday = function (today) {
    return new Date(today.getTime() + 86400000);
}

var getweekday = function (day) {
    return arrDay[day.getDay()];
}

var add_cal = function (today, $cal) {
    var month = today.getMonth() + 1;
    var day = today.getDate();
    var weekday = getweekday(today);
    var strfullday = today.getFullYear() + "-" + month + "-" + day;
    var isfirst = "";
    if (day == 1) {
        for (var i = 0; i < today.getDay(); i++) {
            $choose_month($cal, month).append($('<div class="day none">'));
        }
        isfirst = " firstday";

    }
    $('<div class="day day-' + strfullday + ' week-' + weekday + isfirst + '">').html('<p>' + day + '</p>').attr('data-date', strfullday).appendTo($choose_month($cal, month));

}

//如果沒有月份，插入月份的div
$choose_month = function ($cal, month) {
    if ($(cal).children('.month-' + month).length == 0) {
        var $month = $('<div class="month month-' + month + '">').html('<h2>' + month + '月</h2>').appendTo($(cal));
        return $month;
    } else return $(cal).children('.month-' + month)

}


$(function () {
    var today = new Date("2013-01-01");
    $cal = $('<div id="cal"></div>').appendTo('.wrapper').append($('<h1>2013年</h1>'));
    // console.log(choose_month($cal, 1).text('1234'));
    for (var i = 0; i < 365; i++) {

        add_cal(today, $cal);
        today = nextday(today);
    };
    for (var i = 1; i <= 12; i++) {
        $('.month-' + i).addClass('lastday');

    }

});