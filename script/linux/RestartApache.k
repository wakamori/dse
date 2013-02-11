Json RestartApache(Json request) {
	String from = request.getString("from");
	if(from == null) return null;

	Json response = new Json();
	response.setString("event", "dse");
	response.setString("to", from);
	response.setString("stdout", $(sudo service apache2 restart));
	return response;
}
