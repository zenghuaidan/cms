<%@page import="com.edeas.dwr.SchemaInfo"%>
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
	SchemaInfo fpm = XmlUtils.getSchemaInfo(fieldSchema, widgetSchema);
	String val = (fieldData == null) ? fpm.getDefaultValue() : fieldData.getTextTrim();
	String alt = XmlUtils.getFieldAttr(fieldData, "alt");
	
    StringBuffer imgdesc = new StringBuffer("<span style='text-transform:none;'>");
    if(!StringUtils.isBlank(fpm.getAttribute())) {
        String[] alist = fpm.getAttribute().split(",");
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
    	imgdesc.append("<br />[ Size not more than " + CmsProperties.getImageMaxUploadSize() + "M ]</span>");    	
    }
%>
<tr class="datafield">
    <td class="label" style="vertical-align:top;"><%=fpm.getLabel() %> <%=imgdesc %>: </td>
    <td class="field <%=fpm.getType() %>" fid="<%=fpm.getName() %>">
        <input type='hidden' id="<%=fpm.getName() %>" name="<%=fpm.getName() %>" value="<%=val %>" />
        <input type='file' id="<%=fpm.getName() %>_file" name="<%=fpm.getName() %>_file" class='imgfield' value="<%=val %>" />
        <% if(!StringUtils.isBlank(val)) { %>
            <span id="<%=fpm.getName() %>_view">
                <input type="button" value="View" onclick="popUrl('<%=Global.getImagesUploadPath(Global.IMAGE_SOURCE, val) %>');" />
                <input type="button" value="Clear" onclick="clrVal('<%=fpm.getName() %>'); $('#<%=fpm.getName() %>_view').hide();" />
            </span>
        <% } %>                       
        <div>
            Alt Text: <input type="text" class="altxt" id="<%=fpm.getName() %>_alt" name="<%=fpm.getName() %>_alt" fid="<%=fpm.getName() %>" value="<%=alt %>" />
        </div>
        <%=fpm.getRemark() %>
    </td>
</tr>