define [
  "jquery"
  "underscore"
  "backbone"
  'logger'
], ($, _, Backbone, aLogger) ->  
  class Mission extends Backbone.Model
    defaults: {
      name: '',
      creator: '',
      product: '',
      company: '',
      code: 'Code X', 

      #setting
      frame_line_in: '',
      frame_line_out: '',

      box_length: '0',
      box_width: '0',
      box_height: '0',
      box_weight: '0',

      box_x_off: '0',
      box_y_off: '0',
      box_z_off: '0',
      box_orient: false,

      tool_postion: '',


      length_wise: false,
      cross_wise: true,
      box_per_pick: 1,
      distance: 10,

      pallet_length: 300,
      pallet_width: 400,
      pallet_height: 500,
      pallet_weight: 1000,
      sleepsheet_height: 5,

      tare: 1000,
      max_gross: 800,
      max_height: 600,
      overhang_len: 10,
      overhang_wid: 10,
      max_pack: 200,

      available_layers: {}, # layer_data.id : layer_data
      used_layers: [],
   
    }
    initialize: (params) ->
      @aLogger = aLogger.create
      @aLogger.debug "this is in mission"

    addLayer: (layer_data) ->
      to_updated_available_layers = @get("available_layers")
      to_updated_available_layers[layer_data.id] = layer_data
      @set('available_layers', to_updated_available_layers) 

    layers: ->
      @get("available_layers")

    getAvailableLayersOrder: ->
      result = _.map(_.values(@get("available_layers")), (layer) ->
        layer.name) 
      # result.reverse()
         
  create: new Mission