defmodule App.Commands.Register do
    use App.Commander
    import App.Utils
  
    def register(update) do
        [_command | [url, token]] = String.split(update.message.text, " ")

        send_message set_user_data(%{
            "user" => update.message.from.id,
            "token" => token,
            "url" => url
        } )
    end
  end
  