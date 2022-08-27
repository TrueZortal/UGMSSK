import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // static targets = ["minion"]

  // handleDragStart(event) {
  //   console.log("drag start")
  //   event.dataTransfer.dropEffect = "move"
  //   event.dataTransfer.effectAllowed = "move"
  //   let id = event.target.getAttribute("occupant_id")
  //   console.log(id)
  //   // resourceID = event.target.getAttribute
  //   // console.log(event)
  //   // console.log(event.dataTransfer.dropEffect)
  //   // event.dataTransfer.effectAllowed = "move"
  //   // // console.log(event.dataTransfer.dropEffect)

  //   // let x = this.element.getAttribute("x_position")
  //   // let y = this.element.getAttribute("y_position")
  //   // let minion = fetch('/summoned_minions/'+id+'/grab/')
  //   // .then((response) => response.json())

  //   // console.log(minion)
  //   // console.log(x + "," + y)
  // }

  // // drag(e) {
  // //   e.dataTransfer.setData("text", e.target.id)
  // //   console.log("drag occured")
  // // }

  // onDragOver(event) {
  //   event.preventDefault()
  //   console.log("Minion dragged over")
  // }



  // handleDragEnd(event) {
  //   console.log("drag end")
  //   // console.log(event)
  //   // event.dataTransfer.dropEffect = "move"
  //   // event.dataTransfer.effectAllowed = "move"
  //   // let x = this.element.getAttribute("x_position")
  //   // let y = this.element.getAttribute("y_position")
  //   // console.log(x + "," + y)

  //   // this.style.opacity = '1';
  // }

  // connect() {
  // }

  // onDrop(event) {
  //   event.preventDefault()
  //   console.log("Minion got bodied kek")
  // }

  //   getId() {
  //   // this.element.addEventListener('drag', this.drag.bind(this))
  //   // document.addEventListener('onDragOver', this.onDragOver.bind(this))
  //   // document.addEventListener('dragstart', this.handleDragStart.bind(this))
  //   // document.addEventListener('dragend', this.handleDragEnd.bind(this))
  //   // document.addEventListener('onDrop', this.onDrop.bind(this))
  //   this.element.addEventListener('onDragOver', this.onDragOver.bind(this))
  //   this.element.addEventListener('dragstart', this.handleDragStart.bind(this))
  //   this.element.addEventListener('dragend', this.handleDragEnd.bind(this))
  //   this.element.addEventListener('onDrop', this.onDrop.bind(this))

  //     // console.log(e)

  //   let id = this.element.getAttribute("occupant_id")
  //   let minion = fetch('/summoned_minions/'+id+'/grab/')
  //   .then((response) => response.json())

  //   console.log(minion)

  // }
}