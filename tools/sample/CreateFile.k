import("JavaScript.String");
import("Type.Bytes");
import("Type.File");

void CreateFile(String fileName, String content) {
	FILE file = new FILE(fileName, "w");
	file.write(content.toBytes());
	file.close();
}

CreateFile("test", "this is a test");
