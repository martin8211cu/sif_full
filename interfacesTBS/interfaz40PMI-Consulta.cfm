<cf_templateheader title="SIF - Interfaces P.M.I.">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cancelacion de Documentos'>
		<cfquery name = "RsRegDoctoCab" datasource="sifinterfaces">
			select Empresa, Modulo, NumeroSocio, Transaccion, Documento, 
            max(CodigoMoneda) as CodigoMoneda, max(TipoCambio) as TipoCambio, max(MontoTotal) as MontoTotal,
            max(Banco) as Banco, max(CuentaBanco) as CuentaBanco, max(ConceptoTesoreria) as ConceptoTesoreria
            from Interfaz40 
			where Empresa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Empresa#">
            and Modulo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Modulo#">
            and NumeroSocio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NumeroSocio#">
            and Transaccion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Transaccion#">
            and Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Documento#">
            group by Empresa, Modulo, NumeroSocio, Transaccion, Documento 
		</cfquery>
	 	
        <cfquery name = "RsRegDoctoErr" datasource="sifinterfaces">
			select Error
            from Interfaz40 
			where Empresa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Empresa#">
            and Modulo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Modulo#">
            and NumeroSocio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NumeroSocio#">
            and Transaccion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Transaccion#">
            and Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Documento#">
            and isnull(convert(varchar,Error),'') not like ''
		</cfquery>
        
        <cfquery name = "RsRegDoctoDet" datasource="sifinterfaces">
			select NumeroSocioDoc, TransaccionDestino, DocumentoDestino, MontoDocumento
            from Interfaz40 
			where Empresa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Empresa#">
            and Modulo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Modulo#">
            and NumeroSocio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NumeroSocio#">
            and Transaccion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Transaccion#">
            and Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Documento#">
		</cfquery>
 	<form method="post" name="frmDetalle" style="margin:0 0 0 0">
		<hr>
            <table width=500 align=center><tr><td>
			<cf_web_portlet_start titulo="DOCUMENTO CANCELACION">
				<cfif isdefined("RsRegDoctoCab") and RsRegDoctoCab.recordCount EQ 1>
					<cfset LvarCampos = RsRegDoctoCab.getColumnnames()>
					<table width="100%" border="1">
						<TR>
                            <cfloop index="i" from="1" to="#arrayLen(LvarCampos)#">
                                <td style="font-size:12;font-weight:bold">
                                    <cfoutput>#ucase(LvarCampos[i])#</cfoutput>
                                </td>
                            </cfloop>
                        </TR>
                        <cfloop query="RsRegDoctoCab">   
                            <TR>
                                <cfloop index="i" from="1" to="#arrayLen(LvarCampos)#">
                                    <td style="font-size:10">
                                    <cfoutput>#evaluate("RsRegDoctoCab.#LvarCampos[i]#")#&nbsp;</cfoutput>
                                    </td>
                                </cfloop>
                            </TR>
                        </cfloop> 						
					</table>
				</cfif> 
			<cf_web_portlet_end>
		 	</td></tr></table>
            <cfif isdefined("RsRegDoctoErr") and RsRegDoctoErr.recordcount GT 0>
                <table>
                    <tr>
                        <td align="left">
                            <strong>ERROR:</strong>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <cfoutput>#RsRegDoctoErr.Error#</cfoutput>
                        </td>
                    </tr>
                </table>
            </cfif>
        <hr>
			<table width=500 align=center><tr><td>
			<cf_web_portlet_start titulo="DOCUMENTOS A CANCELAR">
				<cfif isdefined("RsRegDoctoDet") and RsRegDoctoDet.recordCount GTE 1>
					<cfset LvarCampos = RsRegDoctoDet.getColumnnames()>
					<table width="100%" border="1">
						<TR>
                            <cfloop index="i" from="1" to="#arrayLen(LvarCampos)#">
                                <td style="font-size:12;font-weight:bold">
                                    <cfoutput>#ucase(LvarCampos[i])#</cfoutput>
                                </td>
                            </cfloop>
                        </TR>
                        <cfloop query="RsRegDoctoDet">   
                            <TR>
                                <cfloop index="i" from="1" to="#arrayLen(LvarCampos)#">
                                    <td style="font-size:10">
                                    <cfoutput>#evaluate("RsRegDoctoDet.#LvarCampos[i]#")#&nbsp;</cfoutput>
                                    </td>
                                </cfloop>
                            </TR>
                        </cfloop> 						
					</table>
				</cfif> 
			<cf_web_portlet_end>
		 	</td></tr></table>
	</form>
	
   	<!----------------------------------------------------  --->
	<cfoutput>
    <table align="center">
		<tr>
			<td>
				<form action="interfaz40PMI-sql.cfm?PageNum_lista=#url.pagina#&usaAJAX=NO" method="post" style="margin:0 0 0 0" name="sql">
                	<input type="hidden" name="FechaI" value="#url.FechaI#" />
		            <input type="hidden" name="FechaF" value="#url.FechaF#" />
                    <input type="hidden" name="LvarTipo" value="#url.LvarTipo#" />
                    <input type="hidden" name="LvarSocioN" value="#url.LvarSocioN#" />
                    <cfif isdefined("url.Moneda") and len(url.Moneda) GT 0>
	                    <input type="hidden" name="Moneda" value="#url.Moneda#" />
                    </cfif>
					<input type="submit" name="btnRegresar" value="Regresar">
				</form>
			</td>
		</tr>
	</table>
    </cfoutput>
   <!----------------------------------------------------  --->


	<cfset LvarFiltro = ""> 
	<cfset LvarNavegacion = "">
	<cfset Inicio = True>

 <cf_templatefooter>