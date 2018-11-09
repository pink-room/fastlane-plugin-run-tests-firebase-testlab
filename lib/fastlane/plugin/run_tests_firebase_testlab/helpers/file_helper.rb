module Fastlane
  module FileHelper
    def self.scrape_bucket_url(test_console_output_file)
      File.open(test_console_output_file).each do |line|
        url_array = line.scan(/\[(.*)\]/).last
        url = nil
        unless url_array.nil?
          url = url_array.first
        end
        next unless !url.nil? and (!url.empty? and url.include?("test-lab-"))
        splitted_url = url.split("/")
        length = splitted_url.length
        return "gs://#{splitted_url[length - 2]}/#{splitted_url[length - 1]}"
      end
    end

    def self.has_failed_tests(test_console_output_file)
      File.open(test_console_output_file).each do |line|
        line_failed = line.scan(/\| Failed  \|/)

        if !line_failed.nil? && !line_failed.first.nil?
          print(line)
          return true
        end
      end

      File.open(test_console_output_file).each do |line|
        line_failed = line.scan(/failed/)

        if !line_failed.nil? && !line_failed.first.nil?
            print(line)
            return true
        end
      end

      return false
    end

    def self.real_bucket_url(test_console_output_file)
      File.open(test_console_output_file).each do |line|
        url_array = line.scan(/\[(.*)\]/).last
        url = ""
        unless url_array.nil?
          url = url_array.first
        end
        unless !url.nil? and (!url.empty? and url.include?("test-lab-"))
          next
        end
        return url
      end
    end

    def self.test_lab_console_url(test_console_output_file)
      File.open(test_console_output_file).each do |line|
        url_array = line.scan(/\[(.*)\]/).last
        url = ""
        unless url_array.nil?
          url = url_array.first
        end
        unless !url.nil? and (!url.empty? and url.include?("\/testlab\/histories\/"))
          next
        end
        return url
      end
    end

  end
end
