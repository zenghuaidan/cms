package com.edeas.service.impl;

import java.nio.charset.Charset;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.edeas.model.User;
import com.edeas.utils.MessageDigestUtils;

@Service(value="userService")
@Transactional
public class UserServiceImpl extends BasicService {

	public void testUser() {
		this.userDao.findAll();
	}

	public User tryLogin(String userName, String password) {
		try {
			String encryptPassword = MessageDigestUtils.encryptBASE64(MessageDigestUtils.encryptSHA("testing".getBytes(Charset.forName("utf-8"))));
			return userDao.findByUserNameAndPassword(userName, encryptPassword);
		} catch (Exception e) {
		}
		return null;
	}
	
}
