class CheckSslJob < ApplicationJob
  queue_as :default

  def perform
    Domain.all.each do |domain|
      resp = get_resp(domain)
      if resp.nil?
        change_to_fail_if_possible(domain)
        next
      end

      cert = resp.peer_cert

      case cert.not_after
      when 7.days.from_now..14.days.from_now
        change_to_fail_if_possible(domain)
      when 1.day.from_now..6.days.from_now
        change_to_fail_if_possible(domain)
      when proc { |n| n < Time.current }
        change_to_fail_if_possible(domain)
      else
        change_to_pass_if_possible(domain)
      end
    end
  end

  private

  def change_to_fail_if_possible(domain)
    domain.fail! if domain.may_fail?
  end

  def change_to_pass_if_possible(domain)
    domain.pass! if domain.may_pass?
  end

  def get_resp(domain)
    uri = URI::HTTPS.build(host: domain.url)

    begin
      resp = Net::HTTP.start(uri.host, uri.port, use_ssl: true)
    rescue OpenSSL::SSL::SSLError => e
      nil
    rescue SocketError => e
      nil
    end
  end
end
