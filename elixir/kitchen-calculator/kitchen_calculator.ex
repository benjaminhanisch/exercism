defmodule KitchenCalculator do
  def get_volume(volume_pair) do
    elem(volume_pair, 1)
    # {unit, volume} = volume_pair
    # volume
  end

  def to_milliliter(volume_pair) do
    case volume_pair do
      {:cup, volume} -> {:milliliter, volume * 240}
      {:fluid_ounce, volume} -> {:milliliter, volume * 30}
      {:teaspoon, volume} -> {:milliliter, volume * 5}
      {:tablespoon, volume} -> {:milliliter, volume * 15}
      {:milliliter, volume} -> {:milliliter, volume}
    end
  end

  def from_milliliter(volume_pair, :milliliter), do: volume_pair
  def from_milliliter(volume_pair, :cup), do: {:cup, get_volume(volume_pair) / 240}
  def from_milliliter(volume_pair, :fluid_ounce), do: {:fluid_ounce, get_volume(volume_pair) / 30}
  def from_milliliter(volume_pair, :teaspoon), do: {:teaspoon, get_volume(volume_pair) / 5}
  def from_milliliter(volume_pair, :tablespoon), do: {:tablespoon, get_volume(volume_pair) / 15}

  def convert(volume_pair, unit) do
    volume_pair
    |> to_milliliter()
    |> from_milliliter(unit)
  end
end
