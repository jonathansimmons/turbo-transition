module TurboTransition
  class SlotComponent < ViewComponent::Base
    attr_reader :active

    # Initialize a slot component
    # @param active [Boolean] Whether this slot is the initially active one
    def initialize(active: false)
      @active = active
    end

    # Generate the class list for the slot
    def slot_classes
      ["tt-slot", active ? "active" : nil].compact.join(" ")
    end
  end
end
