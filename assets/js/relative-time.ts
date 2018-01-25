import timeago from 'timeago.js'

function timestampsToLocale(nodes: NodeListOf<Element>): void {
  for (let node of <Element[]><any>nodes) {
    let title = node.getAttribute('title')
    if (title && title.length > 0) {
      let date = new Date(title)

      node.setAttribute('title', date.toLocaleString())
    }
  }
}

let nodes = document.querySelectorAll('relative-time')
timeago().render(nodes)
timestampsToLocale(nodes)
