package com.edeas.utils;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordUtils {

	public static boolean matches(String oldpwd, String encodedPassword) {
		return new BCryptPasswordEncoder().matches(oldpwd, encodedPassword);
	}
	
	public static String encode(String pwd) {
		return new BCryptPasswordEncoder().encode(pwd);
	}
	
	public static void main(String[] args) {
		System.out.println(encode("testing"));
	}
	
}
