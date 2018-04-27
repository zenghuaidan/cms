<%@include file="/WEB-INF/Shared/commons.jsp" %>
<%@page import="org.dom4j.Element"%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.edeas.utils.XmlUtils"%>
<%@page import="org.dom4j.Document"%>
<%@page import="com.edeas.service.impl.QueryServiceImpl"%>
<%@page import="com.edeas.web.InitServlet"%>
<%@page import="com.edeas.model.*"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page contentType="text/html;charset=UTF-8"%>
<link href="${Content}/css/form-general.css" rel="stylesheet" type="text/css" />
<style>
    @media only screen and (max-width: 745px) {
    table.quantity td:nth-of-type(1):before { content: "Mooncake Type:"; width:100%; display:none }
    table.quantity td:nth-of-type(2):before { content: "Original Price:"; }
    table.quantity td:nth-of-type(3):before { content: "Special Price:"; }
    table.quantity td:nth-of-type(4):before { content: "Quantity:"; }
    table.quantity td:nth-of-type(5):before { content: "Amount:"; }
    }
</style>
<%
	boolean iscms = (Boolean)request.getAttribute("iscms");
	String lang = (String)request.getAttribute("lang");
	Map<String, Map<String, List<String>>> formMap = new HashMap<String, Map<String, List<String>>>() {		
		{
			put("en", new HashMap<String, List<String>>(){ 
				{
					put("TextInput", Arrays.asList("Text Input"));
					put("MultipleSelectionMode", Arrays.asList("Multiple Selection Mode"));
					put("MultipleSelectionModeOption", Arrays.asList("Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna."));
					put("SingleSelectionMode", Arrays.asList("Single Selection Mode"));
					put("SingleSelectionModeOption", Arrays.asList("Male", "Female"));
					put("DropDownBox", Arrays.asList("Drop Down Box"));
					put("DropDownBoxOption", Arrays.asList("Option 1 - Duis aute irure dolor", "Option 2 - Consectetur adipisicing elit", "Option 3 - Sed do eiusmod tempor"));
					put("Countcharactersintextarea", Arrays.asList("Count characters in textarea"));
					put("CountcharactersintextareaNote", Arrays.asList("<span> Max 500 characters. No of </span><div id='charNum'>0</div><span> character(s).</span>"));
					put("OrderForm", Arrays.asList("Order Form"));
					put("OrderFormType", Arrays.asList("Mooncake Type"));
					put("OrderFormTypeItems", Arrays.asList("雙黃白蓮蓉月餅", "皇牌芒果月餅", "楊枝甘露. 皇牌芒果. 芒果栗子. 芒果脆脆. 士多啤梨脆"));
					put("OrderFormOriginalPrice", Arrays.asList("Original Price"));
					put("OrderFormOriginalPriceItems", Arrays.asList("$246.00", "$246.00", "$246.00"));
					put("OrderFormSpecialPrice", Arrays.asList("Special Price"));
					put("OrderFormSpecialPriceItems", Arrays.asList("$193.00", "$193.00", "$193.00"));
					put("Quantity", Arrays.asList("Quantity"));
					put("QuantityItems", Arrays.asList("1", "2", "3"));
					put("Subtotal", Arrays.asList("Subtotal"));
					put("SubtotalItems", Arrays.asList("190.00", "190.00", "190.00"));
					put("Total", Arrays.asList("Total:"));
					put("TotalValue", Arrays.asList("$250.00"));
					put("ErrorMessage", Arrays.asList("Error Message here."));
				} 
			});
			put("tc", new HashMap<String, List<String>>(){ 
				{
					put("TextInput", Arrays.asList("文本輸入"));
					put("MultipleSelectionMode", Arrays.asList("多選模式"));
					put("MultipleSelectionModeOption", Arrays.asList("請求繁體翻譯", "請求繁體翻譯"));
					put("SingleSelectionMode", Arrays.asList("單選模式"));
					put("SingleSelectionModeOption", Arrays.asList("男", "女"));
					put("DropDownBox", Arrays.asList("下拉框"));
					put("DropDownBoxOption", Arrays.asList("請求繁體翻譯", "請求繁體翻譯", "請求繁體翻譯"));
					put("Countcharactersintextarea", Arrays.asList("限制數字文本域"));
					put("CountcharactersintextareaNote", Arrays.asList("<span> 最多輸入500個字符. 已輸入字符數為 </span><div id='charNum'>0</div>"));
					put("OrderForm", Arrays.asList("訂貨單"));
					put("OrderFormType", Arrays.asList("月餅類型"));
					put("OrderFormTypeItems", Arrays.asList("雙黃白蓮蓉月餅", "皇牌芒果月餅", "楊枝甘露. 皇牌芒果. 芒果栗子. 芒果脆脆. 士多啤梨脆"));
					put("OrderFormOriginalPrice", Arrays.asList("原價"));
					put("OrderFormOriginalPriceItems", Arrays.asList("$246.00", "$246.00", "$246.00"));
					put("OrderFormSpecialPrice", Arrays.asList("特價"));
					put("OrderFormSpecialPriceItems", Arrays.asList("$193.00", "$193.00", "$193.00"));
					put("Quantity", Arrays.asList("數量"));
					put("QuantityItems", Arrays.asList("1", "2", "3"));
					put("Subtotal", Arrays.asList("小計"));
					put("SubtotalItems", Arrays.asList("190.00", "190.00", "190.00"));
					put("Total", Arrays.asList("總計:"));
					put("TotalValue", Arrays.asList("$250.00"));
					put("ErrorMessage", Arrays.asList("此處顯示輸入的錯誤信息."));
				} 
			});
			put("sc", new HashMap<String, List<String>>(){ 
				{
					put("TextInput", Arrays.asList("文本输入"));
					put("MultipleSelectionMode", Arrays.asList("多选模式"));
					put("MultipleSelectionModeOption", Arrays.asList("请求简体翻译", "请求简体翻译"));
					put("SingleSelectionMode", Arrays.asList("单选模式"));
					put("SingleSelectionModeOption", Arrays.asList("男", "女"));
					put("DropDownBox", Arrays.asList("下拉框"));
					put("DropDownBoxOption", Arrays.asList("请求简体翻译", "请求简体翻译", "请求简体翻译"));
					put("Countcharactersintextarea", Arrays.asList("限制数字文本域"));
					put("CountcharactersintextareaNote", Arrays.asList("<span> 最多输入500个字符. 已输入字符数为 </span><div id='charNum'>0</div>"));
					put("OrderForm", Arrays.asList("订货单"));
					put("OrderFormType", Arrays.asList("月饼类型"));
					put("OrderFormTypeItems", Arrays.asList("双黄白莲蓉月饼", "皇牌芒果月饼", "杨枝甘露. 皇牌芒果. 芒果栗子. 芒果脆脆. 士多啤梨脆"));
					put("OrderFormOriginalPrice", Arrays.asList("原价"));
					put("OrderFormOriginalPriceItems", Arrays.asList("$246.00", "$246.00", "$246.00"));
					put("OrderFormSpecialPrice", Arrays.asList("特价"));
					put("OrderFormSpecialPriceItems", Arrays.asList("$193.00", "$193.00", "$193.00"));
					put("Quantity", Arrays.asList("数量"));
					put("QuantityItems", Arrays.asList("1", "2", "3"));
					put("Subtotal", Arrays.asList("小计"));
					put("SubtotalItems", Arrays.asList("190.00", "190.00", "190.00"));
					put("Total", Arrays.asList("总计:"));
					put("TotalValue", Arrays.asList("$250.00"));
					put("ErrorMessage", Arrays.asList("此处显示输入的错误信息."));
				} 
			});
		}
	};
%>

<div class="full-wrapper clearfix"> 
    <div class="inner-wrapper">
        <div class="main-content-pos">
            <div class="row-height">
                <div class="col-sm-height col-left"><span class="error-star">*</span> <%=formMap.get(lang).get("TextInput").get(0) %></div>
                <div class="col-sm-height col-right">
                    <input type="text" class="form">
                    <div class="error font-s"><%=formMap.get(lang).get("ErrorMessage").get(0) %></div>
                </div>
            </div>

            <div class="row-height">
                <div class="col-sm-height col-left"><span class="error-star">*</span> <%=formMap.get(lang).get("MultipleSelectionMode").get(0) %></div>
                <div class="col-sm-height col-right">
                    <div class="checkbox-blk">
                        <input class="checkbox" type="checkbox"><%=formMap.get(lang).get("MultipleSelectionModeOption").get(0) %>
                    </div>
                    <div class="checkbox-blk">
                        <input class="checkbox" type="checkbox"><%=formMap.get(lang).get("MultipleSelectionModeOption").get(1) %>
                    </div>
                    <div class="error font-s"><%=formMap.get(lang).get("ErrorMessage").get(0) %></div>
                </div>
            </div>  

            <div class="row-height">
                <div class="col-sm-height col-left"><%=formMap.get(lang).get("SingleSelectionMode").get(0) %></div>
                <div class="col-sm-height col-right">
                    <div class="radio-blk">
                        <input type="radio" name="gender" value="male" checked> <%=formMap.get(lang).get("SingleSelectionModeOption").get(0) %><br>
                        <input type="radio" name="gender" value="female"> <%=formMap.get(lang).get("SingleSelectionModeOption").get(1) %>
                    </div>
                    <div class="error font-s"><%=formMap.get(lang).get("ErrorMessage").get(0) %></div>
                </div>
            </div>  

            <div class="row-height">
                <div class="col-sm-height col-left"><span class="error-star">*</span> <%=formMap.get(lang).get("DropDownBox").get(0) %></div>
                <div class="col-sm-height col-right">
                   <select>
                        <option><%=formMap.get(lang).get("DropDownBoxOption").get(0) %></option>
                        <option><%=formMap.get(lang).get("DropDownBoxOption").get(1) %></option>
                        <option><%=formMap.get(lang).get("DropDownBoxOption").get(2) %></option>
                    </select>
                    <div class="error font-s"><%=formMap.get(lang).get("ErrorMessage").get(0) %></div>
                </div>
            </div>

            <div class="row-height">
                <div class="col-sm-height col-left"><%=formMap.get(lang).get("Countcharactersintextarea").get(0) %></div>
                <div class="col-sm-height col-right">
                    <textarea id="field"></textarea>
                    <div class="font-s"><%=formMap.get(lang).get("CountcharactersintextareaNote").get(0) %></div>
                    <div class="error font-s"><%=formMap.get(lang).get("ErrorMessage").get(0) %></div>
                </div>
            </div>

            <br/><br/>
            <h2><%=formMap.get(lang).get("OrderForm").get(0) %></h2>

            <table class="quantity">
                <thead>
	                <tr>
	                    <th><%=formMap.get(lang).get("OrderFormType").get(0) %></th>
	                    <th><%=formMap.get(lang).get("OrderFormOriginalPrice").get(0) %></th>
	                    <th><%=formMap.get(lang).get("OrderFormSpecialPrice").get(0) %></th>
	                    <th class="quantity-col"><%=formMap.get(lang).get("Quantity").get(0) %></th>
	                    <th><%=formMap.get(lang).get("Subtotal").get(0) %></th>
	                </tr>
                </thead>
                <tbody>
                	<%
                		for(int i = 0; i <= 2; i++) {
                			%>
				                <tr>
				                    <td><%=formMap.get(lang).get("OrderFormTypeItems").get(i) %></td>
				                    <td><span class="lineThrough"><%=formMap.get(lang).get("OrderFormOriginalPriceItems").get(i) %></span></td>
				                    <td><%=formMap.get(lang).get("OrderFormSpecialPriceItems").get(i) %></td>
				                    <td>
				                        <div>
				                            <div class="btn-minus"></div>
				                            <div class="input-quantity-blk"><input class="input-quantity" type="text" value="<%=formMap.get(lang).get("QuantityItems").get(i) %>" readonly></div>
				                            <div class="btn-add"></div>
				                        </div>
				                        <div class="clear"></div>
				                    </td>
				                    <td><%=formMap.get(lang).get("SubtotalItems").get(i) %></td>
				                </tr>
                			<%
                		}
                	%>
                </tbody>
            </table>
            <div class="total-blk">
                <div class="total-pos">
                    <span class="total txt-blue"><%=formMap.get(lang).get("Total").get(0) %></span><span><%=formMap.get(lang).get("TotalValue").get(0) %></span>
                </div>
                <div class="clear"></div>
            </div>
        </div>
    </div>
</div>

<script>
	$(function() {
	    $("#field").keyup(function(){
	        el = $(this);
	        if(el.val().length >= 500){
	            el.val( el.val().substr(0, 500) );
	        } else {
	            $("#charNum").text(500-el.val().length);
	        }
	    });		
	});
</script>