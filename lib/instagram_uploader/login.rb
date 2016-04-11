module InstagramUploader
  module Login
    def login
      url = 'https://instagram.com/api/v1/accounts/login/'

      data = "{'username':'#{@username}','password':'#{@password}','guid':'#{generate_guid}','device_id':'#{generate_device_id}','Content-Type':'application/x-www-form-urlencoded; charset=UTF-8'}".gsub("'", '"')
      signature = generate_signature(data)
      body = 'ig_sig_key_version=4&signed_body=' + signature + '.' + URI::encode(data, /\W/)

      response = login_request(url, body)
      raise Error, response['message'] if response['status'] != 'ok'
    end

    private

    def login_request(url,data)
      http = Curl::Easy.new(url)
      http.headers["User-Agent"] = generate_user_agent
      http.verbose = true
      http.follow_location = true
      http.enable_cookies = true
      http.cookiejar = @cookie
      http.send('post', data)
      response = JSON.parse(http.body)
      http.close
      response
    end
  end
end
