# frozen_string_literal: true

require 'dtr_core'
require 'json'

module DigicusWebFrontend
  # This is a simple compiler class that takes a DTR code and transpiles it to JSON.
  class Compiler
    attr_reader :json_code

    def initialize(json_code)
      @json_code = JSON.parse(json_code)
    end

    def self.to_dtr(json_code)
      new(json_code).to_dtr
    end

    def to_dtr
      DTRCore::Contract.new(
        json_code['contract_name'],
        form_state(json_code['contract_state']),
        form_functions(json_code['contract_interface']),
        form_user_defined_types(json_code['contract_user_defined_types']),
        form_functions(json_code['contract_helpers']),
        nil # non_translatables
      ).to_s
    end

    private

    def form_state(state)
      return [] if state.nil? || state.empty?

      state.map do |s|
        json_s = JSON.parse(s)

        DTRCore::State.new(
          json_s['name'],
          json_s['type'],
          json_s['initial_value']
        )
      end
    end

    def form_functions(functions)
      return [] if functions.nil? || functions.empty?

      functions.map do |f|
        json_f = JSON.parse(f)

        DTRCore::Function.new(
          json_f['name'],
          json_f['inputs'].map { |i| i.transform_keys(&:to_sym) },
          json_f['output'],
          json_f['instructions'].map do |i|
            ins = JSON.parse(i)
            DTRCore::Instruction.new(
              ins['instruction'],
              ins['inputs'],
              ins['assign'],
              ins['scope'],
              ins['id']
            )
          end
        )
      end
    end

    def form_user_defined_types(user_defined_types)
      return [] if user_defined_types.nil? || user_defined_types.empty?

      user_defined_types.map do |t|
        json_t = JSON.parse(t)

        DTRCore::UserDefinedType.new(
          json_t['name'],
          json_t['attributes']
        )
      end
    end
  end
end
