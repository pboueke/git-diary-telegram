defmodule App.Utils do
    
    def get_json(filename) do
        with {:ok, body} <- File.read(filename),
             {:ok, json} <- Poison.decode(body), do: {:ok, json}
    end

    def set_json(filename, data) do
        File.write(filename,  Poison.encode!(data), [:binary])
    end

    def set_user_data(data) do
        db = get_json("data.json")
        ndb = Map.put(elem(db,1), data["user"], data)
        set_json("data.json", ndb)
        "Ok, cofigurations overwritten"
    end

end