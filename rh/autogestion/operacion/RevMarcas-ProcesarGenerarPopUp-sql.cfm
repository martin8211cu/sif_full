<!--- INVOCACIÓN MANUAL DEL PROCESO DE GENERACIÓN DE MARCAS  --->
<!--- se redefine el tiempo máximo para que responda el request a 3600 segundos  --->
<cfsetting requesttimeout="3600">
<!--- envía al usuario un mensaje para que tenga paciencia y espere a que el proceso termine  --->
<cf_PleaseWait SERVER_NAME="/cfmx/rh/autogestion/operacion/RevMarcas-ProcesarGenerarPopUp-sql.cfm" >
<!--- invocación del componente  --->
<cfinvoke 
	component="rh.Componentes.RH_ProcesoGeneraMarcas" 
	method="RH_ProcesoGeneraMarcas">
	<cfif isdefined("Form.FAGrupo") and len(trim(Form.FAGrupo)) gt 0>
		<cfinvokeargument name="Gid" value="#Form.FAGrupo#">
	</cfif>
	<cfif isdefined("Form.FADEid") and len(trim(Form.FADEid)) gt 0>
		<cfinvokeargument name="DEid" value="#Form.FADEid#">
	</cfif>
	<cfif isdefined("Form.FAfechaFinal") and len(trim(Form.FAfechaFinal)) gt 0>
		<cfinvokeargument name="fechaFin" value="#Form.FAfechaFinal#">
	</cfif>
</cfinvoke>
<!--- se actualiza la pantalla padre y se cierra la ventana emergente  --->
<script type="text/javascript" language="javascript1.2">	
	window.opener.document.form3.submit();
	window.close();
</script>