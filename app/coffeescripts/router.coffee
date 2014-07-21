define [
  "jquery"
  "underscore"
  "backbone"
  "appController"
  "backboneRoutefilter"
  "tinybox"
  "logger"
  "views/missions/show"
  "views/pattern/index"
  "views/frame/show"
  "views/linein/show"
  "views/lineout/show"
  "views/missions/edit"
  "views/missions/index"
  "views/missions/new"  
  "views/linein/boxSetting"
  "views/linein/placeSetting"
  "views/linein/pickSetting"
  "views/linein/additionalInfo"
  "views/lineout/palletSetting"
  "views/lineout/constraintSetting"
  "views/pattern/show"
], ($, _, Backbone, AppController, BackboneRoutefilter, Tinybox, Logger, MissionShowView, PatternIndexView, FrameShowView, 
  LineinShowView, LineoutShowView, MissionEditView, MissionIndexView, MissionNewView,
  BoxSettingView, PlaceSettingView, PickSettingView, AdditionalInfoView,
  PalletSettingView, ConstraintSettingView, PatternShowView) ->
  class AppRouter extends Backbone.Router
    routes:
      "program": "missionShow"
      "pattern/*action": "pattern"
      "frame":   "frameShow"
      "linein":  "lineinShow"
      "lineout":  "lineoutShow"
      'mission/*action':  "mission_"
      'boxSetting': 'boxSetting'
      'boxSetting': 'boxSetting'
      'placeSetting': 'placeSetting'
      'pickSetting': 'pickSetting'
      'additionalInfo': 'additionalInfo'
      'palletSetting' : 'palletSetting'
      'constraintSetting': 'constraintSetting'
      "patterns": "patternIndex"

      # default root router
      "": "missionShow"

      'saveNewMission' : "saveNewMission"

    initialize: ->
      # other router will not refresh view
      @appData = 
        debugInfo: "hello, this is app data debug info"
      @logger = Logger.create  

      # initialize only one appController
      window.appController = AppController.create
      Backbone.history.start()

    missionShow: ->
      $('.right_board').remove()
      missionShowView = new MissionShowView({app: @appData})
      missionShowView.render()
      return
      
    patternIndex: ->
      $('.right_board').remove()
      patternIndexView = new PatternIndexView
      patternIndexView.render()
      return

    pattern: (action)->
      if action == 'new'
        $('.right_board').remove()
        patternShowView = new PatternShowView
        patternShowView.render()
      if action == 'save'
        @logger.dev "route-save"
        @logger.dev "previous_action.action #{window.appController.previous_action.action}"
        @logger.dev "current_action.action #{window.appController.current_action.action}"
        if window.appController.previous_action.action == 'edit'
          window.appController.saveLayerByID({id: window.appController.selected_layer.id, ulid: window.appController.selected_layer.ulid})
          
          # if layer name was modified, then update the layers and used_layers of mission
          # referring to the ulid of this layer.
          new_name = $('#layer-name').val()
          window.appController.updateUsedLayersNameByUlid(new_name, window.appController.selected_layer.ulid)
          window.appController.selected_layer = undefined

        else
          window.appController.saveLayerByID()
        @navigate("patterns", {trigger: true})
      # if action == 'update'
        # to do 
      if action == 'edit'
        layers = window.appController.getLayers()
        selected_layer_id = $('.list-group-item.selected-item').attr('id')
        selected_layer = layers[selected_layer_id]
        @logger.dev("route-edit: selected_layer_id->#{selected_layer_id}; layers-> #{Object.keys(layers)} ")
        if Object.keys(layers).length == 0 or selected_layer_id == undefined or selected_layer == undefined
          @navigate("patterns", {trigger: true})
          return false
        else
          window.appController.selected_layer = selected_layer
          $('.right_board').remove()
          patternShowView = new PatternShowView
          patternShowView.render()
      if action == 'clone'
        layers = window.appController.getLayers()
        selected_layer_id = $('.list-group-item.selected-item').attr('id')
        selected_layer = layers[selected_layer_id]

        if Object.keys(layers).length != 0 or selected_layer_id != undefined or selected_layer != undefined
          # clone it as a new one before renaming this layer
          clone_layer_name = "#{selected_layer.name} clone" 
          window.appController.saveLayerByID({name: clone_layer_name})

        @navigate("patterns", {trigger: true})
        return false
      if action == 'delete'
        selected_layer_id = $('.list-group-item.selected-item').attr('id')
        if selected_layer_id != '' and selected_layer_id != undefined
          window.appController.removeLayer(selected_layer_id)
          selected_layer_id = undefined
        else
          window.appController.flash(message: 'select a layer to delete first!')

        @navigate("patterns", {trigger: true})
        return false      
      if action == 'info'
        selected_layer_id = $('.list-group-item.selected-item').html()
        if selected_layer_id != '' and selected_layer_id != undefined
          # window.appController.setSelectedLayer(selected_layer_id)
          # $('.right_board').remove()
          # patternShowView = new PatternShowView
          # patternShowView.render()
        else
          @navigate("patterns", {trigger: true})
          return false                 
    frameShow: ->
      
      $('.right_board').remove()
      frameShowView = new FrameShowView
      frameShowView.render()

    lineinShow: ->
      $('.right_board').remove()
      lineinShowView = new LineinShowView
      lineinShowView.render()

    lineoutShow: -> 
      $('.right_board').remove()
      lineoutShowView = new LineoutShowView
      lineoutShowView.render()  

    mission_: (action) ->
      if action == 'edit'
        $('.right_board').remove()
        missionEditView = new MissionEditView
        missionEditView.render() 
        # $('#my-select').multiSelect()

      if action == 'new'
        console.log 'missionNew'
        $('.right_board').remove()
        missionNewView = new MissionNewView
        missionNewView.render() 

      if action == 'index'
        $('.right_board').remove()
        missionIndexView = new MissionIndexView
        missionIndexView.render()     

      if action == 'save'
        window.appController.mission_saved_flag = true
        # todo
      # if action == 'update'
      #   window.router.navigate("#mission/index", {trigger: true})
        # # window.router.navigate("#mission/index", {trigger: true})
        # selected_mission_name = $('.list-group-item.selected-item').html()
        # if selected_mission_name != '' and selected_mission_name != undefined
        #   # check exist
        #   selected_mission_name = undefined
        # else
        #   window.appController.flash(message: 'select a layer to delete first!')        
        # return false
        # # selected_mission_name = 
        # # if one of exist missions has a same name with the to-updated name mission
        # # we could not allow it happen.
      # if action == 

    boxSetting: ->
      console.log 'boxSetting'
      $('.right_board').remove()
      boxSettingView = new BoxSettingView
      boxSettingView.render()  

    pickSetting: ->
      console.log 'pickSetting'
      $('.right_board').remove()
      pickSettingView = new PickSettingView
      pickSettingView.render() 
      $("[name='teach']").bootstrapSwitch('onColor', 'success') 

    placeSetting: ->
      console.log 'placeSetting'
      $('.right_board').remove()
      placeSettingView = new PlaceSettingView
      placeSettingView.render()   
      $("[name='orient']").bootstrapSwitch('onColor', 'success') 

    additionalInfo: ->
      console.log 'additionalInfo'
      $('.right_board').remove()
      additionalInfoView = new AdditionalInfoView
      additionalInfoView.render()   
      $("[name='teach']").bootstrapSwitch('onColor', 'success')  

    palletSetting: ->
      console.log 'palletSetting'
      $('.right_board').remove()
      palletSettingView = new PalletSettingView
      palletSettingView.render()           

    constraintSetting: ->
      console.log 'constraintSetting'
      $('.right_board').remove()
      constraintSettingView = new ConstraintSettingView
      constraintSettingView.render()     

    saveNewMission: ->
      @navigate("", {trigger: true});

    ######################################################
    #
    #
    # Route callback for validating and filtering data.
    #
    #
    ######################################################

    before: (route, params) ->
      @logger.debug("[Before] - route: #{route}, params: #{params}")
      return window.appController.before_action(route, params)
      
    after: (route, params) ->
      ## Change left nav button color
      $('.left-nav-list').removeClass('list-group-item-info')
      # $("[href*='linein']")
      $("#left_board [href*='#{route}']").addClass('list-group-item-info')

      @logger.debug("[After] - route: #{route}, params: #{params}")

      window.appController.after_action(route, params)
      # $('#app-flash').modal()
      # @navigate("loadMission", {trigger: true});

  initialize: new AppRouter
