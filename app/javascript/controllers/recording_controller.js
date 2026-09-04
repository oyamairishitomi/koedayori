import { Controller } from "@hotwired/stimulus"

// サーバー側(Post#audio_size)の100MB上限と足並みを揃えるための、クライアント側の録音時間の上限。
// 際限なく録音され続けてファイルサイズが膨らむのを防ぐ。長話をする人向けに10分まで許容する。
const MAX_RECORDING_MS = 10 * 60 * 1000 // 10分

export default class extends Controller {
  static targets = [
    "toggleBtn",
    "buttonLabel",
    "status",
    "recordSection",
    "completeSection",
    "timer",
    "errorSection",
    "micErrorSection",
    "retryBtn"
  ]

  static values = { slug: String }

  start() {
    this.toggleBtnTarget.disabled = true
    this.statusTarget.textContent = "マイクを準備しています"

    navigator.mediaDevices.getUserMedia({ audio: true })
      .then((stream) => {
        this.stream = stream
        this.chunks = []

        // mp4/AACはSafari・Chrome双方で安定して再生できるため優先する。
        // 対応していない環境(古いAndroid Chrome等)だけwebm/Opusにフォールバックする。
        const mimeType = MediaRecorder.isTypeSupported("audio/mp4") ? "audio/mp4" : "audio/webm"
        this.recorder = new MediaRecorder(stream, { mimeType })

        this.recorder.ondataavailable = (event) => {
          this.chunks.push(event.data)
        }

        this.recorder.onstop = () => this.upload()
        this.recorder.start()
        this.startTimer()

        this.maxDurationTimeoutId = setTimeout(() => {
          if (this.recorder && this.recorder.state === "recording") {
            this.stop()
          }
        }, MAX_RECORDING_MS)

        this.toggleBtnTarget.disabled = false
        this.toggleBtnTarget.classList.add("recording-button--active")
        this.toggleBtnTarget.setAttribute("aria-label", "録音を終えてこえを届ける")
        this.toggleBtnTarget.setAttribute("aria-pressed", "true")
        this.buttonLabelTarget.innerHTML = "話し終わったら<br>ここを押す"
        this.statusTarget.textContent = "録音中"
      })
      .catch((error) => {
        if (error.name == "NotAllowedError") {
          this.micErrorSectionTarget.innerHTML = "iPhoneの設定でマイクが許可されていません。Safariにマイク使用を許可してください"
        }
        this.stopTimer()
        this.micErrorSectionTarget.classList.remove("hidden")
        this.recordSectionTarget.classList.add("hidden")
      })
  }

  stop() {
    this.stopTimer()
    clearTimeout(this.maxDurationTimeoutId)
    this.toggleBtnTarget.disabled = true
    this.statusTarget.textContent = "こえを送信しています"
    this.buttonLabelTarget.textContent = "送信中"
    this.recorder.stop()
    this.stream.getTracks().forEach((track) => track.stop())
  }

  toggle() {
    if (this.recorder?.state === "recording") {
      this.stop()
    } else {
      this.start()
    }
  }

  startTimer() {
    this.startTime = Date.now()
    this.timerTarget.textContent = "0:00"
    this.timerId = setInterval(() => {
      const elapsedSeconds = Math.floor((Date.now() - this.startTime) / 1000)
      const minutes = Math.floor(elapsedSeconds / 60)
      const seconds = elapsedSeconds % 60
      this.timerTarget.textContent = `${minutes}:${seconds.toString().padStart(2, "0")}`
    }, 1000)
  }

  stopTimer() {
    clearInterval(this.timerId)
    this.timerId = null
  }

  upload() {
    const blob = new Blob(this.chunks, { type: this.recorder.mimeType })
    const formData = new FormData()
    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content
    formData.append("audio", blob, "recording.webm")

    fetch(`/speakers/${this.slugValue}/posts`, {
      method: "POST",
      headers: { "X-CSRF-Token": csrfToken },
      body: formData
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.status !== "ok") throw new Error("録音の送信に失敗しました")
        this.recordSectionTarget.classList.add("hidden")
        this.completeSectionTarget.classList.remove("hidden")
      })
      .catch(() => {
        this.errorSectionTarget.classList.remove("hidden")
        this.recordSectionTarget.classList.add("hidden")
      })
  }

  retry() {
    this.errorSectionTarget.classList.add("hidden")
    this.recordSectionTarget.classList.remove("hidden")
    this.toggleBtnTarget.disabled = false
    this.toggleBtnTarget.classList.remove("recording-button--active")
    this.toggleBtnTarget.setAttribute("aria-label", "こえの録音を始める")
    this.toggleBtnTarget.setAttribute("aria-pressed", "false")
    this.buttonLabelTarget.innerHTML = "ここを押して<br>「こえ」を録音する"
    this.statusTarget.textContent = "押すと録音が始まります"
    this.timerTarget.textContent = ""
    this.recorder = null
    this.stream = null
  }
}
