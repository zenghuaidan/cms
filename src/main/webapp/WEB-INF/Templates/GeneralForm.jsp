<%@include file="/WEB-INF/Shared/commons.jsp" %>
<%@page import="org.dom4j.Element"%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.edeas.utils.XmlUtils"%>
<%@page import="org.dom4j.Document"%>
<%@page import="com.edeas.service.impl.QueryServiceImpl"%>
<%@page import="com.edeas.web.InitServlet"%>
<%@page import="com.edeas.model.*"%>
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

<div class="full-wrapper clearfix"> 
    <div class="inner-wrapper">
        <div class="main-content-pos">
            <div class="row-height">
                <div class="col-sm-height col-left"><span class="error-star">*</span> Text Input</div>
                <div class="col-sm-height col-right">
                    <input type="text" class="form">
                    <div class="error font-s">Error Message here.</div>
                </div>
            </div>

            <div class="row-height">
                <div class="col-sm-height col-left"><span class="error-star">*</span> Multiple Selection Mode:</div>
                <div class="col-sm-height col-right">
                    <div class="checkbox-blk">
                        <input class="checkbox" type="checkbox">Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
                    </div>
                    <div class="checkbox-blk">
                        <input class="checkbox" type="checkbox">Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna.
                    </div>
                    <div class="error font-s">Error Message here.</div>
                </div>
            </div>  

            <div class="row-height">
                <div class="col-sm-height col-left">Single Selection Mode:</div>
                <div class="col-sm-height col-right">
                    <div class="radio-blk">
                        <input type="radio" name="gender" value="male" checked> Male<br>
                        <input type="radio" name="gender" value="female"> Female
                    </div>
                    <div class="error font-s">Error Message here.</div>
                </div>
            </div>  

            <div class="row-height">
                <div class="col-sm-height col-left"><span class="error-star">*</span> Drop Down Box</div>
                <div class="col-sm-height col-right">
                   <select>
                        <option>Option 1 - Duis aute irure dolor</option>
                        <option>Option 2 - Consectetur adipisicing elit</option>
                        <option>Option 3 - Sed do eiusmod tempor</option>
                    </select>
                    <div class="error font-s">Error Message here.</div>
                </div>
            </div>

            <div class="row-height">
                <div class="col-sm-height col-left">Count characters in textarea</div>
                <div class="col-sm-height col-right">
                    <textarea id="field"></textarea>
                    <div class="font-s"><span> Max 500 characters. No of </span><div id="charNum">0</div> character(s).<span></div>
                    <div class="error font-s">Error Message here.</div>
                </div>
            </div>

            <br/><br/>
            <h2>Order Form</h2>

            <table class="quantity">
                <thead>
                <tr>
                    <th>Mooncake Type</th>
                    <th>Original Price</th>
                    <th>Special Price</th>
                    <th class="quantity-col">Quantity</th>
                    <th>Subtotal</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>雙黃白蓮蓉月餅</td>
                    <td><span class="lineThrough">$246.00</span></td>
                    <td>$193.00</td>
                    <td>
                        <div>
                            <div class="btn-minus"></div>
                            <div class="input-quantity-blk"><input class="input-quantity" type="text" readonly></div>
                            <div class="btn-add"></div>
                        </div>
                        <div class="clear"></div>
                    </td>
                    <td>190.00</td>
                </tr>
                <tr>
                  <td>皇牌芒果月餅</td>
                    <td><span class="lineThrough">$246.00</span></td>
                    <td>$193.00</td>
                    <td>
                        <div>
                            <div class="btn-minus"></div>
                            <div class="input-quantity-blk"><input class="input-quantity" type="text" readonly></div>
                            <div class="btn-add"></div>
                        </div>
                        <div class="clear"></div>
                    </td>
                    <td>190.00</td>
                </tr>
                <tr>
                  <td>楊枝甘露. 皇牌芒果. 芒果栗子. 芒果脆脆. 士多啤梨脆</td>
                    <td><span class="lineThrough">$246.00</span></td>
                    <td>$193.00</td>
                    <td>
                        <div>
                            <div class="btn-minus"></div>
                            <div class="input-quantity-blk"><input class="input-quantity" type="text" readonly></div>
                            <div class="btn-add"></div>
                        </div>
                        <div class="clear"></div>
                    </td>
                    <td>190.00</td>
                </tr>
                </tbody>
            </table>
            <div class="total-blk">
                <div class="total-pos">
                    <span class="total txt-blue">Total:</span><span>$250.00</span>
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