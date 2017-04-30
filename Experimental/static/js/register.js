$(".button-collapse").sideNav();
$(document).ready(function() {
    console.log("caled")
    $("#myForm").submit(function(e) {
        var postData = $("#myForm").serializeArray();
        var formURL = $("#myForm").attr("action");
        $.ajax({
            url: formURL,
            type: "POST",
            data: postData,
            success: function(data, textStatus, jqXHR) {
                document.location.href = '/';
            },
            error: function(jqXHR, textStatus, errorThrown) {
                console.log(jqXHR.status)
                if (jqXHR.status === 400) {
                    document.getElementById("result").innerHTML = "Passwords do not match"
                } else {
                    document.getElementById("result").innerHTML = "Email already in use"
                }
            }
        });
        e.preventDefault(); //STOP default action
        //  e.unbind(); //unbind. to stop multiple form submit.
    });
    $("#ajaxform").submit(); //Submit  the FORM
    $("#myForm").bind('ajax:complete', function() {
        alert(hi)

    });
});

function checkLogin() {
    $.ajax({
        type: 'GET',
        url: '/checkSession',
        async: false,
        error: function() {
            window.location = "home.html"
        }
    });
}