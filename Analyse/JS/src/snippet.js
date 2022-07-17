var qad = window.qad || {}, inputDB = {};

qad.renderDialog = function (dialog, node) {
    this.dialog = dialog;

    if (!node) {

        for (var i = 0; i < dialog.nodes.length; i++) {

            if (dialog.nodes[i].id === dialog.root) {

                node = dialog.nodes[i];
                break;
            }
        }
    }

    if (!node) {
        console.log('It is not clear where to go next.');
        // throw new Error('It is not clear where to go next.');
    }

    if (!this.el) {
        this.el = this.createElement('div', 'qad-dialog');
    }

    // Empty previously rendered dialog.
    this.el.textContent = '';

    switch (node.type) {

        case 'qad.Question':
            this.renderQuestion(node);
            break;
        case 'qad.Answer':
            this.renderAnswer(node);
            break;
    };

    this.currentNode = node;

    return this.el;
};

qad.createElement = function (tagName, className) {

    var el = document.createElement(tagName);
    el.setAttribute('class', className);
    return el;
};

qad.renderOption = function (option) {
    if ((option.text.includes("$")) && (option.text.includes(";"))) {
        // console.log("this option include $.");
        var elOption = this.createElement('div', 'qad-option qad-button');
        // elOption.value = option.text;
        elOption.setAttribute('data-option-id', option.id);
        elOption.setAttribute('id', "option-div");
        // elOption.setAttribute('class', "option-div");
        elOption.innerHTML = "<input type='text' class='option-input' id='" + option.text.substr(1, 4) + "' placeholder='" + hintTran + "' value='' onblur='updateVal(this.id);'></input>";//<input type='button' id='" + option.text + "-bt' value='" + submitTran + "'>";
        // console.log("set id is " + option.text.substr(1, 4));
        var self = this;
        elOption.addEventListener('click', function (evt) {
            if (document.getElementById(option.text.substr(1, 4))) {
                var val = document.getElementById(option.text.substr(1, 4)).value;
                if (val.length > 0) {
                    self.onOptionClick(evt);
                };
                //  else {
                //     var notif = "<a style='color:red;'>(Please input it.)</a>",
                //         qh = $(".qad-question-header").html();
                //     console.log(qh.includes(notif));
                //     if (qh.includes(notif) === false) {
                //         $(".qad-question-header").html($(".qad-question-header").html() + notif);
                //     };
                // };
            };
        }, false);
    } else {
        // var elOption = this.createElement('button', 'qad-option qad-button');
        var elOption = this.createElement('button', 'qad-option qad-button');
        elOption.textContent = option.text;
        elOption.setAttribute('data-option-id', option.id);

        var self = this;
        elOption.addEventListener('click', function (evt) {
            self.onOptionClick(evt);
        }, false);
    };
    return elOption;
};

qad.renderQuestion = function (node) {

    var elContent = this.createElement('div', 'qad-content');
    var elOptions = this.createElement('div', 'qad-options');

    for (var i = 0; i < node.options.length; i++) {

        elOptions.appendChild(this.renderOption(node.options[i]));
    }

    var elQuestion = this.createElement('h3', 'qad-question-header');

    // console.log("node.question: " + node.question);

    if ((node.question.includes("$")) && (node.question.includes(";"))) {
        // console.log("this question inlude $");
        var includesCount = node.question.split("$").length - 1, finalText = node.question;
        for (var t = 0; t < includesCount; t++) {
            var indexOfFirst = finalText.indexOf("$");
            var indexOfEnd = finalText.indexOf(";");
            var id = finalText.substr(indexOfFirst + 1, indexOfEnd - indexOfFirst - 1);
            // console.log("id is " + id);
            var key = "<a style='color:green;'><b>" + inputDB[id] + "</b></a>";
            finalText = finalText.replace(id, key).replace("$", "").replace(";", "").replace(";", "");
            // console.log(t + ": " + finalText);
        };
        elQuestion.innerHTML = finalText;
    } else {
        elQuestion.innerHTML = node.question;
    };

    elContent.appendChild(elQuestion);
    elContent.appendChild(elOptions);

    this.el.appendChild(elContent);
};

qad.renderAnswer = function (node) {

    var elContent = this.createElement('div', 'qad-content');
    var elAnswer = this.createElement('h3', 'qad-answer-header');

    // console.log("node.answer: " + node.answer);

    if ((node.answer.includes("$")) && (node.answer.includes(";"))) {
        var includesCount = node.answer.split("$").length - 1, finalText = node.answer;
        for (var t = 0; t < includesCount; t++) {
            // console.log("this answer inlude $");
            var indexOfFirst = finalText.indexOf("$");
            var indexOfEnd = finalText.indexOf(";");
            var id = finalText.substr(indexOfFirst + 1, indexOfEnd - indexOfFirst - 1);
            // console.log("id is " + id);
            var key = "<a style='color:green;'><b>" + inputDB[id] + "</b></a>";
            finalText = finalText.replace(id, key).replace("$", "").replace(";", "").replace(";", "");
            // console.log(t + ": " + finalText);
        };
        elAnswer.innerHTML = finalText;
    } else {
        elAnswer.innerHTML = node.answer;
    };

    // elAnswer.innerHTML = node.answer;

    elContent.appendChild(elAnswer);
    this.el.appendChild(elContent);
};

qad.onOptionClick = function (evt) {

    var elOption = evt.target;
    var optionId = elOption.getAttribute('data-option-id');

    var outboundLink;
    for (var i = 0; i < this.dialog.links.length; i++) {

        var link = this.dialog.links[i];
        if (link.source.id === this.currentNode.id && link.source.port === optionId) {

            outboundLink = link;
            break;
        }
    }

    if (outboundLink) {

        var nextNode;
        for (var j = 0; j < this.dialog.nodes.length; j++) {

            var node = this.dialog.nodes[j];
            if (node.id === outboundLink.target.id) {

                nextNode = node;
                break;
            }
        }

        if (nextNode) {

            this.renderDialog(this.dialog, nextNode);
        }
    }
};

function updateVal(id) {
    // console.log($("#" + id).val());
    // $("#" + id).value = $("#" + id).val();
    // $("#"+ id).find(":text").each(function () {
    //     this.setAttribute("value", $(this).val());
    // });
    inputDB[id] = $("#" + id).val();
    // inputDB[id] = val;
    console.log(JSON.stringify(inputDB));
};