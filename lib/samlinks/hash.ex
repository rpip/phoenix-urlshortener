defmodule Samlinks.Hash do
  @hash_length 8

  def generate do
    code =
      :crypto.strong_rand_bytes(@hash_length)
      |> Base.url_encode64
      |> binary_part(0, @hash_length)

    Regex.replace(~r/[_-]/, code, "")
  end
end
