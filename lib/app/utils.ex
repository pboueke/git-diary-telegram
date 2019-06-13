defmodule App.Utils do
    @filename "data.json"
    
    def get_json(filename) do
        with {:ok, body} <- File.read(filename),
             {:ok, json} <- Poison.decode(body), do: {:ok, json}
    end

    def set_json(filename, data) do
        File.write(filename,  Poison.encode!(data), [:binary])
    end

    def set_user_data(data) do
        db = get_json(@filename)
        ndb =
            try do
                %{db | to_string(data["user"]) => data}
            rescue
                _ -> Map.put(elem(db,1), to_string(data["user"]), data)
            end
        set_json(@filename, ndb)
        "Ok, cofigurations overwritten"
    end

    def get_user_data(id) do
        db = get_json(@filename)
        [elem(db,1)[to_string(id)]["url"], elem(db,1)[to_string(id)]["token"]]
    end

end