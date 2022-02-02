# frozen_string_literal: true

# !/usr/bin/env ruby

RSpec.describe BattleService do
  context :battle do
    let(:fighters) do
      [
        { name: 'Captain America',
          description: "Vowing to serve his country any way he could, young Steve Rogers took the super soldier serum to become America's one-man army. Fighting for the red, white and blue for over 60 years, Captain America is the living, breathing symbol of freedom and liberty." }, { name: 'Hulk', description: 'Caught in a gamma bomb explosion while trying to save the life of a teenager, Dr. Bruce Banner was transformed into the incredibly powerful creature called the Hulk. An all too often misunderstood hero, the angrier the Hulk gets, the stronger the Hulk gets.' }
      ]
    end

    context :winners do
      let(:similar_fighters) do
        [
          { name: 'Hulk',
            description: 'Caught in a gamma bomb explosion while trying to save the life of a teenager, Dr. Bruce Banner was transformed into the incredibly powerful creature called the Hulk. An all too often misunderstood hero, the angrier the Hulk gets, the stronger the Hulk gets.' }, { name: 'Hulk', description: 'Caught in a gamma bomb explosion while trying to save the life of a teenager, Dr. Bruce Banner was transformed into the incredibly powerful creature called the Hulk. An all too often misunderstood hero, the angrier the Hulk gets, the stronger the Hulk gets.' }
        ]
      end

      it 'checking Hulk winner' do
        expect(BattleService.call(fighters, 3)).to eq('The winner is <<Hulk>>')
      end

      it 'checking both winners' do
        expect(BattleService.call(similar_fighters, 3)).to eq('They are both winners!')
      end
    end

    context :words do
      let(:battle) { BattleService.new(fighters, 3) }
      let(:hulk) do
        { name: 'Hulk',
          description: 'Caught in a gamma bomb explosion while trying to save the life of a teenager, Dr. Bruce Banner was transformed into the incredibly powerful creature called the Hulk. An all too often misunderstood hero, the angrier the Hulk gets, the stronger the Hulk gets.' }
      end

      it 'chosen word' do
        expect(battle.send(:process_description, hulk, 3)).to eq('gamma')
      end
    end
  end
end
