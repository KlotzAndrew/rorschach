var express = require('express');
var app = express();
var moment = require('moment');

symbolSet = {};

// /quoteStream?symbol=AAPL+GOOG
app.get('/quoteStream', function(req, res) {
  res.writeHead(200, { "Content-Type": "text/event-stream" });

  req.query.symbol.split(" ").forEach(function(symbol) {
    if (needsPublish(symbolSet, symbol)) {
      symbolSet[symbol] = true
      randomWalk(res, symbol)
    }
  })
})

function needsPublish(set, symbol) {
  return set[symbol] ? false : true
}

function randomWalk(res, symbol) {
  var value = charsToInt(symbol);
  res.write(quoteTick(symbol, value))

  setInterval(function() {
    value = newValue(value)
    tick = quoteTick(symbol, value)
    console.log('publishing tick: ', tick)
    res.write(tick)
  }, tickFrequency())
}

function tickFrequency() {
  return Math.max(Math.random()*10000, 2500);
}

function newValue(oldValue) {
  return oldValue * (1 + Math.random()*0.01 - Math.random()*0.01);
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

app.listen(5020, function () {
  console.log('Market client demo running on 5020!')
})
