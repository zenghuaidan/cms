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
<link href="${Content}/css/online-shopping.css" rel="stylesheet" type="text/css" />
<link href="${Content}/css/masonry.css" rel="stylesheet" type="text/css" />
<link href="${Content}/css/form-general.css" rel="stylesheet" type="text/css" />
<style>
    @media only screen and (max-width: 745px) {
    table.quantity td:nth-of-type(1):before { content: "${lang eq 'en' ? 'Item:' : (lang eq 'tc' ? '商品:' : '商品:')}"; width:100%; display:none }
    table.quantity td:nth-of-type(2):before { content: "${lang eq 'en' ? 'Original Price:' : (lang eq 'tc' ? '原價:' : '原价:')}"; }
    table.quantity td:nth-of-type(3):before { content: "${lang eq 'en' ? 'Special Price:' : (lang eq 'tc' ? '特價:' : '特价:')}"; }
    table.quantity td:nth-of-type(4):before { content: "${lang eq 'en' ? 'Quantity:' : (lang eq 'tc' ? '數量:' : '数量:')}"; }
    table.quantity td:nth-of-type(5):before { content: "${lang eq 'en' ? 'Amount:' : (lang eq 'tc' ? '總計:' : '总计:')}"; }
    }
</style>
<% 
	boolean iscms = (Boolean)request.getAttribute("iscms");
	String lang = (String)request.getAttribute("lang");	
	Page currentPage = (Page)request.getAttribute("currentPage");
	Content pageContent = currentPage.getContent(lang);
	
	Map<String, Map<String, List<String>>> formMap = new HashMap<String, Map<String, List<String>>>() {		
		{
			put("en", new HashMap<String, List<String>>(){ 
				{										
					put("OrderFormType", Arrays.asList("Item"));				
					put("OrderFormOriginalPrice", Arrays.asList("Original Price"));					
					put("OrderFormSpecialPrice", Arrays.asList("Special Price"));
					put("Quantity", Arrays.asList("Quantity"));
					put("Subtotal", Arrays.asList("Subtotal"));
					put("Total", Arrays.asList("Total:"));
				} 
			});
			put("tc", new HashMap<String, List<String>>(){ 
				{					
					put("OrderFormType", Arrays.asList("商品"));
					put("OrderFormOriginalPrice", Arrays.asList("原價"));
					put("OrderFormSpecialPrice", Arrays.asList("特價"));
					put("Quantity", Arrays.asList("數量"));
					put("Subtotal", Arrays.asList("小計"));
					put("Total", Arrays.asList("總計:"));					
				} 
			});
			put("sc", new HashMap<String, List<String>>(){ 
				{					
					put("OrderFormType", Arrays.asList("商品"));					
					put("OrderFormOriginalPrice", Arrays.asList("原价"));					
					put("OrderFormSpecialPrice", Arrays.asList("特价"));
					put("Quantity", Arrays.asList("数量"));
					put("Subtotal", Arrays.asList("小计"));
					put("Total", Arrays.asList("总计:"));
				} 
			});
		}
	};
%>

<x:parse xml="<%=pageContent.getContentXmlWithoutCRLF() %>" var="contentXml"></x:parse>
<script type="text/javascript" src="${Script}/jquery.cookie.js" ></script>
<style>   
    .shop               { margin-top:50px}
    .post-desc h3       { padding:0; margin:0}
    .masonry .post-desc-wrapper .post-desc { padding:20px}
    .post-content       { margin-bottom:0}
	#payment, #cartSummary {display:none;}	
    @media only screen and (max-width: 745px) {
    .shop           { margin-top:20px}
    }
</style>

<script type="text/javascript">
	function addToCart(id, count) {
		var cart = $.cookie('cart');
		if(cart == undefined) {
			cart = "";
		}
		var newCart = "";
		var added = false;
		for(var i = 0; i < cart.split(",").length; i++) {
			var itemId = cart.split(",")[i];
			if (itemId == "")
				continue;
			var item = id + ":";
			if(itemId.indexOf(item) < 0) {
				newCart += (itemId + ",");
			} else {
				if (count != 0) {
					newCart += (id + ":" + count + ",");	
					added = true;					
				}
			}
		}
		if (count != 0 && !added)
			newCart += (id + ":" + count + ",");
		$.cookie('cart', newCart, { path: '/' });
		initCount();
	}
	
	function increaseItem(_this, id) {
		var count = parseInt($(_this).parent().find(".input-quantity").val());
		count = count+1;
		$(_this).parent().find(".input-quantity").val(count);
		addToCart(id, count);
		refresh();
	}
	
	function decreaseItem(_this, id) {
		var count = parseInt($(_this).parent().find(".input-quantity").val());
		if(count == 0) return;
		count = count-1;
		$(_this).parent().find(".input-quantity").val(count);
		addToCart(id, count);
		refresh();
	}
	
	function initCount() {
		var cart = $.cookie('cart');
		$(".badge").text(cart == undefined || cart == "" ? 0 : cart.split(",").length - 1);
	}
	
	function showCart() {
		if($(".badge").text() == "0")
			return;
		$("#cartSummary").show();
		refresh();
	}
	
	function refresh() {
		var quantity = '<%= lang.equals("en") ? "Quantity" : (lang.equals("tc") ? "數量" : "数量") %>';
		var cart = $.cookie('cart');
		$("ul.shop-item").html("");
		$("#payment").find("tbody").html("");
		if (cart == undefined)
			return;
		var total = 0;
		for(var i = 0; i < cart.split(",").length; i++) {
			if(cart.split(",")[i] == "") continue;
			var itemId = cart.split(",")[i].split(":")[0];
			var itemCount = cart.split(",")[i].split(":")[1];
			if (itemId == "" || $("#" + itemId).length == 0)
				continue;
			var orgprice = $("#" + itemId).find(".itemorgprice").text();
			var spprice = $("#" + itemId).find(".itemspprice").text();
			var price = $.trim(spprice) == "" ? orgprice : spprice;
			var name = $("#" + itemId).find(".itemname").text();
			var itemhtml = 	                   		
				"<li class='clearfix'>" +
	     			"<img src='" + $("#" + itemId).find(".itemimage").attr("src") + "' />" +
	         		"<span class='item-name'>" + name + "</span>" +
	         		"<span class='item-price'>" + price + "</span>" +
	         		"<span class='item-quantity'>" + quantity + ": " + itemCount + "</span>" +
	       		"</li>";
			$("ul.shop-item").append($(itemhtml));
			
			var floatPrice = price.replace(/[^1234567890.]/g, "");
			var subTotal = 0;
			if(!isNaN(parseFloat(floatPrice))) {
				subTotal = parseFloat(floatPrice) * itemCount;
			}
			
			var item2html = 
			    "<tr>" +
			        "<td>" + name + "</td>" +
			        "<td><span class='lineThrough'>" + orgprice + "</span></td>" +
			        "<td>" + ($.trim(spprice) == "" ? "-" : spprice) + "</td>" +
			        "<td>" +
			            "<div>" +
			                "<div class='btn-minus' onclick='decreaseItem(this, \"" + itemId + "\")'></div>" +
			                "<div class='input-quantity-blk'><input class='input-quantity' type='text' value='" + itemCount + "' readonly></div>" +
			                "<div class='btn-add' onclick='increaseItem(this, \"" + itemId + "\")'></div>" +
			            "</div>" +
			            "<div class='clear'></div>" +
			        "</td>" +
			        "<td>" + money(subTotal) + "</td>" +
			    "</tr>";
		    $("#payment").find("tbody").append($(item2html));
			    
			total += subTotal;
			
		}
		$(".totalPrice").text(money(total));
	}
	
	function money(total) {
		return "$" + formatNumber(parseInt(total)) + ((total + "").indexOf(".") >= 0 ? (total + "").substr((total + "").indexOf(".")) : "");
	}
	
	function formatNumber(num) {
		return (num || 0).toString().replace(/(\d)(?=(?:\d{3})+$)/g, '$1,');
	}

	function doPayment() {
		$("#payment").show();
		$("#shopping").hide();
		$("#cartSummary").hide();		
	}
	
	function doShopping() {
		$("#payment").hide();
		$("#shopping").show();
		$("#cartSummary").hide();
	}
	
	$(function() {
		initCount();
		$(".summary").click(function() {
			if($("#cartSummary:visible").length == 1) {
				$("#cartSummary").hide();
			} else {
				showCart();				
			}
		});
	})
</script>

<div class="clearfix"> 
	<div class="full-wrapper clearfix">
    	<div class="inner-wrapper main-masonry-pos">
        	<div class="main-content-pos">
        		<div id="shopping">
	            	<nav class="summary">
		                <div class="container">
		                  	<ul class="navbar-right">
		                      	<li><a style="cursor:pointer;" id="cart"><i class="fa fa-shopping-cart"></i> <%= lang.equals("en") ? "Cart" : (lang.equals("tc") ? "購物車" : "购物车") %> <span class="badge"></span></a></li>
		                  	</ul> 
		                </div>
	                </nav>
	                <div id="cartSummary">
		               	<div class="shopping-cart">	 
			               	<ul class="shopping-cart-items shop-item">
			               	</ul>                	
		                 	<div class="shopping-cart-footer">
		                   		<div class="shopping-cart-total">
		                     		<span><%= lang.equals("en") ? "Total" : (lang.equals("tc") ? "總計" : "总计") %>:</span>
		                     		<span class="main-color-text totalPrice"></span>
		                   		</div>
		                 	</div> <!--end shopping-cart-header -->
		         	  		<a style="cursor:pointer;" onclick="doPayment()" class="button checkout"><%= lang.equals("en") ? "Checkout" : (lang.equals("tc") ? "結賬" : "结账") %></a>
		         		</div>
	                </div>
	
	                <div class="masonry shop">
	                    <div class="posts_group lm_wrapper masonry isotope">
	                        <x:forEach select="$contentXml/PageContent/Widget[@name='OnlineShop']/Widget[@name='OnlineShopItem']" var="item" varStatus="status">                            
	                            <div class="post-item isotope-item clearfix" id="<x:out select='$item/@id' escapeXml='false'/>">
		                            <img width="576" height="450" src="<%=Global.getImagesUploadPath(Global.IMAGE_SOURCE) %>/<x:out select="$item/Field[@name='Image']" escapeXml="false"/>" class="img-scale itemimage" />
		                            <div class="post-desc-wrapper">
		                                <div class="post-desc">
		                                    <h3 class="txt-red itemname"><x:out select="$item/Field[@name='Name']" escapeXml="false"/></h3>
		                                    <div class="post-content">
		                                        <div><x:out select="$item/Field[@name='Description']" escapeXml="false"/></div>
		                                        <h3 class="main-color-text">
		                                        	<x:if select="$item/Field[@name='OrignalPrice']">
		                                        		<div class="org-prince itemorgprice">$<x:out select="$item/Field[@name='OrignalPrice']" escapeXml="false"/></div>
		                                        	</x:if>
		                                        	<div class="sp-price itemspprice">$<x:out select="$item/Field[@name='SpecialPrice']" escapeXml="false"/></div>
	                                        	</h3>
		                                        <a class="button add" style="cursor:pointer;" onclick="addToCart('<x:out select='$item/@id' escapeXml='false'/>', 1)"><%= lang.equals("en") ? "Add to Cart" : (lang.equals("tc") ? "加入購物車" : "加入购物车") %></a>
		                                    </div>
		                                </div>
		                            </div>
		                        </div>
				   			</x:forEach>                          
	                    </div>
	                </div>
                </div>
                <div id="payment">
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
		                </tbody>
	            	</table>
		            <div class="total-blk">
		                <div class="total-pos">
		                    <span class="total txt-blue"><%=formMap.get(lang).get("Total").get(0) %></span><span class="totalPrice"></span>
		                </div>
		                <div class="clear"></div>
		            </div>
	                <div style="float:right">
	                	<a style="cursor:pointer;" onclick="doShopping()" class="button pay gray"><%= lang.equals("en") ? "Continue Shopping" : (lang.equals("tc") ? "繼續購物" : "继续购物") %></a> 
	                	<a href="#" class="button pay red"><%= lang.equals("en") ? "Pay Now" : (lang.equals("tc") ? "付款" : "付款") %></a>
	                </div>
                </div>
            </div>
        </div>
    </div>
</div>