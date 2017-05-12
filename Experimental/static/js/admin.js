$(document).ready(function() {
    getEmployees()
});

function getEmployees() {
    //needs employee view
    $('#foodOptions').hide()
    $('#employeeOptions').show()
    $('#customerOptions').hide()
    $('#addEmps').hide()
    $('#deleteEmps').hide()
    $('#deleteCust').hide()
    $('#adminTable').show()
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
    //need customer view
    $('#foodOptions').hide()
    $('#employeeOptions').hide()
    $('#customerOptions').show()
    $('#addEmps').hide()
    $('#deleteEmps').hide()
    $('#deleteCust').hide()
    $('#adminTable').show()
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
    $('#adminTable').hide()
    $('#addEmps').show()
    $('#deleteEmps').hide()
}

function deleteEmployees() {
    $('#adminTable').hide()
    $('#addEmps').hide()
    $('#deleteEmps').show()
}

function deleteCustomers() {
    $('#adminTable').hide()
    $('#deleteCust').hide()
}

function getTopFood() {
    $('#foodOptions').show()
    $('#employeeOptions').hide()
    $('#customerOptions').hide()
    $('#addEmps').hide()
    $('#deleteEmps').hide()
    $('#deleteCust').hide()
    $('#adminTable').show()
    $('#adminTable').empty()
    var content = "<table>"
    $.get("/getTopFood", function (data) {
        for (i = 0; i < data.length; i++) {
            content += '<tr><td>' + '<span class = "text">'+ data[i] + '</b>' + '</span><br>' + '</td></tr>';
        }
        content += "</table>"

        $('#adminTable').append(content);
    });
}

function getBotFood() {
    $('#adminTable').show()
    $('#adminTable').empty()
    var content = "<table>"
    $.get("/getBotFood", function (data) {
        for (i = 0; i < data.length; i++) {
            content += '<tr><td>' + '<span class = "text">'+ data[i] + '</b>' + '</span><br>' + '</td></tr>';
        }
        content += "</table>"

        $('#adminTable').append(content);
    });
}