// @import jquery.js
// @import lodash.js
// @import backbone.js
// @import geometry.js
// @import vectorizer.js
// @import joint.clean.js
// @import joint.shapes.qad.js
// @import selection.js
// @import factory.js
// @import snippet.js

var app = app || {}, dialog2 = null;
var qad = window.qad || {};
var jsonVal = "", cellArr = [], dialogJSONFull = "";

app.AppView = joint.mvc.View.extend({

    el: '#app',

    events: {
        'click #toolbar .add-question': 'addQuestion',
        'click #toolbar .add-answer': 'addAnswer',
        'click #toolbar .preview-dialog': 'previewDialog',
        'click #toolbar .code-snippet': 'showCodeSnippet',
        'click #toolbar .code-snippet2': 'showCodeSnippet2',
        'click #toolbar .load-example': 'loadExample',
        'click #toolbar .clear': 'clear',
        'click #toolbar .paste-json': 'pasteJSON'
    },

    init: function () {

        this.initializePaper();
        this.initializeSelection();
        this.initializeHalo();
        this.initializeInlineTextEditor();
        this.initializeTooltips();

        // this.loadExample();
    },

    initializeTooltips: function () {

        new joint.ui.Tooltip({
            rootTarget: '#paper',
            target: '.joint-element',
            content: function (target) {

                var cell = this.paper.findView(target).model;

                // var text = '- Double-click to edit text inline.';
                var text = '- ' + explain2;
                if (cell.get('type') === 'qad.Question') {
                    // text += '<br/><br/>- Connect a port with another Question or an Answer.';
                    text += '<br/><br/>- ' + explain3;
                }

                return text;

            }.bind(this),
            direction: 'right',
            right: '#paper',
            padding: 20
        });
    },

    initializeInlineTextEditor: function () {

        var cellViewUnderEdit;

        var closeEditor = _.bind(function () {

            if (this.textEditor) {
                this.textEditor.remove();
                // Re-enable dragging after inline editing.
                cellViewUnderEdit.setInteractivity(true);
                this.textEditor = cellViewUnderEdit = undefined;
            }
        }, this);

        this.paper.on('cell:pointerdblclick', function (cellView, evt) {

            // Clean up the old text editor if there was one.
            closeEditor();

            var vTarget = V(evt.target);
            var text;
            var cell = cellView.model;

            switch (cell.get('type')) {

                case 'qad.Question':

                    text = joint.ui.TextEditor.getTextElement(evt.target);
                    if (!text) {
                        break;
                    }
                    if (vTarget.hasClass('body') || V(text).hasClass('question-text')) {

                        text = cellView.$('.question-text')[0];
                        cellView.textEditPath = 'question';
                        cellView.optionId = null;

                    } else if (V(text).hasClass('option-text')) {

                        cellView.textEditPath = 'options/' + _.findIndex(cell.get('options'), { id: V(text.parentNode).attr('option-id') }) + '/text';
                        cellView.optionId = V(text.parentNode).attr('option-id');

                    } else if (vTarget.hasClass('option-rect')) {

                        text = V(vTarget.node.parentNode).find('.option-text');
                        cellView.textEditPath = 'options/' + _.findIndex(cell.get('options'), { id: V(vTarget.node.parentNode).attr('option-id') }) + '/text';
                    }
                    break;

                case 'qad.Answer':
                    text = joint.ui.TextEditor.getTextElement(evt.target);
                    cellView.textEditPath = 'answer';
                    break;
            }

            if (text) {

                this.textEditor = new joint.ui.TextEditor({ text: text });
                this.textEditor.render(this.paper.el);

                this.textEditor.on('text:change', function (newText) {

                    var cell = cellViewUnderEdit.model;
                    // TODO: prop() changes options and so options are re-rendered
                    // (they are rendered dynamically).
                    // This means that the `text` SVG element passed to the ui.TextEditor
                    // no longer exists! An exception is thrown subsequently.
                    // What do we do here?
                    cell.prop(cellViewUnderEdit.textEditPath, newText);

                    // A temporary solution or the right one? We just
                    // replace the SVG text element of the textEditor options object with the new one
                    // that was dynamically created as a reaction on the `prop` change.
                    if (cellViewUnderEdit.optionId) {
                        this.textEditor.options.text = cellViewUnderEdit.$('.option.option-' + cellViewUnderEdit.optionId + ' .option-text')[0];
                    }

                }, this);

                cellViewUnderEdit = cellView;
                // Prevent dragging during inline editing.
                cellViewUnderEdit.setInteractivity(false);
            }
        }, this);

        $(document.body).on('click', _.bind(function (evt) {

            var text = joint.ui.TextEditor.getTextElement(evt.target);
            if (this.textEditor && !text) {
                closeEditor();
            }

        }, this));
    },

    initializeHalo: function () {

        this.paper.on('element:pointerup', function (elementView, evt) {

            var halo = new joint.ui.Halo({
                cellView: elementView,
                useModelGeometry: true,
                type: 'toolbar'
            });

            halo.removeHandle('resize')
                .removeHandle('rotate')
                .removeHandle('fork')
                .removeHandle('link')
                .render();

        }, this);
    },

    initializeSelection: function () {

        var paper = this.paper;
        var graph = this.graph;
        var selection = this.selection = new app.Selection;

        selection.on('add reset', function () {
            var cell = this.selection.first();
            if (cell) {
                // this.status('Selection: ' + cell.get('type'));
                if ((cellArr.includes(cell) === false)) {
                    cellArr.push(cell);
                    // console.log(cellArr.length);
                    // cellArr = cellArr.filter(v => v !== null);
                    dialogJSONFull = { "length": cellArr.length, "cells": cellArr };
                };
                console.log('Selection: ' + cell.get('type'));
            };
            //  else {
            // this.status('Selection emptied.');
            // console.log('Selection emptied.');
            // this.status(explain4);
            // }
        }, this);

        paper.on({
            'element:pointerup': function (elementView) {
                this.selection.reset([elementView.model]);
            },
            'blank:pointerdown': function () {
                this.selection.reset([]);
            }
        }, this);

        graph.on('remove', function () {
            var cell = this.selection.first();
            this.selection.reset([]);
            cellArr.forEach((item, index) => {
                if (item === cell) {
                    cellArr.splice(index, 1);
                };
            });
            dialogJSONFull = { "length": cellArr.length, "cells": cellArr };
        }, this);

        new app.SelectionView({
            model: selection,
            paper: paper
        });

        // document.body.addEventListener('keydown', _.bind(function (evt) {

        //     var code = evt.which || evt.keyCode;
        // Do not remove the element with backspace if we're in inline text editing.
        //     if ((code === 8 || code === 46) && !this.textEditor && !this.selection.isEmpty()) {
        //         this.selection.first().remove();
        //         this.selection.reset([]);
        //         return false;
        //     }

        //     return true;

        // }, this), false);
    },

    initializePaper: function () {

        this.paper = new joint.dia.Paper({
            el: this.$('#paper'),

            snapLinks: {
                radius: 75
            },
            linkPinning: false,
            multiLinks: false,
            defaultLink: app.Factory.createLink(),
            defaultRouter: { name: 'manhattan', args: { padding: 20 } },
            defaultConnector: { name: 'rounded' },
            validateConnection: function (cellViewS, magnetS, cellViewT, magnetT, end, linkView) {
                // Prevent linking from input ports.
                if (magnetS && magnetS.getAttribute('port-group') === 'in') return false;
                // Prevent linking from output ports to input ports within one element.
                if (cellViewS === cellViewT) return false;
                // Prevent linking to input ports.
                return (magnetT && magnetT.getAttribute('port-group') === 'in') || (cellViewS.model.get('type') === 'qad.Question' && cellViewT.model.get('type') === 'qad.Answer');
            },
            validateMagnet: function (cellView, magnet) {
                // Note that this is the default behaviour. Just showing it here for reference.
                return magnet.getAttribute('magnet') !== 'passive';
            }
        });

        this.graph = this.paper.model;
    },

    // Show a message in the statusbar.
    status: function (m) {
        this.$('#statusbar .message').text(m);
    },

    addQuestion: function () {

        // app.Factory.createQuestion('Question').addTo(this.graph);
        // this.status('Question added.');
        app.Factory.createQuestion(questionTran).addTo(this.graph);
        this.status(questionAddTran);
    },

    addAnswer: function () {

        // app.Factory.createAnswer('Answer').addTo(this.graph);
        // this.status('Answer added.');
        app.Factory.createAnswer(answerTran).addTo(this.graph);
        this.status(answerAddTran);
    },

    previewDialog: function () {

        var cell = this.selection.first();

        if (cell) {

            var dialogJSON = app.Factory.createDialogJSON(this.graph, cell);
            // console.log(JSON.stringify(dialogJSON));
            var $background = $('<div/>').addClass('background').on('click', function () {
                $('#preview').empty();
            });

            $('#preview')
                .empty()
                .append([
                    $background,
                    qad.renderDialog(dialogJSON)
                ])
                .show();
        } else {
            document.getElementById("message1").innerHTML = "<a style='color:red'>" + explain10 + "</a>";
        };
    },

    loadExample: function () {

        if (jsonVal.length > 0) {
            if (jsonVal.includes("'") === true) {
                jsonVal = jsonVal.replaceAll("'", "\"").replaceAll("embeds\": \",", "embeds\": \"\",");
            };
            if (jsonVal.includes("Don\"t") === true) {
                jsonVal = jsonVal.replaceAll("Don\"t", "Do not");
            };
            // console.log(jsonVal);
            var jsonVal2 = JSON.parse(jsonVal);
            // console.log(jsonVal2);
            this.selection.reset([]);
            //this.graph.fromJSON({ 'cells': [{ 'type': 'qad.Question', 'optionHeight': 30, 'questionHeight': 45, 'paddingBottom': 30, 'minWidth': 150, 'ports': { 'groups': { 'in': { 'position': 'top', 'attrs': { 'circle': { 'magnet': 'passive', 'stroke': 'white', 'fill': '#feb663', 'r': 14 }, 'text': { 'pointerEvents': 'none', 'fontSize': 12, 'fill': 'white' } }, 'label': { 'position': { 'name': 'left', 'args': { 'x': 5 } } } }, 'out': { 'position': 'right', 'attrs': { 'circle': { 'magnet': true, 'stroke': 'none', 'fill': '#31d0c6', 'r': 14 } } } }, 'items': [{ 'group': 'in', 'attrs': { 'text': { 'text': 'in' } }, 'id': '3ef1df14-fd20-48d6-9700-d4f1e9ab183f' }, { 'group': 'out', 'id': 'yes', 'args': { 'y': 60 } }, { 'group': 'out', 'id': 'no', 'args': { 'y': 90 } }] }, 'position': { 'x': 45, 'y': 38 }, 'size': { 'width': 150.3046875, 'height': 135 }, 'angle': 0, 'question': 'Does the thing work?', 'options': [{ 'id': 'yes', 'text': 'Yes' }, { 'id': 'no', 'text': 'No' }], 'id': 'd849d917-8a43-4d51-9e99-291799c144db', 'z': 1, 'attrs': { '.options': { 'refY': 45 }, '.question-text': { 'text': 'Does the thing work?' }, '.inPorts>.port-in>.port-label': { 'text': 'In' }, '.inPorts>.port-in>.port-body': { 'port': { 'id': 'in', 'type': 'in', 'label': 'In' } }, '.inPorts>.port-in': { 'ref': '.body', 'ref-x': 0.5 }, '.option-yes': { 'transform': 'translate(0, 0)', 'dynamic': true }, '.option-yes .option-rect': { 'height': 30, 'dynamic': true }, '.option-yes .option-text': { 'text': 'Yes', 'dynamic': true, 'refY': 15 }, '.option-no': { 'transform': 'translate(0, 30)', 'dynamic': true }, '.option-no .option-rect': { 'height': 30, 'dynamic': true }, '.option-no .option-text': { 'text': 'No', 'dynamic': true, 'refY': 15 } } }, { 'type': 'qad.Answer', 'position': { 'x': 464, 'y': 65 }, 'size': { 'width': 223.796875, 'height': 66.8 }, 'angle': 0, 'inPorts': [{ 'id': 'in', 'label': 'In' }], 'outPorts': [{ 'id': 'yes', 'label': 'Yes' }, { 'id': 'no', 'label': 'No' }], 'answer': 'Don\'t mess about with it.', 'id': '4073e883-1cc6-46a5-b22d-688ca1934324', 'z': 2, 'attrs': { 'text': { 'text': 'Don\'t mess about with it.' } } }, { 'type': 'link', 'source': { 'id': 'd849d917-8a43-4d51-9e99-291799c144db', 'selector': 'g:nth-child(1) g:nth-child(3) g:nth-child(1) g:nth-child(4) circle:nth-child(1)      ', 'port': 'yes' }, 'target': { 'id': '4073e883-1cc6-46a5-b22d-688ca1934324' }, 'id': '9d87214a-7b08-47ce-9aec-8e49ed7ae929', 'embeds': '', 'z': 3, 'attrs': { '.marker-target': { 'd': 'M 10 0 L 0 5 L 10 10 z', 'fill': '#6a6c8a', 'stroke': '#6a6c8a' }, '.connection': { 'stroke': '#6a6c8a', 'strokeWidth': 2 } } }, { 'type': 'qad.Question', 'optionHeight': 30, 'questionHeight': 45, 'paddingBottom': 30, 'minWidth': 150, 'ports': { 'groups': { 'in': { 'position': 'top', 'attrs': { 'circle': { 'magnet': 'passive', 'stroke': 'white', 'fill': '#feb663', 'r': 14 }, 'text': { 'pointerEvents': 'none', 'fontSize': 12, 'fill': 'white' } }, 'label': { 'position': { 'name': 'left', 'args': { 'x': 5 } } } }, 'out': { 'position': 'right', 'attrs': { 'circle': { 'magnet': true, 'stroke': 'none', 'fill': '#31d0c6', 'r': 14 } } } }, 'items': [{ 'group': 'in', 'attrs': { 'text': { 'text': 'in' } }, 'id': '32499902-9bd1-4a9f-b4b4-80ee89751594' }, { 'group': 'out', 'id': 'yes', 'args': { 'y': 60 } }, { 'group': 'out', 'id': 'no', 'args': { 'y': 90 } }] }, 'position': { 'x': 55, 'y': 245 }, 'size': { 'width': 195.6484375, 'height': 135 }, 'angle': 0, 'question': 'Did you mess about with it?', 'options': [{ 'id': 'yes', 'text': 'Yes' }, { 'id': 'no', 'text': 'No' }], 'id': '8ce3f820-54f0-41f0-a46c-1e4f57b5f91e', 'z': 4, 'attrs': { '.options': { 'refY': 45 }, '.question-text': { 'text': 'Did you mess about with it?' }, '.inPorts>.port-in>.port-label': { 'text': 'In' }, '.inPorts>.port-in>.port-body': { 'port': { 'id': 'in', 'type': 'in', 'label': 'In' } }, '.inPorts>.port-in': { 'ref': '.body', 'ref-x': 0.5 }, '.option-yes': { 'transform': 'translate(0, 0)', 'dynamic': true }, '.option-yes .option-rect': { 'height': 30, 'dynamic': true }, '.option-yes .option-text': { 'text': 'Yes', 'dynamic': true, 'refY': 15 }, '.option-no': { 'transform': 'translate(0, 30)', 'dynamic': true }, '.option-no .option-rect': { 'height': 30, 'dynamic': true }, '.option-no .option-text': { 'text': 'No', 'dynamic': true, 'refY': 15 } } }, { 'type': 'qad.Answer', 'position': { 'x': 343, 'y': 203 }, 'size': { 'width': 125.59375, 'height': 66.8 }, 'angle': 0, 'inPorts': [{ 'id': 'in', 'label': 'In' }], 'outPorts': [{ 'id': 'yes', 'label': 'Yes' }, { 'id': 'no', 'label': 'No' }], 'answer': 'Run away!', 'id': '7da45291-2535-4aa1-bb50-5cadd2b2fb91', 'z': 5, 'attrs': { 'text': { 'text': 'Run away!' } } }, { 'type': 'link', 'source': { 'id': '8ce3f820-54f0-41f0-a46c-1e4f57b5f91e', 'selector': 'g:nth-child(1) g:nth-child(3) g:nth-child(1) g:nth-child(4) circle:nth-child(1)      ', 'port': 'yes' }, 'target': { 'id': '7da45291-2535-4aa1-bb50-5cadd2b2fb91' }, 'id': 'fd9f3367-79b9-4f69-b5b7-2bba012e53bb', 'embeds': '', 'z': 6, 'attrs': { '.marker-target': { 'd': 'M 10 0 L 0 5 L 10 10 z', 'fill': '#6a6c8a', 'stroke': '#6a6c8a' }, '.connection': { 'stroke': '#6a6c8a', 'stroke-width': 2 } } }, { 'type': 'qad.Question', 'optionHeight': 30, 'questionHeight': 45, 'paddingBottom': 30, 'minWidth': 150, 'ports': { 'groups': { 'in': { 'position': 'top', 'attrs': { 'circle': { 'magnet': 'passive', 'stroke': 'white', 'fill': '#feb663', 'r': 14 }, 'text': { 'pointerEvents': 'none', 'fontSize': 12, 'fill': 'white' } }, 'label': { 'position': { 'name': 'left', 'args': { 'x': 5 } } } }, 'out': { 'position': 'right', 'attrs': { 'circle': { 'magnet': true, 'stroke': 'none', 'fill': '#31d0c6', 'r': 14 } } } }, 'items': [{ 'group': 'in', 'attrs': { 'text': { 'text': 'in' } }, 'id': '964ee8db-c3d5-47a3-ba44-31d7b93f8723' }, { 'group': 'out', 'id': 'yes', 'args': { 'y': 60 } }, { 'group': 'out', 'id': 'no', 'args': { 'y': 90 } }] }, 'position': { 'x': 238, 'y': 429 }, 'size': { 'width': 155.6171875, 'height': 135 }, 'angle': 0, 'question': 'Will you get screwed?', 'options': [{ 'id': 'yes', 'text': 'Yes' }, { 'id': 'no', 'text': 'No' }], 'id': 'fd3e0ab4-fd3a-4342-972b-3616e0c0a5cf', 'z': 7, 'attrs': { '.options': { 'refY': 45 }, '.question-text': { 'text': 'Will you get screwed?' }, '.inPorts>.port-in>.port-label': { 'text': 'In' }, '.inPorts>.port-in>.port-body': { 'port': { 'id': 'in', 'type': 'in', 'label': 'In' } }, '.inPorts>.port-in': { 'ref': '.body', 'ref-x': 0.5 }, '.option-yes': { 'transform': 'translate(0, 0)', 'dynamic': true }, '.option-yes .option-rect': { 'height': 30, 'dynamic': true }, '.option-yes .option-text': { 'text': 'Yes', 'dynamic': true, 'refY': 15 }, '.option-no': { 'transform': 'translate(0, 30)', 'dynamic': true }, '.option-no .option-rect': { 'height': 30, 'dynamic': true }, '.option-no .option-text': { 'text': 'No', 'dynamic': true, 'refY': 15 } } }, { 'type': 'link', 'source': { 'id': 'd849d917-8a43-4d51-9e99-291799c144db', 'selector': 'g:nth-child(1) g:nth-child(3) g:nth-child(2) g:nth-child(4) circle:nth-child(1)      ', 'port': 'no' }, 'target': { 'id': '8ce3f820-54f0-41f0-a46c-1e4f57b5f91e', 'magnet': 'circle', 'port': '32499902-9bd1-4a9f-b4b4-80ee89751594' }, 'id': '641410b2-aeb5-42ad-b757-2d9c6e4d56bd', 'embeds': '', 'z': 8, 'attrs': { '.marker-target': { 'd': 'M 10 0 L 0 5 L 10 10 z', 'fill': '#6a6c8a', 'stroke': '#6a6c8a' }, '.connection': { 'stroke': '#6a6c8a', 'stroke-width': 2 } } }, { 'type': 'link', 'source': { 'id': '8ce3f820-54f0-41f0-a46c-1e4f57b5f91e', 'selector': 'g:nth-child(1) g:nth-child(3) g:nth-child(2) g:nth-child(4) circle:nth-child(1)      ', 'port': 'no' }, 'target': { 'id': 'fd3e0ab4-fd3a-4342-972b-3616e0c0a5cf', 'magnet': 'circle', 'port': '964ee8db-c3d5-47a3-ba44-31d7b93f8723' }, 'id': '3b9de57d-be21-4e9e-a73b-693b32e5f14a', 'embeds': '', 'z': 9, 'attrs': { '.marker-target': { 'd': 'M 10 0 L 0 5 L 10 10 z', 'fill': '#6a6c8a', 'stroke': '#6a6c8a' }, '.connection': { 'stroke': '#6a6c8a', 'stroke-width': 2 } } }, { 'type': 'qad.Answer', 'position': { 'x': 553, 'y': 400 }, 'size': { 'width': 117.296875, 'height': 66.8 }, 'angle': 0, 'inPorts': [{ 'id': 'in', 'label': 'In' }], 'outPorts': [{ 'id': 'yes', 'label': 'Yes' }, { 'id': 'no', 'label': 'No' }], 'answer': 'Poor boy.', 'id': '13402455-006d-41e3-aacc-514f551b78b8', 'z': 10, 'attrs': { 'text': { 'text': 'Poor boy.' } } }, { 'type': 'qad.Answer', 'position': { 'x': 553, 'y': 524 }, 'size': { 'width': 146.9453125, 'height': 66.8 }, 'angle': 0, 'inPorts': [{ 'id': 'in', 'label': 'In' }], 'outPorts': [{ 'id': 'yes', 'label': 'Yes' }, { 'id': 'no', 'label': 'No' }], 'answer': 'Put it in a bin.', 'id': '857c9deb-86c3-47d8-bc6d-8f36c5294eab', 'z': 11, 'attrs': { 'text': { 'text': 'Put it in a bin.' } } }, { 'type': 'link', 'source': { 'id': 'fd3e0ab4-fd3a-4342-972b-3616e0c0a5cf', 'selector': 'g:nth-child(1) g:nth-child(3) g:nth-child(1) g:nth-child(4) circle:nth-child(1)      ', 'port': 'yes' }, 'target': { 'id': '13402455-006d-41e3-aacc-514f551b78b8' }, 'id': '7e96039d-c3d4-4c86-b8e5-9a49835e114b', 'embeds': '', 'z': 12, 'attrs': { '.marker-target': { 'd': 'M 10 0 L 0 5 L 10 10 z', 'fill': '#6a6c8a', 'stroke': '#6a6c8a' }, '.connection': { 'stroke': '#6a6c8a', 'stroke-width': 2 } } }, { 'type': 'link', 'source': { 'id': 'fd3e0ab4-fd3a-4342-972b-3616e0c0a5cf', 'selector': 'g:nth-child(1) g:nth-child(3) g:nth-child(2) g:nth-child(4) circle:nth-child(1)      ', 'port': 'no' }, 'target': { 'id': '857c9deb-86c3-47d8-bc6d-8f36c5294eab' }, 'id': 'eecaae21-3e81-43f9-a5c1-6ea40c1adba8', 'embeds': '', 'z': 13, 'attrs': { '.marker-target': { 'd': 'M 10 0 L 0 5 L 10 10 z', 'fill': '#6a6c8a', 'stroke': '#6a6c8a' }, '.connection': { 'stroke': '#6a6c8a', 'stroke-width': 2 } } }] });
            //this.graph.fromJSON({ 'cells': [{ "type": "qad.Question", "optionHeight": 30, "questionHeight": 45, "paddingBottom": 30, "minWidth": 150, "ports": { "groups": { "in": { "position": "top", "attrs": { "circle": { "magnet": "passive", "stroke": "white", "fill": "rgb(119,176,170)", "r": 14 }, "text": { "pointerEvents": "none", "fontSize": 12, "fill": "white" } }, "label": { "position": { "name": "left", "args": { "x": 5 } } } }, "out": { "position": "right", "attrs": { "circle": { "magnet": true, "stroke": "none", "fill": "rgb(220,136,79)", "r": 14 } } } }, "items": [{ "group": "in", "attrs": { "text": { "text": "in" } }, "id": "aad15c6f-3caf-4c09-a0c8-67c96747506d" }, { "group": "out", "id": "option-37", "args": { "y": 60 } }] }, "position": { "x": 230, "y": 110 }, "size": { "width": 181.42945861816406, "height": 105 }, "angle": 0, "question": "hello, what is your name?", "inPorts": [{ "id": "in", "label": "In" }], "options": [{ "id": "option-37", "text": "$esTP;" }], "id": "14566522-2279-4733-88b7-d326d44423fd", "z": 1, "attrs": { ".options": { "refY": 45 }, ".question-text": { "text": "hello, what is your name?" }, ".option-option-37": { "transform": "translate(0, 0)", "dynamic": true }, ".option-option-37 .option-rect": { "height": 30, "dynamic": true }, ".option-option-37 .option-text": { "text": "$esTP;", "dynamic": true, "refY": 15 } } }] });
            this.graph.fromJSON(jsonVal2);
        } else {
            // var w1 = { 'cells': [{ 'type': 'qad.Question', 'optionHeight': 30, 'questionHeight': 45, 'paddingBottom': 30, 'minWidth': 150, 'ports': { 'groups': { 'in': { 'position': 'top', 'attrs': { 'circle': { 'magnet': 'passive', 'stroke': 'white', 'fill': '#feb663', 'r': 14 }, 'text': { 'pointerEvents': 'none', 'fontSize': 12, 'fill': 'white' } }, 'label': { 'position': { 'name': 'left', 'args': { 'x': 5 } } } }, 'out': { 'position': 'right', 'attrs': { 'circle': { 'magnet': true, 'stroke': 'none', 'fill': '#31d0c6', 'r': 14 } } } }, 'items': [{ 'group': 'in', 'attrs': { 'text': { 'text': 'in' } }, 'id': '3ef1df14-fd20-48d6-9700-d4f1e9ab183f' }, { 'group': 'out', 'id': 'yes', 'args': { 'y': 60 } }, { 'group': 'out', 'id': 'no', 'args': { 'y': 90 } }] }, 'position': { 'x': 45, 'y': 38 }, 'size': { 'width': 150.3046875, 'height': 135 }, 'angle': 0, 'question': 'Does the thing work?', 'options': [{ 'id': 'yes', 'text': 'Yes' }, { 'id': 'no', 'text': 'No' }], 'id': 'd849d917-8a43-4d51-9e99-291799c144db', 'z': 1, 'attrs': { '.options': { 'refY': 45 }, '.question-text': { 'text': 'Does the thing work?' }, '.inPorts>.port-in>.port-label': { 'text': 'In' }, '.inPorts>.port-in>.port-body': { 'port': { 'id': 'in', 'type': 'in', 'label': 'In' } }, '.inPorts>.port-in': { 'ref': '.body', 'ref-x': 0.5 }, '.option-yes': { 'transform': 'translate(0, 0)', 'dynamic': true }, '.option-yes .option-rect': { 'height': 30, 'dynamic': true }, '.option-yes .option-text': { 'text': 'Yes', 'dynamic': true, 'refY': 15 }, '.option-no': { 'transform': 'translate(0, 30)', 'dynamic': true }, '.option-no .option-rect': { 'height': 30, 'dynamic': true }, '.option-no .option-text': { 'text': 'No', 'dynamic': true, 'refY': 15 } } }, { 'type': 'qad.Answer', 'position': { 'x': 464, 'y': 65 }, 'size': { 'width': 223.796875, 'height': 66.8 }, 'angle': 0, 'inPorts': [{ 'id': 'in', 'label': 'In' }], 'outPorts': [{ 'id': 'yes', 'label': 'Yes' }, { 'id': 'no', 'label': 'No' }], 'answer': 'Don\'t mess about with it.', 'id': '4073e883-1cc6-46a5-b22d-688ca1934324', 'z': 2, 'attrs': { 'text': { 'text': 'Don\'t mess about with it.' } } }, { 'type': 'link', 'source': { 'id': 'd849d917-8a43-4d51-9e99-291799c144db', 'selector': 'g:nth-child(1) g:nth-child(3) g:nth-child(1) g:nth-child(4) circle:nth-child(1)      ', 'port': 'yes' }, 'target': { 'id': '4073e883-1cc6-46a5-b22d-688ca1934324' }, 'id': '9d87214a-7b08-47ce-9aec-8e49ed7ae929', 'embeds': '', 'z': 3, 'attrs': { '.marker-target': { 'd': 'M 10 0 L 0 5 L 10 10 z', 'fill': '#6a6c8a', 'stroke': '#6a6c8a' }, '.connection': { 'stroke': '#6a6c8a', 'strokeWidth': 2 } } }, { 'type': 'qad.Question', 'optionHeight': 30, 'questionHeight': 45, 'paddingBottom': 30, 'minWidth': 150, 'ports': { 'groups': { 'in': { 'position': 'top', 'attrs': { 'circle': { 'magnet': 'passive', 'stroke': 'white', 'fill': '#feb663', 'r': 14 }, 'text': { 'pointerEvents': 'none', 'fontSize': 12, 'fill': 'white' } }, 'label': { 'position': { 'name': 'left', 'args': { 'x': 5 } } } }, 'out': { 'position': 'right', 'attrs': { 'circle': { 'magnet': true, 'stroke': 'none', 'fill': '#31d0c6', 'r': 14 } } } }, 'items': [{ 'group': 'in', 'attrs': { 'text': { 'text': 'in' } }, 'id': '32499902-9bd1-4a9f-b4b4-80ee89751594' }, { 'group': 'out', 'id': 'yes', 'args': { 'y': 60 } }, { 'group': 'out', 'id': 'no', 'args': { 'y': 90 } }] }, 'position': { 'x': 55, 'y': 245 }, 'size': { 'width': 195.6484375, 'height': 135 }, 'angle': 0, 'question': 'Did you mess about with it?', 'options': [{ 'id': 'yes', 'text': 'Yes' }, { 'id': 'no', 'text': 'No' }], 'id': '8ce3f820-54f0-41f0-a46c-1e4f57b5f91e', 'z': 4, 'attrs': { '.options': { 'refY': 45 }, '.question-text': { 'text': 'Did you mess about with it?' }, '.inPorts>.port-in>.port-label': { 'text': 'In' }, '.inPorts>.port-in>.port-body': { 'port': { 'id': 'in', 'type': 'in', 'label': 'In' } }, '.inPorts>.port-in': { 'ref': '.body', 'ref-x': 0.5 }, '.option-yes': { 'transform': 'translate(0, 0)', 'dynamic': true }, '.option-yes .option-rect': { 'height': 30, 'dynamic': true }, '.option-yes .option-text': { 'text': 'Yes', 'dynamic': true, 'refY': 15 }, '.option-no': { 'transform': 'translate(0, 30)', 'dynamic': true }, '.option-no .option-rect': { 'height': 30, 'dynamic': true }, '.option-no .option-text': { 'text': 'No', 'dynamic': true, 'refY': 15 } } }, { 'type': 'qad.Answer', 'position': { 'x': 343, 'y': 203 }, 'size': { 'width': 125.59375, 'height': 66.8 }, 'angle': 0, 'inPorts': [{ 'id': 'in', 'label': 'In' }], 'outPorts': [{ 'id': 'yes', 'label': 'Yes' }, { 'id': 'no', 'label': 'No' }], 'answer': 'Run away!', 'id': '7da45291-2535-4aa1-bb50-5cadd2b2fb91', 'z': 5, 'attrs': { 'text': { 'text': 'Run away!' } } }, { 'type': 'link', 'source': { 'id': '8ce3f820-54f0-41f0-a46c-1e4f57b5f91e', 'selector': 'g:nth-child(1) g:nth-child(3) g:nth-child(1) g:nth-child(4) circle:nth-child(1)      ', 'port': 'yes' }, 'target': { 'id': '7da45291-2535-4aa1-bb50-5cadd2b2fb91' }, 'id': 'fd9f3367-79b9-4f69-b5b7-2bba012e53bb', 'embeds': '', 'z': 6, 'attrs': { '.marker-target': { 'd': 'M 10 0 L 0 5 L 10 10 z', 'fill': '#6a6c8a', 'stroke': '#6a6c8a' }, '.connection': { 'stroke': '#6a6c8a', 'stroke-width': 2 } } }, { 'type': 'qad.Question', 'optionHeight': 30, 'questionHeight': 45, 'paddingBottom': 30, 'minWidth': 150, 'ports': { 'groups': { 'in': { 'position': 'top', 'attrs': { 'circle': { 'magnet': 'passive', 'stroke': 'white', 'fill': '#feb663', 'r': 14 }, 'text': { 'pointerEvents': 'none', 'fontSize': 12, 'fill': 'white' } }, 'label': { 'position': { 'name': 'left', 'args': { 'x': 5 } } } }, 'out': { 'position': 'right', 'attrs': { 'circle': { 'magnet': true, 'stroke': 'none', 'fill': '#31d0c6', 'r': 14 } } } }, 'items': [{ 'group': 'in', 'attrs': { 'text': { 'text': 'in' } }, 'id': '964ee8db-c3d5-47a3-ba44-31d7b93f8723' }, { 'group': 'out', 'id': 'yes', 'args': { 'y': 60 } }, { 'group': 'out', 'id': 'no', 'args': { 'y': 90 } }] }, 'position': { 'x': 238, 'y': 429 }, 'size': { 'width': 155.6171875, 'height': 135 }, 'angle': 0, 'question': 'Will you get screwed?', 'options': [{ 'id': 'yes', 'text': 'Yes' }, { 'id': 'no', 'text': 'No' }], 'id': 'fd3e0ab4-fd3a-4342-972b-3616e0c0a5cf', 'z': 7, 'attrs': { '.options': { 'refY': 45 }, '.question-text': { 'text': 'Will you get screwed?' }, '.inPorts>.port-in>.port-label': { 'text': 'In' }, '.inPorts>.port-in>.port-body': { 'port': { 'id': 'in', 'type': 'in', 'label': 'In' } }, '.inPorts>.port-in': { 'ref': '.body', 'ref-x': 0.5 }, '.option-yes': { 'transform': 'translate(0, 0)', 'dynamic': true }, '.option-yes .option-rect': { 'height': 30, 'dynamic': true }, '.option-yes .option-text': { 'text': 'Yes', 'dynamic': true, 'refY': 15 }, '.option-no': { 'transform': 'translate(0, 30)', 'dynamic': true }, '.option-no .option-rect': { 'height': 30, 'dynamic': true }, '.option-no .option-text': { 'text': 'No', 'dynamic': true, 'refY': 15 } } }, { 'type': 'link', 'source': { 'id': 'd849d917-8a43-4d51-9e99-291799c144db', 'selector': 'g:nth-child(1) g:nth-child(3) g:nth-child(2) g:nth-child(4) circle:nth-child(1)      ', 'port': 'no' }, 'target': { 'id': '8ce3f820-54f0-41f0-a46c-1e4f57b5f91e', 'magnet': 'circle', 'port': '32499902-9bd1-4a9f-b4b4-80ee89751594' }, 'id': '641410b2-aeb5-42ad-b757-2d9c6e4d56bd', 'embeds': '', 'z': 8, 'attrs': { '.marker-target': { 'd': 'M 10 0 L 0 5 L 10 10 z', 'fill': '#6a6c8a', 'stroke': '#6a6c8a' }, '.connection': { 'stroke': '#6a6c8a', 'stroke-width': 2 } } }, { 'type': 'link', 'source': { 'id': '8ce3f820-54f0-41f0-a46c-1e4f57b5f91e', 'selector': 'g:nth-child(1) g:nth-child(3) g:nth-child(2) g:nth-child(4) circle:nth-child(1)      ', 'port': 'no' }, 'target': { 'id': 'fd3e0ab4-fd3a-4342-972b-3616e0c0a5cf', 'magnet': 'circle', 'port': '964ee8db-c3d5-47a3-ba44-31d7b93f8723' }, 'id': '3b9de57d-be21-4e9e-a73b-693b32e5f14a', 'embeds': '', 'z': 9, 'attrs': { '.marker-target': { 'd': 'M 10 0 L 0 5 L 10 10 z', 'fill': '#6a6c8a', 'stroke': '#6a6c8a' }, '.connection': { 'stroke': '#6a6c8a', 'stroke-width': 2 } } }, { 'type': 'qad.Answer', 'position': { 'x': 553, 'y': 400 }, 'size': { 'width': 117.296875, 'height': 66.8 }, 'angle': 0, 'inPorts': [{ 'id': 'in', 'label': 'In' }], 'outPorts': [{ 'id': 'yes', 'label': 'Yes' }, { 'id': 'no', 'label': 'No' }], 'answer': 'Poor boy.', 'id': '13402455-006d-41e3-aacc-514f551b78b8', 'z': 10, 'attrs': { 'text': { 'text': 'Poor boy.' } } }, { 'type': 'qad.Answer', 'position': { 'x': 553, 'y': 524 }, 'size': { 'width': 146.9453125, 'height': 66.8 }, 'angle': 0, 'inPorts': [{ 'id': 'in', 'label': 'In' }], 'outPorts': [{ 'id': 'yes', 'label': 'Yes' }, { 'id': 'no', 'label': 'No' }], 'answer': 'Put it in a bin.', 'id': '857c9deb-86c3-47d8-bc6d-8f36c5294eab', 'z': 11, 'attrs': { 'text': { 'text': 'Put it in a bin.' } } }, { 'type': 'link', 'source': { 'id': 'fd3e0ab4-fd3a-4342-972b-3616e0c0a5cf', 'selector': 'g:nth-child(1) g:nth-child(3) g:nth-child(1) g:nth-child(4) circle:nth-child(1)      ', 'port': 'yes' }, 'target': { 'id': '13402455-006d-41e3-aacc-514f551b78b8' }, 'id': '7e96039d-c3d4-4c86-b8e5-9a49835e114b', 'embeds': '', 'z': 12, 'attrs': { '.marker-target': { 'd': 'M 10 0 L 0 5 L 10 10 z', 'fill': '#6a6c8a', 'stroke': '#6a6c8a' }, '.connection': { 'stroke': '#6a6c8a', 'stroke-width': 2 } } }, { 'type': 'link', 'source': { 'id': 'fd3e0ab4-fd3a-4342-972b-3616e0c0a5cf', 'selector': 'g:nth-child(1) g:nth-child(3) g:nth-child(2) g:nth-child(4) circle:nth-child(1)      ', 'port': 'no' }, 'target': { 'id': '857c9deb-86c3-47d8-bc6d-8f36c5294eab' }, 'id': 'eecaae21-3e81-43f9-a5c1-6ea40c1adba8', 'embeds': '', 'z': 13, 'attrs': { '.marker-target': { 'd': 'M 10 0 L 0 5 L 10 10 z', 'fill': '#6a6c8a', 'stroke': '#6a6c8a' }, '.connection': { 'stroke': '#6a6c8a', 'stroke-width': 2 } } }] };
            // console.log(typeof w1);
            this.selection.reset([]);
            //this.graph.fromJSON({ 'cells': [{ 'type': 'qad.Question', 'optionHeight': 30, 'questionHeight': 45, 'paddingBottom': 30, 'minWidth': 150, 'ports': { 'groups': { 'in': { 'position': 'top', 'attrs': { 'circle': { 'magnet': 'passive', 'stroke': 'white', 'fill': '#feb663', 'r': 14 }, 'text': { 'pointerEvents': 'none', 'fontSize': 12, 'fill': 'white' } }, 'label': { 'position': { 'name': 'left', 'args': { 'x': 5 } } } }, 'out': { 'position': 'right', 'attrs': { 'circle': { 'magnet': true, 'stroke': 'none', 'fill': '#31d0c6', 'r': 14 } } } }, 'items': [{ 'group': 'in', 'attrs': { 'text': { 'text': 'in' } }, 'id': '3ef1df14-fd20-48d6-9700-d4f1e9ab183f' }, { 'group': 'out', 'id': 'yes', 'args': { 'y': 60 } }, { 'group': 'out', 'id': 'no', 'args': { 'y': 90 } }] }, 'position': { 'x': 45, 'y': 38 }, 'size': { 'width': 150.3046875, 'height': 135 }, 'angle': 0, 'question': 'Does the thing work?', 'options': [{ 'id': 'yes', 'text': 'Yes' }, { 'id': 'no', 'text': 'No' }], 'id': 'd849d917-8a43-4d51-9e99-291799c144db', 'z': 1, 'attrs': { '.options': { 'refY': 45 }, '.question-text': { 'text': 'Does the thing work?' }, '.inPorts>.port-in>.port-label': { 'text': 'In' }, '.inPorts>.port-in>.port-body': { 'port': { 'id': 'in', 'type': 'in', 'label': 'In' } }, '.inPorts>.port-in': { 'ref': '.body', 'ref-x': 0.5 }, '.option-yes': { 'transform': 'translate(0, 0)', 'dynamic': true }, '.option-yes .option-rect': { 'height': 30, 'dynamic': true }, '.option-yes .option-text': { 'text': 'Yes', 'dynamic': true, 'refY': 15 }, '.option-no': { 'transform': 'translate(0, 30)', 'dynamic': true }, '.option-no .option-rect': { 'height': 30, 'dynamic': true }, '.option-no .option-text': { 'text': 'No', 'dynamic': true, 'refY': 15 } } }, { 'type': 'qad.Answer', 'position': { 'x': 464, 'y': 65 }, 'size': { 'width': 223.796875, 'height': 66.8 }, 'angle': 0, 'inPorts': [{ 'id': 'in', 'label': 'In' }], 'outPorts': [{ 'id': 'yes', 'label': 'Yes' }, { 'id': 'no', 'label': 'No' }], 'answer': 'Don\'t mess about with it.', 'id': '4073e883-1cc6-46a5-b22d-688ca1934324', 'z': 2, 'attrs': { 'text': { 'text': 'Don\'t mess about with it.' } } }, { 'type': 'link', 'source': { 'id': 'd849d917-8a43-4d51-9e99-291799c144db', 'selector': 'g:nth-child(1) g:nth-child(3) g:nth-child(1) g:nth-child(4) circle:nth-child(1)      ', 'port': 'yes' }, 'target': { 'id': '4073e883-1cc6-46a5-b22d-688ca1934324' }, 'id': '9d87214a-7b08-47ce-9aec-8e49ed7ae929', 'embeds': '', 'z': 3, 'attrs': { '.marker-target': { 'd': 'M 10 0 L 0 5 L 10 10 z', 'fill': '#6a6c8a', 'stroke': '#6a6c8a' }, '.connection': { 'stroke': '#6a6c8a', 'strokeWidth': 2 } } }, { 'type': 'qad.Question', 'optionHeight': 30, 'questionHeight': 45, 'paddingBottom': 30, 'minWidth': 150, 'ports': { 'groups': { 'in': { 'position': 'top', 'attrs': { 'circle': { 'magnet': 'passive', 'stroke': 'white', 'fill': '#feb663', 'r': 14 }, 'text': { 'pointerEvents': 'none', 'fontSize': 12, 'fill': 'white' } }, 'label': { 'position': { 'name': 'left', 'args': { 'x': 5 } } } }, 'out': { 'position': 'right', 'attrs': { 'circle': { 'magnet': true, 'stroke': 'none', 'fill': '#31d0c6', 'r': 14 } } } }, 'items': [{ 'group': 'in', 'attrs': { 'text': { 'text': 'in' } }, 'id': '32499902-9bd1-4a9f-b4b4-80ee89751594' }, { 'group': 'out', 'id': 'yes', 'args': { 'y': 60 } }, { 'group': 'out', 'id': 'no', 'args': { 'y': 90 } }] }, 'position': { 'x': 55, 'y': 245 }, 'size': { 'width': 195.6484375, 'height': 135 }, 'angle': 0, 'question': 'Did you mess about with it?', 'options': [{ 'id': 'yes', 'text': 'Yes' }, { 'id': 'no', 'text': 'No' }], 'id': '8ce3f820-54f0-41f0-a46c-1e4f57b5f91e', 'z': 4, 'attrs': { '.options': { 'refY': 45 }, '.question-text': { 'text': 'Did you mess about with it?' }, '.inPorts>.port-in>.port-label': { 'text': 'In' }, '.inPorts>.port-in>.port-body': { 'port': { 'id': 'in', 'type': 'in', 'label': 'In' } }, '.inPorts>.port-in': { 'ref': '.body', 'ref-x': 0.5 }, '.option-yes': { 'transform': 'translate(0, 0)', 'dynamic': true }, '.option-yes .option-rect': { 'height': 30, 'dynamic': true }, '.option-yes .option-text': { 'text': 'Yes', 'dynamic': true, 'refY': 15 }, '.option-no': { 'transform': 'translate(0, 30)', 'dynamic': true }, '.option-no .option-rect': { 'height': 30, 'dynamic': true }, '.option-no .option-text': { 'text': 'No', 'dynamic': true, 'refY': 15 } } }, { 'type': 'qad.Answer', 'position': { 'x': 343, 'y': 203 }, 'size': { 'width': 125.59375, 'height': 66.8 }, 'angle': 0, 'inPorts': [{ 'id': 'in', 'label': 'In' }], 'outPorts': [{ 'id': 'yes', 'label': 'Yes' }, { 'id': 'no', 'label': 'No' }], 'answer': 'Run away!', 'id': '7da45291-2535-4aa1-bb50-5cadd2b2fb91', 'z': 5, 'attrs': { 'text': { 'text': 'Run away!' } } }, { 'type': 'link', 'source': { 'id': '8ce3f820-54f0-41f0-a46c-1e4f57b5f91e', 'selector': 'g:nth-child(1) g:nth-child(3) g:nth-child(1) g:nth-child(4) circle:nth-child(1)      ', 'port': 'yes' }, 'target': { 'id': '7da45291-2535-4aa1-bb50-5cadd2b2fb91' }, 'id': 'fd9f3367-79b9-4f69-b5b7-2bba012e53bb', 'embeds': '', 'z': 6, 'attrs': { '.marker-target': { 'd': 'M 10 0 L 0 5 L 10 10 z', 'fill': '#6a6c8a', 'stroke': '#6a6c8a' }, '.connection': { 'stroke': '#6a6c8a', 'stroke-width': 2 } } }, { 'type': 'qad.Question', 'optionHeight': 30, 'questionHeight': 45, 'paddingBottom': 30, 'minWidth': 150, 'ports': { 'groups': { 'in': { 'position': 'top', 'attrs': { 'circle': { 'magnet': 'passive', 'stroke': 'white', 'fill': '#feb663', 'r': 14 }, 'text': { 'pointerEvents': 'none', 'fontSize': 12, 'fill': 'white' } }, 'label': { 'position': { 'name': 'left', 'args': { 'x': 5 } } } }, 'out': { 'position': 'right', 'attrs': { 'circle': { 'magnet': true, 'stroke': 'none', 'fill': '#31d0c6', 'r': 14 } } } }, 'items': [{ 'group': 'in', 'attrs': { 'text': { 'text': 'in' } }, 'id': '964ee8db-c3d5-47a3-ba44-31d7b93f8723' }, { 'group': 'out', 'id': 'yes', 'args': { 'y': 60 } }, { 'group': 'out', 'id': 'no', 'args': { 'y': 90 } }] }, 'position': { 'x': 238, 'y': 429 }, 'size': { 'width': 155.6171875, 'height': 135 }, 'angle': 0, 'question': 'Will you get screwed?', 'options': [{ 'id': 'yes', 'text': 'Yes' }, { 'id': 'no', 'text': 'No' }], 'id': 'fd3e0ab4-fd3a-4342-972b-3616e0c0a5cf', 'z': 7, 'attrs': { '.options': { 'refY': 45 }, '.question-text': { 'text': 'Will you get screwed?' }, '.inPorts>.port-in>.port-label': { 'text': 'In' }, '.inPorts>.port-in>.port-body': { 'port': { 'id': 'in', 'type': 'in', 'label': 'In' } }, '.inPorts>.port-in': { 'ref': '.body', 'ref-x': 0.5 }, '.option-yes': { 'transform': 'translate(0, 0)', 'dynamic': true }, '.option-yes .option-rect': { 'height': 30, 'dynamic': true }, '.option-yes .option-text': { 'text': 'Yes', 'dynamic': true, 'refY': 15 }, '.option-no': { 'transform': 'translate(0, 30)', 'dynamic': true }, '.option-no .option-rect': { 'height': 30, 'dynamic': true }, '.option-no .option-text': { 'text': 'No', 'dynamic': true, 'refY': 15 } } }, { 'type': 'link', 'source': { 'id': 'd849d917-8a43-4d51-9e99-291799c144db', 'selector': 'g:nth-child(1) g:nth-child(3) g:nth-child(2) g:nth-child(4) circle:nth-child(1)      ', 'port': 'no' }, 'target': { 'id': '8ce3f820-54f0-41f0-a46c-1e4f57b5f91e', 'magnet': 'circle', 'port': '32499902-9bd1-4a9f-b4b4-80ee89751594' }, 'id': '641410b2-aeb5-42ad-b757-2d9c6e4d56bd', 'embeds': '', 'z': 8, 'attrs': { '.marker-target': { 'd': 'M 10 0 L 0 5 L 10 10 z', 'fill': '#6a6c8a', 'stroke': '#6a6c8a' }, '.connection': { 'stroke': '#6a6c8a', 'stroke-width': 2 } } }, { 'type': 'link', 'source': { 'id': '8ce3f820-54f0-41f0-a46c-1e4f57b5f91e', 'selector': 'g:nth-child(1) g:nth-child(3) g:nth-child(2) g:nth-child(4) circle:nth-child(1)      ', 'port': 'no' }, 'target': { 'id': 'fd3e0ab4-fd3a-4342-972b-3616e0c0a5cf', 'magnet': 'circle', 'port': '964ee8db-c3d5-47a3-ba44-31d7b93f8723' }, 'id': '3b9de57d-be21-4e9e-a73b-693b32e5f14a', 'embeds': '', 'z': 9, 'attrs': { '.marker-target': { 'd': 'M 10 0 L 0 5 L 10 10 z', 'fill': '#6a6c8a', 'stroke': '#6a6c8a' }, '.connection': { 'stroke': '#6a6c8a', 'stroke-width': 2 } } }, { 'type': 'qad.Answer', 'position': { 'x': 553, 'y': 400 }, 'size': { 'width': 117.296875, 'height': 66.8 }, 'angle': 0, 'inPorts': [{ 'id': 'in', 'label': 'In' }], 'outPorts': [{ 'id': 'yes', 'label': 'Yes' }, { 'id': 'no', 'label': 'No' }], 'answer': 'Poor boy.', 'id': '13402455-006d-41e3-aacc-514f551b78b8', 'z': 10, 'attrs': { 'text': { 'text': 'Poor boy.' } } }, { 'type': 'qad.Answer', 'position': { 'x': 553, 'y': 524 }, 'size': { 'width': 146.9453125, 'height': 66.8 }, 'angle': 0, 'inPorts': [{ 'id': 'in', 'label': 'In' }], 'outPorts': [{ 'id': 'yes', 'label': 'Yes' }, { 'id': 'no', 'label': 'No' }], 'answer': 'Put it in a bin.', 'id': '857c9deb-86c3-47d8-bc6d-8f36c5294eab', 'z': 11, 'attrs': { 'text': { 'text': 'Put it in a bin.' } } }, { 'type': 'link', 'source': { 'id': 'fd3e0ab4-fd3a-4342-972b-3616e0c0a5cf', 'selector': 'g:nth-child(1) g:nth-child(3) g:nth-child(1) g:nth-child(4) circle:nth-child(1)      ', 'port': 'yes' }, 'target': { 'id': '13402455-006d-41e3-aacc-514f551b78b8' }, 'id': '7e96039d-c3d4-4c86-b8e5-9a49835e114b', 'embeds': '', 'z': 12, 'attrs': { '.marker-target': { 'd': 'M 10 0 L 0 5 L 10 10 z', 'fill': '#6a6c8a', 'stroke': '#6a6c8a' }, '.connection': { 'stroke': '#6a6c8a', 'stroke-width': 2 } } }, { 'type': 'link', 'source': { 'id': 'fd3e0ab4-fd3a-4342-972b-3616e0c0a5cf', 'selector': 'g:nth-child(1) g:nth-child(3) g:nth-child(2) g:nth-child(4) circle:nth-child(1)      ', 'port': 'no' }, 'target': { 'id': '857c9deb-86c3-47d8-bc6d-8f36c5294eab' }, 'id': 'eecaae21-3e81-43f9-a5c1-6ea40c1adba8', 'embeds': '', 'z': 13, 'attrs': { '.marker-target': { 'd': 'M 10 0 L 0 5 L 10 10 z', 'fill': '#6a6c8a', 'stroke': '#6a6c8a' }, '.connection': { 'stroke': '#6a6c8a', 'stroke-width': 2 } } }] });
            this.graph.fromJSON({ "length": 16, "cells": [{ "type": "qad.Question", "optionHeight": 30, "questionHeight": 75, "paddingBottom": 30, "minWidth": 150, "ports": { "groups": { "in": { "position": "top", "attrs": { "circle": { "magnet": "passive", "stroke": "white", "fill": "rgb(199,26,154)", "r": 14 }, "text": { "pointerEvents": "none", "fontSize": 12, "fill": "white" } }, "label": { "position": { "name": "left", "args": { "x": 5 } } } }, "out": { "position": "right", "attrs": { "circle": { "magnet": true, "stroke": "none", "fill": "rgb(216,239,162)", "r": 14 } } } }, "items": [{ "group": "in", "attrs": { "text": { "text": "in" } }, "id": "43035d0f-508c-4507-badd-4ffd0fb3e0f2" }, { "group": "out", "id": "option-25", "args": { "y": 90 } }] }, "position": { "x": 100, "y": 80 }, "size": { "width": 256, "height": 135 }, "angle": 0, "question": "初めまして，メイと申します．\nよろしくお願いいたします．\n最初に，お名前を教えてください．", "inPorts": [{ "id": "in", "label": "In" }], "options": [{ "id": "option-25", "text": "$tTK9;" }], "id": "c0b23d00-ee39-4297-8d7d-868d6a9d5e91", "z": 1, "attrs": { ".options": { "refY": 75 }, ".question-text": { "text": "初めまして，メイと申します．\nよろしくお願いいたします．\n最初に，お名前を教えてください．" }, ".option-option-25": { "transform": "translate(0, 0)", "dynamic": true }, ".option-option-25 .option-rect": { "height": 30, "dynamic": true }, ".option-option-25 .option-text": { "text": "$tTK9;", "dynamic": true, "refY": 15 } } }, { "type": "qad.Question", "optionHeight": 30, "questionHeight": 60, "paddingBottom": 30, "minWidth": 150, "ports": { "groups": { "in": { "position": "top", "attrs": { "circle": { "magnet": "passive", "stroke": "white", "fill": "rgb(199,26,154)", "r": 14 }, "text": { "pointerEvents": "none", "fontSize": 12, "fill": "white" } }, "label": { "position": { "name": "left", "args": { "x": 5 } } } }, "out": { "position": "right", "attrs": { "circle": { "magnet": true, "stroke": "none", "fill": "rgb(216,239,162)", "r": 14 } } } }, "items": [{ "group": "in", "attrs": { "text": { "text": "in" } }, "id": "c56eae1d-21e1-4ffe-bcf1-ab1f72530a14" }, { "group": "out", "id": "option-39", "args": { "y": 75 } }, { "group": "out", "id": "option-47", "args": { "y": 105 } }] }, "position": { "x": 300, "y": 340 }, "size": { "width": 192, "height": 150 }, "angle": 0, "question": "$tTK9;さんと呼ばれて，\n間違いはないでしょうか？", "inPorts": [{ "id": "in", "label": "In" }], "options": [{ "id": "option-39", "text": "はい．" }, { "id": "option-47", "text": "いいえ，違います" }], "id": "5e888baf-5fcf-45d9-a0b6-a6408b48c4c8", "z": 2, "attrs": { ".options": { "refY": 60 }, ".question-text": { "text": "$tTK9;さんと呼ばれて，\n間違いはないでしょうか？" }, ".option-option-39": { "transform": "translate(0, 0)", "dynamic": true }, ".option-option-39 .option-rect": { "height": 30, "dynamic": true }, ".option-option-39 .option-text": { "text": "はい．", "dynamic": true, "refY": 15 }, ".option-option-47": { "transform": "translate(0, 30)", "dynamic": true }, ".option-option-47 .option-rect": { "height": 30, "dynamic": true }, ".option-option-47 .option-text": { "text": "いいえ，違います", "dynamic": true, "refY": 15 } } }, { "type": "qad.Question", "optionHeight": 30, "questionHeight": 45, "paddingBottom": 30, "minWidth": 150, "ports": { "groups": { "in": { "position": "top", "attrs": { "circle": { "magnet": "passive", "stroke": "white", "fill": "rgb(199,26,154)", "r": 14 }, "text": { "pointerEvents": "none", "fontSize": 12, "fill": "white" } }, "label": { "position": { "name": "left", "args": { "x": 5 } } } }, "out": { "position": "right", "attrs": { "circle": { "magnet": true, "stroke": "none", "fill": "rgb(216,239,162)", "r": 14 } } } }, "items": [{ "group": "in", "attrs": { "text": { "text": "in" } }, "id": "c56eae1d-21e1-4ffe-bcf1-ab1f72530a14" }, { "group": "out", "id": "option-145", "args": { "y": 60 } }] }, "position": { "x": 580, "y": 470 }, "size": { "width": 287.1328125, "height": 105 }, "angle": 0, "question": "$tTK9;さんはどちらの出身でしょうか？", "inPorts": [{ "id": "in", "label": "In" }], "options": [{ "id": "option-145", "text": "$6oGM;" }], "id": "561fbcf4-fe23-48d9-bb04-7c9d8251ccb2", "z": 5, "attrs": { ".options": { "refY": 45 }, ".question-text": { "text": "$tTK9;さんはどちらの出身でしょうか？" }, ".option-option-145": { "transform": "translate(0, 0)", "dynamic": true }, ".option-option-145 .option-rect": { "height": 30, "dynamic": true }, ".option-option-145 .option-text": { "text": "$6oGM;", "dynamic": true, "refY": 15 } } }, { "type": "qad.Question", "optionHeight": 30, "questionHeight": 45, "paddingBottom": 30, "minWidth": 150, "ports": { "groups": { "in": { "position": "top", "attrs": { "circle": { "magnet": "passive", "stroke": "white", "fill": "rgb(199,26,154)", "r": 14 }, "text": { "pointerEvents": "none", "fontSize": 12, "fill": "white" } }, "label": { "position": { "name": "left", "args": { "x": 5 } } } }, "out": { "position": "right", "attrs": { "circle": { "magnet": true, "stroke": "none", "fill": "rgb(216,239,162)", "r": 14 } } } }, "items": [{ "group": "in", "attrs": { "text": { "text": "in" } }, "id": "c56eae1d-21e1-4ffe-bcf1-ab1f72530a14" }, { "group": "out", "id": "option-195", "args": { "y": 60 } }] }, "position": { "x": 550, "y": 230 }, "size": { "width": 296.9140625, "height": 105 }, "angle": 0, "question": "そうですか，$6oGM;の名物は何ですか？", "inPorts": [{ "id": "in", "label": "In" }], "options": [{ "id": "option-195", "text": "$AoPC;" }], "id": "a45cf403-47df-49c0-88bf-d429ff7423c7", "z": 7, "attrs": { ".options": { "refY": 45 }, ".question-text": { "text": "そうですか，$6oGM;の名物は何ですか？" }, ".option-option-195": { "transform": "translate(0, 0)", "dynamic": true }, ".option-option-195 .option-rect": { "height": 30, "dynamic": true }, ".option-option-195 .option-text": { "text": "$AoPC;", "dynamic": true, "refY": 15 } } }, { "type": "qad.Question", "optionHeight": 30, "questionHeight": 45, "paddingBottom": 30, "minWidth": 150, "ports": { "groups": { "in": { "position": "top", "attrs": { "circle": { "magnet": "passive", "stroke": "white", "fill": "rgb(199,26,154)", "r": 14 }, "text": { "pointerEvents": "none", "fontSize": 12, "fill": "white" } }, "label": { "position": { "name": "left", "args": { "x": 5 } } } }, "out": { "position": "right", "attrs": { "circle": { "magnet": true, "stroke": "none", "fill": "rgb(216,239,162)", "r": 14 } } } }, "items": [{ "group": "in", "attrs": { "text": { "text": "in" } }, "id": "ff3a9338-359c-449c-b907-5b4b448b95d1" }, { "group": "out", "id": "option-213", "args": { "y": 60 } }, { "group": "out", "id": "option-226", "args": { "y": 90 } }] }, "position": { "x": 950, "y": 330 }, "size": { "width": 187.5859375, "height": 135 }, "angle": 0, "question": "$AoPC; はお好きですか？", "inPorts": [{ "id": "in", "label": "In" }], "options": [{ "id": "option-213", "text": "はい" }, { "id": "option-226", "text": "いいえ" }], "id": "eb36d2a6-8562-4ec9-865a-a25db7e5b3a3", "z": 9, "attrs": { ".options": { "refY": 45 }, ".question-text": { "text": "$AoPC; はお好きですか？" }, ".option-option-213": { "transform": "translate(0, 0)", "dynamic": true }, ".option-option-213 .option-rect": { "height": 30, "dynamic": true }, ".option-option-213 .option-text": { "text": "はい", "dynamic": true, "refY": 15 }, ".option-option-226": { "transform": "translate(0, 30)", "dynamic": true }, ".option-option-226 .option-rect": { "height": 30, "dynamic": true }, ".option-option-226 .option-text": { "text": "いいえ", "dynamic": true, "refY": 15 } } }, { "type": "qad.Answer", "padding": 50, "position": { "x": 640, "y": 40 }, "size": { "width": 370, "height": 100.4 }, "angle": 0, "answer": "そうですか，チャンスがあれば，\n私も $AoPC; を食べたいですね．\n会話は以上です．ありがとうございました．", "id": "f21c36ae-fa71-41a2-976d-f258c535b973", "z": 11, "attrs": { "label": { "text": "そうですか，チャンスがあれば，\n私も $AoPC; を食べたいですね．\n会話は以上です．ありがとうございました．" } } }, { "type": "qad.Question", "optionHeight": 30, "questionHeight": 60, "paddingBottom": 30, "minWidth": 150, "ports": { "groups": { "in": { "position": "top", "attrs": { "circle": { "magnet": "passive", "stroke": "white", "fill": "rgb(199,26,154)", "r": 14 }, "text": { "pointerEvents": "none", "fontSize": 12, "fill": "white" } }, "label": { "position": { "name": "left", "args": { "x": 5 } } } }, "out": { "position": "right", "attrs": { "circle": { "magnet": true, "stroke": "none", "fill": "rgb(216,239,162)", "r": 14 } } } }, "items": [{ "group": "in", "attrs": { "text": { "text": "in" } }, "id": "c56eae1d-21e1-4ffe-bcf1-ab1f72530a14" }, { "group": "out", "id": "option-324", "args": { "y": 75 } }] }, "position": { "x": 1060, "y": 560 }, "size": { "width": 243.609375, "height": 120 }, "angle": 0, "question": "$tTK9; さんは $AoPC; が好きでは\nない理由は何でしょうか？", "inPorts": [{ "id": "in", "label": "In" }], "options": [{ "id": "option-324", "text": "$nCGu;" }], "id": "03a1baa5-db5e-4aa6-8839-1a81e4cf6a2e", "z": 13, "attrs": { ".options": { "refY": 60 }, ".question-text": { "text": "$tTK9; さんは $AoPC; が好きでは\nない理由は何でしょうか？" }, ".option-option-324": { "transform": "translate(0, 0)", "dynamic": true }, ".option-option-324 .option-rect": { "height": 30, "dynamic": true }, ".option-option-324 .option-text": { "text": "$nCGu;", "dynamic": true, "refY": 15 } } }, { "type": "qad.Answer", "padding": 50, "position": { "x": 360, "y": 660 }, "size": { "width": 274, "height": 100.4 }, "angle": 0, "answer": "$nCGu;という理由ですか，\n残念ですね．会話は以上です．\nありがとうございました．", "id": "99349dac-12fe-4020-8c36-02204091c31d", "z": 15, "attrs": { "label": { "text": "$nCGu;という理由ですか，\n残念ですね．会話は以上です．\nありがとうございました．" } } }, { "type": "link", "source": { "id": "5e888baf-5fcf-45d9-a0b6-a6408b48c4c8", "magnet": "circle", "port": "option-47" }, "target": { "id": "c0b23d00-ee39-4297-8d7d-868d6a9d5e91", "magnet": "circle", "port": "43035d0f-508c-4507-badd-4ffd0fb3e0f2" }, "id": "564364df-b11c-459f-b4b0-49767dd489c2", "z": 3, "attrs": { ".marker-target": { "d": "M 10 0 L 0 5 L 10 10 z", "fill": "#406cfc", "stroke": "#406cfc" }, ".connection": { "stroke": "#406cfc", "strokeWidth": 2 } } }, { "type": "link", "source": { "id": "c0b23d00-ee39-4297-8d7d-868d6a9d5e91", "magnet": "circle", "port": "option-25" }, "target": { "id": "5e888baf-5fcf-45d9-a0b6-a6408b48c4c8", "magnet": "circle", "port": "c56eae1d-21e1-4ffe-bcf1-ab1f72530a14" }, "id": "32665563-dfee-410f-b26f-1cb9291c8f7c", "z": 4, "attrs": { ".marker-target": { "d": "M 10 0 L 0 5 L 10 10 z", "fill": "#406cfc", "stroke": "#406cfc" }, ".connection": { "stroke": "#406cfc", "strokeWidth": 2 } } }, { "type": "link", "source": { "id": "5e888baf-5fcf-45d9-a0b6-a6408b48c4c8", "magnet": "circle", "port": "option-39" }, "target": { "id": "561fbcf4-fe23-48d9-bb04-7c9d8251ccb2", "magnet": "circle", "port": "c56eae1d-21e1-4ffe-bcf1-ab1f72530a14" }, "id": "cb3dee9d-7a79-4a1b-8e2d-67ee55bf4b32", "z": 6, "attrs": { ".marker-target": { "d": "M 10 0 L 0 5 L 10 10 z", "fill": "#406cfc", "stroke": "#406cfc" }, ".connection": { "stroke": "#406cfc", "strokeWidth": 2 } } }, { "type": "link", "source": { "id": "561fbcf4-fe23-48d9-bb04-7c9d8251ccb2", "magnet": "circle", "port": "option-145" }, "target": { "id": "a45cf403-47df-49c0-88bf-d429ff7423c7", "magnet": "circle", "port": "c56eae1d-21e1-4ffe-bcf1-ab1f72530a14" }, "id": "ce986365-4f67-4f8f-a4d6-152db018cee7", "z": 8, "attrs": { ".marker-target": { "d": "M 10 0 L 0 5 L 10 10 z", "fill": "#406cfc", "stroke": "#406cfc" }, ".connection": { "stroke": "#406cfc", "strokeWidth": 2 } } }, { "type": "link", "source": { "id": "a45cf403-47df-49c0-88bf-d429ff7423c7", "magnet": "circle", "port": "option-195" }, "target": { "id": "eb36d2a6-8562-4ec9-865a-a25db7e5b3a3", "magnet": "circle", "port": "ff3a9338-359c-449c-b907-5b4b448b95d1" }, "id": "5c036293-e1ea-47b0-b8b1-57ff8643ee44", "z": 10, "attrs": { ".marker-target": { "d": "M 10 0 L 0 5 L 10 10 z", "fill": "#406cfc", "stroke": "#406cfc" }, ".connection": { "stroke": "#406cfc", "strokeWidth": 2 } } }, { "type": "link", "source": { "id": "eb36d2a6-8562-4ec9-865a-a25db7e5b3a3", "magnet": "circle", "port": "option-213" }, "target": { "id": "f21c36ae-fa71-41a2-976d-f258c535b973" }, "id": "3d485fac-d584-442c-9af1-482742e914c6", "z": 12, "attrs": { ".marker-target": { "d": "M 10 0 L 0 5 L 10 10 z", "fill": "#406cfc", "stroke": "#406cfc" }, ".connection": { "stroke": "#406cfc", "strokeWidth": 2 } } }, { "type": "link", "source": { "id": "eb36d2a6-8562-4ec9-865a-a25db7e5b3a3", "magnet": "circle", "port": "option-226" }, "target": { "id": "03a1baa5-db5e-4aa6-8839-1a81e4cf6a2e", "magnet": "circle", "port": "c56eae1d-21e1-4ffe-bcf1-ab1f72530a14" }, "id": "f7a28f14-472a-4862-9e3b-f86a90da963d", "z": 14, "attrs": { ".marker-target": { "d": "M 10 0 L 0 5 L 10 10 z", "fill": "#406cfc", "stroke": "#406cfc" }, ".connection": { "stroke": "#406cfc", "strokeWidth": 2 } } }, { "type": "link", "source": { "id": "03a1baa5-db5e-4aa6-8839-1a81e4cf6a2e", "magnet": "circle", "port": "option-324" }, "target": { "id": "99349dac-12fe-4020-8c36-02204091c31d" }, "id": "3ca07b33-a908-416b-a550-785c28008342", "z": 16, "attrs": { ".marker-target": { "d": "M 10 0 L 0 5 L 10 10 z", "fill": "#406cfc", "stroke": "#406cfc" }, ".connection": { "stroke": "#406cfc", "strokeWidth": 2 } } }] });
        };
    },

    clear: function () {
        cellArr = [];
        dialogJSONFull = { "length": cellArr.length, "cells": cellArr };
        this.graph.clear();
    },

    showCodeSnippet: function () {
        // console.log(JSON.stringify(this.selection));
        var cell = this.selection.first();
        // console.log(typeof cell);
        // console.log("{'cells': [" + JSON.stringify(cell) + "]}");
        // if (jsonVal.length === 0) {
        //     if (cell) {
        //         if ((cellArr.includes(cell) === false)) {
        //             cellArr.push(cell);
        //             console.log(cellArr.length);
        //             // cellArr = cellArr.filter(v => v !== null);
        //             dialogJSONFull = JSON.stringify({ "length": cellArr.length, "cells": cellArr });
        //         };
        //     };
        // };
        var dialogJSON = app.Factory.createDialogJSON(this.graph, cell);
        // var id = _.uniqueId('qad-dialog-');

        // var snippet = '';
        // snippet += '<div id="' + id + '"></div>';
        // snippet += '<link rel="stylesheet" type="text/css" href="http://qad.client.io/css/snippet.css"></script>';
        // snippet += '<script type="text/javascript" src="http://qad.client.io/src/snippet.js"></script>';
        // snippet += '<script type="text/javascript">';
        // snippet += 'document.getElementById("' + id + '").appendChild(qad.renderDialog(' + JSON.stringify(dialogJSON) + '))';
        // snippet += '</script>';

        // var content = '<textarea>' + snippet + '</textarea>';

        var dialog = new joint.ui.Dialog({
            width: '70%',
            height: 500,
            draggable: true,
            // title: 'Copy-paste this snippet to your HTML page.',
            title: explain6,
            // content: content
            // content: '<textarea>' + dialogJSONFull + '</textarea>'
            content: '<textarea>' + JSON.stringify(dialogJSON) + '</textarea>'
        });

        dialog.open();
    },

    showCodeSnippet2: function () {
        // console.log(JSON.stringify(this.selection));
        // var cell = this.selection.first();
        // console.log(typeof cell);
        // console.log("{'cells': [" + JSON.stringify(cell) + "]}");
        // if (cell) {
        //     if ((cellArr.includes(cell) === false)) {
        //         cellArr.push(cell);
        //         console.log(cellArr.length);
        //         // cellArr = cellArr.filter(v => v !== null);
        //         dialogJSONFull = { "length": cellArr.length, "cells": cellArr };
        //     };
        // };
        var cell = this.selection.first();
        var dialogJSON = app.Factory.createDialogJSON(this.graph, cell);

        var dialog3 = new joint.ui.Dialog({
            width: '70%',
            height: 500,
            draggable: true,
            // title: 'Copy-paste this snippet to your HTML page.',
            title: explain7,
            // content: content
            // content: '<textarea>' + dialogJSONFull + '</textarea>'
            content: '<textarea>' + JSON.stringify(dialogJSONFull) + '</textarea>'
        });

        dialog3.open();
    },

    pasteJSON: function () {
        dialog2 = new joint.ui.Dialog({
            width: '70%',
            height: 500,
            draggable: true,
            // title: 'Copy-paste this snippet to your HTML page.',
            title: explain9,
            // content: content
            content: "<textarea type='text' id='textarea-json' style='width:95%;height:300px;'></textarea><br><input type='button' value='" + runTran + "' style='float:right;' onclick='JSONtoGraph()'><br>"
        });

        dialog2.open();
    }
});

function JSONtoGraph() {
    var jsonVal1 = document.getElementById("textarea-json").value;
    if (jsonVal1.length > 0) {
        jsonVal = jsonVal1,
            document.getElementById("load-example1").click();
    };
    if (dialog2) {
        dialog2.close();
    };
};
