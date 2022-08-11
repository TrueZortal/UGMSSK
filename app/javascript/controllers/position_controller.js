import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["field"]
  greet() {
    console.log(JSON.parse(this.element.getAttribute("address")))
  }
}