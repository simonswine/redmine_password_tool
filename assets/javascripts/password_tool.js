function changedPasswordInstanceTemplate(select){

    form = $("#password_template_form")

    // Remove unwanted Elements
    form.find(".ui-dform-div-main").remove()

    // Load new form definition if select != 0
    if (select.value != undefined && select.value != 0){
        form.dform('../../../password_templates/'+select.value+'/form.js',updatePasswordInstanceForm);
    }
    else {
        /* disable name text input */
        form.find("input#name").attr("disabled",true);
    }
}

function initPasswordInstanceForm(data){

    form = $("#password_template_form")
    form.dform(data)
    updatePasswordInstanceForm(data)

}

function updatePasswordInstanceForm(data) {

    form = $("#password_template_form")

    /* enable name text input */
    form.find("input#name").attr("disabled",false);

    /* Move dynamic form to the right place */
    div_dyn = form.children(".ui-dform-div-main").first()
    div_dyn.detach()
    div_dyn.appendTo(form.children("div.box").first())

    /* Loop through Labels */
    div_dyn.children("label[class^='ui-dform-']").each(function(){

        /* Surround label/inputs with <p> element */
        $(this).next().andSelf().wrapAll('<p class="ui-dform-surround"/>');

        /* Set requirement flags as needed */
        my_name = $(this).next().attr('name')
        my_def = getDefinitionByName(data,my_name).pop()
        if (my_def['validate'] && my_def['validate']['required'] == true){
            $(this).append($('<span class="required"> *</span>'))
        }
    });

}

/* Get definition of field by name */
function getDefinitionByName(data, name) {
    var key = 'name'
    var objects = [];
    for (var i in data) {
        if (!data.hasOwnProperty(i)) continue;
        if (typeof data[i] == 'object') {
            objects = objects.concat(getDefinitionByName(data[i], name));
        } else if (i == key && data[key] == name) {
            objects.push(data);
        }
    }
    return objects;
}


function validatePasswordInstanceFrom() {

    form = $("#password_template_form")
    form.validate()


}