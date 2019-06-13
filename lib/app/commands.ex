defmodule App.Commands do
  use App.Router
  use App.Commander
  import App.Utils

  alias App.Commands.Register
  alias App.Commands.Posts

  command ["register"], Register, :register

  command ["posts"], Posts, :posts

  callback_query_command "get" do
    [url, token] = get_user_data(update.message.from.id)
    [_command, name] = String.split(update.callback_query.data, " ")
    case HTTPoison.get(url <> "/posts/" <> name, [{:"Authorization", "Token " <> token}]) do
      {:ok, %{status_code: 200, body: body}} ->
        send_message body

      {:ok, %{status_code: 401}} ->
        send_message "401: Unauthorized to fetch a post"

      {:ok, %{status_code: 404}} ->
        send_message "404: could not locate /posts/" <> name

      {:error, %{reason: reason}} ->
        send_message "Unknown error"
    end
  end


  command "question" do
    Logger.log :info, "Command /question"

    {:ok, _} = send_message "What's the best JoJo?",
      # Nadia.Model is aliased from App.Commander
      #
      # See also: https://hexdocs.pm/nadia/Nadia.Model.InlineKeyboardMarkup.html
      reply_markup: %Model.InlineKeyboardMarkup{
        inline_keyboard: [
          [
            %{
              callback_data: "/choose joseph",
              text: "Joseph Joestar",
            },
            %{
              callback_data: "/choose joseph-of-course",
              text: "Joseph Joestar of course",
            },
          ],
          [
            # Read about fallbacks in the end of the file
            %{
              callback_data: "/typo-:p",
              text: "Other",
            },
          ]
        ]
      }
  end

  # You can create command interfaces for callback querys using this macro.
  callback_query_command "choose" do
    Logger.log :info, "Callback Query Command /choose"

    case update.callback_query.data do
      "/choose joseph" ->
        answer_callback_query text: "Indeed you have good taste."
      "/choose joseph-of-course" ->
        answer_callback_query text: "I can't agree more."
    end
  end

  # You may also want make commands when in inline mode.
  # Be sure to enable inline mode first: https://core.telegram.org/bots/inline
  # Try by typping "@your_bot_name /what-is something"
  inline_query_command "what-is" do
    Logger.log :info, "Inline Query Command /what-is"

    :ok = answer_inline_query [
      %InlineQueryResult.Article{
        id: "1",
        title: "10 Hours What is Love Jim Carrey HD",
        thumb_url: "https://img.youtube.com/vi/ER97mPHhgtM/3.jpg",
        description: "Have a great time",
        input_message_content: %{
          message_text: "https://www.youtube.com/watch?v=ER97mPHhgtM",
        }
      }
    ]
  end

  # You can emulate argument access through nadia's update.message
  command "argued" do
    Logger.log :info, "Command /argued"
    
    [_command | args] = String.split(update.message.text, " ") 
    send_message ("Your arguments were: " <> Enum.join(args, " "))
  end

  # Advanced Stuff
  #
  # Now that you already know basically how this boilerplate works let me
  # introduce you to a cool feature that happens under the hood.
  #
  # If you are used to telegram bot API, you should know that there's more
  # than one path to fetch the current message chat ID so you could answer it.
  # With that in mind and backed upon the neat macro system and the cool
  # pattern matching of Elixir, this boilerplate automatically detectes whether
  # the current message is a `inline_query`, `callback_query` or a plain chat
  # `message` and handles the current case of the Nadia method you're trying to
  # use.
  #
  # If you search for `defmacro send_message` at App.Commander, you'll see an
  # example of what I'm talking about. It just works! It basically means:
  # When you are with a callback query message, when you use `send_message` it
  # will know exatcly where to find it's chat ID. Same goes for the other kinds.

  inline_query_command "foo" do
    Logger.log :info, "Inline Query Command /foo"
    # Where do you think the message will go for?
    # If you answered that it goes to the user private chat with this bot,
    # you're right. Since inline querys can't receive nothing other than
    # Nadia.InlineQueryResult models. Telegram bot API could be tricky.
    send_message "This came from an inline query"
  end

  # Fallbacks

  # Rescues any unmatched callback query.
  callback_query do
    Logger.log :warn, "Did not match any callback query"

    answer_callback_query text: "Sorry, but there is no JoJo better than Joseph."
  end

  # Rescues any unmatched inline query.
  inline_query do
    Logger.log :warn, "Did not match any inline query"

    :ok = answer_inline_query [
      %InlineQueryResult.Article{
        id: "1",
        title: "Darude-Sandstorm Non non Biyori Renge Miyauchi Cover 1 Hour",
        thumb_url: "https://img.youtube.com/vi/yZi89iQ11eM/3.jpg",
        description: "Did you mean Darude Sandstorm?",
        input_message_content: %{
          message_text: "https://www.youtube.com/watch?v=yZi89iQ11eM",
        }
      }
    ]
  end

  # The `message` macro must come at the end since it matches anything.
  # You may use it as a fallback.
  message do
    Logger.log :warn, "Did not match the message"

    send_message "Sorry, I couldn't understand you"
  end
end
