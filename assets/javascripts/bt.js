$("#btn-sidebar").click(function(){
    swich_sidebar();
});

function swich_sidebar(){

    if($("#sidebar").hasClass("invisible")) {
        $("#content").removeClass("col-lg-12");
        $("#content").addClass("col-lg-10");

        $("#sidebar").removeClass("invisible");
    }else{
        $("#content").removeClass("col-lg-10");
        $("#content").addClass("col-lg-12");

        $("#sidebar").addClass("invisible");
    }


}

$('[data-toggle="tooltip"]').tooltip()