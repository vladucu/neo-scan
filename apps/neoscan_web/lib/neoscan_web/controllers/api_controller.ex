defmodule NeoscanWeb.ApiController do
  use NeoscanWeb, :controller

  alias NeoscanWeb.Api

  defmacro cache(key, value, ttl \\ 10_000) do
    quote do
      ConCache.get_or_store(:my_cache, unquote(key), fn ->
        %ConCache.Item{value: unquote(value), ttl: unquote(ttl)}
      end)
    end
  end

  # used by neon-js
  def get_balance(conn, %{"hash" => hash}) do
    balance = cache({:get_balance, hash}, Api.get_balance(hash))
    json(conn, balance)
  end

  # used by neon-js
  def get_last_transactions_by_address(conn, %{"hash" => hash} = params) do
    page = if is_nil(params["page"]), do: 1, else: String.to_integer(params["page"])

    transactions =
      cache(
        {:get_last_transactions_by_address, hash, page},
        Api.get_last_transactions_by_address(hash, page)
      )

    json(conn, transactions)
  end

  # used by neon-js
  def get_all_nodes(conn, %{}) do
    nodes = cache({:get_all_nodes}, Api.get_all_nodes())
    json(conn, nodes)
  end

  # used by neon-js
  def get_unclaimed(conn, %{"hash" => hash}) do
    unclaimed = cache({:get_unclaimed, hash}, Api.get_unclaimed(hash))
    json(conn, unclaimed)
  end

  # used by neon-js
  def get_claimable(conn, %{"hash" => hash}) do
    claimable = cache({:get_claimable, hash}, Api.get_claimable(hash))
    json(conn, claimable)
  end

  # used by neon-js
  def get_height(conn, %{}) do
    height = cache({:get_height}, Api.get_height())
    json(conn, height)
  end

  # used by neon-js 3.7.0 (deprecated)
  def get_address_neon(conn, %{"hash" => hash}) do
    address = cache({:get_address_neon, hash}, Api.get_address_neon(hash))
    json(conn, address)
  end

  # used by NEX
  def get_address_abstracts(conn, %{"hash" => hash, "page" => page}) do
    abstracts = cache({:get_address_abstracts, hash, page}, Api.get_address_abstracts(hash, page))
    json(conn, abstracts)
  end

  # used by NEX
  def get_address_to_address_abstracts(conn, %{"hash1" => hash1, "hash2" => hash2, "page" => page}) do
    abstracts =
      cache(
        {:get_address_to_address_abstracts, hash1, hash2, page},
        Api.get_address_to_address_abstracts(hash1, hash2, page)
      )

    json(conn, abstracts)
  end

  # for future use
  def get_claimed(conn, %{"hash" => hash}) do
    claimed = cache({:get_claimed, hash}, Api.get_claimed(parse_index_or_hash(hash)))
    json(conn, claimed)
  end

  # for future use
  def get_block(conn, %{"hash" => hash}) do
    hash = parse_index_or_hash(hash)
    block = cache({:get_block, hash}, Api.get_block(hash))
    json(conn, block)
  end

  # for future use
  def get_transaction(conn, %{"hash" => hash}) do
    hash = parse_index_or_hash(hash)
    transaction = cache({:get_transaction, hash}, Api.get_transaction(hash))
    json(conn, transaction)
  end

  defp parse_index_or_hash(value) do
    case Integer.parse(value) do
      {integer, ""} ->
        integer

      _ ->
        Base.decode16!(value, case: :mixed)
    end
  end
end
