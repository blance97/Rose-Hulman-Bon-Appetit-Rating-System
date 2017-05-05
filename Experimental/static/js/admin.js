$(document).ready(function() {
    getEmployees()
});

function getEmployees() {
    $('#adminTable').empty()
    var content = "<table>"
    $.get("/getEmployees", function (data) {
        for (i = 0; i < data.length; i++) {
            content += '<tr><td>' + '<span class = "text">'+ data[i] + '</b>' + '</span><br>' + '</td></tr>';
        }
        content += "</table>"

        $('#adminTable').append(content);
    });
}

function getCustomers() {
    $('#adminTable').empty()
    var content = "<table>"
    $.get("/getCustomers", function (data) {

        for (i = 0; i < data.length; i++) {
            content += '<tr><td>' + data[i] + '</b>' + '</span><br>' + '</td></tr>';
        }
        content += "</table>"

        $('#adminTable').append(content);
    });
}

function addEmployees() {
    
}