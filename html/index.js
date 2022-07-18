const resourceName = window.GetParentResourceName();
var spawnSelector = $('#SpawnSelector');
var errorWindow = $('#error-window');
var infoWindow = $("#info-window");
var isErrorJumped = false;
var isInfoWinJumped = false;
var isSpawnSelected = false;
var selectedSpawn = "";

function throwErr(msg) {
    if (!isErrorJumped) {
        isErrorJumped = true
        errorWindow.children().text(msg);
        errorWindow.slideDown(); 
        setTimeout(() => {
            errorWindow.slideUp(); 
            isErrorJumped = false;
        }, 4000);
    }
}

function playAudio(url) {
    let audio = new Audio(url);
    audio.playbackRate = 1.5;
    audio.play();
}

window.addEventListener('message', function(event) {
    var message = event.data;
    if (message.type == "openSpawnSelector") {
        spawnSelector.html(""); // Clearing the container 
        for (const key in message.spawnLocations) {
            spawnSelector.append(`<button class="SpawnOption" data-location="${key}"><p>${message.spawnLocations[key]["label"]}</p></button>`)
        }
        spawnSelector.show();
        infoWindow.show();
    }
})

$(document).on('click', '.SpawnOption', function(evt){
    if ($(this).attr('data-location') != selectedSpawn) {
        playAudio('audio/clickAudio.mp3');
        fetch(`https://${resourceName}/playerSelectedSpawnLocation`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({
                location: $(this).attr('data-location')
            })
        }).then(resp => resp.json()).then(resp => throwErr(resp));
        selectedSpawn = $(this).attr('data-location');
        isSpawnSelected = true;
    }  
});

document.onkeyup = function(data) {
    if (data.which == 16) {
        infoWindow.css({width: 360 + "px", height: 40 + "px", 'font-size': 16 + "px"})
        if (isSpawnSelected) {
            fetch(`https://${resourceName}/spawnPlayer`, {
                method: "POST",
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
            });
            setTimeout(() => {
                spawnSelector.fadeOut();
                infoWindow.hide();
                selectedSpawn = ''
                isSpawnSelected = false;
            }, 400)
        } else {
            throwErr("Please select your spawn location.")
        }
        if (!isInfoWinJumped) {
            isInfoWinJumped = true;
            setTimeout(() => {
                infoWindow.css({width: 350 + "px", height: 30 + "px", 'font-size': 14 + "px"})
                isInfoWinJumped = false;
            }, 400);
        }
    };
}