module InstagramUploader
  module PhotoCommit
    require "openssl"
    
    def commit_photo(media_id, desc)
      url = 'https://instagram.com/api/v1/media/configure/'

      device_timestamp = Time.now.to_i.to_s
      data = "{'guid':'#{@guid}','device_id':'#{@device_id}','device_timestamp':'#{device_timestamp}','media_id':'#{media_id}','caption': '#{desc}','source_type':'5','filter_type':'0','extra':'{}','Content-Type':'application/x-www-form-urlencoded; charset=UTF-8'}".gsub("'", '"')
      signature = generate_signature(data)
      body = 'ig_sig_key_version=4&signed_body=' + signature + '.' + URI::encode(data, /\W/)

      response = commit_request(url, body)
       if response['status'] != 'ok'
         raise Error, response['message']
       else
         response
       end
    end

    private

    def commit_request(url, data)
      http = Curl::Easy.new(url)

      http.headers["User-Agent"] = generate_user_agent
      http.verbose = true
      http.follow_location = true
      http.enable_cookies = true

      http.cookiefile = @cookie

      http.send('post', data)
      response = JSON.parse(http.body)
      http.close

      response
    end

    def generate_guid
      guid = sprintf('%04x%04x-%04x-%04x-%04x-%04x%04x%04x',
        rand(0..65535),
        rand(0..65535),
        rand(0..65535),
        rand(16384..20479),
        rand(32768..49151),
        rand(0..65535),
        rand(0..65535),
        rand(0..65535))
    end

    def generate_device_id
      guid = generate_guid
      "android-#{guid}"
    end

    def generate_signature(data)
      return OpenSSL::HMAC.hexdigest('sha256', 'b4a23f5e39b5929e0666ac5de94c89d1618a2916', data)
    end

    def generate_user_agent
      resolution = ['720x1280', '320x480', '480x800', '1024x768', '1280x720', '768x1024', '480x320'].sample
      version = ['GT-N7000', 'SM-N9000', 'GT-I9220', 'GT-I9100'].sample
      dpi = ['120', '160', '320', '240'].sample

      'Instagram 4.' + rand(1..2).to_s + '.' + rand(0..2).to_s + ' Android (' + rand(10..11).to_s + '/' + rand(1..3).to_s + '.' + rand(3..5).to_s + '.' + rand(0..5).to_s + "; #{dpi}; #{resolution}; samsung; #{version }; #{version}; smdkc210; ru_RU)"
    end
  end
end
