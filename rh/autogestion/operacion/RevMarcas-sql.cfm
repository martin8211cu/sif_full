<!----=========== Autorizacion de marcas =============---->
<cfif isdefined("form.btnAutorizar")>
	<cfquery datasource="#session.DSN#">
		update RHControlMarcas set
			registroaut = 1,
			fechahoraautorizado = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			usuarioautor = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHCMid in (#form.chk#)
	</cfquery>
<!---================ Ajustar marcas ===============---->
<cfelseif isdefined("form.btnAjustar")>
	<!---NOTA: La fecha de de la hora planificada RHCMhoraplan tiene que ser igual a la fecha de la marca fechahoramarca---->
	<cfquery datasource="#session.DSN#">
		update RHControlMarcas set
			fechahoramarca = coalesce(RHCMhoraplan,fechahoramarca)
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHCMid in (#form.chk#)
	</cfquery>
</cfif>
<cfoutput>
	<form name="form1" action="RevMarcas-tabs.cfm" method="post">		
		<cfif isdefined("form.chkTodos")>
			<input type="hidden" name="Todos" value="1">
		</cfif>
		<input type="hidden" name="btnFiltrar" value="btnFiltrar">	
		<input type="hidden" name="chk" value="#form.chk#">	
		<input type="hidden" name="FDEid" value="<cfif isdefined("form.FDEid") and len(trim(form.FDEid))>#form.FDEid#</cfif>">		
		<input type="hidden" name="FDEIdentificacion" value="<cfif isdefined("form.FDEIdentificacion") and len(trim(form.FDEIdentificacion))>#form.FDEIdentificacion#</cfif>">
		<input type="hidden" name="FNombre" value="<cfif isdefined("form.FNombre") and len(trim(form.FNombre))>#form.FNombre#</cfif>">
		<input type="hidden" name="Grupo" value="<cfif isdefined("form.Grupo") and len(trim(form.Grupo))>#form.Grupo#</cfif>">
		<input type="hidden" name="ver" value="<cfif isdefined("form.ver") and len(trim(form.ver))>#form.ver#</cfif>">
		<input type="hidden" name="Inicio_h" value="<cfif isdefined("form.Inicio_h") and len(trim(form.Inicio_h))>#form.Inicio_h#</cfif>">	
		<input type="hidden" name="Inicio_m" value="<cfif isdefined("form.Inicio_m") and len(trim(form.Inicio_m))>#form.Inicio_m#</cfif>">	
		<input type="hidden" name="Inicio_s" value="<cfif isdefined("form.Inicio_s") and len(trim(form.Inicio_s))>#form.Inicio_s#</cfif>">	
		<input type="hidden" name="Fin_h" value="<cfif isdefined("form.Fin_h") and len(trim(form.Fin_h))>#form.Fin_h#</cfif>">	
		<input type="hidden" name="Fin_m" value="<cfif isdefined("form.Fin_m") and len(trim(form.Fin_m))>#form.Fin_m#</cfif>">	
		<input type="hidden" name="Fin_s" value="<cfif isdefined("form.Fin_s") and len(trim(form.Fin_s))>#form.Fin_s#</cfif>">
		<input type="hidden" name="TipoMarca" value="<cfif isdefined("form.TipoMarca") and len(trim(form.TipoMarca))>#form.TipoMarca#</cfif>">
		<input type="hidden" name="fechaInicio" value="<cfif isdefined("form.fechaInicio") and len(trim(form.fechaInicio))>#form.fechaInicio#</cfif>">
		<input type="hidden" name="fechaFinal" value="<cfif isdefined("form.fechaFinal") and len(trim(form.fechaFinal))>#form.fechaFinal#</cfif>">
		<input type="hidden" name="ordenarpor" value="<cfif isdefined("form.ordenarpor") and len(trim(form.ordenarpor))>#form.ordenarpor#</cfif>">
		<input type="hidden" name="Estado" value="<cfif isdefined("form.Estado") and len(trim(form.Estado))>#form.Estado#</cfif>">	
	</form>
</cfoutput>
<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>
