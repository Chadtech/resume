var app = Elm.Main.init();

app.ports.downloadAsPdfInternal.subscribe(function(params){
    window.open(params.url);
})

