$(function () {
    var labelArray1 = window.location.search.split('=');
    var label = labelArray1[1].split('%20').join(" ");
    document.title = label;
    $(commentLabel).html("Comment For: " + label);
    $(foodName).val(label);
    $.get("/getComments/?=", function (data) {
        console.log("GET DATA");
        var commentsBox = "<ul class='commentList'>"
        for (var i = 0; i < data.length; i++) {
            commentsBox += `<li>
                    <div class="commenterImage">
                        <b>USER:</b>
                    </div>
                    </br>
                    <div class="commentText">
                        <p class="">Hello this is a test comment.</p> <span class="date sub-text">on March 5th, 2014</span>
                    </div>
                </li>`
        }
    });

    // $("#addComment").click(function () {
    //     alert("SEDNITN");
    //     var obj = {
    //         "UserID": 123,
    //         "Comment": $("#comment").html(),
    //         "Time": getTimeStamp()
    //     };
    //     $.ajax({
    //         url: '/addComment',
    //         type: 'POST',
    //         contentType: 'application/json',
    //         data: obj,
    //         success: function (data) { alert(data.status); }
    //     });
    // });

});

function userComment() {

    /*<ul class="commentList">
               <li>
                   <div class="commenterImage">
                       <img src="http://placekitten.com/50/50" />
                   </div>
                   <div class="commentText">
                       <p class="">Hello this is a test comment.</p> <span class="date sub-text">on March 5th, 2014</span>

                   </div>
               </li>
               <li>
                   <div class="commenterImage">
                       <img src="http://placekitten.com/45/45" />
                   </div>
                   <div class="commentText">
                       <p class="">Hello this is a test comment and this comment is particularly very long and it goes on and on and
                           on.</p> <span class="date sub-text">on March 5th, 2014</span>
                   </div>
               </li>
               <li>
                   <div class="commentText">
                       <p class="">Hello this is a test comment.</p> <span class="date sub-text">on March 5th, 2014</span>
                   </div>
               </li>
           </ul>*/
}

function getTimeStamp() {
    var d = new Date();
    var n = d.getTime();
    return n;
}