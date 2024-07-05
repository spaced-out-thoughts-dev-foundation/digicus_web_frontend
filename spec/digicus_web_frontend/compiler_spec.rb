# frozen_string_literal: true

require './spec/spec_helper'

RSpec.describe DigicusWebFrontend::Compiler do
  describe '#from_dtr' do
    context 'when given contract with just a name' do
      let(:expected_dtr) do
        <<~DTR
          [Contract]: Foo

          [State]:

          :[State]

          [Interface]:

          :[Interface]
          [User Defined Types]:

          :[User Defined Types]
          [Helpers]:

          :[Helpers]
        DTR
      end

      it 'returns dtr string' do
        json_code = {
          contract_name: 'Foo',
          contract_state: nil,
          contract_interface: nil,
          contract_user_defined_types: nil,
          contract_helpers: nil
        }.to_json

        compiler = described_class.new(json_code)
        expect(compiler.to_dtr).to eq(expected_dtr)
      end
    end
  end
end
