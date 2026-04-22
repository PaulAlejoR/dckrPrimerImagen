// Se modulariza la lógica de la función para las pruebas (sync-db.test.js)
// Y aparte para app.js que es el que orquesta la ejecución 

let times = 0;

const syncDB = () => {
    times++;
    console.log('Tick cada 5 segundos: ', times);

    return times;
}

module.exports = {
    syncDB
};