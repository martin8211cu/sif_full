<cfif not isdefined("Form.Nuevo") and isdefined("Form.btnSubmit")>
	<cftry>
		<cfif Form.btnSubmit EQ 'Agregar'>
			<cfquery name="ABC_Parametros" datasource="#Session.DSN#">
				insert into PFormato(TFid, PFcampo, PFtipodato)
				values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TFid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PFcampo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PFtipodato#">
				)
			</cfquery>				
		<cfelseif Form.btnSubmit EQ 'Borrar'>
			<cfif isdefined("Form.PFid") and Len(Trim(Form.PFid)) NEQ 0>
				<cfquery name="ABC_Parametros" datasource="#Session.DSN#">
					delete from PFormato
					where PFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PFid#"> 
				</cfquery>		
			</cfif>
			<cfset modo="CAMBIO">
		<cfelseif Form.btnSubmit EQ 'Modificar'>
			<cfif isdefined("Form.PFid") and Len(Trim(Form.PFid)) NEQ 0>
				<cfquery name="ABC_Parametros" datasource="#Session.DSN#">
					update PFormato
					   set PFcampo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PFcampo#">,
						   PFtipodato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.PFtipodato#">
					where PFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PFid#"> 
				</cfquery>
			</cfif>
			<cfset modo="CAMBIO">
		</cfif>			
	<cfcatch type="any">
		<cfinclude template="../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<form action="FormatosTipos.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="CAMBIO">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">	
	<cfif isdefined("Form.TFid")>
		<input name="TFid" type="hidden" value="<cfoutput>#Form.TFid#</cfoutput>">
	</cfif>
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
