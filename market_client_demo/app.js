var express = require('express')
var app = express()

app.get('/', function (req, res) {
  quotes = [
    'Q,TSLA,0,K,Q,280.650000,280.770000,1,5,20170215125426269\n',
    'Q,TSLA,0,K,Q,280.750000,280.850000,1,1,20170215125357729\n',
    'Q,AAPL,0,Q,Q,134.990000,135.000000,11,24,20170215125356166\n',
    'Q,AAPL,0,Q,Q,134.990000,135.000000,17,17,20170215125358329\n',
    'Q,GOOG,0,Z,Q,821.490000,821.720000,1,1,20170215125357850\n',
    'Q,GOOG,0,P,Q,821.500000,821.720000,2,1,20170215125358309\n',
  ];

  setInterval(function() {
    quote = quotes[Math.floor(Math.random() * quotes.length)];
    res.write(quote);
  }, 60000)
})

app.listen(3000, function () {
  console.log('Market client demo running on 3000!')
})
