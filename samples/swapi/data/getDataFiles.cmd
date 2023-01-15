echo [ >people.json
curl https://swapi.dev/api/people/ >>people.json
echo , >>people.json
curl https://swapi.dev/api/people/?page=2 >>people.json
echo , >>people.json
curl https://swapi.dev/api/people/?page=3 >>people.json
echo , >>people.json
curl https://swapi.dev/api/people/?page=4 >>people.json
echo , >>people.json
curl https://swapi.dev/api/people/?page=5 >>people.json
echo , >>people.json
curl https://swapi.dev/api/people/?page=6 >>people.json
echo , >>people.json
curl https://swapi.dev/api/people/?page=7 >>people.json
echo , >>people.json
curl https://swapi.dev/api/people/?page=8 >>people.json
echo ] >>people.json
		
curl https://swapi.dev/api/films/ >films.json		

echo [ >planets.json
curl https://swapi.dev/api/planets/ >>planets.json
echo , >>planets.json
curl https://swapi.dev/api/planets/?page=2 >>planets.json
echo , >>planets.json
curl https://swapi.dev/api/planets/?page=3 >>planets.json
echo , >>planets.json
curl https://swapi.dev/api/planets/?page=4 >>planets.json
echo , >>planets.json
curl https://swapi.dev/api/planets/?page=5 >>planets.json
echo , >>planets.json
curl https://swapi.dev/api/planets/?page=6 >>planets.json
echo ] >>planets.json

echo [ >species.json
curl https://swapi.dev/api/species/ >>species.json
echo , >>species.json
curl https://swapi.dev/api/species/?page=2 >>species.json
echo , >>species.json
curl https://swapi.dev/api/species/?page=3 >>species.json
echo , >>species.json
curl https://swapi.dev/api/species/?page=4 >>species.json
echo ] >>species.json

echo [ >starships.json
curl https://swapi.dev/api/starships/ >>starships.json
echo , >>starships.json
curl https://swapi.dev/api/starships/?page=2 >>starships.json
echo , >>starships.json
curl https://swapi.dev/api/starships/?page=3 >>starships.json
echo , >>starships.json
curl https://swapi.dev/api/starships/?page=4 >>starships.json
echo ] >>starships.json

echo [ >vehicles.json
curl https://swapi.dev/api/vehicles/ >>vehicles.json
echo , >>vehicles.json
curl https://swapi.dev/api/vehicles/?page=2 >>vehicles.json
echo , >>vehicles.json
curl https://swapi.dev/api/vehicles/?page=3 >>vehicles.json
echo , >>vehicles.json
curl https://swapi.dev/api/vehicles/?page=4 >>vehicles.json
echo ] >>vehicles.json

