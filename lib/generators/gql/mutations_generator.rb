require "rails/generators/named_base"
require_relative 'gql_generator_base'

module Gql
  class MutationsGenerator < Rails::Generators::NamedBase
    include GqlGeneratorBase
    source_root File.expand_path('../templates', __FILE__)
    desc "Generate create, update and delete generators for a model."

    class_option :name, type: :string
    class_option :include_columns, type: :array, default: []
    class_option :superclass, type: :string, default: 'Types::BaseInputObject'
    class_option :namespace, type: :string, default: 'Types::Input'
    class_option :base_dir, type: :string, default: 'app/graphql'

    def mutations
      generate_mutation('update')
      generate_mutation('create')
      generate_mutation('delete')
    end

    protected
    def generate_mutation(prefix)
      file_name = "#{prefix}_#{singular_name}"
      file_path = File.join(base_dir, class_path.join('/'), "#{file_name.underscore}.rb")
      template("#{prefix}_mutation.rb", file_path)
      debugger
      insert_into_file("#{base_dir}/mutation_type.rb", after: "  class MutationType < Types::BaseObject\n") do
        "    field :#{file_name.camelcase(:lower)}, mutation: Mutations::#{prefixed_class_name(prefix)}\n"
      end
    end
  end
end