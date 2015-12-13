require 'git'

module Generamba::CLI
  class Template < Thor
    include Generamba

    desc 'search', 'Searches a template with a given name in the shared GitHub catalog'
    def search(term)
      catalog_local_path = Pathname.new(ENV['HOME'])
                               .join(GENERAMBA_HOME_DIR)
                               .join(CATALOGS_DIR)
      FileUtils.rm_rf catalog_local_path
      FileUtils.mkdir_p catalog_local_path

      Git.clone(RAMBLER_CATALOG_REPO, GENERAMBA_CATALOG_NAME, :path => catalog_local_path)

      generamba_catalog_path = catalog_local_path.join(GENERAMBA_CATALOG_NAME)

      generamba_catalog_path.children.select { |child|
        child.directory? && child.split.last.to_s[0] != '.'
      }.map { |template_path|
        template_path.split.last.to_s
      }.select { |template_name|
        template_name.include?(term)
      }.each { |template_name|
        puts(template_name)
      }
    end
  end
end