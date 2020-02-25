export class Vector2 {
  constructor(x, y) {
      this.x = x;
      this.y = y;
  }    
}

export class Rect {
  constructor(origin, size) {
    this.origin = origin;
    this.size = size;
  }
}

export class Line {
  constructor(start, end) {
    this.start = start;
    this.end = end;
  }
}

export class Circle {
  constructor(center, radius) {
    this.center = center;
    this.radius = radius;
  }
}
