defmodule App.Commands do
  use App.Router
  use App.Commander
  import App.Utils

  alias App.Commands.Register
  alias App.Commands.Posts
  alias App.Commands.New
  alias App.Commands.Get
  alias App.Commands.Edit
  alias App.Commands.Delete
  alias App.Commands.DeleteConfirm
  alias App.Commands.DeletePost
  alias App.Commands.Help

  command ["register"], Register, :register

  command ["posts", "ls", "list"], Posts, :posts

  callback_query_command "get", Get, :get

  callback_query_command "edit", Edit, :edit

  command ["delete", "del"], Delete, :delete

  callback_query_command "delete_confirm", DeleteConfirm, :deleteConfirm

  callback_query_command "delete_post", DeletePost, :deletePost

  command ["new"], New, :new

  command ["help", "hi", "hello", "Help", "Hi", "Hello"], Help, :help

  callback_query "nil" do end
 
  callback_query do
    Logger.log :warn, "Did not match any callback query"

    answer_callback_query text: "Sorry, I couldn't understand you"
  end

  message do
    Logger.log :warn, "Did not match the message"

    send_message "Sorry, I couldn't understand you"
  end
end
