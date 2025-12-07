defimpl Jason.Encoder, for: Decimal do
  def encode(value, opts) do
    # Passo 1: Transforma o Decimal em String do Elixir ("25.0")
    str_value = Decimal.to_string(value)

    # Passo 2: Usa o codificador de String nativo do Jason
    Jason.Encoder.BitString.encode(str_value, opts)
  end
end
