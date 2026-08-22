import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "button",
    "details"
]

    click() {
        localStorage.setItem("close", "true")
        this.detailsTarget.classList.add("hidden")
    }

    connect() {
    if (localStorage.getItem("close") == "true") {
        this.detailsTarget.classList.add("hidden")
    }
  }
}
