package com.edeas.controller.cmsadmin;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.edeas.dto.Result;
import com.edeas.model.Category;
import com.hankcs.hanlp.HanLP;

@Controller
public class CategoryAdminController extends CmsController {
	
	@RequestMapping(path = {"CategoryAdmin", "CategoryAdmin/Index"}, method={RequestMethod.GET})
	public String Index(Model model) {
		List<Category> categories = categoryService.findAll();
		model.addAttribute("categories", categories);
		model.addAttribute("navigation", "CategoryAdmin");
		return "CategoryAdmin/Index";
	}
	
	@RequestMapping(path = {"CategoryAdmin/Save"}, method={RequestMethod.POST})
	@ResponseBody
	public Result Save(Category category) {
		if(category.getId() != null) {
			categoryService.update(category);		
		} else {
			category.setNameSC(HanLP.t2s(category.getNameTC()));
			categoryService.addCategory(category);
		}
		return new Result();
	}
	
	@RequestMapping(path = {"CategoryAdmin/Delete"}, method={RequestMethod.POST})
	@ResponseBody
	public Result Delete(Long id) {				
		categoryService.deleteById(id);		
		return new Result();
	}
	
	@RequestMapping(path = {"CategoryAdmin/ChgOrder"}, method={RequestMethod.POST})
	@ResponseBody
	public Result ChgOrder(Long id, Long beforeId) {				
		categoryService.chgOrder(id, beforeId);		
		return new Result();
	}
		
}
