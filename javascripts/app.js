(function() {
  "use strict";
  var CollisionPool, Item, ItemCollection, ItemView, Store, editUsingViews, storeItems,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  rivets.adapters[":"] = {
    subscribe: function(obj, keypath, callback) {
      console.log("1.subscribe:\t " + obj + " ||\t " + keypath);
      obj.on("change:" + keypath, callback);
    },
    unsubscribe: function(obj, keypath, callback) {
      console.log("2.unsubscribe:\t " + obj + " ||\t " + keypath);
      obj.off("change:" + keypath, callback);
    },
    read: function(obj, keypath) {
      console.log("3.read:\t\t\t " + obj + " ||\t " + keypath);
      if ((obj.get(keypath)) === void 0) {
        console.log("3.read:++ " + (obj[keypath]()) + " \t " + (obj.get(keypath)));
        return obj[keypath]();
      } else {
        return obj.get(keypath);
      }
    },
    publish: function(obj, keypath, value) {
      console.log("4.publish:\t\t " + obj + " ||\t " + keypath);
      obj.set(keypath, value);
    }
  };

  this.Logger = (function() {
    var Horn, instance;

    function Logger() {}

    instance = null;

    Horn = (function() {
      function Horn() {}

      Horn.prototype.info = function(message) {
        return 'INFO:\t' + message;
      };

      Horn.prototype.debug = function(message) {
        return 'DEBUG:\t' + message;
      };

      return Horn;

    })();

    Logger.info = function(message) {
      if (instance == null) {
        instance = new Horn;
      }
      return console.log(instance.info(message));
    };

    Logger.debug = function(message) {
      if (instance == null) {
        instance = new Horn;
      }
      return console.log(instance.debug(message));
    };

    return Logger;

  })();

  this.Box = (function(_super) {
    __extends(Box, _super);

    function Box() {
      return Box.__super__.constructor.apply(this, arguments);
    }

    Box.prototype.defaults = {
      boxId: '9999',
      fillColor: {
        red: 60,
        green: 118,
        blue: 61
      }
    };

    Box.prototype.initialize = function() {
      this.on('change:rect', this.rectChanged);
      this.set({
        rect: new Kinetic.Rect({
          x: 0,
          y: 0,
          width: 100,
          height: 50,
          fillRed: 60,
          fillGreen: 118,
          fillBlue: 61
        })
      });
      this.set({
        title: new Kinetic.Text({
          x: this.get('rect').x() + this.get('rect').width() / 2 - 5,
          y: this.get('rect').y() + this.get('rect').height() / 2 - 5,
          fontSize: 14,
          fontFamily: "Calibri",
          fill: "white",
          text: this.get('boxId')
        })
      });
      this.set({
        group: new Kinetic.Group({
          x: 4,
          y: 8,
          rotation: 0
        })
      });
      this.get('group').add(this.get('rect'));
      this.get('group').add(this.get('title'));
      Logger.debug('Box: Generate a new box.');
      return this.box().on("dblclick", (function(_this) {
        return function() {
          _this.box().rotation(45);
          return Logger.debug("@box().rotation(45)");
        };
      })(this));
    };

    Box.prototype.setTitleName = function(newTitle) {
      return this.get('title').setText(newTitle);
    };

    Box.prototype.getTitleName = function() {
      return this.get('title').text();
    };

    Box.prototype.setXPosition = function(x) {
      return this.get('group').setX(x);
    };

    Box.prototype.getXPosition = function() {
      return this.get('group').x();
    };

    Box.prototype.setYPosition = function(y) {
      return this.get('group').setY(y);
    };

    Box.prototype.getYPosition = function() {
      return this.get('group').y();
    };

    Box.prototype.setHeight = function(height) {
      return this.get('rect').setHeight(height);
    };

    Box.prototype.getHeight = function() {
      return this.get('rect').height();
    };

    Box.prototype.setWidth = function(width) {
      return this.get('rect').setWidth(width);
    };

    Box.prototype.getWidth = function() {
      return this.get('rect').width();
    };

    Box.prototype.getPointA = function() {
      var pointX;
      return pointX = {
        x: this.getXPosition(),
        y: this.getYPosition()
      };
    };

    Box.prototype.getPointB = function() {
      var pointB;
      return pointB = {
        x: this.getXPosition() + this.get('rect').getWidth(),
        y: this.getYPosition()
      };
    };

    Box.prototype.getPointC = function() {
      var pointC;
      return pointC = {
        x: this.getXPosition(),
        y: this.getYPosition() + this.get('rect').getHeight()
      };
    };

    Box.prototype.getPointD = function() {
      var pointC;
      return pointC = {
        x: this.getXPosition() + this.get('rect').getWidth(),
        y: this.getYPosition() + this.get('rect').getHeight()
      };
    };

    Box.prototype.updateRectStyle = function(options) {
      Logger.debug("updateRectStyle: " + (this.getTitleName()));
      return this.get('rect').setFill(options.color);
    };

    Box.prototype.rectChanged = function() {
      return Logger.debug('box model changed by rect.');
    };

    Box.prototype.box = function() {
      return this.get('group');
    };

    Box.prototype.printPoints = function() {
      return Logger.debug(("PointA(x:" + (this.getPointA().x) + ",y:" + (this.getPointA().y) + ") ") + ("PointB(x:" + (this.getPointB().x) + ",y:" + (this.getPointB().y) + ") ") + ("PointC(x:" + (this.getPointC().x) + ",y:" + (this.getPointC().y) + ") ") + ("PointD(x:" + (this.getPointD().x) + ",y:" + (this.getPointD().y) + ") "));
    };

    return Box;

  })(Backbone.Model);

  CollisionPool = (function() {
    function CollisionPool() {}

    return CollisionPool;

  })();

  this.Boxes = (function(_super) {
    __extends(Boxes, _super);

    function Boxes() {
      this.right = __bind(this.right, this);
      this.left = __bind(this.left, this);
      this.down = __bind(this.down, this);
      this.up = __bind(this.up, this);
      this.removeCurrentBox = __bind(this.removeCurrentBox, this);
      this.addNewBox = __bind(this.addNewBox, this);
      return Boxes.__super__.constructor.apply(this, arguments);
    }

    Boxes.prototype.model = Box;

    Boxes.prototype.initialize = function(layer, zone) {
      this.layer = layer;
      this.zone = zone;
      this.on('add', this.showCurrentBoxPanel);
      this.currentBox = new Box;
      this.availableNewBoxId = 1;
      this.flash = "Initialized completed!";
      return this._collisionPool = new CollisionPool;
    };

    Boxes.prototype.addNewBox = function() {
      var newBox;
      newBox = new Box;
      newBox.setXPosition(newBox.getXPosition() + this.availableNewBoxId * 4);
      newBox.setYPosition(newBox.getYPosition() + this.availableNewBoxId * 4);
      newBox.setTitleName(this.availableNewBoxId);
      newBox.set('boxId', this.availableNewBoxId);
      newBox.box().on("click", (function(_this) {
        return function() {
          Logger.debug("box" + (newBox.getTitleName()) + " clicked!");
          return _this.updateCurrentBox(newBox);
        };
      })(this));
      this.add(newBox);
      this.draw();
      this.updateCurrentBox(newBox);
      this.availableNewBoxId += 1;
      return Logger.debug("@availableNewBoxId:\t" + this.availableNewBoxId);
    };

    Boxes.prototype.removeCurrentBox = function() {
      if (this.length === 0) {
        this.flash = 'There is no box.';
      } else {
        this.currentBox.get('group').destroy();
        this.remove(this.currentBox);
        this.currentBox = this.last();
      }
      this.draw();
      if (this.length === 0) {
        this.flash = 'There is no box.';
      }
      this.showCurrentBoxPanel();
      return Logger.debug("remove button clicked!");
    };

    Boxes.prototype.testCollision = function() {
      var result;
      Logger.debug("...Collision start...");
      result = _.reduce(this.models, (function(status, box) {
        if (this.currentBox.getTitleName() !== box.getTitleName()) {
          return this.testBoxCollision(this.currentBox, box) || status;
        } else {
          return status;
        }
      }), false, this);
      return Logger.debug("...Collision result: " + result);
    };

    Boxes.prototype.draw = function() {
      var box, _i, _len, _ref;
      _ref = this.models;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        box = _ref[_i];
        Logger.debug("In draw: Box" + (box.getTitleName()) + ".color=" + (box.get('rect').getFill()));
        this.layer.add(box.box());
      }
      return this.layer.draw();
    };

    Boxes.prototype.testBoxCollision = function(boxA, boxB) {
      var boxABottom, boxALeft, boxARight, boxATop, boxBBottom, boxBLeft, boxBRight, boxBTop, status;
      status = false;
      boxATop = boxA.getYPosition();
      boxABottom = boxA.getYPosition() + boxA.getHeight();
      boxALeft = boxA.getXPosition();
      boxARight = boxA.getXPosition() + boxA.getWidth();
      boxBTop = boxB.getYPosition();
      boxBBottom = boxB.getYPosition() + boxB.getHeight();
      boxBLeft = boxB.getXPosition();
      boxBRight = boxB.getXPosition() + boxB.getWidth();
      if (!(boxABottom < boxBTop || boxATop > boxBBottom || boxALeft > boxBRight || boxARight < boxBLeft)) {
        status = true;
      }
      if (status) {
        this.updateBoxStyle(boxA, {
          collision: true,
          collisionBox: boxB
        });
      } else {
        this.updateBoxStyle(boxA, {
          recoverFillColor: true
        });
      }
      return status;
    };

    Boxes.prototype.updateBoxStyle = function(boxA, options) {
      if (options.collision) {
        options.collisionBox.updateRectStyle({
          color: 'yellow'
        });
        boxA.updateRectStyle({
          color: 'yellow'
        });
      }
      if (options.recoverFillColor) {
        boxA.updateRectStyle({
          color: 'green'
        });
      }
      return this.draw();
    };

    Boxes.prototype.updateCurrentBox = function(newBox) {
      if (newBox == null) {
        newBox = this.currentBox;
      }
      this.currentBox = newBox;
      return rivets.bind($('.box'), {
        box: newBox
      });
    };

    Boxes.prototype.showCurrentBoxPanel = function() {
      rivets.bind($('.box'), {
        box: this.currentBox
      });
      Logger.debug("showCurrentBoxPanel: " + this.length);
      if (this.length === 0) {
        return $('.panel').css('display', 'none');
      } else {
        return $('.panel').css('display', 'block');
      }
    };

    Boxes.prototype.up = function() {
      Logger.debug("@currentBox:\t" + this.currentBox.getTitleName());
      this.currentBox.setYPosition(this.currentBox.getYPosition() - 4);
      if (this.validateZone(this.currentBox)) {
        this.draw();
      } else {
        this.currentBox.setYPosition(this.currentBox.getYPosition() + 4);
        this.flash = "Box" + (this.currentBox.getTitleName()) + " cannot be moved UP!";
      }
      this.currentBox.printPoints();
      this.testCollision();
      return this.updateCurrentBox();
    };

    Boxes.prototype.down = function() {
      Logger.debug("@currentBox:\t" + this.currentBox.getTitleName());
      this.currentBox.setYPosition(this.currentBox.getYPosition() + 4);
      if (this.validateZone(this.currentBox)) {
        this.draw();
      } else {
        this.currentBox.setYPosition(this.currentBox.getYPosition() - 4);
        this.flash = "Box" + (this.currentBox.getTitleName()) + " cannot be moved DOWN!";
      }
      this.currentBox.printPoints();
      this.testCollision();
      return this.updateCurrentBox();
    };

    Boxes.prototype.left = function() {
      Logger.debug("@currentBox:\t" + this.currentBox.getTitleName());
      this.currentBox.setXPosition(this.currentBox.getXPosition() - 4);
      if (this.validateZone(this.currentBox)) {
        this.draw();
      } else {
        this.currentBox.setXPosition(this.currentBox.getXPosition() + 4);
        this.flash = "Box" + (this.currentBox.getTitleName()) + " cannot be moved LEFT!";
      }
      this.currentBox.printPoints();
      this.testCollision();
      return this.updateCurrentBox();
    };

    Boxes.prototype.right = function() {
      Logger.debug("@currentBox:\t" + this.currentBox.getTitleName());
      this.currentBox.setXPosition(this.currentBox.getXPosition() + 4);
      if (this.validateZone(this.currentBox)) {
        this.draw();
      } else {
        this.currentBox.setXPosition(this.currentBox.getXPosition() - 4);
        this.flash = "Box" + (this.currentBox.getTitleName()) + " cannot be moved RIGHT!";
      }
      this.currentBox.printPoints();
      this.testCollision();
      return this.updateCurrentBox();
    };

    Boxes.prototype.validateZone = function(box) {
      var result;
      result = _.reduce([box.getPointA(), box.getPointB(), box.getPointC(), box.getPointD()], (function(status, point) {
        return status && this.validateZoneX(point) && this.validateZoneY(point);
      }), true, this);
      Logger.debug("validresult:\t " + result);
      if (result) {
        this.flash = "";
      }
      return result;
    };

    Boxes.prototype.validateZoneX = function(point) {
      var _ref;
      Logger.debug("validateZoneX: point.x " + point.x + ", @zone.x " + this.zone.x);
      return (0 <= (_ref = point.x) && _ref <= this.zone.x);
    };

    Boxes.prototype.validateZoneY = function(point) {
      var _ref;
      Logger.debug("validateZoneY: point.y " + point.y + ", @zone.x " + this.zone.y);
      return (0 <= (_ref = point.y) && _ref <= this.zone.y);
    };

    return Boxes;

  })(Backbone.Collection);

  this.StackBoard = (function() {
    function StackBoard() {
      var stage_bg;
      this.stage = new Kinetic.Stage({
        container: "canvas_container",
        width: 360,
        height: 480
      });
      this.zone = {
        x: 300,
        y: 380
      };
      this.layer = new Kinetic.Layer();
      stage_bg = new Kinetic.Rect({
        x: 0,
        y: 0,
        width: 300,
        height: 380,
        fillRed: 255,
        fillGreen: 228,
        fillBlue: 196
      });
      this.layer.add(stage_bg);
      this.stage.add(this.layer);
      Logger.debug("StackBoard: Stage Initialized!");
      Logger.info("StackBoard: Initialized!");
      this.boxes = new Boxes(this.layer, this.zone);
      this.boxes.shift();
      rivets.bind($('.boxes'), {
        boxes: this.boxes
      });
    }

    return StackBoard;

  })();

  Item = (function(_super) {
    __extends(Item, _super);

    function Item() {
      this.Edit = __bind(this.Edit, this);
      return Item.__super__.constructor.apply(this, arguments);
    }

    Item.prototype.initialize = function() {
      return this.set({
        ttext: 'dddd'
      });
    };

    Item.prototype.GetText = function() {
      return this.get("Name") + " | $" + this.get("Price");
    };

    Item.prototype.desc = function() {
      return this.get("Name") + " -- $" + this.get("Price");
    };

    Item.prototype.Edit = function() {
      console.log(this);
      this.trigger("edit", this);
    };

    return Item;

  })(Backbone.Model);

  ItemCollection = Backbone.Collection.extend({
    model: Item
  });

  ItemView = Backbone.View.extend({
    templateId: "#editItemDialog",
    events: {
      "click .close-link": "close"
    },
    render: function() {
      var html, templateFunction;
      templateFunction = _.template($(this.templateId).html());
      html = templateFunction();
      this.setElement(html);
      rivets.bind(this.$el, {
        item: this.model
      });
      return this;
    },
    close: function() {
      this.$el.empty();
    }
  });

  Store = Backbone.Model.extend({
    initialize: function(options) {
      this.set({
        Title: "Cyclist Stuff",
        Items: options.Items
      });
    }
  });

  editUsingViews = function(item) {
    var view;
    view = new ItemView({
      model: item
    });
    $("#holder").empty().append(view.render().el);
    return false;
  };

  storeItems = _.map([
    {
      Name: "Awesome Carbon Wheels",
      Price: "100",
      Description: "Something to covet for a cyclist"
    }, {
      Name: "Speedplay Pedals",
      Price: "10",
      Description: "Something else to covet for a cyclist"
    }, {
      Name: "LOTOJA",
      Price: "25",
      Description: "Big bike ride"
    }
  ], function(obj) {
    var item;
    item = new Item(obj);
    console.log(item.get('Name'));
    item.on("edit", editUsingViews);
    return item;
  });

  rivets.formatters.currency = {
    read: function(value) {
      return (value / Math.pow(10, 2)).toFixed(2);
    },
    publish: function(value) {
      return Math.round(parseFloat(value) * Math.pow(10, 2));
    }
  };

  this.storeItemsCollection = new ItemCollection(storeItems);

  this.store = new Store({
    Items: this.storeItemsCollection
  });

  rivets.bind($("#store1"), {
    store: this.store,
    storeItems: this.storeItemsCollection
  });

}).call(this);

/*
//@ sourceMappingURL=app.js.map
*/
