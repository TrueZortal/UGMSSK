import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // static targets = ["minion"]

  setListeners() {
  let items = document.querySelectorAll('minion');
  items.forEach(function (item) {
    console.log("this triggered for "+item)
    item.addEventListener('dragstart', handleDragStart);
    item.addEventListener('dragend', handleDragEnd);
  })
}

handleDragStart(e) {
  console.log("drag start")
  this.style.opacity = '0.4';
}

handleDragEnd(e) {
  console.log("drag end")
  this.style.opacity = '1';
}

  getId() {
    // console.log(e)
    let id = this.element.getAttribute("occupant_id")
    let minion = fetch('/summoned_minions/'+id+'/grab/')
    .then((response) => response.json())

    console.log(minion)

  }
}