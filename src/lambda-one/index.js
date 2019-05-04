
exports.handler = (event, context, callback) => {
    console.log('lambda-one');
    const value = Math.random();
    if(value >= .20)
        callback(null, 'OK');
    else
        callback('ERROR');
}