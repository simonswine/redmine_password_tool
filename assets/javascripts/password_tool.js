function updatePasswordInstanceFrom(select) {

    form = $("#password_template_form")

    // Remove unwanted Elements
    form.children("[class^='ui-dform-']").remove()

    // Load new form definition if select != 0
    if (select.value != 0){
        form.dform('../../../password_templates/'+select.value+'/form.js', function(data) {
            this //-> Generated $('#myform')
            data //-> data from path/to/form.json

            /* Surround label/inputs with <p> elemegit nt */
            form.children("label[class^='ui-dform-']").each(function(){
                $(this).next().andSelf().wrapAll('<p class="ui-dform-surround"/>');
            });
        });
    }
}