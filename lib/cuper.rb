module Cuper

  require 'yaml'
  require 'cuper/dsl'

  class CLI

    def init
      gem_dir = File.dirname(__FILE__)
      wiki_name = "confluence"
    end

    def run
      Dir.glob("**/*.feature") do |filename|
        File.open(filename, "r") do |infile|

          puts "Wikifying #{filename}" 
         
          outfile_name = filename.split(".")[0]
          outfile = File.open("#{outfile_name}.wiki", "w")

          table_header = false
          in_scenario = false
          in_thens = false

          while( line = infile.gets )

            outline = nil

            case line
              
              when /Feature:/
                outline = line.gsub /(Feature:)/, 'h2. {color:blue}*\1*{color}' if line =~ /Feature:/

              when /(Scenario:|Background:)/
                in_scenario = true
                outline = line.gsub /(Scenario:|Background:)/, 'h3. {color:blue}*\1*{color}'

              when /Given\s/
                if in_scenario
                  outline = line.gsub /(Given)\s/, '{color:indigo}*\1*{color} '
                  and_color = "indigo"
                  table_header = false
                end

              when /When\s/
                if in_scenario
                  outline = line.gsub /(When)\s/, '{color:orange}*\1*{color} ' 
                  and_color = "orange"
                  table_header = false
                end
              when /Then\s/
                if in_scenario
                  outline = line.gsub /(Then)\s/, '{color:green}*\1*{color} ' 
                  and_color = "green"
                  table_header = false
                  in_thens = true
                end

              when /And\s/
                if in_scenario
                  outline = line.gsub /(And)\s/, '{color:' + and_color + '}*\1*{color} '
                  table_header = false
                end

              when /@.*/
                tags = line.scan(/@[a-zA-Z0-9_-]*/)
                next

              when /\|.*\|/
                if in_scenario && !table_header
                  outline = line.gsub /\|/, '||' 
                  table_header = true
                end

              else
                if in_scenario && in_thens
                  in_scenario = false
                  in_thens = false
              
                  outline = "\n\t\t{color:grey}#{tags.join(" ")}{color}\n\n" if tags.size > 0
                end
            end  
            
            if outline != nil
              outfile << outline
            else
              outfile << line
            end
          end
          outfile.close
        end
      end
    end
  end
end
