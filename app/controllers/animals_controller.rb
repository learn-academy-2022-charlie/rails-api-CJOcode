class AnimalsController < ApplicationController

    def index 
        animals = Animal.all
        render json: animals
    end

    def show
        animal = Animal.find(params[:id])
        if stident.valid?
            render json: animal
        else
            rendor json: animal.errors
        end
    end

    def create 
        animal = Animal.create(animal_params)

    end

    private
    def animal_params
        params.require(:animal).permit(:common_name, :latin_name, :kingdom)
    end

    



end
