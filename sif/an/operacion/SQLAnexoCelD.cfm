<cfif not isdefined("Form.Nuevo")>
		<cfset formato = " ">
		<cfif isdefined("form.Cmayor")>
			<cfset formato = trim(form.Cmayor) >
		</cfif>
		<cfif isdefined("form.Cformato") and len(trim(form.Cformato)) gt 0>
			<cfset formato = formato & "-" & trim(form.Cformato) >
		</cfif>
		<cfset movimientos = "N">
		<cfif isdefined("Form.AnexoCelMov")>
			<cfset movimientos = "S">
			<cfset formato = formato & "%">
		</cfif>
		<cfif isdefined("Form.ALTA")>
			<cfquery name="AnexoCelD_ABC" datasource="#Session.DSN#">
				insert into AnexoCelD (AnexoCelId, AnexoCelFmt, AnexoCelMov)
				values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoCelId#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#formato#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#movimientos#">
					  )
			</cfquery>
			<cfset modo = "ALTA">
		<cfelseif isdefined("Form.CAMBIO")>
			<cfquery name="AnexoCelD_ABC" datasource="#Session.DSN#">
				update AnexoCelD set 
					AnexoCelFmt   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#formato#">,
					AnexoCelMov   = <cfqueryparam cfsqltype="cf_sql_char" value="#movimientos#">
				where AnexoCelDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoCelDid#">
			</cfquery>
			<cfset modo = "CAMBIO">
		<cfelseif isdefined("Form.BAJA")>
			<cfquery name="AnexoCelD_ABC" datasource="#Session.DSN#">
				delete from AnexoCelD
				where AnexoCelDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoCelDid#">
			</cfquery>
			<cfset modo = "ALTA">
		</cfif>
</cfif>
<cfoutput>
<script language="JavaScript1.2">document.location.href="Definircuentas.cfm?AnexoId=#Form.AnexoId#&AnexoCelId=#Form.AnexoCelId#";</script>
</cfoutput>
