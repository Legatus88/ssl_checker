class Api::V1::SslCheckerController < ApplicationController
  def status
    render json: { domains: Domain.pluck(:url, :aasm_state) }
  end

  def add_domain
    new_domain = Domain.new(url: domain_params[:url])
    if new_domain.save
      CheckSslJob.new.perform
    else
      render json: new_domain.errors.messages
    end
  end

  private

  def domain_params
    params.permit(:url)
  end
end
