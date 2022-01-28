defmodule BankAccount do
  use GenServer

  @opaque account :: pid

  ### Client Side Functions ###

  @spec open_bank() :: account
  def open_bank() do
    {:ok, account} = GenServer.start_link(__MODULE__, 0, [])
    account
  end

  @spec close_bank(atom | pid | {atom, any} | {:via, atom, any} | BankAccount.account()) :: :ok
  def close_bank(account) do
    GenServer.cast(account, :close)
  end

  @spec balance(account) :: integer
  def balance(account) do
    GenServer.call(account, :balance)
  end

  @spec update(account, integer) :: any
  def update(account, amount) do
    GenServer.call(account, {:update, amount})
  end

  
  ### Server Side Functions ###

  def init(balance) do
    {:ok, balance}
  end

  def handle_cast(:close, _state) do
    {:noreply, :closed}
  end

  def handle_call(_, _from, :closed) do
    {:reply, {:error, :account_closed}, :closed}
  end

  def handle_call(:balance, _from, balance) do
    {:reply, balance, balance}
  end

  def handle_call({:update, amount}, _from, balance) do
    {:reply, :ok, balance + amount}
  end
end
