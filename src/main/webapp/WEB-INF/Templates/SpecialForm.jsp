<%@include file="/WEB-INF/Shared/commons.jsp" %>
<%@page import="org.dom4j.Element"%>
<%@page contentType="text/html;charset=UTF-8"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.edeas.utils.XmlUtils"%>
<%@page import="org.dom4j.Document"%>
<%@page import="com.edeas.service.impl.QueryServiceImpl"%>
<%@page import="com.edeas.web.InitServlet"%>
<%@page import="com.edeas.model.*"%>
<link href="${Content}/css/form-step/special-form.css" rel="stylesheet" type="text/css" />
<link href="${Content}/css/form-step/component.css" rel="stylesheet" type="text/css" />
<link href="${Content}/css/form-text-effect.css" rel="stylesheet" type="text/css" />
<link href="${Content}/css/form-custom-input.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="${Script}/form-step/modernizr.custom.js"></script>

<style>
	.nl-submit:before {    
	    height: 46px;
	}
</style>

<div class="full-wrapper clearfix form bg-red"> 
    <div class="inner-wrapper">
        <div class="main-form-pos">
            <h2 class="txt-white">Minimal Form Interface<br/>
                Simplistic, single input view form</h2>
            <hr/>
            <section class="pos">
                <form id="theForm" class="simform" autocomplete="off">
                    <div class="simform-inner">
                        <ol class="questions">
                            <li>
                                <span><label for="q1">What's your favorite movie?</label></span>
                                <input id="q1" name="q1" type="text"/>
                            </li>
                            <li>
                                <span><label for="q2">Where do you live?</label></span>
                                <input id="q2" name="q2" type="text"/>
                            </li>
                            <li>
                                <span><label for="q3">What time do you got to work?</label></span>
                                <input id="q3" name="q3" type="text"/>
                            </li>
                            <li>
                                <span><label for="q4">How do you like your veggies?</label></span>
                                <input id="q4" name="q4" type="text"/>
                            </li>
                            <li>
                                <span><label for="q5">What book inspires you?</label></span>
                                <input id="q5" name="q5" type="text"/>
                            </li>
                            <li>
                                <span><label for="q6">What's your profession?</label></span>
                                <input id="q6" name="q6" type="text"/>
                            </li>
                        </ol><!-- /questions -->
                        <button class="submit" type="submit">Send answers</button>
                        <div class="controls">
                            <button class="next"></button>
                            <div class="progress"></div>
                            <span class="number">
                                <span class="number-current"></span>
                                <span class="number-total"></span>
                            </span>
                            <span class="error-message"></span>
                        </div><!-- / controls -->
                    </div><!-- /simform-inner -->
                    <span class="final-message"></span>
                </form><!-- /simform -->            
            </section>
        </div>
    </div>
</div>

<div class="full-wrapper clearfix form bg-teal"> 
    <div class="inner-wrapper">
        <div class="main-form-pos">
            <h2 class="txt-white">Text Input Effects<br/>
                Simple ideas for enhancing text input interactions</h2>
            <hr/>
            <section class="pos text-effect">
               <div class="form2-style">Hello,
               I am
                <span class="input input--ruri">
                    <input class="input__field input__field--ruri" type="text" id="input-26" />
                    <label class="input__label input__label--ruri" for="input-26">
                        <span class="input__label-content input__label-content--ruri">Username</span>
                    </label>
                </span>and my email is 
                <span class="input input--ruri">
                    <input class="input__field input__field--ruri" type="text" id="input-27" />
                    <label class="input__label input__label--ruri" for="input-27">
                        <span class="input__label-content input__label-content--ruri">Website</span>
                    </label>
                </span>
                </div>

                <div id="nl-form" class="nl-form">
                    <span>I feel to eat </span>
                    <select>
                        <option value="1" selected>any food</option>
                        <option value="2">Indian</option>
                        <option value="3">French</option>
                        <option value="4">Japanese</option>
                        <option value="2">Italian</option>
                    </select>
                    <br />in a
                    <select>
                        <option value="1" selected>standard</option>
                        <option value="2">fancy</option>
                        <option value="3">hip</option>
                        <option value="4">traditional</option>
                        <option value="2">romantic</option>
                    </select>
                    restaurant
                    <br />at 
                    <select>
                        <option value="1" selected>anytime</option>
                        <option value="1">7 p.m.</option>
                        <option value="2">8 p.m.</option>
                        <option value="3">9 p.m.</option>
                    </select>
                    in <input type="text" value="" placeholder="any location" data-subline="For example: <em>Hong Kong Island</em> or <em>Kowloon</em>"/>
                    <div class="nl-submit-wrap">
                        <button class="nl-submit" type="submit">Submit</button>
                    </div>
                    <div class="nl-overlay"></div>
                </div>
            </section>
        </div>

    </div>
</div>
 
<script type="text/javascript" src="${Script}/form-step/classie.js"></script>
<script type="text/javascript" src="${Script}/form-step/stepsForm.js"></script>
<script type="text/javascript" src="${Script}/form-text-input/classie.js"></script>
<script type="text/javascript" src="${Script}/form-custom-input/nlform.js"></script>
<script>
   var theForm = document.getElementById( 'theForm' );

   new stepsForm( theForm, {
       onSubmit : function( form ) {
           // hide form
           classie.addClass( theForm.querySelector( '.simform-inner' ), 'hide' );

           /*
           form.submit()
           or
           AJAX request (maybe show loading indicator while we don't have an answer..)
           */

           // let's just simulate something...
           var messageEl = theForm.querySelector( '.final-message' );
           messageEl.innerHTML = 'Thank you! We\'ll be in touch.';
           classie.addClass( messageEl, 'show' );
       }
   } );

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

       [].slice.call( document.querySelectorAll( 'input.input__field' ) ).forEach( function( inputEl ) {
           // in case the input is already filled..
           if( inputEl.value.trim() !== '' ) {
               classie.add( inputEl.parentNode, 'input--filled' );
           }

           // events:
           inputEl.addEventListener( 'focus', onInputFocus );
           inputEl.addEventListener( 'blur', onInputBlur );
       } );

       function onInputFocus( ev ) {
           classie.add( ev.target.parentNode, 'input--filled' );
       }

       function onInputBlur( ev ) {
           if( ev.target.value.trim() === '' ) {
               classie.remove( ev.target.parentNode, 'input--filled' );
           }
       }
   })();

   var nlform = new NLForm( document.getElementById( 'nl-form' ) );
   
   function isIE9() {
       return (navigator.userAgent.indexOf('MSIE 9')!==-1);
   }
   function isIE() {
       return (navigator.userAgent.indexOf('MSIE')!==-1 || navigator.appVersion.indexOf('Trident/') > 0);
   }
   $(function(){
       if(isIE9()){
          $("body").append("\
            <style>\n\
            .questions input{\n\
                padding: 0.5em 0em 0.5em 0.7em;\n\
                width: calc(100% - 2.7em)\n\
            }\n\
            </style>");
       }
       if(isIE()){
           $("body").append("\
            <style>\n\
            .simform button.next{\n\
                top: calc(50% - 0.5em);\n\
            }\n\
            </style>");
       }
   });
   
</script>
 