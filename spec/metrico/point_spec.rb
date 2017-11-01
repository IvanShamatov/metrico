require "spec_helper"

RSpec.describe Metrico::Point do

  before do
    Metrico.configure do |config|
      config.app_name = 'app_name' # required
      config.hostname = 'globalhost' # required
      config.nats_connect_options = {
        servers: ['nats://telegraf-0.somenatsnode.com:4222']
      }
    end
  end

  describe 'escaping' do
    it 'should escape correctly' do
      point = described_class.new(
        'somename',
        {
          '4= ,"\\4' => '5= ,"\\5',
          intval: 5,
          floatval: 7.0,
          invalid_encoding: "a\255 b",
          non_latin: 'Улан-Удэ',
          backslash: "C:\\"
        },
        { '2= ,"\\2' => '3= ,"\\3' }
      )
      expected = "app_name:somename,hostname=globalhost,2\\=\\ \\,\"\\2=3\\=\\ \\,\"\\3 4\\=\\ \\,\\\"\\4=\"5= ,\\\"\\\\5\",intval=5i,floatval=7.0,invalid_encoding=\"a b\",non_latin=\"Улан-Удэ\",backslash=\"C:\\\\\" "
      expect(point.to_s).to include(expected)
    end
  end

  describe 'to_s' do
    context 'with all possible data passed' do
      it do
        point = described_class.new(
          'responses',
          { value: 5, threshold: 0.54 },
          { region: 'eu', status: 200 }
        )
        expected = 'app_name:responses,hostname=globalhost,region=eu,status=200 value=5i,threshold=0.54 '
        expect(point.to_s).to include(expected)
      end
    end

    context 'without tags' do
      it do
        point = Metrico::Point.new(
          'responses',
          { value: 5, threshold: 0.54 }
        )
        expected = 'app_name:responses,hostname=globalhost value=5i,threshold=0.54'
        expect(point.to_s).to include(expected)
      end
    end
  end
end
