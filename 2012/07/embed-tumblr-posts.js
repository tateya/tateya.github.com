/**
 * Embed Tumblr Posts
 *
 * @version 0.0.1
 * @license MIT License
 */
(function(global, undefined) {
  'use strict';

  var XHTML_NAMESPACE = 'http://www.w3.org/1999/xhtml';
  var DEFAULT_SETTINGS = {
    api_key: null,
    'base-hostname': 'example.com',
    limit: 10,
    offset: 0
  };
  var window = global.window;

  var EmbedTumblrPosts = global.EmbedTumblrPosts || (function() {
    var EmbedTumblrPosts = function EmbedTumblrPosts(targetElement, settings) {
      this.settings = settings || {};
      this.targetElement = targetElement;
      if (!(targetElement instanceof Element)) {
        throw new TypeError('This class is required argument targetElement.');
      }
      this.contextNode = targetElement.ownerDocument;
    };
    global.EmbedTumblrPosts = EmbedTumblrPosts;

    (function(proto) {
      proto.run = function run() {
        util.log(this.settings);
      };
    })(EmbedTumblrPosts.prototype);

    return EmbedTumblrPosts;
  })();

  var preparation = function(document) {
    var currentScriptElement = preparation.getCurrentScriptElement(document);
    var settings = util.objectMerge.apply(util, [
      DEFAULT_SETTINGS,
      preparation.parseEmbedSettingsText(currentScriptElement),
      preparation.parseQueryString(currentScriptElement)
    ]);
    preparation.listener = preparation.createListener(currentScriptElement, settings);
    preparation.addListener(document);
  };

  preparation.listener = function listener(event) {
    return undefined;
  };

  preparation.addListener = function addListener() {
    var listener = preparation.listener;
    if (typeof(window.addEventListener) === 'function') {
      window.addEventListener('DOMContentLoaded', listener);
    } else if (typeof(document.attachEvent) === 'function') {
      document.attachEvent('onreadystatechange', function(event) {
        if (this.readyState !== 'complate') {
          return;
        }
        listener();
      });
    } else {
      window.onload = listener;
    }
  };

  preparation.createListener = function createListener(targetElement, settings) {
    return function listener(event) {
      var etp = new EmbedTumblrPosts(targetElement, settings);
      etp.run();
    };
  };

  preparation.getCurrentScriptElement = function getCurrentScriptElement(document) {
    var scriptElements = document.getElementsByTagNameNS(XHTML_NAMESPACE, 'script');
    var currentScriptElement = scriptElements[scriptElements.length-1];
    return currentScriptElement;
  };

  preparation.parseQueryString = function parseQueryString(scriptElement) {
    var scriptUri = scriptElement.getAttribute('src');
    var queryString = (util.parseUri(scriptUri).search || '?').slice(1);
    var query = util.parseQueryString(queryString);
    return query;
  };

  preparation.parseEmbedSettingsText = function parseEmbedSettingsText(scriptElement) {
    var embedSettingsText = util.extractContentsFromCdataSection(scriptElement.textContent);
    var settings = JSON.parse(embedSettingsText);
    return settings;
  };

  var util = {};

  util.log = function(/* arguments */) {
    var console = global.console || {
      log: function(/* arguments */) {
        // todo
      }
    };
    console.log.apply(console, arguments);
  };

  util.objectMerge = function objectMerge(/* arguments */) {
    var objects = arguments;
    var newObject = {};
    for (var i=0, len=objects.length, object, objectKey; i<len; i++) {
      for (objectKey in object = objects[i]) {
        newObject[objectKey] = object[objectKey];
      }
    }
    return newObject;
  };

  util.parseUri = function parseUri(uri) {
    var anchorElement = document.createElementNS(XHTML_NAMESPACE, 'a');
    anchorElement.setAttribute('href', uri);
    return anchorElement;
  };

  util.parseQueryString = function parseQueryString(queryString) {
    var query = {};
    var splitQueryString = queryString.split(/[;&]/);
    for (var i=0, len=splitQueryString.length, keyAndValue; i<len; i++) {
      keyAndValue = splitQueryString[i].split('=');
      query[keyAndValue[0]] = keyAndValue[1] || true;
    }
    return query;
  };

  util.extractContentsFromCdataSection = function extractContentsFromCdataSection(cdataSection) {
    var contents = cdataSection;
    contents = contents.replace(/^<!\[CDATA\[/, '');
    contents = contents.replace(/\]\]>$/, '');
    return contents;
  };

  util.extractHtmlTags = function extractHtmlTags(text) {
    var extractedHtmlTagsText = text;
    extractedHtmlTagsText = extractedHtmlTagsText.replace(/<.+?>/g, '');
    return extractedHtmlTagsText;
  };

  util.escapeHtmlTags = function escapeHtmlTags(text) {
    var escapedText = text;
    escapedText = escapedText.replace(/&/g, '&amp;');
    escapedText = escapedText.replace(/</g, '&lt;');
    escapedText = escapedText.replace(/>/g, '&gt;');
    return escapedText;
  };

  function supportInternetExplorer(document) {
    if (typeof(document.createElementNS) !== 'function') {
      document.createElementNS = function createElementNS(namespace, tagName) {
        return this.createElement(tagName);
      };
    }
    if (typeof(document.getElementsByTagNameNS) !== 'function') {
      document.getElementsByTagNameNS = function getElementsByTagNameNS(namespace, tagName) {
        return this.getElementsByTagName(tagName);
      };
    }
    if (typeof(document.createElementNS(XHTML_NAMESPACE, 'div').textContent) !== 'string') {
      Object.defineProperty(Element.prototype, 'textContent', {
        get: function getter() {
          return this.extractHtmlTags(this.innerHTML);
        },
        set: function setter(text) {
          return this.innerHTML = util.escapeHtmlTags(text);
        },
        configurable: true,
        enumerable: false
      });
    }
  };
  if (/MSIE/.test(window.navigator.userAgent)) {
    supportInternetExplorer(window.document);
  }

  if (window === global) {
    preparation(window.document);
  }
})(this);
