<cfif isDefined("Url.ID_Firma") and not isDefined("form.ID_Firma")>
	<cfset form.ID_Firma = Url.ID_Firma>
</cfif>


<cfif isdefined("form.ID_Firma") and len(trim(form.ID_Firma))>
	<cfquery name="rsForm" datasource="#session.dsn#">
		select
			a.Ecodigo,
			a.ID_Firma,
			a.Fcodigo,
			a.Fdescripcion,
			a.NumFilas,
			a.NumColumnas,
            a.ts_rversion
		from CGEstrCatFirma a
			where a.Ecodigo = #session.Ecodigo#
			and  a.ID_Firma = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ID_Firma#">
	</cfquery>

	<cfquery name="rsFirmas" datasource="#session.dsn#">
		select ID_FirmaD,Fnombre,Fcargo,Columna,Fila,ts_rversion
		from CGEstrCatFirmaD
			where ID_Firma = #form.ID_Firma#
		order by Fila,Columna
	</cfquery>

	<cfif rsFirmas.RecordCount GT 0>
		<cfset modo = "CAMBIO">
	<cfelse>
		<cfset modo = "ALTA">
	</cfif>

</cfif>

<cfoutput>
	<fieldset>
	<legend><strong>Estructura Programática</strong>&nbsp;</legend>
		<form action="CatFirmasDet_SQL.cfm" method="post" name="form1">
			<table width="98%" align="center" border="0" >
				<cfset ix = 1>
				<cfloop from="1" to="#rsForm.NumFilas#" index="i">
					<tr>
					<cfloop from="1" to="#rsForm.NumColumnas#" index="j">
						<td>
							<table width="100%" align="center" border="0" >
								<tr>
									<td>
										<input name="firmaid_#i*10+j#" type="hidden" value="<cfif modo NEQ 'ALTA'>#rsFirmas["ID_FirmaD"][ix]#<cfelse>""</cfif>"
						size="5" maxlength="100" />
										Nombre: <input name="nombre_#i*10+j#" tabindex="#ix#" type="text" size="30" value="<cfif modo NEQ 'ALTA'>#rsFirmas["Fnombre"][ix]#<cfelse>""</cfif>"
						size="5" maxlength="100" />
									</td>
								</tr>
								<tr>
									<td>
										Cargo: &nbsp&nbsp <input name="cargo_#i*10+j#" tabindex="#ix#" type="text" size="30" value="<cfif modo NEQ 'ALTA'>#rsFirmas["Fcargo"][ix]#<cfelse>""</cfif>"
						size="5" maxlength="100" />
									</td>
								</tr>
							</table>
						</td>
						<cfset ix = ix+1>
					</cfloop>
					</tr>
					<tr><td >&nbsp</td></tr>
				</cfloop>
				<cfset params = "">
				<tr>
					<td colspan="#rsForm.NumColumnas#" align="center">
						<cfset params=params&"&EPcodigo="&rsForm.Fcodigo>
						<cfif rsFirmas.RecordCount GT 0>
							<cf_botones modo="#modo#" exclude = "baja,nuevo" regresar = "CatFirmas.cfm?#params#" tabindex="100">
						<cfelse>
							<cf_botones modo="#modo#" regresar = "CatFirmas.cfm?#params#" tabindex="100">
						</cfif>

					</td>
				</tr>
				<tr>
					<td colspan="#rsForm.NumColumnas#" align="center">
						<cfinvoke component="sif.ep.componentes.EP_Firmas" method="RP_PieFirma">
							<cfinvokeargument name="IdFirma"	value="#rsForm.ID_Firma#">
						    <cfinvokeargument name="GvarConexion" 	value="#session.dsn#">
						</cfinvoke>
					</td>
				</tr>
			</table>
			<cfset ts = "">
			<input type="hidden" name="ID_Firma" value="#rsForm.ID_Firma#" >
            <cfif modo NEQ "ALTA">
                <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rsForm.ts_rversion#" returnvariable="ts">
                </cfinvoke>

                <input type="hidden" name="ts_rversion" value="#ts#" >
            </cfif>
		</form>
	</fieldset>
</cfoutput>

<cfoutput>
	<cf_qforms form="form1">
	<script language="javascript1" type="text/javascript">
		objForm.EPdescripcion.description = "Descripción";

		objForm.EPdescripcion.required = true;

	<!---	<cfif modo NEQ 'ALTA'>
			document.form1.EPdescripcion.focus();
		<cfelse>
			document.form1.EPcodigo.focus();
			objForm.EPcodigo.description   = "Código";
			objForm.EPcodigo.required      = true;
		</cfif>--->

	</script>
</cfoutput>