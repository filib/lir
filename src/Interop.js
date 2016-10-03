/*global exports, document*/

// module Interop

exports.getValue = function (selector) {
    "use strict";
    return function () {
        return document.querySelector(selector).value;
    };
};
