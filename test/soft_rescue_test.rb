require 'test_helper'

class SoftRescueTest < Minitest::Test
  describe 'version number' do
    it { refute_nil ::SoftRescue::VERSION }
  end

  describe '.soft_rescue' do
    # clean all settings
    before do
      SoftRescue.configure do |config|
        config.logger = nil
        config.capture_exception = nil
        config.enabled = nil
      end
    end

    describe 'when nothing is configured' do
      before do
        @expected_result = :expected_result
        @memo = Minitest::Mock.new
      end

      it 'executes default block' do
        @memo.expect :call, @expected_result
        result = SoftRescue.call { @memo.call }
        @memo.verify
        result.must_equal @expected_result
      end

      it 'raises exception' do
        block = -> { SoftRescue.call { raise } }
        block.must_raise RuntimeError
      end
    end

    describe 'when enabled is false' do
      before do
        SoftRescue.configure do |config|
          config.enabled = false
        end
      end

      it { -> { SoftRescue.call { raise } }.must_raise RuntimeError }
    end

    describe 'when enabled is true' do
      before do
        SoftRescue.configure do |config|
          config.enabled = true
        end
      end

      describe 'when capture_exception is set' do
        describe 'when exception is raised' do
          before do
            @capture_exception = Minitest::Mock.new
            SoftRescue.configure do |config|
              config.capture_exception = @capture_exception
            end
          end

          it 'executes capture_exception' do
            @capture_exception.expect :call, nil, [RuntimeError]
            SoftRescue.call { raise }
            @capture_exception.verify
          end
        end

        describe 'when exception is not raised' do
          before do
            SoftRescue.configure do |config|
              config.capture_exception = ->(_exception) { raise }
            end
          end

          it 'does not execute capture_exception' do
            SoftRescue.call { 2 * 2 }
          end
        end
      end

      describe 'when on_failure is set' do
        describe 'when exception is raised' do
          before do
            @expected_result = :expected_result
          end

          describe 'when on_failure is block' do
            before do
              @on_failure = Minitest::Mock.new
            end

            it 'executes on_failure' do
              @on_failure.expect :call, @expected_result
              result = SoftRescue.call(on_failure: -> { @on_failure.call }) { raise }

              @on_failure.verify
              result.must_equal @expected_result
            end
          end

          it 'returns on_failure value' do
            result = SoftRescue.call(on_failure: @expected_result) { raise }
            result.must_equal @expected_result
          end
        end

        describe 'when exception is not raised' do
          it 'does not execute on_failure' do
            result = SoftRescue.call(on_failure: -> { raise }) { 2 * 2 }
            result.must_equal 4
          end
        end
      end

      describe 'when logger is set' do
        describe 'when exception is raised' do
          before do
            @logger = Minitest::Mock.new
            @message = 'message'
            @err_message = 'err_message'
            SoftRescue.configure do |config|
              config.logger = @logger
            end
          end

          it 'executes on_failure' do
            @logger.expect :error, nil, ["#{@message}. #{@err_message}"]
            SoftRescue.call(message: @message) { raise @err_message }
            @logger.verify
          end
        end

        describe 'when exception is not raised' do
          before do
            SoftRescue.configure do |config|
              config.logger = Object.new # no method error
            end
          end

          it 'does not log anything' do
            SoftRescue.call { 2 * 2 }
          end
        end
      end
    end
  end
end
