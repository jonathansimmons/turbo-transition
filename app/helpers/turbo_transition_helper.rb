module TurboTransitionHelper
  # Generates a Turbo Stream tag with transition capabilities
  #
  # @param [String] target DOM ID of the container element
  # @param [String] partial Path to the partial to render
  # @param [Hash] locals Variables to pass to the partial
  # @param [String] direction Direction of the transition ('forward' or 'backward')
  # @param [Hash] options Additional options for customization
  #
  # @return [String] Turbo Stream tag with transition data attributes
  def turbo_transition_stream(target:, partial:, locals: {}, direction: "forward", options: {})
    # Render content using the appropriate context
    template_content = if is_a?(ActionController::Base)
                         # Called from controller: use view_context to avoid double render
                         view_context.render(partial: partial, locals: locals, formats: [:html])
                       else
                         # Called from view: render directly
                         render(partial: partial, locals: locals, formats: [:html])
                       end

    # Set up data attributes
    data_attributes = {
      direction: direction
    }

    # Add any custom data attributes
    options.each do |key, value|
      data_attributes[key.to_s.dasherize] = value
    end

    # Use turbo_stream_tag helper from Turbo Rails
    tag.turbo_stream(
      action: "transition",
      target: target,
      **data_attributes.transform_keys { |key| "data-#{key}" }
    ) do
      tag.template do
        template_content.html_safe
      end
    end
  end
end
