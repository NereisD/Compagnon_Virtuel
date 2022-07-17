joint.dia.Element.define('qad.Answer', {
    padding: 50,
    attrs: {
        body: {
            // fill: '#4b4a67',
            fill: randomColor(),
            stroke: 'none',
            refWidth: '100%',
            refHeight: '100%',
            rx: 3,
            ry: 3
        },
        label: {
            fontSize: 14,
            refX: .5,
            refY: .5,
            yAlignment: 'middle',
            xAlignment: 'middle',
            fill: '#f6f6f6',
            fontFamily: 'Arial, helvetica, sans-serif'
        }
    }
}, {
    markup: [{
        tagName: 'rect',
        selector: 'body'
    }, {
        tagName: 'text',
        selector: 'label'
    }],

    initialize: function () {

        joint.dia.Element.prototype.initialize.apply(this, arguments);

        this.autoresize();
        this.on('change:answer', this.autoresize, this);
    },

    autoresize: function () {

        var answer = this.get('answer');
        var padding = this.get('padding');
        var size = joint.util.measureText(answer, { fontSize: this.attr(['label', 'fontSize']) });

        this.prop({
            attrs: { label: { text: answer } },
            size: { width: size.width + padding, height: size.height + padding }
        });
    }

});

joint.dia.Element.define('qad.Question', {
    optionHeight: 30,
    questionHeight: 45,
    paddingBottom: 30,
    minWidth: 150,
    ports: {
        groups: {
            'in': {
                position: 'top',
                attrs: {
                    circle: {
                        magnet: 'passive',
                        stroke: 'white',
                        // fill: '#feb663',
                        fill: randomColor(),
                        r: 14
                    },
                    text: {
                        pointerEvents: 'none',
                        fontSize: 12,
                        fill: 'white'
                    }
                },
                label: {
                    position: {
                        name: 'left',
                        args: { x: 5 }
                    }
                }
            },
            out: {
                position: 'right',
                attrs: {
                    'circle': {
                        magnet: true,
                        stroke: 'none',
                        // fill: '#31d0c6',
                        fill: randomColor(),
                        r: 14
                    }
                }
            }
        },
        items: [{
            group: 'in',
            attrs: {
                text: { text: 'in' }
            }
        }]
    },
    attrs: {
        '.': {
            magnet: false
        },
        '.body': {
            refWidth: '100%',
            refHeight: '100%',
            rx: '1%',
            ry: '2%',
            stroke: 'none',
            fill: {
                type: 'linearGradient',
                stops: [
                    // { offset: '0%', color: '#FEB663' },
                    // { offset: '100%', color: '#31D0C6' }
                    { offset: '0%', color: randomColor() },
                    { offset: '100%', color: randomColor() }
                ],
                // Top-to-bottom gradient.
                attrs: { x1: '0%', y1: '0%', x2: '0%', y2: '100%' }
            }
        },
        '.btn-add-option': {
            refX: 10,
            refDy: -22,
            cursor: 'pointer',
            fill: 'white'
        },
        '.btn-remove-option': {
            xAlignment: 10,
            yAlignment: 13,
            cursor: 'pointer',
            fill: 'white'
        },
        '.options': {
            refX: 0
        },

        // Text styling.
        text: {
            fontFamily: 'Arial'
        },
        '.option-text': {
            fontSize: 15,
            fill: '#4b4a67',
            refX: 30,
            yAlignment: 'middle'
        },
        '.question-text': {
            fill: 'white',
            refX: '50%',
            refY: 15,
            fontSize: 15,
            textAnchor: 'middle',
            style: {
                // textShadow: '1px 1px 0px gray'
                textShadow: '1px 1px 0px gray'
            }
        },

        // Options styling.
        '.option-rect': {
            rx: 3,
            ry: 3,
            stroke: 'white',
            strokeWidth: 1,
            strokeOpacity: .5,
            fillOpacity: .5,
            fill: 'white',
            refWidth: '100%'
        }
    }
}, {

    markup: '<rect class="body"/><text class="question-text"/><g class="options"></g><path class="btn-add-option" d="M5,0 10,0 10,5 15,5 15,10 10,10 10,15 5,15 5,10 0,10 0,5 5,5z"/>',
    optionMarkup: '<g class="option"><rect class="option-rect"/><path class="btn-remove-option" d="M0,0 15,0 15,5 0,5z"/><text class="option-text"/></g>',

    initialize: function () {

        joint.dia.Element.prototype.initialize.apply(this, arguments);
        this.on('change:options', this.onChangeOptions, this);
        this.on('change:question', function () {
            this.attr('.question-text/text', this.get('question') || '');
            this.autoresize();
        }, this);

        this.on('change:questionHeight', function () {
            this.attr('.options/refY', this.get('questionHeight'), { silent: true });
            this.autoresize();
        }, this);

        this.on('change:optionHeight', this.autoresize, this);

        this.attr('.options/refY', this.get('questionHeight'), { silent: true });
        this.attr('.question-text/text', this.get('question'), { silent: true });

        this.onChangeOptions();
    },

    onChangeOptions: function () {

        var options = this.get('options');
        var optionHeight = this.get('optionHeight');
        // console.log(JSON.stringify(options));

        // First clean up the previously set attrs for the old options object.
        // We mark every new attribute object with the `dynamic` flag set to `true`.
        // This is how we recognize previously set attributes.
        var attrs = this.get('attrs');
        _.each(attrs, function (attrs, selector) {

            if (attrs.dynamic) {
                // Remove silently because we're going to update `attrs`
                // later in this method anyway.
                this.removeAttr(selector, { silent: true });
            }
        }.bind(this));

        // Collect new attrs for the new options.
        var offsetY = 0;
        var attrsUpdate = {};
        var questionHeight = this.get('questionHeight');

        _.each(options, function (option) {

            // console.log(JSON.stringify(option));
            // var lineNum2 = 1;
            // for (var j = 0; j < option.text.length; j++) {
            //     if (option.text.charAt(j) === "\n") {
            //         lineNum2 += 1;
            //     }
            // };

            // optionHeight = 30 + (lineNum2 - 1) * 15;

            var selector = '.option-' + option.id;

            attrsUpdate[selector] = { transform: 'translate(0, ' + offsetY + ')', dynamic: true };
            attrsUpdate[selector + ' .option-rect'] = { height: optionHeight, dynamic: true };
            attrsUpdate[selector + ' .option-text'] = { text: option.text, dynamic: true, refY: optionHeight / 2 };

            offsetY += optionHeight;

            var portY = offsetY - optionHeight / 2 + questionHeight;
            if (!this.getPort(option.id)) {
                this.addPort({ group: 'out', id: option.id, args: { y: portY } });
            } else {
                this.portProp(option.id, 'args/y', portY);
            }
        }.bind(this));

        this.attr(attrsUpdate);
        this.autoresize();
    },

    autoresize: function () {

        var options = this.get('options') || [];
        var gap = this.get('paddingBottom') || 20;
        var height = options.length * this.get('optionHeight') + this.get('questionHeight') + gap;
        var width = joint.util.measureText(this.get('question'), {
            fontSize: this.attr('.question-text/fontSize')
        }).width;
        this.resize(Math.max(this.get('minWidth') || 150, width), height);

        var question = this.get('question');
        var lineNum = 1;
        for (var i = 0; i < question.length; i++) {
            if (question.charAt(i) === "\n") {
                lineNum += 1;
            }
        };
        // console.log(JSON.stringify(this));
        // console.log("===========================");
        this.prop({
            questionHeight: 45 + (lineNum - 1) * 15
        });

        // console.log(JSON.stringify(options));
        if (options.length > 0) {
            var maxlen = 0, indexOfMax = 0;
            for (i = 0; i < options.length; i++) {
                if (options[i].text.length > maxlen) {
                    maxlen = options[i].text.length;
                    indexOfMax = i;
                };
            };
            // console.log(this.get('optionHeight'));
            // console.log(JSON.stringify(this));
            //this.portProp(option.id, 'args/y', portY);
            // console.log("Max options[i].text: " + options[indexOfMax].text);
            // console.log("question.length: " + question.length);
            // console.log("===========================");11
            var width2 = joint.util.measureText(options[indexOfMax].text, {
                fontSize: this.attr('.question-text/fontSize')
            }).width;
            if (width2 + 40 > width) {
                this.resize(Math.max(this.get('minWidth') || 150, width2 + 40), height);
            };
        };
    },

    addOption: function (option) {

        var options = JSON.parse(JSON.stringify(this.get('options')));
        options.push(option);
        this.set('options', options);
    },

    removeOption: function (id) {

        var options = JSON.parse(JSON.stringify(this.get('options')));
        this.removePort(id);
        this.set('options', _.without(options, _.find(options, { id: id })));
    },

    changeOption: function (id, option) {

        if (!option.id) {
            option.id = id;
        }

        var options = JSON.parse(JSON.stringify(this.get('options')));
        options[_.findIndex(options, { id: id })] = option;
        this.set('options', options);
    }
});

joint.shapes.qad.QuestionView = joint.dia.ElementView.extend({

    events: {
        'click .btn-add-option': 'onAddOption',
        'click .btn-remove-option': 'onRemoveOption'
    },

    presentationAttributes: joint.dia.ElementView.addPresentationAttributes({
        options: ['OPTIONS']
    }),

    confirmUpdate: function (flags) {
        joint.dia.ElementView.prototype.confirmUpdate.apply(this, arguments);
        if (this.hasFlag(flags, 'OPTIONS')) this.renderOptions();
    },

    renderMarkup: function () {

        joint.dia.ElementView.prototype.renderMarkup.apply(this, arguments);

        // A holder for all the options.
        this.$options = this.$('.options');
        // Create an SVG element representing one option. This element will
        // be cloned in order to create more options.
        this.elOption = V(this.model.optionMarkup);

        this.renderOptions();
    },

    renderOptions: function () {

        this.$options.empty();

        _.each(this.model.get('options'), function (option, index) {

            var className = 'option-' + option.id;
            var elOption = this.elOption.clone().addClass(className);
            elOption.attr('option-id', option.id);
            this.$options.append(elOption.node);

        }.bind(this));

        // Apply `attrs` to the newly created SVG elements.
        this.update();
    },

    onAddOption: function () {

        this.model.addOption({
            id: _.uniqueId('option-'),
            // text: 'Option ' + this.model.get('options').length
            text: '$' + randomText(4) + ";"
            // text: optionTran + this.model.get('options').length 
        });
    },

    onRemoveOption: function (evt) {

        this.model.removeOption(V(evt.target.parentNode).attr('option-id'));
    }
});

// Utils

joint.util.measureText = function (text, attrs) {

    var fontSize = parseInt(attrs.fontSize, 10) || 10;

    var svgDocument = V('svg').node;
    var textElement = V('<text><tspan></tspan></text>').node;
    var textSpan = textElement.firstChild;
    var textNode = document.createTextNode('');

    textSpan.appendChild(textNode);
    svgDocument.appendChild(textElement);
    document.body.appendChild(svgDocument);

    var lines = text.split('\n');
    var width = 0;

    // Find the longest line width.
    _.each(lines, function (line) {

        textNode.data = line;
        var lineWidth = textSpan.getComputedTextLength();

        width = Math.max(width, lineWidth);
    });

    var height = lines.length * (fontSize * 1.2);

    V(svgDocument).remove();

    return { width: width, height: height };
};

function randomColor() {
    var r = parseInt(Math.random() * 256);
    var g = parseInt(Math.random() * 256);
    var b = parseInt(Math.random() * 256);
    var rgb = "rgb(" + r + "," + g + "," + b + ")";
    return rgb;
};

function randomText(length) {
    var result = '';
    // var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    var characters = 'ABCDEFGHJKLMNOPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz0123456789';
    var charactersLength = characters.length;
    for (var i = 0; i < length; i++) {
        result += characters.charAt(Math.floor(Math.random() * charactersLength));
    };
    return result;
};
