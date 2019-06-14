defmodule App.Commands.DeleteConfirm do
    use App.Commander
    import App.Utils
  
    def deleteConfirm(update) do
        [_command, name] = String.split(update.callback_query.data, " ")
        send_message "Delete " <> name <> ". Are you sure?",
        [{:reply_markup, %Model.InlineKeyboardMarkup{
            inline_keyboard: [
              [%{
                callback_data: "/delete_post " <> name,
                text: "Yes"
              },
              %{
                callback_data: "/nil ",
                text: "No"
              }]]
          }}, {:parse_mode, "Markdown" }]
    end
end