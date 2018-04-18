package com.edeas.miscellaneous;

import org.junit.Test;

import com.edeas.utils.PasswordUtils;

public class Main {
	
	@Test
	public void testEncode() {
		System.out.println(PasswordUtils.encode("testing"));
		
		System.out.println(PasswordUtils.encode("testing"));
	}
}
