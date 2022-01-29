module Mutations
  class <%= prefixed_class_name('Create') %> < <%= options['superclass'] %>
    class Create<%= name %>Input < Types::BaseInputObject
      description 'Attributes to create <%= name %>'
      <%
      @fields = map_model_types(name)
      @fields.reject! { |field| ['id', 'created_at', 'updated_at'].include?(field[:name]) }
      @fields.each do |field|
      %>
      <%= sprintf("field :%s, %s, null: %s", field[:name], field[:gql_type], field[:null]) %> <% end %>
    end

    field :<%= singular_name %>, Types::<%= name %>Type, null: true
    field :errors, [Types::ValidationErrorType], null: true

    argument :input, Create<%= name %>Input, required: true

    def resolve(input:)
      authorize! <%= name %>, to: :create?

      <%= singular_name %> = <%= name %>.new(input.to_h)

      if <%= singular_name %>.save
        {<%= singular_name %>: <%= singular_name %>}
      else
        { errors: validation_errors(<%= singular_name %>) }
      end
    end
  end
end