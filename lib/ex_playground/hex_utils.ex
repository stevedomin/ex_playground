defmodule ExPlayground.HexUtils do
  # thanks @alco
  # https://gist.github.com/alco/11196658
  def bin_to_hex(data) do
    for <<hi::4, lo::4 <- data>>,
      into: <<>>,
      do:   <<hex_digit(hi), hex_digit(lo)>>
  end

  defp hex_digit(n) when n < 10, do: n + ?0
  defp hex_digit(n), do: n-10 + ?a
end
