<cfset googleData=createobject("component","home.Componentes.SeguridadGOOGLE").generateAuthUrl(session.urltoken)>

<html>
<head>
  <title>Demo: Getting an email address using the Google+ Sign-in button</title>
  <style type="text/css">
  .hide { display: none;}
  .show { display: block;}
  </style>
  <script src="https://apis.google.com/js/plusone.js" type="text/javascript"></script>
  <script type="text/javascript">
  /*
   * Activado cuando el usuario acepta el inicio de sesión, cancela o cierra el
   * cuadro de diálogo de autorización.
   */
  function loginFinishedCallback(authResult) {
    if (authResult) {
      if (authResult['error'] == undefined){
        gapi.auth.setToken(authResult); // Almacena el token recuperado.
        toggleElement('signin-button'); // Oculta el inicio de sesión si se ha accedido correctamente.
        getEmail();                     // Activa la solicitud para obtener la dirección de correo electrónico.
      } else {
        console.log('An error occurred');
      }
    } else {
      console.log('Empty authResult');  // Se ha producido algún error
    }
  }

  /*
   * Inicia la solicitud del punto final userinfo para obtener la dirección de correo electrónico del
   * usuario. Esta función se basa en gapi.auth.setToken que contiene un token
   * de acceso de OAuth válido.
   *
   * Cuando se completa la solicitud, se activa getEmailCallback y recibe
   * el resultado de la solicitud.
   */
  function getEmail(){
    // Carga las bibliotecas oauth2 para habilitar los métodos userinfo.
    gapi.client.load('oauth2', 'v2', function() {
          var request = gapi.client.oauth2.userinfo.get();
          request.execute(getEmailCallback);
        });
  }

  function getEmailCallback(obj){
    var el = document.getElementById('email');
    var email = '';

    if (obj['email']) {
      email = 'Email: ' + obj['email'];
    }

    //console.log(obj);   // Sin comentario para inspeccionar el objeto completo.

    el.innerHTML = email;
    toggleElement('email');
  }

  function toggleElement(id) {
    var el = document.getElementById(id);
    if (el.getAttribute('class') == 'hide') {
      el.setAttribute('class', 'show');
    } else {
      el.setAttribute('class', 'hide');
    }
  }
  </script>

  <script type="text/javascript">
	(function() {
	  var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
	  po.src = 'https://apis.google.com/js/client:plusone.js?onload=onLoadCallback';
	  var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
	})();
  </script>

</head>
<body>
  <div id="signin-button" class="show">
     <div class="g-signin" data-callback="loginFinishedCallback"
      data-approvalprompt="force"
      data-clientid="<cfoutput>#googleData#</cfoutput>"
      data-scope="https://www.googleapis.com/auth/plus.login https://www.googleapis.com/auth/userinfo.email"
      data-height="short"
      data-cookiepolicy="single_host_origin"
      >
    </div>
  </div>

  <div id="email" class="hide"></div>
</body>
</html>
