defmodule AffineCipher do
  @typedoc """
  A type for the encryption key
  """
  @type key() :: %{a: integer, b: integer}

  @group_length 5

  @alphabet_length 26


  @doc """
  Encode an encrypted message using a key
  """
  @spec encode(key :: key(), message :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def encode(%{a: a, b: b}, message) do
    with {:ok, _mmi} <- find_mmi(a, @alphabet_length) do
      encoded =
        message
        |> String.downcase()
        |> String.replace(~r/\W/, "")
        |> String.to_charlist()
        |> Enum.map(fn c ->
          cond do
            c in ?a..?z -> rem(a * (c - ?a) + b, @alphabet_length) + ?a
            true -> c
          end
        end)
        |> List.to_string()
        |> String.graphemes()
        |> Enum.chunk_every(@group_length)
        |> Enum.map(&to_string/1)
        |> Enum.join(" ")
      {:ok, encoded}
    else
      nil -> {:error, "a and m must be coprime."}
    end
  end


  @doc """
  Decode an encrypted message using a key
  """
  @spec decode(key :: key(), message :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def decode(%{a: a, b: b}, encrypted) do
    with {:ok, mmi} <- find_mmi(a, @alphabet_length) do
      decoded =
        encrypted
        |> String.downcase()
        |> String.replace(~r/\W/, "")
        |> String.to_charlist()
        |> Enum.map(fn c ->
          cond do
            c in ?a..?z -> Integer.mod(mmi * ((c - ?a) - b), @alphabet_length) + ?a
            true -> c
          end
        end)
        |> List.to_string()
      {:ok, decoded}
    else
      nil -> {:error, "a and m must be coprime."}
    end
  end

  defp find_mmi(a, m) do
    x = Enum.find(1..m, nil, fn n -> rem(a * n, m) == 1 end)
    if is_nil(x), do: nil, else: {:ok, x}
  end

end
