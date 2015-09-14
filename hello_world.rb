class HelloWorld
  def print(buffer: $stdout)
    buffer.puts "Hello World"
  end
end

if __FILE__ == $0
  case ENV['USING']
  when /rspec/
    require 'rspec/autorun'
    RSpec.describe HelloWorld do
      let(:buffer) { double(puts: true) }
      subject { described_class.new }
      it 'will output to the given buffer' do
        subject.print(buffer: buffer)
        expect(buffer).to have_received(:puts).with("Hello World")
      end

      it 'will output to $stdout if none is given' do
        expect($stdout).to receive(:puts).with("Hello World")
        subject.print
      end
    end
  else
    require 'minitest/autorun'

    class TestHelloWorld < MiniTest::Test
      def test_will_output_to_the_given_buffer
        subject = HelloWorld.new
        mock_buffer = MiniTest::Mock.new
        mock_buffer.expect(:puts, nil, ['Hello World'])
        subject.print(buffer: mock_buffer)
        mock_buffer.verify
      end
    end
  end
end
