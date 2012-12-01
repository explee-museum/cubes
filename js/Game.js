(function() {
  var Game;

  Game = (function() {

    function Game() {
      this.resources = [];
      this.map = null;
      this.peoples = [];
      this.buildings = [];
      this.technologies = [];
    }

    Game.prototype.nextTurn = function() {
      return console.log("nextTurn");
    };

    return Game;

  })();

}).call(this);
