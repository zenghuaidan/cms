<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.edeas.utils.XmlUtils"%>
<%@page import="java.util.Map"%>
<%@page import="org.dom4j.Element"%>
<%@page import="java.util.*"%>
<%@page import="com.edeas.controller.*"%>

<%
	Element fieldData = (Element)request.getAttribute("fieldData");//data
	Element widgetSchema = (Element)request.getAttribute("widgetSchema");//widget define
	Element fieldSchema = (Element)request.getAttribute("fieldSchema");//file schema
	Map<String, String> fpm = XmlUtils.getSchemaInfo(fieldSchema, widgetSchema);
	String val = XmlUtils.getFieldRaw(fieldData, fpm.get("fname"));
	
    String lnktype = XmlUtils.getFieldAttr(fieldData, "lnktype");
    String lnktarget = XmlUtils.getFieldAttr(fieldData, "target");
    String lnkanchor = XmlUtils.getFieldAttr(fieldData, "anchor");
    String nwsel = lnktarget.equals("_blank") ? " SELECTED" : "";
    String extchk = ""; 
    String intchk = ""; 
    String dochk = "";
    switch (lnktype)
    {
        case "external": extchk = " CHECKED"; break;
        case "internal": intchk = " CHECKED"; break;
        case "document": dochk = " CHECKED"; break;
    }
    String intval = lnktype.equals("internal") ? val : "";
    String extval = lnktype.equals("external") ? val : "";
    String docval = lnktype.equals("document") ? val : "";

    String intattr = XmlUtils.getFieldAttr(fieldData, fpm.get("fname") + "IntAttr");
	
%>
<tr class="datafield">
    <td class="label" style="vertical-align:top;"><%=fpm.get("flabel") %> : 
        <br /><select id="<%=fpm.get("fname") %>_target" name="<%=fpm.get("fname") %>_target">
                <option value="">Standard</option>
                <option value="_blank" <%=nwsel %> >New Window</option>
        </select>
        <br />Anchor:
        <br /><input type="text" id="<%=fpm.get("fname") %>_anchor" name="<%=fpm.get("fname") %>_anchor"
                     value="<%=lnkanchor %>" style="width:100px;" />
    </td>
    <td class="field <%=fpm.get("ftype") %>" fid="<%=fpm.get("fname") %>">
        <input type='hidden' id="<%=fpm.get("fname") %>" name="<%=fpm.get("fname") %>" class="lnkvalfield" value="<%=val %>" />
        <input type="radio" id="<%=fpm.get("fname") %>_type_document" name="<%=fpm.get("fname") %>_type" value="nolink" />
        <span>None</span>
        <br /><input type="radio" id="<%=fpm.get("fname") %>_type_internal" name="<%=fpm.get("fname") %>_type" value="internal" <%=intchk %> />
        <span>Internal:
            <select class="selpages internal_link" id="<%=fpm.get("fname") %>_internal_page" name="<%=fpm.get("fname") %>_internal_page"
                    fid="<%=fpm.get("fname") %>" val="<%=intval %>" attr="<%=intattr %>">
            </select>
        </span>
        
        <br /><input type="radio"  id="<%=fpm.get("fname") %>_type_external" name="<%=fpm.get("fname") %>_type" value="external" <%=extchk %> />
        <span>
            External: 
            <input class="external_link" type="text" id="<%=fpm.get("fname") %>_external_link" name="<%=fpm.get("fname") %>_external_link" fid="<%=fpm.get("fname") %>" value="<%=extval %>" />
        </span>

        <br /><input type="radio" id="<%=fpm.get("fname") %>_type_document" name="<%=fpm.get("fname") %>_type" value="document" <%=dochk %> />
        <span>
            Document: <input class="document_link" type="file" id="<%=fpm.get("fname") %>_document_link" name="<%=fpm.get("fname") %>_document_link" style="width:200px;" /> 
        </span>
        <%
        	if(!StringUtils.isBlank(docval)) {
        		out.print("<input type='button' value='View' onclick='window.open('" + Global.getDocUploadPath(docval) + "');' />");
        	}
        %>        
        <%=fpm.get("fremark") %>
    </td>
</tr>