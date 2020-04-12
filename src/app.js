var app = Elm.Main.init({
    flags: {
        viewMode: "pdf"
//        viewMode: "web"
    }
});

app.ports.downloadAsPdfInternal.subscribe(function(params){
    window.open(
        "https://www.sejda.com/html-to-pdf?save-link=" + params.url + "?viewportWidth=850",
    );
})

