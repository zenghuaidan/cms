/* photo-gallery */

function initGallery() {
    $('.photo-gallery').click(function () {
        if ($(ar).length == 0) {
            var ar = [];
            var photos = $(this).find('.photo-item');
            photos.each(function () {
                var inar = {
                    'src': $(this).attr('data-src'), //big photo
                    'thumb': $(this).attr('data-thumb'), //small photo
                    'subHtml': $(this).attr('data-subHtml') //content
                };
                ar.push(inar);
            });
        }

        $(this).lightGallery({
            dynamic: true,
            dynamicEl: ar
        }).on('onAfterOpen.lg', function (event, index, fromTouch, fromThumb) {
            for (var i = 0; i < $(".lg-icon").length; i++) {
                var el = $(".lg-icon").eq(i);
                var class_n = el.attr("class");
                var n = class_n.replace(/lg-icon|lg-|\s/g, "");
                if (n.length == 0) {
                    n = el.attr("id").replace(/lg-|\s/g, "");
                }
                el.attr("title", n);
            }
        });
    });
}

$(window).load(function(){
    initGallery();
});