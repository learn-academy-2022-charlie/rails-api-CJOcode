class SightingsController < ApplicationController

    def index 
        def index
            sightings = Sighting.where(timeline_params)
            render json: sightings
        end
    end

    def show
        sighting = Sighting.find(params[:animal_id])
        rendor json: sighting
    end

    def create 
        sighting = Sighting.create(sighting_params)
        if sighting.valid?
            render json: sighting
        else
            render json: sighting.errors
        end
    end

    def update
        sighting = Sighting.find(params[:animal_id])
        sighting.update(sighting_params)
    end

    def destroy
        sighting = Sighting.find(params[:id])
        if sighting.destroy
          render json: sighting
        else
          render json: sighting.errors
        end
    end


    private
    def sighting_params
        params.require(:sighting).permit(:animal_id, :date, :latitude, :longitude)
    end

    def timeline_params
        params.require(:sightings).permit(date: params[:start_date]..params[:end_date])
    end

end
