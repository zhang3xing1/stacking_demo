// Generated by CoffeeScript 1.7.1
(function() {
  var Box, Boxes, boxes,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Box = (function(_super) {
    __extends(Box, _super);

    function Box() {
      return Box.__super__.constructor.apply(this, arguments);
    }

    Box.prototype.initialize = function() {
      this.on('change:price change:quantity', this.setSubtotal);
      return this.on('change:item', this.setPrice);
    };

    Box.prototype.defaults = {
      x_position: 0,
      y_position: 0,
      rotate: 0
    };

    Box.prototype.setXPosition = function() {};

    Box.prototype.setYPosition = function() {};

    Box.prototype.setRotate = function() {};

    Box.prototype["delete"] = function() {};

    return Box;

  })(Backbone.Model);

  Boxes = (function(_super) {
    __extends(Boxes, _super);

    function Boxes() {
      this.flash = __bind(this.flash, this);
      this.addNewBox = __bind(this.addNewBox, this);
      return Boxes.__super__.constructor.apply(this, arguments);
    }

    Boxes.prototype.model = Box;

    Boxes.prototype.initialize = function() {
      this.stage = new Kinetic.Stage({
        container: "canvas_container",
        width: 300,
        height: 360
      });
      this.layer = new Kinetic.Layer();
      this.rect = new Kinetic.Rect({
        x: 10,
        y: 10,
        width: 20,
        height: 20,
        fill: "green",
        strokeWidth: 4
      });
      this.layer.add(this.rect);
      this.stage.add(this.layer);
      this.newBoxId = 1;
      return this.message = "The new box id will be 1";
    };

    Boxes.prototype.addNewBox = function() {
      return console.log(this.newBoxId);
    };

    Boxes.prototype.flash = function() {
      return this.message;
    };

    return Boxes;

  })(Backbone.Collection);

  rivets.bind($('.boxes'), {
    boxes: boxes = new Boxes
  });

}).call(this);
