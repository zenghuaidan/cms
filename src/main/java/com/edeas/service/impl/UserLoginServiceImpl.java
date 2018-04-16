package com.edeas.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.edeas.model.User;
import com.edeas.model.UserRole;


@Service("userLoginService")
@Transactional
public class UserLoginServiceImpl extends BasicServiceImpl implements UserDetailsService {
	
	@Override
	public UserDetails loadUserByUsername(String userName) throws UsernameNotFoundException {
		User user = userDao.findByUserName(userName);
		if (user == null)
			throw new UsernameNotFoundException(userName + " not exists");
		List<GrantedAuthority> authorities = new ArrayList<GrantedAuthority>();	
		for(UserRole userRole : user.getUserRoles()) {
			authorities.add(new SimpleGrantedAuthority(userRole.getName()));			
		}
//		authorities.add(new SimpleGrantedAuthority("ROLE_Admin"));
		return new org.springframework.security.core.userdetails.User(user.getLogin(), user.getPassword(), authorities);
	}

}
