(function() {
  var Cv;

  Cv = (function() {

    function Cv() {}

    Cv.prototype.getColorBoundsRect = function(imageData, color, maxThreshold) {
      var i, pos, rect, xMax, xMin, yMax, yMin, _ref;
      xMin = imageData.width;
      yMin = imageData.height;
      xMax = yMax = 0;
      for (i = 0, _ref = imageData.length; i <= _ref; i += 4) {
        if (color === this.getPixelColor(imageData, i)) {
          pos = indexToXY(i);
          if (pos.x < xMin) xMin = pos.x;
          if (pos.y < yMin) yMin = pos.y;
          if (pos.x > xMax) xMax = pos.x;
          if (pos.y > yMax) yMax = pos.y;
        }
      }
      if (xMin > xMax || yMin > yMax) {
        return null;
      } else {
        rect = {
          x: xMin,
          y: yMin,
          width: xMax - xMin,
          height: yMax - yMin
        };
        return rect;
      }
    };

    Cv.prototype.getPixelColor = function(imageData, pixIndex) {
      var p;
      p = [imageData[pixIndex], imageData[pixIndex + 1], imageData[pixIndex + 2]];
      return "#" + ("000000" + rgbToHex(p[0], p[1], p[2])).slice(-6);
    };

    Cv.prototype.getXYPixelColor = function(imageData, x, y) {
      var p;
      p = [imageData[(y * imageData.width * 4) + x * 4], imageData[(y * imageData.width * 4) + x * 4 + 1], imageData[(y * imageData.width * 4) + x * 4 + 2]];
      return "#" + ("000000" + rgbToHex(p[0], p[1], p[2])).slice(-6);
    };

    Cv.prototype.copyPixels = function(imageData, srcRect, destPt) {};

    Cv.prototype.indexToXY = function(imageData, index) {
      var x, y;
      index = index / 4;
      y = Math.floor(index / imageData.width);
      x = index - y;
      return {
        x: x,
        y: y
      };
    };

    Cv.prototype.XYToIndex = function(imageData, x, y) {
      return (y * imageData.width * 4) + x * 4;
    };

    Cv.prototype.split = function(img) {
      var blue, green, i, red, _ref;
      red = blue = green = [];
      for (i = 0, _ref = imageData.length; i <= _ref; i += 4) {
        red.push(imageData[i]);
        green.push(imageData[i + 1]);
        blue.push(imageData[i + 2]);
      }
      return [red, blue, green];
    };

    return Cv;

  })();

  if (typeof module !== 'undefined' && module.exports) {
    exports.Cv = Cv;
  } else {
    window.Cv = Cv;
  }

}).call(this);
