<!--- Postea Masivamente Documento CxC --->
<!--- Postea Masivamente Documento CxP --->
<cfcomponent output="no">
	<cffunction name="Ejecuta" access="public"> 
        <cfquery name="rsDocCxC" datasource="minisif">
            select top(1000) Ecodigo, EDid, EDusuario
            from EDocumentosCxC
        </cfquery>
        <cfif rsDocCxC.recordcount GT 0>
        <cfloop query="rsDocCxC">
            <cftry>
                <cfinvoke component="sif.Componentes.CC_PosteoDocumentosCxC"
                    method="PosteoDocumento"
                    EDid	= "#rsDocCxC.EDid#"
                    Ecodigo = "#rsDocCxC.Ecodigo#"
                    usuario = "#rsDocCxC.EDusuario#"
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
                </cfoutput>    	<!--- Upps --->
            </cfcatch>
            </cftry>
        </cfloop>
        </cfif>
    </cffunction>
</cfcomponent>