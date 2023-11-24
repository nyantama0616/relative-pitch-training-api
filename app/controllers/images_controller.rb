class ImagesController < ApplicationController
    def show
        path = Rails.root.join('public', 'images', params[:image_path])
        send_file path, type: 'image/jpeg', disposition: 'inline'
    end
end
