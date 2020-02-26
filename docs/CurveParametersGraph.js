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
    this.haptics = { continuous: [], transient: [] };
    this.tmpHaptic = null;
    this.draggingHaptic = null;
    this.hasUpdate = false;
    this.enabeleDeleteMode = false;
  }

  onDown(canvas_x, canvas_y) {
    this.hasUpdate = false;
    if (this.draggingHaptic != null) { return; }

    const graph = this.targetGraph(canvas_x, canvas_y);
    if (graph == "") { return; }

    for (let haptic of this.haptics.continuous) {
      let config = this.graphConfigs[graph];
      let w = haptic.duration * config.pxPerSec;
      let x = haptic.time * config.pxPerSec + config.origin.x;
      let y = config.origin.y + config.size.y - haptic.values[graph] * config.pxPerValue;
      let d1 = Math.sqrt(Math.pow(canvas_x - x, 2) + Math.pow(canvas_y - y, 2));
      let d2 = Math.sqrt(Math.pow(canvas_x - x - w, 2) + Math.pow(canvas_y - y, 2));
      if (this.enabeleDeleteMode) {
        if (d1 < 7 || d2 < 7) {
          var index = this.haptics.continuous.indexOf(haptic);
          if(index >= 0){
            this.haptics.continuous.splice(index, 1); 
          }
          this.hasUpdate = true;
          return;
        }
        continue;
      }
      if (d1 < 7) {
        haptic.time += haptic.duration;
        haptic.duration = -1 * haptic.duration;
        this.draggingHaptic = haptic;
        return;
      }
      if (d2 < 7) {
        this.draggingHaptic = haptic;
        return;
      }
    }

    for (let haptic of this.haptics.transient) {
      let config = this.graphConfigs[graph];
      let x = haptic.time * config.pxPerSec + config.origin.x;
      let y = config.origin.y + config.size.y - haptic.values[graph] * config.pxPerValue;
      let d1 = Math.sqrt(Math.pow(canvas_x - x, 2) + Math.pow(canvas_y - y, 2));
      if (d1 < 7) {
        if (this.enabeleDeleteMode) {
          var index = this.haptics.transient.indexOf(haptic);
          if(index >= 0){
            this.haptics.transient.splice(index, 1); 
          }
          this.hasUpdate = true;
        } else {
          this.draggingHaptic = haptic;
        }
        return;
      }
    }

    if (this.enabeleDeleteMode) { return; }

    const config = this.graphConfigs[graph];
    const x = (canvas_x - config.origin.x) / config.pxPerSec;
    const y = (config.origin.y + config.size.y - canvas_y) / config.pxPerValue;
    this.tmpHaptic = new ContinuousHaptic(x, 0, y, y);
    this.draggingHaptic = this.tmpHaptic;
    this.hasUpdate = true;
  }

  onMove(canvas_x, canvas_y) {
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
