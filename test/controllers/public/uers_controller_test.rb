require "test_helper"

class Public::UersControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get public_uers_show_url
    assert_response :success
  end

  test "should get edit" do
    get public_uers_edit_url
    assert_response :success
  end

  test "should get unsubscribe" do
    get public_uers_unsubscribe_url
    assert_response :success
  end
end
