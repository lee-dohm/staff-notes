type MaybeHTMLTextAreaElement = HTMLTextAreaElement | null

/**
 * An `UIEvent` that is raised by a `FileReader` object.
 */
interface FileReaderEvent extends UIEvent {
  target: FileReader
}

/**
 * An `UIEvent` that is raised by an `XMLHttpRequest` object.
 */
interface XMLHttpRequestEvent extends UIEvent {
  target: XMLHttpRequest
}

/**
 * Callback to add styles indicating that the element can accept dropped data when hovering over it.
 */
function addDragHover(event: DragEvent): void {
  if (imageDropElement) {
    imageDropElement.classList.add('is-drag-hover')
  }
}

/**
 * Convert an `ArrayBuffer` to a base64-encoded `String`.
 */
function arrayBufferToBase64(buffer: ArrayBuffer): string {
  let binary = ''
  const bytes = new Uint8Array(buffer)
  const len = bytes.byteLength

  for (let i = 0; i < len; i++) {
    binary += String.fromCharCode(bytes[i])
  }

  return window.btoa(binary)
}

/**
 * Callback for when files are dropped in the target element.
 */
async function drop(event: DragEvent): Promise<void> {
  event.preventDefault()

  const submitButton = document.querySelector('.form-actions button[type="submit"]')

  if (submitButton) {
    submitButton.setAttribute('disabled', 'disabled')

    if (event.dataTransfer) {
      await uploadFiles(event.dataTransfer.files)
    }

    submitButton.removeAttribute('disabled')
  }
}

/**
 * Inserts placeholder text into the `HTMLTextAreaElement` while the file is uploading.
 */
function insertPlaceholder(el: HTMLTextAreaElement, filename: string): void {
  const pos = el.selectionStart > el.selectionEnd ? el.selectionStart : el.selectionEnd
  const oldText = el.value
  const newText = oldText.substring(0, pos) + `![Uploading ${filename}...]()` + oldText.substring(pos)

  el.value = newText
}

/**
 * Callback to remove drop styles from the target element.
 */
function removeDragHover(event: Event): void {
  if (imageDropElement) {
    imageDropElement.classList.remove('is-drag-hover')
  }
}

/**
 * Reads a `File` and returns an `ArrayBuffer` of the contents as binary data.
 */
function readFile(file: File): Promise<ArrayBuffer> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader()

    reader.onload = (e: FileReaderEvent) => {
      if (e.target.error) {
        reject(e.target.error)
      } else {
        resolve(e.target.result)
      }
    }

    reader.readAsArrayBuffer(file)
  })
}

/**
 * Replaces the previously inserted placeholder image links in the `HTMLTextAreaElement`.
 */
function replacePlaceholder(el: HTMLTextAreaElement, filename: string, url: string): void {
  const oldText = el.value
  const fileroot = filename.replace(/\.[^/.]+$/, '')
  const newText = oldText.replace(`![Uploading ${filename}...]()`, `![${fileroot}](${url})`)

  el.value = newText
}

/**
 * Executes an `XMLHttpRequest` to send the given `json` to the `url` via the `method`.
 *
 * Returns a `Promise` that resolves with the response text or rejects with the exception on errors.
 */
function request(method: string, url: string, json: string): Promise<string> {
  return new Promise((resolve, reject) => {
    const xhr = new XMLHttpRequest()

    xhr.open(method, url)

    xhr.setRequestHeader('Content-type', 'application/json; charset=utf-8')
    xhr.onload = (e: XMLHttpRequestEvent) => resolve(e.target.responseText)
    xhr.onerror = (e) => reject(e)

    xhr.send(json)
  })
}

/**
 * Uploads the given `File` asynchronously.
 *
 * Returns a `Promise` that resolves to the URL where the file can be downloaded from.
 */
async function uploadFile(file: File): Promise<string> {
  const buffer = await readFile(file)
  const base64 = arrayBufferToBase64(buffer)
  const apiTokenElement = document.querySelector('meta[name="api-access-token"]') as HTMLMetaElement

  const token = apiTokenElement ? apiTokenElement.content : null
  const payload = {base64, mimeType: file.type, token}

  const json = await request('POST', '/api/images', JSON.stringify(payload))
  const response = JSON.parse(json)

  return response.url
}

/**
 * Uploads the dropped files.
 *
 * Returns a `Promise` that resolves when all uploads are complete.
 */
function uploadFiles(files: FileList): Promise<void[]> {
  const promises = []

  if (imageDropElement) {
    for (const file of files as any as File[]) {
      insertPlaceholder(imageDropElement, file.name)

      const promise = uploadFile(file).then((url) => {
        replacePlaceholder(imageDropElement, file.name, url)
      })

      promises.push(promise)
    }
  }

  return Promise.all(promises)
}

const imageDropElement = document.querySelector('.image-drop') as MaybeHTMLTextAreaElement

if (imageDropElement) {
  imageDropElement.addEventListener('dragenter', addDragHover)
  imageDropElement.addEventListener('dragleave', removeDragHover)
  imageDropElement.addEventListener('drop', drop)
}
