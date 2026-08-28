import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    delay: { type: Number, default: 5000 }
  }

  connect() {
    this.dismissTimer = window.setTimeout(() => this.dismiss(), this.delayValue)
  }

  disconnect() {
    window.clearTimeout(this.dismissTimer)
    window.clearTimeout(this.removeTimer)
  }

  dismiss() {
    this.element.classList.add("-translate-y-2", "opacity-0")
    this.removeTimer = window.setTimeout(() => this.element.remove(), 200)
  }
}
