package com.edeas.security;

import java.nio.charset.Charset;

import org.springframework.security.crypto.password.PasswordEncoder;

import com.edeas.utils.MessageDigestUtils;

public class MD5PasswordEncoder implements PasswordEncoder {

	@Override
	public String encode(CharSequence rawPassword) {
		try {
			return MessageDigestUtils.encryptBASE64(MessageDigestUtils.encryptMD5(rawPassword.toString().getBytes(Charset.forName("utf-8"))));			
		} catch (Exception e) {
			return "";
		}
	}

	@Override
	public boolean matches(CharSequence rawPassword, String encodedPassword) {
		return encodedPassword.equals(encode(rawPassword));
	}

}