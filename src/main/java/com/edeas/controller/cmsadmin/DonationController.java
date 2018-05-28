package com.edeas.controller.cmsadmin;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.edeas.dto.Result;
import com.edeas.model.Donation;

@Controller
public class DonationController extends CmsController {
	
	@RequestMapping(path = {"DonationAdmin", "DonationAdmin/Index"}, method={RequestMethod.GET})
	public String Index(Model model) {
		List<Donation> donations = donationService.findAllWithOrderDesc();
		model.addAttribute("donations", donations);
		model.addAttribute("navigation", "DonationAdmin");
		return "DonationAdmin/Index";
	}
	
	@RequestMapping(path = {"DonationAdmin/Void/{id}"}, method={RequestMethod.GET})
	@ResponseBody
	public Result Delete(@PathVariable Long id) {				
		Donation donation = donationService.findById(id);
		donation.setSuccess(false);
		donationService.updateDonation(donation);
		return new Result();
	}
	
//	@RequestMapping(path = {"CategoryAdmin/Save"}, method={RequestMethod.POST})
//	@ResponseBody
//	public Result Save(Category category) {
//		if(category.getId() != null) {
//			categoryService.update(category);		
//		} else {
//			category.setNameSC(HanLP.t2s(category.getNameTC()));
//			categoryService.addCategory(category);
//		}
//		return new Result();
//	}
//	
//	@RequestMapping(path = {"CategoryAdmin/Delete"}, method={RequestMethod.POST})
//	@ResponseBody
//	public Result Delete(Long id) {				
//		categoryService.deleteById(id);		
//		return new Result();
//	}
//	
//	@RequestMapping(path = {"CategoryAdmin/ChgOrder"}, method={RequestMethod.POST})
//	@ResponseBody
//	public Result ChgOrder(Long id, Long beforeId) {				
//		categoryService.chgOrder(id, beforeId);		
//		return new Result();
//	}
		
}
