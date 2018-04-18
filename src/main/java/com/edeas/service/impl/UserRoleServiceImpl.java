package com.edeas.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.edeas.model.UserRole;

@Service(value="userRoleService")
@Transactional
public class UserRoleServiceImpl extends BasicServiceImpl {
	
	public List<UserRole> findAll() {		
		return userRoleDao.findAll();
	}
	
	
}
