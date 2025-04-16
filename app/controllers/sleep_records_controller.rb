class SleepRecordsController < ApplicationController
    before_action :authenticate_user # required to login

    def index
        # get sleep records from current/logged user
        pagination, sleep_records = pagy(
                                        current_user.sleep_records.order(created_at: :desc),
                                        items: params[:per_page] || 10,
                                        page: params[:page] || 1
                                    )

        render json: {
            data: ActiveModelSerializers::SerializableResource.new(sleep_records, each_serializer: SelfSleepRecordSerializer),
            meta: pagination_meta(pagination)
        }
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
    
    def followings_records
        from_date = parse_date(params[:from]) || 1.week.ago.beginning_of_day # default to one week ago
        to_date = parse_date(params[:to]) || Date.today.end_of_day # default to at yesterday

        # check params
        return render json: { error: "`from` must be before `to`" }, status: :unprocessable_entity if from_date > to_date

        # get all following user_id
        following_ids = current_user.followings.pluck(:id) # returns user.id

        sleep_records = SleepRecord.includes(:user)
                            .where(user_id: following_ids)
                            .where(clocked_out_at: from_date..to_date)
                            .select("
                            sleep_records.*,
                            ROUND(
                                (strftime('%s', clocked_out_at) - strftime('%s', clocked_in_at)) / 3600.0,
                                2
                            ) || ' hours' AS sleep_duration") # %s will convert in second and show in hours with 2 decimal places and add hours string on the end
                            .order("sleep_duration DESC") # order from higher to lower

        pagination, sleep_records = pagy(
                                        sleep_records,
                                        items: params[:per_page] || 10,
                                        page: params[:page] || 1
                                    )

        render json: {
            data: ActiveModelSerializers::SerializableResource.new(sleep_records, each_serializer: DetailSleepRecordSerializer),
            meta: pagination_meta(pagination)
        }
    end

    private

    def followings_records_params
        params.permit(:from, :to, :page, :per_page)
    end

    def parse_date(string_date)
        return nil if string_date.blank?

        Date.parse(string_date) rescue nil
    end
end
