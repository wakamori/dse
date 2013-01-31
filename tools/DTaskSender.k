#!/usr/local/bin/minikonoha

import("JavaScript.String");
import("Type.Bytes");
import("Type.File");
import("Type.Json");
import("Lib.Curl");
import("Syntax.CStyleWhile");
import("MiniKonoha.EventListener");
import("posix.process");

String readFile(String fileName) {
	int BUFSIZ = 4096;
	FILE file = new FILE(fileName, "r");
	Bytes buf = new Bytes(BUFSIZ);
	buf.setAll(0);
	file.read(buf);
	file.close();
	return new String(buf);
}

void dumpResponse(Event e) {
	System.p("cid : "    + e.getProperty("cid"));
	System.p("tid : "    + e.getInt("tid"));
	System.p("code : "   + e.getInt("code"));
	System.p("stdout : " + e.getProperty("stdout"));
	System.p("stderr : " + e.getProperty("stderr"));
}

void sendDTask() {
	EventHandler.setCallBack("dse", dumpResponse);
	HttpEventListener.start("0.0.0.0", 8090);

	String script = readFile(SCRIPT).replace("\"", "\\\"");

	Json request = new Json();
	request.setString("jsonrpc", "2.0");
	request.setString("method","ExecuteScript");
	request.setString("from", "http://0.0.0.0:8090");
	Json params = new Json();
	params.setString("cid", "test");
	params.setString("scripttype", "D-Control");
	params.setString("script", script);
	request.set("params", params);

	Curl curl = new Curl();
	curl.setOpt(CURLOPT_URL, IP);
	curl.setOpt(CURLOPT_POSTFIELDS, request.toString());
	curl.perform();

	while(true) {
		System.usleep(10000);
	}
}

sendDTask();
