define [
  "jquery"
  "underscore"
  "backbone"
  "views/program/current"
], ($, _, Backbone, ProgramCurrentView) ->
  class AppRouter extends Backbone.Router
    routes:
      "test1": "index"
      "show/:id": "show"
      "download/*random": "download"
          
    initialize: ->
      Backbone.history.start()

    index: ->
      alert 'yoooo'
      $(document.body).append "Index route has been called.."
      programCurrentView = new ProgramCurrentView
      programCurrentView.render()
      return

    show: (id) ->
      $(document.body).append "Show route has been called.. with id equals : ", id
      return

    download: (random) ->
      $(document.body).append "download route has been called.. with random equals : ", random
      return


  initialize: new AppRouter