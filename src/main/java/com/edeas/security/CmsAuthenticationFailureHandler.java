package com.edeas.security;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;

public class CmsAuthenticationFailureHandler
		extends SimpleUrlAuthenticationFailureHandler {

	@Override
	public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
			AuthenticationException exception) throws IOException, ServletException {
		HttpServletRequest _request = (HttpServletRequest) request;
		List<String> errors = new ArrayList<String>();
		errors.add("Invalidate user name or password.");
		_request.getSession().setAttribute("errors", errors);
		super.onAuthenticationFailure(request, response, exception);
	}



}
