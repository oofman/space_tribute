class HomeController < ApplicationController
  skip_before_action :authenticate, only: [:index]

  def index

  end

  def dashboard

  end
end
