import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  onDrag(event) {
  }

  onDragStart(event){
    console.log("Field drag started")

    let occupant_id = event.target.getAttribute('data-occupant-id')

    let id = {
      field_id: event.target.getAttribute('data-field-id'),
      occupant_id: occupant_id
    }
    console.log(id)
    event.dataTransfer.setData('text/plain', JSON.stringify(id))
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
  }

  onDragEnter(event) {
    event.preventDefault()
  }

  onDragLeave(event) {
    event.preventDefault()
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
      fetch("/summoned_minions/"+ id +"/update_drag/", {
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
      .then((a) => {
        // setTimeout(function(){ location.reload(); }, 50);
      })
    }
  }
}

