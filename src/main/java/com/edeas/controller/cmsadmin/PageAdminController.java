package com.edeas.controller.cmsadmin;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.edeas.model.CmsPage;
import com.edeas.model.Page;

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
	
	@ResponseBody
	@RequestMapping(path = {"PageAdmin/UrlRender"}, method={RequestMethod.GET})
	public String urlRender(long parentid, String txt) {
		if (StringUtils.isBlank(txt))
			return "";
        StringBuilder sb = new StringBuilder("");
        txt = txt.trim();
        String[] words = txt.split(" ");
        for (String w : words)
        {
            String s = w.toLowerCase();
            s = s.substring(0, 1).toUpperCase() + s.substring(1);
            if (sb.length() > 0) s = "-" + s;
            sb.append(s);
        }
        String u = sb.toString(); 
        int i = 1;
        List<Page> pages = queryService.findPagesByParentId(parentid, true);
        List<String> urls = new ArrayList<String>();
        for(Page page : pages) {
        	urls.add(page.getUrl());
        }
        while (urls.contains(u))
            u = sb.append("-").append(i + "").toString();
        return u;
	}	
}
