<cfset LvarGoogle =listFindNoCase(Application.politicas_pglobal.auth.orden,'google',',')>
<cfif LvarGoogle>
  <cfset googleData=createobject('component','home.Componentes.SeguridadGOOGLE').getOauthData()>  
  <cfif StructIsEmpty(googleData)>
    <cfset LvarGoogle=false>
  </cfif>
</cfif>
  
<cfset LvarASP =listFindNoCase(Application.politicas_pglobal.auth.orden,'asp',',') or listFindNoCase(Application.politicas_pglobal.auth.orden,'ldap',',')>
<cfset LvarFieldReady=false>
<cfset LvarFieldReadyEmpresa=false>
 
<cfif LvarGoogle>
      <cfsavecontent variable="LvarLoginJS">
        <!----- para logeo google----->
        <link href="https://fonts.googleapis.com/css?family=Roboto" rel="stylesheet" type="text/css">
        <script src="https://apis.google.com/js/client:platform.js?onload=render" async defer></script>
        <script>

          function render() {
            gapi.signin.render('customBtn', {
              'callback': 'loginFinishedCallback',
              'clientid': '<cfoutput>#googleData.clientid#</cfoutput>',
              'cookiepolicy': 'single_host_origin', 
              'scope': 'https://www.googleapis.com/auth/userinfo.email',
              'approvalprompt': '<cfif IsDefined('session.sitio.CEcodigo') and Len(trim(session.sitio.CEcodigo))>auto<cfelse>force</cfif>'
            });
          } 
        /*
         * Activado cuando el usuario acepta el inicio de sesión, cancela o cierra el
         * cuadro de diálogo de autorización.
         */
        function loginFinishedCallback(authResult) {
          if (authResult) {
            if (authResult['error'] == undefined){
              gapi.auth.setToken(authResult); // Almacena el token recuperado.
              setInfo(authResult);                     // Activa la solicitud para obtener la dirección de correo electrónico.
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
         * Cuando se completa la solicitud, se activa getEmail y recibe
         * el resultado de la solicitud.
         */
        function setInfo(e){
          document.getElementById('j_password').value=e.access_token;
          // Carga las bibliotecas oauth2 para habilitar los métodos userinfo.
          gapi.client.load('oauth2', 'v2', function() {
            var request = gapi.client.oauth2.userinfo.get();
            request.execute(getEmail);
          });
          
        }


        function getEmail(obj){console.log(obj);
          var juser = document.getElementById('j_username');
          juser.value = obj['email'];
          document.login.submit();
        } 

          (function() {
            var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
            po.src = 'https://apis.google.com/js/client:plusone.js?onload=onLoadCallback';
            var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
          })();

        </script>
      </cfsavecontent>

      <cfhtmlhead text="#LvarLoginJS#"/>

      <cfif (Not IsDefined('session.sitio.CEcodigo')) Or (Len(session.sitio.CEcodigo) EQ 0)>
        <div class="form-group">
          <label class="control-label">Empresa:</label>
          <input type="text" autofocus name="j_empresa" size="10"  maxlength="12" onFocus="this.select()" tabindex="1" class="form-control">
        </div>
        <cfset LvarFieldReadyEmpresa=true>
      </cfif>

      <div class="form-group text-center">
        <button type="button" id="customBtn" class="btn btn-danger Inicio"><strong>Iniciar sesión con Google</strong></button>
      </div>
</cfif>

<cfif LvarASP>

  <cfsavecontent variable="LvarLoginJS"> 
    <script type="text/javascript"> 
      var mostrado=false;
      function mostrarDiv(){
        $("#divLoginSOIN").toggle(500);
        $("#customBtn").remove();
        $("#showDivLoginSOIN").remove();
      }
      $( document ).ready(function() {
         $("#showDivLoginSOIN").click(mostrarDiv);
      });
    </script>
  </cfsavecontent>

  <cfhtmlhead text="#LvarLoginJS#"/>

  <cfif LvarGoogle>
    <div class="form-group text-center">
      <button type="button" id="showDivLoginSOIN" class="btn btn-info Inicio"><strong>Iniciar sesión con SOIN</strong></button>
    </div>
  </cfif>

  <div id="divLoginSOIN" <cfif LvarGoogle>style="display:none"</cfif>>
    <cfif (Not IsDefined('session.sitio.CEcodigo')) Or (Len(session.sitio.CEcodigo) EQ 0) and !LvarFieldReadyEmpresa>
      <div class="form-group">
        <label class="control-label">Empresa:</label>
        <input type="text" autofocus name="j_empresa" size="10"  maxlength="12" onFocus="this.select()" tabindex="1" class="form-control">
      </div>
    </cfif> 

    <div class="form-group">
      <label class="login">Usuario:</label>
      <input type="text" name="j_username" id="j_username" size="10" tabindex="2" onFocus="this.select()" class="form-control" >
    </div>
    <div class="form-group">
      <label class="login">Contraseña:</label>
      <input type="password" name="j_password" id="j_password"  size="10" tabindex="3" onFocus="this.select()" class="form-control" >
    </div> 
    <cfset LvarFieldReady=true>
    <div class="form-group"> 
      <a class="link" href="/cfmx/home/public/recordar.cfm" class="copy">&iexcl;Olvid&eacute; mi contrase&ntilde;a!</a>
    </div>
    <div class="form-group text-center">
      <button type="submit"  name="conectarse"  class="btn btn-info Inicio" id="conectarse"><b>INGRESAR</b></button>
    </div>
  </div> 
</cfif>

<cfif !LvarFieldReady>
  <input type="hidden" name="j_username" id="j_username">
  <input type="hidden" name="j_password" id="j_password">
  <cfset LvarFieldReady=true>
</cfif>