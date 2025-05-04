module TurboTransition
  class ContainerComponentPreview < ViewComponent::Preview
    # @param variant [select: fade:fade,slide:slide,vertical:vertical,zoom:zoom,flip:flip,push:push,bounce:bounce]
    def default(variant: "slide")
      render TurboTransition::ContainerComponent.new(id: "preview-container", variant: variant) do |component|
        component.with_slot(active: true) do
          tag.div class: "example-content" do
            tag.h2("Step 1")
            tag.p("This is the first step content. Use the Turbo Stream action to navigate to the next step.")
          end
        end

        component.with_slot do
          tag.div class: "example-content" do
            tag.h2("Step 2")
            tag.p("This is the second step content that will appear after transition.")
          end
        end
      end
    end
  end
end
