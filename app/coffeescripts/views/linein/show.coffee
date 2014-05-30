define [
  "jquery"
  "underscore"
  "backbone"

  # Using the Require.js text! plugin, we are loaded raw text
  # which will be used as our views primary template
  "text!templates/linein/show.html"
], ($, _, Backbone, LineinShowView) ->
  LineinShowTemplate = Backbone.View.extend(
    el: $("#right_board")
    render: ->
      
      # Using Underscore we can compile our template with data
      data =
        title: "Line In"
        buttons: [
          {
            name: 'Box Info'
            router: "#boxSetting"
          }
          {
            name: 'Box Place Location'
            router: "#boxSetting"
          }
          {
            name: 'Box Pick Location'
            router: "#boxSetting"
          }
          {
            name: 'Addtional Info'
            router: "#boxSetting"
          }                    
        ]
      compiledTemplate = _.template(LineinShowView, data)
      
      # Append our compiled template to this Views "el"
      @$el.append compiledTemplate
      return
  )
  
  # Our module now returns our view
  LineinShowTemplate
