# frozen_string_literal: true

module Resolvers
  class <%= @model_name %> < Resolvers::BaseResolver
    type [Types::<%= @model_name %>Type], null: false
    description "Shows <%= @model_name.downcase.pluralize %>"

    argument :id, ID, required: true


    def resolve(id:)
      authorized_scope(::<%= @model_name %>.all).find_by!(uuid: id)
    end
  end
end