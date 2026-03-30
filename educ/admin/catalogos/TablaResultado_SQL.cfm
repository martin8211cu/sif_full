<cfset modo = "ALTA">
<!--- este esta incompleto, falta hacerlo correcto, Oscar me paso a hacer el mantenimiento de carreras --->
<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfquery name="ABC_EstructuraTipo" datasource="#Session.DSN#">
			set nocount on
			declare @TRcodigo numeric
			<cfif isdefined("Form.Alta")>
				insert TablaResultado (Ecodigo, TRnombre, TRcantidadAmpliacion)
				values (
					<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
					, <cfqueryparam value="#form.TRnombre#" cfsqltype="cf_sql_varchar">
					, <cfqueryparam value="#form.TRcantidadAmpliacion#" cfsqltype="cf_sql_tinyint">)


				select @TRcodigo = @@identity
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Baja")>
				select @TRcodigo = <cfqueryparam value="#Form.TRcodigo#" cfsqltype="cf_sql_numeric">

				delete TablaResultadoRango
				where TRcodigo = @TRcodigo

				delete TablaResultado
				where TRcodigo = @TRcodigo
					and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
					and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
				   
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Cambio")>
				select @TRcodigo = <cfqueryparam value="#Form.TRcodigo#" cfsqltype="cf_sql_numeric">

				update TablaResultado set
					TRnombre = <cfqueryparam value="#Form.TRnombre#" cfsqltype="cf_sql_varchar">,
					TRcantidadAmpliacion = <cfqueryparam value="#form.TRcantidadAmpliacion#" cfsqltype="cf_sql_tinyint">
				where TRcodigo  = @TRcodigo
					and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
					and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
				  
				<cfset modo="CAMBIO">
			<cfelseif isdefined("Form.btnLista")>
				<cfset modo="LISTA">
			</cfif>

			<cfif not isdefined("Form.Baja") AND not isdefined("Form.btnLista")>
				<cfparam name="form.TRRminGanar" default="70">
				<cfparam name="form.TRRminNoPerder" default="60">
				<cfif form.TRRminGanar lt form.TRRminNoPerder>
				  <cfset form.TRRminNoPerder = form.TRRminGanar>
				</cfif>
				<cfloop index="cont" from="1" to="3">
				  <cfif cont EQ 1>
					<cfset TTRMinimo = form.TRRminGanar>
					<cfset TTRMaximo = 100>
				  <cfelseif cont EQ 2>
					<cfset TTRMinimo = form.TRRminNoPerder>
					<cfset TTRMaximo = form.TRRminGanar - 0.01>
				  <cfelse>
					<cfset TTRMinimo = 0>
					<cfset TTRMaximo = form.TRRminNoPerder - 0.01>
				  </cfif>
				  if exists (select 1 from TablaResultadoRango 
							  where TRcodigo = @TRcodigo
								and TRRtipo = '#cont#')
					update TablaResultadoRango
					   set TRRnombre = <cfqueryparam value="#Evaluate('Form.TRRnombre#cont#')#" cfsqltype="cf_sql_varchar">
						 , TRRetiqueta = <cfqueryparam value="#Evaluate('Form.TRRetiqueta#cont#')#" cfsqltype="cf_sql_varchar">
						 , TRRminimo = <cfqueryparam value="#TTRminimo#" cfsqltype="cf_sql_numeric" scale="2">
						 , TRRmaximo = <cfqueryparam value="#TTRmaximo#" cfsqltype="cf_sql_numeric" scale="2">
					  where TRcodigo = @TRcodigo
						and TRRtipo = '#cont#'
				  else
					insert into TablaResultadoRango (TRcodigo, TRRtipo, TRRnombre, TRRetiqueta, TRRminimo, TRRmaximo)
						values(@TRcodigo, '#cont#'
							, <cfqueryparam value="#Evaluate('Form.TRRnombre#cont#')#" cfsqltype="cf_sql_varchar">
							, <cfqueryparam value="#Evaluate('Form.TRRetiqueta#cont#')#" cfsqltype="cf_sql_varchar">
							, <cfqueryparam value="#TTRminimo#" cfsqltype="cf_sql_numeric" scale="2">
							, <cfqueryparam value="#TTRmaximo#" cfsqltype="cf_sql_numeric" scale="2">)
				</cfloop>
			</cfif>
			set nocount off
		</cfquery>
	<cfcatch type="any">
		<cfinclude template="/educ/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<form action="TablaResultado.cfm" method="post" name="sql">
<cfoutput>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="TRcodigo" type="hidden" value="<cfif isdefined("Form.TRcodigo") and modo NEQ 'ALTA'>#Form.TRcodigo#</cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">	
</cfoutput>	
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>