import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  summon() {
    let summon = document.getElementById("summon")
    if (summon.style.display === "none") {
      summon.style.display = "block";
    } else if (summon.style.display === "block") {
      summon.style.display = "none";
    } else {
      summon.style.display = "block";
    }
  }
}