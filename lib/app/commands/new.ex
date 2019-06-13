defmodule App.Commands.New do
    use App.Commander
    import App.Utils
  
    def new(update) do
        [_command | words] = String.split(update.message.text, " ")
        [title | phrases] = String.split(Enum.join(words, " "),"\n")
        body = Enum.join(phrases,"\n")

        IO.puts Poison.encode!(%{"title" => title, "body" => body})
                          
        [url, token] = get_user_data(update.message.from.id)
        case HTTPoison.put(url <> "/post/new", 
                          Poison.encode!(%{"title" => title, "body" => body}),
                          [{:"Authorization", "Token " <> token},
                          {:"Content-Type", "application/json"}]) do
          {:ok, %{status_code: 200, body: body}} ->
            send_message body
    
          {:ok, %{status_code: 401}} ->
            send_message "401: Unauthorized to fetch posts"
    
          {:ok, %{status_code: 404}} ->
            send_message "404: could not locate /posts"
    
          {:error, %{reason: reason}} ->
            send_message "Unknown error"
        end

        send_message Enum.join([title, body], "\n"), [{:parse_mode, "Markdown" }]

    end
  end
  