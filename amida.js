process.stdin.resume();
process.stdin.setEncoding('utf8');
/*
一番左に繋がるあみだくじを選ぶ
100万単位のデータの処理には不向き

入力例
7 4 5 # L(縦線の長さ)=7、n(縦線の本数)=4、m(横線の本数)=5
1 3 1 # 1番目の横線　1番目の縦線の上から3cmの位置から、2番目の縦線の上から1cmの位置に線が引かれる
3 2 2 # 2番目の横線　3番目の縦線の上から2cmの位置から、4番目の縦線の上から2cmの位置に線が引かれる
2 3 5 # 3番目の横線　2番目の縦線の上から3cmの位置から、3番目の縦線の上から5cmの位置に線が引かれる
3 4 4 # 4番目の横線　3番目の縦線の上から4cmの位置から、4番目の縦線の上から4cmの位置に線が引かれる
1 6 6 # 5番目の横線　1番目の縦線の上から6cmの位置から、2番目の縦線の上から6cmの位置に線が引かれる

出力例
3
*/

process.stdin.on('data', function (chunk) {
    var line = chunk.toString();
    //line = "5 5 8\n3 3 4\n1 3 2\n4 2 2\n2 1 2\n2 4 4\n3 1 1\n1 4 3\n4 3 4\n";
    var lnm = line.split("\n")[0];
    var l = lnm.split(" ")[0];
    var n = lnm.split(" ")[1];
    var m = lnm.split(" ")[2];
    var a = [];
    var b = [];
    var c = [];
    var abc = line.split("\n");
    abc.shift();
    abc.pop();
    //Amida(0,1)
    
    //a,b,cをそれぞれ配列に分ける
    for(var i=0; i<m; i++){
        a.push(parseInt(abc[i].split(" ")[0]));
        b.push(parseInt(abc[i].split(" ")[1]));
        c.push(parseInt(abc[i].split(" ")[2]));
    }
    
    //Amida関数を実行してあみだくじを下から上にたどる
    var posxy = Amida(1, l);
    var posx = posxy[0];
    var posy = posxy[1];
    while(1){
        posx = posxy[0];
        posy = posxy[1];
        if(posy === 0){break;}
        posxy = Amida(posx, posy);
    }
    
    console.log(posx);
    
    
    //一番下がposy=L, 左からposx=1,2,..
    function Amida(posx, posy){
        var index = -1; //aが現在のxまたはx-1と等しくなるときの配列の添え字
        var max_depth = 0; //posxの縦線につながる横線の中でposyより小さくて一番大きいものの深さ
        for(var amida_i=0; amida_i<m; amida_i++){
            if(a[amida_i] == posx   && b[amida_i] > max_depth && posy > b[amida_i]){
                index = amida_i;
                max_depth = b[amida_i];
            }else if(a[amida_i]+1 == posx && c[amida_i] > max_depth && posy > c[amida_i]){
                index = amida_i;
                max_depth = c[amida_i];
            }
        }
        if(index == -1){
            //そのまま上へ
            return[posx, 0];            
        }
        else if(a[index] == posx){
            //右に行く
            return[posx+1, c[index]];
        }else if(a[index]+1 == posx){
            //左に行く
            return[posx-1, b[index]];
        }
    }
    
});

