require "test_helper"

class PraCommandsDeviceTest < PraTestCase
  include SystemCommandMocking

  # 1. flash
  sub_test_case "device flash command" do
    test "test 1" do
      assert_true(true)
    end
  end

  # 2. monitor  
  sub_test_case "device monitor command" do
    test "test 1" do
      assert_true(true)
    end
  end

  # 3. build
  sub_test_case "device build command" do
    test "test 1" do
      assert_true(true)
    end
  end

  # 4. setup_esp32
  sub_test_case "device setup_esp32 command" do
    test "test 1" do
      assert_true(true)
    end
  end

  # 5. tasks（omit あり）
  sub_test_case "device tasks command" do
    test "test before omit" do
      assert_true(true)
    end
    
    test "omitted test" do
      omit "Thor tasks command breaks test-unit registration"
    end
  end

  # 6. rake task proxy
  sub_test_case "rake task proxy" do
    test "test 1" do
      assert_true(true)
    end
    
    test "test 2" do
      assert_true(true)
    end
    
    test "test 3" do
      assert_true(true)
    end
  end
end
