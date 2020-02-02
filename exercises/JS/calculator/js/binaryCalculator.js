var result = document.getElementById('res');
function appendtext(txt) {
  result.innerHTML += txt;
}

function computeRes(str) {
  strs = str.split(/[+*/-]/);
  op   = str.substr(strs[0].length, 1);
  return eval("0b" + strs[0] + op + "0b" + strs[1]).toString(2);
}

var mustClean = false;
function cleanScreen() {
  result.innerHTML = '';
}

for (const btnid of ["btn0", "btn1", "btnSum", "btnSub", "btnMul", "btnDiv"]) {
  let btn = document.getElementById(btnid)
  btn.onclick = function() {
    if (mustClean) {
      cleanScreen();
      mustClean = false;
    }
    appendtext(btn.innerHTML);
  }
}

document.getElementById("btnClr").onclick = function() {
  cleanScreen();
}

document.getElementById("btnEql").onclick = function() {
  result.innerHTML = computeRes(result.innerHTML);
  mustClean = true;
}
