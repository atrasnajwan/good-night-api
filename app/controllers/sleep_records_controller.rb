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

    def clock_in
        current_sleep = SleepRecord.find_by(user_id: clock_in_params[:user_id], clocked_out_at: nil)
        
        # can't clock in if not clocked out before
        if current_sleep.present?
            render json: {
                message: "Already clocked in",
                error: "You must clock out before clocking in again"
              }, status: :unprocessable_entity
        else
            new_sleep_record = SleepRecord.new(clock_in_params)
    
            if new_sleep_record.save
                render json: new_sleep_record, status: :created
            else
                render json: { errors: new_sleep_record.errors }, status: :unprocessable_entity
            end
        end
    end

    private
    
    # Example
    # {
    #     "sleep_record": { 
    #         "user_id": 99
    #     }
    # }
    def clock_in_params
        params.required(:sleep_record)
              .permit(:user_id)
              .merge(clocked_in_at: Time.now) # merge current time to param clocked_in_at
    end
end
