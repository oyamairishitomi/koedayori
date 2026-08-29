import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }
  static targets = ["button"]

  copy() {
    const button = this.hasButtonTarget ? this.buttonTarget : this.element
    const originalText = button.textContent

    navigator.clipboard.writeText(this.urlValue).then(() => {
      button.textContent = "コピーしました"

      setTimeout(() => {
        button.textContent = originalText
      }, 2000)
    }).catch(() => {
      button.textContent = "コピーできませんでした"

      setTimeout(() => {
        button.textContent = originalText
      }, 2000)
    })
  }
}
