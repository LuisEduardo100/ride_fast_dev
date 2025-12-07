defmodule RideFast.FeedbackTest do
  use RideFast.DataCase

  alias RideFast.Feedback

  describe "ratings" do
    alias RideFast.Feedback.Rating

    import RideFast.FeedbackFixtures

    @invalid_attrs %{comment: nil, score: nil}

    test "list_ratings/0 returns all ratings" do
      rating = rating_fixture()
      assert Feedback.list_ratings() == [rating]
    end

    test "get_rating!/1 returns the rating with given id" do
      rating = rating_fixture()
      assert Feedback.get_rating!(rating.id) == rating
    end

    test "create_rating/1 with valid data creates a rating" do
      valid_attrs = %{comment: "some comment", score: 42}

      assert {:ok, %Rating{} = rating} = Feedback.create_rating(valid_attrs)
      assert rating.comment == "some comment"
      assert rating.score == 42
    end

    test "create_rating/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Feedback.create_rating(@invalid_attrs)
    end

    test "update_rating/2 with valid data updates the rating" do
      rating = rating_fixture()
      update_attrs = %{comment: "some updated comment", score: 43}

      assert {:ok, %Rating{} = rating} = Feedback.update_rating(rating, update_attrs)
      assert rating.comment == "some updated comment"
      assert rating.score == 43
    end

    test "update_rating/2 with invalid data returns error changeset" do
      rating = rating_fixture()
      assert {:error, %Ecto.Changeset{}} = Feedback.update_rating(rating, @invalid_attrs)
      assert rating == Feedback.get_rating!(rating.id)
    end

    test "delete_rating/1 deletes the rating" do
      rating = rating_fixture()
      assert {:ok, %Rating{}} = Feedback.delete_rating(rating)
      assert_raise Ecto.NoResultsError, fn -> Feedback.get_rating!(rating.id) end
    end

    test "change_rating/1 returns a rating changeset" do
      rating = rating_fixture()
      assert %Ecto.Changeset{} = Feedback.change_rating(rating)
    end
  end
end
