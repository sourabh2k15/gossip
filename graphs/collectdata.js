var exec = require('child_process').exec;
var fs = require("fs");

var topology = "imp2D";
var algorithm = "push-sum";
var n = 4;
var end = 80;
var data = [];
var output = 'data_pushsum_imp2d.txt';

function puts(bleh, time, bleh) { 
  data.push(time.replace("\n", ""));
  n += 10;
  
  if(n < end) execute(n);
  else{ 
    fs.appendFileSync(output, JSON.stringify(data)+'\n');	
  }
}


function execute(i){
  var command = "./project2 "+i+" "+topology+" "+algorithm;
  console.log("n: "+n);
  data.push(n);
  exec(command, puts);
}

console.log("Starting data collection");
execute(n);

