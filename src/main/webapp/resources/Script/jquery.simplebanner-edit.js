;(function($,win){
    'use strict';

    /**
     * Simple Banner constructor
     * @param element
     * @param options
     * @constructor
     */
    var Simplebanner = function(element,options){
        this.element = element;
        this._paused = false;
        this._timer = {};
        this._currentBanner = {};
        this._newBanner = {};
        this._bannerWidth = 0;
        this._bannerCount = 0;
        this.options = $.extend({
            arrows:true,
            indicators:true,
            pauseOnHover:true,
            autoRotate:true,
            maxRotations: null,
            rotateTimeout:5000,
            animTime:300
        },options);

        this.init();
    };

    /**
     * Initializer
     */
    Simplebanner.prototype.init = function(){
        var $banners = this.element.find('.bannerList li');
		var bannerdetails = $('.banner .bannerdetails');
        this._bannerCount = $banners.length;
		var allwidth = this._bannerCount*100;
		var eachwidth = Math.floor((100 / this._bannerCount)*100)/100;
		this.element.find('ul.bannerList').width(allwidth+"%");
		this.element.find('ul.bannerList > li').width(eachwidth+"%");
        /* this._bannerWidth = $('.banner').width(); */
        this._rotationCount = 0;

        /* if(!this._bannerWidth){
            this._bannerWidth = this.element.width();
        } */
        this._currentBanner = $banners.first().addClass('current');

        if(this.options.indicators){
            this.buildIndicators();
        } else {
            this.element.addClass('hiddenIndicators');
        }
        if(!this.options.arrows){
			console.log("hdar");
            this.element.addClass('hiddenArrows');
        }
        if(this._bannerCount > 1 && this.options.autoRotate){
            this.toggleTimer();
        }

        this.bindEvents();
    };

    /**
     * This sets the basic events based off the options selected
     */
    Simplebanner.prototype.bindEvents = function(){
        var self = this;
        if(self.options.indicators){
            self.element.find('.bannerIndicator').on({
                'click':function(){
                    var $this = $(this);
                    if(!$this.hasClass('active')){
                        var slideIndex = $this.index();
                        self._newBanner = self.element.find('.bannerList li:eq(' + slideIndex + ')');
                        self.goToBanner(slideIndex);
                    }
                }
            });
        }
		
		/* next prev swipe */
		/* self.element.swipe( {
				swipe:function(event, direction, distance, duration, fingerCount, fingerData) {
				  direction == "left" ? self.previousBanner() : self.nextBanner();
				  self.toggleTimer(false);
				},
			threshold:0,
			fingers:'all'
		}); */
			
        if(self.options.arrows){
            self.element.find('.bannerControlsWpr').on({
                'click':function(){
                    if($(this).hasClass('bannerControlsPrev')){
                        self.previousBanner();
                    } else {
                        self.nextBanner();
                    }
                }
            });
        }

        if(self.options.pauseOnHover && self.options.autoRotate){
            self.element.on({
                'mouseenter':function(){
                    self.toggleTimer(true);
                },
                'mouseleave':function(){
                    self.toggleTimer(false);
                }
            });
        }
    };

    /**
     * Goes to the next banner - loops back to the first banner
     */
    Simplebanner.prototype.nextBanner = function(){
        if(this._currentBanner.next().length){
            this._newBanner = this._currentBanner.next();
        } else {
            this._newBanner = this.element.find('.bannerList li:first');
            this._rotationCount++;
        }

        this.goToBanner(this._newBanner.index());
    };

    /**
     * Goes to the previous banner - loops back to the last banner
     */
    Simplebanner.prototype.previousBanner = function(){
        if(this._currentBanner.prev().length){
            this._newBanner = this._currentBanner.prev();
        } else {
            this._newBanner = this.element.find('.bannerList li:last');
        }

        this.goToBanner(this._newBanner.index());
    };

    /**
     * Goes to a specific slide - This is called by both the Previous and Next methods as well as the Indicator buttons
     * @param slideIndex
     */
    Simplebanner.prototype.goToBanner = function(slideIndex){
        var self = this;
		var ml = slideIndex*-100;
		var bannerdetails = $('.banner .bannerdetails');
		bannerdetails.find('.b-detail').removeClass('current');
		bannerdetails.find('.b-detail:eq(' + slideIndex + ')').addClass('current');
        self._currentBanner.removeClass('current');
        self.element.find('.bannerIndicators .current, .captions .current').removeClass('current');
        self._currentBanner = self._newBanner;
        self._currentBanner.addClass('current');
        self.element.find('.bannerIndicators li:eq(' + slideIndex + '), .captions .caption:eq(' + slideIndex + ')').addClass('current');
        self.element.find('.bannerList').stop(true,false).animate({
           // 'marginLeft':-slideIndex * self._bannerWidth
			'marginLeft':ml+"%"
        },self.options.animTime);
    };

    /**
     * Create the correct amount of indicators based off total banners
     */
    Simplebanner.prototype.buildIndicators = function(){
        var self = this;
        var indicatorUl = self.element.find('.bannerIndicators ul');
		var captions = self.element.find('.captions');
        self.element.find('.bannerList li').each(function(){
            indicatorUl.append('<li class="bannerIndicator"></li>');
			captions.append('<div class="caption"><span>'+$(this).attr("caption")+'</span></div>');
        });

        indicatorUl.find('li:first').addClass('current');
		captions.find('.caption:first').addClass('current');
    };

    /**
     * Starts or stops the timer for going to the next banner
     * @param timer
     */
    Simplebanner.prototype.toggleTimer = function(timer){
        var self = this;
        clearTimeout(self._timer);
        if(!timer && (this.options.maxRotations === null || this._rotationCount < this.options.maxRotations)){
            self._timer = setTimeout(function(){
                self.nextBanner();
                self.toggleTimer(false);
            },self.options.rotateTimeout);
        }
    };

    /**
     * jQuery wrapper method
     * @param options
     * @returns {boolean|jQuery}
     */
    $.fn.simplebanner = function(options){
        var method = false;
        var ret = false;
        var args = [];

        if(typeof options === 'string'){
            args = [].slice.call(arguments,0);
        }

        this.each(function(){
            var self = $(this);
            var instance = self.data('bannerInstance');

            if(!self.attr('id')){
                self.attr('id','simpleBanner-' + ($.fn.simplebanner._instances.length + 1));
            }

            if(instance && options){
                if(typeof options === 'object'){
                    ret = $.extend(instance.options,options);
                } else if(options === 'options'){
                    ret = instance.options;
                } else if(typeof instance[options] === 'function'){
                    ret = instance[options].apply(instance,args.slice(1));
                } else {
                    throw new Error('Simple Banner has no option/method named "' + method + '"');
                }
            } else {
                instance = new Simplebanner(self,options || {});
                self.data('bannerInstance',instance);
                $.fn.simplebanner._instances.push(instance);
            }
        });
        return ret || this;
    };

    $.fn.simplebanner._instances = [];
}(jQuery,window));