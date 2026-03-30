<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso">
<cfif isdefined('form.Recalcular')>
	<!---Proceso nuevo para recalculas las horas extra en caso de que se cambie la jornada--->
	<cfquery name="rsVa" datasource="#session.dsn#">
		select RHJid from RHCMCalculoAcumMarcas where CAMid= <cfqueryparam cfsqltype="cf_sql_numeric"  value="#form.CAMid#">
		and Ecodigo=#session.Ecodigo#
	</cfquery>

	<cfif len(trim(form.jornada)) eq 0>
		<cfthrow message="Debe de seleccionar una jornada laboral">
	</cfif>
	
	<cfif isdefined ('form.jornada') and isdefined ('rsVa') and len(trim(rsVa.RHJid)) gt 0 and ltrim(rtrim(rsVA.RHJid)) neq form.jornada>
		<cfquery name="rsUP" datasource="#session.dsn#">
			update RHControlMarcas
			set 
			grupomarcas = null,
			numlote = null,
			registroaut =1,
			RHJid=#form.jornada#
			where numlote= <cfqueryparam cfsqltype="cf_sql_numeric"  value="#form.CAMid#">
			and Ecodigo=#session.Ecodigo#
		</cfquery>

		<cfinvoke component="rh.Componentes.RH_ProcesoAgrupaMarcas" method="RH_ProcesoAgrupaMarcas">

		<cfquery name="del" datasource="#session.dsn#">
			delete from RHCMCalculoAcumMarcas where 
			Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and CAMid = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#form.CAMid#"> 
		</cfquery>
	</cfif>
</cfif>

<!--- MODIFICACIÓN MANUAL DE MARCAS --->
<cfif isdefined("form.Cambio") and isdefined("form.CAMid") and len(trim(form.CAMid))>
	<cfquery datasource="#session.DSN#">
		update RHCMCalculoAcumMarcas set
			CAMcanthorasreb = <cfqueryparam cfsqltype="cf_sql_money" scale="1" value="#form.CAMcanthorasreb#">,
			CAMcanthorasjornada = <cfqueryparam cfsqltype="cf_sql_money" value="#form.CAMcanthorasjornada#">,
			CAMcanthorasextA = <cfqueryparam cfsqltype="cf_sql_money" value="#form.CAMcanthorasextA#">,
			CAMcanthorasextB = <cfqueryparam cfsqltype="cf_sql_money" value="#form.CAMcanthorasextB#">,
			CAMmontoferiado = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.CAMmontoferiado,',','','all')#">
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and CAMid = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#form.CAMid#">
	</cfquery>


<cfelseif isdefined("form.Baja")>
	<!----Actualiza la tabla de marcas (RHControlMarcas) poner nulo el NumeroLote(es el CAMid de RHCMCalculoAcumMarcas)--->
	<cfquery datasource="#session.DSN#">
		update RHControlMarcas set numlote = null, grupomarcas = null, registroaut = 0
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and numlote = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CAMid#">
	</cfquery>
	<!---Eliminar registro ---->
	<cfquery datasource="#session.DSN#">
		delete RHCMCalculoAcumMarcas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and CAMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CAMid#">
	</cfquery>
</cfif>
<cfoutput>
	<cfif isdefined ('form.Band') and len(trim(form.Band)) gt 0>
		<cfset regresa='aprobar-lista.cfm'>
	<cfelse>
		<cfset regresa='ProcesaMarcas-Lista.cfm'>
	</cfif>
	<form name="form1" action="#regresa#" method="post">		
		<input type="hidden" name="btnFiltrar" value="btnFiltrar">	
		<cfif isdefined("form.chk") and len(trim(form.chk)) gt 0>
		<input type="hidden" name="chk" value="#form.chk#">	
		</cfif>
		<cfif isdefined("form.DEid") and len(trim(form.DEid))>
		<input type="hidden" name="DEid" value="#form.DEid#">		
		</cfif>
		<cfif isdefined("form.visualizar") and len(trim(form.visualizar))>
		<input type="hidden" name="visualizar" value="#form.visualizar#">		
		</cfif>
		<cfif isdefined("form.Grupo") and len(trim(form.Grupo))>
		<input type="hidden" name="Grupo" value="#form.Grupo#">
		</cfif>
		<cfif isdefined("form.ver") and len(trim(form.ver))>
		<input type="hidden" name="ver" value="#form.ver#">
		</cfif>
		<cfif isdefined("form.fechaInicio") and len(trim(form.fechaInicio))>
		<input type="hidden" name="fechaInicio" value="#form.fechaInicio#">
		</cfif>
		<cfif isdefined("form.fechaFinal") and len(trim(form.fechaFinal))>
		<input type="hidden" name="fechaFinal" value="#form.fechaFinal#">
		</cfif>
		<cfif isdefined("form.RHJid") and len(trim(form.RHJid))>
		<input type="hidden" name="RHJid" value="#form.RHJid#">	
		</cfif>
		<cfif isdefined("form.Pagina") and len(trim(form.Pagina))>
		<input type="hidden" name="Pagina" value="#form.Pagina#">	
		</cfif>
	</form>
</cfoutput>
<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>
