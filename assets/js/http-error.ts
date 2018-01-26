/// <reference path="./http" />

/**
 * Thrown when a non-2xx response is returned from an HTTP request.
 */
export default class HTTPError extends Error {
  /** Parsed JSON response from the server if it was valid JSON. */
  public parsedResponse: object

  /** Raw text response from the server. */
  public responseText: string

  /** HTTP status code returned from the server. */
  public status: number

  constructor(response: HttpResponse, message?: string) {
    super(message || `Status code ${response.status} was returned by the server`)

    this.status = response.status
    this.responseText = response.responseText

    try {
      this.parsedResponse = JSON.parse(this.responseText)
    } catch (e) {
      // Catch that exception and ignore it
    }
  }
}
