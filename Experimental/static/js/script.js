var mealState = 0;
$(function () {
    checklogin();
    $.get("/getHours", function (data) {
        $('#search').hide()
        console.log("GET DATA");
        console.log(data)
        var content = `<table class="table table-striped">
        <thead>
          <tr>
              <th width="20%">Cafe</th>
              <th width="20%">Location</th>
              <th width="60%">Hours</th>       
            </tr>
          </thead>
          <tbody>`
        for (i = 0; i < data.length; i++) {
            content += '<tr>'
            for (j = 0; j < 3; j++) {
                content += '<td>' + data[i][j] + '</td>'
            }
            content += '</tr>'
        }
        content += "</tbody></table>"
        $('#getHours').show();
        $('#getHours').append(content);
    });
    getServingLocaiton()
    $("#user").html('<a href="#5">' + getUser());

});

function getServingLocaiton() {
    $.get("/getServingLocation", function (data) {
        console.log("GET DATA2");
        console.log(data)
        var content = `<table class="table table-striped">
        <thead>
          <tr>
              <th width="50%">Serving Name</th>
              <th width="50%">Cafe Name</th>      
            </tr>
          </thead>
          <tbody>`
        for (i = 0; i < data.length; i++) {
            content += '<tr>'
            for (j = 0; j < 2; j++) {
                content += '<td>' + data[i][j] + '</td>'
            }
            content += '</tr>'
        }
        content += "</tbody></table>"
        $('#getServing').show();
        $('#getServing').append(content);
    });
}

function search() {
    console.log("search");
    $.ajax({
        type: "GET",
        url: "/search?query=" + foodID + "&meal=" + mealState,
        contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            console.log(data);
        }
    })
}

function upvote(foodID) {
    checklogin();
    console.log("upvote");
    $.ajax({
        type: "GET",
        url: "/upvote?food=" + foodID + "&username=" + getUser(),
        contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            switch (mealState) {
                case 1:
                    getBreakfast();
                    break;
                case 2:
                    getLunch();
                    break;
                case 3:
                    getDinner();
                    break;
                case 4:
                    getMoench();
                    break;
            }
            console.log("cliked ")
            console.log("User: %s Updvodted %d", getUser(), foodID)
        }
    })
}

function downvote(foodID) {
    checklogin();
    $.ajax({
        type: "GET",
        url: "/downvote?food=" + foodID + "&username=" + getUser(),
        contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            switch (mealState) {
                case 1:
                    getBreakfast();
                    break;
                case 2:
                    getLunch();
                    break;
                case 3:
                    getDinner();
                    break;
                case 4:
                    getMoench();
                    break;
            }
            console.log("DOWNVOTE")
        }
    })
}

function getBreakfast() {
    checklogin();
    $('#search').show();
    $('#getServing').hide();
    mealState = 1;
    $('#getHours').hide();
    $('#here_table').empty()
    var content = "<table>"
    $.get("/getBreakfast", function (data) {
        var content = `<table class="table table-striped">
        <thead>
          <tr>
              <th width="70%">Food</th>
              <th width="30%">Dietary Restrictions</th>        
            </tr>
          </thead>
          <tbody>`
        for (i = 0; i < data.length; i++) {
            content += '<tr><td>' + data[i]['FoodName'] + '<br/><ul class="unstyled">' +
                '<a onclick="upvote(' + data[i]['FoodID'] + ')"> <i class="glyphicon glyphicon-chevron-up"></i></a>' +
                '<span class="label label-primary" style="font-size: 17px;" id="votes">' + getFoodRating(data[i]['FoodID']) + '</span></br>' +
                '<a onclick="downvote(' + data[i]['FoodID'] + ')"><i class="glyphicon glyphicon-chevron-down"></i></a>' +
                '</ul>' +
                '<br/><a href="ratings/?food=' + data[i]['FoodID'] + '">Comments</a></td>'
                + '<td>' + restrictionData(data[i]['Kosher'], 'kosher')
            content += restrictionData(data[i]['vegan'], 'vegan')
            content += restrictionData(data[i]['glutenFree'], 'glutenFree')
            content += restrictionData(data[i]['vegetarian'], 'vegetarian')
            content += '</td></tr>'
        }
        content += "</tbody></table>"

        $('#here_table').append(content);
    });
}

function getUser() {
    var Username
    var request = $.ajax({
        type: 'GET',
        url: '/getUser',
        async: false,
        success: function (data) {
            //var obj = jQuery.parseJSON(data)
            console.log(data[0][0])
            Username = data[0][0];
        }
    });
    return Username
}

function logout() {
    $.ajax({
        type: "GET",
        url: "/logout",
        contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            console.log("cliked ")
            window.location = "/";
        }
    })
}

function getLunch() {
    $('#search').show();
    $('#getServing').hide();
    checklogin();
    mealState = 2;
    $('#getHours').hide();
    $('#here_table').empty()
    var content = `<table class="table table-striped">
        <thead>
          <tr>
              <th width="70%">Food</th>
              <th width="30%">Dietary Restrictions</th>        
            </tr>
          </thead>
          <tbody>`
    $.get("/getLunch", function (data) {
        for (i = 0; i < data.length; i++) {
            content += '<tr><td>' + data[i]['FoodName'] + '<br/><ul class="unstyled">' +
                '<a onclick="upvote(' + data[i]['FoodID'] + ')"> <i class="glyphicon glyphicon-chevron-up"></i></a>' +
                '<span class="label label-primary" style="font-size: 17px;" id="votes">' + getFoodRating(data[i]['FoodID']) + '</span></br>' +
                '<a onclick="downvote(' + data[i]['FoodID'] + ')"><i class="glyphicon glyphicon-chevron-down"></i></a>' +
                '</ul>' +
                '<br/><a href="ratings/?food=' + data[i]['FoodID'] + '">Comments</a></td>'
                + '<td>' + restrictionData(data[i]['Kosher'], 'kosher')
            content += restrictionData(data[i]['vegan'], 'vegan')
            content += restrictionData(data[i]['glutenFree'], 'glutenFree')
            content += restrictionData(data[i]['vegetarian'], 'vegetarian')
            content += '</td></tr>'
        }
        content += "</tbody></table>"
        $('#here_table').append(content);
    });
}


function getFoodRating(foodid) {
    checklogin();
    var foodRating = 0;
    $.ajax({
        type: "GET",
        url: "/foodRating?foodid=" + foodid,
        contentType: "application/json; charset=utf-8",
        async: false,
        success: function (data) {
            console.log(data)
            foodRating = data;
        }
    });
    return foodRating;
}

function getDinner() {
    $('#search').show();
    $('#getServing').hide();
    checklogin();
    mealState = 3;
    $('#getHours').hide();
    $('#here_table').empty()
    var content = `<table class="table table-striped">
        <thead>
          <tr>
              <th width="70%">Food</th>
              <th width="30%">Dietary Restrictions</th>        
            </tr>
          </thead>
          <tbody>`
    $.get("/getDinner", function (data) {
        for (i = 0; i < data.length; i++) {
            content += '<tr><td>' + data[i]['FoodName'] + '<br/><ul class="unstyled">' +
                '<a onclick="upvote(' + data[i]['FoodID'] + ')"> <i class="glyphicon glyphicon-chevron-up"></i></a>' +
                '<span class="label label-primary" style="font-size: 17px;" id="votes">' + getFoodRating(data[i]['FoodID']) + '</span></br>' +
                '<a onclick="downvote(' + data[i]['FoodID'] + ')"><i class="glyphicon glyphicon-chevron-down"></i></a>' +
                '</ul>' +
                '<br/><a href="ratings/?food=' + data[i]['FoodID'] + '">Comments</a></td>'
                + '<td>' + restrictionData(data[i]['Kosher'], 'kosher')
            content += restrictionData(data[i]['vegan'], 'vegan')
            content += restrictionData(data[i]['glutenFree'], 'glutenFree')
            content += restrictionData(data[i]['vegetarian'], 'vegetarian')
            content += '</td></tr>'
        }
        content += "</tbody></table>"

        $('#here_table').append(content);
    });
};
function getMoench() {
    $('#search').show();
    $('#getServing').hide();
    checklogin();
    mealState = 4;
    $('#getHours').hide();
    $('#here_table').empty()
    var content = `<table class="table table-striped">
        <thead>
          <tr>
              <th width="70%">Food</th>
              <th width="30%">Dietary Restrictions</th>        
            </tr>
          </thead>
          <tbody>`
    $.get("/getMoench", function (data) {
        console.log(data)
        for (i = 0; i < data.length; i++) {
            content += '<tr><td>' + data[i]['FoodName'] + '<br/><ul class="unstyled">' +
                '<a onclick="upvote(' + data[i]['FoodID'] + ')"> <i class="glyphicon glyphicon-chevron-up"></i></a>' +
                '<span class="label label-primary" style="font-size: 17px;" id="votes">' + getFoodRating(data[i]['FoodID']) + '</span></br>' +
                '<a onclick="downvote(' + data[i]['FoodID'] + ')"><i class="glyphicon glyphicon-chevron-down"></i></a>' +
                '</ul>' +
                '<br/><a href="ratings/?food=' + data[i]['FoodID'] + '">Comments</a></td>'
                + '<td>' + restrictionData(data[i]['Kosher'], 'kosher')
            content += restrictionData(data[i]['vegan'], 'vegan')
            content += restrictionData(data[i]['glutenFree'], 'glutenFree')
            content += restrictionData(data[i]['vegetarian'], 'vegetarian')
            content += '</td></tr>'
        }
        content += "</tbody></table>"

        $('#here_table').append(content);
    });
}

function restrictionData(data, type) {
    toReturn = ""
    switch (type) {
        case "kosher":
            if (data == 't') {
                toReturn = "Kosher ";
            }
            break;
        case "vegan":
            if (data == 't') {
                toReturn = "vegan ";
            }
            break;
        case "vegetarian":
            if (data == 't') {
                toReturn = "vegetarian ";
            }
            break;
        case "glutenFree":
            if (data == 't') {
                toReturn = "gluten free ";
            }
            break;
    }
    // console.log("Returning for %s, Result: %s",type, toReturn)
    return toReturn;
}


function checklogin() {
    console.log("check login");
    // var request = $.ajax({
    //     type: 'GET',
    //     url: '/checkLogin',
    //     async: false,
    //     success: function(data) {
    //         //var obj = jQuery.parseJSON(data)
    //     }
    // });

}