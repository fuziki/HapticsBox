import { Vector2, Rect, Line, Circle } from "./Utils.js";
import { GraphConfigs, EventParametersGraph } from "./EventParametersGraph.js";
import { CurveParametersGraph } from "./CurveParametersGraph.js";

export class CanvasViewModel {
  constructor(canvas) {
    this.canvas = canvas;

    this.maxSec = 1;
    this.padding_x = 25;
    this.padding_y = 25;
    this.graph_space_height = 20;
    this.graph_width = canvas.width - this.padding_x * 2;
    this.pxPerSec = this.graph_width / this.maxSec;
    this.graph_height = (canvas.height - this.padding_y * 2 - this.graph_space_height * 3) / 4;

    let y = this.padding_y;
    const intensityGraphConfigs = new GraphConfigs(new Vector2(this.padding_x, y), new Vector2(this.graph_width, this.graph_height), this.pxPerSec, this.graph_height);
    y += (this.graph_height + this.graph_space_height);
    const sharpnessGraphConfigs = new GraphConfigs(new Vector2(this.padding_x, y), new Vector2(this.graph_width, this.graph_height), this.pxPerSec, this.graph_height);
    this.eventParametersGraph = new EventParametersGraph(intensityGraphConfigs, sharpnessGraphConfigs);

    y += (this.graph_height + this.graph_space_height);
    const intensityCurveGraphConfigs = new GraphConfigs(new Vector2(this.padding_x, y), new Vector2(this.graph_width, this.graph_height), this.pxPerSec, this.graph_height);
    y += (this.graph_height + this.graph_space_height);
    const sharpnessCurveGraphConfigs = new GraphConfigs(new Vector2(this.padding_x, y), new Vector2(this.graph_width, this.graph_height), this.pxPerSec, this.graph_height);
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

  readJson(json) {
    this.eventParametersGraph.readJson(json);
    this.curveParametersGraph.readJson(json);
    this.draw();
  }

  updateMaxSec(maxSec) {
    this.maxSec = maxSec;
    this.pxPerSec = this.graph_width / this.maxSec;
    this.eventParametersGraph.updatePxPerSec(this.pxPerSec, this.pxPerSec);
    this.curveParametersGraph.updatePxPerSec(this.pxPerSec, this.pxPerSec);
    this.draw();
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
