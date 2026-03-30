<!---
	Realizado por: Martín S. Estevez
	Fecha : 27/Mayo/2014
	Motivo:	Creación de pies de firmas
--->
<cfcomponent output="yes">
	<cffunction name="RP_PieFirma" access="public" output="yes" >
		<cfargument name="IdFirma" 		type="numeric" 	required="yes">
		<cfargument name="GvarConexion" type="string"   required="yes">

		<cfif isdefined("Arguments.IdFirma") and Arguments.IdFirma NEQ "">
		<cfquery name="rsFirmas" datasource="#Arguments.GvarConexion#">
			select a.ID_Firma, a.Fdescripcion, a.NumFilas, a.NumColumnas,
				b. Fnombre, b.Fcargo
			from CGEstrCatFirma a
			left join CGEstrCatFirmaD b
				on a.ID_Firma = b.ID_Firma
			where a.ID_Firma = <cfqueryparam cfsqltype ="cf_sql_integer" value="#Arguments.IdFirma#">
				and a.Ecodigo = <cfqueryparam cfsqltype ="cf_sql_integer" value="#session.Ecodigo#">
			order by b.Fila, b.Columna
		</cfquery>

		<cfoutput>
			<table width="98%" align="center" border="0" >
				<cfset ix = 1>
				<cfloop from="1" to="#rsFirmas.NumFilas#" index="i">
					<tr>
						<td width="1%"/>
						<cfloop from="1" to="#rsFirmas.NumColumnas#" index="j">
							<td>
								<table width="100%" align="center" border="0" >
									<tr><td>&nbsp</td></tr>
									<tr><td>&nbsp</td></tr>
									<tr>
										<td align="center" valign="top">
											<cfif rsFirmas["Fnombre"][ix] neq "" or rsFirmas["Fcargo"][ix] neq "">
											<hr noshade="true" width="160px" />
											</cfif>
											<strong>#rsFirmas["Fnombre"][ix]#</strong>
										</td>
									</tr>
									<tr>
										<td align="center" valign="top">
											#rsFirmas["Fcargo"][ix]#
										</td>
									</tr>
								</table>
							</td>
							<td width="1%"/>
							<cfset ix = ix+1>
						</cfloop>
					</tr>
					<tr><td>&nbsp</td></tr>
				</cfloop>
			</table>
		</cfoutput>
		</cfif>
	</cffunction>

</cfcomponent>