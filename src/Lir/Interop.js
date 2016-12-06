/*global exports, document*/

// module Lir.Interop

exports.getValue = function (selector) {
    "use strict";
    return function () {
        return document.querySelector(selector).value;
    };
};
