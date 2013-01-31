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
	if(params == null) return null;
	String cid = params.getString("cid");
	String scripttype = params.getString("scripttype");
	String content = params.getString("script");
	String from = params.getString("from");
	if(cid == null || scripttype == null || content == null || from == null) return null;
	int tid;
	if(scripttype == "D-Control") {
		tid = 0;
	}
	else if(scripttype == "D-Task") {
		tid = params.getInt("tid");
	}

	String fileName = cid + ":" + tid + ".k";
	outputFile(fileName, content);

	String command = "minikonoha";
	String[] arguments = ("" + fileName).split(" ");
	SubProc sp = new SubProc(command);
	sp.setArgumentList(arguments);
	int result = sp.fg();

	Json response = new Json();
	response.setString("event", "dse");
	response.setString("to", from);
	response.setString("cid", cid);
	response.setInt("tid", tid);
	return response;
}

Json CheckChildAlive(Json request) {
	return new Json();
}

void main() {
	Json request = Json.parse(DSE_REQUEST);
	Json response = null;

	String method = request.getString("method");
	if(method == "ExecuteScript") {
		response = ExecuteScript(request);
	}
	else if(method == "CheckChildAlive") {
		response = CheckChildAlive(request);
	}

	String to = response.getString("to");
	if(to != null) {
		Curl curl = new Curl();
		curl.setOpt(CURLOPT_URL, to);
		curl.setOpt(CURLOPT_POSTFIELDS, response.toString());
		curl.perform();
	}
}

main();
