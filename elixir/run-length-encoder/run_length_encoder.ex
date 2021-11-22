defmodule RunLengthEncoder do

  @spec encode(String.t) :: String.t
  def encode(str) do
    Regex.scan(~r/(.)\1*/, str)
    |> Enum.map(&(encode_match/1))
    |> Enum.join
    |> String.graphemes
    |> Enum.reject( fn x -> x == "1" end )
    |> List.to_string
  end

  @spec decode(String.t) :: String.t
  def decode(str) do
    Regex.scan(~r/(\d+)*(\D)/, str)
    |> Enum.map(&decode_match/1)
    |> Enum.join
  end

  def encode_match([str, letter]) do
     "#{String.length(str)}#{letter}"
  end

  def decode_match([_, num, letter]) do
    case num do
      "" -> letter
      _ -> letter |> String.duplicate(num |> String.to_integer)
    end
  end

end
