require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "post likes" do
    assert_equal 100, posts(:two).like
  end

  test "post title" do
    assert_equal "Hundred favs on this post", posts(:two).title
  end

  test "post text" do
    assert_equal "This post was liked by hundred users", posts(:two).text
  end
end
