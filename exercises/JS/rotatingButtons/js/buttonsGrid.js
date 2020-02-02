var labels = ['1','2','3','6','9','8','7','4'];
var buttons = labels.map(x => document.getElementById("btn" + x));

document.getElementById("btn5").onclick = function() {
  labels = [labels.pop(), ...labels];
  for (var i = 0; i < buttons.length; ++i) {
    buttons[i].innerHTML = labels[i];
  }
}
