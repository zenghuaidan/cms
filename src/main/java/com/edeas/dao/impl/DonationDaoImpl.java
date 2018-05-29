package com.edeas.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.edeas.model.Donation;
import com.edeas.web.SiteIdHolder;

@Repository(value="donationDao")
public class DonationDaoImpl extends BasicDao<Donation> {

	public List<Donation> findAllWithOrderDesc() {
		return listByHQL("from " + getClz().getName() + " where cmsPage.siteId=? order by id desc", new String[]{ SiteIdHolder.getSiteId() });
	}
	
}
