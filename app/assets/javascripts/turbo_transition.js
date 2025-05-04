// TurboTransition - Animated content transitions for Turbo Streams
(function() {
  // Default animation duration used when setting timeout
  const DEFAULT_DURATION = 500;

  // Define our custom transition action
  const transitionAction = function() {
    console.log("🔄 TurboTransition activated")

    // Get parameters from the turbo-stream tag
    const direction = this.getAttribute("data-direction") || "forward"
    const targetId = this.getAttribute("target")
    const container = document.getElementById(targetId)

    if (!container) {
      console.error("TurboTransition: Missing container", { targetId })
      return
    }

    // Get content from template
    const newContent = this.querySelector("template")?.content

    if (!newContent) {
      console.error("TurboTransition: Missing content template")
      return
    }

    // Find the slots
    const activeSlot = container.querySelector(".tt-slot.active")
    const inactiveSlot = container.querySelector(".tt-slot:not(.active)")

    if (!activeSlot || !inactiveSlot) {
      console.error("TurboTransition: Could not find both slots in container")
      return
    }

    // Get the duration from computed style for timeout purposes
    const computedStyle = window.getComputedStyle(container);
    const cssCustomDuration = computedStyle.getPropertyValue('--tt-custom-duration') ||
                              computedStyle.getPropertyValue('--tt-duration');

    // Extract numeric value for completion delay calculation
    let duration = DEFAULT_DURATION;
    if (cssCustomDuration && cssCustomDuration.includes('ms')) {
      const parsed = parseInt(cssCustomDuration.match(/(\d+)/)?.[0], 10);
      if (!isNaN(parsed)) {
        duration = parsed;
      }
    }

    // Calculate completion delay based on CSS duration
    const completionDelay = duration + 100; // Add buffer to ensure animation completes

    // Step 1: Set up the direction class on container
    container.classList.remove("tt-direction-forward", "tt-direction-backward")
    container.classList.add(`tt-direction-${direction}`)

    // Force a browser reflow to ensure CSS positioning is applied
    void container.offsetWidth

    // Step 2: Insert the content into inactive slot
    inactiveSlot.innerHTML = ""
    inactiveSlot.appendChild(document.importNode(newContent, true))

    // Step 3: Set initial visibility and positioning
    inactiveSlot.style.visibility = "visible"
    inactiveSlot.style.opacity = "0" // Start completely invisible

    // Position the inactive slot based on direction and variant
    const variant = container.className.match(/tt-variant-(\S+)/)?.[1];

    // For fade variant, don't set any initial transform
    if (variant === 'fade') {
      // No transform needed for fade
      inactiveSlot.style.transform = "translateX(0)";
    } else {
      // For slide and other variants, set initial position
      if (direction === "forward") {
        inactiveSlot.style.transform = "translateX(100%)"
      } else {
        inactiveSlot.style.transform = "translateX(-100%)"
      }
    }

    inactiveSlot.style.left = "0"; // Use transform instead of left positioning
    inactiveSlot.style.top = "0"; // Ensure vertical position is reset

    // Step 4: Disable transitions temporarily to ensure clean start positions
    container.classList.add("tt-no-transition")
    void container.offsetWidth // Force reflow
    container.classList.remove("tt-no-transition")

    // Step 5: Start the animation by adding the animating class
    container.classList.add("tt-animating")

    // Step 6: Apply transform for the actual animation

    if (variant === 'fade') {
      // For fade variant, no transform changes
      activeSlot.style.opacity = "0"
      inactiveSlot.style.opacity = "1"
      // Don't change transforms - keep both at translateX(0)
    }
    else if (variant === 'zoom') {
      // For zoom variant, scale transforms are handled by CSS
      activeSlot.style.opacity = "0"
      inactiveSlot.style.opacity = "1"
    }
    else if (variant === 'bounce') {
      // For bounce variant
      const transformValue = (direction === "forward" ? "translateX(-120%)" : "translateX(120%)");
      activeSlot.style.transform = transformValue;
      inactiveSlot.style.transform = "translateX(0)";
      activeSlot.style.opacity = "0"
      inactiveSlot.style.opacity = "1"
    }
    else {
      // Default slide variant
      const transformValue = (direction === "forward" ? "translateX(-100%)" : "translateX(100%)");
      activeSlot.style.transform = transformValue;
      inactiveSlot.style.transform = "translateX(0)";
      activeSlot.style.opacity = "0"
      inactiveSlot.style.opacity = "1"
    }

    // After animation completes
    setTimeout(() => {
      // Step 7: Temporarily disable transitions before final state change
      container.classList.add("tt-no-transition")

      // Reset transforms FIRST while transitions are disabled
      activeSlot.style.transform = ""
      inactiveSlot.style.transform = ""

      // Move inactive slot to the right place before swapping active state
      inactiveSlot.style.left = "0";

      // Now swap active states
      activeSlot.classList.remove("active")
      inactiveSlot.classList.add("active")

      // Reset opacity
      activeSlot.style.opacity = "0"
      inactiveSlot.style.opacity = "1"

      // Clean up remaining inline styles
      activeSlot.style.visibility = ""
      inactiveSlot.style.visibility = ""

      // Reset container state
      container.classList.remove("tt-animating", "tt-direction-forward", "tt-direction-backward")

      // Force reflow again to ensure changes apply
      void container.offsetWidth

      // Re-enable transitions
      container.classList.remove("tt-no-transition")

      // Fire an event for any listeners
      container.dispatchEvent(new CustomEvent("turbo-transition:complete", {
        detail: { direction, targetId, duration }
      }))

      console.log(`🔄 TurboTransition complete: ${direction}`)
    }, completionDelay) // Dynamic timing based on CSS duration
  }

  // Register the custom action when Turbo is available
  document.addEventListener("turbo:load", () => {
    if (typeof Turbo !== "undefined" && Turbo.StreamActions) {
      console.log("🔄 Registering TurboTransition action")
      Turbo.StreamActions.transition = transitionAction
    } else {
      console.warn("🔄 Turbo not available, TurboTransition action not registered")
    }
  })

  // Also try to register immediately for first page load
  if (typeof Turbo !== "undefined" && Turbo.StreamActions) {
    Turbo.StreamActions.transition = transitionAction
    console.log("🔄 TurboTransition action registered")
  }
})();
