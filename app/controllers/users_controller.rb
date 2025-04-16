class UsersController < ApplicationController
    skip_before_action :verify_authenticity_token # to skip CSRF token verification

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
