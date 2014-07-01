(function() {
  require.config({
    baseUrl: "./scripts",
    dir: "../dist",
    optimize: "uglify",
    optimizeCss: "standard.keepLines",
    removeCombined: true,
    fileExclusionRegExp: /^\./,
    paths: {
      jquery: "lib/jquery",
      underscore: "lib/underscore",
      backbone: "lib/backbone",
      backboneRoutefilter: "lib/backboneRoutefilter",
      rivets: "lib/rivets",
      kinetic: "lib/kinetic",
      bootstrap: 'lib/bootstrap',
      jqueryMultiSelect: 'lib/jqueryMultiSelect',
      bootstrapSwitch: 'lib/bootstrapSwitch',
      jqueryEditable: 'lib/jqueryEditable',
      tinybox: "lib/jqueryModal"
    },
    shim: {
      underscore: {
        exports: "_"
      },
      backbone: {
        deps: ["underscore", "jquery"],
        exports: "Backbone"
      },
      rivets: {
        exports: "rivets"
      },
      kinetic: {
        exports: "Kinetic"
      },
      bootstrap: {
        deps: ["jquery"],
        exports: "Bootstrap"
      },
      jqueryMultiSelect: {
        deps: ["jquery"],
        exports: "JqueryMultiSelect"
      },
      jqueryEditable: {
        deps: ["jquery"],
        exports: "JqueryEditable"
      },
      tinybox: {
        deps: ["jquery"],
        exports: "Tinybox"
      }
    }
  });

  require(['router', 'appController'], function(Router, AppController) {});

}).call(this);

/*
//@ sourceMappingURL=main.js.map
*/
