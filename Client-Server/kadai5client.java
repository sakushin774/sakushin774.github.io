import java.io.*;
import java.net.*;
import java.util.regex.*;
import java.util.ArrayList;
class Client{
	private String host;
	private String path;
	private String port;
	private String str;
	private String req;
	
	private final String BR = System.getProperty("line.separator");
	public static void main(String args[]){
		Client client = new Client();
		
		client.input();
		while(true){
			client.analyzer();
			client.make_request();
			Browse browse = new Browse();
			browse.contents = client.connect_net();
			browse.collectLinks();
			browse.printLinks();
			client.str = browse.getLink();
			if(client.str.equals("return")){
				client.input();
				continue;
			}
			client.str = browse.completeLink(client.host, client.port, client.path, client.str);
		}
		
	}

	private void input(){
		//URLの入力
		try{
			System.out.println("URLを入力してください。");
			InputStreamReader instr = new InputStreamReader(System.in);
			BufferedReader br = new BufferedReader(instr);
			str = br.readLine();
		}catch(IOException e) {
      			System.err.println(e.getMessage());
		}
	}

	private void analyzer(){	
		try{
		String splitByDoubleSla[] = str.split("//", 0);
		int indexOfSla = splitByDoubleSla[1].indexOf('/');
		int indexOfCol = splitByDoubleSla[1].indexOf(':');
		if(indexOfCol == -1){
			host = splitByDoubleSla[1].substring(0, indexOfSla);
			port = "80";
			path = splitByDoubleSla[1].substring(indexOfSla, splitByDoubleSla[1].length());
		}else{
			host = splitByDoubleSla[1].substring(0, indexOfCol);
			port = splitByDoubleSla[1].substring(indexOfCol +1, indexOfSla);
			path = splitByDoubleSla[1].substring(indexOfSla, splitByDoubleSla[1].length());
		}
		
		}catch(ArrayIndexOutOfBoundsException e){
			System.out.println("入力されたURLが不正です。プログラムを終了します。");
			System.exit(1);
		}
	}

	private void make_request(){
		String request_line = "GET " + path + " HTTP/1.1" + BR;
		String request_header = "Host: " + host + BR;
		req = request_line + request_header + BR;
	}

	private String connect_net(){
		String contents = "";
		try {
			
			Socket s = new Socket(host, Integer.parseInt(port));
			BufferedReader in = new BufferedReader(new InputStreamReader(s.getInputStream()));
			PrintWriter out = new PrintWriter(s.getOutputStream(),true);
			String buf;

			// send request to server
			out.print(req);
			out.println(BR);
			
			// receive contents from server
			while (null != (buf = in.readLine())) {
				System.out.println(buf);
				contents = contents + buf;
			}
			in.close();
			out.close();
			s.close();
		} catch (UnknownHostException e) {
			System.out.println("Unknown host.");
			System.exit(1);
		} catch (IOException e) {
			System.out.println("IO exception.");
			System.exit(1);
		}
		return contents;
	}
}

class Browse {
		// instance variables
		public String url, contents, link, str;
		//public String[] links;
		private static final int MAX_LINKS = 100;
		ArrayList<String> links;

		// constructor
		public Browse(){
			url = "";
			links = new ArrayList<String>();
			//links = new String[MAX_LINKS];
			contents = "";
		}
		// methods
		public void collectLinks() {
			// contents中のリンクを抽出し，linksを更新
			Pattern pat = Pattern.compile("<a.*?href=\".*?\"", Pattern.CASE_INSENSITIVE);
			Matcher mat = pat.matcher(contents);
			for(int i=0; mat.find(); i++){
				link = mat.group();
				links.add(link.substring(link.toLowerCase().indexOf("href=\"") +6,
					link.lastIndexOf('\"')));
			}
			
		}
		public void printLinks() {
			// linksの内容をナンバリングしながら表示
			for(int i=0; i < links.size(); i++){
				System.out.println(i+1 +  ". " + links.get(i));
			}
		}
		public String getLink(){
			// links中のn番目のURLを返す
			while(true){
				try{
					System.out.println("表示されたリンクを開く場合は対応する数字を入力してください。");
					System.out.println("URLを入力しなおす場合はreturnを、終了する場合はexitを入力してください。");
					InputStreamReader instr = new InputStreamReader(System.in);
					BufferedReader br = new BufferedReader(instr);
					str = br.readLine();
				
					if(str.equals("return")){
						return str;
					}
					if(str.equals("exit")){
						System.exit(0);
					}
				
					int num = Integer.parseInt(str);
					if(num > 0 && num <= links.size()){
						return links.get(num-1);
					}else{
						System.err.println("不正な入力です。");
					}
				}catch(IOException | NumberFormatException e){
					System.err.println(e.getMessage());
					System.out.println("不正な入力です。");
				}
				}
			}
		
		public String completeLink(String host, String port, String path, String str){
			if((str.contains("http://"))){
				return str;
			}else{
				while(str.contains("../")){
					str = str.substring(3, str.length());
					path = path.substring(0, path.lastIndexOf('/'));
				}
				if(str.contains("./")){
					str = str.substring(2, str.length());
				}
				path = path.substring(0, path.lastIndexOf('/'));
				str = "http://" + host + ':' + port + path + '/' + str;
				return str;
			}
		}
}
