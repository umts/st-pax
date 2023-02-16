# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IssueToken do
  describe '#instance' do
    it "creates an instance if there isn't one" do
      expect { described_class.instance }.to change(described_class, :count).by(1)
    end

    it 'returns the existing one otherwise' do
      new_instance = described_class.create(singleton: 0)
      expect(described_class.instance).to eq(new_instance)
    end
  end

  describe '#usable?' do
    subject(:call) { described_class.usable? }

    before { described_class.create(singleton: 0) }

    it 'is false if the token is blank' do
      expect(call).to be(false)
    end

    it 'is false if the token is invalid' do
      dummy_instance = double(described_class, token: 'abc', valid?: false)
      allow(described_class).to receive(:instance).and_return(dummy_instance)

      expect(call).to be(false)
    end

    it 'is true if the token is present and valid' do
      dummy_instance = double(described_class, token: 'abc', valid?: true)
      allow(described_class).to receive(:instance).and_return(dummy_instance)

      expect(call).to be(true)
    end
  end

  describe 'functioning token validation' do
    subject(:instance) { described_class.instance }

    before { described_class.create(singleton: 0) }

    it "doesn't interfere if the token is blank" do
      expect(instance).to be_valid
    end

    context 'with a mock client' do
      let(:client) { double(Octokit::Client) }

      before { allow(Octokit::Client).to receive(:new).and_return(client) }

      it 'passes if OctoKit succeeds in its check' do
        allow(client).to receive(:check_application_authorization)
        instance.token = 'GOODTOKEN'

        expect(instance).to be_valid
      end

      it 'fails of OctoKit fails in its check' do
        allow(client).to receive(:check_application_authorization).and_raise(Octokit::NotFound)
        instance.token = 'BADTOKEN'

        expect(instance).not_to be_valid
      end
    end
  end
end
