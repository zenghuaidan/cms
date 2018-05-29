package com.edeas.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.edeas.model.Donation;

@Service(value="donationService")
@Transactional
public class DonationServiceImpl extends BasicServiceImpl {	
	
	public Donation addDonation(Donation donation) {
		return donationDao.add(donation);
	}
	
	public Donation findById(long id) {
		return donationDao.getById(id);
	}
	
	public void updateDonation(Donation donation) {
		donationDao.update(donation);
	}
	
	public void deleteById(long id) {
		donationDao.delete(id);
	}
	
	public List<Donation> findAllWithOrderDesc() {
		return donationDao.findAllWithOrderDesc();
	}		
}
