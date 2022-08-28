import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  initialize() {
    this.element.addEventListener('onDragStart', this.onDragStart.bind(this))
    this.element.addEventListener('onDragEnd', this.onDragEnd.bind(this))
    this.element.addEventListener('onDragOver', this.onDragOver.bind(this))
    this.element.addEventListener('onDragEnter', this.onDragEnter.bind(this))
    this.element.addEventListener('onDrop', this.onDrop.bind(this))
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

    let id = {
      field_id: event.target.getAttribute('data-field-id')
    }
    console.log(id)
    event.dataTransfer.setData('text/plain', JSON.stringify(id))
    // allows fetching via method
    // let minion = fetch('/summoned_minions/'+id+'/grab/')
    // .then((response) => response.json())
  }


  onDragEnd(event) {
    // event.preventDefault()
    setTimeout(function(){ location.reload(); }, 200);
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
    console.log(fromFieldData)
    // console.log()
    console.log("Field on drop fired")
    fetch("/board_fields/"+ id +"/update_drag/", {
      method: "POST",
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        "from_field_id": fromFieldData['field_id'],
        "to_field_id": id
      })
    })
  }
}