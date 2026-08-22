import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }
  static targets = ["button"]

  copy() {
    navigator.clipboard.writeText(this.urlValue).then(() => {
      const button = this.hasButtonTarget ? this.buttonTarget : this.element
      const originalText = button.textContent

      button.textContent = "コピーしました"

      setTimeout(() => {
        button.textContent = originalText
      }, 2000)
    })
  }
}
