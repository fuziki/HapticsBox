import { CanvasViewModel } from "./CanvasViewModel.js";

onload = function() {
    init();
};

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
  context.beginPath();
  context.moveTo(0, canvas.height / 2);
  context.lineTo(canvas.width, canvas.height / 2);
  context.stroke();
  context.beginPath();
  context.moveTo(0, canvas.height);
  context.lineTo(canvas.width, canvas.height);
  context.stroke();

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
  for (let circle of canvasViewModel.drawCircles) {
    context.strokeStyle="black"
    context.fillStyle="white";
    context.beginPath();
    context.arc(circle.center.x, circle.center.y, circle.radius, 0, 2 * Math.PI, true);
    context.fill();
    context.stroke();
  }
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