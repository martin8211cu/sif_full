<!---
	Creado por Gustavo Fonseca HernÃ¡ndez.
		Fecha: 14-12-2005.
		Motivo: Nuevo proceso de ReclasificaciÃ³n de Cuentas.
--->

 <!--- <cfdump var="#form#">
<cf_dump var="#url#"> --->


	<cfinvoke returnvariable="rs_Res" component="sif.Componentes.CC_ReclasificacionCuentas" method="reclasificacionCuentas">
		<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#">
		<cfinvokeargument name="SNcodigo" value="#form.SNcodigo#">
		<cfinvokeargument name="Ccuentanue" value="#form.Ccuenta#">
		
		<cfif isdefined("form.ID_DIRECCIONENVIO") and len(trim(form.ID_DIRECCIONENVIO))>
			<cfinvokeargument name="id_direccion" value="#form.ID_DIRECCIONENVIO#">
		</cfif>
		<cfif isdefined("form.Ocodigo") and len(trim(form.Ocodigo))>
			<cfinvokeargument name="Ocodigo" value="#form.Ocodigo#">
		</cfif>
		<cfif isdefined("form.antiguedad") and len(trim(form.antiguedad))>
			<cfinvokeargument name="antiguedad" value="#form.antiguedad#">
		</cfif>
		<cfif isdefined("form.Ccuenta2") and len(trim(form.Ccuenta2))>
			<cfinvokeargument name="Ccuentaant" value="#form.Ccuenta2#">
		</cfif>
		<cfif isdefined("form.CCTcodigo") and Len(Trim(form.CCTcodigo))>
			<cfinvokeargument name="CCTcodigo" value="#form.CCTcodigo#">
		</cfif>

		<cfif not (( isdefined("form.Ocodigo") and len(trim(form.Ocodigo)) eq 0 ) or ( isdefined("form.CCTcodigo") and Len(Trim(form.CCTcodigo)) eq 0 ) or ( isdefined("form.ID_DIRECCIONENVIO") and len(trim(form.ID_DIRECCIONENVIO)) eq 0 ))>
			<cfif isdefined("form.Documento") and Len(Trim(form.Documento))>
				<cfinvokeargument name="Ddocumento" value="#form.Documento#">
			</cfif>
		</cfif>	

		<cfinvokeargument name="debug" value="false">
		<cfinvokeargument name="usuario" value="#session.Usucodigo#">	<!--- Usuario --->
	</cfinvoke>			

<cflocation addtoken="no" url="ReclasificacionCuenta.cfm">
	
	
