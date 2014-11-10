var helper = require('./helper');
var fs = require('fs.extra');

exports.report = {};

exports.report.add = function (req, res) {
    console.log(req.body);

    var path = 'public/uploads/' + helper.utils.randomStringNoSymbol(14) + '.jpg';
    var post  = {comment: req.body.comment, latitude: req.body.latitude, longitude: req.body.longitude ,address: req.body.address, type: req.body.type, android_id: req.body.android_id, phone_number: req.body.phone_number, date: helper.mysql.stringifyDate(new Date()), picture: path};

    helper.mysql.connection(function(err, connection) {
        fs.move(req.files['picture'].path, path, function(err) {
            for(var file in req.files) {
                if (req.files.hasOwnProperty(file)) {
                    if (fs.existsSync(req.files[file].path)) {
                        fs.unlink(req.files[file].path);
                    }
                }
            }
        });

        var query = connection.query('INSERT INTO report SET ?', post, function(err, result) {
            console.log(err);
            console.log(result);
        });
    });

    res.end();
};