var express = require('express');
var router = express.Router();
var api = require('../lib/api');
var fs = require('fs');

/* GET home page. */
router.get('/', function(req, res) {
  res.render('index', { title: 'Express' });
});

router.post('/report/add', function(req, res) {
    // remove all files
    for(var file in req.files) {
        if (req.files.hasOwnProperty(file)) {
            fs.unlink(req.files[file].path);
        }
    }

    res.end();
});

module.exports = router;
