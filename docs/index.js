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
var slider
var maxSec

function init() {
    canvas = document.getElementById('canvas');
    textarea = document.getElementById('textarea');
    urlInput = document.getElementById('urlInput');
    slider = document.getElementById('rangeSlider');
    maxSec = document.getElementById('maxSec');
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
    slider.addEventListener('input', sliderChane, false);;

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
    if (stridPoints == 0) { continue; }
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

  let l1 = canvasViewModel.padding_y + canvasViewModel.graph_height;
  let l2 = l1 + (canvasViewModel.graph_height + canvasViewModel.graph_space_height);
  let l3 = l2 + (canvasViewModel.graph_height + canvasViewModel.graph_space_height);
  let l4 = l3 + (canvasViewModel.graph_height + canvasViewModel.graph_space_height);
  let baseLines = [l1, l2, l3, l4];
  for (let line of baseLines) {
    context.beginPath();
    context.moveTo(0, line);
    context.lineTo(canvas.width, line);
    context.stroke();
    context.fillText((canvasViewModel.maxSec / 4 * 0).toFixed(1) + "sec", 0, line - 3);
    context.fillText((canvasViewModel.maxSec / 4 * 1).toFixed(1) + "sec", canvas.width / 4 - 20, line - 3);
    context.fillText((canvasViewModel.maxSec / 4 * 2).toFixed(1) + "sec", canvas.width / 2 - 20, line - 3);
    context.fillText((canvasViewModel.maxSec / 4 * 3).toFixed(1) + "sec", canvas.width * 3 / 4 - 20, line - 3);
    context.fillText((canvasViewModel.maxSec / 4 * 4).toFixed(1) + "sec", canvas.width - 35, line - 3);
  }

  context.fillText("event intensity", 5, l1 - canvasViewModel.graph_height + 15);
  context.fillText("event sharpness", 5, l2 - canvasViewModel.graph_height + 15);
  context.fillText("curve intensity", 5, l3 - canvasViewModel.graph_height + 15);
  context.fillText("curve sharpness", 5, l4 - canvasViewModel.graph_height + 15);

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
  canvasViewModel.readJson(JSON.parse(textarea.value));
  draw();
}

function sliderChane() {
  maxSec.value = (slider.value * slider.value).toFixed(2) + "sec"
  canvasViewModel.updateMaxSec(slider.value * slider.value);
  draw();
}
