$(".button-collapse").sideNav();
$(document).ready(function() {
    $("#myForm").submit(function(e) {
        var postData =   $("#myForm").serializeArray();
        var formURL =   $("#myForm").attr("action");
        $.ajax({
            url: formURL,
            type: "POST",
            data: postData,
            success: function(data, textStatus, jqXHR) {
              window.location = "rating.html"
            },
            error: function(jqXHR, textStatus, errorThrown) {
                $("#result").html("Username or Password was not valid")
            }
        });
        e.preventDefault(); //STOP default action
      //  e.unbind(); //unbind. to stop multiple form submit.
    });
    $("#ajaxform").submit(); //Submit  the FORM
    // the "href" attribute of .modal-trigger must specify the modal ID that wants to be triggered
    $('.modal-trigger').modal();
    $("#myForm").bind('ajax:complete', function() {
        alert(hi)

    });

});

function checkSession() {
    var request = $.ajax({
        type: 'GET',
        url: '/checkSession',
        async: false,
        success: function(data) {
            console.log("checking good SessionID");
            //window.location = "main.html"
        },
        error: function(data) {
          alert("nahmna")
            console.log("Failed to get SessionId")
        }
    });
}
function logout() {
    $.post("/logout", function(data, status) {
        if (status == "success") {
            window.location = "index.html"
        }
    });
}


function checkLogin() {
    $.ajax({
        type: 'GET',
        url: '/checkSession',
        async: false,
        error: function() {
            window.location = "index.html"
        }
    });
}