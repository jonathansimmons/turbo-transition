# frozen_string_literal: true

require_relative "turbo_transition/version"
require "rails"
require "view_component"

module TurboTransition
  class Error < StandardError; end

  # Rails engine to integrate with Rails asset pipeline
  class Engine < ::Rails::Engine
    isolate_namespace TurboTransition

    initializer "turbo_transition.assets" do |app|
      # Add full asset paths for both Propshaft and Sprockets
      app.config.assets.paths << root.join("app/assets/javascripts")
      app.config.assets.paths << root.join("app/assets/stylesheets")

      # For Sprockets compatibility
      if !defined?(Propshaft) && defined?(Sprockets)
        app.config.assets.precompile += %w[turbo_transition.js turbo_transition.css]
      end
    end

    # Configure ViewComponent
    config.view_component.preview_paths << File.expand_path("../app/components/previews", __dir__)

    # Include helpers
    config.to_prepare do
      ActionController::Base.helper TurboTransitionHelper
    end
  end
end

# Load components
require "turbo_transition/components"

# Load generators
require_relative "generators/turbo_transition/install/install_generator" if defined?(Rails::Generators)
