defmodule App.Commands.Delete do
    use App.Commander
    import App.Utils
  
    def delete(update) do
      [url, token] = get_user_data(update.message.from.id)
      [_command | params] = String.split(update.message.text, " ")
      date = List.first(params)
      case HTTPoison.get(url <> "/posts", [{:"Authorization", "Token " <> token}]) do
        {:ok, %{status_code: 200, body: body}} ->
          records = elem(Poison.decode(body),1)
          filtered = if date == nil, do: records, else: Enum.filter(records, fn x -> String.starts_with?(x, date) end)
          send_message "Which one?",
            reply_markup: %Model.InlineKeyboardMarkup{
              inline_keyboard: Enum.map(filtered, fn it -> 
                [%{
                  callback_data: "/delete_confirm " <> it,
                  text: "Del: " <> String.replace(String.slice(it,11..-1), "-", " ")
                }]
              end)
            }
  
        {:ok, %{status_code: 401}} ->
          send_message "401: Unauthorized to fetch posts"
  
        {:ok, %{status_code: 404}} ->
          send_message "404: could not locate /posts"
  
        {:error, %{reason: reason}} ->
          send_message "Unknown error"
      end
    end
end
  







