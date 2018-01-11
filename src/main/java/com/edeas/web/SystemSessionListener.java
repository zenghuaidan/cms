package com.edeas.web;

import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

public class SystemSessionListener implements HttpSessionListener {

	@Override
	public void sessionCreated(HttpSessionEvent event) {
		// only need to add the login session, can do the login in login method
	}

	@Override
	public void sessionDestroyed(HttpSessionEvent event) {
		// need to handle user directly close the browser case
		SystemSessionContext.removeSession(event.getSession());
	}

}
