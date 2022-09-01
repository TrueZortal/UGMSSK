import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // static targets = [ "hideable" ]



  summon() {
    var summon = document.getElementById("summon")
    // var move = document.getElementById("move")
    // var attack = document.getElementById("attack")

    // move.style.display = "none"
    // attack.style.display = "none"
    if (summon.style.display === "none") {
      summon.style.display = "block";
    } else {
      summon.style.display = "none";
    }
  }

  //deprecated with the drag and drop functionality, leaving in the case of troubleshooting
  move() {
    var summon = document.getElementById("summon")
    var move = document.getElementById("move")
    var attack = document.getElementById("attack")

    summon.style.display = "none";
    attack.style.display = "none"
    if (move.style.display === "none") {
      move.style.display = "block";
    } else {
      move.style.display = "none";
    }
  }

  //deprecated with the drag and drop functionality, leaving in the case of troubleshooting
  attack() {
    var summon = document.getElementById("summon")
    var move = document.getElementById("move")
    var attack = document.getElementById("attack")

    summon.style.display = "none";
    move.style.display = "none"
    if (attack.style.display === "none") {
      attack.style.display = "block";
    } else {
      attack.style.display = "none";
    }
  }
}