<cfif isdefined("form.SDetalle")>
	<cfset LvarDetalle = form.SDetalle>
<cfelse>
	<cfset LvarDetalle = 1> <!---Para No Mostrar los Detalles --->
</cfif>

<cf_templateheader title="Consulta Mascaras al Plan Contable">
    <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Cuentas Financieras'>
			
			<cfoutput>
                <form id="form1" name="form1" method="post" action="ConsultaCuentasFinancieras.cfm">
                    <table>
                        <tr>
                            <td colspan="2">
                                <label>Genera Cuenta Financiera</label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label>Cuenta a Generar o Consultar</label>
                            </td>
                            <td>
                                <input type="text" name="CFformato" id="CFformato" />
                            </td>
                            <td>
                            	<input type="submit" name="Consulta" value="Consultar" />
                            </td>
                        </tr>
                    </table>
                </form>
            	<hr color="##333333" style="border:groove" />    

				<cfif isdefined("form.CFformato") AND len(form.CFformato) GT 0>
                    <cfinvoke 
                     component="sif.Componentes.PC_GeneraCuentaFinanciera"
                     method="fnGeneraCuentaFinanciera"
                     returnvariable="Lvar_MsgError">
                        <cfinvokeargument name="Lprm_CFformato"	value="#form.CFformato#"/>
                        <cfinvokeargument name="Lprm_fecha" value="#now()#"/>
                        <cfinvokeargument name="Lprm_EsDePresupuesto" value="false"/>
                        <cfinvokeargument name="Lprm_NoCrear" value="false"/>
                        <cfinvokeargument name="Lprm_CrearSinPlan" value="false"/>
                        <cfinvokeargument name="Lprm_debug" value="false"/>
                        <cfinvokeargument name="Lprm_Ecodigo" value="#session.Ecodigo#"/>
                        <cfinvokeargument name="Lprm_DSN" value="#session.dsn#">
                        <cfinvokeargument name="Lprm_SoloVerificar" value="false"/>
                    </cfinvoke>
                    <center>
                        <table width="100%" cellpadding="2" cellspacing="10" >
                            <tr>
                                <td bgcolor="##CCCCCC" bordercolor="##000000" align="center" width="100%"> Resultado de la Consulta </td>
                            </tr>
                            <tr>
                            <cfif isdefined('Lvar_MsgError') AND (Lvar_MsgError NEQ "" AND Lvar_MsgError NEQ "OLD" AND Lvar_MsgError NEQ "NEW")>
                                <td bgcolor="##CCCCCC" bordercolor="##000000" align="center" width="100%">Cuenta: #CFformato# Error: #Lvar_MsgError# </td>
                            <cfelseif Lvar_MsgError EQ "OLD">
                     			<td bgcolor="##CCCCCC" bordercolor="##000000" align="center" width="100%">Cuenta: #CFformato# Ya Existe en Catalogo </td>       	
                            <cfelseif Lvar_MsgError EQ "NEW">
                  				<td bgcolor="##CCCCCC" bordercolor="##000000" align="center" width="100%">Cuenta: #CFformato# Nueva</td>          	
                            <cfelse>
                            	<td bgcolor="##CCCCCC" bordercolor="##000000" align="center" width="100%">Cuenta: #CFformato# ERROR NO INTERCEPTABLE</td>
                            </cfif>
                            </tr>
                        </table>
                  </center>
                </cfif>
            </cfoutput>
            
	<cf_web_portlet_end>
<cf_templatefooter>