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
<%
	boolean iscms = (Boolean)request.getAttribute("iscms");
	String lang = (String)request.getAttribute("lang");
	Map<String, Map<String, List<String>>> formMap = new HashMap<String, Map<String, List<String>>>() {		
		{
			put("en", new HashMap<String, List<String>>(){ 
				{
					put("MoneyLabel", Arrays.asList("I would like to donate HK$"));
					put("SalutationLabel", Arrays.asList("Salutation"));
					put("Salutation", Arrays.asList("Mr", "Mrs", "Ms", "Miss"));
					put("FirstNameLabel", Arrays.asList("First Name"));
					put("LastNameLabel", Arrays.asList("Last Name"));
					put("CorrespondenceAddressLabel", Arrays.asList("Correspondence Address"));
					put("CountryLabel", Arrays.asList("Country"));
					put("Country", Arrays.asList("Afghanistan","Aland Islands","Albania","Algeria","American Samoa","Andorra","Angola","Anguilla","Antarctica","Antigua and Barbuda","Argentina","Armenia","Aruba","Australia","Austria","Azerbaijan","Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize","Benin","Bermuda","Bhutan","Bolivia","Bonaire, Saint Eustatius and Saba","Bosnia and Herzegovina","Botswana","Bouvet Island","Brazil","British Indian Ocean Territory","Brunei Darussalam","Bulgaria","Burkina Faso","Burundi","Cambodia","Cameroon","Canada","Canary Islands","Cape Verde","Cayman Islands","Central African Republic","Ceuta and Melilla","Chad","Chile","China","Christmas Island","Cocos (Keeling) Islands","Colombia","Comoros","Congo, Democratic Republic of","Congo, Republic of","Cook Islands","Costa Rica","Cote d'Ivoire","Croatia/Hrvatska","Cuba","Curaçao","Cyprus","Czech Republic","Denmark","Djibouti","Dominica","Dominican Republic","East Timor","Ecuador","Egypt","El Salvador","Equatorial Guinea","Eritrea","Estonia","Ethiopia","Falkland Islands","Faroe Islands","Fiji","Finland","France","French Guiana","French Polynesia","French Southern Territories","Gabon","Gambia","Georgia","Germany","Ghana","Gibraltar","Greece","Greenland","Grenada","Guadeloupe","Guam","Guatemala","Guernsey","Guinea","GuineaBissau","Guyana","Haiti","Heard and McDonald Islands","Holy See (City Vatican State)","Honduras","Hong Kong (SAR)","Hungary","Iceland","India","Indonesia","Iran (Islamic Republic of)","Iraq","Ireland","Isle of Man","Israel","Italy","Jamaica","Japan","Jersey","Jordan","Kazakhstan","Kenya","Kiribati","Korea, Democratic People's Republic","Korea, Republic of","Kosovo","Kuwait","Kyrgyzstan","Lao People's Democratic Republic","Latvia","Lebanon","Lesotho","Liberia","Libya","Liechtenstein","Lithuania","Luxembourg","Macau","Macedonia","Madagascar","Malawi","Malaysia","Maldives","Mali","Malta","Marshall Islands","Martinique","Mauritania","Mauritius","Mayotte","Mexico","Micronesia, Federal State of","Moldova, Republic of","Monaco","Mongolia","Montenegro","Montserrat","Morocco","Mozambique","Myanmar (Burma)","Namibia","Nauru","Nepal","Netherlands","New Caledonia","New Zealand","Nicaragua","Niger","Nigeria","Niue","Norfolk Island","Northern Mariana Islands","Norway","Oman","Pakistan","Palau","Panama","Papua New Guinea","Paraguay","Peru","Philippines","Pitcairn Island","Poland","Portugal","Puerto Rico","Qatar","Reunion Island","Romania","Russian Federation","Rwanda","Saint Barthélemy","Saint Helena","Saint Kitts and Nevis","Saint Lucia","Saint Martin","Saint Vincent and the Grenadines","Samoa","San Marino","Sao Tome and Principe","Saudi Arabia","Senegal","Serbia","Seychelles","Sierra Leone","Singapore","Sint Maarten","Slovak Republic","Slovenia","Solomon Islands","Somalia","South Africa","South Georgia","South Sudan","Spain","Sri Lanka","St. Pierre and Miquelon","State of Palestine","Sudan","Suriname","Svalbard and Jan Mayen Islands","Swaziland","Sweden","Switzerland","Syrian Arab Republic","Taiwan","Tajikistan","Tanzania","Thailand","Togo","Tokelau","Tonga","Trinidad and Tobago","Tunisia","Turkey","Turkmenistan","Turks and Caicos Islands","Tuvalu","Uganda","Ukraine","United Arab Emirates","United Kingdom","United States","Uruguay","US Minor Outlying Islands","Uzbekistan","Vanuatu","Venezuela","Vietnam","Virgin Islands (British)","Virgin Islands (USA)","Wallis and Futuna","Western Sahara","Yemen","Zambia","Zimbabwe"));
					put("TelephoneLabel", Arrays.asList("Telephone"));
					put("EmailLabel", Arrays.asList("E-mail"));
					put("NotificationLabel", Arrays.asList("I would like to receive future information from Edeas."));
					put("Notification", Arrays.asList("By Mobile Text Message", "By Phone", "By Email", "By Post"));
					
					
					put("CountcharactersintextareaNote", Arrays.asList("<span> Max 500 characters. No of </span><div id='charNum'>0</div><span> character(s).</span>"));
					put("ErrorMessage", Arrays.asList(" is Invalid."));					
				} 
			});
			put("tc", new HashMap<String, List<String>>(){ 
				{
					put("MoneyLabel", Arrays.asList("本人將捐款港幣$"));
					put("SalutationLabel", Arrays.asList("稱謂"));
					put("Salutation", Arrays.asList("先生", "太太", "女士", "小姐"));
					put("FirstNameLabel", Arrays.asList("名字"));
					put("LastNameLabel", Arrays.asList("姓氏"));
					put("CorrespondenceAddressLabel", Arrays.asList("通訊地址"));
					put("CountryLabel", Arrays.asList("國家 / 城市"));
					put("Country", Arrays.asList("不丹","中國","中非共和國","丹麥","乍得","也門","亞美尼亞","以色列","伊拉克","伊朗伊斯蘭共和國","俄羅斯聯邦","保加利亞","克羅埃西亞/赫爾瓦次卡","冰島","列支敦斯","利比亞","剛果共和國","剛果民主共和國","加彭","加拿大","加那利群島","匈牙利","北馬里亞納群島","南喬治亞","南極洲","南蘇丹","南非","博內爾島、聖尤斯特歇斯島及薩巴島","卡塔爾","印尼","印度","厄利垂亞","厄瓜多爾","古巴","可可群島","台灣","吉布提","吉爾吉斯","吉里巴斯","吐瓦魯","哈薩克斯坦","哥倫比亞","哥德普洛","哥斯大黎加","喀麥隆","土庫曼","土耳其","圭亞那","坦桑尼亞","埃及","塔吉克","塞內加爾","塞爾維亞","塞錫爾群島","墨西哥","多哥","多明尼加","多明尼加共和國","奈及利亞","奧地利","委內瑞拉","孟加拉共和國","安哥拉","安圭拉","安提瓜和巴布達","安道爾","宏都拉斯","密克羅尼西亞，聯邦州","尼加拉瓜","尼日","尼泊爾","巴勒斯坦國","巴哈馬","巴基斯坦","巴布亞新幾內亞","巴拉圭","巴拿馬","巴林","巴西","巴貝多","布吉那法索","布威島","希臘","帛琉","幾內亞","幾內亞比紹","庫拉索島","德國","愛沙尼亞","愛爾蘭","托克勞群島","拉脫維亞","挪威","捷克","摩洛哥","摩爾多瓦共和國","摩納哥","敘利亞","斐濟","斯威士蘭","斯洛伐克共和國","斯洛文尼亞","斯瓦爾巴和央麥恩群島","斯里蘭卡","新加坡","新喀裏多尼亞","新西蘭","日本","智利","曼島","朝鮮人民民主共和國","東加","東帝汶","根息","格瑞納達","格陵蘭","格魯吉亞","梵帝岡","模里西斯","比利時","毛里塔尼亞","汶萊","沃利斯和富圖納","沙地阿拉伯","法國","法國南方領地","法屬圭亞那","法屬玻裏尼西亞","法羅群島","波士尼亞赫塞哥維納聯邦","波多黎各","波札那","波蘭","泰國","津巴布韋","海地","澤西島","澳洲","澳門","烏克蘭","烏干達","烏拉圭","烏茲別克斯坦","牙買加","特克斯和凱科斯群島","特立尼達和多巴哥","獅子山","玻利維亞","瑞典","瑞士","瓜地馬拉","甘比亞","留尼旺群島","白俄羅斯","百慕達","皮特凱恩島","盧安達","盧森堡","直布羅陀","福克蘭群島","科克群島","科威特","科摩洛","科特迪瓦共和國","科索沃","秘魯","突尼斯","立陶宛","約旦","紐威島","索羅門群島","索馬利亞","維德角","維爾京群島 (美國)","維爾京群島 (英國)","緬甸","羅馬尼亞","美國","美國外圍小島嶼","美屬薩摩亞群島","義大利","老撾人民民主共和國","聖 皮埃爾和密克羅","聖吉斯和尼維斯","聖多美和普林西比","聖巴托洛繆島","聖文森和格林納丁斯","聖誕島","聖赫勒拿島","聖露西亞","聖馬丁","聖馬丁","聖馬利諾","肯尼亞","芬蘭","英國","英屬印度洋領土","荷蘭","莫桑比克","菲律賓共和國","萬那杜","葡萄牙","蒙古","蒙特內哥羅","蒙特色拉特島","蒲隆地","薩摩亞","薩爾瓦多","蘇丹","蘇里南","衣索比亞","西屋達及美利亞","西撒哈拉","西班牙","諾福克島","諾魯","貝南","貝里斯","賴比瑞亞","賴索托","賽浦路斯","贊比亞","赤道畿內亞","赫德和邁克唐納島","越南","迦納","那米比亞","開曼群島","關島","阿塞拜疆","阿富汗","阿拉伯聯合酋長國","阿曼","阿根廷","阿爾及利亞","阿爾巴尼亞","阿蘭群島","阿路巴","韓國","香港","馬丁尼克島","馬來西亞","馬其頓","馬利","馬拉威","馬爾他","馬爾地夫","馬約特島","馬紹爾群島","馬達加斯加","高棉","黎巴嫩"));
					put("TelephoneLabel", Arrays.asList("聯絡電話"));
					put("EmailLabel", Arrays.asList("電郵"));
					put("NotificationLabel", Arrays.asList("本人 希望收到來自裕德堂有限公司的推廣及宣傳資訊。"));
					put("Notification", Arrays.asList("以電話短訊方式收取", "以電話方式收取", "以電郵方式收取", "以郵遞方式收取"));
					
					
					put("CountcharactersintextareaNote", Arrays.asList("<span> 最多輸入500個字符. 已輸入字符數為 </span><div id='charNum'>0</div>"));
					put("ErrorMessage", Arrays.asList("信息不正確."));
				} 
			});
			put("sc", new HashMap<String, List<String>>(){ 
				{
					put("MoneyLabel", Arrays.asList("本人将捐款港币$"));
					put("SalutationLabel", Arrays.asList("称谓"));
					put("Salutation", Arrays.asList("先生", "太太", "女士", "小姐"));
					put("FirstNameLabel", Arrays.asList("名字"));
					put("LastNameLabel", Arrays.asList("姓氏"));
					put("CorrespondenceAddressLabel", Arrays.asList("通讯地址"));
					put("CountryLabel", Arrays.asList("国家 / 城市"));
					put("Country", Arrays.asList("不丹","中国","中非共和国","丹麦","乍得","也门","亚美尼亚","以色列","伊拉克","伊朗伊斯兰共和国","俄罗斯联邦","保加利亚","克罗埃西亚/赫尔瓦次卡","冰岛","列支敦斯","利比亚","刚果共和国","刚果民主共和国","加彭","加拿大","加那利群岛","匈牙利","北马里亚纳群岛","南乔治亚","南极洲","南苏丹","南非","博内尔岛、圣尤斯特歇斯岛及萨巴岛","卡塔尔","印尼","印度","厄利垂亚","厄瓜多尔","古巴","可可群岛","台湾","吉布提","吉尔吉斯","吉里巴斯","吐瓦鲁","哈萨克斯坦","哥伦比亚","哥德普洛","哥斯大黎加","喀麦隆","土库曼","土耳其","圭亚那","坦桑尼亚","埃及","塔吉克","塞内加尔","塞尔维亚","塞锡尔群岛","墨西哥","多哥","多明尼加","多明尼加共和国","奈及利亚","奥地利","委内瑞拉","孟加拉共和国","安哥拉","安圭拉","安提瓜和巴布达","安道尔","宏都拉斯","密克罗尼西亚，联邦州","尼加拉瓜","尼日","尼泊尔","巴勒斯坦国","巴哈马","巴基斯坦","巴布亚新几内亚","巴拉圭","巴拿马","巴林","巴西","巴贝多","布吉那法索","布威岛","希腊","帛琉","几内亚","几内亚比绍","库拉索岛","德国","爱沙尼亚","爱尔兰","托克劳群岛","拉脱维亚","挪威","捷克","摩洛哥","摩尔多瓦共和国","摩纳哥","叙利亚","斐济","斯威士兰","斯洛伐克共和国","斯洛文尼亚","斯瓦尔巴和央麦恩群岛","斯里兰卡","新加坡","新喀里多尼亚","新西兰","日本","智利","曼岛","朝鲜人民民主共和国","东加","东帝汶","根息","格瑞纳达","格陵兰","格鲁吉亚","梵帝冈","模里西斯","比利时","毛里塔尼亚","汶莱","沃利斯和富图纳","沙地阿拉伯","法国","法国南方领地","法属圭亚那","法属玻里尼西亚","法罗群岛","波士尼亚赫塞哥维纳联邦","波多黎各","波札那","波兰","泰国","津巴布韦","海地","泽西岛","澳洲","澳门","乌克兰","乌干达","乌拉圭","乌兹别克斯坦","牙买加","特克斯和凯科斯群岛","特立尼达和多巴哥","狮子山","玻利维亚","瑞典","瑞士","瓜地马拉","甘比亚","留尼旺群岛","白俄罗斯","百慕达","皮特凯恩岛","卢安达","卢森堡","直布罗陀","福克兰群岛","科克群岛","科威特","科摩洛","科特迪瓦共和国","科索沃","秘鲁","突尼斯","立陶宛","约旦","纽威岛","索罗门群岛","索马利亚","维德角","维尔京群岛 (美国)","维尔京群岛 (英国)","缅甸","罗马尼亚","美国","美国外围小岛屿","美属萨摩亚群岛","义大利","老挝人民民主共和国","圣 皮埃尔和密克罗","圣吉斯和尼维斯","圣多美和普林西比","圣巴托洛缪岛","圣文森和格林纳丁斯","圣诞岛","圣赫勒拿岛","圣露西亚","圣马丁","圣马丁","圣马利诺","肯尼亚","芬兰","英国","英属印度洋领土","荷兰","莫桑比克","菲律宾共和国","万那杜","葡萄牙","蒙古","蒙特内哥罗","蒙特色拉特岛","蒲隆地","萨摩亚","萨尔瓦多","苏丹","苏里南","衣索比亚","西屋达及美利亚","西撒哈拉","西班牙","诺福克岛","诺鲁","贝南","贝里斯","赖比瑞亚","赖索托","赛浦路斯","赞比亚","赤道畿内亚","赫德和迈克唐纳岛","越南","迦纳","那米比亚","开曼群岛","关岛","阿塞拜疆","阿富汗","阿拉伯联合酋长国","阿曼","阿根廷","阿尔及利亚","阿尔巴尼亚","阿兰群岛","阿路巴","韩国","香港","马丁尼克岛","马来西亚","马其顿","马利","马拉威","马尔他","马尔地夫","马约特岛","马绍尔群岛","马达加斯加","高棉","黎巴嫩"));
					put("TelephoneLabel", Arrays.asList("联络电话"));
					put("EmailLabel", Arrays.asList("电邮"));
					put("NotificationLabel", Arrays.asList("本人 希望收到来自裕德堂有限公司的推广及宣传资讯。"));
					put("Notification", Arrays.asList("以电话短讯方式收取", "以电话方式收取", "以电邮方式收取", "以邮递方式收取"));
					
					
					put("CountcharactersintextareaNote", Arrays.asList("<span> 最多输入500个字符. 已输入字符数为 </span><div id='charNum'>0</div>"));
					put("ErrorMessage", Arrays.asList("信息不正确."));
				} 
			});
		}
	};
%>

<div class="full-wrapper clearfix"> 
    <div class="inner-wrapper">
        <div class="main-content-pos">            
            <div class="row-height">
                <div class="col-sm-height col-left"><span class="error-star">*</span> <%=formMap.get(lang).get("SalutationLabel").get(0) %></div>
                <div class="col-sm-height col-right">
                    <div class="radio-blk">                        
                        <%for (int i = 0; i < formMap.get(lang).get("Salutation").size(); i++) {%>                   						
                        	<input type="radio" <%= i==0 ? "checked" : "" %> name="salutation" value="<%=formMap.get(lang).get("Salutation").get(i) %>"> <%=formMap.get(lang).get("Salutation").get(i) %>
						<%}%>
                    </div>
                </div>
            </div>
            <div class="row-height">
                <div class="col-sm-height col-left"><span class="error-star">*</span> <%=formMap.get(lang).get("FirstNameLabel").get(0) %></div>
                <div class="col-sm-height col-right">
                    <input type="text" class="form" id="firstName">
                    <div class="error font-s errorfirstName">'<%=formMap.get(lang).get("FirstNameLabel").get(0) %>'<%=formMap.get(lang).get("ErrorMessage").get(0) %></div>
                </div>
            </div>
            <div class="row-height">
                <div class="col-sm-height col-left"><span class="error-star">*</span> <%=formMap.get(lang).get("LastNameLabel").get(0) %></div>
                <div class="col-sm-height col-right">
                    <input type="text" class="form" id="lastName">
                    <div class="error font-s errorlastName">'<%=formMap.get(lang).get("LastNameLabel").get(0) %>'<%=formMap.get(lang).get("ErrorMessage").get(0) %></div>
                </div>
            </div>

            <div class="row-height">
                <div class="col-sm-height col-left"><span class="error-star">*</span> <%=formMap.get(lang).get("CorrespondenceAddressLabel").get(0) %></div>
                <div class="col-sm-height col-right">
                    <textarea class="address" id="field"></textarea>
                    <div class="font-s"><%=formMap.get(lang).get("CountcharactersintextareaNote").get(0) %></div>
                    <div class="error font-s erroraddress">'<%=formMap.get(lang).get("CorrespondenceAddressLabel").get(0) %>'<%=formMap.get(lang).get("ErrorMessage").get(0) %></div>
                </div>
            </div>

            <div class="row-height">
                <div class="col-sm-height col-left"><span class="error-star">*</span> <%=formMap.get(lang).get("CountryLabel").get(0) %></div>
                <div class="col-sm-height col-right">
                   <select id="country">         				
                        <%for (int i = 0; i < formMap.get(lang).get("Country").size(); i++) {
                        	String country = formMap.get(lang).get("Country").get(i);
                        	String selected = "Hong Kong (SAR)".equals(country) || "香港".equals(country) ? "selected" : "";
                        %>
                        	<option <%=selected %> value="<%=country %>"><%=country %></option>	                    						
						<%}%>
                    </select>
                    <div class="error font-s errorcountry">'<%=formMap.get(lang).get("CountryLabel").get(0) %>'<%=formMap.get(lang).get("ErrorMessage").get(0) %></div>
                </div>
            </div>
            
            <div class="row-height">
                <div class="col-sm-height col-left"><span class="error-star">*</span> <%=formMap.get(lang).get("TelephoneLabel").get(0) %></div>
                <div class="col-sm-height col-right">
                    <input type="text" class="form" id="telephone">
                    <div class="error font-s errortelephone">'<%=formMap.get(lang).get("TelephoneLabel").get(0) %>'<%=formMap.get(lang).get("ErrorMessage").get(0) %></div>
                </div>
            </div>
            
            <div class="row-height">
                <div class="col-sm-height col-left"><span class="error-star">*</span> <%=formMap.get(lang).get("EmailLabel").get(0) %></div>
                <div class="col-sm-height col-right">
                    <input type="text" class="form" id="email">
                    <div class="error font-s erroremail">'<%=formMap.get(lang).get("EmailLabel").get(0) %>'<%=formMap.get(lang).get("ErrorMessage").get(0) %></div>
                </div>
            </div>

            <div class="row-height">
                <div class="col-sm-height col-left"> <%=formMap.get(lang).get("NotificationLabel").get(0) %></div>
                <div class="col-sm-height col-right">                                        
					<%for (int i = 0; i < formMap.get(lang).get("Notification").size(); i++) {%>
	                    <div class="checkbox-blk">
	                        <input class="checkbox" name="notification" type="checkbox" value="<%=formMap.get(lang).get("Notification").get(i) %>"><%=formMap.get(lang).get("Notification").get(i) %>
	                    </div>							
					<%}%>
                </div>
            </div>
            <div class="row-height">
                <div class="col-sm-height col-left"><span class="error-star">*</span> <%=formMap.get(lang).get("MoneyLabel").get(0) %></div>
                <div class="col-sm-height col-right">
                    <input type="text" class="form" id="amount">
                    <div class="error font-s erroramount">'<%=formMap.get(lang).get("MoneyLabel").get(0) %>'<%=formMap.get(lang).get("ErrorMessage").get(0) %></div>
                </div>
            </div>  
			<br/>
        	<input style="float:right" type="image" src="${ Content }/images/paypal.jpg" id="submit" alt="PayPal – The safer, easier way to pay online!"/>
        </div>
        <!-- https://www.paypal.com" -->
		<form id="paypalForm" action="https://www.sandbox.paypal.com/cgi-bin/webscr" method="post" target="_blank">
			<input type="hidden" name="cmd" value="_xclick"/>							
			<input type="hidden" name="business" value="<%=CmsProperties.getValue("Merchant_ID") %>"/>
			<input type='hidden' name='lc' value='HK'/>
			<input type="hidden" name="item_name" value="Edeas Donation"/>
			<input type="hidden" name="button_subtype" value="services"/>
			<input type="hidden" name="no_note" value="1"/>
			<input type="hidden" name="no_shipping" value="1"/>
			<input type="hidden" name="rm" value="1"/>
			<input type="hidden" name="cbt" value="Click here to complete the payment process."/>
			<input type="hidden" id="ppok" name="return" value="<%=CmsProperties.getHost() %>/common/donationsuccess"/>
			<input type="hidden" id="ppfail" name="cancel_return" value="<%=CmsProperties.getHost() %>/common/donationfail"/>
			<input type="hidden" name="currency_code" value="HKD"/>
			<input type="hidden" name="bn" value="PP-BuyNowBF:btn_paynow_LG.gif:NonHosted"/>
			<input type="hidden" id="ppid" name="item_number" value="" />
			<input type="hidden" id="ppamt" name="amount" value=""/>						
		</form>
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
	    $("#submit").click(function() {
	    	$("div.error").hide();
	    	var notificationElements = $("input[name='notification']:checked");
	    	var notifications = new Array();
	    	for(var i = 0; i < notificationElements.length; i++) {
	    		notifications.push(notificationElements.eq(i).val());
	    	}
			$.post(
	    		"<%=Global.getWebUrl() %>/common/donation",
	    		{
	    			"salutation": $("input[name='salutation']:checked").val(),	    		
	    			"firstName": $.trim($("#firstName").val()),	    		
	    			"lastName": $.trim($("#lastName").val()),
	    			"address": $.trim($("textarea.address").val()),
	    			"country": $.trim($("#country").val()),
	    			"telephone": $.trim($("#telephone").val()),
	    			"email": $.trim($("#email").val()),
	    			"notification": notifications.join(","),
	    			"amount": $.trim($("#amount").val())
    			},	    		
				function(data) {
			        if (data.success) {	
			        	
			        	$("#ppamt").val($.trim($("#amount").val()));
			        	$("#ppid").val(data.successMsg);
			        	$("#paypalForm").submit();	
			        } else {
			        	var errorFields = data.errorMsg.split(",");
			        	for(var i = 0; i < errorFields.length; i++) {
			        		$("div.error" + errorFields[i]).show();
			        	}
			        }
    			}
	        );
	    });
	});
</script>