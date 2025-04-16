class SleepRecordsController < ApplicationController
    before_action :authenticate_user, only: [:index, :clock_in, :clock_out] # required to login

    def index
        # get sleep records from current/logged user
        pagination, sleep_records = pagy(
                                        current_user.sleep_records.order(created_at: :desc),
                                        items: params[:per_page] || 10,
                                        page: params[:page] || 1
                                    )

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
        # get sleep records from current/logged user
        current_sleep = SleepRecord.find_by(user: current_user, clocked_out_at: nil)
        
        # can't clock in if not clocked out before
        if current_sleep.present?
            render json: {
                message: "Already clocked in",
                error: "You must clock out before clocking in again"
              }, status: :unprocessable_entity
        else
            new_sleep_record = SleepRecord.new(user: current_user, clocked_in_at: Time.now) # clock in with current time
    
            if new_sleep_record.save
                render json: new_sleep_record, status: :created
            else
                render json: { errors: new_sleep_record.errors }, status: :unprocessable_entity
            end
        end
    end

    def clock_out
        # get un-clocked out sleep record from current/logged user
        current_sleep = current_user.sleep_records.find_by(clocked_out_at: nil)

        if current_sleep.present?
            current_sleep.update!(clocked_out_at: Time.now)

            render json: current_sleep
        else
            render json: { 
                message: "Already clocked out",    
                error: "Can't clock out sleep that you already clocked out"
            }, status: :unprocessable_entity
        end
    end
    
end
