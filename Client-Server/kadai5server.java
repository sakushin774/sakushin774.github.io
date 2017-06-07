import java.net.*;
import java.io.*;

class Server {
	public static void main(String[] args) {
		if (args.length < 1) return;
		try {
			ServerSocket serverS = new ServerSocket(Integer.parseInt(args[0]));
			while (true) {
				new ServerThread(serverS.accept()).start();
				System.out.println("New connection.");
			}
		} catch  (IOException e) {
			System.out.println("IO exception.");
			System.exit(1);
		}
	}
}

class ServerThread extends Thread {
	private final String BR = System.getProperty("line.separator");
	Socket clientS;
	int sleepTime;
	String request = "";
	String path = "";
	int indexOfFirstSpace, indexOfSecondSpace;
	String entityHeader, statusLine, response;
	String statusCode, reasonPhrase;

	public ServerThread(Socket acceptedS) {
		clientS = acceptedS;
	}
	
	public void run() {
		try {
			PrintStream out = new PrintStream(clientS.getOutputStream(), true);
			BufferedReader in = new BufferedReader(new InputStreamReader(clientS.getInputStream()));
			String buf;

			// receive requests from client (until an empty line)
			while(null != (buf = in.readLine())) {
			    if(buf.equals("")) {
				break;
			    } else {
				request = request + buf;
			    }
			}
			
			//extract path from requests 
			indexOfFirstSpace = request.indexOf(" ");
			indexOfSecondSpace = request.indexOf(" ", indexOfFirstSpace+1);
			path = request.substring(indexOfFirstSpace+2, indexOfSecondSpace);
			// open file
			try {
				File file = new File(path);
				FileReader filereader = new FileReader(file);
				int ch = filereader.read();
				statusCode = "200";
				reasonPhrase = "OK";
				// make response to client
				entityHeader = "Content-Type: text/html; charset=us-ascii";
				statusLine = "HTTP/1.1 " + statusCode + " " + reasonPhrase + BR;
				response = statusLine + entityHeader + BR;
				while(ch != -1){
					response = response + ((char)ch);
					ch = filereader.read();
				}

				filereader.close();
			} catch(FileNotFoundException e){
				statusCode = "404";
				reasonPhrase = "Not Found";
				// make response to client
				entityHeader = "Content-Type: text/html; charset=us-ascii";
				statusLine = "HTTP/1.1 " + statusCode + " " + reasonPhrase + BR;
				response = statusLine + entityHeader + BR;
				response = response + "<HTML><HEAD>Not Found</HEAD> <BODY> The requested URL " + path + " was not found on this server.</BODY></HTML>";

			} catch(IOException e){
				System.err.println(e);
			}
			
			
			

			// send contents to client
			out.println(response);
			out.close();
			in.close();
			clientS.close();
		} catch  (IOException e) {
			System.out.println("IO exception.");
			System.exit(1);
		}
	}
}
