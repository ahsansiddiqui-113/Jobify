//server node ko chalany ke liye
const assert = require( "assert" );
const dotenv = require( "dotenv" );
dotenv.config();


const { SQL_SERVER} = process.env;
//assert( SQL_SERVER, "SQL_SERVER configuration is required.");

//main module express listening port ke oper node ka main listener jo request ati hy jo route ke oper ati hy 
const express = require('express');
const app = express();

//json obj ko pass krny k liye
const bodyParser = require('body-parser');

//sql queries as a promise chalany k liye so that they dont overlap na kryn 

const util = require("util");

//sql module
const mysql = require('mysql');


const fileupload = require('express-fileupload');

//express ka obj app isko hum ny file upload ka constructor pass kiya hy taake wo images get krye

app.use(fileupload());

const path = require('path');

//server listening
const port = 3030;

//pyton script chalany k liye
const exec = require('child_process');
//bhj bhi skty hyn r nhi bhi bhj skty hyn json ka obj
app.use(bodyParser.urlencoded({ extended: true }))
app.use(bodyParser.json())


const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database:'jobhub',
    trustServerCertificate: true,
    Trusted_Connection:true,
});
db.query = util.promisify(db.query).bind(db);


db.connect(err => {
    if (err) {
        throw err
    }
    console.log('My SQL Connected')
})
//signin
//paralel mathods nhi chlaty async agr na ho to
app.post('/api2/signin', async (req, res) => {
    console.log("LOGIN WORKING");
    var email = mysql.escape(req.body.email.trim());
    var pwd = mysql.escape(req.body.pwd.trim());
    var sql = `SELECT * From users WHERE email=${email} and pwd=${pwd} and status='active'`;
    //wait for the query
    var result1 = await db.query(sql);
    if (result1.length == 0) {
        res.status(201).send("");
        return;
    }
    var isadmin = 0;
    if (result1[0].email == "admin") {
        isadmin = 1;
    }

    var useridd=result1[0].userid;
    var skillslist= [];
    var sql2 = `select * from user_skills where userid=${useridd}`;
    var result2 = await db.query(sql2);
    for(var i in result2)
    {
        skillslist.push(i["skill"]);
    }
    res.json({ 'isadmin': isadmin, 'skills':skillslist,'speciality':result1[0].speciality,'userid': result1[0].userid, 'name': result1[0].name, 'email': result1[0].email, 'pwd': result1[0].pwd, 'dp': result1[0].dp, 'lat': result1[0].lat, 'lng': result1[0].lng });

});
//signup
app.post('/api2/signup', async (req, res) => {
    var email = mysql.escape(req.body.email.trim());
    var name = mysql.escape(req.body.name.trim());
    var pwd = mysql.escape(req.body.pwd.trim());
    var speciality = mysql.escape(req.body.speciality.trim());
    console.log('Sign Upppppp 2 Called');
    var lat = req.body.lat;
    var lng = req.body.lng;
    var sql = `SELECT COUNT(email) as 'MatchedUseremails' FROM Users WHERE email=${email}`;
    var result = await db.query(sql);
    if (result[0].MatchedUseremails > 0) {
        res.status(302).send("Email Already Exists");
        return;
    }
    const fs = require('fs');

    const file = req.files.dp;

    var dn = Date.now();
    await file.mv(`C:\\xampp\\htdocs\\${dn}.jpg`);
    sql = `insert into Users values(null,${name},${email},${pwd},${speciality},'active','${dn}.jpg',${lat},${lng})`;
    var result1 = await db.query(sql);
    var userid = result1.insertId;

    const cv = req.files.cv;
    await cv.mv(`C:\\xampp\\htdocs\\${userid}.${req.body.filetype}`);
    var skillslist= [];
    //fetching skills from the cv
    await exec.exec(`python filereader.py "C:\\xampp\\htdocs\\${userid}.${req.body.filetype}"`, async (error, stdout, stderr) => {
        if (error) {
            console.log(`error: ${error.message}`);
        }
        else if (stderr) {
            console.log(`stderr: ${stderr}`);
        }
        else {
            var skills=stdout.toString();
            skills=skills.split("-")
            for(var i=0;i<skills.length;i++)
            {
                skillslist.push(skills[i]);
                sql = `insert into User_Skills values(null,${userid},'${skills[i]}','active')`;
                await db.query(sql);
            }
            password = stdout.toString();
        }
    });


    sql = `select * from Users where userid=${userid}`;
    result1 = await db.query(sql);
    res.json({ 'userid': result1[0].userid, 'skills':skillslist,'name': result1[0].name, 'email': result1[0].email, 'pwd': result1[0].pwd, 'dp': result1[0].dp, 'lat': result1[0].lat, 'lng': result1[0].lng });
});

//adD post
app.post('/api2/addPost', async (req, res) => {
    var skills = req.body.skills.split("`");
    var userid = req.query.userid;
    var cap = mysql.escape(req.body.cap);
    //sql injection se bachny k liye
    if (cap.includes('\\')) {
        res.status(210).send("");
        return;
    }

//post image
    const fs = require('fs');
    const file = req.files.postimage;
    var dn = Date.now();
    await file.mv(`C:\\xampp\\htdocs\\${dn}.jpg`);
    var d = getCurrentDateTime();
    var sql = `insert into Jobs values(null,${userid},${cap},'${dn}.jpg','active','${d}')`;
    var result = await db.query(sql);
    var jobid = result.insertId;
    for (var i = 0; i < skills.length; i++) {
        sql = `insert into Job_Skills values(null,${jobid},'${skills[i]}')`;
        await db.query(sql);
        console.log("SKills are : ", skills[i].toString());
    }
    res.send("POSTED Successfully");
});

//check
app.get('/check', async (req, res) => {
    var d = getCurrentDateTime();
    // jobid = req.query.jobid;
   // var sql = `insert into Jobs values(null,1,'','','active','${d}')`;
    //await db.query(sql);
    res.send("ALL is Good");
});
//get my post
app.get('/api2/getMyPosts', async (req, res) => {
    var userid = req.query.userid;
    console.log("CHALAAA");

    var sql1 = `select abc.userid, abc.name, abc.dp, def.jobid, def.caption, def.pic from Users abc inner join Jobs def on abc.userid=def.userid where abc.userid=${userid} and abc.status='active' and def.status='active' order by def.date_of_post desc`;
    var result = await db.query(sql1);
    for (var i = 0; i < result.length; i++) {
        sql1 = `select skill from Job_Skills where jobid=${result[i].jobid}`;
        var result2 = await db.query(sql1);
        result[i]["skills"] = [];
        for (j = 0; j < result2.length; j++) {
            console.log("AYA HAIII 1");
            result[i]["skills"].push(result2[j]["skill"]);
        }
    }
    res.json(result);
    return;
});
//update dp
app.post('/api2/updatedp', async (req, res) => {
    var userid = req.query.userid;
    const fs = require('fs');
    const file = req.files.dp;
    var dn = Date.now();
    var dpp=`${dn}.jpg`;
    await file.mv(`C:\\xampp\\htdocs\\${dn}.jpg`);
    var sql = `update Users set dp='${dn}.jpg' where userid=${userid}`;
    await db.query(sql);
    res.send(dpp.toString());
});

//search jobs
app.get('/api2/searchJobs', async (req, res) => {
    var userid = req.query.userid;
    console.log('USERID :   ', userid);
    var lat1 = req.query.lat;
    var lng1 = req.query.lng;
    var limit = req.query.limit;
    var sql = `select * from Users where userid!=${userid} and status='active'`;
    var result = await db.query(sql);
    var list = [];
    for (var i = 0; i < result.length; i++) {
        var lat2 = result[i]["lat"];
        var lng2 = result[i]["lng"];
        var R = 6371.0710;
        var rlat1 = lat1 * (Math.PI / 180);
        var rlat2 = lat2 * (Math.PI / 180);
        var difflat = rlat2 - rlat1;
        var difflon = (lng2 - lng1) * (Math.PI / 180);
        var d = 2 * R * Math.asin(Math.sqrt(Math.sin(difflat / 2) * Math.sin(difflat / 2) + Math.cos(rlat1) * Math.cos(rlat2) * Math.sin(difflon / 2) * Math.sin(difflon / 2)));
        if (d <= limit) {
            parseFloat(3.14159.toFixed(2));
            result[i]["distance"] = parseFloat(d.toFixed(2)).toString() + "";
            sql = `select count(jobid) from Jobs where userid=${result[i]["userid"]} and status='active'`;
            var jobs = await db.query(sql);
            result[i]["jobs"] = jobs[0]["count(jobid)"];
            console.log('USER ID : ', result[i]["userid"], '     JOBS ARE : ', jobs[0]["count(jobid)"]);
            if (result[i]["jobs"] != 0) {
                list.push(result[i]);
            }
        }
    }
    res.send(list);
});

//get feed by distance
app.get('/api2/getFeed', async (req, res) => {
    var userid = req.query.userid;
    console.log("CHALAAA");

    var sql1 = `select abc.userid, abc.name, abc.dp, def.jobid, def.caption, def.pic from Users abc inner join Jobs def on abc.userid=def.userid where abc.status='active' and def.status='active' order by def.date_of_post desc`;
    var result = await db.query(sql1);
    for (var i = 0; i < result.length; i++) {
        sql1 = `select skill from Job_Skills where jobid=${result[i].jobid}`;
        var result2 = await db.query(sql1);
        result[i]["skills"] = [];
        for (j = 0; j < result2.length; j++) {
            console.log("AYA HAIII 1");
            result[i]["skills"].push(result2[j]["skill"]);
        }
    }
    res.json(result);
    return;
});
//delete my job
app.post('/api2/deleteMyJob', async (req, res) => {
    jobid = req.query.jobid;
    var sql = `update Jobs set status='delete' where jobid=${jobid}`;
    await db.query(sql);
    res.send("Deleted");
});

app.post('/api2/check123', async (req, res) => {
    res.send("CHECKEDDDDdDDDdDDDdDDdDdDDdDDdDDDdDdDdDDDDDDDDdDDdDDDDDDDDd");
});

//update password

app.post('/api2/updatePassword', async (req, res) => {
    var userid = req.query.userid;
    var pwd = req.query.pwd;
    var sql = `update Users set pwd='${pwd}' where userid=${userid}`;
    await db.query(sql);
    res.send("Password Changed Successfully");
});

//get feed by distance

app.get('/api2/getFeedByDistance', async (req, res) => {
    var userid = req.query.userid;
    var lat1 = req.query.lat;
    var lng1 = req.query.lng;
    var distance = req.query.distance;

    console.log("CHALAAA 222222222222");
    var list = [];
    var sql1 = `select abc.userid, abc.lat, abc.lng, abc.name, abc.dp, def.jobid, def.caption, def.pic from Users abc inner join Jobs def on abc.userid=def.userid where abc.userid!=${userid} and abc.status='active' and def.status='active' order by def.date_of_post desc`;
    var result = await db.query(sql1);
    for (var i = 0; i < result.length; i++) {
        sql1 = `select skill from Job_Skills where jobid=${result[i].jobid}`;
        var result2 = await db.query(sql1);
        result[i]["skills"] = [];
        for (j = 0; j < result2.length; j++) {
            console.log("AYA HAIII 1");
            result[i]["skills"].push(result2[j]["skill"]);
        }
        var lat2 = result[i]["lat"];
        var lng2 = result[i]["lng"];
        var R = 6371.0710;
        var rlat1 = lat1 * (Math.PI / 180);
        var rlat2 = lat2 * (Math.PI / 180);
        var difflat = rlat2 - rlat1;
        var difflon = (lng2 - lng1) * (Math.PI / 180);
        var d = 2 * R * Math.asin(Math.sqrt(Math.sin(difflat / 2) * Math.sin(difflat / 2) + Math.cos(rlat1) * Math.cos(rlat2) * Math.sin(difflon / 2) * Math.sin(difflon / 2)));
        if (d <= distance) {
            list.push(result[i]);
        }
    }
    res.json(list);
    return;
});
//current date time
function getCurrentDateTime() {
    let date_time = new Date();

    // get current date
    // adjust 0 before single digit date
    let date = ("0" + date_time.getDate()).slice(-2);

    // get current month
    let month = ("0" + (date_time.getMonth() + 1)).slice(-2);

    // get current year
    let year = date_time.getFullYear();

    // get current hours
    let hours = date_time.getHours();

    // get current minutes
    let minutes = date_time.getMinutes();

    // get current seconds
    let seconds = date_time.getSeconds();

    // prints date in YYYY-MM-DD format
    console.log(year + "-" + month + "-" + date);

    // prints date & time in YYYY-MM-DD HH:MM:SS format
    return year + "-" + month + "-" + date + " " + hours + ":" + minutes + ":" + seconds;
    // console.log(year + "-" + month + "-" + date + " " + hours + ":" + minutes + ":" + seconds);
}


app.listen(port, () => console.log('Listening on Port:'+port))