module Cuper
  module DSL

    def color_tag color, text
      replace_text @config[:color], text
    end

    def strong text
      bold text
    end

    def bold text
      replace_text @config[:strong], text
    end

    def italic text
      emphasis text
    end

    def emphasis text
      replace_text @config[:emphasis], text
    end

    def h1 
      @config[:header_1]
    end

    def h2
      @config[:header_2]
    end

    def h3
      @config[:header_3]
    end

    def th text
      replace_text @config[:table_head], text
    end

    def cite text

      replace_text @config[:cite], text
    end

    def strike text
      replace_text @config[:deleted], text
    end

    def insert text
      replace_text @config[:inserted], text
    end
    
    def super text
      replace_text @config[:superscript], text
    end

    def sub text
      replace_text @config[:subscript], text
    end

    def mono text
      replace_text @config[:monospaced], text
    end

    def list level
      ret = ""
      level.times.do
        ret += @config[:list]
      end
      ret
    end

    def bullet level
      ret = ""
      level.times.do
        ret += @config[:bullet]
      end
      ret
    end

    def numlist level
      ret = ""
      level.times.do
        ret += @config[:numbered_list]
      end
      ret
    end

    def replace_text text, conf
      conf.gsub(/<%.*%>/, text)
    end

  end
end
