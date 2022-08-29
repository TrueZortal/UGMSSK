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
    // event.dataTransfer.dropEffect = "move"
    // event.dataTransfer.effectAllowed = "move"
    console.log("Field drag started")

    let occupant_id = event.target.getAttribute('data-occupant-id')

    let id = {
      field_id: event.target.getAttribute('data-field-id'),
      occupant_id: occupant_id
    }
    console.log(id)
    event.dataTransfer.setData('text/plain', JSON.stringify(id))
    // async query of fields from database with highlight function
    let minion = fetch('/summoned_minions/'+occupant_id+'/grab/')
    .then((response) => response.json())
    .then((minion) => {
      return minion
    })

    const moveList = () => {
      minion.then((a) => {
        const allFields = document.querySelectorAll('.field')
          allFields.forEach((element) => {
          if (a.available_targets.includes(parseInt(element.getAttribute('occupant_id')))) {
            element.style.backgroundColor = "red"
          } else if (a.valid_moves.includes(parseInt(element.getAttribute('field_id')))) {
            element.style.backgroundColor = "chartreuse"
          }
      })
    })
  }
    moveList()


  }


  onDragEnd(event) {
    event.preventDefault()
    // console.log(event)
    const allFields = document.querySelectorAll('.field')
    allFields.forEach((element) => {
      if (element.style.backgroundColor === "chartreuse") {
      element.style.backgroundColor = "transparent"
    } else if (element.style.backgroundColor === "red") {
      element.style.backgroundColor = "transparent"
    }
    })
  }

  onDragOver(event) {
    event.preventDefault()
    // console.log(event.target)
    // console.log("Field on drag over fired")
  }

  onDragEnter(event) {
    event.preventDefault()
    // console.log("Field drag was entered")
  }

  onDragLeave(event) {
    event.preventDefault()
    // console.log("Field drag event was left")
  }

  onDrop(event) {
    event.preventDefault()
    let id = event.target.getAttribute('field_id')
    if (id === null) {
      id = event.target.getAttribute("data-field-id")
    }

    let fromFieldData = JSON.parse(event.dataTransfer.getData('text/plain'))
    console.log("Field on drop fired")
    if (fromFieldData['field_id'] === id) {
      // same field, no action
    } else {
      fetch("/board_fields/"+ id +"/update_drag/", {
        method: "POST",
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          "from_field_id": fromFieldData['field_id'],
          "to_field_id": id
          // ,'malicious_parametr': "blabla haxxorhuehue"
        })
      })
      .then((a) => {
        setTimeout(function(){ location.reload(); }, 50);
      })
    }
  }
}

