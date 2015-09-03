/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function initialize(lat, long, id){
    var myOptions = {
        zoom:8,
        center:new google.maps.LatLng(lat ,long),
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
        map = new google.maps.Map(document.getElementById(id), myOptions);
        marker = new google.maps.Marker({map: map,position: new google.maps.LatLng(lat, long)});
        google.maps.event.addListener(marker, "click",function(){infowindow.open(map,marker);});
}


