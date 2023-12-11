require 'rspec'
require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  describe "Item updates" do
    context "# Aged Brie" do
      let(:item) { Item.new("Aged Brie", 2, 0) }

      it "Increases in quality by 2 as sell_in date passed" do
        GildedRose.new([item]).update_quality
        expect(item.sell_in).to eq 1
        expect(item.quality).to eq 2
      end

      it "Quality should not exceed 50" do
        item.quality = 50
        GildedRose.new([item]).update_quality
        expect(item.sell_in).to eq 1
        expect(item.quality).to eq 50
      end
    end

    context "# Backstage passes" do
      let(:item) { Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20) }

      context 'when there are 11 days or more' do
        it "Quality increases by 1 as sell_in date passed" do
          GildedRose.new([item]).update_quality
          expect(item.sell_in).to eq 14
          expect(item.quality).to eq 21
        end
      end

      context 'when there are 10 days or less' do
        before do
          item.sell_in = 10
          item.quality = 20
        end

        it "Quality increases by 2 as sell_in date passed" do
          GildedRose.new([item]).update_quality
          expect(item.sell_in).to eq 9
          expect(item.quality).to eq 22
        end
      end

      context 'when there are 5 days or less' do
        before do
          item.sell_in = 5
          item.quality = 20
        end

        it "Quality increases by 3 as sell_in date passed" do
          GildedRose.new([item]).update_quality
          expect(item.sell_in).to eq 4
          expect(item.quality).to eq 23
        end
      end

      it "Quality drops to 0 after the concert" do
        item.sell_in = 0
        item.quality = 10
        GildedRose.new([item]).update_quality
        expect(item.quality).to eq 0
      end

      it "Quality of an item is never more than 50" do
        item.sell_in = 5
        item.quality = 49
        GildedRose.new([item]).update_quality
        expect(item.quality).to eq 50
      end
    end

    context "# Sulfuras, Hand of Ragnaros" do
      let(:item) { Item.new("Sulfuras, Hand of Ragnaros", -1, 80) }

      it "Never has to be sold or decreases in Quality" do
        GildedRose.new([item]).update_quality

        expect(item.sell_in).to eq -1
        expect(item.quality).to eq 80
      end
    end

    context "# Conjured Mana Cake" do
      let(:item) { Item.new("Conjured Mana Cake", 3, 6) }

      it "Degrades in quality twice as fast as regular items" do
        GildedRose.new([item]).update_quality
        expect(item.sell_in).to eq 2
        expect(item.quality).to eq 4
      end
    end

    context "# Normal" do
      let(:item) { Item.new("Elixir of the Mongoose", 5, 7) }

      it "Once the sell by date has passed, Quality degrades twice as fast" do
        GildedRose.new([item]).update_quality

        expect(item.sell_in).to eq 4
        expect(item.quality).to eq 5
      end

      it "The Quality of an item is never negative" do
        item.quality = 0

        GildedRose.new([item]).update_quality

        expect(item.sell_in).to eq 4
        expect(item.quality).to eq 0
      end
    end
  end
end