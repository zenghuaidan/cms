package com.edeas.miscellaneous;

import org.junit.Test;

import com.edeas.security.MD5PasswordEncoder;

public class Main {
	
	@Test
	public void testEncode() {
		System.out.println(new MD5PasswordEncoder().encode("testing"));
	}
}
