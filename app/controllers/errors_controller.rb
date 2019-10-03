class ErrorsController < ApplicationController
    def show
        render text: params[:status]
    end
end
