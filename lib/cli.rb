require "./config/environment"

class Cli

  def initialize
    @layer = 1
  end

  # main loop for the program
  def call
    IoManager.greeting
    input = format_input
    until input == "quit"
      input = @layer == 1 ? layer_input(input) : "Not Found!"
    end
    IoManager.goodbye
  end

  private

  # get and format user command input
  # return - user input line to indicate the layer
  def format_input
    hash = IoManager.parse_layer_input(@layer)
    @layer = hash[:layer]
    hash[:input]
  end

  # actions defined on the first layer of input,
  # loads in articles or prints help message
  def layer_input(input)
    input = IoManager.global_input_layer(input)
    input == "quit" ? input : format_input
  end

end
