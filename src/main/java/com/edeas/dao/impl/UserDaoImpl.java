package com.edeas.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.edeas.model.User;

@Repository(value="userDao")
public class UserDaoImpl extends BasicDao<User> {

//	public User findByUserNameAndPassword(String userName, String password) {
//		List<User> users = listByHQL("from User where login=? and password=?", new String[]{userName, password});
////		List<User> users = listBySQL("select * from CmsUser where login=? and password=?", new String[]{userName, password}, User.class, true);
//		return users.size() > 0 ? users.get(0) : null;
//	}
	
	public User findByUserName(String userName) {
		List<User> users = listByHQL("from User where login=?", new String[]{userName});
//		List<User> users = listBySQL("select * from CmsUser where login=? and password=?", new String[]{userName, password}, User.class, true);
		return users.size() > 0 ? users.get(0) : null;
	}

	public void updatePassword(String userName, String oldPassword, String newPassword) {
		updateBySQL("update " + getTableName() + " set password=? where login=? and password=?", new String[]{newPassword, userName, oldPassword});
	}
}
