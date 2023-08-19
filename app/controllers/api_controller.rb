class ApiController < ActionController::API

  include ActionController::HttpAuthentication::Token::ControllerMethods

  private

  def response_data(data, message, status, error:nil, disabled:false, update:false, external_rating: nil, params: {})
    result = Hash.new
    result[:data] = data
    result[:message] = message
    result[:status] = status
    result[:error] = error
    result[:disabled] = disabled
    result[:update] = update
    result[:external_rating] = external_rating
    render json: result, params: params, status: status
  end

  def error_response error
    return response_data(nil, error[1], 200, error: get_error_object(error[1], error[0]))
  end

  def error_response_bad_request error
    return response_data(nil, error[1], 400, error: get_error_object(error[1], error[0]))
  end

  def throw_internal_server_error
    error = Entities::Error.new
    error.code = 500
    error.message = 'Internal Server Error'
    response_data(nil, 'Internal Server Error', 500, error: error)
  end

  def get_error_object message, code
    errorResp = Entities::Error.new
    errorResp.message = message
    errorResp.code = code
    errorResp
  end

end
