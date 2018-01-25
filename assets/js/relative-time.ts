import timeago from 'timeago.js'

/**
 * Accepts a list of relative time elements and updates their `title` attribute to use the browser's
 * locale-specific date format.
 */
function timestampsToLocale(elements: NodeListOf<Element>): void {
  for (const element of elements as any as Element[]) {
    const title = element.getAttribute('title')
    if (title && title.length > 0) {
      const date = new Date(title)

      element.setAttribute('title', date.toLocaleString())
    }
  }
}

const nodes = document.querySelectorAll('relative-time')
timeago().render(nodes)
timestampsToLocale(nodes)
