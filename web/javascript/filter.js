
window.onload = function(){
    document.getElementById("apply").onclick = function(){
        
        var inputs = document.getElementsByTagName("input");
        
        var checkedType = []; //conterrà tutti itipi checked
        var checkedDistrict = []; //conterrà tutte le province checked
        var date = [];
        
        for (var i = 0; i < inputs.length; i++) {
            if (inputs[i].type === "checkbox") {
                if (inputs[i].checked) {
                    if (inputs[i].name ==="type"){
                        checkedType.push(inputs[i]);
                    }else if (inputs[i].name ==="district"){
                        checkedDistrict.push(inputs[i]);
                    }
                }
            }else if(inputs[i].type ==="date"){
                date.push(inputs[i]);
            }
        }
        
        //Se nessuna città è selezionata allora la ricerca è su tutte le città
        if (checkedDistrict.length === 0){
            for (var i = 0; i < inputs.length; i++) {
                if (inputs[i].type === "checkbox") {
                    if (inputs[i].name ==="district"){
                        checkedDistrict.push(inputs[i]);
                    }
                }
            }
        }
        
        //Se nessun tipo è selezionato allora la ricerca è su tutti i tipi di eventi
        if (checkedType.length === 0){
            for (var i = 0; i < inputs.length; i++) {
                if (inputs[i].type === "checkbox") {
                    if (inputs[i].name ==="type"){
                        checkedType.push(inputs[i]);
                    }
                }
            }
        }
        
        //Inserisco in un array tutti gli articoli delle città selezionate
        var eventsInCities = [];
        eventsInCities = findCity(checkedDistrict);
        
        //Inserisco in un array tutti gli articoli delle città e dei tipi selezionati
        var eventsOfType = [];
        eventsOfType = findType(checkedType, eventsInCities);
        
        //Inserisco in un array gli elementi da visualizzare con tutti i filtri applicati
        var eventsToShow = [];
        eventsToShow = findDate(date, eventsOfType);
        
        showEvents(eventsToShow);
        
        return false;
        };
};

function findCity(checkedDistrict){
    //Prendo tutti gli articoli delle città selezionate
    var articles = document.getElementsByTagName("article");
    var eventsInCities = [];
    for (var i=0; i<articles.length; i++){
        var districtName = articles[i].className.split(' ')[0];
        for (var j=0; j<checkedDistrict.length; j++){
            if (districtName === checkedDistrict[j].value){
                eventsInCities.push(articles[i]);
            }
        }
    }
    return eventsInCities;        
}

function findType(checkedType, eventsInCities){
    //Prendo tutti i tipi di evento nelle città selezionate (già filtrate per città)
    var eventsOfType = [];
    for (var i=0; i<eventsInCities.length; i++){
        var typeName = eventsInCities[i].className.split(' ')[1];
        for (var j=0; j<checkedType.length; j++){
            if (typeName === checkedType[j].value){
                eventsOfType.push(eventsInCities[i]);
            }
        }
    }
    return eventsOfType;        
}

function findDate(date,eventsOfType){
    
    var n = 0;          //numero di quante date sono state inserite
    var time = [];      //array che contiene le 2 date su cui fare la ricerca
    
    /*
     * Dichiariamo 2 variabili che utilizzeremo nel caso in cui un utente non inserisca 
     * la data di inizio o di fine del range di ricerca.
     */
    var dataMax = new Date("2100-01-01").getTime();
    var dataMin = new Date("2000-01-01").getTime();
    
    var events_to_show = [];    //array in cui inseriremo gli eventi che devono essere visualizzati.
    
    //Salviamo le date inserite dall'utente nel nostro array time[]
    for(var i=0; i<date.length; i++){
        if(date[i].value.length===0){ //nel caso in cui una data non sia stata inserita l'input 'date' ritorna una stringa vuota
            time[i]=0;   
        }else{
            time[i] = new Date(date[i].value).getTime();
            n++;    //conta quante date ha inserito l'utente
        }
    }
    
    if(n===0){ //se nessuna data è stata inserita non c'è necessità di fare altri controlli
        return eventsOfType;
    }
    if(n === 1){
        if(time[1]===0){
            //l'utente ha inserito solo la data iniziale per cui vuole visualizzare tutti gli eventi a partire da questa data
            time[1]=dataMax;
            n++;
        }else{
            //l'utente ha inserito solo la data finale per cui vuole visualizzare tutti gli eventi precedenti a questa data
            time[0]=dataMin;
            n++;
        }
    }
    if(n === 2){    //sono presenti entrambe le date o perchè le abbiamo aggiunte noi o perchè sono state inserite dall'utente
        
        for(var i=0; i<eventsOfType.length; i++){
            //Per ogni evento mi salvo le date di inizio e di fine
            var eventId = eventsOfType[i].id;
            var eventST = new Date(eventId.split("_")[1]).getTime();
            var eventET = new Date(eventId.split("_")[2]).getTime();
            
            //Controlliamo se l'evento è da visualizzare confrontando le date
            if( ((eventST<=time[0])&&(time[0]<=time[1])&&(time[1]<=eventET)) || 
                    ((eventST<=time[0])&&(time[0]<=eventET)&&(eventET<=time[1]))|| 
                    ((time[0]<=eventST)&&(eventST<=time[1])&&(time[1]<=eventET))|| 
                    ((time[0]<=eventST)&&(eventST<=eventET)&&(eventET<=time[1]))){
                console.log("data inizio evento "+eventST);
                console.log("data fine evento "+eventET);
                console.log("inizio ricerca"+time[0]);
                console.log("fine ricerca"+time[1]);
                console.log("evento aggiunto "+i);
                
                events_to_show.push(eventsOfType[i]);
            }
        }
    }
    return events_to_show;
}


function showEvents(events_to_show){
    //nascondi tutti gli articoli
    var articles = document.getElementsByTagName("article");
    for (var i=0; i<articles.length; i++){
        articles[i].style.display ="none";
    }
    
    //Visualizza solo gli articles_to_show
    for (var i=0; i<events_to_show.length; i++){
        events_to_show[i].style.display ="block";
    }    
}