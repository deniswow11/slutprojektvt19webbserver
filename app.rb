require "sqlite3"
require "slim"
require "sinatra"
require "byebug"
enable :sessions

get "/" do
    slim(:index)
end

get "/register" do
    slim(:register)
end

get "/login" do
    slim(:login)
end

get "/profile" do
    slim(:profile)
end

post "/check" do
    db = SQLite3::Database.new("database/database.db")
    db.results_as_hash = true;

    result = db.execute("SELECT Name, Password FROM users WHERE users.Name=?",params["name"])
    if params["name"] == result.first["Name"]
        if params["password"] == result.first["Password"]
            redirect("/profile")
        else
            redirect("/login")
        end
    else 
        redirect("/login") 
    end
end

post "/create" do
    db = SQLite3::Database.new('database/database.db')
    db.results_as_hash = true

    new_name = params["name"]
    new_password = params["password"]
    new_username = params["username"]
    new_telephone = params["telephone"]

    session[:username] = new_name

    db.execute("INSERT INTO users (Name,Telephone,Username,Password) VALUES(?,?,?,?)", new_name, new_telephone, new_username, new_password)
    redirect("/profile")
end