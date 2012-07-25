(function(global, undefined) {
  'use strict';

  var window = global.window;
  var document = window.document;

  function main() {
    var listener = function() {};
    var scriptElements = document.getElementsByTagName('script');
    var currentScriptElement = scriptElements[scriptElements.length-1];
    var currentScriptUri = currentScriptElement.getAttribute('src');
    var currentScript = currentScriptElement.firstChild.nodeValue;
    var jsonString = extractContentsFromCdataSection(currentScript);
    var queryString = (parseUri(currentScriptUri).search || '?').slice(1);
    var settings = JSON.parse(jsonString);
    var query = parseQueryString(queryString);
    settings = objectMerge(query, settings);
    listener = createListener(settings);
    window.addEventListener('DOMContentLoaded', listener);
  }

  function createListener(settings) {
    return function(event) {
      // todo
    };
  }

  function extractContentsFromCdataSection(cdataSection) {
    var contents = cdataSection;
    contents = contents.replace(/^<!\[CDATA\[/, '');
    contents = contents.replace(/\]\]>$/, '');
    return contents;
  }

  function parseUri(uri) {
    var anchorElement = document.createElementNS('http://www.w3.org/1999/xhtml', 'a');
    anchorElement.setAttribute('href', uri);
    return anchorElement;
  }

  function parseQueryString(queryString) {
    var query = {};
    var splitQueryString = queryString.split(/[;&]/);
    for (var i=0, len=splitQueryString.length, keyAndValue; i<len; i++) {
      keyAndValue = splitQueryString[i].split('=');
      query[keyAndValue[0]] = keyAndValue[1] || true;
    }
    return query;
  }

  function objectMerge(/* arguments */) {
    var objects = arguments;
    var newObject = {};
    var object;
    var objectKey;
    for (var i=0, len=objects.length; i<len; i++) {
      for (objectKey in object = objects[i]) {
        newObject[objectKey] = object[objectKey];
      }
    }
    return newObject;
  }

  main();
})(this);
