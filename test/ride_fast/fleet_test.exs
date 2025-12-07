defmodule RideFast.FleetTest do
  use RideFast.DataCase

  alias RideFast.Fleet

  describe "vehicles" do
    alias RideFast.Fleet.Vehicle

    import RideFast.FleetFixtures

    @invalid_attrs %{driver_id: nil, color: nil, plate: nil, model: nil}

    test "list_vehicles/0 returns all vehicles" do
      vehicle = vehicle_fixture()
      assert Fleet.list_vehicles() == [vehicle]
    end

    test "get_vehicle!/1 returns the vehicle with given id" do
      vehicle = vehicle_fixture()
      assert Fleet.get_vehicle!(vehicle.id) == vehicle
    end

    test "create_vehicle/1 with valid data creates a vehicle" do
      valid_attrs = %{driver_id: 42, color: "some color", plate: "some plate", model: "some model"}

      assert {:ok, %Vehicle{} = vehicle} = Fleet.create_vehicle(valid_attrs)
      assert vehicle.driver_id == 42
      assert vehicle.color == "some color"
      assert vehicle.plate == "some plate"
      assert vehicle.model == "some model"
    end

    test "create_vehicle/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Fleet.create_vehicle(@invalid_attrs)
    end

    test "update_vehicle/2 with valid data updates the vehicle" do
      vehicle = vehicle_fixture()
      update_attrs = %{driver_id: 43, color: "some updated color", plate: "some updated plate", model: "some updated model"}

      assert {:ok, %Vehicle{} = vehicle} = Fleet.update_vehicle(vehicle, update_attrs)
      assert vehicle.driver_id == 43
      assert vehicle.color == "some updated color"
      assert vehicle.plate == "some updated plate"
      assert vehicle.model == "some updated model"
    end

    test "update_vehicle/2 with invalid data returns error changeset" do
      vehicle = vehicle_fixture()
      assert {:error, %Ecto.Changeset{}} = Fleet.update_vehicle(vehicle, @invalid_attrs)
      assert vehicle == Fleet.get_vehicle!(vehicle.id)
    end

    test "delete_vehicle/1 deletes the vehicle" do
      vehicle = vehicle_fixture()
      assert {:ok, %Vehicle{}} = Fleet.delete_vehicle(vehicle)
      assert_raise Ecto.NoResultsError, fn -> Fleet.get_vehicle!(vehicle.id) end
    end

    test "change_vehicle/1 returns a vehicle changeset" do
      vehicle = vehicle_fixture()
      assert %Ecto.Changeset{} = Fleet.change_vehicle(vehicle)
    end
  end

  describe "vehicles" do
    alias RideFast.Fleet.Vehicle

    import RideFast.FleetFixtures

    @invalid_attrs %{active: nil, color: nil, plate: nil, model: nil, seats: nil}

    test "list_vehicles/0 returns all vehicles" do
      vehicle = vehicle_fixture()
      assert Fleet.list_vehicles() == [vehicle]
    end

    test "get_vehicle!/1 returns the vehicle with given id" do
      vehicle = vehicle_fixture()
      assert Fleet.get_vehicle!(vehicle.id) == vehicle
    end

    test "create_vehicle/1 with valid data creates a vehicle" do
      valid_attrs = %{active: true, color: "some color", plate: "some plate", model: "some model", seats: 42}

      assert {:ok, %Vehicle{} = vehicle} = Fleet.create_vehicle(valid_attrs)
      assert vehicle.active == true
      assert vehicle.color == "some color"
      assert vehicle.plate == "some plate"
      assert vehicle.model == "some model"
      assert vehicle.seats == 42
    end

    test "create_vehicle/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Fleet.create_vehicle(@invalid_attrs)
    end

    test "update_vehicle/2 with valid data updates the vehicle" do
      vehicle = vehicle_fixture()
      update_attrs = %{active: false, color: "some updated color", plate: "some updated plate", model: "some updated model", seats: 43}

      assert {:ok, %Vehicle{} = vehicle} = Fleet.update_vehicle(vehicle, update_attrs)
      assert vehicle.active == false
      assert vehicle.color == "some updated color"
      assert vehicle.plate == "some updated plate"
      assert vehicle.model == "some updated model"
      assert vehicle.seats == 43
    end

    test "update_vehicle/2 with invalid data returns error changeset" do
      vehicle = vehicle_fixture()
      assert {:error, %Ecto.Changeset{}} = Fleet.update_vehicle(vehicle, @invalid_attrs)
      assert vehicle == Fleet.get_vehicle!(vehicle.id)
    end

    test "delete_vehicle/1 deletes the vehicle" do
      vehicle = vehicle_fixture()
      assert {:ok, %Vehicle{}} = Fleet.delete_vehicle(vehicle)
      assert_raise Ecto.NoResultsError, fn -> Fleet.get_vehicle!(vehicle.id) end
    end

    test "change_vehicle/1 returns a vehicle changeset" do
      vehicle = vehicle_fixture()
      assert %Ecto.Changeset{} = Fleet.change_vehicle(vehicle)
    end
  end
end
