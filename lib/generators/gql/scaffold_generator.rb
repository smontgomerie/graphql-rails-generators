require "rails/generators/named_base"
require_relative 'gql_generator_base'

module Gql
  class ScaffoldGenerator < Rails::Generators::NamedBase
    include GqlGeneratorBase
    source_root File.expand_path('../templates', __FILE__)
    desc "Generate create, update and delete generators for a model."

    class_option :name, type: :string
    class_option :include_columns, type: :array, default: []
    class_option :superclass, type: :string, default: 'Types::BaseInputObject'
    class_option :namespace, type: :string, default: 'Types::Input'
    class_option :base_dir, type: :string, default: 'app/graphql'

    def scaffold
      generate_queries
      generate_policy
      generate_mutation('update')
      generate_mutation('create')
      generate_mutation('delete')
    end

    protected

    def generate_mutation(prefix)
      file_name = "#{prefix}_#{singular_name}"

      file_path = File.join(base_dir, "mutations", class_path.join('/'), "#{file_name.underscore}.rb")
      template("#{prefix}_mutation.rb", file_path)

      file_path = File.join(base_dir, "types", "mutation_type.rb")
      insert_into_file(file_path, after: "  class MutationType < Types::BaseObject\n") do
        "    field :#{file_name.camelcase(:lower)}, mutation: Mutations::#{prefixed_class_name(prefix)}\n"
      end
    end

    def generate_policy
      template("policy_file.rb", "app/policies/#{singular_name}_policy.rb")
    end

    def generate_queries
      template("show_query.rb", "#{base_dir}/resolvers/#{singular_name}.rb")
      insert_into_file("#{base_dir}/types/query_type.rb", after: " class QueryType < Types::BaseObject\n") do
        "    field :#{singular_name.camelcase(:lower)}, resolver: Resolvers::#{singular_name.capitalize}\n"
      end

      template("index_query.rb", "#{base_dir}/resolvers/#{singular_name.pluralize}.rb")
      insert_into_file("#{base_dir}/types/query_type.rb", after: " class QueryType < Types::BaseObject\n") do
          "    field :#{singular_name.pluralize.camelcase(:lower)}, resolver: Resolvers::#{singular_name.pluralize.capitalize}\n"
      end
    end
  end
end