package com.edeas.controller.cmsadmin;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.edeas.model.CmsPage;

@Controller
public class PageAdminController extends CmsController {
	@RequestMapping(path = {"PageAdmin/New"}, method={RequestMethod.GET})
	public String index(Model model, long parentid, HttpServletRequest request) {
		CmsPage parentPage = parentid <= 0 ? null : (CmsPage)queryService.findPageById(parentid, true);
		CmsPage page = new CmsPage();
		page.setParent(parentPage);
		page.setPageTimeFrom(new Date());
		page.setPageTimeTo(new Date());
		model.addAttribute("currentPage", page);
		model.addAttribute("parentPage", parentPage);
		model.addAttribute("parentid", parentid);
		model.addAttribute("newatfront", false);
		return "PageAdmin/ConfigForm";
	}	
}
