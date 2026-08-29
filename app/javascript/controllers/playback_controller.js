import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["audio", "playButton", "seekInput", "currentTime", "duration"]

  togglePlay() {
    if (this.audioTarget.paused) {
      this.audioTarget.play()
      this.showPauseButton()
    } else {
      this.audioTarget.pause()
      this.showPlayButton()
    }
  }

  showDuration() {
    this.durationTarget.textContent = this.formatTime(this.audioTarget.duration)
  }

  updateProgress() {
    if (!Number.isFinite(this.audioTarget.duration)) return

    this.seekInputTarget.value = (this.audioTarget.currentTime / this.audioTarget.duration) * 100
    this.currentTimeTarget.textContent = this.formatTime(this.audioTarget.currentTime)
  }

  seek() {
    if (!Number.isFinite(this.audioTarget.duration)) return

    this.audioTarget.currentTime = (this.seekInputTarget.value / 100) * this.audioTarget.duration
  }

  resetButton() {
    this.showPlayButton()
    this.seekInputTarget.value = 0
    this.currentTimeTarget.textContent = "0:00"
  }

  showPauseButton() {
    this.playButtonTarget.setAttribute("aria-label", "一時停止")
    this.playButtonTarget.innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="h-5 w-5" aria-hidden="true">
      <path fill-rule="evenodd" d="M6.75 5.25a.75.75 0 0 1 .75-.75H9a.75.75 0 0 1 .75.75v13.5a.75.75 0 0 1-.75.75H7.5a.75.75 0 0 1-.75-.75V5.25Zm7.5 0A.75.75 0 0 1 15 4.5h1.5a.75.75 0 0 1 .75.75v13.5a.75.75 0 0 1-.75.75H15a.75.75 0 0 1-.75-.75V5.25Z" clip-rule="evenodd"/>
    </svg>`
  }

  showPlayButton() {
    this.playButtonTarget.setAttribute("aria-label", "再生")
    this.playButtonTarget.innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="h-5 w-5" aria-hidden="true">
      <path fill-rule="evenodd" d="M4.5 5.653c0-1.427 1.529-2.33 2.779-1.643l11.54 6.347c1.295.712 1.295 2.573 0 3.286L7.28 19.99c-1.25.687-2.779-.217-2.779-1.643V5.653Z" clip-rule="evenodd"/>
    </svg>`
  }

  formatTime(value) {
    if (!Number.isFinite(value)) return "0:00"

    const minutes = Math.floor(value / 60)
    const seconds = Math.floor(value % 60)
    return `${minutes}:${seconds.toString().padStart(2, "0")}`
  }
}
