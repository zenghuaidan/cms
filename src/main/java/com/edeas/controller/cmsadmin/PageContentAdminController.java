package com.edeas.controller.cmsadmin;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.dom.DOMElement;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

import com.edeas.common.utils.ExcelUtils;
import com.edeas.common.utils.ImageUtils;
import com.edeas.common.utils.ZipUtils;
import com.edeas.controller.Global;
import com.edeas.dto.ImageInfo;
import com.edeas.dto.Result;
import com.edeas.dwr.SchemaInfo;
import com.edeas.model.CmsContent;
import com.edeas.model.Content;
import com.edeas.model.Lang;
import com.edeas.model.Page;
import com.edeas.utils.XmlUtils;
import com.hankcs.hanlp.HanLP;

@Controller
@SuppressWarnings({"rawtypes", "unchecked"})
public class PageContentAdminController extends CmsController {	
	
	@RequestMapping(path = {"PageContentAdmin/MceImgUpload"}, method={RequestMethod.POST})
	@ResponseBody
    public String mceImgUpload(String iname, HttpServletRequest request, HttpServletResponse response) throws IllegalStateException, IOException
    {
		String imgurl = "";
        CommonsMultipartResolver multipartResolver=new CommonsMultipartResolver(request.getSession().getServletContext());
        if(multipartResolver.isMultipart(request))
        {
        	String fname = "filedata";
            MultipartHttpServletRequest multiRequest=(MultipartHttpServletRequest)request;
			if(multiRequest.getMultiFileMap().containsKey(fname)) {
				List<MultipartFile> list = multiRequest.getMultiFileMap().get(fname);
				if (list.size() == 1 && !StringUtils.isBlank(list.get(0).getOriginalFilename())) {
					String orgfil = list.get(0).getOriginalFilename();										
					String newFileName = newRandomFilename(Global.getImagesUploadPhysicalPath(Global.IMAGE_EDITOR), orgfil);	
					list.get(0).transferTo(new File(Global.getImagesUploadPhysicalPath(Global.IMAGE_EDITOR, newFileName)));															
					imgurl = Global.getImagesUploadPath(Global.IMAGE_EDITOR, newFileName);
				}
            }            
        }
		return imgurl;
    }

	@RequestMapping(path = {"PageContentAdmin/MceDocUpload"}, method={RequestMethod.POST})
	@ResponseBody
    public String mceDocUpload(String iname, HttpServletRequest request, HttpServletResponse response) throws IllegalStateException, IOException
    {
		String docurl = "";
        CommonsMultipartResolver multipartResolver=new CommonsMultipartResolver(request.getSession().getServletContext());
        if(multipartResolver.isMultipart(request))
        {
        	String fname = "filedata";
            MultipartHttpServletRequest multiRequest=(MultipartHttpServletRequest)request;
			if(multiRequest.getMultiFileMap().containsKey(fname)) {
				List<MultipartFile> list = multiRequest.getMultiFileMap().get(fname);
				if (list.size() == 1 && !StringUtils.isBlank(list.get(0).getOriginalFilename())) {
					String orgfil = list.get(0).getOriginalFilename();										
					String newFileName = newRandomFilename(Global.getDocUploadPhysicalPath(), orgfil);	
					list.get(0).transferTo(new File(Global.getDocUploadPhysicalPath(newFileName)));															
					docurl = Global.getDocUploadPath(newFileName);
				}
            }            
        }
		return docurl;
    }
	
	@RequestMapping(path = {"PageContentAdmin/TinyMceUpFrame"}, method={RequestMethod.GET})
	public String tinyMceUpFrame(String wtype, String iname, HttpServletResponse response, Model model) throws IOException {		
		model.addAttribute("aurl", Global.getCMSUrl() + "/PageContentAdmin" + (wtype.equals("webimage") ? "/MceImgUpload" : "/MceDocUpload"));
		model.addAttribute("iname", iname);
		return "PageContentAdmin/TinyMceUpFrame";
	}
	
	@ResponseBody
	@RequestMapping(path = {"PageContentAdmin/MovWidgetDown"}, method={RequestMethod.GET})
	public Result movWidgetDown(int pgid, String lang, String xid, HttpServletRequest request) throws ParseException {
		Page page = queryService.findPageById(pgid, true);
		if (page.isNew()) {
			return new Result("Failed", "Can not find this page=" + pgid + " to apply content with");
		}
		if (!Lang.exists(lang)) {
			return new Result("Failed", "Invalidate language");
		}
		
		Content content = page.getContent(lang);
		if (content == null || content.isNew()) {
			return new Result("Failed", "Widget not existis");
		}

		Document contentDocument = content.getContentXmlDoc();
		Element moven = (Element)contentDocument.selectSingleNode("//Widget[@id='" + xid + "']");
		if(moven != null) {
			Element parent = moven.getParent();
			List<Element> elements = parent.elements();
			int index = 0;
			for(Element element : elements) {
				if(element.attributeValue("id").equals(xid)) {
					break;
				}
				index++;
			}
			if(index < elements.size() - 1) {
				Element clonen = (Element)moven.clone();			
				parent.remove(moven);
				elements.add(index + 2, clonen);
			}
		}
		
		content.setContentXml(XmlUtils.formatXml(contentDocument));
		queryService.addOrUpdate(content, true);
		return new Result();
	}
	
	@ResponseBody
	@RequestMapping(path = {"PageContentAdmin/MovWidgetUp"}, method={RequestMethod.GET})
	public Result movWidgetUp(int pgid, String lang, String xid, HttpServletRequest request) throws ParseException {
		Page page = queryService.findPageById(pgid, true);
		if (page.isNew()) {
			return new Result("Failed", "Can not find this page=" + pgid + " to apply content with");
		}
		if (!Lang.exists(lang)) {
			return new Result("Failed", "Invalidate language");
		}
		
		Content content = page.getContent(lang);
		if (content == null || content.isNew()) {
			return new Result("Failed", "Widget not existis");
		}

		Document contentDocument = content.getContentXmlDoc();
		Element moven = (Element)contentDocument.selectSingleNode("//Widget[@id='" + xid + "']");
		if(moven != null) {
			Element parent = moven.getParent();
			List<Element> elements = parent.elements();
			int index = 0;
			for(Element element : elements) {
				if(element.attributeValue("id").equals(xid)) {
					break;
				}
				index++;
			}
			if(index > 0) {
				Element clonen = (Element)moven.clone();			
				parent.remove(moven);
				elements.add(index - 1, clonen);
			}
		}
		
		content.setContentXml(XmlUtils.formatXml(contentDocument));
		queryService.addOrUpdate(content, true);
		return new Result();
	}
	
	@ResponseBody
	@RequestMapping(path = {"PageContentAdmin/ChangeWidgetOrder"}, method={RequestMethod.GET})
	public Result changeWidgetOrder(int pgid, String lang, String xid, String beforeid, HttpServletRequest request) throws ParseException {
		Page page = queryService.findPageById(pgid, true);
		if (page.isNew()) {
			return new Result("Failed", "Can not find this page=" + pgid + " to apply content with");
		}
		if (!Lang.exists(lang)) {
			return new Result("Failed", "Invalidate language");
		}
		
		Content content = page.getContent(lang);
		if (content == null || content.isNew()) {
			return new Result("Failed", "Widget not existis");
		}

		Document contentDocument = content.getContentXmlDoc();
		Element moven = (Element)contentDocument.selectSingleNode("//Widget[@id='" + xid + "']");
		Element beforen = (Element)contentDocument.selectSingleNode("//Widget[@id='" + beforeid + "']");
		if(moven != null) {
			Element parent = moven.getParent();
			Element clonen = (Element)moven.clone();
			parent.remove(moven);
			if (beforen == null) {
				parent.add(clonen);
			} else {
				List<Element> elements = parent.elements();
				int index = 0;
				for(Element element : elements) {
					if(element.attributeValue("id").equals(beforeid)) {
						elements.add(index, clonen);
						break;
					}
					index++;
				}
			}
		}
		
		content.setContentXml(XmlUtils.formatXml(contentDocument));
		queryService.addOrUpdate(content, true);
		return new Result();
	}
	
	@ResponseBody
	@RequestMapping(path = {"PageContentAdmin/DeleteWidget"}, method={RequestMethod.GET})
	public Result deleteWidget(int pgid, String lang, String xid, HttpServletRequest request) throws ParseException {
		Page page = queryService.findPageById(pgid, true);
		if (page.isNew()) {
			return new Result("Failed", "Can not find this page=" + pgid + " to apply content with");
		}
		if (!Lang.exists(lang)) {
			return new Result("Failed", "Invalidate language");
		}
		
		Content content = page.getContent(lang);
		if (content == null || content.isNew()) {
			return new Result("Failed", "Widget not existis");
		}

		Document contentDocument = content.getContentXmlDoc();
		Element widget = (Element)contentDocument.selectSingleNode("//Widget[@id='" + xid + "']");
		if(widget != null) widget.getParent().remove(widget);
		content.setContentXml(XmlUtils.formatXml(contentDocument));
		queryService.addOrUpdate(content, true);
		return new Result();
	}
	
	@ResponseBody
	@RequestMapping(path = {"PageContentAdmin/GetOrNewWidgetXid"}, method={RequestMethod.GET})
	public Result getOrNewWidgetXid(int pageid, String lang, String wname, String wid, String pwxid, HttpServletRequest request) throws ParseException {
		Page page = queryService.findPageById(pageid, true);
		if (page.isNew()) {
			return new Result("Failed", "Can not find this page=" + pageid + " to apply content with");
		}
		if (!Lang.exists(lang)) {
			return new Result("Failed", "Invalidate language");
		}
		
		Content content = page.getContent(lang);
		if (content == null || content.isNew()) {
			content = new CmsContent();
			content.init(page, Lang.getByName(lang));
			page.getContents().add(content);
		}
		Document contentDocument = content.getContentXmlDoc();
		Element parentNode = (StringUtils.isBlank(pwxid)) ? (Element)contentDocument.selectSingleNode("/PageContent") : (Element)contentDocument.selectSingleNode("//Widget[@id='" + pwxid + "']");
		Element widgetNode = (Element)parentNode.selectSingleNode("Widget[@name='" + wname + "' and @wid='" + wid + "']");
		String wxid = "";
		if (widgetNode == null) {
			widgetNode = new DOMElement("Widget");
			wxid = createWidgetNode(contentDocument, parentNode, widgetNode, wid, wname, "", false);
			content.setContentXml(XmlUtils.formatXml(contentDocument));
			queryService.addOrUpdate(page, true);
		} else {
			wxid = XmlUtils.getFieldAttr(widgetNode, "id");
		}
		return new Result(wxid);
	}
	
	@RequestMapping(path = {"PageContentAdmin/WListMgr"}, method={RequestMethod.GET})
	public String widgetListMgr(Model model, long pageid, String lang, String mgrname, String mgrtype, String mgrattr, String mgrxid, HttpServletRequest request) throws ParseException {
		if (Lang.exists(lang)) {
			Page currentPage = queryService.findPageById(pageid, true);
			if (!currentPage.isNew()) {
				model.addAttribute("pageid", pageid);
				model.addAttribute("lang", lang);
				model.addAttribute("mgrname", mgrname);
				model.addAttribute("mgrtype", mgrtype);
				model.addAttribute("mgrattr", mgrattr);
				model.addAttribute("mgrxid", mgrxid);
				model.addAttribute("currentPage", currentPage);			
				return "PageContentAdmin/WidgetListMgr";
			}
		}
		return "404";
	}
	
	@RequestMapping(path = {"PageContentAdmin/WidgetForm"}, method={RequestMethod.GET})
	public String widgetForm(Model model, long pageid, String lang, String wid, String wname, String wxid, String parentxid, String caller, String iszipupload,  HttpServletRequest request) throws ParseException {
		if (Lang.exists(lang)) {
			Page currentPage = queryService.findPageById(pageid, true);
			if (!currentPage.isNew()) {
				model.addAttribute("lang", lang);
				model.addAttribute("wid", wid);
				model.addAttribute("wname", wname);
				model.addAttribute("wxid", wxid);
				model.addAttribute("parentxid", parentxid);
				model.addAttribute("caller", caller);
				model.addAttribute("iszipupload", iszipupload);
				model.addAttribute("currentPage", currentPage);			
				return "PageContentAdmin/WidgetForm";
			}
		}
		return "404";
	}
	
	@RequestMapping(path = {"PageContentAdmin/UpdateWidget"}, method={RequestMethod.POST})
	@ResponseBody
	public String updateWidget(HttpServletResponse response, HttpServletRequest request) throws Exception {
		boolean isZipUpload = "yes".equals(request.getParameter("isZipUpload"));
		if(isZipUpload) {
			StringBuffer error = new StringBuffer();
	        CommonsMultipartResolver multipartResolver=new CommonsMultipartResolver(request.getSession().getServletContext());
	        if(multipartResolver.isMultipart(request))
	        {
	        	String fname = "image_zip_upload_file";
	            MultipartHttpServletRequest multiRequest=(MultipartHttpServletRequest)request;
				if(multiRequest.getMultiFileMap().containsKey(fname)) {
					List<MultipartFile> list = multiRequest.getMultiFileMap().get(fname);
					if (list.size() == 1 && !StringUtils.isBlank(list.get(0).getOriginalFilename())) {						
						String originalFilename = list.get(0).getOriginalFilename();
						if("zip".equals(FilenameUtils.getExtension(originalFilename).toLowerCase())) {							
							String zipPath = Global.getImagesZipUploadPhysicalPath();
							File zipPathFile = new File(zipPath);
							FileUtils.deleteQuietly(zipPathFile);
							zipPathFile.mkdirs();							
							
							String zipFileName = FilenameUtils.concat(zipPath, originalFilename);
							File zipFile = new File(zipFileName);
							list.get(0).transferTo(zipFile);
							
							ZipUtils.unzipFile(zipFileName);
							
							Map<String, File> imageDataMap = new HashMap<String, File>();
							Collection<File> images = FileUtils.listFiles(zipPathFile, new String[] {"bmp", "jpg", "jpeg", "png", "gif"}, true);
							for(File image : images) {
								imageDataMap.put(FilenameUtils.getBaseName(image.getName()), image);
							}
							
							Collection<File> xlsFiles = FileUtils.listFiles(zipPathFile, new String[] {"xls", "xlsx", "xlsm"}, true);
							for(File xls : xlsFiles) {
								ArrayList<ArrayList<ArrayList<Object>>> imageData = ExcelUtils.readExcel(xls);
								for(ArrayList<Object> item : imageData.get(0)) {
									String imageName = item.size() > 0 ? item.get(0).toString() : "";
									String alt = item.size() > 1 ? item.get(1).toString() : "";
									String caption = item.size() > 2 ? item.get(2).toString() : "";
									if (imageDataMap.containsKey(imageName)) {										
										ImageInfo imageInfo = new ImageInfo(imageDataMap.get(imageName), alt, caption);
										error.append(updateWidget(multiRequest, imageInfo));										
									}
								}
							}
							
							
							FileUtils.deleteQuietly(zipPathFile);
						}

					}
	            }   				
	        }
	        return "";
		} else {
			return updateWidget(request, null);			
		}
	}

	private String updateWidget(HttpServletRequest request, ImageInfo imageInfo) {
		StringBuffer error = new StringBuffer();
		Long pageId = Long.parseLong(request.getParameter("pageid"));
		String lang = request.getParameter("lang");
		String wname = request.getParameter("wname");
		String wid = request.getParameter("wid");
		String wxid = request.getParameter("wxid");
		String parentxid = request.getParameter("parentxid");
		String caller = request.getParameter("caller");
		Page page = queryService.findPageById(pageId, true);
		Content content = page.getContent(lang);
		if(content == null || content.isNew()) {
			content = new CmsContent();
			content.init(page, Lang.getByName(lang));
			page.getContents().add(content);
		}
		if (!page.isNew()) {
			Document contentDocument = content.getContentXmlDoc();
			Document tempateDocument = XmlUtils.getTemplateDocument(page.getTemplate());
			Document widgetListDocument = XmlUtils.getWidgetListDocument();
			Element widgetDefine = (Element)widgetListDocument.selectSingleNode("//Widget[@id='" + wid + "']");
			Element templateDefine = (Element)tempateDocument.selectSingleNode("//Widget[@ename='" + wname + "']");
			if(templateDefine == null) templateDefine = (Element)tempateDocument.selectSingleNode("//AcceptWidget[@ename='" + wname + "']");
			boolean addToFront = "yes".equals(XmlUtils.getFieldAttr(templateDefine, "AddFront").toLowerCase());
			Element widgetNode = (Element)contentDocument.selectSingleNode("//Widget[@id='" + wxid + "']");
			if (widgetNode == null) {
				Element parentNode = StringUtils.isBlank(parentxid) ? null : (Element)contentDocument.selectSingleNode("//Widget[@id='" + parentxid + "']");
				if (parentNode == null) {
					parentNode = (Element)contentDocument.selectSingleNode("/PageContent");
				}
				widgetNode = new DOMElement("Widget");
				wxid = createWidgetNode(contentDocument, parentNode, widgetNode, wid, wname, wxid, addToFront);
			}
			List<Element> fields = (List<Element>)widgetDefine.selectNodes("Field");
			for(Element field : fields) {
				SchemaInfo fpm = XmlUtils.getSchemaInfo(field, templateDefine);
				Element dataField = (Element)widgetNode.selectSingleNode("Field[@name='" + fpm.getName() + "']");
				String value = request.getParameter(fpm.getName());
				value = value == null ? "" : value;
				if (Lang.en.equals(Lang.getByName(lang))) value = value.replaceAll("<br /><br />", "<br />&nbsp;<br />");
				if (dataField == null) {
					dataField = widgetNode.addElement("Field");
					int i = 1;
                    while (contentDocument.selectSingleNode("//*[@id='" + wxid + "-" + fpm.getName() + "-" + i + "']") != null) i++;
                    String fxid = wxid + "-" + fpm.getName() + "-" + i;
                    dataField.addAttribute("id", fxid);
				}
				Enumeration parameterNames = request.getParameterNames();
				while(parameterNames.hasMoreElements()) {
					String parameterName = (String)parameterNames.nextElement();
					if (parameterName.startsWith(fpm.getName() + "_") && parameterName.split("_", 2).length == 2 && !StringUtils.isBlank(parameterName.split("_", 2)[1])) {
						String key = parameterName.split("_", 2)[1];
						dataField.addAttribute(key, request.getParameter(parameterName));
					}
				}
				dataField.addAttribute("name", fpm.getName());
				dataField.addAttribute("ftype", fpm.getType());
				dataField.setText(XmlUtils.toCDATA(value));
				error.append(setSpecialField(fpm, dataField, request, imageInfo));
			}
			if(StringUtils.isBlank(error.toString())) {
				content.setContentXml(XmlUtils.formatXml(contentDocument));
				queryService.addOrUpdate(page, true);
			}
		}
		return error.toString();
	}
	
	private String createWidgetNode(Document contentDocument, Element parentNode, Element widgetNode, String wid, String wname, String wxid, boolean addToFront)
    {
        int i = 1;
        while (contentDocument.selectSingleNode("//*[@id='" + wname + "-" + i + "']") != null) i++;
        wxid = wname + "-" + i;
        widgetNode.addAttribute("name", wname);
        widgetNode.addAttribute("id", wxid);
        widgetNode.addAttribute("wid", wid);
        List<Element> children = parentNode.elements();
        if (addToFront && !children.isEmpty()) {
            children.add(0, widgetNode);
        } else {
        	children.add(widgetNode);
        }
        return wxid;
    }
	
	@ResponseBody
	@RequestMapping(path = {"PageContentAdmin/ApplyLang"}, method={RequestMethod.GET})
	public Result applyLang(int pageid, String pglang, String applylang, HttpServletRequest request) throws ParseException {
		Page page = queryService.findPageById(pageid, true);
		if (page.isNew()) {
			return new Result("Failed", "Can not find this page=" + pageid + " to apply content with");
		}
		if (!Lang.exists(pglang) || !Lang.exists(applylang)) {
			return new Result("Failed", "Invalidate language");
		}
		Lang applyLang = Lang.getByName(applylang);
		Lang pageLang = Lang.getByName(pglang);
		Content applyLangContent = page.getContent(applyLang);
		if (applyLangContent != null && (!StringUtils.isBlank(applyLangContent.getPropertyXml()) || !StringUtils.isBlank(applyLangContent.getContentXml()))) {
			String propertyXml = applyLangContent.getPropertyXml();
			String contentXml = applyLangContent.getContentXml();
			Content content = page.getContent(pageLang);
			if(content == null || content.isNew()) {
				content = new CmsContent();
				content.setLang(pageLang);
				content.setPage(page);
				page.getContents().add(content);
			}
			if (applyLang.equals(Lang.tc) && pageLang.equals(Lang.sc)) {
				propertyXml = HanLP.t2s(propertyXml);
				contentXml = HanLP.t2s(contentXml);
			}
			if (applyLang.equals(Lang.sc) && pageLang.equals(Lang.tc)) {
				propertyXml = HanLP.s2t(propertyXml);
				contentXml = HanLP.s2t(contentXml);
			}
			
			if(!StringUtils.isBlank(propertyXml)) {
				Document propertyDocument = XmlUtils.loadFromString(propertyXml);
				Element element = (Element)propertyDocument.selectSingleNode("/Properties");
				if(element != null) {
					element.addAttribute("lang", pageLang.getName());
					propertyXml = XmlUtils.formatXml(propertyDocument);
				}
			}
			
			if(!StringUtils.isBlank(contentXml)) {
				Document contentDocument = XmlUtils.loadFromString(contentXml);
				Element element = (Element)contentDocument.selectSingleNode("/PageContent");
				if(element != null) {
					element.addAttribute("lang", pageLang.getName());
					contentXml = XmlUtils.formatXml(contentDocument);
				}
			}
			
			content.setPropertyXml(propertyXml);
			content.setContentXml(contentXml);
			queryService.addOrUpdate(page, true);
		}
		return new Result();
	}
	
	@ResponseBody
	@RequestMapping(path = {"PageContentAdmin/UpdateProperty"}, method={RequestMethod.POST})
	public Result updateProperty(HttpServletRequest request) throws ParseException {
		Long pageId = Long.parseLong(request.getParameter("pageid"));
		String lang = request.getParameter("lang");
		Page page = queryService.findPageById(pageId, true);
		if(!page.isNew() && Lang.exists(lang)) {
			String errors = updateProperty(page, Lang.getByName(lang), request);
			if (StringUtils.isBlank(errors)) {				
				return new Result("Congraduation! Page is saved successfully.");				
			} else {
				return new Result("Failed", errors);
			}
		} else {
			return new Result("Failed", "Invalid config form. Invalidate page id or empty lang?");
		}
	}
	
	private String updateProperty(Page page, Lang lang, HttpServletRequest request) {
		StringBuffer errors = new StringBuffer();
		Content content = (Content)page.getContent(lang);
		Document template = XmlUtils.getTemplateDocument(page.getTemplate());
		List<Element> fieldList = template.selectNodes("/Template/Properties/Field");
		if (content == null || content.isNew()) {
			content = new CmsContent();
			content.init(page, lang);
			page.getContents().add(content);
		}
		
		Document propDocument = content.getPropertyXmlDoc();
		Element propDataXml = (Element)propDocument.selectSingleNode("/Properties");
		for(Element field : fieldList) {
			SchemaInfo fpm = XmlUtils.getSchemaInfo(field, null);
			
			Element dataField = (Element)propDataXml.selectSingleNode("Field[@name='" + fpm.getName() + "']");
			String value = request.getParameter(fpm.getName());
			if(lang.equals("en")) value = value.replaceAll("<br /><br />", "<br />&nbsp;<br />");
			if(dataField == null) {			
				dataField = propDataXml.addElement("Field");
				int i = 1;
				while (propDataXml.selectSingleNode("//*[@id='" + fpm.getName() + "-" + i + "']") != null) { i++; }
				String fxid = fpm.getName() + "-" + i;
				dataField.addAttribute("id", fxid);
			}
			Enumeration parameterNames = request.getParameterNames();
			while(parameterNames.hasMoreElements()) {
				String parameterName = (String)parameterNames.nextElement();
				if (parameterName.startsWith(fpm.getName() + "_") && parameterName.split("_", 2).length == 2 && StringUtils.isBlank(parameterName.split("_", 2)[1])) {
					String key = parameterName.split("_", 2)[1];
					dataField.addAttribute(key, request.getParameter(parameterName));
				}
			}
			dataField.addAttribute("name", fpm.getName());
			dataField.addAttribute("ftype", fpm.getType());
			dataField.setText(XmlUtils.toCDATA(value));
			errors.append(setSpecialField(fpm, dataField, request, null) + System.lineSeparator());
		}
		if (StringUtils.isBlank(errors.toString())) {
			content.setPropertyXml(XmlUtils.formatXml(propDocument));		
			queryService.addOrUpdate(page, true);
		}
		return errors.toString().trim();
	}
	
	private String setSpecialField(SchemaInfo fpm, Element dataField, HttpServletRequest request, ImageInfo imageInfo)
	{
		String err = "";
		switch (fpm.getType())
		{
			case "imgfield": err = setImageElement(fpm, dataField, request, imageInfo); break;
			case "lnkfield": err = setLinkElement(fpm, dataField, request); break;
			case "docfield": setDocElement(fpm, dataField, request); break;
			case "spgfield": setSubpageElement(fpm, dataField, request); break;
			default: break;
		}
		return err;
	}
	
	private void setSubpageElement(SchemaInfo fpm, Element dataField, HttpServletRequest request) { 
        String fid = fpm.getName();
        int selpgid = 0;
        try {
        	selpgid = Integer.parseInt(request.getParameter(fid));
        } catch (Exception e) {
		}
        Page page = queryService.findPageById(selpgid, true);        
        dataField.setText(XmlUtils.toCDATA(page.getName()));
        dataField.addAttribute("pgid", selpgid + "");
	}
	
	private String setDocElement(SchemaInfo fpm, Element dataField, HttpServletRequest request) {
		try {
			String fid = fpm.getName();
			String fname = fid + "_file";
			CommonsMultipartResolver multipartResolver=new CommonsMultipartResolver(request.getSession().getServletContext());
			if(multipartResolver.isMultipart(request))
			{
				MultipartHttpServletRequest multiRequest=(MultipartHttpServletRequest)request;
				if(multiRequest.getMultiFileMap().containsKey(fname)) {
					List<MultipartFile> list = multiRequest.getMultiFileMap().get(fname);
					if(!StringUtils.isBlank(list.get(0).getOriginalFilename())) {
						String newFileName = newRandomFilename(Global.getDocUploadPhysicalPath(), list.get(0).getOriginalFilename());	
						String size = (int)(list.get(0).getSize() / 1024) + "";
						list.get(0).transferTo(new File(Global.getDocUploadPhysicalPath(newFileName)));
						dataField.setText(XmlUtils.toCDATA(newFileName));
						dataField.addAttribute("size", size);
					}
				}
			}
		} catch (Exception e) {
			return e.getMessage();
		}
		return "";
	}
	
	private String setLinkElement(SchemaInfo fpm, Element dataField, HttpServletRequest request) {
		try {
			String fid = fpm.getName();
			String lnktype = request.getParameter(fid + "_type");
			dataField.addAttribute("lnktype", lnktype);
			dataField.addAttribute("target", request.getParameter(fid + "_target"));
			dataField.addAttribute("anchor", request.getParameter(fid + "_anchor"));
			switch (lnktype)
			{
			case "internal": dataField.setText(XmlUtils.toCDATA(request.getParameter(fid + "_internal_page"))); break;
			case "external": dataField.setText(XmlUtils.toCDATA(request.getParameter(fid + "_external_link"))); break;
			case "document":
				String fname = fid + "_document_link";
				CommonsMultipartResolver multipartResolver=new CommonsMultipartResolver(request.getSession().getServletContext());
				if(multipartResolver.isMultipart(request))
				{
					MultipartHttpServletRequest multiRequest=(MultipartHttpServletRequest)request;
					if(multiRequest.getMultiFileMap().containsKey(fname)) {
						List<MultipartFile> list = multiRequest.getMultiFileMap().get(fname);
						String newFileName = newRandomFilename(Global.getDocUploadPhysicalPath(), list.get(0).getOriginalFilename());	
						String size = (int)(list.get(0).getSize() / 1024) + "";
						list.get(0).transferTo(new File(Global.getDocUploadPhysicalPath(newFileName)));
						dataField.setText(XmlUtils.toCDATA(newFileName));
						dataField.addAttribute("size", size);
					}
				}                
				break;
			}
		} catch (Exception e) {
			return e.getMessage();
		}
		return "";
	}
	
    public static String newRandomFilename(String savepath, String filename)
    {
        String name = FilenameUtils.getBaseName(filename);
        String ext = FilenameUtils.getExtension(filename); //include .
        String newf = filename;
        int i = 0;
        while (new File(FilenameUtils.concat(savepath, newf)).exists())
        {
            i++;
            newf = name + "_" + i + "." + ext;
        }
        return newf;
    }
	
	private String setImageElement(SchemaInfo fpm, Element dataField, HttpServletRequest request, ImageInfo imageInfo)
	{
		try {
			String err = "";
			String fid = fpm.getName();
			String fileidx = fid + "_file";
			String imageAttribute = fpm.getAttribute();
			String alt = request.getParameter(fid + "_alt");
			String caption = request.getParameter(fid + "_caption");
			CommonsMultipartResolver multipartResolver=new CommonsMultipartResolver(request.getSession().getServletContext());
			String newFileName = "";
			if(multipartResolver.isMultipart(request))
			{
				MultipartHttpServletRequest multiRequest=(MultipartHttpServletRequest)request;
				if(multiRequest.getMultiFileMap().containsKey(fileidx)) {
					List<MultipartFile> list = multiRequest.getMultiFileMap().get(fileidx);
					if (CmsProperties.getImageMaxUploadSize() > 0 && list.size() == 1 && !StringUtils.isBlank(list.get(0).getOriginalFilename())) {
						if(list.get(0).getSize() < CmsProperties.getImageMaxUploadSize() * 1024 * 1024) {
							newFileName = newRandomFilename(Global.getImagesUploadPhysicalPath(Global.IMAGE_SOURCE), list.get(0).getOriginalFilename());								
							list.get(0).transferTo(new File(Global.getImagesUploadPhysicalPath(Global.IMAGE_SOURCE, newFileName)));						
						} else {
							err = "Image size shoud not more than " + CmsProperties.getImageMaxUploadSize() + "M";
						}
					}
				}            
				
			}
						
			if(imageInfo != null && fpm.canZipUpload()) {
				newFileName = newRandomFilename(Global.getImagesUploadPhysicalPath(Global.IMAGE_SOURCE), imageInfo.getImage().getName());
				FileUtils.moveFile(imageInfo.getImage(), new File(Global.getImagesUploadPhysicalPath(Global.IMAGE_SOURCE, newFileName))); 
				alt = imageInfo.getAlt();
				caption = imageInfo.getCaption();
			}
			
			if (!StringUtils.isBlank(newFileName)) {
				Map<String, String> result = mgnCmsImg(newFileName, imageAttribute);
				err = result.remove("ERROR");
				for (String attr : result.keySet()) {
					dataField.addAttribute(attr, result.get(attr));
				}				
			}
			
			dataField.addAttribute("alt", alt);
			dataField.addAttribute("caption", caption);
			dataField.setText(XmlUtils.toCDATA(newFileName));
			
			return err;			
		} catch (Exception e) {
			return e.getMessage();
		}
	}

	private Map<String, String> mgnCmsImg(String newFileName, String attr) {
		Map<String, String> result = new HashMap<String, String>();
		String err = "";	
		try {
			String sourceFilePath = Global.getImagesUploadPhysicalPath(Global.IMAGE_SOURCE, newFileName);			
			BufferedImage sourceImg =ImageIO.read(new File(sourceFilePath));			
			int width = sourceImg.getWidth();
			int height = sourceImg.getHeight();
			result.put("srcw", width + "");
			result.put("srch", height + "");
			if (!StringUtils.isBlank(attr))
			{
				String[] ra = attr.split(",");
				for (String r : ra)
				{
					if (!StringUtils.isBlank(err)) break;					
					String[] fa = r.split(":");
					String[] wh = fa[1].split("x");;
					String type = fa[0];
					if ("fix".equals(type) && (wh.length != 2 || Integer.parseInt(wh[0]) != width || Integer.parseInt(wh[1]) != height))
						err = "Invalid image size. Image must be " + fa[1];
					else if ("fixw".equals(type) && Integer.parseInt(fa[1]) != width)
						err = "Invalid image size. Image must be " + fa[1] + "in width";
					else if ("fixh".equals(type) && Integer.parseInt(fa[1]) != height)
						err = "Invalid image size. Image must be " + fa[1] + "in height";
					else if ("max".equals(type) && (wh.length != 2 || Integer.parseInt(wh[0]) < width || Integer.parseInt(wh[1]) < height))
						err = "Invalid image size. Image must be within " + fa[1];
					else if ("maxw".equals(type) && Integer.parseInt(fa[1]) < width)
						err = "Invalid image size. Image must be smaller than " + fa[1] + "in width";
					else if ("maxh".equals(type) && Integer.parseInt(fa[1]) < height)
						err = "Invalid image size. Image must be smalelr than " + fa[1] + "in height";
					else if ("samewh".equals(type) && width != height)
						err = "Invalid image size. Image width must same with the height";					
					else {							
						List<String> accepts = Arrays.asList(new String[] { 
							Global.IMAGE_RESIZE, Global.IMAGE_RESIZE + "w", Global.IMAGE_RESIZE + "h",
							Global.IMAGE_THUMB, Global.IMAGE_THUMB + "w", Global.IMAGE_THUMB + "h",
							Global.IMAGE_CMGR, Global.IMAGE_CMGR + "w", Global.IMAGE_CMGR + "h" }
						);
						if (accepts.contains(type)) {
							String lastc = type.substring(type.length() - 1, type.length());
							type = type.substring(0, type.length() - 1);
							int w = width;
							int h = height;
							if ("w".equals(lastc)) {
								w = Integer.parseInt(fa[1]);
								h = (w * height) / width;
							} else if ("h".equals(lastc)) {
								h = Integer.parseInt(fa[1]);
								w = (h * width) / height;
							} else {								
								type = fa[0];																	
								w = Integer.parseInt(wh[0]);																																															                                            			                                            								
								h = Integer.parseInt(wh[1]);
							}
							result.put(type + "w", w + "");
							result.put(type + "h", h + "");							
							
							ImageUtils.zoom(sourceFilePath, Global.getImagesUploadPhysicalPath(type, newFileName), w, h);
						}
					}
					
				}
			}
		} catch (Exception e) {
			err = e.getMessage();
		}
		result.put("ERROR", err);
		return result;
	}
}
