module Mutations
  class <%= prefixed_class_name('Create') %> < Mutations::BaseMutation
    class Create<%= name %>Input < Types::BaseInputObject
      description 'Attributes to create <%= name %>'
      <%
      @fields = map_model_types(name)
      if options['include_columns'].any?
        @fields.reject! { |field| ['id', 'created_at', 'updated_at'].include?(field[:name]) }
      end
      %>

      <% fields.each do |field| %>
      <% string = sprintf("%sfield :%s, %s, null: %s", "  " * (indent + 1), field[:name], field[:gql_type], field[:null]) %>
      <%= string %>
      <% end %>
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