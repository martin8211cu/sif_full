
<cfif isdefined("Form.Alta")>
           <cfquery name="rsExisTransa" datasource="#Session.DSN#">
              select *
					from FAtransacciones
					where CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CCTcodigo#">
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
           </cfquery>
           <cfif rsExisTransa.recordcount gt 0>
              <cf_ErrorCode code="-1" msg="La transaccion ya esta en la lista.">
           </cfif>
			<cfquery name="rsAgrTransa" datasource="#Session.DSN#">
				insert FAtransacciones (Ecodigo,CCTcodigo)
					values
					(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CCTcodigo#">
					)
			</cfquery>
			<cfset modo="ALTA">
<cfelseif isdefined("Form.Baja")>
           <cfquery name="rsExisTransa" datasource="#Session.DSN#">
              select *
					from FAtransacciones
					where CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CCTcodigo#">
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
           </cfquery>
           <cfif  rsExisTransa.recordcount eq 0>
             <cf_ErrorCode code="-1" msg="No existe la transaccion para eliminarla.">
          </cfif>
          <cfquery name="rsDelTrans" datasource="#Session.DSN#">
				delete from FAtransacciones
				where
					Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and CCTcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CCTcodigo#">
			</cfquery>

			<cfset modo="ALTA">
</cfif>

<form action="<cfoutput>#LvarPagina#</cfoutput>" method="post" name="sql">
	<cfif isDefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="<cfoutput>#Form.Nuevo#</cfoutput>">
	<cfelse>
		<cfif modo NEQ "BAJA">
			<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
			<!---<input name="CCTcodigo" type="hidden" value="<cfif isdefined("Form.CCTcodigo")><cfoutput>#Form.CCTcodigo#</cfoutput></cfif>">--->
		</cfif>
	</cfif>
	<input type="hidden" name="PageNum" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>