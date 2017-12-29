/**
 * main.js
 * http://www.codrops.com
 *
 * Licensed under the MIT license.
 * http://www.opensource.org/licenses/mit-license.php
 * 
 * Copyright 2016, Codrops
 * http://www.codrops.com
 */
;(function(window) {

	'use strict';

	var openCtrl3 = document.getElementById('btn-s-subscribe'),
		openCtrl4 = document.getElementById('btn-s-subscribe-m'),
		closeCtrl2 = document.getElementById('btn-s-subscribe-close'),
		subscribeContainer = document.querySelector('.s-subscribe'),
		inputSubscribe = subscribeContainer.querySelector('.s-subscribe__input'),
		form = document.querySelector('.s-subscribe__form'),
		formbtn = form.querySelector('.form-btn'),
		thanks = document.querySelector('.thanks-subscribe');

	function init() {
		initEvents();	
	}

	function initEvents() {
		openCtrl3.addEventListener('click', openSubscribe);
		openCtrl4.addEventListener('click', openSubscribe);
		closeCtrl2.addEventListener('click', closeSubscribe);
		formbtn.addEventListener('click', openThanks);
		document.addEventListener('keyup', function(ev) {
			// escape key.
			if( ev.keyCode == 27 ) {
				closeSubscribe();
			}
		});
	}
	
	function openSubscribe(){
		subscribeContainer.classList.add('s-subscribe--open');
		inputSubscribe.focus();
	}
	
	function closeSubscribe() {
		subscribeContainer.classList.remove('s-subscribe--open');
		thanks.classList.remove('open');
		$(form).delay(500).show(500);
		inputSubscribe.blur();
		inputSubscribe.value = '';
	}
	
	function openThanks(){
		$(form).hide();
		thanks.classList.add('open');
	}

	init();

})(window);