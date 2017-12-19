<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <!-- Basic Page Needs -->
    <meta charset="utf-8">
    <title>Edeas: Digital Consulting, Web Design, Corporate Intranet, Hong Kong</title>
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no, width=device-width" />
    <meta name="description" content="Edeas is an interactive agency in Hong Kong. We blend website strategy, design and technology innovations to create and sustain a successful digital experience." />
    <meta name="keywords" content="Hong Kong website design,corporate website,intranet,user experience,user interface,custom web application, interface" />
    
    <%@ include file="/WEB-INF/public/commons.jspf" %>
    
    <!-- Favicons -->
    <link rel="shortcut icon" href="<%=request.getContextPath()%>/resources/Content/images/favicon.png" />
    <link rel="apple-touch-icon" href="<%=request.getContextPath()%>/resources/Content/images/apple-touch-icon.png" />
    <link rel="apple-touch-icon" sizes="72x72" href="<%=request.getContextPath()%>/resources/Content/images/apple-touch-icon-72x72.png" />
    <link rel="apple-touch-icon" sizes="114x114" href="<%=request.getContextPath()%>/resources/Content/images/apple-touch-icon-114x114.png" />

    <!-- FONTS -->
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/Content/css/font-awesome/css/font-awesome.min.css" />
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/Content/css/glyphicons/style.min.css" />
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/resources/Content/css/cms-cover.css" />    

    <style>
		html #body.cms-cover .header 		{ background-color:#fff}
		html #body.cms-cover .login-blk		{ background: #ececec url("/resources/Content/images/bg-cms-cover-musicus.jpg") center center no-repeat; background-size:cover;}
		.input__label--ruri::after,
		.input--filled .input__label--ruri::after  { background-color:#b20838}
		html #body.cms-cover .btn-login .login-bg  { background-color:#b20838}
		html #body.cms-cover .btn-login:hover      { background-color:#5a021b; }

		html #body.cms-cover footer { color:#ececec}
		html #body .error 			{ background-color:#ed7b35; border-top:2px solid #fb995e; display:none;
									-webkit-box-shadow: 3px 3px 0px 0px rgba(20, 20, 20, 0.10);
									   -moz-box-shadow: 3px 3px 0px 0px rgba(20, 20, 20, 0.10);
											box-shadow: 3px 3px 0px 0px rgba(20, 20, 20, 0.10);}
		html #body.cms-cover .header img  { width:auto; height:70px}

		@@media only screen and (max-width:667px) {
		html #body .header .div-table .row2 .r2-pos { background-color:#ececec; color: #666}
		html #body.cms-cover .header img  { width:auto; height:70px;}
		}
    </style>

    <title>edeas</title>
</head>
<body id="body" class="cms-cover">
    <div class="header">
        <div class="div-table">
            <div class="row1">
                <div class="r1-pos">
                    <img src="<%=request.getContextPath()%>/resources/Content/cms/core/images/logo-musicus.png" class="img-scale" />
                </div>
            </div>
            <div class="row2"><div class="r2-pos">Content Management System</div></div>
        </div>
    </div>
    <form>
        <div class="login-blk">
            <div class="login">
                <div class="intro-blk">
                    <div class="font-l">Sign Up</div>
                    <div class="intro">
                        To use the application and get access to the content, sign in by your account or use the login data you have recently received in your invitation.
                    </div>
                    <section class="text-effect pos">
                        <span class="input input--ruri">
                            @Html.TextBoxFor(m => m.UserName, new { @class = "input__field input__field--ruri", @id= "input-26" })
                            <label class="input__label input__label--ruri" for="input-26">
                                <span class="input__label-content input__label-content--ruri"><i class="fa fa-user"></i> Username</span>
                            </label>
                        </span>
                        <span class="input input--ruri">
                            @Html.PasswordFor(m => m.Password, new { @class = "input__field input__field--ruri", @id = "input-27" })                            
                            <label class="input__label input__label--ruri" for="input-27">
                                <span class="input__label-content input__label-content--ruri"><i class="fa fa-lock"></i> Password</span>
                            </label>
                        </span>
                    </section>
                    <div class="forget-password-blk">
                        <a href="#" class="forget-password"><i class="fa fa-question-circle"></i> Forget Password</a>
                    </div>
                </div>
                <div class="btn-login">
                    <div class="login-field" onclick="E$('loginform').submit();">@vhelp.renderResource(Html, "Login") <i class="fa fa-angle-right"></i></div>
                    <div class="login-bg">&nbsp;</div>
                </div>
                <div class="error">
                    <ul>
                        <li><i class="fa fa-warning"></i>Please enter a valid username</li>
                        <li><i class="fa fa-warning"></i>Please enter a valid password</li>
                    </ul>
                </div>
            </div>

            <footer>Developed by © edeas Limited</footer>
        </div>
    </form>
    <script type="text/javascript" src="@vhelp.js(Url,"classie.js")"></script>
    <script src="//code.jquery.com/jquery-1.11.3.min.js" type="text/javascript"></script>
    <script src="@Url.Content("~/Scripts/cms/jquery.validate.min.js")" type="text/javascript"></script>
    <script src="@Url.Content("~/Scripts/cms/common.js")" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#input-26, #input-27').bind('keypress', function (event) {
                if (event.keyCode == "13")
                    E$('loginform').submit();
            });
        });
    </script>
    <script>
        (function () {
            // trim polyfill : https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/Trim
            if (!String.prototype.trim) {
                (function () {
                    // Make sure we trim BOM and NBSP
                    var rtrim = /^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g;
                    String.prototype.trim = function () {
                        return this.replace(rtrim, '');
                    };
                })();
            }

            [].slice.call(document.querySelectorAll('input.input__field')).forEach(function (inputEl) {
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
    </script>
</body>
</html>

