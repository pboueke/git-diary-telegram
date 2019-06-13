defmodule App.Commands.Posts do
    use App.Commander
    import App.Utils
  
    def posts(update) do
        [url, token] = get_user_data(update.message.from.id)
        case HTTPoison.get(url <> "/posts", [{:"Authorization", "Token " <> token}]) do
            {:ok, %{status_code: 200, body: body}} ->
              send_message body
      
            {:ok, %{status_code: 401}} ->
              send_message "401: Unauthorized to fetch posts"
      
            {:ok, %{status_code: 404}} ->
              send_message "404: could not locate /posts"
      
            {:error, %{reason: reason}} ->
              send_message "Unknown error"
          end
    end
end
  







