package com.edeas.dto;

public class Result {
	private boolean success;
	private String successMsg;
	private String errorCode;
	private String errorMsg;

	public Result() {
		this(true, "", "", "");
	}
	
	public Result(String successMsg) {		
		this(true, successMsg, "", "");
	}
	
	public Result(String errorCode, String errorMsg) {
		this(false, "", errorCode, errorMsg);
	}

	public Result(boolean success, String successMsg, String errorCode, String errorMsg) {
		this.success = success;
		this.successMsg = successMsg;
		this.errorCode = errorCode;
		this.errorMsg = errorMsg;
	}

	public boolean isSuccess() {
		return success;
	}

	public void setSuccess(boolean success) {
		this.success = success;
	}

	public String getSuccessMsg() {
		return successMsg;
	}

	public void setSuccessMsg(String successMsg) {
		this.successMsg = successMsg;
	}

	public String getErrorCode() {
		return errorCode;
	}

	public void setErrorCode(String errorCode) {
		this.errorCode = errorCode;
	}

	public String getErrorMsg() {
		return errorMsg;
	}

	public void setErrorMsg(String errorMsg) {
		this.errorMsg = errorMsg;
	}

}
