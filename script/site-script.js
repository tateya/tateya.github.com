(function(callback) {
  'use strict';

  var JQUEY_URI = 'http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js';

  Object.defineProperty(window, 'jQuery', {
    'set': function(jQuery) {
      callback.call(window, jQuery.noConflict());
    }
  });

  (function(s) {
    s.setAttribute('src', JQUEY_URI);
    document.body.appendChild(s);
    return s;
  })(document.createElement('script'));
})(function($) {
  'use strict';

  $.getJSON('/webbrowser.json', null, function(data) {
    var keys = Object.keys(data);
    var len = keys.length;
    var name = keys[Math.floor(Math.random() * len)];
    data = data[name];console.log(data);
    $('#recommended-webbrowser').html([
      '<h1>ブラウザ判定</h1>',
      '<figure>',
      '  <img alt="get ' + name + '" src="' + data.uri.icon + '">',
      '  <figcaption>Please Use ' + name + ' ' + data.version + '</figcaption>',
      '</figure>',
      '<p>たてや組オススメのブラウザ、<a href="' + data.uri.download + '">' + name + ' ' + data.version + '</a>',
      '<p>(ブラウザ判定システムbeta3)</p>'
    ].join('\n'));
  });
});
