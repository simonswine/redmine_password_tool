function changedPasswordInstanceTemplate(select) {

    form = $("#password_template_form");

    // Remove unwanted Elements
    form.find(".ui-dform-div-main").remove();

    // Load new form definition if select != 0
    if (select.value !== undefined && select.value !== 0) {
        form.dform('../../../password_templates/' + select.value + '/form.js', updatePasswordInstanceForm);
    }
    else {
        resetPasswordInstanceForm(true);
    }
}

function initPasswordInstanceForm(data) {

    form = $("#password_template_form");
    form.dform(data);
    updatePasswordInstanceForm(data);

}

function resetPasswordInstanceForm(value) {

    /* disable name text input */
    form.find("input#name").attr("disabled", value);
    /* disable reset parent select */
    form.find("select#password_instance_parent_id").attr("disabled", value);
    if (value){
        form.find("input#name").val("");
        form.find("select#password_instance_parent_id option").removeAttr('selected');
        form.find("select#password_instance_parent_id option[value='']").attr('selected', true);
    }
}

function updatePasswordInstanceForm(data) {

    form = $("#password_template_form");

    resetPasswordInstanceForm(false);

    /* Move dynamic form to the right place */
    div_dyn = form.children(".ui-dform-div-main").first();
    div_dyn.detach();
    div_dyn.appendTo(form.children("div.box").first());

    /* Loop through Labels */
    div_dyn.children("label[class^='ui-dform-']").each(function () {

        /* Surround label/inputs with <p> element */
        $(this).next().andSelf().wrapAll('<p class="ui-dform-surround"/>');

        /* Set requirement flags as needed */
        my_name = $(this).next().attr('name');
        my_def = getDefinitionByName(data, my_name).pop();
        if (my_def['validate'] && my_def['validate']['required'] === true) {
            $(this).append($('<span class="required"> *</span>'));
        }
    });

}

/* Get definition of field by name */
function getDefinitionByName(data, name) {
    var key = 'name';
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
    form = $("#password_template_form");
    form.validate();
}

function togglePasswordInstanceContent(event) {
    $(this).hide();
    $(this).siblings("a.icon").show();

    if ($(this).hasClass("pw-show")) {
        // Show

        var pw_instance_id = parseInt($(this).attr("href").substring(1),10);

        var pathname = window.location.pathname;


        // Get JSON data
        $.ajax({
            url: window.location.pathname +"/"+pw_instance_id+"/data_schema.js",
            context: $(this)
        }).done(function (data) {
                // Add table
                $(this).before(showPasswordInstanceContent(data));
            });
    }
    else {
        // Hide
        $(this).siblings("table.list").remove();
    }
}

function showPasswordInstanceContent(data_json) {

    var table = $('<table></table>').addClass('list');
    var even_or_odd = "odd";

    var data = JSON.parse(data_json);

    for (i in data) {

        // Show only if value non empty
        if (data[i]['value'] !== "" && data[i]['value'] !== undefined) {
            var row = $('<tr></tr>').addClass(even_or_odd);
            row.append($('<td width="50%"></td>').text(data[i]['caption']));
            row.append($('<td width="50%"></td>').append($('<span style="font-family: monospace;"></span>').text(data[i]['value'])));
            table.append(row);
        }

        // Even or odd
        if (even_or_odd == "even") {
            even_or_odd = "odd";
        }
        else {
            even_or_odd = "even";
        }


    }

    // Loop over values

    return table;


}

function showPasswordInstanceAllContent() {
    $("table.pw-table").find("a.pw-hide").trigger('click');
    $("table.pw-table").find("a.pw-show").trigger('click');
}

function hidePasswordInstanceAllContent() {
    $("table.pw-table").find("a.pw-hide").trigger('click');
}

