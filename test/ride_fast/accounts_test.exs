defmodule RideFast.AccountsTest do
  use RideFast.DataCase

  alias RideFast.Accounts

  describe "users" do
    alias RideFast.Accounts.User

    import RideFast.AccountsFixtures

    @invalid_attrs %{name: nil, role: nil, email: nil, password_hash: nil, phone: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{name: "some name", role: "some role", email: "some email", password_hash: "some password_hash", phone: "some phone"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.name == "some name"
      assert user.role == "some role"
      assert user.email == "some email"
      assert user.password_hash == "some password_hash"
      assert user.phone == "some phone"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{name: "some updated name", role: "some updated role", email: "some updated email", password_hash: "some updated password_hash", phone: "some updated phone"}

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.name == "some updated name"
      assert user.role == "some updated role"
      assert user.email == "some updated email"
      assert user.password_hash == "some updated password_hash"
      assert user.phone == "some updated phone"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "drivers" do
    alias RideFast.Accounts.Driver

    import RideFast.AccountsFixtures

    @invalid_attrs %{name: nil, status: nil, email: nil, phone: nil, password_hash: nil}

    test "list_drivers/0 returns all drivers" do
      driver = driver_fixture()
      assert Accounts.list_drivers() == [driver]
    end

    test "get_driver!/1 returns the driver with given id" do
      driver = driver_fixture()
      assert Accounts.get_driver!(driver.id) == driver
    end

    test "create_driver/1 with valid data creates a driver" do
      valid_attrs = %{name: "some name", status: "some status", email: "some email", phone: "some phone", password_hash: "some password_hash"}

      assert {:ok, %Driver{} = driver} = Accounts.create_driver(valid_attrs)
      assert driver.name == "some name"
      assert driver.status == "some status"
      assert driver.email == "some email"
      assert driver.phone == "some phone"
      assert driver.password_hash == "some password_hash"
    end

    test "create_driver/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_driver(@invalid_attrs)
    end

    test "update_driver/2 with valid data updates the driver" do
      driver = driver_fixture()
      update_attrs = %{name: "some updated name", status: "some updated status", email: "some updated email", phone: "some updated phone", password_hash: "some updated password_hash"}

      assert {:ok, %Driver{} = driver} = Accounts.update_driver(driver, update_attrs)
      assert driver.name == "some updated name"
      assert driver.status == "some updated status"
      assert driver.email == "some updated email"
      assert driver.phone == "some updated phone"
      assert driver.password_hash == "some updated password_hash"
    end

    test "update_driver/2 with invalid data returns error changeset" do
      driver = driver_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_driver(driver, @invalid_attrs)
      assert driver == Accounts.get_driver!(driver.id)
    end

    test "delete_driver/1 deletes the driver" do
      driver = driver_fixture()
      assert {:ok, %Driver{}} = Accounts.delete_driver(driver)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_driver!(driver.id) end
    end

    test "change_driver/1 returns a driver changeset" do
      driver = driver_fixture()
      assert %Ecto.Changeset{} = Accounts.change_driver(driver)
    end
  end

  describe "driver_profiles" do
    alias RideFast.Accounts.DriverProfile

    import RideFast.AccountsFixtures

    @invalid_attrs %{license_number: nil, license_expiry: nil, background_check_ok: nil}

    test "list_driver_profiles/0 returns all driver_profiles" do
      driver_profile = driver_profile_fixture()
      assert Accounts.list_driver_profiles() == [driver_profile]
    end

    test "get_driver_profile!/1 returns the driver_profile with given id" do
      driver_profile = driver_profile_fixture()
      assert Accounts.get_driver_profile!(driver_profile.id) == driver_profile
    end

    test "create_driver_profile/1 with valid data creates a driver_profile" do
      valid_attrs = %{license_number: "some license_number", license_expiry: ~D[2025-12-06], background_check_ok: true}

      assert {:ok, %DriverProfile{} = driver_profile} = Accounts.create_driver_profile(valid_attrs)
      assert driver_profile.license_number == "some license_number"
      assert driver_profile.license_expiry == ~D[2025-12-06]
      assert driver_profile.background_check_ok == true
    end

    test "create_driver_profile/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_driver_profile(@invalid_attrs)
    end

    test "update_driver_profile/2 with valid data updates the driver_profile" do
      driver_profile = driver_profile_fixture()
      update_attrs = %{license_number: "some updated license_number", license_expiry: ~D[2025-12-07], background_check_ok: false}

      assert {:ok, %DriverProfile{} = driver_profile} = Accounts.update_driver_profile(driver_profile, update_attrs)
      assert driver_profile.license_number == "some updated license_number"
      assert driver_profile.license_expiry == ~D[2025-12-07]
      assert driver_profile.background_check_ok == false
    end

    test "update_driver_profile/2 with invalid data returns error changeset" do
      driver_profile = driver_profile_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_driver_profile(driver_profile, @invalid_attrs)
      assert driver_profile == Accounts.get_driver_profile!(driver_profile.id)
    end

    test "delete_driver_profile/1 deletes the driver_profile" do
      driver_profile = driver_profile_fixture()
      assert {:ok, %DriverProfile{}} = Accounts.delete_driver_profile(driver_profile)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_driver_profile!(driver_profile.id) end
    end

    test "change_driver_profile/1 returns a driver_profile changeset" do
      driver_profile = driver_profile_fixture()
      assert %Ecto.Changeset{} = Accounts.change_driver_profile(driver_profile)
    end
  end
end
