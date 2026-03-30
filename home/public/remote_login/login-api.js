var sapi = (function() {
    var instance;

    function createInstance() {
        var object = new Object("I am the instance");
        return object;
    }

    return {
        getInstance: function() {
            if (!instance) {
                instance = createInstance();
            }
            return instance;
        },

        render: function(containerId, params) {
            //Create an input type dynamically.   
            var button = document.createElement("button");
            var customStyle = createStyle();
            document.body.appendChild(customStyle);

            button.innerHTML = params.buttonTitle || "APH Login";
            //Assign different attributes to the element. 
            //button.style = "background-color: #4CAF50;color: white;padding: 14px 20px;margin: 8px 0;border: none;cursor: pointer;width: auto;"
            // 3. Add event handler
            button.addEventListener("click", function() {
                var urlstr = `${params.sifURL}/cfmx/home/public/remote_login/login.html`;
                var title = params.buttonTitle || "APH Login";
                var width = params.width || 400;
                var height = params.height || 600;
                popupCenter(urlstr, title, width, height);
                //alert("did something");
            });

            var _container = document.getElementById(containerId);
            //Append the element in page (in span).  
            _container.appendChild(button);
        },

        verifyToken: function(token, user, params, callback) {

            var urlstr = `${params.sifURL}/cfmx/home/public/api/index.cfm?endpoint=/remote-login&username=${user}&token=${token}`;
            var xmlHttp = new XMLHttpRequest();
            xmlHttp.onreadystatechange = function() {
                if (xmlHttp.readyState == 4 && xmlHttp.status == 200)
                    callback(JSON.parse(xmlHttp.responseText));
                else if (xmlHttp.readyState == 4 && xmlHttp.status != 200)
                    callback({ result: false, message: "Token invalido" });
            }
            xmlHttp.open("GET", urlstr, true); // true for asynchronous 
            xmlHttp.send(null);
        }
    };
})();

window.addEventListener('message', function(e) {
    onSuccess(e.data);
}, false);


var popUpWin = null;

function popupCenter(url, title, w, h) {
    var left = Math.round((screen.width / 2) - (w / 2));
    var top = Math.round((screen.height / 2) - (h / 2));
    return window.open(url, title, `toolbar=no, location=no, directories=no, status=no, 
            menubar=no, scrollbars=no, resizable=no, copyhistory=no, width=${w}, 
            height=${h}, top=${top}, left=${left}`);
}

function popUpWindow(URLStr, width, height) {
    var left = Math.round((screen.width / 2) - (width / 2));
    var top = Math.round((screen.height / 2) - (height / 2));
    if (popUpWin) {
        if (!popUpWin.closed) popUpWin.close();
    }
    popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width=' + width + ',height=' + height + ',left=' + left + ', top=' + top + ',screenX=' + left + ',screenY=' + top + '');
    if (!popUpWin && !document.popupblockerwarning) {
        alert('Aviso: Su bloqueador de ventanas emergentes (popup blocker) \nestá evitando que se abra la ventana.\nPor favor revise las opciones de su navegador (browser), y \nacepte las ventanas emergentes de este sitio: ' + location.hostname);
        document.popupblockerwarning = 1;
    } else
    if (popUpWin.focus) popUpWin.focus();
}

function closePopup() {
    if (popUpWin) {
        if (!popUpWin.closed) popUpWin.close();
        popUpWin = null;
    }
}

function test() {

    var instance1 = sapi.getInstance();
    var instance2 = sapi.getInstance();

    alert("Same instance? " + (instance1 === instance2));
}

function createStyle() {
    var sheet = document.createElement('style');
    sheet.type = "text/css";
    sheet.innerHTML = `body {
        font-family: Arial, Helvetica, sans-serif;
    }
    /* Full-width input fields */
    
    input[type=text],
    input[type=password] {
        width: 100%;
        padding: 12px 20px;
        margin: 8px 0;
        display: inline-block;
        border: 1px solid #ccc;
        box-sizing: border-box;
    }
    /* Set a style for all buttons */
    
    button {
        background-color: #4CAF50;
        color: white;
        padding: 14px 20px;
        margin: 8px 0;
        border: none;
        cursor: pointer;
        width: 100%;
    }
    
    button:hover {
        opacity: 0.8;
    }
    /* Extra styles for the cancel button */
    
    .cancelbtn {
        width: auto;
        padding: 10px 18px;
        background-color: #f44336;
    }
    /* Center the image and position the close button */
    
    .imgcontainer {
        text-align: center;
        margin: 24px 0 12px 0;
        position: relative;
    }
    
    img.avatar {
        width: 40%;
        border-radius: 50%;
    }
    
    .container {
        padding: 16px;
    }
    
    span.psw {
        float: right;
        padding-top: 16px;
    }
    /* The Modal (background) */
    
    .modal {
        display: none;
        /* Hidden by default */
        position: fixed;
        /* Stay in place */
        z-index: 1;
        /* Sit on top */
        left: 0;
        top: 0;
        width: 100%;
        /* Full width */
        height: 100%;
        /* Full height */
        overflow: auto;
        /* Enable scroll if needed */
        background-color: rgb(0, 0, 0);
        /* Fallback color */
        background-color: rgba(0, 0, 0, 0.4);
        /* Black w/ opacity */
        padding-top: 60px;
    }
    /* Modal Content/Box */
    
    .modal-content {
        background-color: #fefefe;
        margin: 5% auto 15% auto;
        /* 5% from the top, 15% from the bottom and centered */
        border: 1px solid #888;
        width: 80%;
        /* Could be more or less, depending on screen size */
    }
    /* The Close Button (x) */
    
    .close {
        position: absolute;
        right: 25px;
        top: 0;
        color: #000;
        font-size: 35px;
        font-weight: bold;
    }
    
    .close:hover,
    .close:focus {
        color: red;
        cursor: pointer;
    }
    /* Add Zoom Animation */
    
    .animate {
        -webkit-animation: animatezoom 0.6s;
        animation: animatezoom 0.6s
    }
    
    @-webkit-keyframes animatezoom {
        from {
            -webkit-transform: scale(0)
        }
        to {
            -webkit-transform: scale(1)
        }
    }
    
    @keyframes animatezoom {
        from {
            transform: scale(0)
        }
        to {
            transform: scale(1)
        }
    }
    /* Change styles for span and cancel button on extra small screens */
    
    @media screen and (max-width: 300px) {
        span.psw {
            display: block;
            float: none;
        }
        .cancelbtn {
            width: 100%;
        }
    `;

    return sheet;
}


renderButton();