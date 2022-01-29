module Mutations
  class <%= prefixed_class_name('Delete') %> < <%= options['superclass'] %>
    field :<%= singular_name %>, Types::<%= name %>Type, null: true

    argument :id, ID, required: true

    def resolve(id:)
      model = <%= class_name %>.find_by(uuid: id)

      authorize! <%= singular_name %>, to: :destroy?

      model.destroy
      {<%= singular_name %>: model}
    end
  end
end