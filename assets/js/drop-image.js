let droppedFiles
const imageDropElement = document.querySelector('.image-drop')
const form = document.getElementById('comment-form')

function addDragHover (event) {
  imageDropElement.classList.add('is-drag-hover')
}

function drop (event) {
  event.preventDefault()

  droppedFiles = event.dataTransfer.files
  console.log('Ready to submit!')
}

function removeDragHover (event) {
  imageDropElement.classList.remove('is-drag-hover')
}

function submitFiles () {
  const xhr = new XMLHttpRequest()

  let formData = new FormData(form)
  for (let file of droppedFiles) {
    formData.append(imageDropElement.name, file)
  }

  xhr.addEventListener('load', (e) => console.log(event.target.responseText))
  xhr.addEventListener('error', (e) => console.error(`Error = ${e}`))

  xhr.open(form.method, form.action)
  xhr.send(formData)
}

imageDropElement.addEventListener('dragenter', addDragHover)
imageDropElement.addEventListener('dragleave', removeDragHover)
imageDropElement.addEventListener('drop', drop)

form.addEventListener('submit', (e) => {
  e.preventDefault()

  submitFiles()
})
