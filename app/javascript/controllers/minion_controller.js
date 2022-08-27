import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // static targets = ["minion"]

  handleDragStart(event) {
    console.log("drag start")
    console.log(event)
    let id = this.element.getAttribute("occupant_id")
    let minion = fetch('/summoned_minions/'+id+'/grab/')
    .then((response) => response.json())

    console.log(minion)
    // this.style.opacity = '0.4';
  }

  handleDragEnd(event) {
    console.log("drag end")
    console.log(event)

    // this.style.opacity = '1';
  }

  connect() {
  }

  // disconnect() {
    //   let items = document.getElementsByClassName("minion")
    //   console.log("this works but something is missing")
    //   // console.log(items)
    //   Array.from(items).forEach(function (item) {
      //     console.log("this triggered for "+item)
      //     item.removeEventListener('dragstart', this.handleDragStart.bind(this))
      //     item.removeEventListener('dragend', this.handleDragEnd.bind(this))
      //   })
      // }

      getId() {
      this.element.addEventListener('dragstart', this.handleDragStart.bind(this))
      this.element.addEventListener('dragend', this.handleDragEnd.bind(this))
        // console.log(e)

    let id = this.element.getAttribute("occupant_id")
    let minion = fetch('/summoned_minions/'+id+'/grab/')
    .then((response) => response.json())

    console.log(minion)

  }
}