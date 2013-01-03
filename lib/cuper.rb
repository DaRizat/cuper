module Cuper

  require 'yaml'
  require 'cuper/dsl'

  class CLI

    include Cuper::DSL

    def init
      gem_dir = File.dirname(__FILE__)
      wiki_name = "confluence"
      @wiki_conf = YAML::load(File.open("#{gem_dir}/../config/#{wiki_name}.yml"))
    end

    def run
      @config = YAML::load(File.open("#{Dir.pwd}/config/cuper.yml"))

      Dir.glob("**/*.feature") do |filename|
        File.open(filename, "r") do |infile|

          puts "Wikifying #{filename}" 
          outfile_name = filename.split("/").last.split(".")[0]
          outfile = File.open("#{@config['output']['dir']}/#{outfile_name}.wiki", "w")

          table_header = false
          in_scenario = false
          step_type = ""

          while( line = infile.gets )

            outline = nil

            case line
              
              when /Feature:/
               outline = feature_for line, @config['feature']

              when /(Scenario:|Background:)/
                in_scenario = true
                outline = scenario_for line, @config['scenario']

              when /Given\s/
                if in_scenario
                  step_type = "given"
                  outline = given_for line, @config['given']
                  table_header = false
                end

              when /When\s/
                if in_scenario
                  step_type = "when"
                  outline = when_for line, @config['when']
                  table_header = false
                end

              when /Then\s/
                if in_scenario
                  step_type = "then"
                  outline = then_for line, @config['then']
                  table_header = false
                end

              when /And\s/
                if in_scenario
                  outline = and_for line, @config[step_type]
                  table_header = false
                end

              when /@.*/
                tags = line.scan(/@[a-zA-Z0-9_-]*/)
                next

              when /\|.*\|/
                if in_scenario && !table_header
                  #outline = line.gsub /\|/, '||' 
                  outline = table_for line, @config['table_head']
                  table_header = true
                end

              else
                if in_scenario && step_type == "then"
                  in_scenario = false
                  outline = "#{tags_for(tags.join(" "), @config['tag'])}\n\n" if tags.size > 0
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
