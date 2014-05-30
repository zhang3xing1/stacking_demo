define [
  "jquery"
  "underscore"
  "backbone"

  # Using the Require.js text! plugin, we are loaded raw text
  # which will be used as our views primary template
  "text!templates/lineout/show.html"
], ($, _, Backbone, LineoutShowView) ->
  LineoutShowTemplate = Backbone.View.extend(
    el: $("#right_board")
    render: ->
      
      # Using Underscore we can compile our template with data
      data =
        title: "Line Out"
        buttons: ['Pallet Setting', 'Constraints', 'Layout']
      compiledTemplate = _.template(LineoutShowView, data)
      
      # Append our compiled template to this Views "el"
      @$el.append compiledTemplate
      return
  )
  
  # Our module now returns our view
  LineoutShowTemplate
