package com.edeas.web;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

public class SystemSessionContext {
	
	private static final Map<String, HttpSession> ctx = new HashMap<String, HttpSession>();
	
	public static void addSession(HttpSession session) {
		if (!ctx.containsKey(session.getId()))
			ctx.put(session.getId(), session);
	}
	
	public static void removeSession(HttpSession session) {
		ctx.remove(session.getId());
	}
	
	public static HttpSession getSession(String sessionId) {
		return ctx.get(sessionId);
	}
	
}
