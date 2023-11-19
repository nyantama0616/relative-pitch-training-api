module Test
    class TestsController < ApplicationController
        def ping
            render json: { message: 'pong' }
        end

        #params付きのgetを試したい
        def ping_with_message
            message = "ping!#{params[:message]}!"
            render json: { message: message }
        end

        #postを試したい
        def greet
            name = params[:name]
            message = "Hello #{name}!"
            render json: { message: message }
        end
    end
end
