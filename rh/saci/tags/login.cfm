<cfparam 	name="Attributes.idpersona"	type="string"	default="">						<!--- Id de Persona (es Obligatorio) --->
<cfparam 	name="Attributes.loginid"	type="string"	default="">						<!--- Id de Login --->
<cfparam 	name="Attributes.value"		type="string"	default="">						<!--- Nombre de Login --->
<cfparam 	name="Attributes.form" 		type="string"	default="form1">				<!--- nombre del formulario --->
<cfparam 	name="Attributes.sufijo" 	type="string"	default="">						<!--- sufijo a agregar en todos los campos, se usa en caso de que se use varias veces el mismo tag en la misma pantalla --->
<cfparam 	name="Attributes.Ecodigo" 	type="string"	default="#Session.Ecodigo#">	<!--- código de empresa --->
<cfparam 	name="Attributes.Conexion" 	type="string"	default="#Session.DSN#">		<!--- cache de conexion --->
<cfparam 	name="Attributes.size" 		type="string"	default="18">		<!--- cache de conexion --->

<cfif not (isdefined("Attributes.idpersona") and Len(Trim(Attributes.idpersona)))>
	<cfthrow message="ERROR: Para utilizar el Tag de Login debe enviarse el Id de Persona">
</cfif>

<cfset ExisteLogin = isdefined("Attributes.loginid") and Len(Trim(Attributes.loginid))>

<cfinvoke component="saci.comp.ISBparametros" method="Get" returnvariable="PG_caracteresValidos">
	<cfinvokeargument name="Pcodigo" value="50">
</cfinvoke>

<cfoutput>
	<cfinvoke component="home.Componentes.Politicas" method="trae_parametros_cuenta" returnvariable="data" CEcodigo="#session.CEcodigo#"/>
	
	<table border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td>
				<input type="hidden" name="LGnumero#Attributes.sufijo#" value="<cfif ExisteLogin>#Attributes.loginid#</cfif>" />
				<input type="hidden" name="LoginAnt#Attributes.sufijo#" id="LoginAnt#Attributes.sufijo#" value="#Attributes.value#" />&nbsp;
				<input type="text" name="Login#Attributes.sufijo#" id="Login#Attributes.sufijo#" size="#Attributes.size#" 
					maxlength="16" value="#Attributes.value#"
					 onclick="javascript: LimpiarImagenes#Attributes.sufijo#()" 
					 onchange="javascript: validar_login#Attributes.sufijo#(document.#Attributes.form#.Login#Attributes.sufijo#.value,'')" 	
					 height=""="javascript: validar_login#Attributes.sufijo#(document.#Attributes.form#.Login#Attributes.sufijo#.value,'')" 			
					 <!---onblur="javascript: validar_login#Attributes.sufijo#(); set_indicadores#Attributes.sufijo#(0);"---> 
					tabindex="1"/>&nbsp;
			</td>
			<td>
				<a href="javascript: validar_login#Attributes.sufijo#(document.#Attributes.form#.Login#Attributes.sufijo#.value,'');" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"><img src="/cfmx/saci/images/verificar.png" title="Validar Login" border="0" align="absmiddle"></a>&nbsp;
			</td>
			<td nowrap id="TdEspacio#Attributes.sufijo#" width="24" height="18">&nbsp;</td>
			<td nowrap>
				<img src="/cfmx/saci/images/Borrar01_S.gif" 	name="img_login_mal#Attributes.sufijo#"		id="img_login_mal#Attributes.sufijo#" 	width="16" height="18" border="0" title="Login Inválido" style="display:none">
				<img src="/cfmx/saci/images/check-verde.gif" 	name="img_login_ok#Attributes.sufijo#" 		id="img_login_ok#Attributes.sufijo#" 	width="20" height="18" border="0" title="Login Válido"	<cfif not ExisteLogin> style="display:none"</cfif>>
				<img src="/cfmx/saci/images/blank.gif" 			name="img_login_blank#Attributes.sufijo#" 	id="img_login_blank#Attributes.sufijo#" width="20" height="18" border="0"	<cfif ExisteLogin> style="display:none"</cfif>>
			</td>
		</tr>
	</table>
	
	
	<script language="javascript" type="text/javascript">
		function o(s){
			return document.all ? document.all[s] : document.getElementById(s);
		}
		
		function LimpiarImagenes#Attributes.sufijo#(){
			o('img_login_ok#Attributes.sufijo#').style.display = 'none';
			o('img_login_mal#Attributes.sufijo#').style.display = 'none';
		}
		
		function validar_login#Attributes.sufijo#(u, l) {
		
			var div = o('div_test_msg');
			var valida = validarPassword(u, l);
			<!---o('img_login_ok#Attributes.sufijo#').style.display = !valida.erruser.length ? '' : 'none';
			o('img_login_mal#Attributes.sufijo#').style.display = valida.erruser.length ? '' : 'none';--->
			
			o('img_login_ok#Attributes.sufijo#').style.display = 'none';
			o('img_login_mal#Attributes.sufijo#').style.display = 'none';
			
			if((document.getElementById("img_login_ok#Attributes.sufijo#").style.display == '') || (document.getElementById("img_login_mal#Attributes.sufijo#").style.display == '') )
				document.getElementById("TdEspacio#Attributes.sufijo#").style.display = 'none';
			else document.getElementById("TdEspacio#Attributes.sufijo#").style.display = 'none';
			
			if(valida.erruser.length != 0){ 
				alert(valida.erruser);
			}
			else{

				var dato = document.#Attributes.form#.Login#Attributes.sufijo#.value.replace(/^\s+|\s+$/g, '');
				if (!dato.match("[^#Trim(data.user.valid.chars)#]")) {
					var params = "?sufijo=#Attributes.sufijo#&login="+dato;
					<cfif ExisteLogin>params += "&loginid="+document.#Attributes.form#.LGnumero#Attributes.sufijo#.value;
					</cfif>
					var fr = document.getElementById("frValLogin#Attributes.sufijo#");
					fr.src = "/cfmx/saci/utiles/chkLogin.cfm"+params;
					
				}
			}	
		}

		var NuevoLoginWindow#Attributes.sufijo#=null;
		function closeNuevoLoginWindow#Attributes.sufijo#() {
			NuevoLoginWindow#Attributes.sufijo#.close();
		}

		function doConlisChgLogin#Attributes.sufijo#() {
			var width = 350;
			var height = 150;
			var top = (screen.height - height) / 2;
			var left = (screen.width - width) / 2;
			
		 	if(NuevoLoginWindow#Attributes.sufijo#){
				if(!NuevoLoginWindow#Attributes.sufijo#.closed) NuevoLoginWindow#Attributes.sufijo#.close();
		  	}
			
			params = "?f=#Attributes.form#&sufijo=#Attributes.sufijo#&Pquien=#Attributes.idpersona#&LGnumero="+document.#Attributes.form#.LGnumero#Attributes.sufijo#.value+"&validCaracts=#data.user.valid.chars#";					  	
			NuevoLoginWindow#Attributes.sufijo# = open("/cfmx/saci/utiles/conlisChgLogin.cfm"+params, "NuevoLogin", "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width="+width+",height="+height+",left="+left+", top="+top+",screenX="+left+",screenY="+top);
		  	if (! NuevoLoginWindow#Attributes.sufijo# && !document.popupblockerwarning) {
				alert('Aviso: Su bloqueador de ventanas emergentes (popup blocker) \nestá evitando que se abra la ventana.\nPor favor revise las opciones de su navegador (browser), y \nacepte las ventanas emergentes de este sitio: ' + location.hostname);
				document.popupblockerwarning = 1;
		  	}
			NuevoLoginWindow#Attributes.sufijo#.focus();
			window.onfocus = closeNuevoLoginWindow#Attributes.sufijo#;
		}
		
		function AsignarLogin#Attributes.sufijo#(login) {
			document.#Attributes.form#.Login#Attributes.sufijo#.value = login;
			validar_login#Attributes.sufijo#(login,'');
		}
	</script>
	
	<cfinvoke component="home.Componentes.ValidarPassword" method="javascript" data="#data#"/>
	
	<iframe id="frValLogin#Attributes.sufijo#" name="frValLogin#Attributes.sufijo#" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>
	
</cfoutput>
