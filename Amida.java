import java.util.*;
/*
一番左の縦線に繋がるあみだくじを選ぶ
大規模データにも対応可能

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

public class Main {
    private static int l, n, m;
    private static int[] array_a;
    private static int[] array_b; 
    private static int[] array_c;
    
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        l = sc.nextInt();
        n = sc.nextInt();
        m = sc.nextInt();
        sc.nextLine();
        array_a = new int[m];
        array_b = new int[m];
        array_c = new int[m];
        for(int div_i=0; div_i<m; div_i++){
            array_a[div_i] = sc.nextInt();
            array_b[div_i] = sc.nextInt();
            array_c[div_i] = sc.nextInt();
            sc.nextLine();
        }
        
        //Amida関数を実行してあみだくじを下から上にたどる
        int[] posxy = Amida(1, l);
        int posx = posxy[0];
        int posy = posxy[1];
        while(true){
            posx = posxy[0];
            posy = posxy[1];
            if(posy == 0){break;}
            posxy = Amida(posx, posy);
        }        
        System.out.println(posx);
    }
    
    //一番下がposy=L, 左からposx=1,2,.. 現在の縦線から別の縦線に移った後の座標を返す
    public static int[] Amida(int posx, int posy){
        int index = -1; //aがposxまたはposx-1と等しくなる時の配列の添え字
        int max_depth = 0; //posxの縦線につながる横線の中でposyより小さくて一番大きいものの深さ
        int[] ret_ary = new int[2];
        
        for(int ai=0; ai<m; ai++){
            if(array_a[ai] == posx && array_b[ai] < posy && array_b[ai] > max_depth){
                index = ai;
                max_depth = array_b[ai];
            }else if(array_a[ai]+1 == posx && array_c[ai] < posy && array_c[ai] > max_depth){
                index = ai;
                max_depth = array_c[ai];
            }
        }
        
        if(index == -1){
            //そのまま上へ
            ret_ary[0] = posx;
            ret_ary[1] = 0;
        }
        else if(array_a[index] == posx){
            //右に行く
            ret_ary[0] = posx+1;
            ret_ary[1] = array_c[index];
        }else if(array_a[index]+1 == posx){
            //左に行く
            ret_ary[0] = posx-1;
            ret_ary[1] = array_b[index];
        }
        
        return ret_ary;    
    }
}

