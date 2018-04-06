package com.edeas.controller;

import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.dom4j.Document;
import org.dom4j.Element;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.edeas.model.Content;
import com.edeas.model.Lang;
import com.edeas.model.Page;
import com.edeas.utils.XmlUtils;

@RequestMapping("/common")
@Controller
public class CommonController extends BaseController {	
	protected final Logger logger = Logger.getLogger(CommonController.class);
	
	@RequestMapping(path = {"timelineDetail"}, method={RequestMethod.GET})
	@ResponseBody
	public String timelineDetail(long pageId, String timelineId, String lang, boolean iscms, HttpSession session) {
		if(!Lang.exists(lang))
			return "";
		
		Page page = queryService.findPageById(pageId, iscms);
		Content content = page.getContent(lang);
		
		Document contentDocument = content.getContentXmlDoc();
		
		Element element = (Element)contentDocument.selectSingleNode("/PageContent/Widget[@name='HorizontalTimelineBlks']/Widget[@id='" + timelineId + "']");
		String detailContent = XmlUtils.getFieldRaw(element, "Detail", true);
		String detailTitle = XmlUtils.getFieldRaw(element, "DetailTitle", false);
		
		String result = "<div class='timeline_open_content'><h2 class='no-marg-top'>" + detailTitle + "</h2><span>" + detailContent + "</span></div>";
		
		return result;		
	}
}
