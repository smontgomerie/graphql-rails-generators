module Mutations
  class <%= prefixed_class_name('Create') %> < Mutations::BaseMutation
    class Create<%= name %>Input < Types::BaseInputObject
      description 'Attributes to create <%= name %>'

      # argument :start_date, GraphQL::Types::ISO8601Date, required: true
    end

    field :<%= singular_name %>, Types::<%= name %>Type, null: true
    field :errors, [Types::ValidationErrorType], null: true

    argument :input, Create<%= name %>Input, required: true

    def resolve(input:)
      authorize! <%= name %>, to: :create?

      model = <%= name %>.new(input.to_h)

      if model.save
        {<%= singular_name %>: model}
      else
        model_errors!(model)
      end
    end
  end
end