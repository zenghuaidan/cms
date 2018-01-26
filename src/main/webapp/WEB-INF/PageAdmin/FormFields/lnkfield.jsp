<%@page import="com.edeas.dwr.SchemaInfo"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.edeas.utils.XmlUtils"%>
<%@page import="java.util.Map"%>
<%@page import="org.dom4j.Element"%>
<%@page import="java.util.*"%>
<%@page import="com.edeas.controller.*"%>
<%@include file="/WEB-INF/Shared/commons.jsp" %>
<%
	Element fieldData = (Element)request.getAttribute("fieldData");//data
	Element widgetSchema = (Element)request.getAttribute("widgetSchema");//widget define
	Element fieldSchema = (Element)request.getAttribute("fieldSchema");//file schema
	SchemaInfo fpm = XmlUtils.getSchemaInfo(fieldSchema, widgetSchema);
	String val = fieldData.getTextTrim();
	
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

    String intattr = XmlUtils.getFieldAttr(fieldData, fpm.getName() + "IntAttr");
	
%>
<tr class="datafield">
    <td class="label" style="vertical-align:top;"><%=fpm.getLabel() %> : 
        <br />
        <select id="<%=fpm.getName() %>_target" name="<%=fpm.getName() %>_target">
                <option value="">Standard</option>
                <option value="_blank" <%=nwsel %> >New Window</option>
        </select>
        <br />Anchor:
        <br />
        <input type="text" id="<%=fpm.getName() %>_anchor" name="<%=fpm.getName() %>_anchor"
                     value="<%=lnkanchor %>" style="width:100px;" />
    </td>
    <td class="field <%=fpm.getType() %>" fid="<%=fpm.getName() %>">
        <input type='hidden' id="<%=fpm.getName() %>" name="<%=fpm.getName() %>" class="lnkvalfield" value="<%=val %>" />
        <input type="radio" id="<%=fpm.getName() %>_type_document" name="<%=fpm.getName() %>_type" value="nolink" />
        <span>None</span>
        <br /><input type="radio" id="<%=fpm.getName() %>_type_internal" name="<%=fpm.getName() %>_type" value="internal" <%=intchk %> />
        <span>Internal:
            <select class="selpages internal_link" id="<%=fpm.getName() %>_internal_page" name="<%=fpm.getName() %>_internal_page"
                    fid="<%=fpm.getName() %>" val="<%=intval %>" attr="<%=intattr %>">
            </select>
        </span>
        
        <br /><input type="radio"  id="<%=fpm.getName() %>_type_external" name="<%=fpm.getName() %>_type" value="external" <%=extchk %> />
        <span>
            External: 
            <input class="external_link" type="text" id="<%=fpm.getName() %>_external_link" name="<%=fpm.getName() %>_external_link" fid="<%=fpm.getName() %>" value="<%=extval %>" />
        </span>

        <br /><input type="radio" id="<%=fpm.getName() %>_type_document" name="<%=fpm.getName() %>_type" value="document" <%=dochk %> />
        <span>
            Document: <input class="document_link" type="file" id="<%=fpm.getName() %>_document_link" name="<%=fpm.getName() %>_document_link" style="width:200px;" /> 
        </span>
        <c:set var="docval" value="<%=docval %>"></c:set>
        <c:if test="${not empty docval}">
        	<input type='button' value='View' onclick='window.open('<%=Global.getDocUploadPath(docval)%>');' />
        </c:if>
        <%=fpm.getRemark() %>
    </td>
</tr>