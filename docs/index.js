import { CanvasViewModel } from "./CanvasViewModel.js";

onload = function() {
    init();
};

shortcut.add("Shift+S",function() {
  sendWs();
});

var canvas
var context
var canvasViewModel
var textarea
var urlInput
var ws

function init() {
    canvas = document.getElementById('canvas');
    textarea = document.getElementById('textarea');
    urlInput = document.getElementById('urlInput');
    if ( ! canvas || ! canvas.getContext ) {
        return false;
    }
    context = canvas.getContext('2d');

    canvasViewModel = new CanvasViewModel(canvas);

    canvas.addEventListener('mousedown', onDown, false)
    canvas.addEventListener('mousemove', onMove, false);
    canvas.addEventListener('mouseup', onUp, false);

    document.getElementById('connectButton').addEventListener('click', connectWs, false);
    document.getElementById('closeButton').addEventListener('click', closeWs, false);
    document.getElementById('sendButton').addEventListener('click', sendWs, false);
    document.getElementById('modeButton').addEventListener('click', toggledDleteMode, false);
    document.getElementById('readButton').addEventListener('click', read, false);

    draw();
}

function onDown(e) {
  var offset_x = canvas.getBoundingClientRect().left;
  var offset_y = canvas.getBoundingClientRect().top;
  var canvas_x = e.clientX - offset_x;
  var canvas_y = e.clientY - offset_y;

  canvasViewModel.onDown(canvas_x, canvas_y);
  if(canvasViewModel.shouldDraw) {
    draw();
  }
}

function onMove(e) {
  var offset_x = canvas.getBoundingClientRect().left;
  var offset_y = canvas.getBoundingClientRect().top;
  var canvas_x = e.clientX - offset_x;
  var canvas_y = e.clientY - offset_y;

  canvasViewModel.onMove(canvas_x, canvas_y);
  if(canvasViewModel.shouldDraw) {
      draw();
  }
}
  
function onUp(e) {
  canvasViewModel.onUp();
  if(canvasViewModel.shouldDraw) {
      draw();
  }
}

function draw() {
  context.strokeStyle="black"
  context.fillStyle="lightgray";
  let intensityEventBaseLine = canvas.height / 4;
  let sharpnessEventBaseLine = canvas.height / 4 * 2;
  let intensityCurveBaseLine = canvas.height / 4 * 3;
  let sharpnessCurveBaseLine = canvas.height / 4 * 4;
  let baseLines = [intensityEventBaseLine, sharpnessEventBaseLine, intensityCurveBaseLine, sharpnessCurveBaseLine];

  context.clearRect(0, 0, canvas.width, canvas.height);
  context.fillRect(0, 0, canvas.width, canvas.height);

  for (let rect of canvasViewModel.drawRects) {
    context.strokeStyle="black"
    context.fillStyle="clear";
    context.strokeRect(rect.origin.x, rect.origin.y, rect.size.x, rect.size.y);
  }
  for (let line of canvasViewModel.drawLines) {
    context.strokeStyle="black"
    context.fillStyle="clear";
    context.beginPath();
    context.moveTo(line.start.x, line.start.y);
    context.lineTo(line.end.x, line.end.y);
    context.stroke();
  }

  for (let stridPoints of canvasViewModel.drawStrideLines) {
    context.beginPath();
    context.moveTo(stridPoints[0].x, stridPoints[0].y);
    for(var i = 0; i < stridPoints.length; i++) {
      context.lineTo(stridPoints[i].x, stridPoints[i].y);
    }
    context.stroke();
  }

  for (let circle of canvasViewModel.drawCircles) {
    context.strokeStyle="black"
    context.fillStyle="white";
    context.beginPath();
    context.arc(circle.center.x, circle.center.y, circle.radius, 0, 2 * Math.PI, true);
    context.fill();
    context.stroke();
  }

  context.font = "20px"
  context.fillStyle="black";

  for (let line of baseLines) {
    context.beginPath();
    context.moveTo(0, line);
    context.lineTo(canvas.width, line);
    context.stroke();
    context.fillText("0.0sec", 0, line - 3);
    context.fillText("1.0sec", canvas.width / 4 - 20, line - 3);
    context.fillText("2.0sec", canvas.width / 2 - 20, line - 3);
    context.fillText("3.0sec", canvas.width * 3 / 4 - 20, line - 3);
    context.fillText("4.0sec", canvas.width - 35, line - 3);
  }

  context.fillText("event intensity", 5, intensityEventBaseLine - canvas.height / 4 + 15);
  context.fillText("event sharpness", 5, sharpnessEventBaseLine - canvas.height / 4 + 15);
  context.fillText("curve intensity", 5, intensityCurveBaseLine - canvas.height / 4 + 15);
  context.fillText("curve sharpness", 5, sharpnessCurveBaseLine - canvas.height / 4 + 15);

  textarea.value = JSON.stringify(canvasViewModel.json());
}

function connectWs() {
  console.log("connect", urlInput.value);
  ws = new WebSocket(urlInput.value);
}

function closeWs() {
  console.log("close");
  ws.close();
  ws = null;
}

function sendWs() {
  console.log("send", textarea.value);
  if (ws == null) { return; }
  ws.send(textarea.value);
}

function toggledDleteMode() {
  canvasViewModel.toggledDleteMode();
  document.getElementById('modeButton').value = canvasViewModel.enabeleDeleteMode ? "delete mode: on" : "delete mode: off";
}

function read() {
  console.log("read text area");
}