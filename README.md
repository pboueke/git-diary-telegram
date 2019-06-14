# Git-diary telegram bot

Bot for the [git-diary](https://github.com/pboueke/git-diary) project.

## Getting Started

Setup you bot name and telegram bot token at `config/config.ex`

Then run at your shell:

```sh
λ mix deps.get
λ mix
```

## Help

```
Hi! You are talking with the git-diary bot. It is part of the [git-diary](https://github.com/pboueke/git-diary) project.

To start using the bot you must first have an instance of the 
[git-diary-api](https://github.com/pboueke/git-diary-api) running. Then, execute
the /register command to initialize the bot for your user.

Below are the available commands and their parameters.

/register <api-url> <api-token>
    * Configures the bot for your user to use the <api-url> endpoint with the
     provided <token>

/posts <date>
    * Returns the list of available posts. Use the optional <date> parameter to
     filter the results by date, in the format YYYY-MM-DD. For example, /posts 
     2019-06 will return all posts from june 2019

/new <title> \\n <body>
    * Creates a new post with <title> and <body>. Note that there must be a break
     line between <title> and <body>. Returns the git url of the new post.
```

## Credits

[Elixir Telegram Bot Boilerplate](https://github.com/lubien/elixir-telegram-bot-boilerplate)

## License

[MIT](LICENSE.md)
