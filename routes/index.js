var express = require('express');
var router = express.Router();
var api = require('../lib/api');
var fs = require('fs');

/* GET home page. */
router.get('/', function(req, res) {
  res.render('index', { title: 'Express' });
});

router.post('/report/add', function(req, res) {
    api.report.add(req, res);
});

module.exports = router;
