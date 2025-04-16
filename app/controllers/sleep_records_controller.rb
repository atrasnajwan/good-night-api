class SleepRecordsController < ApplicationController
    skip_before_action :verify_authenticity_token # to skip CSRF token verification

    def index
        pagination, sleep_records = pagy(SleepRecord, items: params[:per_page] || 10, page: params[:per_page] || 1)

        render json: {
            data: sleep_records,
            meta: pagination_meta(pagination)
        }
    end

    # GET /users/:user_id/sleep_records
    def user_sleep_records
        sleep_records = SleepRecord.where(user_id: params[:user_id])
                                   .order(created_at: :desc)

        render json: sleep_records
    end

end
