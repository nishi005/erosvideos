var Button = function() {
  this.pushed = false;
  this.pushButton = function() {
    this.pushed = this.pushed == false ? true : false;
    return this.pushed;
  };
  return this.pushButton;
};

var clickButton = Button();

$(function() {
  $(document).on('click', '.tag_edit_link', function() {
    if(clickButton()) {
      $('.tag_edit_form').css("display", "block");
      $('.tag_delete_form').css("display", "inline-block");
      $('.tag_edit_link').text('編集を終了');
    } else {
      $('.tag_edit_form').css("display", "none");
      $('.tag_delete_form').css("display", "none");
      $('.tag_edit_link').text('タグを編集');
    }
  });
});
