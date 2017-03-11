// call the packages we need
var express     = require('express');      // call express
var app         = express();               // define our app using express
var bodyParser  = require('body-parser');
var multer      = require('multer');
var path        = require('path');
var pg          = require('pg');
var uniqID      = require('uniq-id');
var geo         = require('node-geo-distance');
var compression = require('compression');

var conString   = "postgres://postgres:pa$$w0rd@localhost:5432/blowfish_dev";
var client      = new pg.Client(conString);
client.connect(function(err) {
    if(err) {
        return console.error('could not connect to postgres', err);
    }
});
// configure app to use bodyParser()
// this will let us get the data from a POST

app.use(bodyParser.json({ type: 'application/json'}));
app.use(compression());
app.use(express.static('/blowfish_media')); //*Needs to change

var storage = multer.diskStorage({ //*Needs to be moved into route
    destination: function (req, file, callback) {
    callback(null, '/blowfish_media');
    },
    filename: function (req, file, callback) {
    callback(null, file.fieldname + '-' + Date.now() + path.extname(file.originalname));
    }
});

//var image_upload = multer({ storage : image_storage}).single('jpg');
//var video_upload = multer({ storage : video_storage}).single('mp4');

var upload =  multer({ storage : storage}).single('media');

var port = process.env.PORT || 8080; // set our port --
//var host = process.env.IP
var server = app.listen(app.get('port'), function() {
    var host = server.address().address;
    var port = server.address().port;
});
/*function getPost(req, res, next) {
    var postID = req.params.post_id;
    var query = "SELECT * FROM post ORDER BY post_time ASC"
    client.query(query, getPost, function(err, results) {
        if (err) {
            console.error(err);
            res.statusCode = 500;
            return res.json({errors: ['Could not retrieve post']
            });
        }
        if (result.rows.length === 0) {
		        res.statusCode = 404;
		        return res.json({ errors: ['post not found']});
	      }
	      req.post_id = result.rows[0];
	      next();
    });
}*/
// Our handler function is passed a request and response object
app.get('/', function(req, res) { //*We Don't need
  // We must end the request when we are done handling it
    res.end();
});
var postRouter = express.Router();
//This will go into the HTTP POST for the post table
postRouter.get('/distance', function(req, res) { //*Move example code
    /*White house:
    latitude: 38.8977330,
    longitude: -77.0365310

    Washington Monument:
    latitude: 38.8894840,
    longitude: -77.0352790

    Jefferson St. UC:
    latitude: 39.132016,
    longitude: -84.511096

    Crib:
    latitude: 39.135982,
    longitude: -84.529792
    */
    var coord1 = {
                   latitude: 39.127949,
                   longitude: -84.520784
                 }  //End of Clifton Ave @ McMillan
    var coord2 = {
                  latitude: 39.135336,
                  longitude: -84.520055
                 } //Clifton Ave @ MLK DR
    //Vincenty Equation (More Accurate, slower process)
    //Asynchronous Vincenty:
    geo.vincenty(coord1, coord2, function(dist) {
        console.log(dist + ' Meters ');
    });
    //Synchronous Vincenty:
    var vincentyDist = geo.vincentySync(coord1, coord2);
    //Haversine Equation (Less Accurate, faster process)
    //Asynchronous Haversine:
    geo.haversine(coord1, coord2, function(dist) {
        console.log(dist + ' Meters ');
    });
    //Synchronous Haversine:
    var haversineDist = geo.haversineSync(coord1, coord2);
});
postRouter.post('/register', function (req, res) {
    var uid = req.body.deviceUid;
    var deviceLatitude = Number(req.body.latitude);
    var deviceLongitude = Number(req.body.longitude);
    var deviceCoord = { latitude : deviceLatitude, longitude : deviceLongitude }
    console.log("Device Unique ID: " + uid)
    console.log("Device Coordinates: " + JSON.stringify(deviceCoord));
    if (uid === null || uid === undefined) {
        res.end('Invalid DeviceID');
    }
    else {
        var query = client.query("SELECT * FROM location");
        var results = [];
        query.on('row', function(row) {
            results.push(row);
            var queryLat = Number(row.latitude);
            var queryLon = Number(row.longitude);
            var coord2 = { latitude : queryLat, longitude : queryLon}
            console.log("Records in Location Table: " + row);
        });
        query.on('end', function(result) {
            console.log(results[0].latitude);
            JSON.stringify(results);
            var length = results.length
            var distList = [];
            for (i = 0; i < length; i++) {
                var Lat = Number(results[i].latitude);
                var Lon = Number(results[i].longitude);
                var coord2 = { latitude : Lat, longitude : Lon}
                geo.vincenty(deviceCoord, coord2, function(dist) {
                    distList.push(dist);
                    console.log(dist + ' Meters ');
                });
            }
            console.log("Distance from UC: " + distList[0] + " Meters");
            console.log("Distance from Xavier: " + distList[1] + " Meters");
            var closestDist = [];
            var returnId = [];
            var name = [];
            for (i = 0; i < distList.length; i++){
                if (distList[i] <= 2414.02 ) {
                    closestDist.push(distList[i]);
                    returnId.push(results[i].location_id);
                    name.push(results[i].location_desc);
                }
            }
            var deviceId;
            var userId;
            var query = client.query("SELECT * FROM device WHERE device_sn = $1", [uid], function (err, result) {
                console.log("Device Unique ID: " + uid)
                console.log("Checking for stored Unique ID...");
                console.log("Record Exists!");
                console.log("Records found: " + result.rowCount);
                var registration;
            if (result.rowCount == 0) {
                client.query("INSERT INTO device (device_sn) VALUES ($1) RETURNING device_id", [uid], function (err, result) {
                    if (err) {
                        console.error(err);
                    }
                    console.log("Device ID: " + result.rows[0].device_id);
                    var deviceId = result.rows[0].device_id;
                    var genId = uniqID.generateUUID('xxxxxxxxxx', 10)();
                    console.log("User ID: " + genId);
                    client.query("INSERT INTO users (user_id, device_id) VALUES ($1, $2)", [genId, deviceId], function (err, result){
                        if (err){
                            console.log(err);
                        }
                        var query1 = client.query("SELECT * FROM users WHERE device_id = $1", [deviceId], function(err, result) {
                            console.log(result.rows[0].user_id);
                            var userId = result.rows[0].user_id;
                            console.log("User ID: " + userId)
                            var registration = { location_id : returnId , location_name : name, user_id : userId }
                            console.log("Closest Location: " + registration.location_id);
                            console.log(", Distance: " + closestDist + " Meters ");
                            res.json(registration);
                        });
                    });
                });
            }
            else {
                console.log("Record ID: " + result.rows[0].device_id);
                deviceId = result.rows[0].device_id;
                var query1 = client.query("SELECT * FROM users WHERE device_id = $1", [deviceId], function(err, result) {
                    var userId = result.rows[0].user_id;
                    console.log("User ID: " + result.rows[0].user_id);
                    var registration = { location_id : returnId , location_name : name, user_id : userId }
                    console.log("Closest Location: " + registration.location_id);
                    console.log("     School: " + registration.location_name);
                    console.log("     Distance: " + closestDist + " Meters ");
                    res.json(registration);
                });
            }
        });
    });
  }
});
/*WHEN INSERTING DATA:
{
  "deviceUid" : ,
  "latitude" : ,
  "longitude" :
}
Idea!! : so for the pattern of userid's, I could set numbers rep. locations where they got their userId
*/
//NOTES: CLEAN UP CODE!!!
//WORK ON VALIDATION W/ this info now
postRouter.get('/timestamp', function(req, res) {
    var date = Math.floor(new Date() / 1000);
    console.log(date);
    res.end();
});
postRouter.get('/:location_id([0-9]+)', function(req, res) {
    var locationId = req.params.location_id;
    var query = client.query("SELECT * FROM post p, media m WHERE p.media_id = m.media_id AND p.location_id = $1 ORDER BY timestamp DESC LIMIT 16", [locationId]);
    var posts = [];
    var postID = [];
    var pcArray;
    //console.log('seq1')
    query.on('row', function (row) {
        posts.push(row);
        postID.push(row.post_id)
        pcArray = row.comments = [];
    });
    query.on('end', function (result) {
        //console.log(posts);
        //console.log(posts[0].post_id)
        //console.log(pcArray)
        //pcArray.splice(0,0, "Lene")
        //console.log(posts)
        for (i = 0; i < postID.length; i++) {
            var query1 = client.query("SELECT * FROM comment WHERE post_id = $1", [ postID[i] ]);
            comments = [];
            var commentID;
            var postId;
            var message;
            var time;
            var comment;
            query1.on('row', function (row, result) {
              commentID = row.comment_id
              postId = row.post_id
              message = row.comment_message
              time = row.comment_time
              comment = {
                  commentID : commentID,
                  commentPost : postId,
                  commentMessage : message,
                  commentTime : time
              }
              comments.push(comment)
              result.addRow(row)
            });
        }
        query1.on('end', function (result) {
            //console.log(JSON.stringify(comments)) //array of comments
            //console.log(result.rows)
            for (j = 0; j < postID.length; j++){
                var validComments = [];
                for (i = 0; i < comments.length; i++) {
                    //console.log("compare")
                    //console.log(comments[i].commentPost + " - commentPost ")
                    //console.log(postID[j] + " - postID ")
                    if (comments[i].commentPost == postID[j]) {
                          delete comments[i].commentPost;
                          validComments.push(comments[i])
                      /*for (i = 0; i < posts.length; i++) {
                          posts[i].yopper = comments
                      }*/
                    }
                    else {
                        //posts[j].comments = [];
                    }
                }
                posts[j].comments = validComments
                //console.log(postID[j] + " END ")
            }
            //console.log(posts)
            res.json(posts);
        });
});


        /*Push comments query results into array defined as comments FIRST!!, then put the array defined as comments
        into the post property.*/
      /*post = {
               post_id : postID,
               device_id : deviceID,
               media_id : mediaID,
               post_time : postTime,
               post_like : postLike,
               location_id : locationID,
               media_type : mediaType,
               media_filename : mediaFilename,
               comments : row
             };*/

    /*Working code
    client.query(query, [ locationId ], function(err, result) {
      console.log(locationId + 'seq 4');

      console.log(comments)
      var json = JSON.stringify(result.rows);
      console.log(result.rows);
      res.writeHead(200, {'content-type':'application/json', 'content-length':Buffer.byteLength(json)});
      res.end(json);
    });*/
console.log("Retrieving Data For location: " + locationId);
    //var query = "SELECT * FROM post p, media m WHERE location_id = $1  ORDER BY post_time ASC"
    //var query = "SELECT * FROM post p, media m WHERE p.media_id=m.media_id ORDER BY post_time ASC"
    //var query = client.query('SELECT post_id, COUNT(post_like) AS likes FROM post p, media m WHERE p.media_id=m.media_id GROUP BY p.post_id ORDER BY post_time');
    //var query = "SELECT * FROM post ORDER BY post_time ASC"
    /*var results = [];
    client.query(query,'row', function(row) {
        results.push(row);
        console.log(results);
    });*/
    /*client.query(query, [ locationId ], function(err, result) {
      var json = JSON.stringify(result.rows);
      res.writeHead(200, {'content-type':'application/json', 'content-length':Buffer.byteLength(json)});
      res.end(json);
    });*/
    /*var results = []; WORKING POST!!
    var query = client.query('SELECT post_id, COUNT(post_like) AS likes FROM post p, media m WHERE p.media_id=m.media_id GROUP BY p.post_id ORDER BY post_time');
    query.on('row', function(row) {
        results.push(row);
        var json = JSON.stringify(row);
        console.log('deez nuts');
    });
    query.on('end', function(result){
        console.log(result.rowCount);
        res.json(results);
    });*/
});
postRouter.get('/top/:location_id([0-9]+)', function(req, res) {
  var locationId = req.params.location_id;
  var query = client.query("SELECT * FROM post p, media m WHERE p.media_id = m.media_id AND p.location_id = $1 AND p.post_like > 0 ORDER BY post_like DESC LIMIT 16", [locationId]);
  var posts = [];
  var postID = [];
  var pcArray;
  console.log('seq1')
  query.on('row', function (row) {
      posts.push(row);
      postID.push(row.post_id)
      pcArray = row.comments = [];
      console.log('seq2')
  });
  query.on('end', function (result) {
      console.log(posts);
      console.log(posts[0].post_id)
      console.log(pcArray)
      //pcArray.splice(0,0, "Lene")
      console.log(posts)
      for (i = 0; i < postID.length; i++) {
          var query1 = client.query("SELECT * FROM comment WHERE post_id = $1", [ postID[i] ]);
          comments = [];
          var commentID;
          var postId;
          var message;
          var time;
          var comment;
          query1.on('row', function (row, result) {
            commentID = row.comment_id
            postId = row.post_id
            message = row.comment_message
            time = row.comment_time
            comment = {
                commentID : commentID,
                commentPost : postId,
                commentMessage : message,
                commentTime : time
            }
            comments.push(comment)
            result.addRow(row)
          });
      }
      query1.on('end', function (result) {
          console.log(JSON.stringify(comments)) //array of comments
          //console.log(result.rows)
          for (j = 0; j < postID.length; j++){
              var validComments = [];
              for (i = 0; i < comments.length; i++) {
                  console.log("compare")
                  console.log(comments[i].commentPost + " - commentPost ")
                  console.log(postID[j] + " - postID ")
                  if (comments[i].commentPost == postID[j]) {
                        delete comments[i].commentPost;
                        validComments.push(comments[i])
                        /*for (i = 0; i < posts.length; i++) {
                            posts[i].yopper = comments
                          }*/
                  }
                  else {
                      //posts[j].comments = [];
                  }
              }
              posts[j].comments = validComments
              console.log(postID[j] + " END ")
          }
          console.log(posts)
          res.json(posts);
      });
  });
      /*Push comments query results into array defined as comments FIRST!!, then put the array defined as comments
      into the post property.*/
    /*post = {
             post_id : postID,
             device_id : deviceID,
             media_id : mediaID,
             post_time : postTime,
             post_like : postLike,
             location_id : locationID,
             media_type : mediaType,
             media_filename : mediaFilename,
             comments : row
           };*/

  /*Working code
  client.query(query, [ locationId ], function(err, result) {
    console.log(locationId + 'seq 4');

    console.log(comments)
    var json = JSON.stringify(result.rows);
    console.log(result.rows);
    res.writeHead(200, {'content-type':'application/json', 'content-length':Buffer.byteLength(json)});
    res.end(json);
  });*/
    console.log('nothing should go here!!');
  //var query = "SELECT * FROM post p, media m WHERE location_id = $1  ORDER BY post_time ASC"
  //var query = "SELECT * FROM post p, media m WHERE p.media_id=m.media_id ORDER BY post_time ASC"
  //var query = client.query('SELECT post_id, COUNT(post_like) AS likes FROM post p, media m WHERE p.media_id=m.media_id GROUP BY p.post_id ORDER BY post_time');
  //var query = "SELECT * FROM post ORDER BY post_time ASC"
  /*var results = [];
  client.query(query,'row', function(row) {
      results.push(row);
      console.log(results);
  });*/
  /*client.query(query, [ locationId ], function(err, result) {
    var json = JSON.stringify(result.rows);
    res.writeHead(200, {'content-type':'application/json', 'content-length':Buffer.byteLength(json)});
    res.end(json);
  });*/
  /*var results = []; WORKING POST!!
  var query = client.query('SELECT post_id, COUNT(post_like) AS likes FROM post p, media m WHERE p.media_id=m.media_id GROUP BY p.post_id ORDER BY post_time');
  query.on('row', function(row) {
      results.push(row);
      var json = JSON.stringify(row);
      console.log('deez nuts');
  });
  query.on('end', function(result){
      console.log(result.rowCount);
      res.json(results);
  });*/
});
postRouter.post('/', function(req, res) {
    //This declaration Works, but stores data in DB as: {"TEXT"}
    /*var data = [
      req.body.device_sn,
      req.body.device_id,
      req.body.media_id,
      req.body.post_time,
      ];*/
    //This declaration Works!
    var device_data = req.body.device_sn;
    //var media_type = req.body.media_type;     // <<----- USE THESE IF BRACKETS DON'T WORK PROPERLY
    //var media_filename = req.body.media_filename;  // <<----- USE THESE IF BRACKETS DON'T WORK PROPERLY
    //var media_req = [
    //req.body.media_type,
    //req.body.media_filename
    //];
    //-------------------------------------------------------------------------
    //var query = client.query("INSERT INTO post (device_id, media_id, post_time) VALUES (4,53,'01:01:01')");
    //var query = client.query('INSERT INTO post (device_id, media_id, post_time) VALUES (101,101,'00:00:00') RETURNING post_id'[data.device_id, data.media_id, data.post_time]);
    // var query_1 = client.query("INSERT INTO media (media_id, media_type, media_filename) VALUES ($1, $2, $3) ");
    // var query_2 = client.query("INSERT INTO device (device_id, device_sn) VALUES (102, 'serial') ");
    // var query_3 = client.query("INSERT INTO post (device_id, media_id, post_time) VALUES (102, 102, '00:00:00') ");
    // var query_1 = client.query("INSERT INTO media ( media_type, media_filename) VALUES ($1, $2) RETURNING media_id");
    //-------------------------------------------------------------------------
    //var device_post = client.query("INSERT INTO device (device_sn) VALUES ($1) RETURNING device_id", [device_data]);
    //var media_post = "INSERT INTO media (media_type, media_filename) VALUES ($1, $2) RETURNING media_id", [media_type, media_filename];
    client.query("INSERT INTO device (device_sn) VALUES ($1) RETURNING device_id", [device_data], function(err, result) {
        if (err) {
    		    console.error(err);
    		    res.statusCode = 500;
    		    return res.json({
    		    errors: ['Failed to create post']
    		    });
        }
    });  //var newDeviceSN = result.rows[0].device_sn;
        //var getDeviceID = "SELECT * FROM device";
        /*client.query(getDeviceID, [newDeviceSN], function(err, result) {
            if (err) {
      	        console.error(err);
      		      res.statusCode = 500;
      		      return res.json({
      			    errors: ['Could not retrieve post after created']
      		      });
            }
            res.statusCode = 201;
            return res.json(result.rows[0]);
        });*/
    return res.json({ message: 'DATA STORED!' });

});
postRouter.post('/file-upload',function(req,res) {
    //var userId = req.body.user_id
    //var locationId = req.body.location_id
    //var time = Math.floor(new Date() / 1000);
    upload(req,res, function(err) {
      var userId = req.body['value1'];
      var locationId = req.body['value2'];
      console.log(userId)
      console.log(locationId)
        var url = 'http:\/\/ec2-52-26-20-48.us-west-2.compute.amazonaws.com:8080'
        var path = url + req.file.path.replace('/blowfish_media','');
        var media_req = req.file.mimetype;
        if(err) {
            return res.end("Global Error uploading file.");
        }
        switch (media_req) {
            case 'image/jpeg' || 'image/png' || 'video/mp4' || 'video/mov':
                client.query("INSERT INTO media (media_type, media_filename) VALUES ($1, $2) RETURNING media_id", [media_req, path], function(err, result) {
                    if (err) {
                        console.error(err);
                        res.statusCode = 500;
                        return res.json({
                            errors: ['Failed to post image']
                        });
                    }
                    console.log('Data STORED in DB');
                    var mediaId = result.rows[0].media_id
                    client.query("INSERT INTO post (media_id, user_id, location_id) VALUES ($1, $2, $3) RETURNING post_id", [mediaId, userId, locationId], function (err, result) {
                        if(err) {
                            console.error(err);
                        }
                    });
                });
                break;
            default :
                res.end("Unsupported File type");
        }
        console.log(req.file);
        console.log(req.params)
        //res.json(req.params);
        res.end("Media is uploaded");
    });
});
postRouter.get('/file-upload',function(req,res){
  var page = parseInt(req.query.page, 10);
  if (isNaN(page) || page < 1) {
    page = 1;
  }

  var limit = parseInt(req.query.limit, 10);
  if (isNaN(limit)) {
    limit = 10;
  } else if (limit > 50) {
    limit = 50;
  } else if (limit < 1) {
    limit = 1;
  }

  var query = "SELECT count(1) FROM media";
  client.query(query, function(err, result) {
    if (err) {
      console.error(err);
      res.statusCode = 500;
      return res.json({
        errors: ['Could not retrieve photos']
      });
    }

    var count = parseInt(result.rows[0].count, 10);
    var offset = (page - 1) * limit;

    query = "SELECT * FROM media ORDER BY media_id DESC OFFSET $1 LIMIT $2";
    client.query(query, [offset, limit], function(err, result) {
      if (err) {
        console.error(err);
        res.statusCode = 500;
        return res.json({
          errors: ['Could not retrieve photos']
        });
      }

      return res.json(result.rows);
    });
  });
  /* CODE BEFORE PAGE RESULTS
    var results = [];
    var query = client.query("SELECT * FROM media ORDER BY media_id DESC LIMIT 15"); //media_type,media_filename
    query.on('row', function(row) {
        results.push(row);
        var type = JSON.stringify(row.media_type);
        var typeHead = JSON.parse(type);
        var fileLoco = JSON.stringify(row.media_filename);
        var abspath = JSON.parse(fileLoco);
        console.log(abspath);
    });
    query.on('end', function(result){
        console.log(result.rowCount);
        res.json(results);
    });*/
});
postRouter.patch('/rating/:post_id', function(req, res) {
    var post = req.params.post_id;
    var rate = req.body.post_like;
    //var update = client.query("UPDATE post SET post_like = post_like + $1  WHERE post_id = $2",[rate, post]);
    console.log('posting');
    client.query("UPDATE post SET post_like = post_like + $1  WHERE post_id = $2",[rate, post], function(err, result) {
        if (err) {
            console.error(err);
            res.statusCode = 500;
            return res.json({
            errors: ['Error liking post']
            });
        }
    });
    console.log('Post Liked!');
    return res.json({ message: 'Post Liked!' });
});
postRouter.post('/comments', function(req, res) {
    var postID = req.body.post_id;
    var message = req.body.comment_message;
    //var comment_store = client.query("INSERT INTO comment (post_id, comment_message, comment_time) VALUES ($1, $2, $3) RETURNING comment_id", [postID, message, time]);
    client.query("INSERT INTO comment (post_id, comment_message) VALUES ($1, $2) RETURNING comment_id", [postID, message], function(err, result) {
        if (err) {
            console.error(err);
            res.statusCode = 500;
            return res.json({
            errors: ['Failed to post comment']
            });
        }
        console.log('Data STORED in DB');
        return res.json({ message: 'DATA STORED!' });
    });
});
postRouter.get('/comments', function(req, res) {
    var query = "SELECT * FROM comment"
    client.query(query, function(err, result) {
        var json = JSON.stringify(result.rows);
        res.writeHead(200, {'content-type':'application/json', 'content-length':Buffer.byteLength(json)});
        res.end(json);
    });
});
postRouter.get('/users/posts/:user_id', function (req, res) {
    var userID = req.params.user_id
    client.query("SELECT *, count(p.user_id) AS numberOfPosts FROM post p, media m WHERE p.media_id = m.media_id AND p.user_id = $1", [userID], function (err, result) {
        res.json(result.rows);
    });
});
postRouter.get('/users/posts/replies/:user_id', function (req, res) {
    var userID = req.params.user_id
    client.query("SELECT *, count(c.user_id) AS numberOfComments FROM post p, media m, comments c WHERE p.media_id = m.media_id AND p.user_id = c.user_id AND c.user_id = $1", [userID], function (err, result) {
        res.json(result.rows);
    });
});
app.use('/post', postRouter);
postRouter.get('/devices', function(req, res) {
    var getDeviceID = "SELECT * FROM device";
    client.query(getDeviceID, function(err, result) {
        var json = JSON.stringify(result.rows);
        res.writeHead(200, {'content-type':'application/json', 'content-length':Buffer.byteLength(json)});
        res.end(json);
    });
});
postRouter.patch('/posts/report/:post_id', function(req, res) { });
postRouter.delete('/:post_id', function(req, res) { });

app.listen(port);
console.log('Magic happens on port ' + port);
/* NOTES:
1. When using parameters and placeholders with queries, be sure to place them inside
of methods.
EX. client.query('SQL QUERY', [object]); RIGHT!
   'SQL QUERY', [object]; WRONG!
2. Find out why file-upload stores values 3 times
3. Find out how to retrieve files and post data
*/
