class WebhooksController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def callback
    if request.content_type == 'application/json'
      payload = params
    else
      payload = JSON.parse params[:payload].to_s
    end
    ParsePayloadService.new(payload).call

    head :ok, content_type: "text/html"
  end
end
