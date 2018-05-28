package com.edeas.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.edeas.model.Donation;

@Repository(value="donationDao")
public class DonationDaoImpl extends BasicDao<Donation> {

	public List<Donation> findAllWithOrderDesc() {
		return getSession().createQuery("from Donation order by id desc").list();
	}
	
}
