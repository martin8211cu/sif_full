
<cfparam default="minisif" name="session.DSNnuevo">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Insertado de datos en empresa de demostraciones</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body style="margin:0">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr> 
			<td>
				<table width="50%" style="border:1px solid black;" align="center"> 
					<tr><td>
						<!---Tabla de una columna que va a ir aumentando el with dinámicamente por medio de un llamado de una funcion de javascript----->
						<table width="0%" id="pct2" bgcolor="#0066CC"><tr><td>&nbsp;</td></tr></table>
					</td></tr>
				</table>
			</td>
		</tr>
	</table>		
	<table width="100%" cellpadding="0" cellspacing="0" align="center">
		<tr><td>
			<table width="50%" align="center"> 
				<tr><td nowrap align="center">
					<!---Etiqueta de avance del proceso--->
					<span id="paso" style=" font-size:11px">Cargando datos... </span><span id="percent">0</span>
				</td></tr>
			</table>
		</td></tr>								
	</table>
	
	<script language='javascript' type='text/JavaScript'>
		var total = 100;//Valor máximo al que se puede llegar		
		function funcDevuelveObjeto(elid){
			return document.all?document.all[elid]:document.getElementById(elid);//devuelve el objeto
		}
		
		function funcAvance(n) {
			var percent = 0;
			percent = Math.floor(n * 100 / total);						//Obtiene el porcentaja
			funcDevuelveObjeto('pct2').width = " " + percent + "%"; 	//Aumenta el with del td (columna) 
			funcDevuelveObjeto('percent').innerHTML = percent + " % ";	//Pinta el porcentaje de avance dinamicamente
			
			if (n == 100){ 												//Cuando se ha llegado al tope
				funcDevuelveObjeto('paso').innerHTML = 'La carga de datos ha finalizado con éxito...';	//Pinta etiqueta de finalización
				funcDevuelveObjeto('percent').innerHTML = '';												
				setTimeout("window.parent.document.goSQL.submit()",5000);	//Envia al menú
			} ///window.parent.location.href ='clonacion-sql.cfm'
		}
	</script>
	<cfflush interval="1">
	
	<cfsetting requesttimeout="8600">

<cftry>	
	<cfset vn_Ecodigo = 1097>

	<cftransaction>
		<cfset Avance = 0>
		<cfset incremeto = Round(100 / arraylen(session.fuenteArray))>	<!--- % incremento = 100 / total de fuenes a ejecutar--->
		
		<cfloop  from="1" to="#arraylen(session.fuenteArray)#" index="i">
			
			<!---CODIGO FUENTE A EJECUTAR--->
			<!---<cfdump var="#evaluate('session.fuenteArray[i]')#">--->
			<cfoutput>#evaluate('session.fuenteArray[i]')#</cfoutput>
			<!--- --->
			
			<!---AVANCE DE LA BARRA--->
			<script type="text/javascript" language="javascript1.2">
				<cfoutput>
					var avan = '#Avance#';
					funcAvance(avan);
				</cfoutput>
			</script>
			<cfdump var=" ">
			<!------>
			
			
			<!---<cfif isdefined('session.Debug') and session.Debug>		<!---si se activa el modo debug--->
				<cfdump var="#session.fuenteArray[i]#"> <br><br><br>
			</cfif>--->
			
			<cfset Avance = Avance + incremeto>
		</cfloop>
		
		<script type="text/javascript">								<!---lleva al 100% a la barra--->
			funcAvance(100);
		</script>
		<center>
			<input name="Comprimir" value="Comprimir" type="button" <cfif isdefined('url.func') and len(trim(url.func))>onClick="<cfoutput>parent.#url.func#()</cfoutput>"</cfif>>
			<input name="Continuar" value="Continuar" type="button" <cfif isdefined('url.func2') and len(trim(url.func2))>onClick="<cfoutput>parent.#url.func2#()</cfoutput>"</cfif>>
		</center>
	</cftransaction>

	<cfcatch type="any">
		<cfdump var="#cfcatch#">
		<div align="center">
			Ha ocurrido un error en el proceso de carga de datos. Intentelo de nuevo.<br>
			<cfoutput>#cfcatch.message#</cfoutput>
			<cfoutput>#cfcatch.Detail#</cfoutput>
			<br><a target="_parent" href='' style="color:#003399"><b>Ir a lista de Solicitudes de Demo</b></a>
		</div>
		<cfabort>	
	</cfcatch>
</cftry>
</body>
</html>
