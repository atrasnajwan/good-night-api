class ApplicationController < ActionController::Base
    include Pagy::Backend

    rescue_from ActionController::ParameterMissing, with: :handle_missing_params
    rescue_from ActiveRecord::NotNullViolation, with: :handle_not_null_violation

    # handle if got wrong page
    rescue_from Pagy::OverflowError do
      render json: { error: 'Page out of range' }, status: :bad_request
    end

    private

    def pagination_meta(pagy)
        {
            current_page: pagy.page,
            next_page: pagy.next,
            prev_page: pagy.prev,
            total_pages: pagy.pages,
            total_count: pagy.count
        }
    end

    def handle_missing_params(exception)
        render json: {
          message: "Missing required parameter",
          error: exception.message
        }, status: :bad_request
    end

    def handle_not_null_violation(exception)
        render json: {
          message: "NULL value not allowed",
          error: exception.message
        }, status: :unprocessable_entity
    end
end
