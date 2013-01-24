#!/usr/local/bin/minikonoha

import("JavaScript.String");
import("Type.Bytes");
import("Type.File");
import("Type.Json");
import("Lib.Curl");

String readFile(String fileName) {
	int BUFSIZ = 4096;
	FILE file = new FILE(fileName, "r");
	Bytes buf = new Bytes(BUFSIZ);
	buf.setAll(0);
	file.read(buf);
	file.close();
	return new String(buf);
}

void sendDTask() {
	String content = readFile(SCRIPT).replace("\"", "\\\"");

	Json request = new Json();
	request.setString("method","ExecuteScript");
	Json params = new Json();
	params.setString("cid", "test");
	params.setString("scripttype", "D-Control");
	params.setString("script", content);
	request.set("params", params);

	Curl curl = new Curl();
	curl.setOpt(CURLOPT_URL, IP);
	curl.setOpt(CURLOPT_POSTFIELDS, request.toString());
	curl.perform();
}

sendDTask();
