var foodName
$(function () {
    var labelArray1 = window.location.search.split('=');
    var label = labelArray1[1];
    
    document.title = getFoodName(label);
    $(commentLabel).html("Comment For: " + getFoodName(label));
    $(foodid).val(label);
    $(userID).val(getUser());
    var ts = Math.round((new Date()).getTime() / 1000);
    var datets = new Date(ts * 1000);
     var request = $.ajax({ 
        type: 'GET',
        url: "/getComments/?food=" + label,
        async: true,
        success: function(data) {
            console.log(data);
        var commentsBox = "<ul class='commentList'>"
        for (var i = 0; i < data.length; i++) {
            commentsBox += '<li>'
                    + '<div class="commenterImage">'
                    +    '<b>USER:'+ data[i][2] +'</b>'
                    + '</div>'
                    + '</br>'
                    + '<div class="commentText">'
                    +    '<p class="">' + data[i][0]+ '</p> <span class="date sub-text">'+ timeDifference(datets, getPostDate(data[i][1].substring(0, data[i][1].length-3))); +'</span>'
                   + '</div>'
                + '</li>'

        }
        commentsBox += "</ul>"
        $('#commentBox').append(commentsBox);
        }
    });
  
});

// simpler version of above...
function getPostDate(dateTime){
    console.log("Input date: " + dateTime)
    var ds=dateTime;
    var day=new Date(ds.replace(' ','T')+'Z');
    console.log(day.toUTCString());
    return day;
}


function getFoodName(foodid) {
      var Username
    var request = $.ajax({
        type: 'GET',
        url: '/getFoodName/?food=' + foodid,
        async: false,
        success: function(data) {
            foodName = data;
        }
    });
    return foodName;
}




function timeDifference(current, previous) {

    var msPerMinute = 60 * 1000;
    var msPerHour = msPerMinute * 60;
    var msPerDay = msPerHour * 24;
    var msPerMonth = msPerDay * 30;
    var msPerYear = msPerDay * 365;

    var elapsed = current - previous;

    if (elapsed < msPerMinute) {
         return Math.round(elapsed/1000) + ' seconds ago';   
    }

    else if (elapsed < msPerHour) {
         return Math.round(elapsed/msPerMinute) + ' minutes ago';   
    }

    else if (elapsed < msPerDay ) {
         return Math.round(elapsed/msPerHour ) + ' hours ago';   
    }

    else if (elapsed < msPerMonth) {
        return 'approximately ' + Math.round(elapsed/msPerDay) + ' days ago';   
    }

    else if (elapsed < msPerYear) {
        return 'approximately ' + Math.round(elapsed/msPerMonth) + ' months ago';   
    }

    else {
        return 'approximately ' + Math.round(elapsed/msPerYear ) + ' years ago';   
    }
}
// var current= new Date(2011, 04, 24, 12, 30, 30, 30);
// alert(timeDifference(current, new Date(2011, 04, 24, 12, 30, 00, 00)));

function timeConverter(UNIX_timestamp){
  var a = new Date(UNIX_timestamp * 1000);
  var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  var year = a.getFullYear();
  var month = months[a.getMonth()];
  var date = a.getDate();
  var hour = a.getHours();
  var min = a.getMinutes();
  var sec = a.getSeconds();
  var time = date + ' ' + month + ' ' + year + ' ' + hour + ':' + min + ':' + sec ;
  return time;
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