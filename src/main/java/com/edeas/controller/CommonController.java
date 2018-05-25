package com.edeas.controller;

import java.io.InputStream;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.IOUtils;
import org.apache.log4j.Logger;
import org.dom4j.Document;
import org.dom4j.Element;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.edeas.common.utils.MailUtils;
import com.edeas.controller.cmsadmin.CmsProperties;
import com.edeas.dto.Result;
import com.edeas.model.Content;
import com.edeas.model.Lang;
import com.edeas.model.Page;
import com.edeas.utils.XmlUtils;

@RequestMapping("/common")
@Controller
public class CommonController extends BaseController {	
	protected final Logger logger = Logger.getLogger(CommonController.class);
	
	@RequestMapping(path = {"timelineDetail"}, method={RequestMethod.GET}, produces ="text/plain; charset=UTF-8")
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
	
	@RequestMapping(path = {"form1"}, method={RequestMethod.POST})
	@ResponseBody
	public Result form1(String lang, HttpServletRequest request) {
		Map<String, List<String>> qMap = new HashMap<String, List<String>>();
		qMap.put("en", Arrays.asList("What's your favorite movie?", "Where do you live?", "What time do you got to work?", "How do you like your veggies?", "What book inspires you?", "What's your profession?"));
		qMap.put("tc", Arrays.asList("你最喜歡哪部電影?", "你居住在何處?", "你的工作時間是什麼?", "你如何看待素食主義者", "什麼書最能激勵你?", "你最擅長那個方面?"));
		qMap.put("sc", Arrays.asList("你最喜欢哪部电影?", "你居住在何处?", "你的工作时间是什麽?", "你如何看待素食主义者", "什麽书最能激励你?", "你最擅长那个方面?"));
		
		String subject = lang.equals("en") ? "Simplistic, single input view form" : (lang.equals("tc") ? "簡單美觀輸入框" : "简单美观输入框");
		
		Enumeration parameterNames = request.getParameterNames();
		List<String> sortedParameterNames = new ArrayList<String>();		
		while(parameterNames.hasMoreElements()) {
			String parameterName = (String)parameterNames.nextElement();
			if ("lang".equals(parameterName)) continue;
			sortedParameterNames.add(parameterName);			
		}
		Collections.sort(sortedParameterNames);
		StringBuilder emailContentStr = new StringBuilder("<html><body><h3>" + subject + "</h3><br />");
		for(int i = 0; i < sortedParameterNames.size() - 1; i++) {
			emailContentStr.append("<br />" + qMap.get(lang).get(i) + "<ul><li><font color='#BA2946'>" + request.getParameter(sortedParameterNames.get(i)) + "</font></li></ul>");
		}
		emailContentStr.append("</body></html>");
					
		String email = request.getParameter(sortedParameterNames.get(sortedParameterNames.size() - 1));
		MailUtils.sendmail(email, email, "Simplistic, single input view form", emailContentStr.toString(), false, true);			

		return new Result();		
	}
	
	@RequestMapping(path = {"form2"}, method={RequestMethod.POST})
	@ResponseBody
	public Result form2(String lang, String name, String email, String food, String restaurant, String time, String location) {		
		
		String subject = lang.equals("en") ? "Simplistic, single input view form" : (lang.equals("tc") ? "簡單美觀輸入框" : "简单美观输入框");		
		String emailContentStr = lang.equals("en") ? ("<html><body><h3>" + subject + "</h3><br />"
				+ "I feel to eat <font color='#BA2946'>" + food + "</font> <br/>"
				+ "in a <font color='#BA2946'>" + restaurant + "</font> restaurant <br/>"
				+ "at <font color='#BA2946'>" + time + "</font> in <font color='#BA2946'>" + location + "</font> <br/>"
				+ "</body></html>") : (
						lang.equals("tc") ? ("<html><body><h3>" + subject + "</h3><br />"
								+ "我想吃  <font color='#BA2946'>" + food + "</font> <br/>"
								+ "在一間 <font color='#BA2946'>" + restaurant + "</font> 餐廳<br/>"
								+ "時間是 <font color='#BA2946'>" + time + "</font> 位置在 <font color='#BA2946'>" + location + "</font> <br/>"
								+ "</body></html>") : 
									("<html><body><h3>" + subject + "</h3><br />"
										+ "我想吃 <font color='#BA2946'>" + food + "</font> <br/>"
										+ "在一间 <font color='#BA2946'>" + restaurant + "</font> 餐厅<br/>"
										+ "时间是 <font color='#BA2946'>" + time + "</font> 位置在<font color='#BA2946'>" + location + "</font> <br/>"
										+ "</body></html>")
				);
		MailUtils.sendmail(name, email,  "Simplistic, single input view form", emailContentStr, false, true);	
		
		return new Result();		
	}
}
