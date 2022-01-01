#!usr/bin/env ruby
require 'net/http'
require 'mechanize'
require 'open-uri'
require 'socket'
require 'colorize'


def help
    puts "\rARB commands:"
    puts "headers      => returns the headers of a site"
    puts "site         => parse an user target (website)"
    puts "fingerprint  => capture the html body of a site"
    puts "linkshunt    => view the correlated links in a site"
    puts "portchecker  => check the open port on a target ip"
    puts "xml-version  => show the xml version of a site"
    puts "fuzzer       => do the directory fuzzing in a site"
    puts "-r           => reset & clear display"
    puts "help         => help you :kek:\r"
end

def logo
    banner = '''
                  ___
 ▄▀█ █▀█ █▄▄     / | \
 █▀█ █▀▄ █▄█    |--0--|
                 \_|_/        By LoJacopS
'''.cyan[..-5]
    print banner
    puts "v1.7.3"
    puts "\n"
    print Time.now
    puts "\n"
end
print logo
puts "Welcome to arb!"

prompt = "\rArb>".green[..-5]

while (input = gets.chomp)
break if input == "exit"
    print prompt && input
    if input == "headers"
        Thread.new{
            begin
                puts "\rTarget:"
                sessoinput = gets.chomp
                urii = URI("#{sessoinput}")
                response = Net::HTTP.get_response(urii) 
                response.to_hash['set-cookie']                      #get the sexy headers
                puts "Headers:\n #{response.to_hash.inspect}"
            rescue Errno::ENOENT, Errno::ECONNREFUSED
                puts "\rselect a valid target! (example https://pornhub.com)".red
            end
        }.join
    end
    if input == "site"
        puts "\rSelect a valid target:"
        class Spidercute
            def target
                begin
                    url_target = gets.chomp
                    if url_target == nil
                        puts "Not a valid target"
                        return
                    end
                    body = Nokogiri::HTML(open(url_target))
                    puts "\rHere the site informations:\n"
                    urll = URI("#{url_target}")
                    respone = Net::HTTP.get_response(urll) 
                    respone.to_hash['set-cookie']    
                    print respone.to_hash.inspect
                    puts "\nhtml body:"
                    puts respone.body

                    inline = body.xpath('//script[not(@src)]')
                    inline.each do |script|
                        puts "-"*50, script.text
                    end
                rescue Errno::ENOENT, Errno::ECONNREFUSED
                    puts "\rselect a valid target! (example https://pornhub.com)".red
                end
            end
        end
        Thread.new{
            crawling = Spidercute.new
            crawling.target do |output|
                print output
                puts "\n"
            end
        }.join
    end
    if input == "fingerprint"
        begin
            puts "\rinsert a site target:"
            html_code = gets.chomp
            puts "\rhere the html code\n"
            capture = open(html_code)
            work = Nokogiri::HTML(capture)  #sorry for the variables, but to make it work, just the function is not enough
            print work
        rescue Errno::ENOENT, Errno::ECONNREFUSED
            puts "\rselect a valid target! (example https://pornhub.com)".red
        end
    end
    if input == "linkshunt"
        def owo
            Thread.new{
                amogus = Mechanize.new
                puts "\rinsert a link:"
                url = gets.chomp
                puts "\rtarget selected: #{url}"
                amogus.get(url).links.each do |link|
                    puts "correlated links at #{url} = #{link.uri}"
                end
            }.join
        end
        print owo
    end
    if input == "portchecker"
        puts "\rtype an ip to check the ports open on:"
        puts "(example: www.google.com)"
        def scan_port
            port_input = gets.chomp
            ports = [15,21,22,25,26,80,110,143,200,443,587,
                    993,995,1000,2077,2078,2082,2083,2086,      #most used ports
                    2087,2095,2096,3080,3306
                ]
            for numbers in ports
                socket = Socket.new(:INET, :STREAM)
                remote_addr = Socket.sockaddr_in(numbers, port_input)
                begin
                    socket.connect_nonblock(remote_addr)
                rescue Errno::EINPROGRESS
                end
                time = 1
                sockets = Socket.select(nil, [socket], nil, time)
                if sockets
                    puts "\rPort #{numbers} is open"
                else
                    puts "\rPort #{numbers} is closed"
                end
            end
        end
        print scan_port
    end
    if input == "xml-version"
        def xml_v
            begin
                puts "\nsite with xml:"
                version = gets.chomp
                e = open(version)
                puts "\rHere the xml version:"
                Nokogiri::XML(e)
            rescue Errno::ENOENT, Errno::ECONNREFUSED
                puts "\rselect a valid target! (example https://google.com)".red
            end
        end
        print xml_v
    end
    if input == "fuzzer"
        def fuzzer
            begin
                Thread.new{
                    puts "\rlink: "
                    fuzz_option = gets.chomp
                    puts "\rselect a wordlist:"
                    wordlist_option = gets.chomp
                    print wordlist_option
                    wordlist = File.open(wordlist_option)
                    ohyes = wordlist.map {|x| x.chomp }
                    ohyes.each do |dir|
                        uriiii = URI("#{fuzz_option}/#{dir}/")
                        requestt = Net::HTTP.get_response(uriiii)
                        print requestt.code
                        if requestt.code == '200'
                            puts "\rdirectory open! '#{dir}'"
                            log = File.new("Valid-dir.log", 'a')
                            log.write(dir+"\n")
                            log.close
                            puts "saved on file Valid-dir.log!"
                        elsif requestt.code == '404'
                            puts "\nscanning..."                       #directory closed
                        end
                    end
                }.join
            rescue Errno::ENOENT, Errno::ECONNREFUSED
                puts "\rERROR: Select a valid wordlist".red
            rescue Net::OpenTimeout
                puts "\rERROR: Select a valid link".red
            end
        end
        print fuzzer
    end
    if input == "-r"
        system('clear')
        puts "Resetted!".yellow
        puts "\n"
    end
    if input == "help"
        print help
    elsif input == "banner"
        print logo
        commands = ['headers', 'site', '-r', 'help', 'linkshunt','fingerprint','portchecker',"fuzzer"]
    else input != commands
        puts "\r"
    end
system(input)
print prompt
end
