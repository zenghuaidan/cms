package com.edeas.miscellaneous;

import org.junit.Test;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import com.edeas.security.MD5PasswordEncoder;

public class Main {
	
	@Test
	public void testEncode() {
		System.out.println(new MD5PasswordEncoder().encode("testing"));
		
		System.out.println(new BCryptPasswordEncoder().encode("testing"));
	}
}
