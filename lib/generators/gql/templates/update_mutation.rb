module Mutations
  class <%= prefixed_class_name('Update') %> < Mutations::BaseMutation
    class Update<%= name %>Input < Types::BaseInputObject
      description 'Attributes to update <%= name %>'

      # argument :start_date, GraphQL::Types::ISO8601Date, required: true
    end

    field :<%= singular_name %>, Types::<%= name %>Type, null: true
    field :errors, [Types::ValidationErrorType], null: true

    argument :id, :ID, required: true
    argument :input, Update<%= name %>Input, required: true

    def resolve(input:, id:)
      <%= singular_name %> = <%= class_name %>.find_by(uuid: id)

      authorize! <%= model %>, to: :update?

      if <%= singular_name %>.update_attributes(input.to_h)
        {<%= singular_name %>: <%= singular_name %>}
      else
        { errors: validation_errors(<%= singular_name %>) }
      end
    end
  end
end