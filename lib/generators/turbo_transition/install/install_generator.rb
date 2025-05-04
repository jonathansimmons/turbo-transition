module TurboTransition
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Installs TurboTransition by copying CSS to vendor directory"

      def create_vendor_directory
        empty_directory "app/assets/stylesheets/vendor"
      end

      def copy_css_file
        # Find the path to the gem's CSS file
        gem_root = File.expand_path("../../../../", __dir__)
        css_source = File.join(gem_root, "app/assets/stylesheets/turbo_transition.css")

        if File.exist?(css_source)
          copy_file css_source, "app/assets/stylesheets/vendor/turbo_transition.css"
        else
          say "CSS file not found at #{css_source}. Please manually copy the CSS file from the gem.", :red
        end
      end

      def show_readme
        readme "README.md"
      end
    end
  end
end
