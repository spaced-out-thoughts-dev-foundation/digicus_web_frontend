# frozen_string_literal: true

require './spec/spec_helper'

RSpec.describe DigicusWebFrontend::Compiler do
  describe '#from_dtr' do
    context 'when given contract with just a name' do
      let(:expected_dtr) do
        <<~DTR
          [Contract]: Foo
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
        expect(compiler.to_dtr.gsub("\t", '').gsub(' ', '').gsub("\n",
                                                                 '')).to eq(expected_dtr.gsub("\t", '').gsub(' ', '').gsub(
                                                                              "\n", ''
                                                                            ))
      end
    end

    context 'when given hello world contract' do
      let(:expected_dtr) do
        <<~DTR
          [Contract]: HelloWorld

          [Interface]:
          -() [hello]
            * Inputs:
              {
                env: Env
                to: String
              }
              * Output: List<String>
              * Instructions:
                $
                  { id: 0, instruction: instantiate_object, input: (List, env, String, from_str, env, "Hello", to), assign: Thing_to_return, scope: 0 }
                  { id: 1, instruction: return, input: (Thing_to_return), scope: 0 }
                $
            :[Interface]
        DTR
      end

      it 'returns dtr string' do
        json_code = {
          contract_name: 'HelloWorld',
          contract_state: [],
          contract_interface: [
            {
              name: 'hello',
              inputs: [
                { name: 'env', type_name: 'Env' },
                { name: 'to', type_name: 'String' }
              ],
              output: 'List<String>',
              instructions: [
                { id: 0, instruction: 'instantiate_object',
                  inputs: %w[List env String from_str env "Hello" to], assign: 'Thing_to_return', scope: 0 }.to_json,
                { id: 1, instruction: 'return', inputs: ['Thing_to_return'], scope: 0 }.to_json
              ]
            }.to_json
          ],
          contract_user_defined_types: nil,
          contract_helpers: nil
        }.to_json

        compiler = described_class.new(json_code)
        expect(compiler.to_dtr.gsub("\t", '').gsub(' ', '').gsub("\n",
                                                                 '')).to eq(expected_dtr.gsub("\t", '').gsub(' ', '').gsub(
                                                                              "\n", ''
                                                                            ))
      end
    end
  end
end
