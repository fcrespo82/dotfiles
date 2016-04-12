#!/usr/bin/ruby

module Bytes

  def to_human(n,fmt=false)
    count = 0
    formats = %w(B KB MB GB TB PB EB ZB YB)

    while  (fmt || n >= 1024) && count < 8
      n /= 1024.0
      count += 1
      break if fmt && formats[count][0].upcase =~ /#{fmt[0].upcase}/
    end

    format("%.2f",n) + formats[count]

  end

  def to_machine s
    yotta_size = 1208925801182629174706176.0
    zetta_size = 1180591620717411303424.0
    exa_size = 1152921504606846976.0
    peta_size =1125899906842624.0
    terra_size =1099511627776.0
    gig_size = 1073741824.0
    meg_size = 1048576.0
    kilo_size = 1024.0

    output = false
    if s =~ /((?:\d+)(?:\.\d+)?)([tgmkpezy])b?/i
      num, type = [$1.to_f, $2.downcase]
      output = case type
      when 'y'
        num * yotta_size
      when 'z'
        num * zetta_size
      when 'e'
        num * exa_size
      when 'p'
        num * peta_size
      when 't'
        num * terra_size
      when 'g'
        num * gig_size
      when 'm'
        num * meg_size
      when 'k'
        num * kilo_size
      else
        num
      end
    end
    return output.to_i
  end

  def convert(input)
    input.gsub!(/(?:^\s*|\()(?:([\d\.,]+)\s*(?:([tgmkpezy])b?|b(?:ytes)?)?\s+(in|to)\s+((k(?:ilo)?|m(?:ega)?|g(?:iga)?|t(?:erra)?|p(?:eta)?|e(?:xa)?|z(?:etta)?|y(?:otta)?)(b(?:ytes)?)?|b(?:ytes)?|(h(?:uman)?|m(?:achine)?))(\)|\s*$)|(^[\d\.,]+$))/i) {|m|

      conversion = false

      match = Regexp.last_match
      if match[9]
        to_human(match[9].to_i)
      elsif match[1] !~ /^[\d\.,]+/
        match.string
      else
        number_string = match[1].gsub(/,/,'')
        if match[2] && match[2].length > 0
          num = to_machine("#{number_string}#{match[2]}")
        else
          num = number_string.to_f
        end

        if match[3] =~ /^in/
          conversion = "human"
          fmt = match[4] ? match[4][0] : false
          to_human(num, fmt)
        elsif match[3] =~ /^to/
          fmt = false
          if match[4] =~ /^m(achine)?/i
            num
          elsif match[4] =~ /^h(uman)?/i
            eval("to_#{match[4].strip.downcase}(#{num})").to_s
          elsif match[4] =~ /^([yzeotgmkb])/i
            fmt = $1
            to_human(num, fmt).to_s
          else
            match.to_s
          end
        else
          if match.to_s =~ /^\s*\d+\s*$/
            to_human(num, false)
          else
            match.to_s
          end
        end
      end
    }
    input
  end

  def exit_help(code=false)
    name = File.basename(__FILE__)
    help =<<-EOF
Usage: #{name} [INT|STRING]
Examples:
  #{name} 289259845
  #{name} 24mb in kb
  #{name} 1995pb to machine
    EOF
    puts help unless code
    exit code ? code : 0
  end

end

include Bytes

piped = false

if STDIN.stat.size > 0
  piped = STDIN.read
  piped = piped.force_encoding('utf-8') if piped.respond_to? "force_encoding"
end

if ARGV.length > 0 && !piped
  input = ARGV.join(' ')
elsif piped
  input = piped
end

Bytes.exit_help unless input && input.length > 0

print Bytes.convert(input)
