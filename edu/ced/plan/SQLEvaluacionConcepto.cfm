<cfset params="">
<cfif not isdefined("form.Nuevo")>

	<cfif form.ECorden eq "" and (isdefined("form.Alta") or isdefined("form.Cambio"))>
		<cfquery name="rsOrden" datasource="#Session.Edu.DSN#">
			select isnull(max(ECorden),0) + 10 as ECorden 
			from EvaluacionConcepto
			where CEcodigo=<cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfif rsOrden.RecordCount gt 0>
			<cfset form.ECorden = rsOrden.ECorden>
		<cfelse>
			<cfset form.ECorden = 1>
		</cfif>
	</cfif>

	
		<cfif isdefined("form.Alta")>
			<cftransaction>
			<cfquery name="ins_EvaluacionConcepto" datasource="#Session.Edu.DSN#">
				insert EvaluacionConcepto ( CEcodigo, ECnombre, ECorden )
							values( <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">, 
									<cfqueryparam value="#form.ECnombre#"    cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#form.ECorden#"     cfsqltype="cf_sql_integer">
								  )
				<cf_dbidentity1 datasource="#Session.Edu.DSN#">
			</cfquery>	
			<cf_dbidentity2 name="ins_EvaluacionConcepto" datasource="#Session.Edu.DSN#">
			<cfset params = params & "&ECcodigo=" & ins_EvaluacionConcepto.identity>
			<cfquery name="rsPagina" datasource="#Session.Edu.DSN#">
				select ECcodigo
				from EvaluacionConcepto
				where CEcodigo=#Session.Edu.CEcodigo# 
				<cfif isdefined("form.Filtro_ECnombre") and len(trim(form.Filtro_ECnombre))>
					and ECnombre like '%#form.Filtro_ECnombre#%'
				</cfif>
				<cfif isdefined("form.Filtro_ECorden") and len(trim(form.Filtro_ECorden))>
					and ECorden >= #form.Filtro_ECorden#
				</cfif>
				order by ECorden, upper(ECnombre)
			</cfquery>
			<cfset row = 1>
			<cfif rsPagina.RecordCount LT 500>
				<cfloop query="rsPagina">
					<cfif rsPagina.ECcodigo EQ ins_EvaluacionConcepto.identity>
						<cfset row = rsPagina.currentrow>
						<cfbreak>
					</cfif>
				</cfloop>
			</cfif>
			<cfset form.pagina = Ceiling(row / form.MaxRows)>
			</cftransaction>
			<cfset modo="ALTA">
		<cfelseif isdefined("form.Baja")>
			<cfquery name="del_EvaluacionConcepto" datasource="#Session.Edu.DSN#">
					if not exists ( select 1 from EvaluacionConceptoCurso
							where ECcodigo = <cfqueryparam value="#Form.ECcodigo#" cfsqltype="cf_sql_numeric">
						)
					begin			
						if not exists ( select 1 from EvaluacionConceptoMateria
							where ECcodigo = <cfqueryparam value="#Form.ECcodigo#" cfsqltype="cf_sql_numeric">
						)				
						begin
							if not exists ( select 1 from EvaluacionPlanConcepto
								where ECcodigo = <cfqueryparam value="#Form.ECcodigo#" cfsqltype="cf_sql_numeric">
							)				
							begin
						
								delete EvaluacionConcepto
								where ECcodigo = <cfqueryparam value="#form.ECcodigo#"    cfsqltype="cf_sql_numeric">
							end
		
						end
					end
			</cfquery>
			<cfset modo="ALTA">

		<cfelseif isdefined("form.Cambio")>
			<cfquery name="upd_EvaluacionConcepto" datasource="#Session.Edu.DSN#">
				 update EvaluacionConcepto 
				 set ECnombre      = <cfqueryparam value="#form.ECnombre#" cfsqltype="cf_sql_varchar">,
					 ECorden       = <cfqueryparam value="#form.ECorden#"  cfsqltype="cf_sql_integer">
				 where ECcodigo    = <cfqueryparam value="#form.ECcodigo#" cfsqltype="cf_sql_numeric">
			</cfquery>			
			<cfset params = params & "&ECcodigo=" & Form.ECcodigo>
			<cfset modo = "ALTA">
		</cfif>
</cfif>
<!--- <cfif not isdefined("form.Nuevo") and not isdefined("Form.Baja")>
	<cflocation url="EvaluacionConcepto.cfm#params#">
<cfelse>
	<cfif isdefined("Form.Baja")>
		<cflocation url="EvaluacionConcepto.cfm">
	<cfelse>
		<cflocation url="EvaluacionConcepto.cfm">
	</cfif>
</cfif>
 --->
<cflocation url="EvaluacionConcepto.cfm?Pagina=#form.pagina#&Filtro_ECnombre=#Form.Filtro_ECnombre#&Filtro_ECorden=#Form.Filtro_ECorden#&HFiltro_ECnombre=#Form.Filtro_ECnombre#&HFiltro_ECorden=#Form.Filtro_ECorden##params#">



<!--- <form action="EvaluacionConcepto.cfm" method="post" name="sql">
	<input name="modo"     type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="ECcodigo" type="hidden" value="<cfif isdefined("Form.ECcodigo")><cfoutput>#Form.ECcodigo#</cfoutput></cfif>">
	<input name="Pagina"   type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">	
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML> --->