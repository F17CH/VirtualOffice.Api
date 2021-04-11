defmodule VirtualOffice.InstantMessage.Message do
  @derive {Jason.Encoder, only: [:id, :user_id, :content]}
  defstruct id: 0, user_id: 0, content: ""

  alias VirtualOffice.InstantMessage.Message, as: Message

  def new(message_id, user_id, content) do
    %Message{id: message_id, user_id: user_id, content: content}
  end
end
