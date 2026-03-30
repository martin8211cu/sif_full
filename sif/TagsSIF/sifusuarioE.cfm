<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 		default="#Session.DSN#"	type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 			default="form1" 		type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.idusuario"		default="" 				type="string">  <!--- consulta por defecto --->
<cfparam name="Attributes.Usucodigo" 		default="Usucodigo"		type="string"> <!--- Codigo de Usuario --->
<cfparam name="Attributes.Nombre" 			default="Nombre" 		type="string"> <!--- Nombres de la descripción del Usuario --->
<cfparam name="Attributes.frame" 			default="frusuario"		type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.FuncJSalAbrir" 	default="" 				type="string"> <!--- función .js antes de ejecutar la consulta --->
<cfparam name="Attributes.FuncJSalCerrar"	default="" 				type="string"> <!--- función .js después de ejecutar la consulta --->
<cfparam name="Attributes.tabindex" 		default="" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.size" 			default="30" 			type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.conlis" 			default="true" 			type="boolean"> <!--- muestra conlis o no --->

<!--- consultas --->
<!--- query --->
<cfif isdefined("Attributes.idusuario") and len(trim(Attributes.idusuario)) >
	<cfset queryUsuario = "rsUsucodigo_#Attributes.idusuario#">
	<cfquery name="#queryUsuario#" datasource="asp">
		select a.Usucodigo, 
			{fn concat( {fn concat( {fn concat( {fn concat(
				b.Pnombre,' ')},b.Papellido1)},' ')},b.Papellido2 )} as Pnombre
		from Usuario a
		inner join DatosPersonales b
		on a.datos_personales=b.datos_personales
		where a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		  and a.Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idusuario#">
	</cfquery>
</cfif>
<!--- query --->

<script language="JavaScript">
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin) {
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	function doConlisUsuario<cfoutput>#Attributes.Usucodigo#</cfoutput>() {
		<cfoutput>#Attributes.FuncJSalAbrir#</cfoutput>;
		var params ="";
		params = "<cfoutput>?formulario=#Attributes.form#&Usucodigo=#Attributes.Usucodigo#&Nombre=#Attributes.Nombre#</cfoutput>";
		<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
			params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
		</cfif>	
		popUpWindow("/cfmx/sif/Utiles/ConlisUsuariosE.cfm"+params,95,190,830,400);
	}
</script>

<table border="0" cellspacing="0" cellpadding="0">
	<cfoutput>
	<tr>
		<td nowrap>
			<input tabindex="-1" type="text" name="#Attributes.Nombre#" id="#Attributes.Nombre#" maxlength="255" size="#Attributes.size#" readonly 
				   value="<cfif isdefined("Attributes.idusuario") and len(trim(Attributes.idusuario)) >#Trim(Evaluate(queryUsuario).Pnombre)#</cfif>" >
			<cfif Attributes.conlis><a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Usuarios" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlisUsuario#Attributes.Usucodigo#();'></a></cfif>
		</td>
	</tr>
	<input type="hidden" name="#Attributes.Usucodigo#" id="#Attributes.Usucodigo#" value="<cfif isdefined("Attributes.idusuario") and len(trim(Attributes.idusuario)) >#Trim(Evaluate(queryUsuario).Usucodigo)#</cfif>">
	</cfoutput>
</table>
<iframe name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" ></iframe>