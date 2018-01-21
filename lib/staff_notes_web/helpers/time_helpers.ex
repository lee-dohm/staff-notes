defmodule StaffNotesWeb.TimeHelpers do
  @moduledoc """
  View helpers for dealing with timestamps.
  """
  use StaffNotesWeb, :helper

  @doc """
  Uses the [timeago.js module](http://timeago.org/) to format the given timestamp as "[some amount
  of time] ago" such as "three hours ago".

  ## HTML emitted

  It emits an HTML `relative-time` tag of the format:

  ```html
  <relative-time datetime="2018-01-01T12:00:00Z" title="2018-01-01T12:00:00Z">
    2018-01-01T12:00:00Z
  </relative-time>
  ```

  The `relative-time` tag is used by the library to find content to reformat based on the `datetime`
  property. The `title` property is included so that people can hover over the time expression to
  see the exact date and time the event occurred. The content of the `relative-time` tag is there in
  case the viewer has JavaScript disabled in their browser. The content of the tag is replaced
  otherwise by the timeago library.

  ## Time zones

  This function assumes that all timestamps are in UTC.

  ## Examples

  Slime template:

  ```
  = relative_time(~N[2018-01-01 12:00:00])
  ```
  """
  @spec relative_time(NaiveDateTime.t()) :: Phoenix.HTML.safe()
  def relative_time(time) do
    time = format(time)

    content_tag(:"relative-time", time, datetime: time, title: time)
  end

  defp format(time) do
    time
    |> Timex.to_datetime("UTC")
    |> Timex.format!("{ISO:Extended:Z}")
    |> String.replace(~r{\.\d+Z$}, "Z")
  end
end
