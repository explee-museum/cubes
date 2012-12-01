(function() {
  var People;

  People = (function() {

    function People() {
      this.posX = 0;
      this.posY = 0;
      this.spriteElem = null;
      this.path = [];
      this.state = 'IDLE';
      this.goal = 'NONE';
      this.age = 0;
    }

    People.prototype.walk = function() {};

    People.prototype.draw = function() {};

    return People;

  })();

}).call(this);
