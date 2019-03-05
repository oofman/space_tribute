class HomeController < ApplicationController
  skip_before_action :authenticate, only: [:index]

  def index
    require('nasa_open_api')
    api = NasaOpenAPI.new(1000)
    result = api.load_info

    @parsed = result.parsed_response['photos']
    Rails.logger.info("INFO: #{@parsed} ")

  end

  def dashboard

  end
end
