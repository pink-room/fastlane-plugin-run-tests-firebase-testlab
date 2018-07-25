module Fastlane
  module FileHelper
    def self.scrape_bucket_url(test_console_output_file)
      File.open(test_console_output_file).each do |line|
        urlArray = line.scan(/\[(.*)\]/).last
        url = nil
        unless urlArray.nil?
          url = urlArray.first
        end
        next unless !url.nil? and (!url.empty? and url.include?("test-lab-"))
        splitted_url = url.split("/")
        length = splitted_url.length
        return "gs://#{splitted_url[length - 2]}/#{splitted_url[length - 1]}"
      end
    end

    def self.has_failed_tests(test_console_output_file)
      File.open(test_console_output_file).each do |line|
        lineFailed = line.scan(/\| Failed  \|/)

        unless lineFailed.nil?
          unless lineFailed.first.nil?
            print(line)
            return true
          end
        end
      end

      File.open(test_console_output_file).each do |line|
        lineFailed = line.scan(/failed/)

        unless lineFailed.nil?
          unless lineFailed.first.nil?
            print(line)
            return true
          end
        end
      end

      return false
    end

    def self.real_bucket_url(test_console_output_file)
      File.open(test_console_output_file).each do |line|
        urlArray = line.scan(/\[(.*)\]/).last
        url = ""
        unless urlArray.nil?
          url = urlArray.first
        end
        unless !url.nil? and (!url.empty? and url.include?("test-lab-"))
          next
        end
        return url
      end
    end

    def self.test_lab_console_url(test_console_output_file)
      File.open(test_console_output_file).each do |line|
        urlArray = line.scan(/\[(.*)\]/).last
        url = ""
        unless urlArray.nil?
          url = urlArray.first
        end
        unless !url.nil? and (!url.empty? and url.include?("\/testlab\/histories\/"))
          next
        end
        return url
      end
    end

  end
end
