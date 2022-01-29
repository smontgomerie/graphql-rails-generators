module Mutations
  class <%= prefixed_class_name('Update') %> < <%= options['superclass'] %>
    class Update<%= name %>Input < Types::BaseInputObject
      description 'Attributes to update <%= name %>'
      <%
      @fields = map_model_types(name)
      @fields.reject! { |field| ['id', 'created_at', 'updated_at'].include?(field[:name]) }
      @fields.each do |field|
      %>
      <%= sprintf("field :%s, %s, null: %s", field[:name], field[:gql_type], field[:null]) %> <% end %>
    end

    field :<%= singular_name %>, Types::<%= name %>Type, null: true
    field :errors, [Types::ValidationErrorType], null: true

    argument :id, :ID, required: true
    argument :input, Update<%= name %>Input, required: true

    def resolve(input:, id:)
      <%= singular_name %> = <%= name %>Type.find_object(id) unless id.blank?

      authorize! <%= singular_name %>, to: :update?

      if <%= singular_name %>.update_attributes(input.to_h)
        {<%= singular_name %>: <%= singular_name %>}
      else
        { errors: validation_errors(<%= singular_name %>) }
      end
    end
  end
end