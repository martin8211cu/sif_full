<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 		default="#Session.DSN#"	type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 			default="form1" 		type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.idempleado"		default="" 				type="string">  <!--- consulta por defecto --->
<cfparam name="Attributes.DEid" 			default="DEid" 			type="string"> <!--- Codigo de Empleado --->
<cfparam name="Attributes.Usucodigo" 		default="Usucodigo"		type="string"> <!--- Codigo de Usuario --->
<cfparam name="Attributes.Nombre" 			default="Nombre" 		type="string"> <!--- Nombres de la descripción del empleado --->
<cfparam name="Attributes.Pid" 				default="Pid" 			type="string"> <!--- Nombres de la descripción del empleado --->
<cfparam name="Attributes.frame" 			default="frempleado"	type="string"> <!--- Nombre del frame --->
<cfparam name="Attributes.FuncJSalAbrir" 	default="" 				type="string"> <!--- función .js antes de ejecutar la consulta --->
<cfparam name="Attributes.FuncJSalCerrar"	default="" 				type="string"> <!--- función .js después de ejecutar la consulta --->
<cfparam name="Attributes.tabindex" 		default="" 				type="string"> <!--- Tabindex del campo editable --->
<cfparam name="Attributes.conlis" 			default="true" 			type="boolean"> <!--- muestra conlis o no --->


<!--- consultas --->
<!--- query --->
<cfif isdefined("Attributes.idempleado") and len(trim(Attributes.idempleado)) >
	<cfset queryDEid = "rsDEid_#Attributes.idempleado#">
	<cfquery name="#queryDEid#" datasource="#session.DSN#">
		select DEid, DEidentificacion, DEnombre ||' '|| DEapellido1 ||' '|| DEapellido2 as DEnombre 
		from DatosEmpleado 
		where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idempleado#">
		and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

	<cfset queryUsuario = "rsUsucodigo_#Attributes.idempleado#">
	<cfquery name="#queryUsuario#" datasource="asp">
		select Usucodigo
		from UsuarioReferencia
		where STabla='DatosEmpleado'
		  and Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
		  and llave=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.idempleado#">
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
	
	function doConlisEmpleado<cfoutput>#Attributes.DEid#</cfoutput>() {
		<cfoutput>#Attributes.FuncJSalAbrir#</cfoutput>;
		var params ="";
		params = "<cfoutput>?formulario=#Attributes.form#&DEid=#Attributes.DEid#&Usucodigo=#Attributes.Usucodigo#&Nombre=#Attributes.Nombre#&Pid=#Attributes.Pid#</cfoutput>";
		<cfif Len(Trim("<cfoutput>#Attributes.FuncJSalCerrar#</cfoutput>")) GT 0 > 
			params = params + "<cfoutput>&FuncJSalCerrar=#Attributes.FuncJSalCerrar#</cfoutput>";
		</cfif>	
		popUpWindow("/cfmx/sif/Utiles/ConlisEmpleados.cfm"+params,250,200,650,400);
	}
</script>

<table border="0" cellspacing="0" cellpadding="0">
	<cfoutput>
	<tr>
		<td nowrap>
			<input type="text" name="#Attributes.Pid#" id="#Attributes.Pid#" maxlength="50" size="10" readonly value="<cfif isdefined("Attributes.idempleado") and len(trim(Attributes.idempleado)) >#Trim(Evaluate(queryDEid).DEidentificacion)#</cfif>">		
		</td>
		<td nowrap>
			<input type="text" name="#Attributes.Nombre#" id="#Attributes.Nombre#" maxlength="255" size="30" readonly 
				   value="<cfif isdefined("Attributes.idempleado") and len(trim(Attributes.idempleado)) >#Trim(Evaluate(queryDEid).DEnombre)#</cfif>" >
			<cfif Attributes.Conlis><a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Empleados" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlisEmpleado#Attributes.DEid#();'></a></cfif>
		</td>
		
	</tr>
	<input type="hidden" name="#Attributes.DEid#" id="#Attributes.DEid#" value="<cfif isdefined("Attributes.idempleado") and len(trim(Attributes.idempleado)) >#Trim(Evaluate(queryDEid).DEid)#</cfif>">
	<input type="hidden" name="#Attributes.Usucodigo#" id="#Attributes.Usucodigo#" value="<cfif isdefined("Attributes.idempleado") and len(trim(Attributes.idempleado)) >#Trim(Evaluate(queryUsuario).Usucodigo)#</cfif>">
	
	</cfoutput>
</table>
<iframe name="<cfoutput>#Attributes.frame#</cfoutput>" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" ></iframe>
