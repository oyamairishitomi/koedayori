import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [
        "startBtn",
        "stopBtn",
        "toggleBtn",
        "recordSection",
        "completeSection",
        "timer",
        "errorSection",
        "micErrorSection",
        "retryBtn"
    ]

    static values = { slug: String }

    connect() {
    }

    start(){
        this.startTime = Date.now()

        this.timerId = setInterval(() => {
            this.elapsedTime = Date.now() - this.startTime;

            this.minutes = Math.floor((this.elapsedTime / 1000 / 60) % 60);
            this.seconds = Math.floor((this.elapsedTime / 1000) % 60);
            this.milliseconds = Math.floor((this.elapsedTime % 1000) / 10);

            this.timerTarget.textContent = `${this.minutes}:${this.seconds.toString().padStart(2,"0")}:${this.milliseconds.toString().padStart(2,"0")}`
        }, 10);

        navigator.mediaDevices.getUserMedia({ audio: true })
          .then((stream) => {
            this.stream = stream;
            this.chunks = [];
            this.recorder = new MediaRecorder(stream);

            this.recorder.ondataavailable = (event) => {
              this.chunks.push(event.data);
            };

            this.recorder.onstop = () => {
            this.blob = new Blob(this.chunks, { type: 'audio/webm' });

            const formData = new FormData();
            const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content;

            formData.append("audio", this.blob, "recording.webm");

            fetch(`/speakers/${this.slugValue}/posts`, {
            method: "POST",
            headers: {
                "X-CSRF-Token": csrfToken
            },
            body: formData,
            })
            .then(response => {
                return response.json()
            })
            .then(data => {
                if (data.status === "ok") {
                this.recordSectionTarget.classList.add("hidden");
                this.completeSectionTarget.classList.remove("hidden");
                } else {
                this.errorSectionTarget.classList.remove("hidden");
                this.recordSectionTarget.classList.add("hidden");
            }
            })
            .catch(() => {
                this.errorSectionTarget.classList.remove("hidden");
                this.recordSectionTarget.classList.add("hidden");
            })
            }
            this.recorder.start();
        })
        .catch(() => {
            clearInterval(this.timerId)
            this.micErrorSectionTarget.classList.remove("hidden");
            this.recordSectionTarget.classList.add("hidden");
        });
    }

    stop() {
        clearInterval(this.timerId);
        this.recorder.stop();
        this.stream.getTracks().forEach((track) => {
            track.stop()
        })
    }

    toggle() {
        if (this.recorder && this.recorder.state === "recording") {
            this.stop();
        } else {
            this.start();
            this.toggleBtnTarget.className = "animate-pulse w-64 h-64 rounded-full bg-error"
            this.toggleBtnTarget.innerHTML = `
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="text-white w-18 h-18 mx-auto mb-2">
                <path d="M8.25 4.5a3.75 3.75 0 1 1 7.5 0v8.25a3.75 3.75 0 1 1-7.5 0V4.5Z"/>
                <path d="M6 10.5a.75.75 0 0 1 .75.75v1.5a5.25 5.25 0 1 0 10.5 0v-1.5a.75.75 0 0 1 1.5 0v1.5a6.751 6.751 0 0 1-6 6.709v2.291h3a.75.75 0 0 1 0 1.5h-7.5a.75.75 0 0 1 0-1.5h3v-2.291a6.751 6.751 0 0 1-6-6.709v-1.5A.75.75 0 0 1 6 10.5Z"/>
            </svg>
            <p class="text-white text-2xl font-bold">ふきこみ中</p>
            `
        }
    }

    retry() {
        this.errorSectionTarget.classList.add("hidden")
        this.recordSectionTarget.classList.remove("hidden")
        this.toggleBtnTarget.className = "w-64 h-64 rounded-full bg-success"
        this.toggleBtnTarget.innerHTML = `
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="text-white w-18 h-18 mx-auto mb-2">
            <path d="M8.25 4.5a3.75 3.75 0 1 1 7.5 0v8.25a3.75 3.75 0 1 1-7.5 0V4.5Z"/>
            <path d="M6 10.5a.75.75 0 0 1 .75.75v1.5a5.25 5.25 0 1 0 10.5 0v-1.5a.75.75 0 0 1 1.5 0v1.5a6.751 6.751 0 0 1-6 6.709v2.291h3a.75.75 0 0 1 0 1.5h-7.5a.75.75 0 0 1 0-1.5h3v-2.291a6.751 6.751 0 0 1-6-6.709v-1.5A.75.75 0 0 1 6 10.5Z"/>
        </svg>
        <p class="text-white text-2xl font-bold">ここを押して<br>こえをふきこむ</p>
        `
        this.timerTarget.textContent = `0:00:00`

        this.recorder = null;
        this.stream = null;
    }
}
