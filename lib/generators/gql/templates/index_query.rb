# frozen_string_literal: true

module Resolvers
  class <%= name.pluralize %> < Resolvers::BaseResolver
    type Types::<%= name %>Type, null: false
    description "Shows <%= name.downcase.pluralize %>"

    def resolve(id:)
      authorized_scope(::<%= name %>.all)
    end
  end
end