defmodule App.Commands.New do
    use App.Commander
    import App.Utils
  
    def new(update) do
        [_command | words] = String.split(update.message.text, " ")
        [title | phrases] = String.split(Enum.join(words, " "),"\n")
        body = Enum.join(phrases,"\n")
                          
        [url, token] = get_user_data(update.message.from.id)
        case HTTPoison.put(url <> "/post/new", 
                          Poison.encode!(%{"title" => title, "body" => body}),
                          [{:"Authorization", "Token " <> token},
                          {:"Content-Type", "application/json"}],
                          [{:recv_timeout, 50000}]) do
          {:ok, %{status_code: 200, body: body}} ->
            send_message List.first(Poison.decode!(body))
    
          {:ok, %{status_code: 401}} ->
            send_message "401: Unauthorized to fetch posts"
    
          {:ok, %{status_code: 404}} ->
            send_message "404: could not locate /posts"
    
          {:error, %{reason: reason}} ->
            IO.inspect reason
            send_message "Unknown error"
        end
    end
  end
  