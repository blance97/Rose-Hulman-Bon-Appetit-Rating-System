$(function () {
    $(document).on('show', '.accordion', function (e) {
        //$('.accordion-heading i').toggleClass(' ');
        $(e.target).prev('.accordion-heading').addClass('accordion-opened');
    });

    $(document).on('hide', '.accordion', function (e) {
        $(this).find('.accordion-heading').not($(e.target)).removeClass('accordion-opened');
        //$('.accordion-heading i').toggleClass('fa-chevron-right fa-chevron-down');
    });
    $.get("/getHours", function (data) {
        console.log("GET DATA");
        console.log(data)
        var content = "<div>"
        for (i = 0; i < data.length; i++) {
            content += '<td>' + data[i] + '</td>'
        }
        content += "</div>"

        $('#getHours').append(content);
    });
    var content = "<table>"
    $.get("/getMoench", function (data) {
        for (i = 0; i < data.length; i++) {
            content += '<tr><td>' + '<span class = "text">' + '<b>FOOD: ' + data[i] + '</b>' + '</span><br>' + '<span class="vote"></span><br>' + '<span class="downVote"></span>' + '<img src="static/pepe.jpg">' + '</td></tr>';
        }
        content += "</table>"

        $('#here_table').append(content);
        $('.vote').click(function () {
            $(this).toggleClass('on');
        });
        $('.downVote').click(function () {
            $(this).toggleClass('on');
        });
    });
});
function getBreakfast() {
    $('#here_table').empty()
    var content = "<table>"
    $.get("/getBreakfast", function (data) {

        for (i = 0; i < data.length; i++) {
            content += '<tr><td>' + '<span class = "text">' + '<b>FOOD: ' + data[i] + '</b>' + '</span><br>' + '<span class="vote"></span><br>' + '<span class="downVote"></span>' + '<img src="static/pepe.jpg">' + '</td></tr>';
        }
        content += "</table>"

        $('#here_table').append(content);
        $('.vote').click(function () {
            $(this).toggleClass('on');
        });
        $('.downVote').click(function () {
            $(this).toggleClass('on');
        });
    });
}
function getLunch() {
    $('#here_table').empty()
    var content = "<table>"
    $.get("/getLunch", function (data) {

        for (i = 0; i < data.length; i++) {
            content += '<tr><td>' + '<span class = "text">' + '<b>FOOD: ' + data[i] + '</b>' + '</span><br>' + '<span class="vote"></span><br>' + '<span class="downVote"></span>' + '<img src="static/pepe.jpg">' + '</td></tr>';
        }
        content += "</table>"

        $('#here_table').append(content);
        $('.vote').click(function () {
            $(this).toggleClass('on');
        });
        $('.downVote').click(function () {
            $(this).toggleClass('on');
        });
    });
}

function getDinner() {
    $('#here_table').empty()
    var content = "<table>"
    $.get("/getDinner", function (data) {

        for (i = 0; i < data.length; i++) {
            content += '<tr><td>' + '<span class = "text">' + '<b>FOOD: ' + data[i] + '</b>' + '</span><br>' + '<span class="vote"></span><br>' + '<span class="downVote"></span>' + '<img src="static/pepe.jpg">' + '</td></tr>';
        }
        content += "</table>"

        $('#here_table').append(content);
        $('.vote').click(function () {
            $(this).toggleClass('on');
        });
        $('.downVote').click(function () {
            $(this).toggleClass('on');
        });
    });
}
function getMoench() {
    $('#here_table').empty()
    var content = "<table>"
    $.get("/getMoench", function (data) {

        for (i = 0; i < data.length; i++) {
            content += '<tr><td>' + '<span class = "text">' + '<b>FOOD: ' + data[i] + '</b>' + '</span><br>' + '<span class="vote"></span><br>' + '<span class="downVote"></span>' + '<img src="static/pepe.jpg">' + '</td></tr>';
        }
        content += "</table>"

        $('#here_table').append(content);
        $('.vote').click(function () {
            $(this).toggleClass('on');
        });
        $('.downVote').click(function () {
            $(this).toggleClass('on');
        });
    });
}


