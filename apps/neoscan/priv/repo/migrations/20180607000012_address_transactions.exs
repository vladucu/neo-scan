defmodule Neoscan.Repo.Migrations.AddressTransactions do
  use Ecto.Migration

  def change do
    create table(:address_transactions, primary_key: false) do
      add(:address_hash, :binary, primary_key: true)
      add(:transaction_hash, :binary, primary_key: true)
      add(:block_time,  :naive_datetime, null: false)
      timestamps()
    end

    create(index(:address_transactions, [:address_hash, :block_time]))
  end
end
