import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  initialize() {
    // console.log(this.element)
    // minions = document.getElementsByClassName("minion")
    // Array.from(minions).forEach (function()
    // )
    // document.addEventListener('onDrag', this.onDrag.bind(this))
    // document.addEventListener('onDragStart', this.onDragStart.bind(this))
    // document.addEventListener('onDragEnd', this.onDragEnd.bind(this))
    // document.addEventListener('onDragOver', this.onDragOver.bind(this))
    // document.addEventListener('onDragEnter', this.onDragEnter.bind(this))
    // document.addEventListener('onDragLeave', this.onDragLeave.bind(this))
    // document.addEventListener('onDrop', this.onDrop.bind(this))
    // this.element.addEventListener('onDrag', this.onDrag.bind(this))
    this.element.addEventListener('onDragStart', this.onDragStart.bind(this))
    this.element.addEventListener('onDragEnd', this.onDragEnd.bind(this))
    this.element.addEventListener('onDragOver', this.onDragOver.bind(this))
    this.element.addEventListener('onDragEnter', this.onDragEnter.bind(this))
    // this.element.addEventListener('onDragLeave', this.onDragLeave.bind(this))
    this.element.addEventListener('onDrop', this.onDrop.bind(this))

    // console.log("field is now listening for drops and dragovers")
  }

  onDrag(event) {
    // event.preventDefault()
    console.log("Field on drag fired")
  }

  onDragStart(event){
    // event.preventDefault()
    event.dataTransfer.dropEffect = "move"
    event.dataTransfer.effectAllowed = "move"
    console.log("Field drag started")
    // field_id = event.target.getAttribute('data-field-id')
    let id = {
      field_id: event.target.getAttribute('data-field-id')
      // ,occupant_id: event.target.getAttribute('data-occupant-id')
    }
    console.log(id)
    event.dataTransfer.setData('text/plain', JSON.stringify(id))
    // allows fetching via method
    // let minion = fetch('/summoned_minions/'+id+'/grab/')
    // .then((response) => response.json())

    // console.log(minion)
  }


  onDragEnd(event) {
    // event.preventDefault()
    // console.log("Field drag ended")
  }

  onDragOver(event) {
    event.preventDefault()
    // console.log("Field on drag over fired")
  }

  onDragEnter(event) {
    event.preventDefault()
    // console.log("Field drag was entered")
  }

  onDragLeave(event) {
    // event.preventDefault()
    // console.log("Field drag event was left")
  }

  onDrop(event) {
    event.preventDefault()
    let id = event.target.getAttribute('field_id')
    if (id === null) {
      id = event.target.getAttribute("data-field-id")
    }
    let fromFieldData = JSON.parse(event.dataTransfer.getData('text/plain'))
    const headers = {
      "from_field_id": fromFieldData['field_id'],
      "to_field_id": id
    }
    // console.log(id)
    // console.log()
    console.log("Field on drop fired")
    fetch("/board_fields/"+ id +"/update_drag/", { headers, method: "POST" })
  }
}