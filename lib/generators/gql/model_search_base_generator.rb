module Gql
  class ModelSearchBaseGenerator < Rails::Generators::Base          
    source_root File.expand_path('../templates', __FILE__)    
    def generate_model_search_base
      gem 'search_object_graphql'

      file_path = File.join(root_directory(options['namespace'], options['base_dir']), "resolvers", "base_search_resolver.rb")

      template('model_search_base.rb', file_path)
    end
  end
end