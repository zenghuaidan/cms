<%@include file="/WEB-INF/Shared/commons.jsp"%>
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
<link href="${Content}/css/form-step/special-form.css" rel="stylesheet"
	type="text/css" />
<link href="${Content}/css/form-step/component.css" rel="stylesheet"
	type="text/css" />
<link href="${Content}/css/form-text-effect.css" rel="stylesheet"
	type="text/css" />
<link href="${Content}/css/form-custom-input.css" rel="stylesheet"
	type="text/css" />

<script type="text/javascript"
	src="${Script}/form-step/modernizr.custom.js"></script>
<%
	boolean iscms = (Boolean) request.getAttribute("iscms");
	String lang = (String) request.getAttribute("lang");
	Map<String, Map<String, List<String>>> formMap = new HashMap<String, Map<String, List<String>>>() {
		{
			put("en", new HashMap<String, List<String>>() {
				{
					put("Form1", Arrays.asList("Simplistic, single input view form"));
					put("QuestionFormOptions", Arrays.asList("What's your favorite movie?", "Where do you live?", "What time do you got to work?", "How do you like your veggies?", "What book inspires you?", "What's your profession?", "What's your email?"));
					put("SendAnswers", Arrays.asList("Send answers"));
					put("Form2", Arrays.asList("Text Input Effects<br/>Simple ideas for enhancing text input interactions"));
					put("Form2Text1", Arrays.asList("Hello, I am"));
					put("Form2Text2", Arrays.asList("Username"));
					put("Form2Text3", Arrays.asList("and my email is"));
					put("Form2Text4", Arrays.asList("Email"));
					put("Form2Text5", Arrays.asList("I feel to eat"));
					put("Form2Text6", Arrays.asList("in a"));
					put("Form2Text7", Arrays.asList("restaurant<br />at "));
					put("Form2Text8", Arrays.asList("in"));
					put("Form2Text9", Arrays.asList("any location"));
					put("Form2Text10", Arrays.asList("For example: <em>Hong Kong Island</em> or <em>Kowloon</em>"));
					put("Form2Option1", Arrays.asList("any food", "Indian", "French", "Japanese", "Italian"));
					put("Form2Option2", Arrays.asList("standard", "fancy", "hip", "traditional", "romantic"));
					put("Form2Option3", Arrays.asList("anytime", "7 p.m.", "8 p.m.", "9 p.m."));
					put("Submit", Arrays.asList("Submit"));
					put("ThankYou", Arrays.asList("Thank you! We'll be in touch."));
				}
			});
			put("tc", new HashMap<String, List<String>>() {
				{
					put("Form1", Arrays.asList("簡單美觀輸入框"));
					put("QuestionFormOptions", Arrays.asList("你最喜歡哪部電影?", "你居住在何處?", "你的工作時間是什麼?", "你如何看待素食主義者", "什麼書最能激勵你?", "你最擅長那個方面?", "你的電郵是?"));
					put("SendAnswers", Arrays.asList("提交答案"));
					put("Form2", Arrays.asList("请求繁体翻译"));
					put("Form2Text1", Arrays.asList("您好, 我是"));
					put("Form2Text2", Arrays.asList("用戶名"));
					put("Form2Text3", Arrays.asList("我的電郵是"));
					put("Form2Text4", Arrays.asList("電郵"));
					put("Form2Text5", Arrays.asList("我想吃"));
					put("Form2Text6", Arrays.asList("在一間"));
					put("Form2Text7", Arrays.asList("餐廳<br />時間是 "));
					put("Form2Text8", Arrays.asList("位置在"));
					put("Form2Text9", Arrays.asList("任何地點"));
					put("Form2Text10", Arrays.asList("例如: <em>香港島</em> 或者  <em>九龍</em>"));
					put("Form2Option1", Arrays.asList("任何類型食物", "印度餐", "法國餐", "日本餐", "意大利餐"));
					put("Form2Option2", Arrays.asList("標準的", "奇幻的", "時尚的", "傳統的", "浪漫的"));
					put("Form2Option3", Arrays.asList("任何時候", "下午七點", "下午八點", "下午九點"));
					put("Submit", Arrays.asList("提交"));
					put("ThankYou", Arrays.asList("謝謝！我們会与您繼續保持聯繫。"));
				}
			});
			put("sc", new HashMap<String, List<String>>() {
				{
					put("Form1", Arrays.asList("简单美观输入框"));
					put("QuestionFormOptions", Arrays.asList("你最喜欢哪部电影?", "你居住在何处?", "你的工作时间是什麽?", "你如何看待素食主义者", "什麽书最能激励你?", "你最擅长那个方面?", "你的电邮是?"));
					put("SendAnswers", Arrays.asList("提交答桉"));
					put("Form2", Arrays.asList("请求简体翻译"));
					put("Form2Text1", Arrays.asList("您好, 我是"));
					put("Form2Text2", Arrays.asList("用户名"));
					put("Form2Text3", Arrays.asList("我的电邮是"));
					put("Form2Text4", Arrays.asList("电邮"));
					put("Form2Text5", Arrays.asList("我想吃"));
					put("Form2Text6", Arrays.asList("在一间"));
					put("Form2Text7", Arrays.asList("餐厅<br />时间是 "));
					put("Form2Text8", Arrays.asList("位置在"));
					put("Form2Text9", Arrays.asList("任何地点"));
					put("Form2Text10", Arrays.asList("例如: <em>香港岛</em> 或者  <em>九龙</em>"));
					put("Form2Option1", Arrays.asList("任何类型食物", "印度餐", "法国餐", "日本餐", "意大利餐"));
					put("Form2Option2", Arrays.asList("标准的", "奇幻的", "时尚的", "传统的", "浪漫的"));
					put("Form2Option3", Arrays.asList("任何时候", "下午七点", "下午八点", "下午九点"));
					put("Submit", Arrays.asList("提交"));
					put("ThankYou", Arrays.asList("谢谢！我们会与您继续保持联系"));
				}
			});
		}
	};
%>
<style>
.nl-submit:before {
	height: 46px;
}
</style>

<div class="full-wrapper clearfix form bg-red">
	<div class="inner-wrapper">
		<div class="main-form-pos">
			<h2 class="txt-white"><%=formMap.get(lang).get("Form1").get(0)%></h2>
			<hr />
			<section class="pos">
				<form id="theForm" class="simform" autocomplete="off">
					<div class="simform-inner">
						<ol class="questions">
							<%
								for (int i = 0; i < formMap.get(lang).get("QuestionFormOptions").size(); i++) {
							%>
							<li><span><label for="q<%=i + 1%>"><%=formMap.get(lang).get("QuestionFormOptions").get(i)%></label></span>
								<input id="q<%=i + 1%>" name="q<%=i + 1%>" type="text" /></li>
							<%
								}
							%>
						</ol>
						<!-- /questions -->
						<button class="submit" type="submit"><%=formMap.get(lang).get("SendAnswers").get(0)%></button>
						<div class="controls">
							<button class="next"></button>
							<div class="progress"></div>
							<span class="number"> <span class="number-current"></span>
								<span class="number-total"></span>
							</span> <span class="error-message"></span>
						</div>
						<!-- / controls -->
					</div>
					<!-- /simform-inner -->
					<span class="final-message"></span>
				</form>
				<!-- /simform -->
			</section>
		</div>
	</div>
</div>

<div class="full-wrapper clearfix form bg-teal">
	<div class="inner-wrapper">
		<div class="main-form-pos">
			<h2 class="txt-white"><%=formMap.get(lang).get("Form2").get(0)%></h2>
			<hr />
			<section class="pos text-effect">
				<div class="form2-style"><%=formMap.get(lang).get("Form2Text1").get(0)%>
					<span class="input input--ruri"> 
						<input class="input__field input__field--ruri" type="text" id="name" />
						<label class="input__label input__label--ruri" for="name">
							<span class="input__label-content input__label-content--ruri"><%=formMap.get(lang).get("Form2Text2").get(0)%></span>
						</label>
					</span><%=formMap.get(lang).get("Form2Text3").get(0)%>
					<span class="input input--ruri"> 
						<input class="input__field input__field--ruri" type="text" id="email" />
						<label class="input__label input__label--ruri" for="email">
							<span class="input__label-content input__label-content--ruri"><%=formMap.get(lang).get("Form2Text4").get(0)%></span>
						</label>
					</span>
				</div>

				<div id="nl-form" class="nl-form">
					<span><%=formMap.get(lang).get("Form2Text5").get(0)%> </span> 
					<select id="food">
						<%
							for (int i = 0; i < formMap.get(lang).get("Form2Option1").size(); i++) {
						%>
						<option value="<%=formMap.get(lang).get("Form2Option1").get(i)%>" <%=i == 0 ? "selected" : ""%>><%=formMap.get(lang).get("Form2Option1").get(i)%></option>
						<%
							}
						%>
					</select> <br /><%=formMap.get(lang).get("Form2Text6").get(0)%>
					<select id="restaurant">
						<%
							for (int i = 0; i < formMap.get(lang).get("Form2Option2").size(); i++) {
						%>
						<option value="<%=formMap.get(lang).get("Form2Option2").get(i)%>" <%=i == 0 ? "selected" : ""%>><%=formMap.get(lang).get("Form2Option2").get(i)%></option>
						<%
							}
						%>
					</select>
					<%=formMap.get(lang).get("Form2Text7").get(0)%>
					<select id="time">
						<%
							for (int i = 0; i < formMap.get(lang).get("Form2Option3").size(); i++) {
						%>
						<option value="<%=formMap.get(lang).get("Form2Option3").get(i)%>" <%=i == 0 ? "selected" : ""%>><%=formMap.get(lang).get("Form2Option3").get(i)%></option>
						<%
							}
						%>
					</select>
					<%=formMap.get(lang).get("Form2Text8").get(0)%>
					<input id="location" type="text" value=""
						placeholder="<%=formMap.get(lang).get("Form2Text9").get(0)%>"
						data-subline="<%=formMap.get(lang).get("Form2Text10").get(0)%>" />
					<div class="nl-submit-wrap">
						<button class="nl-submit" type="submit"><%=formMap.get(lang).get("Submit").get(0)%></button>
					</div>
					<div class="nl-overlay">sdfsfdsfsdfsd</div>
				</div>
			</section>
		</div>

	</div>
</div>

<script type="text/javascript" src="${Script}/form-step/classie.js"></script>
<script type="text/javascript" src="${Script}/form-step/stepsForm.js"></script>
<script type="text/javascript"
	src="${Script}/form-text-input/classie.js"></script>
<script type="text/javascript"
	src="${Script}/form-custom-input/nlform.js"></script>
<script>
	$(".nl-submit").click(function() {
	    var email = $.trim($("#email").val());
	    if(email == "") {
	    	alert("Email is mandatory");
	    	return;
	    }
		$.post(
	    		"<%=Global.getWebUrl() %>/common/form2",
	    		{
	    			"lang": "<%=lang%>",	    		
	    			"name": $.trim($("#name").val()),	    		
	    			"email": email,
	    			"food": $.trim($("#food").val()),
	    			"restaurant": $.trim($("#restaurant").val()),
	    			"time": $.trim($("#time").val()),
	    			"location": $.trim($("#location").val())
    			},	    		
				function(data) {
			        if (data.success) {		          
			        	alert("Submit Successfully!");			
			        } else alert(data.errorMsg);
    			}
	        );
	});

	var theForm = document.getElementById('theForm');

	new stepsForm(theForm, {
		onSubmit : function(form) {
			// hide form
			classie.addClass(theForm.querySelector('.simform-inner'), 'hide');

			/*
			form.submit()
			or
			AJAX request (maybe show loading indicator while we don't have an answer..)
			 */

			// let's just simulate something...			
		    $.post(
	    		"<%=Global.getWebUrl() %>/common/form1",
	    		{
	    			"lang": "<%=lang%>",	    		
	    			"a1": $.trim($("#q1").val()),	    		
	    			"a2": $.trim($("#q2").val()),
	    			"a3": $.trim($("#q3").val()),
	    			"a4": $.trim($("#q4").val()),
	    			"a5": $.trim($("#q5").val()),
	    			"a6": $.trim($("#q6").val()),
	    			"a7": $.trim($("#q7").val())
    			},	    		
				function(data) {
			        if (data.success) {		          
						var messageEl = theForm.querySelector('.final-message');
						messageEl.innerHTML = "<%=formMap.get(lang).get("ThankYou").get(0)%>";
						classie.addClass(messageEl, 'show');
			        } else alert(data.errorMsg);
    			}
	        );
			
		}
	});

	(function() {
		// trim polyfill : https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/Trim
		if (!String.prototype.trim) {
			(function() {
				// Make sure we trim BOM and NBSP
				var rtrim = /^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g;
				String.prototype.trim = function() {
					return this.replace(rtrim, '');
				};
			})();
		}

		[].slice.call(document.querySelectorAll('input.input__field')).forEach(
				function(inputEl) {
					// in case the input is already filled..
					if (inputEl.value.trim() !== '') {
						classie.add(inputEl.parentNode, 'input--filled');
					}

					// events:
					inputEl.addEventListener('focus', onInputFocus);
					inputEl.addEventListener('blur', onInputBlur);
				});

		function onInputFocus(ev) {
			classie.add(ev.target.parentNode, 'input--filled');
		}

		function onInputBlur(ev) {
			if (ev.target.value.trim() === '') {
				classie.remove(ev.target.parentNode, 'input--filled');
			}
		}
	})();

	var nlform = new NLForm(document.getElementById('nl-form'));

	function isIE9() {
		return (navigator.userAgent.indexOf('MSIE 9') !== -1);
	}
	function isIE() {
		return (navigator.userAgent.indexOf('MSIE') !== -1 || navigator.appVersion
				.indexOf('Trident/') > 0);
	}
	$(function() {
		if (isIE9()) {
			$("body")
					.append(
							"\
            <style>\n\
            .questions input{\n\
                padding: 0.5em 0em 0.5em 0.7em;\n\
                width: calc(100% - 2.7em)\n\
            }\n\
            </style>");
		}
		if (isIE()) {
			$("body")
					.append(
							"\
            <style>\n\
            .simform button.next{\n\
                top: calc(50% - 0.5em);\n\
            }\n\
            </style>");
		}
	});
</script>
