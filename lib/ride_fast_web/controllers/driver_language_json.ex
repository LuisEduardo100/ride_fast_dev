defmodule RideFastWeb.DriverLanguageJSON do
  def index(%{languages: languages}) do
    %{data: for(lang <- languages, do: %{id: lang.id, code: lang.code, name: lang.name})}
  end
end
