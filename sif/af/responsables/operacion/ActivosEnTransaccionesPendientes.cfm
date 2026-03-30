<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Activos en Transacciones Pendientes de Aplicar'>
	<cfsetting requesttimeout="3600">
	<cfif not isdefined('form.CFid') and isdefined('url.CFid')>
		<cfset form.CFid = url.CFid>
	</cfif>
	<cfif not isdefined('form.Aplaca') and isdefined('url.Aplaca')>
		<cfset form.Aplaca = url.Aplaca>
	</cfif>
	<cfset filtro = "">
	<cfif isDefined("form.CFid") and len(trim(form.CFid))>
		<cfset filtro = filtro & " and re.CFid = #form.CFid#">
	</cfif>
	<cfif isDefined("form.Aplaca") and len(trim(form.Aplaca))>
		<cfset filtro = filtro & "  and lower(a.Aplaca) like lower('%#form.Aplaca#%')">
	</cfif>
	<cfif isDefined("form.DEid") and len(trim(form.DEid))>
		<cfset filtro = filtro & "  and re.DEid = #form.DEid#">
	</cfif>
	
	<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
	<cfoutput>	
	<cfinvoke 
		component="sif.Componentes.pListas" 
		method="pLista" 
		returnvariable="Lvar_Lista" 
		columnas="a.Adescripcion,
				a.Aplaca ,  
				tr.AFTdes,
				d.DEnombre #_Cat# ' ' #_Cat# d.DEapellido1 #_Cat# ' ' #_Cat# d.DEapellido2  as responsable"
		tabla=" AFResponsables re
			inner join  Activos a
				on a.Aid = re.Aid
			inner join DatosEmpleado d
				on d.DEid = re.DEid
			inner join ADTProceso pr
				on pr.Ecodigo = a.Ecodigo 
				and pr.Aid = a.Aid
			inner join AFTransacciones tr
				on tr.IDtrans = pr.IDtrans"
		filtro="a.Ecodigo = #Session.Ecodigo# #filtro# order by Aplaca"
		desplegar="Aplaca, Adescripcion, AFTdes,  responsable"
		etiquetas="Placa, Descripci&oacute;n, Tipo de Transacción, Responsable"
		filtrar_por="a.Aplaca, a.Adescripcion, tr.AFTdes, d.DEnombre #_Cat# ' ' #_Cat# d.DEapellido1 #_Cat# ' ' #_Cat# d.DEapellido2"
		cortes=""
		maxrows="25"
		formatos="S,S,S,S"
		align="left,left,left,left"
		mostrar_filtro="true"
		filtrar_automatico="true"
		showemptylistmsg="true"
		emptylistmsg=" --- No se encontraron Documentos --- "
		ira=""
		checkboxes="N"
		keys="Aplaca"
		incluyeform="true"
		formname="form1"
		showlink="false"
		ajustar="N"
		/>	
		</cfoutput>
		<cf_web_portlet_end>
