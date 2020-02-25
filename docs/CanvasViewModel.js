import { Vector2, Rect, Line, Circle } from "./Utils.js";
import { GraphConfigs, EventParametersGraph } from "./EventParametersGraph.js";

export class CanvasViewModel {
  constructor(canvas) {
    this.canvas = canvas;

    const intensityGraphConfigs = new GraphConfigs(new Vector2(0, 0), new Vector2(canvas.width, canvas.height / 2), 200, 180);
    const sharpnessGraphConfigs = new GraphConfigs(new Vector2(0, canvas.height / 2), new Vector2(canvas.width, canvas.height / 2), 200, 180);
    this.eventParametersGraph = new EventParametersGraph(intensityGraphConfigs, sharpnessGraphConfigs);

    this.drawRects = [];
    this.drawLines = [];
    this.drawCircles = [];

    this.shouldDraw = false;
    this.enabeleDeleteMode = false;
  }

  toggledDleteMode() {
    this.enabeleDeleteMode = !this.enabeleDeleteMode;
    this.eventParametersGraph.enabeleDeleteMode = this.enabeleDeleteMode;
  }

  onDown(x, y) {
    this.eventParametersGraph.onDown(x, y);
    if(this.eventParametersGraph.hasUpdate) {
      this.draw();
    }
  }

  onMove(x, y) {
    this.eventParametersGraph.onMove(x, y);
    if(this.eventParametersGraph.hasUpdate) {
      this.draw();
    }
  }

  onUp() {
    this.eventParametersGraph.onUp();
    if(this.eventParametersGraph.hasUpdate) {
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
    return { Pattern: params };
  }

  draw() {
    this.drawRects = [];
    this.drawLines = [];
    this.drawCircles = [];

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
    this.shouldDraw = true;
  }
}
