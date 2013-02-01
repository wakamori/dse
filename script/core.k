import("Syntax.Null");
import("JavaScript.String");
import("JavaScript.Array");
import("Type.Bytes");
import("Type.File");
import("Type.Json");
import("Lib.Curl");
import("dscript.subproc");

void outputFile(String fileName, String content) {
	FILE file = new FILE(fileName, "w");
	file.write(content.toBytes());
	file.close();
}

Json ExecuteScript(Json request) {
	Json params = request.get("params");
	String from = request.getString("from");
	if(params == null || from == null) return null;

	String cid = params.getString("cid");
	String scripttype = params.getString("scripttype");
	String content = params.getString("script");
	if(cid == null || scripttype == null || content == null) return null;

	int tid;
	if(scripttype == "D-Control") {
		tid = 0;
	}
	else if(scripttype == "D-Task") {
		tid = params.getInt("tid");
	}

	String fileName = cid + ":" + tid + ".k";
	outputFile(fileName, content);

	String command = "/usr/local/bin/minikonoha";
	String[] arguments = ("" + fileName).split(" ");
	SubProc sp = new SubProc(command);
	sp.setArgumentList(arguments);
	sp.bg();
	String[] out = sp.communicate("");
	int ret = sp.getStatus();
//	System.p("stdout : " + out[0]); // for debug
//	System.p("stderr : " + out[1]); // for debug
//	System.p("ret    : " + ret);    // for debug

	Json response = new Json();
	response.setString("event", "dse");
	response.setString("to", from);
	response.setString("cid", cid);
	response.setInt("tid", tid);
	response.setInt("code", ret);
//	response.setString("stdout", out[0]); // TODO
//	response.setString("stderr", out[1]); // TODO
	return response;
}

Json CheckChildAlive(Json request) {
	return new Json();
}

void main() {
	Json request = Json.parse(DSE_REQUEST);
	Json response = null;

	String method = request.getString("method");
//	System.p("method : " + method); // for debug
	if(method == "ExecuteScript") {
		response = ExecuteScript(request);
	}
	else if(method == "CheckChildAlive") {
		response = CheckChildAlive(request);
	}

	response.setString("jsonrpc", "2.0");
	String to = response.getString("to");
	if(to != null) {
		Curl curl = new Curl();
//		System.p("to : " + to); // for debug
		curl.setOpt(CURLOPT_URL, to);
//		System.p("response : " + response); // for debug
		curl.setOpt(CURLOPT_POSTFIELDS, response.toString());
		curl.perform();
	}
}

main();
