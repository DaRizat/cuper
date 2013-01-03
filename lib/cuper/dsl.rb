module Cuper
  module DSL

    def feature_for line, opts
      line.gsub(/(\s*|\t*)Feature:/, '\1' + modify_in_order("Feature:", opts))
    end

    def scenario_for line, opts
      text = /Scenario:|Background:/.match(line).to_s
      line.gsub(/(\s+|\t+)Scenario:|Background:/, '\1' + modify_in_order(text, opts))
    end

    def given_for line, opts
      line.gsub(/(\s+|\t+)Given/, '\1' + modify_in_order("Given", opts))
    end

    def when_for line, opts
      line.gsub(/(\s+|\t+)When/, '\1' + modify_in_order("When", opts))
    end

    def then_for line, opts
      line.gsub(/(\s+|\t+)Then/, '\1' + modify_in_order("Then", opts))
    end

    def and_for line, opts
      line.gsub(/(\s+|\t+)And/, '\1' + modify_in_order("And", opts))
    end

    def tags_for line, opts
      modify_in_order line, opts
    end

    def table_for line, opts

    end

    private
    def modify_in_order text, opts

      puts opts.to_s

      if opts['strong'] || opts['bold']
        text = bold text
      end
      puts "#{text}!"

      if opts['emphasis'] || opts['italic']
        text = emphasis text
      end
      puts "#{text}!"

      if opts['color']
        text = color opts['color'], text
      end
      puts "#{text}!"
      
      if opts['heading']
        text = "#{eval(opts['heading'])} #{text}"
      end
      puts "#{text}!"

      text
    end

    def color color, text
      opt = @wiki_conf['color'].gsub(/<%color%>/, color)
      replace_text opt, text 
    end

    def strong text
      puts "Fortune favors the strong #{@wiki_conf['strong']}"
      replace_text @wiki_conf['strong'], text
    end

    def bold text
      strong text
    end

    def emphasis text
      replace_text @wiki_conf['emphasis'], text
    end

    def italic text
      emphasis text
    end

    def h1 
      @wiki_conf['header_1']
    end

    def h2
      @wiki_conf['header_2']
    end

    def h3
      @wiki_conf['header_3']
    end

    def th text
      replace_text @wiki_conf['table_head'], text
    end

    def cite text
      replace_text @wiki_conf['cite'], text
    end

    def strike text
      replace_text @wiki_conf['deleted'], text
    end

    def insert text
      replace_text @wiki_conf['inserted'], text
    end
    
    def super text
      replace_text @wiki_conf['superscript'], text
    end

    def sub text
      replace_text @wiki_conf['subscript'], text
    end

    def mono text
      replace_text @wiki_conf['monospaced'], text
    end

    def list level
      ret = ""
      level.times do
        ret += @wiki_conf['list']
      end
      ret
    end

    def bullet level
      ret = ""
      level.times do
        ret += @wiki_conf['bullet']
      end
      ret
    end

    def numlist level
      ret = ""
      level.times do
        ret += @wiki_conf['numbered_list']
      end
      ret
    end

    def replace_text conf, text
      conf.gsub(/<%text%>/, text)
    end
  end
end
