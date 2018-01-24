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
  console.log('Ready to submit!')
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

// Executes an XMLHttpRequest given the parameters and returns a Promise

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
 * Uploads the given file asynchronously.
 */
function uploadFile (file) {
  readFile(file).then((buffer) => {
    const base64 = arrayBufferToBase64(buffer)
    const payload = {base64: base64, mimeType: file.type}

    request('POST', '/api/images', JSON.stringify(payload)).then((json) => {
      const response = JSON.parse(json)

      console.log(`Received upload response: ${response.url}`)
    })
  })
}

/**
 * Uploads the dropped files.
 */
function uploadFiles () {
  // TODO: Disable form to prevent multiple submissions

  for (let file of droppedFiles) {
    uploadFile(file)
  }

  // TODO: Enable form to allow more form interaction
}

imageDropElement.addEventListener('dragenter', addDragHover)
imageDropElement.addEventListener('dragleave', removeDragHover)
imageDropElement.addEventListener('drop', drop)

form.addEventListener('submit', (e) => {
  e.preventDefault()

  uploadFiles()
})
