
defmodule App.Commands.Edit do
    use App.Commander
    import App.Utils
  
    def edit(update) do
        [url, token] = get_user_data(update.callback_query.from.id)
        [_command, name] = String.split(update.callback_query.data, " ")
        case HTTPoison.get(url <> "/post/" <> get_post_uri(name) <> "/link", [{:"Authorization", "Token " <> token}]) do
          {:ok, %{status_code: 200, body: body}} ->
            {_,[link]} = Poison.decode(body)
            send_message "Edit: [" <> name <> "](" <> link <> ")",
            [{:parse_mode, "Markdown" }]
    
          {:ok, %{status_code: 401}} ->
            send_message "401: Unauthorized to fetch a post"
    
          {:ok, %{status_code: 404}} ->
            send_message "404: could not locate /posts/" <> name
    
          {:error, %{reason: reason}} ->
            send_message "Unknown error"
        end
    end
end
  




