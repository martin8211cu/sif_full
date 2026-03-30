<cfif not isdefined("Form.btnNuevo")>
	<cftransaction>
		<cftry>
			<cfif isdefined("Form.btnAgregar")>
				<cfquery name="ABC_Eventos" datasource="#Session.DSN#">
					insert MEEvento (Ecodigo, MEVevento, MEVdesc, MEVfecha, MEVinicio, MEVfin)
					select 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.MEVevento#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.MEVdesc#">,
						convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.MEVfecha#">, 103),
						convert(datetime, '#Form.MEVinicio1#:#Form.MEVinicio2#:00'),
						convert(datetime, '#Form.MEVfin1#:#Form.MEVfin2#:00')
				</cfquery>

			<cfelseif isdefined("Form.btnCambiar")>
				<cfquery name="ABC_Eventos" datasource="#Session.DSN#">
					update MEEvento 
					   set MEVevento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.MEVevento#">, 
						   MEVdesc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.MEVdesc#">, 
						   MEVfecha = convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.MEVfecha#">, 103), 
						   MEVinicio = convert(datetime, '#Form.MEVinicio1#:#Form.MEVinicio2#:00'),
						   MEVfin = convert(datetime, '#Form.MEVfin1#:#Form.MEVfin2#:00')
					where MEVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MEVid#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery>
				
			<cfelseif isdefined("Form.btnEliminar")>
				<cfquery name="ABC_Eventos" datasource="#Session.DSN#">
					delete MEEvento 
					where MEVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MEVid#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery>
				
			</cfif>
		
		
		<cfcatch>
			
			<cfabort>
		</cfcatch>
		
		
		</cftry>
		
		
	</cftransaction>


</cfif>

<form name="frmActividades" action="actividades.cfm" method="post">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
