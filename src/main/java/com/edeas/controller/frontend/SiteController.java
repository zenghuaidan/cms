package com.edeas.controller.frontend;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FilenameUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.edeas.controller.cmsadmin.CmsProperties;
import com.edeas.model.Lang;
import com.edeas.model.Page;
import com.edeas.web.InitServlet;

@Controller
public class SiteController extends FrontController {
	
	@RequestMapping(path = {"{lang}/**/**.html"}, method={RequestMethod.GET})
	public String viewPage(Model model, @PathVariable("lang") String lang, HttpServletRequest request) {
		if(!Lang.exists(lang)) {
			return "redirect:/";
		}
		String webpath = request.getRequestURL().toString();
		String pageUrl = FilenameUtils.getBaseName(webpath);
		List<Page> pages = queryService.findPageByUrl(pageUrl, false, true);
		if(pages.size() > 0) {
			for(Page page : pages) {
				String url = request.getRequestURI().replaceAll(InitServlet.getWc().getServletContext().getContextPath(), "").replaceAll("/" + lang + "/", "").replaceAll(".html", "");
				if(url.equals(page.getPageUrlForRouteMap())) {
					model.addAttribute("iscms", false);
					model.addAttribute("lang", lang);
					model.addAttribute("currentPage", page);
					return "Templates/" + page.getTemplate();
				}
			}
		}
		return "redirect:/PageNotFound";
	}	
	
	@RequestMapping(path = {""}, method={RequestMethod.GET})
	public String index() {
		return "redirect:/" + CmsProperties.getDefaultLanguage() + "/index.html";		
	}	
	
	@RequestMapping(path = {"PageNotFound"}, method={RequestMethod.GET})
	public String pageNotFound() {
		return "404";		
	}
	
	@RequestMapping(path = {"/test"}, method={RequestMethod.GET})
	public String test() {
		return "test";		
	}	
}
