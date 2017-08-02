var express = require('express');
var app = express();
var moment = require('moment');

let prevReq = null;

// /quoteStream?symbol=AAPL+GOOG
app.get('/quoteStream', function(req, res) {
  res.writeHead(200, { "Content-Type": "text/event-stream" });
  prevReq = req

  console.log('received request', req.query)

  req.query.symbol.split(" ").forEach(function(symbol) {
    randomWalk(req, res, symbol, 50)
  })
})

function needsPublish(set, symbol) {
  return set[symbol] ? false : true
}

function randomWalk(req, res, symbol, prevValue) {
  var value = newValue(prevValue);

  setTimeout(function() {
    tick = quoteTick(symbol, value)
    console.log('publishing tick: ', tick)
    res.write(tick)

    if (req == prevReq) { randomWalk(req, res, symbol, value) }
  }, tickFrequency())
}

function tickFrequency() {
  return Math.random()*10000;
}

function newValue(oldValue) {
  if (oldValue > 2000) { return 1; }
  return oldValue * 20
  // return oldValue * (1 + Math.random()*0.01 - Math.random()*0.01);
}

// 'Q,TSLA,0,K,Q,280.650000,280.770000,1,5,20170215125426269\n'
function quoteTick(symbol, value) {
  timestamp = moment.utc().format('YYYYMMDDHHmmssSSS');
  bid = value*.99;
  ask = value;

  return `Q,${symbol},0,K,Q,${bid},${ask},1,5,${timestamp}\n`;
}

function charsToInt(symbol) {
  value = 0;
  symbol.split('').forEach(function(char) { value += char.charCodeAt(0) })
  return value / symbol.split('').length
}

app.listen(5000, function () {
  console.log('Market client demo running on 5000!')
})
