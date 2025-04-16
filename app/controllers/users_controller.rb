class UsersController < ApplicationController
    before_action :authenticate_user, only: [:followers, :followings, :follow] # required to login

    def index
        pagination, users = pagy(User, items: params[:per_page] || 10, page: params[:per_page] || 1)

        render json: {
            data: users,
            meta: pagination_meta(pagination)
        }
    end

    def show
        user = User.find_by(id: params[:id])

        if user.present?
            render json: user
        else
            render json: { error: 'User not found' }, status: :not_found # not_found == http status code 404
        end
    end

    def create
        new_user = User.new(create_params)

        if new_user.save
            render json: new_user, status: :created
        else
            render json: { errors: new_user.errors }, status: :unprocessable_entity
        end
    end

    def followers
        pagination, users = pagy(
                                current_user.followers.order(created_at: :desc), # sort by latest
                                items: params[:per_page] || 10,
                                page: params[:page] || 1
                            )

        render json: {
            data: users,
            meta: pagination_meta(pagination)
        }
    end

    def followings
        pagination, users = pagy(
                                current_user.followings.order(created_at: :desc), # sort by latest
                                items: params[:per_page] || 10,
                                page: params[:page] || 1
                            )

        render json: {
            data: users,
            meta: pagination_meta(pagination)
        }
    end

    def follow
        if params[:id] == current_user.id
        return render json: {
                    message: "Can not follow",
                    error: "You can not follow yourself"
                }, status: :unprocessable_entity
        end

        user_to_follow = User.find_by(id: params[:id])

        if user_to_follow.present?
            is_already_follow = current_user.followings.find_by(id: user_to_follow.id)

            if is_already_follow
                return render json: {
                        message: "Already follow",
                        error: "You already follow this User"
                    }, status: :unprocessable_entity
            end

            ::Following.create!(
                follower_id: current_user.id,
                followed_id: user_to_follow.id
            )
          
            render json: { message: "Now following #{user_to_follow.name}" }, status: :created
        else
            render json: { error: 'User not found' }, status: :not_found # not_found == http status code 404
        end
    end

    private

    # Example
    # {
    #     "user": { 
    #         "name": "New User.name"
    #     }
    # }
    def create_params
        params.require(:user)
              .permit(:name)
    end
end
