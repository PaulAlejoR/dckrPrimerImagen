// Este archivo aisla a app.js para tomar la lógica de sync-db.js que es la lógica de la aplicación y poder hacer pruebas

const { syncDB } = require("../../tasks/sync-db");


describe('syncDB task', () => {

    test('debe ejecutar el proceso 2 veces', () => {
        
        syncDB();
        const times = syncDB();

        expect( times ).toBe(2); 
    });

});