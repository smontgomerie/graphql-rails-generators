require_relative 'gql_generator_base'
module Gql
  class ModelTypeGenerator < Rails::Generators::Base
    include GqlGeneratorBase
    source_root File.expand_path('../templates', __FILE__)

    argument :model_name, type: :string

    class_option :name, type: :string
    class_option :include_columns, type: :array, default: []
    class_option :superclass, type: :string, default: 'Types::BaseObject'
    class_option :namespace, type: :string, default: 'Types'
    class_option :base_dir, type: :string, default: 'app/graphql'

    def type
      name = options['name'].nil? ? "#{model_name}Type" : options['name']

      superclass = options['superclass']

      fields = map_model_types(model_name)
      if options['include_columns'].any?
        fields.reject! { |field| !options['include_columns'].include?(field[:name]) }
      end

      code = class_with_fields(options['namespace'], name, superclass, fields)
      file_name = File.join(root_directory(options['namespace'], options['base_dir']), "#{name.underscore}.rb")

      create_file file_name, code
    end
  end
end
