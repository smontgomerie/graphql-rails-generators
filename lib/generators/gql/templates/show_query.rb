# frozen_string_literal: true

module Resolvers
  class <%= name %> < Resolvers::BaseResolver
    type Types::<%= name %>Type, null: false
    description "Shows <%= name.downcase.pluralize %>"

    argument :id, ID, required: true

    def resolve(id:)
      authorized_scope(::<%= name %>.all).find_by!(uuid: id)
    end
  end
end