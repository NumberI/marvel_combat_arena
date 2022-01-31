# frozen_string_literal: true
#!/usr/bin/env ruby

RSpec.describe 'ProcessingRequest' do
  context :request do
    before do
      Timecop.freeze(Time.utc(2022))
    end
  
    after do
      Timecop.return
    end

    before(:all) { WebMock.disable_net_connect! }
    after(:all)  { WebMock.allow_net_connect! }

    let(:response_file) do
      File.join('spec', 'resources', 'hulk.json')
    end

    let(:response) do
      response_file
        .yield_self { |file_path| File.read(file_path) }
        .yield_self { |file| JSON.parse(file) }
    end
    
    let(:wrong_url) { 'https://gateway.marvel.com/v1/public/characters?name=huk&ts=1640995200&apikey=d37fd2633e3c15a835a6414e3dabf784&hash=ef9ea8e9b1d8979f85985e741144c64f' }
    let(:wrong_fighter) { 'huk' }
    
    let(:url) { 'https://gateway.marvel.com/v1/public/characters?name=hulk&ts=1640995200&apikey=d37fd2633e3c15a835a6414e3dabf784&hash=ef9ea8e9b1d8979f85985e741144c64f' }
    let(:fighter) { 'hulk' }

    let(:description) { 'Caught in a gamma bomb explosion while trying to save the life of a teenager, '\
      'Dr. Bruce Banner was transformed into the incredibly powerful creature called the Hulk. An all too often misunderstood hero, '\
      'the angrier the Hulk gets, the stronger the Hulk gets.' }
    
    it "don't have character" do
      stub_request(:get, wrong_url)
          .to_return(body: {
            "code": 200,
            "status": "Ok",
            "copyright": "xC2xA9 2022 MARVEL",
            "attributionText": "Data provided by Marvel. xC2xA9 2022 MARVEL",
            "attributionHTML": '<a href="http://marvel.com">Data provided by Marvel. xC2xA9 2022 MARVEL</a>',
            "etag": "79ef3436d0dc139b17693635b99776556e29f495",
            "data": {
              "offset": 0,
              "limit": 20,
              "total": 0,
              "count": 0,
              "results": []
            }
          }.to_json)
      
      expect { ProcessingRequest.call([wrong_fighter]) }.to raise_error(StandardError, 'Sorry. Character <<huk>> not found! Choose another')
    end
    
    it "checking result" do
      stub_request(:get, url)
        .to_return(body: response.to_json)
      
      expect( ProcessingRequest.call([fighter]) ).to eq([:name => "Hulk", :description => description])
    end
    
  end
end