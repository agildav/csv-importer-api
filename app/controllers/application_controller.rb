class ApplicationController < ActionController::API
  before_action do
    ActiveStorage::Current.host = request.base_url
  end

  rescue_from(ArgumentError) { |err| render_argument_error(err) }
  rescue_from(ActiveRecord::RecordNotFound) { |err| render_record_not_found_error(err) }
  rescue_from(ActiveRecord::RecordInvalid) { |err| render_record_not_valid_error(err) }
  rescue_from(ActiveRecord::RecordNotUnique) { |err| render_record_not_unique_error(err) }
  rescue_from(ActionController::ParameterMissing) { |err| render_parameter_missing_error(err) }
  rescue_from(ActionController::RoutingError) { |err| render_routing_error(err) }
  rescue_from(ActiveModel::ForbiddenAttributesError) { |err| render_forbidden_attribute_error(err) }
  rescue_from(ForbiddenException) { |err| render_forbidden_exception(err) }
  rescue_from(UnauthorizedException) { |err| render_unauthorized_exception(err) }
  rescue_from(CustomException) { |err| render_custom_exception(err) }
  def raise_no_matching_route!
    raise ActionController::RoutingError.new("No route matches #{request&.request_method} '/#{params[:unmatched_route_error]}'")
  end

  # pagination settings
  DEFAULT_PAGE_NUMBER = 1
  DEFAULT_MIN_PER_PAGE = 10
  DEFAULT_MAX_PER_PAGE = 100

  def authenticate!
    @current_user = AuthService::AuthenticateUser.call(request.headers[:HTTP_AUTHORIZATION]).result
    render_unauthorized_error("Not authorized") unless @current_user.present?
  end

  def current_user
    @current_user
  end

  # renders raw data
  def render_raw_response(response, status_code = :ok, meta = nil)
    render status: status_code,
      json: {
        status: status_code,
        meta: meta,
        data: response
      }
  end

  # renders data with serializer and meta
  def render_response(response, each_serializer = nil, status_code = :ok, serializer_params = nil)
    if status_code == :no_content
      render_no_content
      return
    end

    if response.blank?
      render_internal_server_error "Could not get response"
      return
    end

    if each_serializer.blank?
      render_internal_server_error "Could not serialize data"
      return
    end

    resources, meta = response
    if resources.respond_to? :each
      if meta.blank?
        render_internal_server_error "Could not fetch metadata"
        return
      end
      render_success_for_resources(status_code: status_code, resources: resources, each_serializer: each_serializer, meta: meta, serializer_params: serializer_params)
    else
      render_success_for_resource(status_code: status_code, resource: resources, serializer: each_serializer, serializer_params: serializer_params)
    end
  end

  # merges page params with a list of parameters
  def merge_with_page_params(parameters)
    params.permit([*page_params, *parameters])
  end

  def parse_multipart_form_data(root_require_parameter = :data, allowed_root_parameters = [], allowed_files = [])
    required_param_body = params.require(root_require_parameter)
    allowed_files = params.permit([*allowed_files])
    required_param_body = required_param_body.to_json unless required_param_body.is_a?(String)

    required_param_body = JSON.parse required_param_body
    required_param_body = ActionController::Parameters.new required_param_body
    ActionController::Parameters.new(required_param_body.permit([*allowed_root_parameters]).to_hash.merge(allowed_files)).permit!
  end

  # builds pagination from resources
  def paginate_resources(resources)
    page_number = DEFAULT_PAGE_NUMBER
    per_page = DEFAULT_MIN_PER_PAGE

    page_number = params[:page]&.to_i if params[:page].present?
    per_page = params[:per_page]&.to_i if params[:per_page].present?

    page_number = DEFAULT_PAGE_NUMBER if page_number < 1
    per_page = DEFAULT_MIN_PER_PAGE if per_page < 1
    per_page = DEFAULT_MAX_PER_PAGE if per_page > DEFAULT_MAX_PER_PAGE

    page = resources&.paginate(page: page_number, per_page: per_page)
    [page, build_pagination_meta(page, [page_number, per_page])]
  end

  private

  def page_params
    [:page, :per_page]
  end

  def build_pagination_meta(page, pager)
    page_number, per_page = pager
    {
      total_pages: page&.total_pages,
      page_number: page_number,
      max_per_page: per_page,
      total_resources: page&.total_entries
    }
  end

  def render_unauthorized_error(error = "User is not authorized")
    logger.error(error)

    render status: :unauthorized,
      json: { status: :unauthorized, error: error, type: "unauthorized_error" }
  end

  def render_routing_error(error)
    logger.error(error&.message)

    render status: :bad_request,
      json: { status: :bad_request, error: error&.message, type: "routing_error" }
  end

  def render_argument_error(error)
    logger.error(error&.message)

    render status: :bad_request,
      json: { status: :bad_request, error: error&.message, type: "argument_error" }
  end

  def render_record_not_found_error(error)
    logger.error(error&.message)

    render status: :not_found,
      json: { status: :not_found, error: "Could not find resource", type: "not_found_error" }
  end

  def render_parameter_missing_error(error)
    logger.error("Missing parameter #{error&.param}")

    render status: :bad_request,
      json: { status: :bad_request, error: "Missing parameter #{error&.param}", type: "parameter_missing_error" }
  end

  def render_forbidden_attribute_error(error)
    logger.error(error&.message)

    render status: :unprocessable_entity,
      json: { status: :unprocessable_entity, error: "Forbidden attributes in record", type: "forbidden_attribute_error" }
  end

  def render_forbidden_exception(error)
    logger.error([error&.message, error&.exception_type])

    render status: :forbidden,
      json: { status: :forbidden, error: error&.message, type: "forbidden_error" }
  end

  def render_unauthorized_exception(error)
    logger.error([error&.message, error&.exception_type])

    render status: :unauthorized,
      json: { status: :unauthorized, error: error&.message, type: "unauthorized_error" }
  end

  def render_custom_exception(error)
    logger.error([error&.message, error&.exception_type])

    render status: :unprocessable_entity,
      json: { status: :unprocessable_entity, error: error&.message, type: "processing_error" }
  end

  def render_record_not_valid_error(error)
    logger.error(error&.message)

    render status: :unprocessable_entity,
      json: { status: :unprocessable_entity, errors: error.record&.errors&.messages, type: "invalid_error" }
  end

  def render_record_not_unique_error(error)
    logger.error(error&.message)

    render status: :bad_request,
      json: { status: :bad_request, error: "A record already exists", type: "not_unique_error" }
  end

  def render_internal_server_error(message = "An internal error has occurred")
    logger.error(message)

    render status: :internal_server_error,
      json: { status: :internal_server_error, error: message, type: "internal_error"  }
  end

  def render_no_content
    render status: :no_content
  end

  def render_success_for_resource(status_code:, resource:, serializer:, serializer_params:)
    render status: status_code,
      json: {
        status: status_code,
        data: serializer&.new(resource, { serializer_params: serializer_params })
      }
  end

  def render_success_for_resources(status_code:, resources:, each_serializer:, meta:, serializer_params:)
    render status: status_code,
      json: {
        status: status_code,
        meta: meta,
        data: ActiveModel::Serializer::CollectionSerializer.new(resources, { serializer: each_serializer, serializer_params: serializer_params })
      }
  end
end
