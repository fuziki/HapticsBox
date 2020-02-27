import { Vector2, Rect, Line, Circle } from "./Utils.js";
import { GraphConfigs, EventParametersGraph } from "./EventParametersGraph.js";
import { CurveParametersGraph } from "./CurveParametersGraph.js";

export class CanvasViewModel {
  constructor(canvas) {
    this.canvas = canvas;

    const intensityGraphConfigs = new GraphConfigs(new Vector2(0, 0), new Vector2(canvas.width, canvas.height / 4), 200, canvas.height / 4);
    const sharpnessGraphConfigs = new GraphConfigs(new Vector2(0, canvas.height / 4), new Vector2(canvas.width, canvas.height / 4), 200, canvas.height / 4);
    this.eventParametersGraph = new EventParametersGraph(intensityGraphConfigs, sharpnessGraphConfigs);

    const intensityCurveGraphConfigs = new GraphConfigs(new Vector2(0, canvas.height / 4 * 2), new Vector2(canvas.width, canvas.height / 4), 200, canvas.height / 4);
    const sharpnessCurveGraphConfigs = new GraphConfigs(new Vector2(0, canvas.height / 4 * 3), new Vector2(canvas.width, canvas.height / 4), 200, canvas.height / 4);
    this.curveParametersGraph = new CurveParametersGraph(intensityCurveGraphConfigs, sharpnessCurveGraphConfigs);

    this.drawRects = [];
    this.drawLines = [];
    this.drawStrideLines = [];
    this.drawCircles = [];

    this.shouldDraw = false;
    this.enabeleDeleteMode = false;

    if(this.eventParametersGraph.hasUpdate || this.curveParametersGraph.hasUpdate) {
      this.draw();
    }
  }

  toggledDleteMode() {
    this.enabeleDeleteMode = !this.enabeleDeleteMode;
    this.eventParametersGraph.enabeleDeleteMode = this.enabeleDeleteMode;
    this.curveParametersGraph.enabeleDeleteMode = this.enabeleDeleteMode;
  }

  onDown(x, y) {
    this.eventParametersGraph.onDown(x, y);
    this.curveParametersGraph.onDown(x, y);
    if(this.eventParametersGraph.hasUpdate || this.curveParametersGraph.hasUpdate) {
      this.draw();
    }
  }

  onMove(x, y) {
    this.eventParametersGraph.onMove(x, y);
    this.curveParametersGraph.onMove(x, y);
    if(this.eventParametersGraph.hasUpdate || this.curveParametersGraph.hasUpdate) {
      this.draw();
    }
  }

  onUp() {
    this.eventParametersGraph.onUp();
    this.curveParametersGraph.onUp();
    if(this.eventParametersGraph.hasUpdate || this.curveParametersGraph.hasUpdate) {
      this.draw();
    }
  }

  json() {
    let params = [];
    for (let haptic of this.eventParametersGraph.haptics.continuous) {
      params.push(haptic.json());
    }
    for (let haptic of this.eventParametersGraph.haptics.transient) {
      params.push(haptic.json());
    }
    for (let json of this.curveParametersGraph.jsons()) {
      params.push(json);
    }
    return { Pattern: params };
  }

  draw() {
    this.drawRects = [];
    this.drawLines = [];
    this.drawCircles = [];
    this.drawStrideLines = [];

    let haptics = this.eventParametersGraph.haptics.continuous;
    if(this.eventParametersGraph.tmpHaptic != null) {
      haptics = haptics.concat(this.eventParametersGraph.tmpHaptic);
    }
    for (let haptic of haptics) {
      for (let [key, config] of Object.entries(this.eventParametersGraph.graphConfigs)) {
        let w = haptic.duration * config.pxPerSec;
        let h = haptic.values[key] * config.pxPerValue;
        let x = haptic.time * config.pxPerSec + config.origin.x;
        let y = config.origin.y + config.size.y - h;
        let rect = new Rect(new Vector2(x, y), new Vector2(w, h));
        this.drawRects.push(rect);
        this.drawCircles.push(new Circle(new Vector2(x, y), 7));
        this.drawCircles.push(new Circle(new Vector2(x + w, y), 7));
      }
    }

    for (let haptic of this.eventParametersGraph.haptics.transient) {
      for (let [key, config] of Object.entries(this.eventParametersGraph.graphConfigs)) {
        let h = haptic.values[key] * config.pxPerValue;
        let x = haptic.time * config.pxPerSec + config.origin.x;
        let y = config.origin.y + config.size.y - h;
        let line = new Line(new Vector2(x, y), new Vector2(x, y + h));
        this.drawLines.push(line);
        this.drawCircles.push(new Circle(new Vector2(x, y), 7));
      }
    }

    for (let [key, config] of Object.entries(this.curveParametersGraph.graphConfigs)) {
      let stridePoints = []
      for(let point of this.curveParametersGraph.controlPoints[key]) {
        let x = point.time * config.pxPerSec + config.origin.x;
        let y = config.origin.y + config.size.y - point.value * config.pxPerValue;
        this.drawCircles.push(new Circle(new Vector2(x, y), 7));
        stridePoints.push(new Vector2(x, y));
      }
      this.drawStrideLines.push(stridePoints);
    }

    this.shouldDraw = true;
  }
}
