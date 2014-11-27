#Author : Vicellaneous

#Require Gems
require 'open-uri';
require 'fileutils';
require 'openSSL';
require 'json';
require 'uri';
system("cls");
system("clear");
puts "Processing. . ."
class VicelTube
	def Download(uri)
		downloadURL = Parse(uri);
		youtubeHTML = open(downloadURL, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}).read;
		json_string = youtubeHTML.scan(/ytplayer\.config = (.*?);ytplayer.load/)[0][0];
		root = JSON.parse(json_string);
		information = [["Title","title"],["Thumb", "thumbnail_url"],["Keywords", "keywords"],["URL", "loaderUrl"],["View","view_count"],["Length Seconds","length_seconds"],["Rating Average","avg_rating"],["Author","author"]];
		stream_map = root["args"]["url_encoded_fmt_stream_map"].split(/,/);
		maps = Array.new;

		stream_map.each { |map|
			maps.push(map.split(/&/));
		}

		system("cls");
		system("clear");
		
		information.each { |info|
			puts info[0] + " : " + root["args"][info[1]];
		}
		puts "\n";
		index = 1;
		maps.each { |cont|
			puts index;
			cont.each { |conts|
				if (conts.start_with?("type="))
					puts "Type : " + URI.unescape(conts.gsub("type=",""));
					
				elsif (conts.start_with?("quality="))
					puts "Quality : " + conts.gsub("quality=","").capitalize;
					
				end
			}
			index += 1;
			puts "\n";
		}

		print "File mana yang ingin kamu download? ";
		dl_index=gets.chomp;
		maps[dl_index.to_i-1].each { |cid|
			if(cid.start_with?('url='))
				puts URI.unescape(cid.gsub("url=",""));
			end
		}
	end

	def Parse(uri)
		return "https://www.youtube.com/watch?" + uri.match(/(\?|&)v=(.*)(&|)/).to_s.gsub(/(\?|&)v/,'v');
	end
end
