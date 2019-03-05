class NasaOpenAPI

  def initialize(sol,camera = false)
    @host = 'https://api.nasa.gov'
    @uri = '/mars-photos/api/v1/rovers/curiosity/photos'
    @api_key = 'sgdkgDRtALYdJXguVZgY0dMjmDsHUPVjRbVsxJqp'


    @sol = 0
    @camera = camera

    @camera_options = [
        {'id'=>'FHAZ','name'=>'Front Hazard Avoidance Camera'},
        {'id'=>'RHAZ','name'=>'Rear Hazard Avoidance Camera'},
        {'id'=>'MAST','name'=>'Mast Camera'},
        {'id'=>'CHEMCAM','name'=>'Chemistry and Camera Complex'},
        {'id'=>'MAHLI','name'=>'Mars Hand Lens Imager'},
        {'id'=>'MARDI','name'=>'Mars Descent Imager'},
        {'id'=>'NAVCAM','name'=>'Navigation Camera'},
        {'id'=>'PANCAM','name'=>'Panoramic Camera'},
        {'id'=>'MINITES','name'=>'Miniature Thermal Emission Spectrometer (Mini-TES)'},
    ]


  end

  def load_info

    options = [@host,@uri,'?sol=',@sol,'&api_key=',@api_key]
    if @camera
      options.push("&camera=#{@camera}")
    end
    request = options.join()

    cache_key = 'lookup-'+Digest::MD5.hexdigest(request)
    if !response = Rails.cache.read(cache_key)
      response = _api_call(request)
      Rails.cache.write(cache_key, response, expires_in: 24.hours)
    end

    response

  end


  private

  def _api_call(url)

    #authentication to access the API
    begin
      response = HTTParty.get(url)
    rescue HTTParty::Error => e
      Rails.logger.error('HttParty::Error '+ e.message)
      Rails.logger.error('URL: '+url.to_s)
      response = false
    rescue StandardError => e
      Rails.logger.error('StandardError '+ e.message)
      Rails.logger.error('URL: '+url.to_s)
      response = false
    end

    #if error is found return false
    if response && response.code != 200
      response = false
    end

    return response

  end

end
