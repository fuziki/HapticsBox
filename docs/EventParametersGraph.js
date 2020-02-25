export class GraphConfigs {
  constructor(origin, size, pxPerSec, pxPerValue) {
    this.origin = origin;
    this.size = size;
    this.pxPerSec = pxPerSec;
    this.pxPerValue = pxPerValue;
  }
}

export class ContinuousHaptic {
  constructor(time, duration, intensity, sharpness) {
    this.time = time;
    this.duration = duration;
    this.values = { intensity: intensity, sharpness: sharpness };
    this.tmpHaptic = null;
  }
  json() {
    let time = this.time;
    let duration = this.duration;
    if (this.duration < 0) {
      time += duration;
      duration = -1 * duration;
    }
    let p1 = { ParameterID: "HapticIntensity", ParameterValue: this.values.intensity };
    let p2 = { ParameterID: "HapticSharpness", ParameterValue: this.values.sharpness };
    let e = { Time: time, EventDuration: duration, EventType: "HapticContinuous", EventParameters: [p1, p2]}
    return { Event: e }
  }
}

export class TransientHaptic {
  constructor(time, intensity, sharpness) {
    this.time = time;
    this.values = { intensity: intensity, sharpness: sharpness };
  }
  json() {
    let p1 = { ParameterID: "HapticIntensity", ParameterValue: this.values.intensity };
    let p2 = { ParameterID: "HapticSharpness", ParameterValue: this.values.sharpness };
    let e = { Time: this.time, EventType: "HapticTransient", EventParameters: [p1, p2]}
    return { Event: e }
  }
}

export class EventParametersGraph {
  constructor(intensityGraphConfigs, sharpnessGraphConfigs) {
    this.graphConfigs = { intensity: intensityGraphConfigs, sharpness: sharpnessGraphConfigs, };
    this.haptics = { continuous: [], transient: [] };
    this.tmpHaptic = null;
    this.draggingHaptic = null;
    this.hasUpdate = false;
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
      if (d1 < 7) {
        haptic.time += haptic.duration;
        haptic.duration = -1 * haptic.duration;
        this.draggingHaptic = haptic;
        return;
      }
      let d2 = Math.sqrt(Math.pow(canvas_x - x - w, 2) + Math.pow(canvas_y - y, 2));
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
        this.draggingHaptic = haptic;
        return;
      }
    }

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
