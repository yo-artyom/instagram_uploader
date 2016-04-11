module InstagramUploader
  module PhotoUploader

      def upload_photo(image)
        url = 'https://instagram.com/api/v1/media/upload/'
        device_timestamp = Time.now.to_i.to_s

        data = [
          Curl::PostField.file('photo', image),
          Curl::PostField.content('device_timestamp', device_timestamp)
        ]
        response = upload_request(url, data)

        response['status'] != 'ok' ? (raise Error, response['message']) : response
      end

      private

      def upload_request(url, data)
        http = Curl::Easy.new(url)

        http.headers["User-Agent"] = generate_user_agent
        http.multipart_form_post = true
        http.verbose = true
        http.follow_location = true
        http.enable_cookies = true

        http.cookiefile = @cookie

        http.send('post', data)
        response = JSON.parse(http.body)
        http.close

        response
      end

  end
end
