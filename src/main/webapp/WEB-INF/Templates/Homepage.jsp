<%@include file="/WEB-INF/Shared/commons.jsp" %>
<script type="text/javascript" src="${Plugin}/rs-plugin/js/jquery.themepunch.tools.min.js"></script>
<script type="text/javascript" src="${Plugin}/rs-plugin/js/jquery.themepunch.revolution.min.js"></script>
<script type="text/javascript" src="${Plugin}/rs-plugin/js/extensions/revolution.extension.video.min.js"></script>
<script type="text/javascript" src="${Plugin}/rs-plugin/js/extensions/revolution.extension.slideanims.min.js"></script>
<script type="text/javascript" src="${Plugin}/rs-plugin/js/extensions/revolution.extension.actions.min.js"></script>
<script type="text/javascript" src="${Plugin}/rs-plugin/js/extensions/revolution.extension.layeranimation.min.js"></script>
<script type="text/javascript" src="${Plugin}/rs-plugin/js/extensions/revolution.extension.kenburn.min.js"></script>
<script type="text/javascript" src="${Plugin}/rs-plugin/js/extensions/revolution.extension.navigation.min.js"></script>
<script type="text/javascript" src="${Plugin}/rs-plugin/js/extensions/revolution.extension.migration.min.js"></script>
<script type="text/javascript" src="${Plugin}/rs-plugin/js/extensions/revolution.extension.parallax.min.js"></script>
<script type="text/javascript" src="${Plugin}/rs-plugin/js/extensions/revolution.extension.carousel.min.js"></script>

<link rel='stylesheet' href='${Content}/css/index.css'>

<!-- Revolution Slider -->
<link rel="stylesheet" type="text/css" href="${Plugin}/rs-plugin/css/settings.css">
<link rel="stylesheet" type="text/css" href="${Plugin}/rs-plugin/css/layers.css">
<link rel="stylesheet" type="text/css" href="${Plugin}/rs-plugin/css/navigation.css">

<div id="promo" class="clearfix full-wrapper"> 
     <div class="inner-wrapper">
         <div class="main-index-pos">
             <div class="intro">
                 <h2>Lorem ipsum dolor</h2>
                 <h3>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor</h3>
                 <div>Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate.</div>
             </div>

             <div class="news">
                 <div class="news-pos">
                     <h2>Latest News</h2>
                     <div class="recent-posts">
                         <ul>
                             <li class="post">
                                 <a href="#">
                                     <div class="photo"><img src="images/demo-img-160x160.gif" class="img-scale" /></div>
                                     <div class="desc">
                                         <div class="post-intro">Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna </div>
                                         <div class="date">December 13, 2016</div>
                                     </div>
                                 </a>
                             </li>
                             <li class="post">
                                 <a href="#">
                                     <div class="photo"><img src="images/demo-img-160x160.gif" class="img-scale" /></div>
                                     <div class="desc">
                                         <div class="post-intro">Cumque nihil impedit quo minus id quod maxime placeat facere possimus.</div>
                                         <div class="date">November 13, 2016</div>
                                     </div>
                                 </a>
                             </li>
                         </ul>
                     </div>
                 </div>
             </div>

             <div class="links">
                 <div class="links-pos">
                     <h2>Quick Links</h2>
                     <ul>
                         <a href="#"><li>Suspendisse a pellentesque dui</li></a>
                         <a href="#"><li>Quisque lorem tortor fringilla sed</li></a>
                         <a href="#"><li>Et harum quidem rerum facilis</li></a>
                         <a href="#"><li>Nulla ipsum dolor lacus suscipit</li></a>
                     </ul>
                 </div>
             </div>
             <div class="clear"></div>
         </div>
     </div>
 </div>

<script type="text/javascript">
    var tpj = jQuery;

    var revapi206;
    tpj(document).ready(function() {
        if (tpj("#rev_slider_206_1").revolution == undefined) {
            revslider_showDoubleJqueryError("#rev_slider_206_1");
        } else {
            revapi206 = tpj("#rev_slider_206_1").show().revolution({
                sliderType: "standard",
                jsFileLocation: "../../revolution/js/",
                sliderLayout: "fullscreen",
                dottedOverlay: "none",
                delay: 9000,
                navigation: {
                    keyboardNavigation: "off",
                    keyboard_direction: "horizontal",
                    mouseScrollNavigation: "off",
                    onHoverStop: "off",
                    touch: {
                        touchenabled: "on",
                        swipe_threshold: 75,
                        swipe_min_touches: 50,
                        swipe_direction: "horizontal",
                        drag_block_vertical: false
                    },
                    tabs: {
                        style: "metis",
                        enable: true,
                        width: 250,
                        height: 40,
                        min_width: 249,
                        wrapper_padding: 0,
                        wrapper_color: "",
                        wrapper_opacity: "0",
                        tmp: '<div class="tp-tab-wrapper"><div class="tp-tab-number">{{param1}}</div><div class="tp-tab-divider"></div><div class="tp-tab-title-mask"><div class="tp-tab-title">{{title}}</div></div></div>',
                        visibleAmount: 5,
                        hide_onmobile: true,
                        hide_under: 800,
                        hide_onleave: false,
                        hide_delay: 200,
                        direction: "vertical",
                        span: true,
                        position: "inner",
                        space: 0,
                        h_align: "left",
                        v_align: "center",
                        h_offset: 0,
                        v_offset: 0
                    }
                },
                responsiveLevels: [1240, 1024, 778, 480],
                visibilityLevels: [1240, 1024, 778, 480],
                gridwidth: [1240, 1024, 778, 480],
                gridheight: [868, 768, 960, 720],
                lazyType: "none",
                parallax: {
                    type: "3D",
                    origo: "slidercenter",
                    speed: 1000,
                    levels: [2, 4, 6, 8, 10, 12, 14, 16, 45, 50, 47, 48, 49, 50, 0, 50],
                    ddd_shadow: "off",
                    ddd_bgfreeze: "on",
                    ddd_overflow: "hidden",
                    ddd_layer_overflow: "visible",
                    ddd_z_correction: 100,
                },
                spinner: "off",
                stopLoop: "on",
                stopAfterLoops: 0,
                stopAtSlide: 1,
                shuffle: "off",
                autoHeight: "off",
                fullScreenAutoWidth: "off",
                fullScreenAlignForce: "off",
                fullScreenOffsetContainer: "",
                fullScreenOffset: "60px",
                disableProgressBar: "on",
                hideThumbsOnMobile: "off",
                hideSliderAtLimit: 0,
                hideCaptionAtLimit: 0,
                hideAllCaptionAtLilmit: 0,
                debugMode: false,
                fallbacks: {
                    simplifyAll: "off",
                    nextSlideOnWindowFocus: "off",
                    disableFocusListener: false,
                }
            });
        }
    }); /*ready*/
</script>