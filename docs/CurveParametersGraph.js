export class GraphConfigs {
  constructor(origin, size, pxPerSec, pxPerValue) {
    this.origin = origin;
    this.size = size;
    this.pxPerSec = pxPerSec;
    this.pxPerValue = pxPerValue;
  }
}

export class ControlPoint {
  constructor(time, value, timeConstraint = false) {
    this.time = time;
    this.value = value;
    this.timeConstraint = timeConstraint;
  }
  json() {
    return { Time: this.time, ParameterValue: this.value };
  }
}

export class CurveParametersGraph {
  constructor(intensityGraphConfigs, sharpnessGraphConfigs) {
    this.graphConfigs = { intensity: intensityGraphConfigs, sharpness: sharpnessGraphConfigs, };
    this.controlPoints = { intensity: [], sharpness: [] };
    this.controlPoints.intensity.push(new ControlPoint(0, 1, true));
    this.controlPoints.intensity.push(new ControlPoint(4, 1, true));
    this.controlPoints.sharpness.push(new ControlPoint(0, 1, true));
    this.controlPoints.sharpness.push(new ControlPoint(4, 1, true));

    this.draggingPoint = null;
    this.hasUpdate = true;
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
      if (d < 14) {
        if (this.enabeleDeleteMode) {
          if (point.timeConstraint) { return; }
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
    this.sort(graph);
  }

  onMove(canvas_x, canvas_y) {
    this.hasUpdate = false;
    const graph = this.targetGraph(canvas_x, canvas_y);
    if (graph == "") { return; }

    if (this.draggingPoint == null) {
      return;
    }
    this.hasUpdate = true;

    const config = this.graphConfigs[graph];
    const x = (canvas_x - config.origin.x) / config.pxPerSec;
    const y = (config.size.y - (canvas_y - config.origin.y)) / config.pxPerValue;
    if (!this.draggingPoint.timeConstraint) {
      this.draggingPoint.time = x;
      this.sort(graph);
    }
    this.draggingPoint.value = y;
  }

  onUp() {
    this.hasUpdate = false;
    this.draggingPoint = null;
  }

  jsons() {
    let ipoints = []
    this.controlPoints.intensity.forEach(e => {
      ipoints.push(e.json());
    })
    let spoints = []
    this.controlPoints.sharpness.forEach(e => {
      spoints.push(e.json());
    })
    let icurve = { ParameterID: "HapticIntensityControl", Time: 0.0, ParameterCurveControlPoints: ipoints }
    let scurve = { ParameterID: "HapticSharpnessControl", Time: 0.0, ParameterCurveControlPoints: spoints }
    return [{ ParameterCurve: icurve }, { ParameterCurve: scurve }];
  }

  sort(graph) {
    this.controlPoints[graph].sort((l, r) => {
      return l.time > r.time ? 1 : -1;
    });
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
