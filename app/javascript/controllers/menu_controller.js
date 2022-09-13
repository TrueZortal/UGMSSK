import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // static targets = [ "hideable" ]

initialize(){
  var summon = document.getElementById("summon")
  this.element.addEventListener('onMouseover', this.summon.bind(this))
  console.log(this.element + "got initialized")
}

  summon() {
    var summon = document.getElementById("summon")
    if (summon.style.display === "none") {
      summon.style.display = "block";
    } else {
      summon.style.display = "none";
    }
  }
}