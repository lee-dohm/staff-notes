let droppedFiles
const imageDropElement = document.querySelector('.image-drop')
const form = document.getElementById('comment-form')

/**
 * Callback to add styles indicating that the element can accept dropped data when hovering over it.
 */
function addDragHover (event) {
  imageDropElement.classList.add('is-drag-hover')
}

/**
 * Convert an `ArrayBuffer` to a base64-encoded `String`.
 */
function arrayBufferToBase64 (buffer) {
  let binary = '';
  let bytes = new Uint8Array(buffer);
  let len = bytes.byteLength;

  for (let i = 0; i < len; i++) {
    binary += String.fromCharCode(bytes[i]);
  }

  return window.btoa(binary);
}

/**
 * Callback for when files are dropped in the target element.
 */
function drop (event) {
  event.preventDefault()

  droppedFiles = event.dataTransfer.files
  uploadFiles()
}

/**
 * Inserts placeholder text into the `HTMLTextAreaElement` while the file is uploading.
 */
function insertPlaceholder (el, filename) {
  let pos = el.selectionStart > el.selectionEnd ? el.selectionStart : el.selectionEnd
  let oldText = el.value
  let newText = oldText.substring(0, pos) + `![Uploading ${filename}...]()` + oldText.substring(pos)

  el.value = newText
}

/**
 * Callback to remove drop styles from the target element.
 */
function removeDragHover (event) {
  imageDropElement.classList.remove('is-drag-hover')
}

/**
 * Reads a `File` and returns an `ArrayBuffer` of the contents as binary data.
 */
function readFile (file) {
  return new Promise((resolve, reject) => {
    const reader = new FileReader()

    reader.onload = (e) => {
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
function replacePlaceholder (el, filename, url) {
  let oldText = el.value
  let fileroot = filename.replace(/\.[^/.]+$/, "")
  let newText = oldText.replace(`![Uploading ${filename}...]()`, `![${fileroot}](${url})`)

  el.value = newText
}

/**
 * Executes an `XMLHttpRequest` to send the given `json` to the `url` via the `method`.
 *
 * Returns a `Promise` that resolves with the response text or rejects with the exception on errors.
 */
function request (method, url, json) {
  return new Promise((resolve, reject) => {
    const xhr = new XMLHttpRequest()

    xhr.open(method, url)

    xhr.setRequestHeader('Content-type', 'application/json; charset=utf-8')
    xhr.onload = (e) => resolve(e.target.responseText)
    xhr.onerror = (e) => reject(e)

    xhr.send(json)
  })
}

/**
 * Uploads the given `File` asynchronously.
 */
async function uploadFile (file) {
  const buffer = await readFile(file)
  const base64 = arrayBufferToBase64(buffer)
  const payload = {base64: base64, mimeType: file.type}

  const json = await request('POST', '/api/images', JSON.stringify(payload))
  const response = JSON.parse(json)
  console.log(`Received upload response: ${response.url}`)

  replacePlaceholder(imageDropElement, file.name, response.url)
}

/**
 * Uploads the dropped files.
 */
function uploadFiles () {
  for (let file of droppedFiles) {
    insertPlaceholder(imageDropElement, file.name)
    uploadFile(file)
  }
}

if (imageDropElement) {
  imageDropElement.addEventListener('dragenter', addDragHover)
  imageDropElement.addEventListener('dragleave', removeDragHover)
  imageDropElement.addEventListener('drop', drop)
}
