import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  save(key, value) {
    localStorage.setItem(key, value)
  }
}