// Generated by CoffeeScript 1.9.0
(function() {
  var Stats;

  Stats = (function() {
    function Stats(_at_video) {
      this.video = _at_video;
      this.decodedFrames = 0;
      this.droppedFrames = 0;
      this.decodedFPS = 0;
      this.droppedFPS = 0;
      this.startTime = 0;
      this.video.addEventListener("playing", (function(_this) {
        return function(event) {
          _this.startTime = new Date().getTime();
          return update();
        };
      })(this));
      this.video.addEventListener("error", function() {
        return this.endTest(false);
      }, false);
      this.video.addEventListener("ended", function() {
        return this.endTest(true);
      }, false);
    }

    Stats.prototype.calculate = function(logDiv) {
      var currentTime, deltaTime, fps;
      if (this.video.readyState <= HTMLMediaElement.HAVE_CURRENT_DATA || this.video.paused || this.video.ended) {
        return;
      }
      currentTime = new Date().getTime();
      deltaTime = (currentTime - this.startTime) / 1000;
      if (deltaTime > 5) {
        this.startTime = currentTime;
        fps = (video.webkitDecodedFrameCount - this.decodedFrames) / deltaTime;
        this.decodedFrames = video.webkitDecodedFrameCount;
        this.decodedFPS = fps;
        fps = (video.webkitDroppedFrameCount - this.droppedFrames) / deltaTime;
        this.droppedFrames = video.webkitDroppedFrameCount;
        this.droppedFPS = fps;
        return logDiv.innerHTML = "Decoded frames: " + this.decodedFrames + " Avg: " + this.decodedFPS + " fps.<br>" + "Dropped frames: " + this.droppedFrames + " Avg: " + this.droppedFPS + " fps.<br>";
      }
    };

    Stats.prototype.endTest = function(successFlag) {
      if (window.domAutomationController) {
        return window.domAutomationController.send(successFlag);
      }
    };

    Stats.prototype.startTest = function(url) {
      this.video.src = url;
      return this.video.play();
    };

    return Stats;

  })();

  window.Stats = Stats;

}).call(this);
