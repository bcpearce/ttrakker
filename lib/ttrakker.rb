require "ttrakker/version"

module Ttrakker

  ROOT = 'http://www.amtrak.com'

  STATUS_FORM = {id:'ff_status_form', train:'wdf_trainNumber',
                   origin:'wdf_origin', destination:'wdf_destination',
                   sort_by:'wdf_SortBy' }
  STATUS_NEEDS = [[:origin, :destination], [:train, :origin], [:train, :destination]]
  STATUS_RESULT = ".status_result"
  ROUTE_NUM = ".route_num"
  ROUTE_NAME = ".route_name"

  def get_root
    agent = Mechanize.new
    page = agent.get(ROOT)
  end

  def options_good?(options={})
    STATUS_NEEDS.any? { |keys| (keys - options.keys).empty? }
  end

  def status_query(options={})
    agent = Mechanize.new
    page = get_root
    status_form = page.form(STATUS_FORM[:id])

    options.each do |key, value|
      status_form.send(STATUS_FORM[key], value)
    end

    agent.submit(status_form)
  end

  def status_results(options={})
    page = status_query(options)
    page.search(STATUS_RESULT).each_slice(2).to_a
  end

  def route_num(status_result)
    status_result.first.search(ROUTE_NUM).text.delete("\r\n")
  end

  def route_name(status_result)
    status_result.first.search(ROUTE_NAME).text.delete("\r\n")
  end

  class StatusResult < Array

  end


end
