module TurboTransition
  class ContainerComponent < ViewComponent::Base
    renders_many :slots, "TurboTransition::SlotComponent"

    attr_reader :id, :variant, :class_name

    # Initialize the container component
    # @param id [String] The container's DOM ID
    # @param variant [String] Animation variant (e.g., "fade", "zoom", "bounce")
    # @param class_name [String] Additional CSS classes
    def initialize(id:, variant: nil, class_name: nil)
      @id = id
      @variant = variant
      @class_name = class_name
    end

    # Builds the CSS classes for the container
    def container_classes
      classes = ["tt-container"]
      classes << "tt-variant-#{variant}" if variant.present?
      classes << class_name if class_name.present?
      classes.join(" ")
    end

    # Returns a slot component ready to be rendered
    def slot_component(active: false, &block)
      SlotComponent.new(active: active).with_content(&block)
    end
  end
end
