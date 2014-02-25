(function() {
  var CollisionPair, CollisionUtil,
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
      return obj.get(keypath);
    },
    publish: function(obj, keypath, value) {
      console.log("4.publish:\t\t " + obj + " ||\t " + keypath);
      obj.set(keypath, value);
    }
  };

  this.Logger = (function() {
    var Horn, instance, statuses;

    function Logger() {}

    instance = null;

    statuses = ['info', 'debug', "dev"];

    statuses = ["dev"];

    Horn = (function() {
      function Horn() {}

      Horn.prototype.info = function(message) {
        return 'INFO:\t' + message;
      };

      Horn.prototype.debug = function(message) {
        return 'DEBUG:\t' + message;
      };

      Horn.prototype.dev = function(message) {
        return 'Dev:\t' + message;
      };

      return Horn;

    })();

    Logger.info = function(message) {
      if (_.contains(statuses, 'info')) {
        if (instance == null) {
          instance = new Horn;
        }
        return console.log(instance.info(message));
      }
    };

    Logger.debug = function(message) {
      if (_.contains(statuses, 'debug')) {
        if (instance == null) {
          instance = new Horn;
        }
        return console.log(instance.debug(message));
      }
    };

    Logger.dev = function(message) {
      if (_.contains(statuses, 'dev')) {
        if (instance == null) {
          instance = new Horn;
        }
        return console.log(instance.dev(message));
      }
    };

    return Logger;

  })();

  this.Box = (function(_super) {
    __extends(Box, _super);

    function Box() {
      return Box.__super__.constructor.apply(this, arguments);
    }

    Box.prototype.defaults = {
      boxId: 'nullID',
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
          _this.box().rotation(90);
          return Logger.debug("@box().rotation(90)");
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

    Box.prototype.makeCollisionStatus = function() {
      Logger.dev("box" + (this.getTitleName()) + ": makeCollisionStatus");
      return this.get('rect').setFill('red');
    };

    Box.prototype.makeUnCollisionStatus = function() {
      Logger.dev("box" + (this.getTitleName()) + ": makeUnCollisionStatus");
      return this.get('rect').setFill('green');
    };

    Box.prototype.printPoints = function() {
      return Logger.debug(("PointA(x:" + (this.getPointA().x) + ",y:" + (this.getPointA().y) + ") ") + ("PointB(x:" + (this.getPointB().x) + ",y:" + (this.getPointB().y) + ") ") + ("PointC(x:" + (this.getPointC().x) + ",y:" + (this.getPointC().y) + ") ") + ("PointD(x:" + (this.getPointD().x) + ",y:" + (this.getPointD().y) + ") "));
    };

    return Box;

  })(Backbone.Model);

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
      this.on('all', this.testCollision);
      this.collisionUtil = new CollisionUtil;
      this.currentBox = new Box;
      this.availableNewBoxId = 1;
      return this.flash = "Initialized completed!";
    };

    Boxes.prototype.updateCollisionStatus = function(options) {
      return this.collisionUtil.updateRelation(options);
    };

    Boxes.prototype.testCollisionPair = function(boxA, boxB) {
      return this.collisionUtil.testCollisionPair(boxA, boxB);
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
        if (this.currentBox.getTitleName() !== box.getTitleName() && this.currentBox.getTitleName() !== 'nullID') {
          return this.testCollisionPair(this.currentBox, box) || status;
        } else {
          return status;
        }
      }), false, this);
      Logger.debug("...Collision result: " + result);
      return this.draw();
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
      if (!this.validateZone(this.currentBox)) {
        this.currentBox.setYPosition(this.currentBox.getYPosition() + 4);
        this.flash = "Box" + (this.currentBox.getTitleName()) + " cannot be moved UP!";
      }
      this.testCollision();
      return this.updateCurrentBox();
    };

    Boxes.prototype.down = function() {
      Logger.debug("@currentBox:\t" + this.currentBox.getTitleName());
      this.currentBox.setYPosition(this.currentBox.getYPosition() + 4);
      if (!this.validateZone(this.currentBox)) {
        this.currentBox.setYPosition(this.currentBox.getYPosition() - 4);
        this.flash = "Box" + (this.currentBox.getTitleName()) + " cannot be moved DOWN!";
      }
      this.testCollision();
      return this.updateCurrentBox();
    };

    Boxes.prototype.left = function() {
      Logger.debug("@currentBox:\t" + this.currentBox.getTitleName());
      this.currentBox.setXPosition(this.currentBox.getXPosition() - 4);
      if (!this.validateZone(this.currentBox)) {
        this.currentBox.setXPosition(this.currentBox.getXPosition() + 4);
        this.flash = "Box" + (this.currentBox.getTitleName()) + " cannot be moved LEFT!";
      }
      this.testCollision();
      return this.updateCurrentBox();
    };

    Boxes.prototype.right = function() {
      Logger.debug("@currentBox:\t" + this.currentBox.getTitleName());
      Logger.debug("@currentBox:\t" + this.currentBox.getXPosition());
      this.currentBox.setXPosition(this.currentBox.getXPosition() + 4);
      if (!this.validateZone(this.currentBox)) {
        this.currentBox.setXPosition(this.currentBox.getXPosition() - 4);
        this.flash = "Box" + (this.currentBox.getTitleName()) + " cannot be moved RIGHT!";
      }
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

  CollisionPair = (function(_super) {
    var CollisionRelation;

    __extends(CollisionPair, _super);

    function CollisionPair() {
      return CollisionPair.__super__.constructor.apply(this, arguments);
    }

    CollisionRelation = (function(_super1) {
      __extends(CollisionRelation, _super1);

      function CollisionRelation() {
        return CollisionRelation.__super__.constructor.apply(this, arguments);
      }

      CollisionRelation.prototype.defaults = {
        status: false
      };

      CollisionRelation.prototype.initialize = function(options) {
        return this.set({
          boxId: options.boxId
        });
      };

      return CollisionRelation;

    })(Backbone.Model);

    CollisionPair.prototype.initialize = function(options) {
      this.set({
        boxId: options.boxId
      });
      return this.set({
        relationCollection: new CollisionRelation
      });
    };

    return CollisionPair;

  })(Backbone.Model);

  CollisionUtil = (function(_super) {
    __extends(CollisionUtil, _super);

    function CollisionUtil() {
      return CollisionUtil.__super__.constructor.apply(this, arguments);
    }

    CollisionUtil.prototype.model = CollisionPair;

    CollisionUtil.prototype.initialize = function(options) {
      return console.log('*CollisionUtil initialize* to do');
    };

    CollisionUtil.prototype.removeCollisionPair = function(boxA, boxB) {
      Logger.dev("removeCollisionPair: box" + (boxA.getTitleName()) + ", box" + (boxB.getTitleName()));
      this.removeRelation(boxA, boxB);
      if (!this.isRelationInclude(boxA)) {
        boxA.makeUnCollisionStatus();
      }
      if (!this.isRelationInclude(boxB)) {
        return boxB.makeUnCollisionStatus();
      }
    };

    CollisionUtil.prototype.addCollisionPair = function(boxA, boxB) {
      Logger.dev("addCollisionPair: box" + (boxA.getTitleName()) + ", box" + (boxB.getTitleName()));
      this.addRelation(boxA, boxB);
      boxA.makeCollisionStatus();
      return boxB.makeCollisionStatus();
    };

    CollisionUtil.prototype.isRelationInclude = function(boxA) {
      var status;
      status = false;
      return status;
    };

    CollisionUtil.prototype.updateRelation = function(options) {
      var box;
      box = options.box;
      if (options.action === 'add') {
        return Logger.dev("CollisionUtil:\t add box");
      } else if (options.action === 'remove') {
        return Logger.dev("CollisionUtil:\t remove box");
      } else if (options.action === 'changeID') {
        return Logger.dev("CollisionUtil:\t changeID box");
      }
    };

    CollisionUtil.prototype.removeRelation = function(boxA, boxB) {
      return Logger.dev("removeRelation: box" + (boxA.getTitleName()) + ", box" + (boxB.getTitleName()));
    };

    CollisionUtil.prototype.addRelation = function(boxA, boxB) {
      return Logger.dev("addCollisionPair: box" + (boxA.getTitleName()) + ", box" + (boxB.getTitleName()));
    };

    CollisionUtil.prototype.testCollisionPair = function(boxA, boxB) {
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
      Logger.dev("testCollisionPair: box" + (boxA.getTitleName()) + " box" + (boxB.getTitleName()) + " " + status);
      if (status) {
        this.addCollisionPair(boxA, boxB);
      } else {
        this.removeCollisionPair(boxA, boxB);
      }
      return status;
    };

    return CollisionUtil;

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

  this.board = new StackBoard;

}).call(this);

/*
//@ sourceMappingURL=app.js.map
*/
