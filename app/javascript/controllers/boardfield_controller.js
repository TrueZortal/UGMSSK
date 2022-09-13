import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // temporary timeout function to enable "syncing" before websocket implementation
    setTimeout(function(){ location.reload(); }, 15000);
  }
}