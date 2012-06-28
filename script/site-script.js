// あとで書きなおす。
(function(callback, template) {
  'use strict';

  var JQUEY_URI = 'http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js';

  Object.defineProperty(window, 'jQuery', {
    'set': function(jQuery) {
      callback.call(window, jQuery.noConflict(), template);
    }
  });

  (function(s) {
    s.setAttribute('src', JQUEY_URI);
    document.body.appendChild(s);
    return s;
  })(document.createElement('script'));
})(function($, template) {
  'use strict';

  $.getJSON('/webbrowser.json', null, function(data) {
    var keys = Object.keys(data);
    var len = keys.length;
    var name = keys[Math.floor(Math.random() * len)];
    var dict = {
      name: name,
      version: data[name].version,
      uri: data[name].uri.download,
      icon: data[name].uri.icon
    };
    $('#recommended-webbrowser').html(template.replace(/\{\{([^\}]+)\}\}/g, function(_, name) {
      return dict[name] || '';
    }));
  });
}, [
  '<h1>ブラウザ判定</h1>',
  '<figure>',
  '  <img alt="get {{name}}" src="{{icon}}">',
  '  <figcaption>Please Use {{name}} {{version}}</figcaption>',
  '</figure>',
  '<p>たてや組オススメのブラウザ、<a href="{{uri}}">{{name}} {{version}}</a>を是非お使いください!</p>',
  '<p>(ブラウザ判定システムbeta3)</p>'
].join('\n'));
