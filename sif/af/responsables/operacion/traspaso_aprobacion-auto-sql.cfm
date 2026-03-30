<cfset params = "">
<cfset params = listAppend(params,"FILTRO_AFRFINI="&FORM.FILTRO_AFRFINI,'&')>
<cfset params = listAppend(params,"FILTRO_APLACA="&FORM.FILTRO_APLACA,'&')>
<cfset params = listAppend(params,"FILTRO_DESCRIPCION="&FORM.FILTRO_DESCRIPCION,'&')>
<cfif isdefined("FORM.HFILTRO_AFRFINI") and len(trim(FORM.HFILTRO_AFRFINI))>
	<cfset params = listAppend(params,"HFILTRO_AFRFINI="&FORM.HFILTRO_AFRFINI,'&')>
</cfif>
<cfset params = listAppend(params,"HFILTRO_APLACA="&FORM.HFILTRO_APLACA,'&')>
<cfset params = listAppend(params,"HFILTRO_DESCRIPCION="&FORM.HFILTRO_DESCRIPCION,'&')>
<cfset params = listAppend(params,"PageNum_Lista="&FORM.PageNum_Lista,'&')>
<cfset params = listAppend(params,"o="&FORM.o,'&')>
<cfif isdefined("FORM.Filtro_FechasMayores") and len(trim(FORM.Filtro_FechasMayores))>
	<cfset params = listAppend(params,"Filtro_FechasMayores="&FORM.Filtro_FechasMayores,'&')>
</cfif>
<cfif isdefined("FORM.APROBAR1")>
	<cfif isdefined("FORM.CHK")>	
		<cfinvoke 
			component="sif.Componentes.AF_CambioResponsable"
			method="AprobarMasivo"
			AFTRidlist="#form.chk#"
			Aprobacion="1"/>
	<cfelse>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_ErrorDebeDefinirCualesDocumentosDeseaAprobar1ProcesoCancelado"
			Default="Error, debe definir cuales documentos desea aprobar (1), Proceso Cancelado"
			returnvariable="MSG_ErrorDebeDefinirCualesDocumentosDeseaAprobar1ProcesoCancelado"/>
			
		<cfthrow message="#MSG_ErrorDebeDefinirCualesDocumentosDeseaAprobar1ProcesoCancelado#">
	</cfif>
<cfelseif isdefined("FORM.APROBAR2")>
	<cfif isdefined("FORM.CHK")>
		<cfinvoke 
			component="sif.Componentes.AF_CambioResponsable"
			method="AprobarMasivo"
			AFTRidlist="#form.chk#"
			Aprobacion="2"/>
			
		
		<!--- Verifica mediante el parametro de la aplicación si se sigue la jerarquía
		de jefes de centros funcionales, o se hace la aprobación por medio del encargado
		del centro de custodia --->	
		<cfquery name="rsTipoAprobacion" datasource="#session.dsn#">
			select Pvalor as TAprob
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Pcodigo = 990
				and Mcodigo = 'AF'
		</cfquery>			
		<cfif rsTipoAprobacion.recordcount eq 0>
			<cfset TAprob = 0>
		<cfelse>
			<cfset TAprob = rsTipoAprobacion.TAprob>
		</cfif>		
		
		<!--- 
		      En caso de que este activado el parámetro de aprobar por 
		      el encargado del centro de custodia, se hace el pase del activo de una vez
			  sin que el empleado lo apruebe.
		--->
		<cfif isdefined("TAprob") and TAprob eq 1>
			<cfinvoke 
					component="sif.Componentes.AF_CambioResponsable"
					method="ProcesarMasivo"
					AFTRidlist="#form.chk#"
					Estado="10"/>			
		</cfif>
			
	<cfelse>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_ErrorDebeDefinirCualesDocumentosDeseaAprobar2ProcesoCancelado"
			Default="Error, debe definir cuales documentos desea aprobar (2), Proceso Cancelado"
			returnvariable="MSG_ErrorDebeDefinirCualesDocumentosDeseaAprobar2ProcesoCancelado"/>
		
		<cfthrow message="#MSG_ErrorDebeDefinirCualesDocumentosDeseaAprobar2ProcesoCancelado#">
	</cfif>
<cfelseif isdefined("FORM.RECHAZAR1") or isdefined("FORM.RECHAZAR2")>
	<cfif isdefined("FORM.CHK")>
		<cfinvoke 
			component="sif.Componentes.AF_CambioResponsable"
			method="RechazarMasivo"
			AFTRidlist="#form.chk#"
			Estado="20"/>
	<cfelse>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_ErrorDebeDefinirCualesDocumentosDeseaRechazarProcesoCancelado"
			Default="Error, debe definir cuales documentos desea Rechazar, Proceso Cancelado"
			returnvariable="MSG_ErrorDebeDefinirCualesDocumentosDeseaRechazarProcesoCancelado"/>
			
		<cfthrow message="#MSG_ErrorDebeDefinirCualesDocumentosDeseaRechazarProcesoCancelado#">
	</cfif>
</cfif>
<cflocation url="traspaso_aprobacion-auto.cfm?#params#">

