defmodule Spell.Serializer.JSON do
  @behaviour Spell.Serializer
  alias Spell.Message

  # Serializer Callbacks

  def transport_info(Spell.Transport.WebSocket) do
    %{name: "json", frame_type: :text}
  end
  def transport_info(Spell.Transport.RawSocket) do
    %{name: "json", serializer_id: 1}
  end

  def decode(string) do
    case Poison.Parser.parse(string) do
      {:ok, [code | args]} ->
        {:ok, Message.new!(code: code, args: args)}
      {:ok, _other} ->
        {:error, :bad_message}
      {:error, reason} ->
        {:error, reason}
    end
  end

  def encode(%Message{} = message) do
    Poison.encode(message)
  end

end

defimpl Poison.Encoder, for: Spell.Message do
  alias Spell.Message

  def encode(%Message{code: code, args: args}, options) do
    Poison.Encoder.encode([code | args], options)
  end
end
