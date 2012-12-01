(function() {
  var BlobDetector;

  BlobDetector = (function() {

    function BlobDetector(canvas, filters) {
      this.canvas = canvas;
      this.filters = filters;
      this.ctx = this.canvas.getContext('2d');
    }

    BlobDetector.prototype.process = function() {
      var imageData, r1, r2, r3;
      imageData = this.ctx.getImageData(0, 0, this.canvas.width, this.canvas.height);
      r1 = this.getDiffImage(imageData);
      r2 = this.getBlocks(r1);
      r3 = drawBlobs(imageData);
      return [r1, r2, r3];
    };

    BlobDetector.prototype.getDiffImage = function(imageData) {
      var originalImageData, pt, r, r2, rect, tmpRect, weight;
      pt = {
        x: 0,
        y: 0
      };
      originalImageData = imageData;
      this.ctx.translate(2, 0);
      r = this.ctx.getImageData(0, 0, this.canvas.width, this.canvas.height);
      r.data = this.filters.filter(filter.blend, r, originalImageData, rect, 2, 'difference');
      tmpRect = {
        x: 2,
        y: 0,
        w: 2,
        h: imageData.height
      };
      r.data = this.copyPixels(originalImageData, tmpRect, pt);
      this.ctx.translate(-2, 2);
      r2 = this.ctx.getImageData(0, 0, this.canvas.width, this.canvas.height);
      r2.data = this.filters.filter(filter.blend, r2, originalImageData, rect, 2, 'difference');
      tmpRect = {
        x: 0,
        y: 2,
        w: imageData.width,
        h: 2
      };
      r2.data = this.copyPixels(originalImageData, tmpRect, pt);
      rect = {
        x: 0,
        y: 0,
        w: imageData.width,
        h: imageData.height
      };
      pt = {
        0: 0,
        0: 0
      };
      r.data = this.filters.filter(filter.blend, r, r2, rect, 2, 'add');
      weight = [0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1];
      r = this.filters.convolution(r, weight, 0);
      r = this.filters.threshold(r, "<", 10, 0);
      r = this.filters.threshold(r, "!=", 233, 255);
      return r;
    };

    BlobDetector.prototype.getBlocks = function(imageData) {
      var blocks, i, o, r, rect1, rect2, size, x, y, _ref, _ref2, _ref3;
      blocks = [];
      r = this.ctx.getImageData(0, 0, this.canvas.width, this.canvas.height);
      while (true) {
        i++;
        if (i > 1000) break;
      }
      rect1 = this.getColorBoundsRect(r, 'ffffff', 'ff00ff');
      if (rect1 != null) return;
      x = rect1.x;
      for (y = _ref = rect1.y, _ref2 = rect1.y + rect1.height; _ref <= _ref2 ? y <= _ref2 : y >= _ref2; _ref <= _ref2 ? y++ : y--) {
        if (r.data[(y * r.width * 4) + x * 4] === 255 && r.data[(y * r.width * 4) + x * 4 + 1] === 255 && r.data[(y * r.width * 4) + x * 4 + 2] === 255) {
          ctx.fillStyle = "rgb(127,127,127)";
          ctx.fillRect(x, y, 1, 1);
          rect2 = this.getColorBoundsRect(r, 'ffffff', 'ff00ff');
          size = rect2.width * rect2.height;
          if (size > 300) {
            o = {
              size: size,
              rect: rect2,
              bmpd: this.ctx.getImageData(o.rect.width, o.rect.height)
            };
            r.imageData = o.bmpd.data(r, o.rect, blocks.push(o));
          }
        }
      }
      ctx.fillStyle = "00ff00";
      ctx.fillRect(x, y, 1, 1);
      for (i = 0, _ref3 = blocks.length - 1; 0 <= _ref3 ? i <= _ref3 : i >= _ref3; 0 <= _ref3 ? i++ : i--) {
        this.ctx.strokeStyle = "00ff00";
        g.drawRect(blocks[i].rect.x, blocks[i].rect.y, blocks[i].rect.width, blocks[i].rect.height);
      }
      r.draw(sp);
      return r;
    };

    BlobDetector.prototype.drawBlobs = function(imageData) {
      var b, i, j, pts, r, x, y, _ref, _ref2, _ref3, _ref4, _ref5, _ref6;
      r = this.ctx.getImageData(0, 0, this.canvas.width, this.canvas.height);
      for (i = 0, _ref = blocks.length - 1; 0 <= _ref ? i <= _ref : i >= _ref; 0 <= _ref ? i++ : i--) {
        pts = [];
        b = blocks[i];
        for (y = 0, _ref2 = b.rect.height - 1; 0 <= _ref2 ? y <= _ref2 : y >= _ref2; 0 <= _ref2 ? y++ : y--) {
          for (x = 0, _ref3 = b.rect.width - 1; 0 <= _ref3 ? x <= _ref3 : x >= _ref3; 0 <= _ref3 ? x++ : x--) {
            if (b.bmpd.getPixel(x, y) === 0xff00ff) {
              pts.push({
                x: x,
                y: y
              });
              break;
            }
          }
        }
        for (y = _ref4 = b.rect.height - 1; y >= 0; y += -5) {
          for (x = _ref5 = b.rect.width - 1; _ref5 <= 0 ? x <= 0 : x >= 0; _ref5 <= 0 ? x++ : x--) {
            if (b.bmpd.getPixel(x, y) === 0xff00ff) {
              pts.push({
                x: x,
                y: y
              });
              break;
            }
          }
        }
      }
      this.ctx.save();
      this.ctx.fillStyle = "ff0000";
      this.ctx.lineWidth = 0.2;
      this.ctx.strokeStyle = "ff0000";
      this.ctx.beginPath();
      for (j = 0, _ref6 = pts.length - 1; 0 <= _ref6 ? j <= _ref6 : j >= _ref6; 0 <= _ref6 ? j++ : j--) {
        if (j === 0) this.ctx.moveTo(b.rect.x + mid1.x, b.rect.y + mid1.y);
        this.ctx.quadraticCurveTo(b.rect.x + pts[(j + 1) % pts.length].x, b.rect.y + pts[(j + 1) % pts.length].y, b.rect.x + mid2.x, b.rect.y + mid2.y);
      }
      this.ctx.fill();
      this.ctx.restore();
      return r;
    };

    BlobDetector.prototype.getColorBoundsRect = function(imageData, minThreshold, maxThreshold) {
      var xMax, xMin, yMax, yMin;
      xMin = yMin = xMax = yMax = 0;
      this.ctx.save();
      this.ctx.strokeStyle = "ff0000";
      this.ctx.strokeRect(xMin, yMin, xMax - xMin, yMax - yMin);
      return this.ctx.restore();
    };

    BlobDetector.prototype.getPixelColor = function(imageData, x, y) {
      var p;
      p = [(y * imageData.width * 4) + x * 4, (y * imageData.width * 4) + x * 4 + 1, (y * imageData.width * 4) + x * 4 + 2];
      return "#" + ("000000" + rgbToHex(p[0], p[1], p[2])).slice(-6);
    };

    BlobDetector.prototype.blend = function() {
      var blendedData, height, lastImageData, sourceData, width;
      width = this.canvas.width;
      height = this.canvas.height;
      sourceData = this.ctx.getImageData(0, 0, width, height);
      if (typeof lastImageData === 'undefined') {
        lastImageData = this.ctx.getImageData(0, 0, width, height);
      }
      blendedData = this.ctx.createImageData(width, height);
      this.differenceAccuracy(blendedData.data, sourceData.data, lastImageData.data);
      ctxblended.putImageData(blendedData, 0, 0);
      return lastImageData = sourceData;
    };

    BlobDetector.prototype.copyPixels = function(ctx, srcRect, destPt) {
      return ctx.putImageData(srcRect, destPt.x, destPt.y);
    };

    return BlobDetector;

  })();

  if (typeof module !== 'undefined' && module.exports) {
    exports.BlobDetector = BlobDetector;
  } else {
    window.BlobDetector = BlobDetector;
  }

}).call(this);
