require 'test_helper'

class PostControllerTest < ActionDispatch::IntegrationTest
  test "should get item" do
    get post_item_url
    assert_response :success
  end

end
