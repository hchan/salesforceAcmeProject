public  class RESTController {
	private String result;
	
	public String getResult() {
		return result;
	}
	
	public RESTController() {
		GoogleDrive googleDrive = new GoogleDrive();
		try {
			result = googleDrive.getAccessToken();
		} catch (Exception e) {
			result = e.getMessage();
		}
	}
}