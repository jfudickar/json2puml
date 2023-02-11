echo [ >swapi_data_people.json
curl https://swapi.dev/api/people/ >>swapi_data_people.json
echo , >>swapi_data_people.json
curl https://swapi.dev/api/people/?page=2 >>swapi_data_people.json
echo , >>swapi_data_people.json
curl https://swapi.dev/api/people/?page=3 >>swapi_data_people.json
echo , >>swapi_data_people.json
curl https://swapi.dev/api/people/?page=4 >>swapi_data_people.json
echo , >>swapi_data_people.json
curl https://swapi.dev/api/people/?page=5 >>swapi_data_people.json
echo , >>swapi_data_people.json
curl https://swapi.dev/api/people/?page=6 >>swapi_data_people.json
echo , >>swapi_data_people.json
curl https://swapi.dev/api/people/?page=7 >>swapi_data_people.json
echo , >>swapi_data_people.json
curl https://swapi.dev/api/people/?page=8 >>swapi_data_people.json
echo ] >>swapi_data_people.json
		
curl https://swapi.dev/api/films/ >swapi_data_films.json		

echo [ >swapi_data_planets.json
curl https://swapi.dev/api/planets/ >>swapi_data_planets.json
echo , >>swapi_data_planets.json
curl https://swapi.dev/api/planets/?page=2 >>swapi_data_planets.json
echo , >>swapi_data_planets.json
curl https://swapi.dev/api/planets/?page=3 >>swapi_data_planets.json
echo , >>swapi_data_planets.json
curl https://swapi.dev/api/planets/?page=4 >>swapi_data_planets.json
echo , >>swapi_data_planets.json
curl https://swapi.dev/api/planets/?page=5 >>swapi_data_planets.json
echo , >>swapi_data_planets.json
curl https://swapi.dev/api/planets/?page=6 >>swapi_data_planets.json
echo ] >>swapi_data_planets.json

echo [ >swapi_data_species.json
curl https://swapi.dev/api/species/ >>swapi_data_species.json
echo , >>swapi_data_species.json
curl https://swapi.dev/api/species/?page=2 >>swapi_data_species.json
echo , >>swapi_data_species.json
curl https://swapi.dev/api/species/?page=3 >>swapi_data_species.json
echo , >>swapi_data_species.json
curl https://swapi.dev/api/species/?page=4 >>swapi_data_species.json
echo ] >>swapi_data_species.json

echo [ >swapi_data_starships.json
curl https://swapi.dev/api/starships/ >>swapi_data_starships.json
echo , >>swapi_data_starships.json
curl https://swapi.dev/api/starships/?page=2 >>swapi_data_starships.json
echo , >>swapi_data_starships.json
curl https://swapi.dev/api/starships/?page=3 >>swapi_data_starships.json
echo , >>swapi_data_starships.json
curl https://swapi.dev/api/starships/?page=4 >>swapi_data_starships.json
echo ] >>swapi_data_starships.json

echo [ >swapi_data_vehicles.json
curl https://swapi.dev/api/vehicles/ >>swapi_data_vehicles.json
echo , >>swapi_data_vehicles.json
curl https://swapi.dev/api/vehicles/?page=2 >>swapi_data_vehicles.json
echo , >>swapi_data_vehicles.json
curl https://swapi.dev/api/vehicles/?page=3 >>swapi_data_vehicles.json
echo , >>swapi_data_vehicles.json
curl https://swapi.dev/api/vehicles/?page=4 >>swapi_data_vehicles.json
echo ] >>swapi_data_vehicles.json

