require 'spec_helper'
RSpec.describe Applitools::Selenium::Target do
  it_behaves_like 'has chain methods',
    fully: nil,
    ignore_caret: [false],
    floating: [Applitools::FloatingRegion.new(0, 0, 0, 0, 0, 0, 0, 0)],
    timeout: [10],
    ignore_mismatch: [false],
    match_level: [:none],
    ignore: [Applitools::Region::EMPTY]

  context 'timeout' do
    it 'sets options[:timeout]' do
      subject.timeout(100_500)
      expect(subject.options[:timeout]).to eq 100_500
    end

    it 'converts value using to_i method' do
      integer_value = double(100_500)
      expect(integer_value).to receive(:to_i).and_return(0)
      subject.timeout(integer_value)
    end
  end

  context 'ignore mismatch' do
    it 'sets options[:ignore_mismatch]' do
      subject.ignore_mismatch(true)
      expect(subject.options[:ignore_mismatch]).to be true
      subject.ignore_mismatch(false)
      expect(subject.options[:ignore_mismatch]).to be false
    end

    it 'uses default value' do
      expect(subject.options[:ignore_mismatch]).to be false
    end
  end

  context 'match level' do
    it 'sets options[:match_level]' do
      subject.match_level(:strict)
      expect(subject.options[:match_level]).to eq Applitools::MATCH_LEVEL[:strict]
      expect { subject.match_level('Strict') }.to raise_error Applitools::EyesError
    end
    it 'raises an exception on wrong value' do
      expect { subject.match_level('unknown') }.to raise_error Applitools::EyesError
      expect { subject.match_level(:none) }.to_not raise_error
    end
  end

  context 'ignore_caret' do
    it 'sets ignore_caret option' do
      subject.ignore_caret(true)
      expect(subject.options[:ignore_caret]).to be true
      subject.ignore_caret(false)
      expect(subject.options[:ignore_caret]).to be false
    end

    it 'sets default value when called without args' do
      subject.ignore_caret
      expect(subject.options[:ignore_caret]).to be false
    end

    it 'false by default' do
      expect(subject.options[:ignore_caret]).to be false
    end
  end

  describe ':trim' do
    it 'false by default' do
      expect(subject.options[:trim]).to be false
    end
    it 'resets if nil is passed' do
      subject.trim(nil)
    end
    it 'sets only true/false values' do
      subject.trim(0)
      expect(subject.options[:trim]).to be true
    end
    it 'true if no argument' do
      subject.trim
      expect(subject.options[:trim]).to be true
    end
  end

  context 'region methods' do
    let(:driver) do
      double.tap do |d|
        allow(d).to receive(:find_element)
      end
    end

    context 'floating' do
      before do
        expect(subject.instance_variable_get(:@floating_regions)).to receive(:<<) do |*args|
          expect(args.first).to be_a Proc
          expect { args.first.call(driver) }.to_not raise_error
        end
      end
      it 'accepts :how, :what' do
        allow(Applitools::FloatingRegion).to receive :for_element
        subject.floating(:css, '.class', 10, 10, 10, 10)
      end
      it 'accepts Applitools::Region' do
        subject.floating(Applitools::Region::EMPTY, 10, 10, 10, 10)
      end
      it 'accepts Applitools::Selenium::Element' do
        subject.floating(Applitools::Selenium::Element.new(driver, Applitools::Region::EMPTY), 10, 10, 10, 10)
      end
      it 'accepts Applitools::FloatingRegion' do
        subject.floating(Applitools::FloatingRegion.new(0, 0, 0, 0, 0, 0, 0, 0))
      end
    end

    context 'region' do
      before do
        expect(subject.instance_variable_get(:@region_to_check)).to be_a Proc
        expect { subject.instance_variable_get(:@region_to_check).call(driver) }.to_not raise_error
      end
      it 'accepts :how, :what' do
        subject.region(:css, '.class')
      end
      it 'accepts Applitools::Region' do
        subject.region(Applitools::Region::EMPTY)
      end
      it 'accepts Applitools::Selenium::Element' do
        subject.region(Applitools::Selenium::Element.new(driver, Applitools::Region::EMPTY))
      end
    end

    context 'ignore' do
      before do
        expect(subject.instance_variable_get(:@ignored_regions)).to receive(:<<) do |*args|
          expect(args.first).to be_a Proc
          expect { args.first.call(driver) }.to_not raise_error
        end
      end
      it 'accepts :how, :what' do
        subject.ignore(:css, '.class')
      end
      it 'accepts Applitools::Region' do
        subject.ignore(Applitools::Region::EMPTY)
      end
      it 'accepts Applitools::Selenium::Element' do
        subject.ignore(Applitools::Selenium::Element.new(driver, Applitools::Region::EMPTY))
      end
    end
  end
end