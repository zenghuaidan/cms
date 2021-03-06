package com.edeas.controller.frontend;

import java.util.Enumeration;
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
			String langSeg = "/" + lang + "/";
			for(Page page : pages) {
				String url = request.getRequestURI();
				url = url.substring(url.indexOf(langSeg) + langSeg.length()).replace(".html", "");
				if(url.equals(page.getPageUrl())) {
					Page masterPage = queryService.getMasterPage(false);
					model.addAttribute("iscms", false);
					model.addAttribute("isPageAdmin", false);
					model.addAttribute("lang", lang);
					model.addAttribute("currentPage", page);
					model.addAttribute("masterPage", masterPage);
					Enumeration parameterNames = request.getParameterNames();
					while(parameterNames.hasMoreElements()) {
						String parameterName = (String)parameterNames.nextElement();
						model.addAttribute(parameterName, request.getParameter(parameterName));
					}
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
