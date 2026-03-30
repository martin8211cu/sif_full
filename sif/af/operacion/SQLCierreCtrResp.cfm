<cfsetting requesttimeout="3600">
<cfset Session.debug = false>
<cfif isdefined("Form.btnCierre")>
		
	<!--- Verifica si el parámetro existe en la aplicación (Control de Transacciones) --->
	<cfquery datasource="#Session.DSN#" name="ValorParam">
		Select Pvalor 
		from Parametros 
		where Pcodigo=970 
		  and Ecodigo =  #session.Ecodigo# 
	</cfquery>
	
	<!--- 
		Estados del Parámetro 970 - Control de Transacciones provenientes de AF.
			0. Control Desactivado => Indica que las transacciones de CR se aplicarán directo a AF y Conta.
			1. Control Activado => Indica que las transacciones de CR se quedaran en cola
			2. Cola procesado => Indica que hay transaccioens en cola en proceso de aplicación a AF y Conta
	--->
	<cfif ValorParam.recordcount gt 0>

		<!--- 
			- Si el parámetro no existe del todo, asume que no hay control sobre las transacciones
			provenientes de control de responsables.
			- En caso de estar el parámetro en 0(sin control), se cambiará a 1 (Activando Control de Transacciones).
			- En caso de estar el parámetro en 1(control de transacciones activado), se pasa a 0 (sin control).
			- En caso de que el parámetro este en 2, no se modifica, porque ocurrieron errores durante el procesamiento en 
			alguna de las transacciones.
		--->
		<cfif ValorParam.Pvalor eq 0>
			<cfset nuevo_valor = 1>
		<cfelseif ValorParam.Pvalor eq 1>
			<cfset nuevo_valor = 0>	
		<cfelse>	
			<cfset nuevo_valor = 2>	
		</cfif>

		<!--- 
			  Si la acción que el usuario esta haciendo es abrir de nuevo AF 
			  o la cola presentó errores y esta en 2, se debe procesar lo que 
			  hay en cola.
		 --->
		<cfif nuevo_valor eq 0 or nuevo_valor eq 2>
		
			<cfquery datasource="#Session.DSN#">
				UPDATE Parametros
				set Pvalor = '2'
				where Pcodigo=970 
				  and Ecodigo =  #session.Ecodigo# 	
			</cfquery>	
			
			
			<!--- Llama al componente de procesamiento de la cola --->
			<cfinvoke
				component="sif.Componentes.AF_ControldeCola"
				method="ProcesarCola">
				<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#"/>
				<cfinvokeargument name="DSN" value="#session.dsn#"/>
				<cfinvokeargument name="Usucodigo" value="#session.Usucodigo#"/>
			</cfinvoke>
			
		<cfelse>
			
			<cfquery datasource="#Session.DSN#">
				UPDATE Parametros
				set Pvalor = '1'
				where Pcodigo=970 
				  and Ecodigo =  #session.Ecodigo# 	
			</cfquery>	
				<script language="javascript" type="text/javascript">
					alert("El Control de Transacciones de Activos Fijos se ha Activado con Exito");
				</script>
		</cfif>

		<cfset showMessage="true">
<cfelse>
	<cfquery name="rs_InsertaParametro" datasource="#Session.DSN#">
		  insert into Parametros (
				Ecodigo, 
				Pcodigo, 
				Mcodigo, 
				Pdescripcion, 
				Pvalor
				)
		  values (
				#session.Ecodigo#, 
				970,
				'AF',
				'Control de Transacciones de Control de Responsables', 
				'1'
				)
	 </cfquery>

	</cfif>

</cfif>


<form action="CierreCtrResp.cfm" method="post" name="sql">
	<cfif isdefined("showMessage")>
		<input name="showMessage" type="hidden" value="true">
	</cfif>	
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

