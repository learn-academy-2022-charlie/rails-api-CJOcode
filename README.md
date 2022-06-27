# README
Starting in terminal:
-- rails new wildlife_tracker -d postgresql -T 
    ## generating new rails app
-- cd wildlife_tracker
-- bundle add rspec-rails

-- rails db:create
-- bundle add rspec-rails
-- rails g rspec:install
-- rails server
-- git remote add origin https://github.com/learn-academy-2022-charlie/rails-api-CJOcode.git
-- git checkout -b main
-- git add .
-- git commit -m "initial rails app with rspec installed"
-- git push origin main
-- code .



Story: As a developer I can create an animal model in the database. An animal has the following information: common name, latin name, kingdom (mammal, insect, etc.).

Terminal:
-- rails g resource Animal common_name:string latin_name:string kingdom:string 
-- rm -r app/views/animals 
-- rm app/helpers/animals_helper.rb
-- rails c
--  Animal.create common_name:"alligator", latin_name:"alligator missis
sippiensis", kingdom:"animalia" 


<-------------------------------------------------------------------------->
Story: As the consumer of the API I can see all the animals in the database. Hint: Make a few animals using Rails Console

## In Animal contoller:
    
    def index 
        animals = Animal.all
        render json: animals
        //--> since API's have no UI and we deleted the views(app/views/animals) form our app, must render JSON.
    end
    
    def show
        animal = Animal.find(params[:id])
        render json: animal
    end
        // SHOW method allows us to look up individual animals
        // localhost:3000/animals/:id 
    
## Open Postman, 
    // add new file, 
    // paste localhost:3000/animals("route") in url bar.
    // use GET as your HTTP verb
    // click send, all your create animals should pop up, status should be 200
        // ** Make sure server is running in terminal **
        
<-------------------------------------------------------------------------->
Story: As the consumer of the API I can update an animal in the database.

## IN Animal controller
    def update
        animal = Animal.find(params[:id])
        animal.update(animal_params)
    end

<-------------------------------------------------------------------------->
Story: As the consumer of the API I can destroy an animal in the database.

## IN Animal controller

    def destroy
        animal = Animal.find(params[:id])
        if animal.destroy
          render json: animal
        else
          render json: animal.errors
        end
    end

<-------------------------------------------------------------------------->
Story: As the consumer of the API I can create a new animal in the database.

## In Animal contoller:

    def create 
        animal = Animal.create(animal_params)
        if animal.valid?
            render json: animal
        else
            render json: animal.errors
        end
    end

    private // stops users form accessing this method
    def animal_params
        params.require(:animal).permit(:common_name, :latin_name, :kingdom)
    end
// CREATE method / RESTful route allows us to create the new animals.
    // the IF statement allows us to see if the new animal if what user entered is valid and if not show us why it isn't working.
        // should get back a 200 for status when entered in post man
// then underneath the private key word animal_params only permit users to enter the common name, latin_name and Kingdom. Not allowing them to mess with the ID and dev specific keys.


## In Application controller:

    class ApplicationController < ActionController::Base

    skip_before_action :verify_authenticity_token 
// this allows your application to by pass Postmate's security measures and access if the data base.
// ** if you forget this you will not be allowed to create a new animal **

    end

## In Postman

// Use POST for the route, localhost:3000/animals
    // under url bar select body, raw, and JSON
    // type in your new animal (extremely case sensitive)
        {
        "common_name": "jaguar",
        "latin_name": "panthero onca",
        "kingdom": "animalia"
        }
    // your new animal should be created

// Check by running a GET, localhost:3000/animals 
    // your new animal should be listed with all the others.

<-------------------------------------------------------------------------->
Story: As the consumer of the API I can create a sighting of an animal with date (use the datetime datatype), a latitude, and a longitude.
Hint: An animal has_many sightings. (rails g resource Sighting animal_id:integer ...)
Hint: Datetime is written in Rails as “year-month-day hr:min:sec" (“2022-01-28 05:40:30")

## In terminal: 

    -- rails g resource Sighting animal_id:integer date:datetime latitude:string longitude:string
    -- rails db:migrate

 ## In sightings_controller
    
    def create 
        sighting = Sighting.create(sighting_params)
        if sighting.valid?
            render json: sighting
        else
            render json: sighting.errors
        end
    end

    private
    def sighting_params
        params.require(:sighting).permit(:animal_id, :date, :latitude, :longitude)
    end 
// sets params for what to be entered to create sighting in postman

## In Postman
    -- Set http verb to post, typed localhost:3000/sightings

// enter in sighting params

    --> {
        "animal_id": 1,
        "date": "2022-03-24T12:30:30.000Z",
        "latitude": "17°N",
        "longitude": "14°E"
        }

// check its entered by using GET localhost:3000/sightings
    -- new sighting should pop up


<-------------------------------------------------------------------------->
Story: As the consumer of the API I can update an animal sighting in the database.

## In sighting controller
    def update
        sighting = Sighting.find(params[:animal_id])
        sighting.update(sighting_params)
    end

## In Postman
    -- set HTTP verb to PUT; URL - localhost:3000/sightings
// update info you want
    {
    "animal_id": 1,
    "date": "2022-04-24T12:30:30.000Z",
    "latitude": "17°N",
    "longitude": "14°E"
    }


<-------------------------------------------------------------------------->
Story: As the consumer of the API I can destroy an animal sighting in the database.

## In sighting controller
    def destroy
        sighting = Sighting.find(params[:id])
        if animal.destroy
          render json: sighting
        else
          render json: sighting.errors
        end
    end

## In Postman
    -- set HTTP verb to DELETE; URL: localhost:3000/sightings/1 --> (sighting_id)




<-------------------------------------------------------------------------->
Story: As the consumer of the API, when I view a specific animal, I can also see a list sightings of that animal.
Hint: Checkout the Ruby on Rails API docs on how to include associations.

## In Animal Controller
    def show
        animal = Animal.find(params[:id])
        render json: animal, include: :sightings 
    end
// include: includes the model Sighting into the show route when ran

## in Postman
    -- set HTTP verb to get; URL: localhost:3000/animals/1 --> (sighting_id)

<-------------------------------------------------------------------------->
Story: As the consumer of the API, I can run a report to list all sightings during a given time period.
Hint: Your controller can look like this:

## In Sighting Controller
    def index 
        def index
            sightings = Sighting.where(timeline_params)
            render json: sightings
        end
    end

### strong params
    def timeline_params
        params.require(:sightings).permit(date: params[:start_date]..params[:end_date])
    end