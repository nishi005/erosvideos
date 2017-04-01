$(function() {
  $('.search_filter_btn').on('click', function() {
    $('body').append('<div class="overlay"></div>');
    centeringSearchFilter();
    $('.overlay').fadeIn('slow');
    $('.search_filter').fadeIn('slow');
  });

  $(document).on('click', '.overlay, .search_filter_cancel_btn', function() {
    $('.overlay, .search_filter').fadeOut('slow', function() {
      $('.overlay').remove();
    });
  });

  $('.inputMovieLengthMin, .inputMovieLengthMax').on('focus', function() {
    if($(window).width() < 758) {
      $('.search_filter').css({
        top: 10
      });
    }
  });


  $('.inputMovieLengthMin, inputMovieLengthMax').on('blur', function() {
    centeringSearchFilter();
  });

  function centeringSearchFilter() {
    var windowWidth = $(window).width();
    var windowHeight = $(window).height();

    var contentWidth = $('.search_filter').outerWidth(true);
    var contentHeight = $('.search_filter').outerHeight(true);

    var pxleft = (windowWidth - contentWidth) / 2;
    var pxtop = (windowHeight - contentHeight) / 2;

    $('.search_filter').css({
      left: pxleft,
      top: pxtop
    });
  }
});
