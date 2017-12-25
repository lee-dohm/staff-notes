defmodule StaffNotes do
  @moduledoc """
  Staff Notes is an application that keeps track of these things:

  * Accounts
      * Organizations
          * An organization has many users
      * Teams
          * A team belongs to an organization
          * A team can have many users
      * Users &mdash; the staff of an organization
          * A user can be on many teams
          * A user authors many notes
  * Records
      * Members &mdash; the members of the organization the staff notes are about
          * Members belong to an organization
          * A member has many notes
          * A member has many identities
      * Notes &mdash; the notes about the members
          * A note belongs to a member
          * A note was authored by a user
          * Notes may include text, images or other files
      * Identities &mdash; information identifying a member on a service
          * An identity belongs to a member

  Because the Internet is a strange and fluid place, members may have different names on different
  platforms. For example, a member may be named "foo" on GitHub but named "bar" on the message
  board. These are a single member but need all their different known identities coalesced into one
  record. Because an individual may be tracked for a time as two separate members and eventually be
  identified as a single member, there must be a way to merge member records.
  """
end
