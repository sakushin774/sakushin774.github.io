process.stdin.resume();
process.stdin.setEncoding('utf8');

/*
ハノイの塔の円盤数と動かす回数から状態を求める
円盤の大きさは数字の大きさと同じ

入力例
3 4

出力例
- 
2 1
3
*/

//大域変数
var a = [];
var b = [];
var c = [];

process.stdin.on('data', function (chunk) {
    var line = chunk.toString();
    var n = parseInt(line.split(" ")[0]);
    var t = parseInt(line.split(" ")[1]);
    for(var i=n; i>0; i--){
        a.push(i);
    }

    hanoi(n, false, 0);
    output(a);
    output(b);
    output(c);
    
    
    function hanoi(n, putOnNext, moveFrom){ //putOnNext=trueなら次,falseなら前に積む
        if(t===0){return 1;}
        else if(n==1){   
            //一番上を移す
            pushAndPop(putOnNext, moveFrom, 1);
            t--;
            return 0;
        } 
        else{
            //上からn-1個を移す
            if(hanoi(n-1, !putOnNext, moveFrom)) 
                return 1; 
            if(t===0){return 1;}   
            
             //一番下を移す
            pushAndPop(putOnNext, moveFrom, n);
            t--;
            if(t===0){return 1;}  
            
            //上からn-1個を戻す            
            if(hanoi(n-1, !putOnNext, getPosition(!putOnNext, moveFrom))) 
                return 1;
        }
        return 0;
    }

    
    function pushAndPop(putOnNext, moveFrom, i){
        if(putOnNext){
            switch(moveFrom){
                case 0:
                    b.push(i);
                    a.pop();
                    break;
                case 1:
    　               c.push(i);
                    b.pop();
                    break;
                case 2:
                    a.push(i);
                    c.pop();
                    break;
            }
        }else{
            switch(moveFrom){
                case 0:
                    c.push(i);
                    a.pop();
                    break;
                case 1:
                    a.push(i);
                    b.pop();
                    break;
                case 2:
                    b.push(i);
                    c.pop();
                    break;
            }
        }
    }

    function getPosition(puttedOnNext, movedFrom){
        if(puttedOnNext){
            switch(movedFrom){
                case 0:
                    return 1;
                case 1:
    　               return 2;
                case 2:
                    return 0;
            }
        }else{
            switch(movedFrom){
                case 0:
                    return 2;
                case 1:
                    return 0;
                case 2:
                    return 1;
            }
        }        
    }
    
    function output(array){
        if(array.length === 0){array.push("-")}
        var out = array.join(" ");
        console.log(out);
    }

});

