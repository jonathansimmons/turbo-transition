# TurboTransition

A Rails gem that provides smooth, animated transitions for Turbo Stream updates. Create beautiful multi-step forms, wizards, and content transitions with minimal effort.

## Why TurboTransition?

### The Problem with Standard Turbo Stream Animations

Turbo Stream's standard actions (`replace`, `update`, etc.) have a fundamental limitation when it comes to animations: they operate in a "single DOM space." When you replace content with Turbo:

1. The existing element is immediately removed from the DOM
2. The new element is inserted in its place
3. There's no "in-between" state where both elements exist simultaneously

This makes it difficult to create smooth transitions between content, as you can't simultaneously animate the old content out while animating the new content in. Attempting to work around this limitation typically requires complex JavaScript and CSS, often resulting in an abrupt or inconsistent user experience.

### The TurboTransition Solution

TurboTransition solves this problem by:

1. **Using a two-slot pattern**: A container with two slots where one is active and one is inactive
2. **Custom Turbo Stream action**: A new `transition` action that handles content replacement differently
3. **Coordinated animations**: Simultaneous exit and entrance animations between slots

Instead of replacing content directly, TurboTransition:
- Keeps the existing content in place
- Loads the new content into the inactive slot
- Animates both slots simultaneously (old content out, new content in)
- Swaps the active/inactive states once animation is complete

This creates much smoother, more professional transitions between content without the jarring experience of standard Turbo Stream updates.

## Installation

1.  **Add the Gem:** Add this line to your application's Gemfile:

    ```ruby
    # Gemfile
    gem 'turbo_transition', git: 'https://github.com/jonathansimmons/turbo-transition.git' # Or your repo URL
    ```

2.  **Install:** Run Bundler:

    ```bash
    bundle install
    ```

3.  **Run the Installation Generator:**

    ```bash
    bin/rails generate turbo_transition:install
    ```

    This will:
    - Copy the CSS file to your app/assets/stylesheets/vendor directory
    - Show you the next steps needed to complete installation

4.  **Include Assets:** Add the CSS and JavaScript to your application:

    ```erb
    <%# app/views/layouts/application.html.erb - for Sprockets %>
    <%= stylesheet_link_tag "application", "vendor/turbo_transition", "data-turbo-track": "reload" %>

    <%# app/views/layouts/application.html.erb - for Propshaft/Tailwind %>
    <%= stylesheet_link_tag :app, "vendor/turbo_transition", "data-turbo-track": "reload" %>
    ```

    And in your JavaScript entry point:

    ```javascript
    // app/javascript/application.js
    import "turbo_transition"
    ```

    If you're using importmap, add:

    ```ruby
    # config/importmap.rb
    pin "turbo_transition", preload: true
    ```

5.  **Include Helper:** To use the transition helpers in your views:

    ```ruby
    # app/helpers/application_helper.rb
    module ApplicationHelper
      include TurboTransitionHelper
    end
    ```

6.  **Restart Server:** Restart your Rails server for the changes to take effect.

## Usage

### Basic Setup

TurboTransition requires a container with two slots for content to transition between.

#### Using ViewComponents (Recommended)

```erb
<%= render TurboTransition::ContainerComponent.new(id: "my-wizard", variant: "slide") do |container| %>
  <%= container.with_slot(active: true) do %>
    <h2>Step 1 Content</h2>
    <p>This is the first step</p>

    <%= form_with(url: next_step_path, data: { turbo_stream: true }) do |f| %>
      <!-- Form fields -->
      <%= f.submit "Next" %>
    <% end %>
  <% end %>

  <%= container.with_slot do %>
    <!-- This will be empty initially, content is loaded via Turbo -->
  <% end %>
<% end %>
```

#### Using Helper Methods (Alternative)

```erb
<div id="my-wizard" class="tt-container tt-variant-slide">
  <div class="tt-slot active">
    <h2>Step 1 Content</h2>
    <p>This is the first step</p>

    <%= form_with(url: next_step_path, data: { turbo_stream: true }) do |f| %>
      <!-- Form fields -->
      <%= f.submit "Next" %>
    <% end %>
  </div>

  <div class="tt-slot">
    <!-- Empty slot for next content -->
  </div>
</div>
```

### Creating Transitions

Currently, TurboTransition supports creating transitions from view templates only:

```erb
<%= turbo_transition_stream(
  target: "my-wizard",
  partial: "steps/step2",
  direction: "forward"
) %>
```

You can use this in your view responses to Turbo Stream requests. Controller-level support will be added in a future release.

### How It Works

When the `turbo_transition_stream` helper is called:

1. It creates a custom `<turbo-stream action="transition">` tag
2. The custom action is processed by JavaScript that:
   - Places new content into the inactive slot
   - Sets up the initial positioning based on the transition direction
   - Adds animation classes to trigger transitions on both slots simultaneously
   - After animation completes, swaps the active/inactive states
   - Cleans up any temporary styles

This approach allows for seamless transitions between content states, without the typical abrupt changes caused by standard Turbo Stream actions.

### Animation Variants

TurboTransition comes with several built-in animation variants:

- `slide` (default) - Horizontal slide transition with fade effect
- `fade` - Simple fade transition
- `zoom` - Zoom in/out effect
- `bounce` - Bouncy transition with elastic easing

Specify the variant in the container component or class:

```erb
<%= render TurboTransition::ContainerComponent.new(id: "my-wizard", variant: "zoom") %>
```

### Direction

Specify the direction of the animation:

```erb
<%= turbo_transition_stream(
  target: "my-wizard",
  partial: "steps/step2",
  direction: "backward"
) %>
```

The `direction` parameter accepts:
- `forward` (default) - Navigate forward/next
- `backward` - Navigate backward/previous

### Animation Duration

You can customize the animation duration using CSS variables. This approach allows you to set durations that persist across transitions:

#### Global Duration Setting

Set a global duration for all transitions in your CSS:

```css
/* In your application.css or other global stylesheet */
:root {
  --tt-duration: 1000ms; /* All transitions will use this duration (1 second) */
}
```

#### Container-Specific Duration

Set a duration for a specific container using CSS:

```css
/* In your application.css or other stylesheet */
#my-wizard {
  --tt-duration: 4000ms; /* This specific container will use 4-second transitions */
}
```

#### Inline Styles

For one-off customizations, you can also use inline styles:

```erb
<div id="my-wizard" class="tt-container tt-variant-slide" style="--tt-duration: 500ms;">
  <!-- Container content -->
</div>
```

Common duration values:
- `1000ms` - Slower, more dramatic transitions (1 second)
- `500ms` - Default speed (half second)
- `300ms` - Quick transitions
- `100ms` - Very fast transitions
