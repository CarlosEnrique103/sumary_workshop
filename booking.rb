require_relative "dbmanager"
class Booking
  MENU = {
    "top" => {
      title: "Top publishers by Annual Revenue",
      description: "Top publishers by anul revenue",
      method: "top_publishers"
    },
    "search" => {
      title: "Search books",
      description: "Search books by [title=string  | author=string | publisher=string]",
      method: "search"
    },
    "count" => {
      title: "Count Books",
      description: "Count books by [author | publisher | genre]"
      method: "count"
    }
  }.freeze

  def initialize
    @dbmanager = DBManager.new
  end
  
  def start
    print_welcome
    print_menu
    while(line = Readline.readline("> ", true))
      action, parameter = line.split(' ',2)
      case action
        when "menu" then print_menu
        when "exit" then exit(1)
        else run_query(action, parameter)
        end   
      end
    end
  end

  def run_query(action, parameter)
    if MENU.key? action
      method = MENU[:action][:method]
      params = parameter ? [method, parameter] : method;
      #MENU[:action][:method] # "TOP_PUBLISHERS"
      res = @dbmanager.send(parameter)
      puts Terminal::Table.new(title: MENU[:action][:title], headings: res.fields, rows: res.values)
      # if parameter.nil?
      #   @dbmanager.send(MENU[:action][:method])
      # else
      #   @dbmanager.send(MENU[:action][:method], parameter)
      # end
      puts "Llamar al metodo #{action} y pasarl el parametro #{parameter}"
    else
      puts "Invalid option"
    end
  end

  def print_welcome
    puts "Welcome to booking"
    puts "Write 'menu' as any moment to print"
  end
  def print_welcome
    puts "_____________"
    puts "1.- Top 5 publisher"
    puts "2.- Search books by [title=string | author=string | publisher=string]"
    puts "3.- Search books by [title=]"
    puts "_____________"
  end
end