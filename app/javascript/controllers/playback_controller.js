import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { postId: Number };
  static targets = [
    "audio",
    "playButton",
    "progressBar",
    "readBadge",
    "seekHandle",
    "seekInput"
  ];

  markPlayed() {
    const csrfToken = document.querySelector(
      'meta[name="csrf-token"]',
    )?.content;
    fetch(`/families/playbacks/${this.postIdValue}`, {
      method: "POST",
      headers: {
        "X-CSRF-Token": csrfToken,
      },
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error("既読処理に失敗しました");
        }
        this.readBadgeTarget.className = "badge badge-success";
        this.readBadgeTarget.textContent = "既読";
      })
      .catch((error) => {
        console.error("エラー", error);
      });
  }

  togglePlay() {
    if (this.audioTarget.paused) {
      this.seekHandleTarget.classList.remove("hidden");
      this.audioTarget.play();
      this.playButtonTarget.innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="w-5 h-5">
        <path fill-rule="evenodd" d="M6.75 5.25a.75.75 0 0 1 .75-.75H9a.75.75 0 0 1 .75.75v13.5a.75.75 0 0 1-.75.75H7.5a.75.75 0 0 1-.75-.75V5.25Zm7.5 0A.75.75 0 0 1 15 4.5h1.5a.75.75 0 0 1 .75.75v13.5a.75.75 0 0 1-.75.75H15a.75.75 0 0 1-.75-.75V5.25Z" clip-rule="evenodd"/>
      </svg>`;
    } else {
      this.audioTarget.pause();
      this.playButtonTarget.innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="w-5 h-5">
        <path fill-rule="evenodd" d="M4.5 5.653c0-1.427 1.529-2.33 2.779-1.643l11.54 6.347c1.295.712 1.295 2.573 0 3.286L7.28 19.99c-1.25.687-2.779-.217-2.779-1.643V5.653Z" clip-rule="evenodd"/>
      </svg>`;
    }
  }

  resetButton() {
    this.playButtonTarget.innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="w-5 h-5">
        <path fill-rule="evenodd" d="M4.5 5.653c0-1.427 1.529-2.33 2.779-1.643l11.54 6.347c1.295.712 1.295 2.573 0 3.286L7.28 19.99c-1.25.687-2.779-.217-2.779-1.643V5.653Z" clip-rule="evenodd"/>
      </svg>`;
  }

  currentPosition() {
    return (this.seekInputTarget.value / 100) * this.audioTarget.duration;
  }
  
  updateProgress() {
    const progress = (this.audioTarget.currentTime / this.audioTarget.duration) * 100;
    this.seekInputTarget.value = progress;
    this.progressBarTarget.style.width = progress + "%";
  }

  seek() {
    this.audioTarget.currentTime = this.currentPosition();
  }
}
