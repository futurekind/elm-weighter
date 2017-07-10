var ghpages = require('gh-pages');
var path = require('path');
var pkg = require('./package.json');

ghpages.publish(path.join(__dirname, 'dist'), {
    message: 'Bumping to ' + pkg.version
}, function(err) {});
