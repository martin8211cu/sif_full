<!--- Postea Masivamente Documento CxP --->
<cfquery name="rsDocCxP" datasource="minisif">
	select top(100) Ecodigo, IDdocumento, EDusuario
    from EDocumentosCxP
</cfquery>
<cfif rsDocCxP.recordcount GT 0>
<cfloop query="rsDocCxP">
	<cftry>
        <cfinvoke component="sif.Componentes.CP_PosteoDocumentosCxP"
            method="PosteoDocumento"
            IDdoc = "#rsDocCxP.IDdocumento#"
            Ecodigo = "#rsDocCxP.Ecodigo#"
            usuario = "#rsDocCxP.EDusuario#"
            debug = "N"
        />
    <cfcatch>
    	<cfoutput>
			<table>
				<tr>
				<td>
				Error: #cfcatch.message#
				</td>
				</tr>
				<cfif isdefined("cfcatch.detail") AND len(cfcatch.detail) NEQ 0>
					<tr>
					<td>
					Detalles: #cfcatch.detail#
					</td>
					</tr>
				</cfif>
				<cfif isdefined("cfcatch.sql") AND len(cfcatch.sql) NEQ 0>
					<tr>
					<td>
					SQL: #cfcatch.sql#
					</td>
					</tr>
				</cfif>
				<cfif isdefined("cfcatch.queryError") AND len(cfcatch.queryError) NEQ 0>
					<tr>
					<td>
					QUERY ERROR: #cfcatch.queryError#
					</td>
					</tr>
				</cfif>
				<cfif isdefined("cfcatch.where") AND len(cfcatch.where) NEQ 0>
					<tr>
					<td>
					Parametros: #cfcatch.where#
					</td>
					</tr>
				</cfif>
			</table>
		</cfoutput> <!--- Upps --->
	</cfcatch>
    </cftry>
</cfloop>
</cfif>