export class GraphConfigs {
  constructor(origin, size, pxPerSec, pxPerValue) {
    this.origin = origin;
    this.size = size;
    this.pxPerSec = pxPerSec;
    this.pxPerValue = pxPerValue;
  }
}

export class ControlPoint {
  constructor(time, value) {
    this.time = time;
    this.value = value;
  }
  json() {
    return { Time: this.time, ParameterValue: this.value };
  }
}

export class CurveParametersGraph {
  constructor(intensityGraphConfigs, sharpnessGraphConfigs) {
    this.graphConfigs = { intensity: intensityGraphConfigs, sharpness: sharpnessGraphConfigs, };
    this.controlPoints = { intensity: [], sharpness: [] };

    this.draggingPoint = null;
    this.hasUpdate = false;
    this.enabeleDeleteMode = false;
  }

  onDown(canvas_x, canvas_y) {
    this.hasUpdate = false;
    if (this.draggingHaptic != null) { return; }

    const graph = this.targetGraph(canvas_x, canvas_y);
    if (graph == "") { return; }

    let config = this.graphConfigs[graph];
    for (let point of this.controlPoints[graph]) {
      let x = point.time * config.pxPerSec + config.origin.x;
      let y = config.origin.y + config.size.y - point.value * config.pxPerValue;
      let d = Math.sqrt(Math.pow(canvas_x - x, 2) + Math.pow(canvas_y - y, 2));
      if (d < 7) {
        if (this.enabeleDeleteMode) {
          var index = this.controlPoints[graph].indexOf(point);
          if(index >= 0){
            this.controlPoints[graph].splice(index, 1); 
          }
          this.hasUpdate = true;
        } else {
          this.draggingPoint = point;
        }
        return;
      }
    }

    if (this.enabeleDeleteMode) { return; }

    const x = (canvas_x - config.origin.x) / config.pxPerSec;
    const y = (config.origin.y + config.size.y - canvas_y) / config.pxPerValue;
    this.draggingPoint = new ControlPoint(x, y);
    this.controlPoints[graph].push(this.draggingPoint);
    this.hasUpdate = true;
  }

  onMove(canvas_x, canvas_y) {
    return;
    this.hasUpdate = false;
    const graph = this.targetGraph(canvas_x, canvas_y);
    if (graph == "") { return; }

    if (this.draggingHaptic == null) {
      return;
    }
    this.hasUpdate = true;

    const config = this.graphConfigs[graph];
    const x = (canvas_x - config.origin.x) / config.pxPerSec;
    const y = (config.size.y - (canvas_y - config.origin.y)) / config.pxPerValue;
    if (this.draggingHaptic.constructor.name == "ContinuousHaptic") {
      this.draggingHaptic.duration = x - this.draggingHaptic.time;
    } else {
      this.draggingHaptic.time = x;
    }
    if (this.tmpHaptic != null) {
      this.draggingHaptic.values.intensity = y;
      this.draggingHaptic.values.sharpness = y;
    } else {
      this.draggingHaptic.values[graph] = y;
    }
  }

  onUp() {
    return;
    this.hasUpdate = false;
    this.draggingHaptic = null;

    if (this.tmpHaptic == null) { return; }
    this.hasUpdate = true;
    if (Math.abs(this.tmpHaptic.duration) < 0.1) {
      let haptic = new TransientHaptic(this.tmpHaptic.time, this.tmpHaptic.values.intensity, this.tmpHaptic.values.sharpness);
      this.haptics.transient.push(haptic);
    } else {
      this.haptics.continuous.push(this.tmpHaptic);
    }
    this.tmpHaptic = null;
  }

  targetGraph(canvas_x, canvas_y) {
    for (let [key, config] of Object.entries(this.graphConfigs)) {
      if (config.origin.x < canvas_x && 
        canvas_x < config.origin.x + config.size.x && 
        config.origin.y < canvas_y && 
        canvas_y < config.origin.y + config.size.y) {
        return key;
      }
    }
    return "";
  }
}
