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

    def scaffold
      generate_queries
      generate_mutation('update')
      generate_mutation('create')
      generate_mutation('delete')
    end

    protected
    def generate_mutation(prefix)
      file_name = "#{prefix}_#{singular_name}"
      template("#{prefix}_mutation.rb", "app/graphql/mutations/#{class_path.join('/')}/#{file_name.underscore}.rb")
      insert_into_file("app/graphql/types/mutation_type.rb", after: "  class MutationType < Types::BaseObject\n") do
        "    field :#{file_name.camelcase(:lower)}, mutation: Mutations::#{prefixed_class_name(prefix)}\n"
      end
    end

    def generate_queries
      template("show_query.rb", "app/graphql/resolvers/#{singular_name}.rb")

      insert_into_file("app/graphql/types/query_type.rb", after: " class QueryType < Types::BaseObject\n") do
        "    field :#{singular_name.camelcase(:lower)}, resolver: Resolvers::#{singular_name.capitalize}\n"
      end
    end
  end
end