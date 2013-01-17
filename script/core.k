import("Syntax.Null");
import("JavaScript.String");
import("JavaScript.Array");
import("Type.Bytes");
import("Type.File");
import("Type.Json");
import("dscript.subproc");

void outputFile(String fileName, String content) {
	FILE file = new FILE(fileName, "w");
	file.write(content.toBytes());
	file.close();
}

Json ExecuteScript(Json message) {
	Json params = message.get("params");
	if(params == null) return null;
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

	String command = "minikonoha";
	String[] arguments = ("" + fileName).split(" ");
	SubProc sp = new SubProc(command);
	sp.setArgumentList(arguments);
	int result = sp.fg();

	Json response = new Json();
	return response;
}

Json CheckChildAlive(Json message) {
}

void main() {
//	Json request = Json.parse("{\"method\":\"ExecuteScript\", \"params\":{\"cid\":\"hoge\", \"scripttype\":\"D-Control\",\"script\":\"System.p(\\\"hoge\\\");\"}}");   this is stub
	Json request = Json.parse(DSE_REQUEST);
	Json response = null;
	String method = request.getString("method");
	if(method == "ExecuteScript") {
		response = ExecuteScript(request);
	}
	else if(method == "CheckChildAlive") {
		response = CheckChildAlive(request);
	}
}

main();
