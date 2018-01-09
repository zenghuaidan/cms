package com.edeas.controller.cmsadmin;

import java.text.ParseException;
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

import com.edeas.controller.Global;
import com.edeas.dto.Result;
import com.edeas.model.CmsPage;
import com.edeas.model.Page;
import com.edeas.utils.DateUtils;

@Controller
public class PageAdminController extends CmsController {
	@RequestMapping(path = {"PageAdmin/New"}, method={RequestMethod.GET})
	public String newPage(Model model, long parentid, HttpServletRequest request) {
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
	
	@RequestMapping(path = {"PageAdmin/Index"}, method={RequestMethod.GET})
	public String index(Model model, long id, String lang, HttpServletRequest request) {
		lang = StringUtils.isBlank(lang) ? CmsProperties.getDefaultLanguage() : lang;
		Page page;
		if(id == Page.HOME_PAGE_PARENT_ID || id == Page.MASTER_PAGE_PARENT_ID) {
			page = id == Page.HOME_PAGE_PARENT_ID ? queryService.getHomePage(true) : queryService.getMasterPage(true);
			if(page.isNew()) {
				CmsPage parent = new CmsPage();
				parent.setId(id);
				page.initNewPage(parent);
				page.setParent(parent);
				queryService.addOrUpdate(page, true);
			}
			id = page.getId();
		} else {
			page = queryService.findPageById(id, true);
		}
		
		if(page == null || page.isNew() || page.isDelete()) return "redirect:" + Global.getCMSURI() + "/SiteAdmin";
		
		model.addAttribute("lang", lang);
		model.addAttribute("isCms", true);
		model.addAttribute("currentPage", page);
		model.addAttribute("referAction", "PageAdmin");
		model.addAttribute("newatfront", false);
		return "PageAdmin/Index";
	}
	
	@ResponseBody
	@RequestMapping(path = {"PageAdmin/UrlRender"}, method={RequestMethod.GET})
	public String urlRender(long parentid, String txt) {
		return renderUrl(parentid, txt);
	}

	private String renderUrl(long parentid, String txt) {
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
	
	@ResponseBody
	@RequestMapping(path = {"PageAdmin/Save"}, method={RequestMethod.POST})
	public Result Save(HttpServletRequest request) throws ParseException {
		Long pageId = Long.parseLong(request.getParameter("pageid"));
		Page page = queryService.findPageById(pageId, true);
		if(loadConfigForm(page, request)) {
			queryService.addOrUpdate(page, true);
			return new Result("Congraduation! Page is saved successfully.");
		} else {
			
			return new Result("Failed", "Invalid config form. Some field empty?");
		}
	}
	
	 public boolean loadConfigForm(Page page, HttpServletRequest request) throws ParseException
     {
         boolean v = true;
         String template = request.getParameter("template");
         String name = request.getParameter("name");
         String url = request.getParameter("url");
         String namealg = request.getParameter("namealg");
         boolean isActive = !StringUtils.isBlank(request.getParameter("isActive"));
         Long parentId = Long.parseLong(request.getParameter("parentid"));
         boolean newAtFront = Boolean.parseBoolean(request.getParameter("newatfront"));
         String pageTimeFrom = request.getParameter("pgtimei");
         String pageTimeFromHour = request.getParameter("pgtimeihr");
         String pageTimeFromMinute = request.getParameter("pgtimeimin");
         
         String pageTimeTo = request.getParameter("pgtimef");
         String pageTimeToHour = request.getParameter("pgtimefhr");
         String pageTimeToMinute = request.getParameter("pgtimefmin");
         
         String pageTimeDisplay = request.getParameter("pgtimedisplay");
         
         String customPageOrder = request.getParameter("custompgorder");
         
         CmsPage parent = (CmsPage)queryService.findPageById(parentId, true);
         if(parent.isNew()) parent.setId(parentId);
         //check valid form
         if (StringUtils.isBlank(template) || ((StringUtils.isBlank(name) || StringUtils.isBlank(url)) && StringUtils.isBlank(namealg)))
         { v = false; }
         if (v)
         {
             if (page.isNew())  //if new page load new properties
             {
                 page.initNewPage(parent, newAtFront);
             } 
             page.setParent(parent);
             page.setName(name);
             page.setUrl(url);
             page.setActive(isActive);
             page.setTemplate(template);

             //pgtimei / pgtimef
             if (!StringUtils.isBlank(pageTimeFrom))
             {
                 boolean hasTime = !StringUtils.isBlank(pageTimeFromHour);
                 String dtstri = pageTimeFrom + " ";
                 dtstri += (hasTime) ? (pageTimeFromHour.length() == 2 ? pageTimeFromHour : "0" + pageTimeFromHour) + ":" + (pageTimeFromMinute.length() == 2 ? pageTimeFromMinute : "0" + pageTimeFromMinute) + ":01" : "00:00:01";
                 page.setPageTimeFrom(DateUtils.yyyyMMddHHmmss().parse(dtstri));
             }
             if (!StringUtils.isBlank(pageTimeTo))
             {
            	 boolean hasTime = !StringUtils.isBlank(pageTimeToHour);
            	 String dtstrf = pageTimeTo + " ";
                 dtstrf += (hasTime) ? (pageTimeToHour.length() == 2 ? pageTimeToHour : "0" + pageTimeToHour) + ":" + (pageTimeToMinute.length() == 2 ? pageTimeToMinute : "0" + pageTimeToMinute) + ":01" : "00:00:01";
                 page.setPageTimeTo(DateUtils.yyyyMMddHHmmss().parse(dtstrf));
             }
             page.setPageTimeDisplay((!StringUtils.isBlank(pageTimeDisplay)) ? pageTimeDisplay : "");

             //Try custom pg order
             if (!StringUtils.isBlank(customPageOrder))
             {	
            	 try {
            		 page.setPageOrder(Integer.parseInt(customPageOrder));            		 
            	 } catch (Exception e) {
				}
             }

             //Try auto name and url
             if (StringUtils.isBlank(page.getName()) && !StringUtils.isBlank(namealg))
             {
                 switch (namealg)
                 {
                     case "daterange":
                    	 page.setName(DateUtils.yyyyMMdd().format(page.getPageTimeFrom()) + "-" + DateUtils.yyyyMMdd().format(page.getPageTimeTo()));
                         break;
                     case "pgorder":
                         page.setName(page.getPageOrder() + "");
                         break;
                 }
                 page.setUrl(renderUrl(parentId, page.getName()));
             }
             //TODO: publish / expire
         }
         return v;
     }
}
