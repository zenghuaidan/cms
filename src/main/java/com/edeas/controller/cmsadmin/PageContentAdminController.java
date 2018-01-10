package com.edeas.controller.cmsadmin;

import java.awt.image.BufferedImage;
import java.io.File;
import java.text.ParseException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.dom4j.Document;
import org.dom4j.Element;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

import com.edeas.controller.Global;
import com.edeas.dto.Result;
import com.edeas.dwr.SchemaInfo;
import com.edeas.model.CmsContent;
import com.edeas.model.Content;
import com.edeas.model.Lang;
import com.edeas.model.Page;
import com.edeas.utils.XmlUtils;

import net.coobird.thumbnailator.Thumbnails;
import net.coobird.thumbnailator.Thumbnails.Builder;

@Controller
@SuppressWarnings({"rawtypes", "unchecked"})
public class PageContentAdminController extends CmsController {	
	@ResponseBody
	@RequestMapping(path = {"PageContentAdmin/UpdateProperty"}, method={RequestMethod.POST})
	public Result UpdateProperty(HttpServletRequest request) throws ParseException {
		Long pageId = Long.parseLong(request.getParameter("pageid"));
		String lang = request.getParameter("lang");
		Page page = queryService.findPageById(pageId, true);
		if(!page.isNew() && Lang.exists(lang)) {
			String errors = updateProperty(page, lang, request);
			if (StringUtils.isBlank(errors)) {
				queryService.addOrUpdate(page, true);
				return new Result("Congraduation! Page is saved successfully.");				
			} else {
				return new Result("Failed", errors);
			}
		} else {
			return new Result("Failed", "Invalid config form. Invalidate page id or empty lang?");
		}
	}
	
	private String updateProperty(Page page, String lang, HttpServletRequest request) {
		StringBuffer errors = new StringBuffer();
		Content content = (Content)page.getContent(lang);
		Document template = XmlUtils.getTemplateDocument(page.getTemplate());
		List<Element> fieldList = template.selectNodes("/Template/Properties/Field");
		if (content == null) {
			content = new CmsContent();
			content.initPropertyXml(page, Lang.getByName(lang));
		}
		
		Document propDocument = XmlUtils.loadFromString(content.getPropertyXml());
		Element propDataXml = (Element)propDocument.selectSingleNode("/Properties");
		for(Element field : fieldList) {
			SchemaInfo fpm = XmlUtils.getSchemaInfo(field, null);
			
			Element dataField = (Element)propDataXml.selectSingleNode("Field[@name='" + fpm.getName() + "']");
			String value = request.getParameter(fpm.getName());
			if(lang.equals("en")) value = value.replaceAll("<br /><br />", "<br />&nbsp;<br />");
			if(dataField != null) {
				dataField.addAttribute("ftype", fpm.getType());
				dataField.setText(XmlUtils.toCDATA(value));
			} else {
				dataField = propDataXml.addElement("Field");
				int i = 1;
				while (propDataXml.selectSingleNode("//*[@id='" + fpm.getName() + "-" + i + "']") != null) { i++; }
				String fxid = fpm.getName() + "-" + i;
				dataField.addAttribute("id", fxid);
				dataField.addAttribute("name", fpm.getName());
				dataField.addAttribute("ftype", fpm.getType());
				dataField.addText(XmlUtils.toCDATA(value));
			}
			errors.append(setSpecialField(fpm, dataField, request) + System.lineSeparator());
		}
		content.setPropertyXml(XmlUtils.formatXml(propDocument));
		queryService.addOrUpdate(content, true);
		return errors.toString().trim();
	}
	
	private String setSpecialField(SchemaInfo fpm, Element dataField, HttpServletRequest request)
	{
		String err = "";
		switch (fpm.getType())
		{
			case "imgfield": err = setImageElement(fpm, dataField, request); break;
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
					String newFileName = newRandomFilename(Global.getDocUploadPhysicalPath(), list.get(0).getOriginalFilename());	
					String size = (int)(list.get(0).getSize() / 1024) + "";
					list.get(0).transferTo(new File(Global.getDocUploadPhysicalPath(newFileName)));
					dataField.setText(XmlUtils.toCDATA(newFileName));
					dataField.addAttribute("size", size);
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
	
	private String setImageElement(SchemaInfo fpm, Element dataField, HttpServletRequest request)
	{
		String err = "";
		String fid = fpm.getName();
		String fileidx = fid + "_file";
		String imageAttribute = fpm.getAttribute();
		String alt = request.getParameter(fid + "_alt");
		dataField.addAttribute("alt", alt);		
        CommonsMultipartResolver multipartResolver=new CommonsMultipartResolver(request.getSession().getServletContext());
        if(multipartResolver.isMultipart(request))
        {
            MultipartHttpServletRequest multiRequest=(MultipartHttpServletRequest)request;
			if(multiRequest.getMultiFileMap().containsKey(fileidx)) {
				List<MultipartFile> list = multiRequest.getMultiFileMap().get(fileidx);
				if (CmsProperties.getImageMaxUploadSize() > 0 && list.size() == 1) {
					if(list.get(0).getSize() < CmsProperties.getImageMaxUploadSize() * 1024 * 1024) {
						String newFileName = newRandomFilename(Global.getImagesUploadPhysicalPath(Global.IMAGE_SOURCE), list.get(0).getOriginalFilename());											
						Map<String, String> result = mgnCmsImg(list.get(0), newFileName, imageAttribute);
						err = result.remove("ERROR");
						for (String attr : result.keySet()) {
							dataField.addAttribute(attr, result.get(attr));
						}
						dataField.setText(XmlUtils.toCDATA(newFileName));
					} else {
						err = "Image size shoud not more than " + CmsProperties.getImageMaxUploadSize() + "M";
					}
				}
            }            
           
        }
		return err;
	}

	private Map<String, String> mgnCmsImg(MultipartFile file, String newFileName, String attr) {
		Map<String, String> result = new HashMap<String, String>();
		String err = "";	
		try {
			File sourceFile = new File(Global.getImagesUploadPhysicalPath(Global.IMAGE_SOURCE, newFileName));
			file.transferTo(sourceFile);
			BufferedImage sourceImg =ImageIO.read(sourceFile);
			Builder<BufferedImage> builder = Thumbnails.of(sourceImg);
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
							if ("w".equals(lastc) && width > Integer.parseInt(fa[1]))
								builder.width(Integer.parseInt(fa[1]));		                                            
							else if ("h".equals(lastc) && height > Integer.parseInt(fa[1]))
								builder.height(Integer.parseInt(fa[1]));
							else {								
								type = fa[0];									
								if (width > Integer.parseInt(wh[0]))
									builder.width(Integer.parseInt(wh[0]));																																															                                            			                                            
								if (builder.asBufferedImage().getHeight() > Integer.parseInt(wh[1]))
									builder.height(Integer.parseInt(wh[1]));
							}
							result.put(type + "w", builder.asBufferedImage().getWidth() + "");
							result.put(type + "h", builder.asBufferedImage().getHeight() + "");
							builder.toFile(Global.getImagesUploadPhysicalPath(type, newFileName));
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
