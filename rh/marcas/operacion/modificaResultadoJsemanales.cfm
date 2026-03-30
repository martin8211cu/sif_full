<cfquery name="rsModificaDet" datasource="#Session.DSN#">
	select b.CIid,a.RHDMid, a.RHDMhorasautor, 
		case b.CInegativo when 1 then '+' else '-' end as sumaresta
	from RHDetalleIncidencias a
		inner join CIncidentes b
		on b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and b.CIid = a.CIid
	where a.RHPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPMid#">
	and a.RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCMid#">
	order by a.RHDMid
</cfquery>

<cfset contHorasAdicionales = 0>
<cfset contHorasRebajar = 0>

<cfif isdefined('form.horasAdic') and form.horasAdic NEQ ''>
	<cfset contHorasAdicionales = form.horasAdic>
</cfif>
<cfif isdefined('form.horasRebaj') and form.horasRebaj NEQ ''>
	<cfset contHorasRebajar = form.horasRebaj>
</cfif>

<cfif isdefined('rsModificaDet') and rsModificaDet.recordCount GT 0>
	<cfloop query="rsModificaDet">
		<cfif isdefined('form.horasAdic') and form.horasAdic NEQ '' and form.horasAdic GT 0>
			<cfif rsModificaDet.sumaresta EQ '+'>
				<cfif contHorasAdicionales GT 0>
					<cfif rsModificaDet.RHDMhorasautor LTE contHorasAdicionales>
						<cfset contHorasAdicionales = contHorasAdicionales - rsModificaDet.RHDMhorasautor>
					<cfelse>
						<cfquery datasource="#Session.DSN#">
							update RHDetalleIncidencias set
								RHDMhorasautor=<cfqueryparam cfsqltype="cf_sql_float" value="#contHorasAdicionales#">
							where RHDMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsModificaDet.RHDMid#">
						</cfquery>
						<cfset contHorasAdicionales = 0>
					</cfif>
				<cfelse>
					<cfif rsModificaDet.RHDMhorasautor GT 0 and contHorasAdicionales EQ 0>
						<cfquery datasource="#Session.DSN#">
							delete RHDetalleIncidencias
							where RHDMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsModificaDet.RHDMid#">
						</cfquery>			
					</cfif>
				</cfif>
			</cfif>		
		</cfif>

		<cfif isdefined('form.horasRebaj') and form.horasRebaj NEQ '' and form.horasRebaj GT 0>
			<cfif rsModificaDet.sumaresta EQ '-'>
				<cfif contHorasRebajar GT 0>
					<cfif rsModificaDet.RHDMhorasautor LTE contHorasRebajar>
						<cfset contHorasRebajar = contHorasRebajar - rsModificaDet.RHDMhorasautor>
					<cfelse>
						<cfquery datasource="#Session.DSN#">
							update RHDetalleIncidencias set
								RHDMhorasautor=<cfqueryparam cfsqltype="cf_sql_float" value="#contHorasRebajar#">
							where RHDMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsModificaDet.RHDMid#">					
						</cfquery>
						<cfset contHorasRebajar = 0>
					</cfif>
				<cfelse>
					<cfif rsModificaDet.RHDMhorasautor GT 0 and contHorasRebajar EQ 0>
						<cfquery datasource="#Session.DSN#">
							delete RHDetalleIncidencias
							where RHDMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsModificaDet.RHDMid#">
						</cfquery>		
					</cfif>
				</cfif>		
			</cfif>
		</cfif>
	</cfloop>
</cfif>
