﻿
var func = (function () {

    window.testFunction = {
        helloWorld: function () {
            return alert('Hello World');
        },
        inputName: function (text) {
            return prompt(text, 'input Name');
        }
    };

});

func();