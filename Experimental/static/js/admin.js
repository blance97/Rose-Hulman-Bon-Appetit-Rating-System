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
            content += '</tr>';
        }
        content += "</tbody></table>"

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
        content += "</tbody></table>"

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
    var content = `<div class="food-table"><table class="table table-striped">
        <thead>
          <tr>
              <th width="25%">Food</th>
              <th width="25%">Description</th>
              <th width="25%">Rating</th>         
            </tr>
          </thead>
          <tbody>`
    $.get("/getTopFood", function (data) {
        for (i = 0; i < data.length; i++) {
             content += '<tr>'
            for (j = 0; j < 3; j++) {
                content += '<td>' + data[i][j] + '</td>';
            }
            content += '</tr>';
        }
        content += "</tbody></table></div>"

        $('#adminTable').append(content);
    });
}

function getBotFood() {
    $('#adminTable').show()
    $('#adminTable').empty()
    var content = `<div class="food-table"><table class="table table-striped">
        <thead>
          <tr>
              <th width="25%">Food</th>
              <th width="25%">Description</th>
              <th width="25%">Rating</th>         
            </tr>
          </thead>
          <tbody>`
    $.get("/getBotFood", function (data) {
        for (i = 0; i < data.length; i++) {
             content += '<tr>'
            for (j = 0; j < 3; j++) {
                content += '<td>' + data[i][j] + '</td>';
            }
            content += '</tr>';
        }
        content += "</tbody></table></div>"

        $('#adminTable').append(content);
    });
}