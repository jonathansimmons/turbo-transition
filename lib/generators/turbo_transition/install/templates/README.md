===============================================================================

TurboTransition has been successfully installed!

The CSS file has been copied to:
  app/assets/stylesheets/vendor/turbo_transition.css

Next steps:

1. Add the CSS to your layout:

```erb
<%# For regular Sprockets apps %>
<%= stylesheet_link_tag "application", "vendor/turbo_transition", "data-turbo-track": "reload" %>

<%# For Propshaft/Tailwind apps %>
<%= stylesheet_link_tag :app, "vendor/turbo_transition", "data-turbo-track": "reload" %>
```

2. Add the JavaScript to your application:

```javascript
// In your JavaScript entry point (app/javascript/application.js)
import "turbo_transition"
```

3. If you're using the ViewComponents, add this to your controller:

```ruby
class ApplicationController < ActionController::Base
  include TurboTransitionHelper
end
```

===============================================================================
