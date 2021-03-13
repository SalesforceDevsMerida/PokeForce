public with sharing class PokemonController {
    private static final String POKEMON_URL = 'https://pokeapi.co/api/v2/pokemon?limit=20';
    private static final String POKEMON_IMAGE_URL = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/';

    public void fetchPokemonData(){
        String POKEMON_IMAGE_URL = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/';
        Http client = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://pokeapi.co/api/v2/pokemon?limit=20');
        request.setMethod('GET');
        HttpResponse response = client.send(request);
        Map<String, Object> deserialized = (Map<String,Object>)JSON.deserializeUntyped(response.getBody());
        Map<String,Object> mapPokemon;
        Pokemon__c pokemon;
        List<Pokemon__c> pokemons = new List<Pokemon__c>();
        for (Object rawPokemon : ((List<Object>)deserialized.get('results'))) {
            mapPokemon = (Map<String,Object>) rawPokemon;
            pokemon = new Pokemon__c();
            pokemon.Name = ((String)((Map<String,Object>) rawPokemon).get('name')).capitalize();
            pokemon.ExternalId__c = ((String)((Map<String,Object>) rawPokemon).get('url')).split('/')[6];
            pokemon.ImageURL__c = POKEMON_IMAGE_URL + pokemon.ExternalId__c + '.png';
            pokemons.add(pokemon);
        }
        upsert pokemons ExternalId__c;
    }
}
