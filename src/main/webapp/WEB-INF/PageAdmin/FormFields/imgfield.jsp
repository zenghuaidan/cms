<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.edeas.utils.XmlUtils"%>
<%@page import="java.util.Map"%>
<%@page import="org.dom4j.Element"%>
<%@page import="java.util.*"%>
<%@page import="com.edeas.controller.*"%>
<%@page import="com.edeas.controller.cmsadmin.CmsProperties"%>

<%
	Element fieldData = (Element)request.getAttribute("fieldData");//data
	Element widgetSchema = (Element)request.getAttribute("widgetSchema");//widget define
	Element fieldSchema = (Element)request.getAttribute("fieldSchema");//file schema
	Map<String, String> fpm = XmlUtils.getSchemaInfo(fieldSchema, widgetSchema);
	String val = XmlUtils.getFieldRaw(fieldData, fpm.get("fname"));
	String alt = XmlUtils.getWidgetFieldAttr(fieldData, fpm.get("fname"), "alt");
	
    StringBuffer imgdesc = new StringBuffer("<span style='text-transform:none;'>");
    if(!StringUtils.isBlank(fpm.get("fattr"))) {
        String[] alist = fpm.get("fattr").split(",");
        for (String a : alist)
        {
        	imgdesc.append("<br />[ ");
            String[] b = a.split(":");
            String l = b[0];
            switch (l)
            {
                case "fix": l = "Fix dimenaion"; break;
                case "fixw": l = "Fix width"; break;
                case "fixh": l = "Fix height"; break;
                case "max": l = "Max dimension"; break;
                case "maxw": l = "Max width"; break;
                case "maxh": l = "Max height"; break;
                case "samewh": l = "Same width and height"; break;
            }
            imgdesc.append(l + (b.length < 2 ? "" :  " : " + b[1]) + " ]");
        }
    }
    if(CmsProperties.getImageMaxUploadSize() > 0) {
    	imgdesc.append("<br />[ Size not more than" + CmsProperties.getImageMaxUploadSize() + "M ]</span>");    	
    }
%>
<tr class="datafield">
    <td class="label" style="vertical-align:top;"><%=fpm.get("flabel") %> <%=imgdesc %>: </td>
    <td class="field <%=fpm.get("ftype") %>" fid="<%=fpm.get("fname") %>">
        <input type='hidden' id="<%=fpm.get("fname") %>" name="<%=fpm.get("fname") %>" value="<%=val %>" />
        <input type='file' id="<%=fpm.get("fname") %>_file" name="<%=fpm.get("fname") %>_file" class='imgfield' value="<%=val %>" />
        <% if(!StringUtils.isBlank(val)) { %>
            <span id="<%=fpm.get("fname") %>_view">
                <input type="button" value="View" onclick="popUrl('<%=Global.getImagesUploadPath("source", val) %>');" />
                <input type="button" value="Clear" onclick="clrVal('<%=fpm.get("fname") %>'); $('#<%=fpm.get("fname") %>_view').hide();" />
            </span>
        <% } %>                       
        <div>
            Alt Text: <input type="text" class="altxt" id="<%=fpm.get("fname") %>_alt" name="<%=fpm.get("fname") %>_alt" fid="<%=fpm.get("fname") %>" value="<%=alt %>" />
        </div>
        <%=fpm.get("fremark") %>
    </td>
</tr>