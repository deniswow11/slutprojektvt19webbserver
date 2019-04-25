require "sqlite3"
require "slim"
require "sinatra"
require "byebug"
require "bcrypt"
enable :sessions

get "/" do
    slim(:index)
end

get "/forum" do
    slim(:forum)
end

get "/createpost" do
    slim(:createpost)
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
    if result.length > 0 && BCrypt::Password.new(result.first["Password"]) == params["password"]
       
        name = db.execute("SELECT Username From Users")
        name.each do |row|
            name = row['Username']
        end

        session[:createlogin] = "login"
        session[:username] = name
        redirect("/profile")
    else 
        
        redirect("/login")
    end
end

post "/create" do
    db = SQLite3::Database.new('database/database.db')
    db.results_as_hash = true

    new_name = params["name"]
    new_password = BCrypt::Password.create(params["password"])
    new_username = params["username"]
    new_telephone = params["telephone"]

    session[:username] = new_username
    session[:createlogin] = "login"
    db.execute("INSERT INTO users (Name,Telephone,Username,Password) VALUES(?,?,?,?)", new_name, new_telephone, new_username, new_password)
    redirect("/profile")
end

post "/logout" do
    session[:username] = nil
    redirect("/")
end

post "/createapost" do
    db = SQLite3::Database.new('database/database.db')
    db.results_as_hash = true

    new_thread = params["thread"]
    new_title = params["title"]
    new_message =params["message"]

    db.execute("INSERT INTO forumposts (Title,Message,Thread) VALUES(?,?,?)", new_thread, new_title, new_message)
    db.execute("SELECT forumposts.User_Id, users.Username FROM forumposts INNER JOIN users ON forumposts.User_Id = users.User_Id")
    redirect("/")
end