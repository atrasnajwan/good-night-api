class UsersController < ApplicationController
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
end
