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
    var content = `<table class="table table-striped">
        <thead>
          <tr>
              <th width="20%">First Name</th>
              <th width="20%">Last Name</th>
              <th width="20%">Employee ID</th>
              <th width="20%">Cafe</th>
              <th width="20%">Delete</th>           
            </tr>
          </thead>
          <tbody>`
    $.get("/getEmployees", function (data) {
        console.log(data)
        for (i = 0; i < data.length; i++) {
            content += '<tr>';
            for (j = 0; j < 4; j++) {
                //+ '<span class = "text">'
                //+ '</span>'
                content += '<td>' + data[i][j]  + '</td>';
            }
            content += '<td><i class="glyphicon glyphicon-trash"></i></td>';
            content += '</tr>';
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
    var content = `<table class="table table-striped">
        <thead>
          <tr>
              <th width="25%">Userame</th>
              <th width="25%">Email</th>
              <th width="25%">Favorites</th>
              <th width="25%">Delete</th>           
            </tr>
          </thead>
          <tbody>`
    $.get("/getCustomers", function (data) {
       for (i = 0; i < data.length; i++) {
            content += '<tr>';
            for (j = 0; j < 3; j++) {
                content += '<td>' + data[i][j]  + '</td>';
            }
            content += '<td><i class="glyphicon glyphicon-trash"></i></td>';
            content += '</tr>';
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
    $('#deleteCust').show()
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