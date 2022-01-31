#!/usr/bin/env ruby
# frozen_string_literal: true

RSpec.describe 'fight' do
  context :start do
    let(:exec) { File.expand_path('../../bin/fight.rb', File.dirname(__FILE__)) }

    it "checking arguments' count" do
      res = `ruby #{exec} #{'cap'}`
      expect(res).to include('You need to write 3 arguments')
    end
    
    it "checking arguments' count" do
      res = `ruby #{exec} #{'cap'} #{'hulk'} #{10}`
      expect(res).to include('You need to point a suitable number')
    end
  end
end