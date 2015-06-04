require 'test_helper'

describe Lotus::Action do
  describe 'session' do
    it 'captures session from Rack env' do
      action = SessionAction.new
      action.call({'rack.session' => session = { 'user_id' => '23' }})

      action.__send__(:session).must_equal(session)
    end

    it 'returns empty hash when it is missing' do
      action = SessionAction.new
      action.call({})

      action.__send__(:session).must_equal({})
    end

    it 'exposes session' do
      action = SessionAction.new
      action.call({'rack.session' => session = { 'foo' => 'bar' }})

      action.exposures[:session].must_equal(session)
    end
  end
end
