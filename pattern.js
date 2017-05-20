process.stdin.resume();
process.stdin.setEncoding('utf8');


/*
入力例
2
2
#.
##

出力例
#...............
##..............
#.#.............
####............
#...#...........
##..##..........
#.#.#.#.........
########........
#.......#.......
##......##......
#.#.....#.#.....
####....####....
#...#...#...#...
##..##..##..##..
#.#.#.#.#.#.#.#.
################
*/
process.stdin.on('data', function (chunk) {
    var line = chunk.toString();
    var k = line.split("\n")[0];
    var n = line.split("\n")[1];
    
    var pattern = line.split("\n");
    pattern.shift();
    pattern.shift();
    pattern.pop();
    var dim2Pattern = new Array();
    for(pat_i=0; pat_i<n; pat_i++){
        dim2Pattern[pat_i] = pattern[pat_i].split("");
    }
    
    for(gen_i=0; gen_i<k; gen_i++){
        dim2Pattern = generate(dim2Pattern, n);
        n = 2 * n;
    }
    
    for(out_j=0; out_j<n; out_j++){
        var array = dim2Pattern[out_j];
        if(array != undefined){
            console.log(array.join(""));
        }
    }
    
    function generate(dim2Pattern, n){
        var newDim2Pattern = new Array();

        for(init_i=0; init_i<2*n; init_i++){
            newDim2Pattern[init_i] = new Array();
        }
        
        for(var xi=0; xi<n; xi++){
            for(var yj=0; yj<n; yj++){
                if(dim2Pattern[yj+1] )
                else if(dim2Pattern[yj][xi] == "#"){
                    newDim2Pattern[2*yj][2*xi]     = dim2Pattern[yj][xi];
                    newDim2Pattern[2*yj+1][2*xi]   = dim2Pattern[yj+1][xi];
                    newDim2Pattern[2*yj][2*xi+1]   = dim2Pattern[yj][xi+1];
                    newDim2Pattern[2*yj+1][2*xi+1] = dim2Pattern[yj+1][xi+1];
                }else{
                    newDim2Pattern[2*yj][2*xi]     = ".";
                    newDim2Pattern[2*yj+1][2*xi]   = ".";
                    newDim2Pattern[2*yj][2*xi+1]   = ".";
                    newDim2Pattern[2*yj+1][2*xi+1] = ".";
                }
            }
        }
        return newDim2Pattern;
    }

});

