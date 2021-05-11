defmodule VirtualOffice.Communication.IndividualConversation do
  @derive {Jason.Encoder, only: [:id, :recipient_user, :messages]}
  defstruct id: "", recipient_user: :nil, messages: []

  alias VirtualOffice.Communication.IndividualConversation
  alias VirtualOffice.Communication.Conversation

  def new(individual_conversation = %Conversation{}, current_user_id) do

    recipient_user = case individual_conversation.individual_user_id1 == current_user_id do
      true ->  individual_conversation.user2
      false -> individual_conversation.user1
    end

    %IndividualConversation{id: individual_conversation.id, recipient_user: recipient_user, messages: individual_conversation.messages }
  end
end
