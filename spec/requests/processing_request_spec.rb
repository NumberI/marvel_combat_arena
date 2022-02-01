# frozen_string_literal: true

# !/usr/bin/env ruby

RSpec.describe 'ProcessingRequest' do

  PUBLIC_KEY = ENV['PUBLIC_KEY']
  PRIVATE_KEY = ENV['PRIVATE_KEY']
  CHARACTERS_URL = "https://gateway.marvel.com/v1/public/characters"

  context :request do

    let(:time_now) { Time.utc(2022) }
    let(:time_now_str) { time_now.to_i.to_s }

    before do
      Timecop.freeze(time_now)
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

    let(:url_hash) { Digest::MD5.hexdigest(time_now_str + PRIVATE_KEY + PUBLIC_KEY) }

    let(:wrong_fighter) { 'huk' }
    let(:wrong_url) do
      "#{CHARACTERS_URL}?name=#{wrong_fighter}&ts=#{time_now_str}&apikey=#{ENV['PUBLIC_KEY']}&hash=#{url_hash}"
    end


    let(:fighter) { 'hulk' }
    let(:url) do
      "#{CHARACTERS_URL}?name=#{fighter}&ts=#{time_now_str}&apikey=#{ENV['PUBLIC_KEY']}&hash=#{url_hash}"
    end

    let(:description) do
      'Caught in a gamma bomb explosion while trying to save the life of a teenager, '\
      'Dr. Bruce Banner was transformed into the incredibly powerful creature called the Hulk. An all too often misunderstood hero, '\
      'the angrier the Hulk gets, the stronger the Hulk gets.'
    end

    it "don't have character" do
      stub_request(:get, wrong_url)
        .to_return(body: {
          "code": 200,
          "status": 'Ok',
          "copyright": 'xC2xA9 2022 MARVEL',
          "attributionText": 'Data provided by Marvel. xC2xA9 2022 MARVEL',
          "attributionHTML": '<a href="http://marvel.com">Data provided by Marvel. xC2xA9 2022 MARVEL</a>',
          "etag": '79ef3436d0dc139b17693635b99776556e29f495',
          "data": {
            "offset": 0,
            "limit": 20,
            "total": 0,
            "count": 0,
            "results": []
          }
        }.to_json)

      expect do
        ProcessingRequest.call([wrong_fighter])
      end.to raise_error(ProcessingRequest::CharacterNotFound)
    end

    it 'checking result' do
      stub_request(:get, url)
        .to_return(body: response.to_json)

      expect(ProcessingRequest.call([fighter])).to eq([name: 'Hulk', description: description])
    end
  end
end
