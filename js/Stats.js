(function() {
  var Stats;

  Stats = (function() {
    var calculate, endTest, startTest;

    function Stats(video) {
      this.video = video;
      this.decodedFrames = 0;
      this.droppedFrames = 0;
      this.decodedFPS = 0;
      this.droppedFPS = 0;
      this.startTime = 0;
      this.video.addEventListener("playing", function(event) {
        this.startTime = new Date().getTime();
        return update();
      });
      this.video.addEventListener("error", function() {
        return this.endTest(false);
      }, false);
      this.video.addEventListener("ended", function() {
        return this.endTest(true);
      }, false);
    }

    calculate = function(logDiv) {
      var currentTime, deltaTime, fps;
      if (this.video.readyState <= HTMLMediaElement.HAVE_CURRENT_DATA || this.video.paused || this.video.ended) {
        return;
      }
      currentTime = new Date().getTime();
      deltaTime = (currentTime - this.startTime) / 1000;
      if (deltaTime > 5) {
        this.startTime = currentTime;
        fps = (video.webkitDecodedFrameCount - decodedFrames) / deltaTime;
        this.decodedFrames = video.webkitDecodedFrameCount;
        this.decodedFPS = fps;
        fps = (video.webkitDroppedFrameCount - droppedFrames) / deltaTime;
        this.droppedFrames = video.webkitDroppedFrameCount;
        this.droppedFPS = fps;
        return logDiv.innerHTML = "Decoded frames: " + decodedFrames + " Avg: " + decodedFPS + " fps.<br>" + "Dropped frames: " + droppedFrames + " Avg: " + droppedFPS + " fps.<br>";
      }
    };

    endTest = function(successFlag) {
      if (window.domAutomationController) {
        return window.domAutomationController.send(successFlag);
      }
    };

    startTest = function(url) {
      this.video.src = url;
      return this.video.play();
    };

    return Stats;

  })();

  if (typeof module !== 'undefined' && module.exports) {
    exports.Stats = Stats;
  } else {
    window.Stats = Stats;
  }

}).call(this);
