$(document).ready(function() {
    getCafeInfo()
});

function getCafeInfo() {
    $("#employeeDisplay").show();
    $("#foodDisplay").hide();
    $.get("/getEmployeeHours", function (data) {
        console.log(data)
        $('#cafeName').append(data['EmpHours'][0][0]);
        $('#cafeLocation').append(data['EmpHours'][0][1]);
        $('#hours').append(data['EmpHours'][0][2]);
    
     $("#cafeEmployees").empty();
    var content = `<p><b>Employees at Cafe</b></p>
    <table class="table table-striped">
        <thead>
          <tr>
              <th width="20%">First Name</th>
              <th width="20%">Last Name</th>      
            </tr>
          </thead>
          <tbody>`;
    for(var i = 0; i < data['Coworker'].length; i++){
             content += '<tr>';
          for (j = 0; j < data['Coworker'][i].length; j++) {
              content += '<td>' + data['Coworker'][i][j]  + '</td>';
          }
            content += '</tr>';
    }
    $("#cafeEmployees").append(content);
    });
}

function getMenu() {
    $("#employeeDisplay").hide();
    $("#foodDisplay").show();
    $("#breakfast").empty();
    $("#lunch").empty();
    $("#dinner").empty();
    $.get("/getMenuEmployee", function (data) {
        var breakfast = `<table class="table table-striped">
            <thead>
            <tr>
                <th width="20%">Breakfast</th>    
                </tr>
            </thead>
            <tbody>`;
        for(var i = 0; i < data['Breakfast'].length; i++){
                breakfast += '<tr><td>' + data['Breakfast'][i][0]  + '</td></tr>';
        }
        var lunch = `<table class="table table-striped">
            <thead>
            <tr>
                <th width="20%">Lunch</th>    
                </tr>
            </thead>
            <tbody>`;
        for(var i = 0; i < data['Lunch'].length; i++){
                lunch += '<tr><td>' + data['Lunch'][i][0]  + '</td></tr>';
        }
        var dinner = `<table class="table table-striped">
            <thead>
            <tr>
                <th width="20%">Dinner</th>    
                </tr>
            </thead>
            <tbody>`;
        for(var i = 0; i < data['Dinner'].length; i++){
                dinner += '<tr><td>' + data['Dinner'][i][0]  + '</td></tr>';
        }
        $("#breakfast").append(breakfast);
        $("#lunch").append(lunch);
        $("#dinner").append(dinner);
    });
}

function logout() {
        $.ajax({
        type: "GET",
        url: "/logoutEmployee",
        contentType: "application/json; charset=utf-8",
        async: false,
        success: function(data) {
        console.log("cliked "  )
            window.location = "/";
        }
    });
}