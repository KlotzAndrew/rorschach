var express = require('express');
var app = express();
var moment = require('moment');

// /quoteStream?symbol=AAPL+GOOG
app.get('/quoteStream', function(req, res) {
  res.writeHead(200, { "Content-Type": "text/event-stream" });

  req.query.symbol.split(" ").forEach(function(symbol) {
    randomWalk(res, symbol)
  })
})

function randomWalk(res, symbol) {
  var value = charsToInt(symbol);
  res.write(quote_tick(symbol, value))

  setInterval(function() {
    value = value * (1 + Math.random()*0.01 - Math.random()*0.01)
    res.write(quote_tick(symbol, value))
  }, 1000)
}

// 'Q,TSLA,0,K,Q,280.650000,280.770000,1,5,20170215125426269\n'
function quote_tick(symbol, value) {
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
