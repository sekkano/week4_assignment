require "sinatra/base"
require "sqlite3"

class LinksApp < Sinatra::Base
  CONNECTION = SQLite3::Database.new("favorite_links.sqlite3")

  # Create the database
  CONNECTION.execute <<-SQL
    CREATE TABLE IF NOT EXISTS "links" (
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "name" VARCHAR,
      "url" VARCHAR,
      "description" VARCHAR  
    )
  SQL

  get "/" do
    @title = "Links"
    results = CONNECTION.execute("SELECT id, name, url, description FROM links ORDER BY id DESC LIMIT 10")
    
    @tablerows = results.collect do |row|
      "<tr><td><a href=\"http://localhost:9292/links/#{row[0]}\">#{row[1]}</td><td>#{row[2]}</td><td>#{row[3]}</td></tr>"
    end
    erb :index
  end

  get "/links/:id" do
    id = params[:id]
    results = CONNECTION.execute("SELECT name, url, description FROM links WHERE id=#{id}")
    
    @tablerows = results.collect do |row|
      "<tr><td>#{row[0]}</td><td>#{row[1]}</td><td>#{row[2]}</td></tr>"
    end
    
    erb :links_display
  end

  get "/links" do
    results = CONNECTION.execute("SELECT id, name, url, description FROM links ORDER BY id DESC")
    
    @tablerows = results.collect do |row|
      "<tr><td>#{row[1]}</td><td>#{row[2]}</td><td>#{row[3]}</td></tr>"
    end
    erb :links 
  end



  post "/links" do
    name = params[:name]
    url = params[:url]
    description = params[:description]
    
    CONNECTION.execute("INSERT INTO links (name, url, description) VALUES (?, ?, ?)", [name, url, description])
    
    redirect "/links"
  end
end