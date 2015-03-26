// Generated by CoffeeScript 1.9.0
(function() {
  var Video;

  Video = (function() {
    function Video(_at_webcam, _at_canvasVideoFront, _at_ctxVideoFront, _at_canvasVideoBack, _at_ctxVideoBack, _at_canvasVideoDebug, _at_ctxVideoDebug, _at_game) {
      this.webcam = _at_webcam;
      this.canvasVideoFront = _at_canvasVideoFront;
      this.ctxVideoFront = _at_ctxVideoFront;
      this.canvasVideoBack = _at_canvasVideoBack;
      this.ctxVideoBack = _at_ctxVideoBack;
      this.canvasVideoDebug = _at_canvasVideoDebug;
      this.ctxVideoDebug = _at_ctxVideoDebug;
      this.game = _at_game;
      this.cv = new Cv(this.canvasVideoBack);
      this.blobDetector = new BlobDetector(this.cv, this.canvasVideoBack);
      this.active = false;
      this.tilex = this.tiley = this.savedTilex = this.savedTiley = null;
      this.fakeDuration = 0;
      this.lastFrame = this.frame = null;
      this.sizeTile = 50;
    }

    Video.prototype.update = function() {
      var buildingIndex, isOnZone, resetDuration, result, sizedBounds;
      this.ctxVideoBack.drawImage(this.webcam, 0, 0, this.webcam.width, this.webcam.height);
      result = this.blobDetector.detect();
      sizedBounds = this.cv.convertBounds(result.bounds, this.canvasVideoFront, this.canvasVideoDebug);
      this.frame = this.ctxVideoBack.getImageData(0, 0, this.canvasVideoBack.width, this.canvasVideoBack.height);
      if (this.lastFrame === null) {
        this.lastFrame = this.frame;
      }
      isOnZone = this.blobDetector.blend(this.lastFrame, this.frame, this.ctxVideoFront);
      if (isOnZone && this.active === false) {
        this.active = true;
      }
      this.lastFrame = this.frame;
      resetDuration = 0;
      this.canvasVideoDebug.width = this.canvasVideoDebug.width;
      if (this.active) {
        this.tilex = Math.floor((this.canvasVideoDebug.width - sizedBounds.x) / this.sizeTile);
        this.tiley = Math.floor(sizedBounds.y / this.sizeTile);
        if (this.tilex === this.savedTilex && this.tiley === this.savedTiley) {
          this.fakeDuration++;
        } else {
          this.fakeDuration = 0;
        }
        this.savedTilex = this.tilex;
        this.savedTiley = this.tiley;
        if (this.fakeDuration > 25) {
          if (this.game.resources[this.game.MANA] > 6) {
            this.game.resources[this.game.MANA] -= 7;
            if (result.type !== this.game.map.tiles[this.tilex][this.tiley].type) {
              buildingIndex = this.game.buildings.indexOf(this.game.map.tiles[this.tilex][this.tiley].building);
              this.game.buildings.splice(buildingIndex, 1);
            }
            this.game.map.addMapElement(result.type, this.tilex, this.tiley, this.ctxVideoBack);
          }
          this.active = false;
          this.savedTilex = null;
          this.fakeDuration = 0;
        }
        if (resetDuration > 300) {
          this.fakeDuration = this.resetDuration = 0;
        }
        resetDuration++;
        this.ctxVideoDebug.fillStyle = 'white';
        this.ctxVideoDebug.globalAlpha = 0.5;
        return this.ctxVideoDebug.fillRect(this.sizeTile * this.tilex, this.sizeTile * this.tiley, this.sizeTile, this.sizeTile);
      }
    };

    return Video;

  })();

  window.Video = Video;

}).call(this);
