<!---
<cfquery name="def" datasource="#Session.DSN#">
	select 1 as dato
</cfquery>
--->
<cfset def = QueryNew("dato")>

<cfparam name="Attributes.roles" default="sif.corp,sif.ctadm,sif.ctreg,sif.proveedor,sif.usuario" type="string"> <!--- Indica los roles de los usuarios --->
<cfparam name="Attributes.Ecodigo" default="#Session.Ecodigo#" type="numeric"> <!--- Empresa de los usuarios --->

<!---
<cfparam name="Attributes.idusuario"		default="" 				type="string">  <!--- consulta por defecto --->
<cfparam name="Attributes.Usucodigo" 		default="Usucodigo"		type="string"> <!--- Codigo de Usuario --->
<cfparam name="Attributes.Nombre" 			default="Nombre" 		type="string"> <!--- Nombres de la descripción del Usuario --->
---->




<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form donde se colocará el campo --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.size" default="30" type="numeric"> <!--- Tamaño del Nombre del Usuario --->
<cfparam name="Attributes.frame" default="frUsuarios" type="string"> <!--- Feame del Usuario --->
<cfparam name="Attributes.tabindex" default="0" type="numeric"> <!--- TabIndex del Campo Editable --->
<cfparam name="Attributes.index" default="0" type="numeric"> <!--- Para cuando se va a necesitar mas de un Tag en el mismo form --->
<cfparam name="Attributes.quitar" default="" type="String"> <!--- Hilera del campo Usucodigo de Usuarios que no se deben seleccionar en la consulta --->
<cfparam name="Attributes.readonly" default="no" type="boolean"> <!--- Sólo lectura --->

<cfif Attributes.index NEQ 0>
	<cfset index = "" & Attributes.index>
<cfelse>
	<cfset index = "">
</cfif>


<!--- consultas  --->
<!--- query --->
<!---<cfif isdefined("Attributes.idusuario") and len(trim(Attributes.idusuario)) >
	<cfset queryUsuario = "rsUsucodigo_#Attributes.idusuario#">
	<cfquery name="#queryUsuario#" datasource="asp">
		select a.Usucodigo, b.Pnombre||' '||b.Papellido1||' '||b.Papellido2 as Pnombre
		from Usuario a
		inner join DatosPersonales b
		on a.datos_personales=b.datos_personales
		where a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		  and a.Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idusuario#">
	</cfquery>
</cfif>--->
<!--- query --->

<script language="JavaScript" type="text/javascript">
	// funcion F2
	function conlis_keyup_<cfoutput>#index#</cfoutput>(e) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			doConlisUsuarios<cfoutput>#index#</cfoutput>();
		}
	}


	//Levanta el Conlis
	function doConlisUsuarios<cfoutput>#index#</cfoutput>() {
		var width = 600;
		var height = 500;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		
		<cfoutput>
			var nuevo = window.open('/cfmx/sif/Utiles/ConlisUsuarios.cfm?roles=#Attributes.roles#&Ecodigo=#Attributes.Ecodigo#&f=#Attributes.form#&p1=Usucodigo#index#&p2=Ulocalizacion#index#&p3=Usulogin#index#&p4=Usunombre#index#&quitar=#Attributes.quitar#','ListaUsuarios','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
		</cfoutput>
		
		nuevo.focus();
	}
	
	function ResetUsuario<cfoutput>#index#</cfoutput>() {
		document.<cfoutput>#Attributes.form#.Usucodigo#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#.Ulocalizacion#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#.Usulogin#index#</cfoutput>.value = "";
		document.<cfoutput>#Attributes.form#.Usunombre#index#</cfoutput>.value = "";
	}
	
	function TraeUsuario<cfoutput>#index#</cfoutput>(UsuloginL) {
		window.ctl1 = document.<cfoutput>#Attributes.form#</cfoutput>.Usucodigo<cfoutput>#index#</cfoutput>;
		window.ctl2 = document.<cfoutput>#Attributes.form#</cfoutput>.Ulocalizacion<cfoutput>#index#</cfoutput>;
		window.ctl3 = document.<cfoutput>#Attributes.form#</cfoutput>.Usulogin<cfoutput>#index#</cfoutput>;
		window.ctl4 = document.<cfoutput>#Attributes.form#</cfoutput>.Usunombre<cfoutput>#index#</cfoutput>;
		
		if (UsuloginL != "") {
			var fr = document.getElementById("<cfoutput>#Attributes.frame#</cfoutput>");
			
			<cfif Attributes.quitar NEQ ''>
				fr.src = "/cfmx/sif/Utiles/sifusuarioquery.cfm?roles=<cfoutput>#Attributes.roles#</cfoutput>&Ecodigo=<cfoutput>#Attributes.Ecodigo#</cfoutput>&Usulogin="+UsuloginL+"&quitar=<cfoutput>#Attributes.quitar#</cfoutput>";
			<cfelse>
				fr.src = "/cfmx/sif/Utiles/sifusuarioquery.cfm?roles=<cfoutput>#Attributes.roles#</cfoutput>&Ecodigo=<cfoutput>#Attributes.Ecodigo#</cfoutput>&Usulogin="+UsuloginL+"&quitar=";			
			</cfif>
		} else {
			ResetUsuario<cfoutput>#index#</cfoutput>();
		}
		return true;
	}
//funcion para habilitar el F2
	function conlis_keyup_<cfoutput>#index#</cfoutput>(e) {
		var keycode = e.keyCode ? e.keyCode : e.which;
		if (keycode == 113) {<!--- El código 113 corresponde a la tecla F2 --->
			doConlisUsuarios<cfoutput>#index#</cfoutput>();
		}
	}	
</script>
<cfoutput>
<table border="0" cellspacing="0" cellpadding="0">

	<tr>

		<td>
			<input type="hidden" name="Usucodigo#index#" value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.Usucodigo#index#")>#Evaluate("Attributes.query.Usucodigo#index#")#</cfif>">
			<input type="hidden" name="Ulocalizacion#index#" value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.Ulocalizacion#index#")>#Evaluate("Attributes.query.Ulocalizacion#index#")#</cfif>">
			<input type="text"
				name="Usulogin#index#" 
				id="Usulogin#index#"
				<cfif isdefined("Attributes.query") and isdefined("Attributes.query.Usulogin#index#")>
					value="#Evaluate('Attributes.query.Usulogin#index#')#"
				</cfif>
				<cfif Attributes.readOnly>
					tabindex="-1"
					readonly
					style="border:solid 1px ##CCCCCC; background:inherit;"
				<cfelse>
					onblur="javascript: TraeUsuario#index#(this.value);"
					onkeyup="javascript:conlis_keyup_#index#(event);"				
					<cfif isDefined("Attributes.tabindex") and len(trim(Attributes.tabindex)) gt 0>
						tabindex="#Attributes.tabindex#"
					</cfif>				
					onkeyup="javascript:conlis_keyup_#index#(event);"
				</cfif>				
				>
		</td>

	    <td nowrap>
			<input type="text"
				name="Usunombre#index#" id="Usunombre#index#"
				value="<cfif isdefined("Attributes.query") and isdefined("Attributes.query.Usunombre#index#")>#Evaluate("Attributes.query.Usunombre#index#")#</cfif>" 
				size="#Attributes.size#" maxlength="80"

				tabindex="-1"
				readonly
				style="border:solid 1px ##CCCCCC; background:inherit;"
				>
		</td>
		<td>
			<cfif NOT Attributes.readOnly>
			<a href="javascript: doConlisUsuarios#index#();" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Usuarios" name="imagen" width="18" height="14" border="0" align="absmiddle"></a>
			</cfif>
		</td>

	</tr>

</table>
</cfoutput>

<cfif not isdefined("Request.UsuarioTag")>
	<iframe id="<cfoutput>#Attributes.frame#</cfoutput>" name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="display:none;"></iframe>
	<cfset Request.UsuarioTag = True>
</cfif>
