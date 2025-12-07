defmodule RideFast.DataTest do
  use RideFast.DataCase

  alias RideFast.Data

  describe "languages" do
    alias RideFast.Data.Language

    import RideFast.DataFixtures

    @invalid_attrs %{code: nil, name: nil}

    test "list_languages/0 returns all languages" do
      language = language_fixture()
      assert Data.list_languages() == [language]
    end

    test "get_language!/1 returns the language with given id" do
      language = language_fixture()
      assert Data.get_language!(language.id) == language
    end

    test "create_language/1 with valid data creates a language" do
      valid_attrs = %{code: "some code", name: "some name"}

      assert {:ok, %Language{} = language} = Data.create_language(valid_attrs)
      assert language.code == "some code"
      assert language.name == "some name"
    end

    test "create_language/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_language(@invalid_attrs)
    end

    test "update_language/2 with valid data updates the language" do
      language = language_fixture()
      update_attrs = %{code: "some updated code", name: "some updated name"}

      assert {:ok, %Language{} = language} = Data.update_language(language, update_attrs)
      assert language.code == "some updated code"
      assert language.name == "some updated name"
    end

    test "update_language/2 with invalid data returns error changeset" do
      language = language_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.update_language(language, @invalid_attrs)
      assert language == Data.get_language!(language.id)
    end

    test "delete_language/1 deletes the language" do
      language = language_fixture()
      assert {:ok, %Language{}} = Data.delete_language(language)
      assert_raise Ecto.NoResultsError, fn -> Data.get_language!(language.id) end
    end

    test "change_language/1 returns a language changeset" do
      language = language_fixture()
      assert %Ecto.Changeset{} = Data.change_language(language)
    end
  end
end
