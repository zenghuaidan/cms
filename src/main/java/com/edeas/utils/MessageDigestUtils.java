package com.edeas.utils;

import java.nio.charset.Charset;
import java.security.MessageDigest;

import javax.crypto.KeyGenerator;
import javax.crypto.Mac;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

@SuppressWarnings("restriction")

public abstract class MessageDigestUtils {

	public static void main(String[] args) throws Exception{
		String encryptPassword = MessageDigestUtils.encryptBASE64(MessageDigestUtils.encryptSHA("testing".getBytes(Charset.forName("utf-8"))));
		System.out.println(encryptPassword);
	}
	
	public static final String KEY_SHA = "SHA";

	public static final String KEY_MD5 = "MD5";

	/**
	 * 
	 * MAC算法可选以下多种算法
	 * 
	 * HMAC MD5
	 * 
	 * HMAC SHA1
	 * 
	 * HMAC SHA256
	 * 
	 * HMAC SHA384
	 * 
	 * HMAC SHA512
	 * 
	 */

	public static final String KEY_MAC = "HMACMD5";

	/**
	 * 
	 * BASE64解密
	 * 
	 */
	public static byte[] decryptBASE64(String key) throws Exception {
		return (new BASE64Decoder()).decodeBuffer(key);
	}

	// BASE64加密
	public static String encryptBASE64(byte[] key) throws Exception {
		return (new BASE64Encoder()).encodeBuffer(key);
	}

	// MD5加密
	public static byte[] encryptMD5(byte[] data) throws Exception {

		MessageDigest md5 = MessageDigest.getInstance(KEY_MD5);

		md5.update(data);

		return md5.digest();

	}

	// SHA加密
	public static byte[] encryptSHA(byte[] data) throws Exception {

		MessageDigest sha = MessageDigest.getInstance(KEY_SHA);

		sha.update(data);

		return sha.digest();

	}

	// 初始化HMAC密钥
	public static String initMacKey() throws Exception {

		KeyGenerator keyGenerator = KeyGenerator.getInstance(KEY_MAC);

		SecretKey secretKey = keyGenerator.generateKey();

		return encryptBASE64(secretKey.getEncoded());

	}

	// HMAC加密
	public static byte[] encryptHMAC(byte[] data, String key) throws Exception {

		SecretKey secretKey = new SecretKeySpec(decryptBASE64(key), KEY_MAC);

		Mac mac = Mac.getInstance(secretKey.getAlgorithm());

		mac.init(secretKey);

		return mac.doFinal();

	}

}