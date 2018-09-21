var fs = require("fs");
var plot = require('plotter').plot;

var file1 = 'raw_data/data_gossip_imp2d.txt';
var file2 = 'raw_data/data_gossip_full.txt';
var file3 = 'raw_data/data_gossip_2d.txt';
var file4 = 'raw_data/data_gossip_line.txt'

var file5 = 'raw_data/data_pushsum_imp2d.txt';
var file6 = 'raw_data/data_pushsum_full.txt';
var file7 = 'raw_data/data_pushsum_2d.txt';
var file8 = 'raw_data/data_pushsum_line.txt'

var dataobj1 = extractdata(file1);
var dataobj2 = extractdata(file2);
var dataobj3 = extractdata(file3);
var dataobj4 = extractdata(file4);

var dataobj5 = extractdata(file5);
var dataobj6 = extractdata(file6);
var dataobj7 = extractdata(file7);
var dataobj8 = extractdata(file8);


plot({
  data     :	{'line' : dataobj1},
  filename :	'output_gossip_imp2d.png',
  xlabel   :  	'No. of nodes',
  ylabel   :    'convergence time (ms)'
});

plot({
  data     :	{'line' : dataobj2},
  filename :	'output_gossip_full.png',
  xlabel   :  	'No. of nodes',
  ylabel   :    'convergence time (ms)'
});

plot({
  data     :	{'line' : dataobj3},
  filename :	'output_gossip_2d.png',
  xlabel   :  	'No. of nodes',
  ylabel   :    'convergence time (ms)'
});

plot({
  data     :	{'line' : dataobj4},
  filename :	'output_gossip_line.png',
  xlabel   :  	'No. of nodes',
  ylabel   :    'convergence time (ms)'
});

plot({
  data     :	{'line' : dataobj5},
  filename :	'output_pushsum_imp2d.png',
  xlabel   :  	'No. of nodes',
  ylabel   :    'convergence time (ms)'
});

plot({
  data     :	{'line' : dataobj6},
  filename :	'output_pushsum_full.png',
  xlabel   :  	'No. of nodes',
  ylabel   :    'convergence time (ms)'
});

plot({
  data     :	{'line' : dataobj7},
  filename :	'output_pushsum_2d.png',
  xlabel   :  	'No. of nodes',
  ylabel   :    'convergence time (ms)'
});

plot({
  data     :	{'line' : dataobj8},
  filename :	'output_pushsum_line.png',
  xlabel   :  	'No. of nodes',
  ylabel   :    'convergence time (ms)'
});


function extractdata(file){
	var data = fs.readFileSync(file, 'utf8');

	data = data.toString();
	data = data.split("\n");
	data.pop();

	var dataobj = {};
	
	for(var i = 0; i < data.length; i++){
	  var a = JSON.parse(data[i]);
	    
	  for(var j = 0; j < a.length; j+=2){
		dataobj[a[j]] = parseInt(a[j+1]);
	  }
	}

	return dataobj;
}
