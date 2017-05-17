var socket = null;
$(function () {
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
    $("#user").html('<a href="#5">' + getUser());
    getMoench(); // how moench food first
});

function upvote(foodID){
    console.log("upvote");
       $.ajax({
        type: "GET",
        url: "/upvote?food=" + foodID + "&username=" + getUser(),
        contentType: "application/json; charset=utf-8",
        async: false,
        success: function(data) {
        console.log("cliked "  )
            console.log("User: %s Updvodted %d",getUser(),foodID)
        }
    })
}

function getBreakfast() {
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

           content += '<tr><td>' + data[i]['FoodName'] + '<br/><i class="glyphicon glyphicon-star"></i>Rating: 25<br/><a href="ratings/?food=' + data[i]['FoodID'] + '">Comments</a></td>'
                + '<td>' + restrictionData(data[i]['Kosher'], 'kosher')
            content += restrictionData(data[i]['vegan'], 'vegan') 
            content += restrictionData(data[i]['glutenFree'], 'glutenFree') 
            content += restrictionData(data[i]['vegetarian'] , 'vegetarian')
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
        success: function(data) {
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
        success: function(data) {
        console.log("cliked "  )
            window.location = "/";
        }
    })
}
	/*<li class="list-group-item">
		<i class="glyphicon glyphicon-chevron-up" @click="upvote"></i>
		<span class="label label-primary">{{ votes }}</span>
		<i class="glyphicon glyphicon-chevron-down" @click="downvote"></i>
		<a>{{ post.title }}</a>
	</li>*/
//    <a id="menu-toggle" href="#" class="btn btn-default"><i class="glyphicon glyphicon-arrow-right"></i></a>
function getLunch() {
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
          content += '<tr><td>' + data[i]['FoodName'] + '<br/><ul class="unstyled">'+
          '<a onclick="upvote('+ data[i]['FoodID'] +')"> <i class="glyphicon glyphicon-chevron-up"></i></a>' +
		  '<span class="label label-primary" style="font-size: 17px;" id="votes"> 24</span></br>' +
		  '<a onclick="downvote('+ data[i]['FoodID'] +')"><i class="glyphicon glyphicon-chevron-down"></i></a>' +
	      '</ul>' +
          '<br/><a href="ratings/?food=' + data[i]['FoodID'] + '">Comments</a></td>'
                + '<td>' + restrictionData(data[i]['Kosher'], 'kosher')
            content += restrictionData(data[i]['vegan'], 'vegan') 
            content += restrictionData(data[i]['glutenFree'], 'glutenFree') 
            content += restrictionData(data[i]['vegetarian'] , 'vegetarian')
            content += '</td></tr>'
        }
        content += "</tbody></table>"
        $('#here_table').append(content);
    });
}




function getDinner() {
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
            content += '<tr><td>' + data[i]['FoodName'] 
            + '<br/><i class="glyphicon glyphicon-star"></i>Rating: 25<br/><a href="ratings/?food=' 
            + data[i]["FoodID"] + '">Comments</a></td>'
                + '<td>' + restrictionData(data[i]['Kosher'], 'kosher')
            content += restrictionData(data[i]['vegan'], 'vegan') 
            content += restrictionData(data[i]['glutenFree'], 'glutenFree') 
            content += restrictionData(data[i]['vegetarian'] , 'vegetarian')
            content += '</td></tr>'
        }
        content += "</tbody></table>"

        $('#here_table').append(content);
    });
};
function getMoench() {
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
            content += '<tr><td>' + data[i]['FoodName'] + '<br/><i class="glyphicon glyphicon-star"></i>Rating: 25<br/><a href="ratings/?food=' + data[i]['FoodID'] + '">Comments</a></td>'
                + '<td>' + restrictionData(data[i]['Kosher'], 'kosher')
            content += restrictionData(data[i]['vegan'], 'vegan') 
            content += restrictionData(data[i]['glutenFree'], 'glutenFree') 
            content += restrictionData(data[i]['vegetarian'] , 'vegetarian')
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



