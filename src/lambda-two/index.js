
exports.handler = (event, context, callback) => {
    console.log('lambda-two');
    const value = Math.random();
    if(value >= .20)
        callback(null, 'OK');
    else
        callback('ERROR');
}