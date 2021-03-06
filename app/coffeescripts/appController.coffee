#every share data of single mission will be store here
define ["logger", "tinybox", 'jquery', 'backbone', 'mission','rivets'], (Logger, Tinybox, $, Backbone, Mission, rivets) ->
  class AppController
    constructor: ->
      @logger = Logger.create 
      @mission = Mission.create

      @new_mission = Mission.create
      @previous_action = undefined
      @current_action = undefined

      ## view shared
      # pattern index -> for edit layer
      @selected_layer = undefined

      ## mission edit page -> for order of layers
      @removed_layer_index = -1

      # @remote_url = 'http://192.168.56.2/'
      # @remote_url = 'http://172.22.117.53/'
      @remote_url = 'http://192.168.1.101:4242/'
      # @remote_url = 'http://127.0.0.1:8000/'
      @program_name = 'pd_db2'

      @mission_saved_flag = true
      @pattern_saved_flag = true

      # mission index page
      @mission_list = []



      # pallets template data
      @pallet_templates = [
          {
            id:   0
            name: 'Industrie-Palette'
            length: 1200
            width:  1000
            max_height: 1500
            height:   145
          }
          {
            id:   1
            name: 'Chep 1200 × 1000'
            length: 1200
            width:  1000
            max_height: 1500
            height:   172
          }
          {
            id:   2
            name: 'Chep Halbpalette'
            length: 800
            width:  600
            max_height: 1500
            height:   158
          }
          {
            id:   3
            name: 'Chep 600 × 400'
            length: 600
            width:  400
            max_height: 1000
            height:   145
          }
          {
            id:   4
            name: 'niche definiert'
            length: 1200
            width:  800
            max_height: 1500
            height:   145
          }                              
        ]      

      # flag of timeout for calculation of tool
      @is_timeout = true


      # all tool names from pdl
      @tool_names = []
    sleep: (d = 100) ->
      t = Date.now()
      while Date.now() - t <= d
        d

    #
    #  ajax request to pdl sever
    #
    set_request: (options) =>
      if options.type == 'str'
        options.value = "'#{ options.value}'"  

      get_url = "set?var=#{options.name}&prog=#{@program_name}&value=#{options.value}"
      # console.log "#{@remote_url}#{get_url}"

      $.ajax
        url: get_url
        cache: false
        async: false
        success: (data) ->
          options.callback data if options.callback != undefined
        error: () ->
          window.appController.logger.dev "[set]: error"        
        
    get_request: (options) =>
      get_url = "get?var=#{options.name}&prog=#{@program_name}"
      console.log "#{@remote_url}#{get_url}"
      $.ajax
        url: get_url
        cache: false
        async: false
        success: (data) ->
          options.callback data if options.callback != undefined
        error: () ->
          window.appController.logger.dev "[get]: error" 
    
    get_mission_list: =>
      get_url = "get?dirList=UD:/usr/dev/"
      # console.log "#{@remote_url}#{get_url}"

      $.ajax
        url: get_url
        cache: false
        async: false
        success: (data) ->
          window.appController.mission_list = JSON.parse(data)
        error: () ->
          window.appController.logger.dev "[get_mission_list]: error" 

    get_tool_names: =>
      @routine_request(name: 'getToolNames')
      @get_request(name: 'tool_names', callback: (data) ->
        tool_names_data = JSON.parse(data)
        if tool_names_data.tool_names != undefined
          window.appController.tool_names = tool_names_data.tool_names
        )

    routine_request: (options) =>
      params = options.params
      if params != undefined 
        params_ = _.map(params, (param)->
          if typeof(param) == 'string'
            "'#{param}'" 
          else
            param
          )
        result = "(#{params_.join(',')})"
      else
        result = ''

      get_url = "run?routine=#{options.name}#{result}&prog=#{@program_name}"
      console.log "#{@remote_url}#{get_url}"
      $.ajax
        url: get_url
        cache: false
        async: false
        success: (data) ->
          options.callback data if options.callback != undefined
        error: () ->
          window.appController.logger.dev "[get]: error" 
  
    set_selected_layer_name: (selected_layer_name) =>
      window.appController.set_request(name:'edting_layer_name', value: selected_layer_name, type: 'str')

    get_selected_layer_name:() =>
      selected_layer_name = ''
      window.appController.get_request(name:'edting_layer_name', callback: (data) ->
        selected_layer_name = data)
      selected_layer_name

    set_stored_layer_name: (stored_layer_name) =>
      window.appController.set_request(name:'stored_layer_name', value: stored_layer_name, type: 'str')

    get_stored_layer_name:() =>
      stored_layer_name = ''
      window.appController.get_request(name:'stored_layer_name', callback: (data) ->
        stored_layer_name = data)
      stored_layer_name
      
    load_whole_mission_data: (mission_data_name) => 

      @mission.set('available_layers', {})
      @mission.set('used_layers', [])

      @routine_request(
        name: 'loadVarFile'
        params: [mission_data_name])

      @load_tool_data()
      @load_frame_in_data()
      @load_frame_out_data()
      @load_missionData_data()
      @load_settingData_data()

    load_tool_data: =>
        @routine_request(name: 'getTool')
        @get_request(
          name:'setting_data'
          callback: (data) ->
            window.appController.mission.load_setting_info(JSON.parse(data)) )

    load_frame_in_data: =>
        @routine_request(name: 'getFrameIn')
        @get_request(
          name:'setting_data'
          callback: (data) ->
            window.appController.mission.load_setting_info(JSON.parse(data)) )

    load_frame_out_data: =>
        @routine_request(name: 'getFrameOut')
        @get_request(
          name:'setting_data'
          callback: (data) ->
            window.appController.mission.load_setting_info(JSON.parse(data)) )        

    load_missionData_data: =>
      @get_request(
        name: 'mission_data'
        callback: (data) ->
          window.appController.mission.load_mission_info(JSON.parse(data)) )
      
    load_settingData_data: =>
      @get_request(
        name:'setting_data'
        callback: (data) ->
          window.appController.mission.load_setting_info(JSON.parse(data)) )
    load_layers_data: =>
      @get_request(
        name: 'layers'
        callback: (data) ->
          window.appController.mission.load_layers_info(JSON.parse(data))
      )    
    load_used_layers_data: =>      
      @get_request(
        name: 'used_layers'
        callback: (data) ->
          window.appController.mission.load_used_layers_info(JSON.parse(data)) 
      )      

    flash: (options={closable: true})->
      $('#popup').html(options.message)
      $("#popup").modal
        escapeClose: options.closable
        clickClose: options.closable
        showClose: options.closable

    # decide if router be valid
    before_action: (route, params) ->
      action = params[0]
      @previous_action = @current_action
      @current_action = {route: route, action: params[0]}
      @logger.debug "[before_action]: @previous_action #{@previous_action.route} #{@previous_action.action}" if @previous_action != undefined
      @logger.debug "[before_action]: @current_action #{@current_action.route} #{@current_action.action}" if @previous_action != undefined
      rivets.adapters[":"] =
        subscribe: (obj, keypath, callback) ->
          # console.log("1.subscribe:\t #{obj} ||\t #{keypath}")
          obj.on "change:" + keypath, callback
          return

        unsubscribe: (obj, keypath, callback) ->
          # console.log("2.unsubscribe:\t #{obj} ||\t #{keypath}")
          obj.off "change:" + keypath, callback
          return

        read: (obj, keypath) ->
          # console.log("3.read:\t\t\t #{obj} ||\t #{keypath}")
          # if((obj.get keypath) == undefined)
          #   console.log("3.read:++ #{obj[keypath]()} \t #{(obj.get keypath)}")
          #   obj[keypath]()
          # else
          #   obj.get keypath
          obj.get keypath

        publish: (obj, keypath, value) ->
          # console.log("4.publish:\t\t #{obj} ||\t #{keypath}")
          obj.set keypath, value
        
      # get mission list data    
      @get_mission_list()

      if route == 'mission/*action'
        if action == 'new'
          if window.appController.mission_saved_flag == true
            @mission = @new_mission
          else
            @flash({message: 'Do you want to abandon the modification?'})
            window.router.navigate("#program", {trigger: true})
            return false
        if action == 'save'
          @flash(message: 'Saving Data......', closable: false)

        if action == 'save_as'
          new_message = '<form class="navbar-form"> <div class="form-group"> <input type="text" class="form-control" id="to-renamed-mission" placeholder="'\
            + "#{selected_mission_name}" + '"> </div> <a class="btn btn-default" id="misson_rename">Rename</a> </form>'          
          @flash(message: 'Saving Data......', closable: false)

      if route == 'pattern/*action'
        if action == 'new' or action == 'clone'
          unless @mission.validate_layers(attr: 'count')
            window.router.navigate("#patterns", {trigger: true} )
            @flash(message: 'Reach the maximam number of Pattern!', closable: true)
            return false
    after_action: (route, params) =>
      action = params[0]
      rivets.bind $('.mission_'),{mission: @mission}
      @is_timeout = true

      @load_whole_mission_data()

      if route == '' or route == 'program'
        @load_layers_data()
        @load_used_layers_data()

      if route == 'frame'
        $("input").attr "readonly", true
        $("input[rv-value$='index']").attr "readonly", false

      if route == 'placeSetting'
        orient_value = window.appController.mission.get('orient')
        $("[name='orient']").bootstrapSwitch('state', orient_value) 
        $("[name='orient']").on "switchChange.bootstrapSwitch", (event, state) ->
          # console.log this # DOM element
          # console.log event # jQuery event
          # console.log state # true | false

          # state turn to be off, then button 'set' turn to be button 'PLACE'
          window.appController.mission.set('orient', state)
      
      if route == 'additionalInfo'
        length_wise_value = window.appController.mission.get('length_wise')
        $("[name='length']").bootstrapSwitch('state', length_wise_value) 
        $("[name='length']").on "switchChange.bootstrapSwitch", (event, state) ->
          window.appController.mission.set('length_wise', state)
          $("[name='cross']").bootstrapSwitch('state', !state) 

        
        cross_wise_value = window.appController.mission.get('cross_wise')
        $("[name='cross']").bootstrapSwitch('state', cross_wise_value) 
        $("[name='cross']").on "switchChange.bootstrapSwitch", (event, state) ->
          window.appController.mission.set('cross_wise', state)
          $("[name='length']").bootstrapSwitch('state', !state) 
      
      if route == 'mission/*action'
        if action == 'delete'
          @get_mission_list()
          selected_mission_name = $('.list-group-item.selected-item').html()
          if _.contains(@mission_list, "#{selected_mission_name}.var")
            @routine_request(name: 'deleteVarFile', params: [selected_mission_name])
          else
            @flash("#{selected_mission_name} does not exist!", close: true)
          window.router.navigate("#mission/index", {trigger: true})
          return false
        
        if action == 'rename'
          selected_mission_name = $('.list-group-item.selected-item').html()
          if selected_mission_name == undefined
            window.router.navigate("#mission/index", {trigger: true})
            return false

          new_message = '<form class="navbar-form"> <div class="form-group"> <input type="text" class="form-control" id="to-renamed-mission" placeholder="'\
            + "#{selected_mission_name}" + '"> </div> <a class="btn btn-default" id="misson_rename">Rename</a> </form>'
          @flash({message: new_message, closable: false})
          $('#misson_rename').click ->
            if ($('#to-renamed-mission').val() != '')
              ## todo
              ## rename the mission after validate it if no same name with exists missions
              console.log "todo -> rename mission in pdl"
            $.modal.close()

          window.router.navigate("#mission/index", {trigger: true})
          return false

        if action == 'index'
          $('a[href="#mission/load"]').click ->
            window.appController.flash(message: 'Loading Data...', closable: false)
          @get_mission_list()
          if @mission_list.length > 0
            _.each(window.appController.mission_list, (a_mission) ->
              r_var_file = /\w+\.var$/
              if r_var_file.test(a_mission)
                $('#mission_list').append("<li class=\"list-group-item mission_item\" >#{a_mission.substring(0,a_mission.length-4)}</li>"))

            $(".mission_item").on('click', (el) ->
              $(".mission_item").removeClass('selected-item')
              $(this).addClass('selected-item')
            )

        if action == 'save'
          @load_layers_data()
          @load_used_layers_data()

          @routine_request(name: 'saveVarFile', params:[@mission.get('name')])
          @mission.generateCSVData()
          @get_mission_list()
          
          # window.appController.sleep(1000)
          $.modal.close()
          window.router.navigate("#program", {trigger: true})
        if action == 'edit'
          # init avaiable layers
          # destroy all data in multi_select
          @load_layers_data()
          @load_used_layers_data()

          $('.ms-list').empty()
          $('#my-select').empty()

          _.each(@mission.get('available_layers'),((a_layer, layer_index) ->
            $('#my-select').append( "<option value='#{a_layer.name}-----#{Math.random()*10e16}'>#{a_layer.name}</option>" )
            ),this) 

          $('#my-select').prepend( "<option value='PALLET' selected>0: PALLET</option>" )
          _.each(window.appController.getUsedLayersOrder(),((a_layer, layer_index) ->
              $('#my-select').prepend( "<option value=#{a_layer.option_value} layer-index='#{layer_index}' selected>#{layer_index+1}: #{a_layer.name}</option>" )
            ),this) 

          $('#my-select').multiSelect
            afterSelect: (option_value) =>
              @logger.debug "afterSelect: #{option_value}"

              # get select layer value
              regex = /\s*-----\s*/
              selected_layer_info = option_value[0].split(regex)
              selected_layer_name = selected_layer_info[0]
              selected_layer_ulid = @getUlidByName(selected_layer_name)

              if window.appController.mission.validate_used_layers(attr: 'count')
                window.appController.addToUsedLayers(selected_layer_name, option_value[0], selected_layer_ulid)
              else
                window.appController.flash(message: "Reach maximam number of used layers")

              @refreshSelectableAndSelectedLayers()

              # mission changed
              window.appController.mission_saved_flag = false

              # synchronize data on used_layers
              @routine_request(name: 'resetUsedLayers')
              @sendUsedLayersToSave()
              # mission binding by rivets
              rivets.bind $('.mission_'),{mission: window.appController.mission}
 
            afterDeselect: (option_value) =>
              @logger.debug "afterDeselect: #{option_value}"
              # remove selected item
              regex = /\s*-----\s*/
              value = option_value[0].split(regex)
              value_name = value[0]

              # to_remove_used_layer_index = $("option[value='" + option_value + "']").attr('layer-index')

              window.appController.removeFromUsedLayers(option_value)
              @refreshSelectableAndSelectedLayers()
              window.appController.mission_saved_flag = false

              # synchronize data on used_layers
              @routine_request(name: 'resetUsedLayers')
              @sendUsedLayersToSave()
              # mission binding by rivets
              rivets.bind $('.mission_'),{mission: window.appController.mission}

          $("input").attr('readonly',true)
        if action == 'load'
          selected_mission_name = $('.list-group-item.selected-item').html()
          if selected_mission_name != undefined
            @mission.set('name', selected_mission_name)
            # console.log "selected_mission_name: #{selected_mission_name}"
            # console.log "@mission.get('name'): #{@mission.get('name')}"

            # console.log "----->before: load_whole_mission_data"
            @load_whole_mission_data(selected_mission_name)
            # console.log "----->after: load_whole_mission_data"

            $.modal.close()
            window.router.navigate("#program", {trigger: true})
            rivets.bind $('.mission_'),{mission: @mission} 
            return false 

          $.modal.close()
          window.router.navigate("#mission/index", {trigger: true})
          return false 

        if action == 'reload'
          @get_mission_list()
          to_reload_mission_name = "#{@mission.get('name')}.var"
          if _.contains(@mission_list, to_reload_mission_name)
            @routine_request(name: 'loadVarFile', params: [to_reload_mission_name])
            # console.log "----->before: reload_whole_mission_data"
            @load_whole_mission_data(selected_mission_name)
            # console.log "----->after: reload_whole_mission_data"
          else
            @flash(message: "[#{@mission.get('name')}] does not exist in ROBOT!", close: true)
          window.router.navigate("#program", {trigger: true})
          return false 

      if route == 'patterns'
        @load_layers_data()
        @load_used_layers_data()

        @set_selected_layer_name('')
        # @set_stored_layer_name('')

        layers = _.values(@mission.get('available_layers'))
        for a_layer in layers
          # SHEET  are layers can not access
          if a_layer.name != 'SHEET'
            $('#patterns').append( "<li class=\"list-group-item\" id=\"#{a_layer.id}\">#{a_layer.name}</li>" )
  
        $("[id^='layer-item-']").on('click', (el) ->
          $("[id^='layer-item-']").removeClass('selected-item')
          $(this).addClass('selected-item')
          selected_layer_name = $('.list-group-item.selected-item').html()
          window.appController.set_selected_layer_name(selected_layer_name)
          return
        )

      if route == 'calculateTool'
        $("input").attr "readonly", true
        # $("input[rv-value^='mission:tool_']").attr "readonly", false

        @is_timeout = false
        setTimeout (->
          window.appController.routine_request(name: 'calculate_tool_data')
          window.appController.load_settingData_data()
          setTimeout arguments.callee, 500  unless window.appController.is_timeout 
        ), 500

      if route == 'tools'
        @get_tool_names()
        if @tool_names.length > 0
          _.each(window.appController.tool_names, (a_tool_name, index) ->
            $('#tool_list').append("<li class=\"list-group-item tool_item\" tool_index='#{index+1}'>#{index+1}: #{a_tool_name}</li>"))

          $(".tool_item").on('click', (el) ->
            window.appController.set_request(name: 'setting_data.tool_index', value: $(this).attr('tool_index'))
            window.router.navigate("pickSetting", {trigger: true})
          ) 

      if route == 'palletTemplate'
        for a_pattet in @pallet_templates
          # SHEET  are layers can not access
          if a_pattet.name != 'SHEET'
            $('#patterns').append( "<li class=\"list-group-item\" id=\"pallet-template-#{a_pattet.id}\" pallet-index=\"#{a_pattet.id}\"  >#{a_pattet.name}</li>" )
  
        $("[id^='pallet-template-']").on('click', (el) ->
          $("[id^='pallet-template-']").removeClass('selected-item')
          $(this).addClass('selected-item')
          pallet_template = window.appController.pallet_templates[Number.parseInt($('.list-group-item.selected-item').attr('pallet-index'))]
          # window.appController.set_request(name: 'setting_data.pallet_length', value: pallet_template.length)
          # window.appController.set_request(name: 'setting_data.pallet_width', value: pallet_template.width)
          # window.appController.set_request(name: 'setting_data.pallet_height', value: pallet_template.height)
          # window.appController.set_request(name: 'setting_data.max_height', value: pallet_template.max_height)
          window.appController.mission.set('pallet_width', pallet_template.width)
          window.appController.mission.set('pallet_height', pallet_template.height)
          window.appController.mission.set('pallet_length', pallet_template.length)
          window.appController.mission.set('max_height', pallet_template.max_height)

          window.router.navigate("palletSetting", {trigger: true})
        )
      if route == 'pattern/*action'
        @load_layers_data()
        if action == 'new'
          window.appController.set_selected_layer_name('')
          $('#layer-name').val("Layer_#{(Math.random()*10e16).toString().substr(0,5)}")
          $('#layer-name').focus().select()


          # $("#layer-name").focusin(->
          #   return 
          # ).focusout ->
          #   if $('#layer-name').val() == ''
          #     window.appController.flash(message: 'layer name can not be empty!')
          #     new_layer_name = "Layer_#{(Math.random()*10e16).toString().substr(0,5)}"
          #   else
          #     new_layer_name = $('#layer-name').val()    
          #   new_layer_name = window.appController.mission.generate_valid_layer_name(new_layer_name)
          #   $('#layer-name').val(new_layer_name)
          #   $('#layer-name').focus()


        if action == 'edit'
          selected_layer_name = window.appController.get_selected_layer_name()
          selected_layer = window.appController.mission.getLayerDataByName(selected_layer_name)
          @load_pattern_data(selected_layer)

          $('#layer-name').val(selected_layer_name)  
          $('#layer-name').focus()


        if action == 'clone'
          selected_layer_name = window.appController.get_selected_layer_name()
          selected_layer = window.appController.mission.getLayerDataByName(selected_layer_name)
          if selected_layer != undefined
            # clone it as a new one before renaming this layer
            clone_layer_name = "#{selected_layer.name}_clone" 
            window.appController.saveLayerBy({name: clone_layer_name, boxes: selected_layer.boxes})

          window.router.navigate("patterns", {trigger: true})
          return false 

      rivets.bind $('.mission_'),{mission: @mission}    

      if route == 'pickSetting'
        $("input").attr "readonly", true
        $("input#table-index").attr "readonly", false
        
        @load_tool_data()     

        rivets.bind $('.mission_'),{mission: @mission}     

      if route == 'tool/*action' 
        if action == 'set'   
          @mission.set('tool_position_x', @mission.get('tcp_position_x'))
          @mission.set('tool_position_y', @mission.get('tcp_position_y'))
          @mission.set('tool_position_z', @mission.get('tcp_position_z'))
          @mission.set('tool_position_a', @mission.get('tcp_position_a'))
          @mission.set('tool_position_r', @mission.get('tcp_position_r'))
          @mission.set('tool_position_e', @mission.get('tcp_position_e'))

          @set_request(name: 'setting_data.tool_position_x', value: @mission.get('tcp_position_x'))
          @set_request(name: 'setting_data.tool_position_y', value: @mission.get('tcp_position_y'))
          @set_request(name: 'setting_data.tool_position_z', value: @mission.get('tcp_position_z'))
          @set_request(name: 'setting_data.tool_position_a', value: @mission.get('tcp_position_a'))
          @set_request(name: 'setting_data.tool_position_r', value: @mission.get('tcp_position_r'))
          @set_request(name: 'setting_data.tool_position_e', value: @mission.get('tcp_position_e'))
          
          window.router.navigate("#pickSetting", {trigger: true})
          rivets.bind $('.mission_'),{mission: @mission} 

    # functions for mission edit page

    refreshSelectableAndSelectedLayers: ->
      # destroy all data in multi_select
      $('.ms-list').empty()
      $('#my-select').empty()

      _.each(@mission.get('available_layers'),((a_layer, layer_index) ->
        $('#my-select').append( "<option value='#{a_layer.name}-----#{Math.random()*10e16}'>#{a_layer.name}</option>" )
        ),this) 

      $('#my-select').prepend( "<option value='PALLET' selected>0: PALLET</option>" )
      _.each(window.appController.getUsedLayersOrder(),((a_layer, layer_index) ->
          $('#my-select').prepend( "<option value=#{a_layer.option_value} layer-index='#{layer_index}' selected>#{layer_index+1}: #{a_layer.name}</option>" )
        ),this) 

      $('#my-select').multiSelect('refresh')   

    setBoard: (newBoard) ->
      @board = newBoard

    getLayers: ->
      @mission.get('available_layers') 

    addLayer: (new_layer) ->
      @mission.addLayer(new_layer)

      @routine_request(name: 'resetBoxes')
      @routine_request(name: 'resetLayers')
      @sendLayersToSave()

    removeLayer: (layer_data) ->
      @mission.removeLayer(layer_data.id)

      @routine_request(name: 'resetBoxes')
      @routine_request(name: 'resetLayers')
      @sendLayersToSave()

      @routine_request(name: 'resetUsedLayers')
      @sendUsedLayersToSave()

      # mission changed
      window.appController.mission_saved_flag = false
       
    saveLayerBy: (layer_params) ->
      if layer_params.id == undefined
        layer_params.id = "layer-item-#{layer_params.name}-#{Math.random()*10e17}"

      if layer_params.ulid == undefined
        layer_params.ulid ="#{layer_params.name}------ulid#{Math.random()*10e17}"  

      @addLayer(layer_params)
      # mission changed

      window.appController.mission_saved_flag = false      

    getAvailableLayersOrder: ->
      @mission.getAvailableLayersOrder()

    addToUsedLayers: (layer_name, layer_option_value, layer_ulid)->
      @mission.addToUsedLayers(layer_name, layer_option_value, layer_ulid)

    getUsedLayersOrder: ->
      @mission.getUsedLayersOrder()

 
    removeFromUsedLayers: (layer_option_value) ->
      @mission.removeFromUsedLayers(layer_option_value)

      # mission changed
      window.appController.mission_saved_flag = false

    load_pattern_data: (layer_data)->   
      if layer_data != undefined    
        $('#layer-name').val(layer_data.name)
        _.each(layer_data.boxes, (a_box) ->
          window.appController.board.boxes.createNewBox(a_box)
          )

    getUlidByName: (layer_name) ->
      @mission.getLayerDataByName(layer_name).ulid 

    updateUsedLayersNameByUlid:(new_layer_name, layer_ulid) ->
      @mission.updateUsedLayersNameByUlid(new_layer_name, layer_ulid)

      @routine_request(name: 'resetBoxes')
      @routine_request(name: 'resetLayers')
      @sendLayersToSave()

      @routine_request(name: 'resetUsedLayers')
      @sendUsedLayersToSave()
    #
    # generate layers data to save data from js to pdl
    #

    sendLayersToSave: =>
      available_layers = @mission.get('available_layers')
  
      _.each(available_layers, ((a_layer) =>
        if a_layer.name != 'SHEET'
          layer_name = a_layer.name
          layer_boxes = a_layer.boxes

          @routine_request(
            name: 'addNewLayer'
            params:[layer_name]
          )

          _.each(layer_boxes, ((a_box) =>
            @set_request(name: 'request_box.x', value: a_box.x)
            @set_request(name: 'request_box.y', value: a_box.y)
            @set_request(name: 'request_box.arrow', value: a_box.arrow)
            @set_request(name: 'request_box.arrowEnabled', value: a_box.arrowEnabled.toString())
            @set_request(name: 'request_box.layer_name', value: layer_name, type: 'str')
            @set_request(name: 'request_box.rotate', value: a_box.rotate)  
            @routine_request(name: 'addNewBox')          
            ), this)
          ), this)

    sendUsedLayersToSave: =>
      used_layers = @mission.get('used_layers')
 
      _.each(used_layers, ((a_layer) =>
        @routine_request(name: 'addNewUsedLayer', params:[a_layer.name])
        ), this)      
    default_pattern_params: ->
      canvasStage =  
            width:      280
            height:     315 
            stage_zoom: 1.5

      # color: RGB
      color = 
          stage:   
              red:    255
              green:  255
              blue:   255
          pallet: 
              red:    251
              green:  209
              blue:   175
          overhang: 
              stroke:
                red:    238
                green:  49
                blue:   109
                alpha:  0.5
          boxPlaced:
            inner:
              red:    79
              green:  130
              blue:   246
              alpha:  0.8
              stroke:
                red:    147
                green:  218
                blue:   87
                alpha:  0.5
            outer:
              red:    0
              green:  0
              blue:   0
              alpha:  0
              stroke:
                red:    0
                green:  0
                blue:   0
                alpha:  0
          boxSelected:
            collision:
              inner:
                red:    255
                green:  0
                blue:   0
                alpha:  1
                stroke:
                  red:    147
                  green:  218
                  blue:   87
                  alpha:  0.5
              outer:
                red:    255
                green:  0
                blue:   0
                alpha:  0.5
                stroke:
                  red:    255
                  green:  0
                  blue:   0
                  alpha:  0.5           
            uncollision:
              inner:
                red:    108
                green:  153
                blue:   57
                alpha:  1
                stroke:
                  red:    72
                  green:  82
                  blue:   38
                  alpha:  0.5
              outer:
                red:    0
                green:  0
                blue:   0
                alpha:  0
                stroke:
                  red:    70
                  green:  186
                  blue:   3
                  alpha:  0.5


      pallet =  
            width:    @mission.get('pallet_length')
            height:   @mission.get('pallet_width')
            overhang: @mission.get('overhang_len')

      box  =      
            x:      0 
            y:      0
            width:  @mission.get('box_length') 
            height: @mission.get('box_width')
            minDistance: @mission.get('mini_distance')


      params = 
          pallet: pallet
          box: box
          stage: canvasStage
          color: color  

      params


    # # integer
    # $("button.get." + "integer").click ->
    #   aGetRequest "gui_" + "integer", (data) ->
    #     $("label.get." + "integer").html data
    #     $("#flash").html "Get " + varName + " done!"
    #     return

    #   return

    # $("button.set." + "integer").click ->
    #   setValue = $("input.set.integer").val()
    #   aSetRequest "gui_" + "integer", setValue, (data, varName) ->
    #     $("#flash").html "Set " + varName + " done!"
    #     return

    #   return

  create: new AppController

