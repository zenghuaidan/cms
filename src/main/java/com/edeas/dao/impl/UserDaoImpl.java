package com.edeas.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.edeas.model.User;

@Repository(value="userDao")
public class UserDaoImpl extends BasicDao<User> {

	public User findByUserNameAndPassword(String userName, String password) {
		List<User> users = listByHQL("from User where login=? and password=?", new String[]{userName, password});
		return users.size() > 0 ? users.get(0) : null;
	}
}
