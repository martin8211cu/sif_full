<cfset titulo = 'Detalle de Anticipos a Generar'>
<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	<cfquery datasource="#session.dsn#" name="listaDet">
		Select TESSPid,TESDPid
				,TESDPdescripcion as Descripcion
				,TESDPmontoSolicitadoOri as Monto
			<cfif isdefined("form.chkCancelados")>
				, 1 as chkCancelados
			</cfif>
		  from TESdetallePago dp
			left outer join CFinanciera cf
				on cf.CFcuenta=dp.CFcuentaDB
				and cf.Ecodigo=dp.EcodigoOri
			left outer join Oficinas o
				on o.Ecodigo=dp.EcodigoOri
				and o.Ocodigo = dp.OcodigoOri
		 where EcodigoOri=#session.Ecodigo#
		   and TESSPid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
	</cfquery>
	
	<cfif isdefined("LvarIncluyeForm") and LvarIncluyeForm>
		<cfset LvarIncluyeForm = "yes">
	<cfelse>
		<cfset LvarIncluyeForm = "no">
	</cfif>
	<cfif isdefined("LvarMnombreSP")>
		<cfset LvarMonedaTitulo = "Monto Solicitado<BR>#replace(LvarMnombreSP,",","-","ALL")#">
	<cfelse>
		<cfset LvarMonedaTitulo = "Monto Solicitado">
	</cfif>
	
	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
		query="#listaDet#"
		desplegar="Descripcion, Monto"
		etiquetas="Descripci&oacute;n, #LvarMonedaTitulo#"
		formatos="S,M"
		align="left,right"
		ira="solicitudesCPanticipos.cfm"
		form_method="post"	
		showEmptyListMsg="yes"
		keys="TESDPid"
		incluyeForm="#LvarIncluyeForm#"
		showLink="#LvarIncluyeForm#"
		maxRows="0"
	/>							

	<cf_web_portlet_end>
