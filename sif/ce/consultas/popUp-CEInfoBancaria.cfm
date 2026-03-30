<cfinvoke key="LB_Tipo" default="Tipo" returnvariable="LB_Tipo" component="sif.Componentes.Translate" method="Translate" xmlfile="popUp-CEInfoBancaria.xml"/>
<cfinvoke key="LB_Banco" default="Banco" returnvariable="LB_Banco" component="sif.Componentes.Translate" method="Translate" xmlfile="popUp-CEInfoBancaria.xml"/>
<cfinvoke key="LB_NumDocumento" default="N&uacute;m. de Documento" returnvariable="LB_NumDocumento" component="sif.Componentes.Translate" method="Translate" xmlfile="popUp-CEInfoBancaria.xml"/>
<cfinvoke key="LB_RFC" default="R.F.C." returnvariable="LB_RFC" component="sif.Componentes.Translate" method="Translate" xmlfile="popUp-CEInfoBancaria.xml"/>
<cfinvoke key="LB_Beneficiario" default="Beneficiario" returnvariable="LB_Beneficiario" component="sif.Componentes.Translate" method="Translate" xmlfile="popUp-CEInfoBancaria.xml"/>
<cfinvoke key="LB_CuentaOrigen" default="Cuenta Origen" returnvariable="LB_CuentaOrigen" component="sif.Componentes.Translate" method="Translate" xmlfile="popUp-CEInfoBancaria.xml"/>
<cfinvoke key="LB_BancoDestino" default="Banco Destino" returnvariable="LB_BancoDestino" component="sif.Componentes.Translate" method="Translate" xmlfile="popUp-CEInfoBancaria.xml"/>
<cfinvoke key="LB_CuentaDestino" default="Cuenta Destino" returnvariable="LB_CuentaDestino" component="sif.Componentes.Translate" method="Translate" xmlfile="popUp-CEInfoBancaria.xml"/>
<cfinvoke key="LB_Monto" default="Monto" returnvariable="LB_Monto" component="sif.Componentes.Translate" method="Translate" xmlfile="popUp-CEInfoBancaria.xml"/>


<cfif isdefined('url.IDContable') and len(trim(url.IDContable))>
	<cfset IDContable = #url.IDContable#>
</cfif>

<cfif isdefined('url.Dlinea') and len(trim(url.Dlinea))>
	<cfset Dlinea = #url.Dlinea#>
</cfif>

<cfif isdefined('url.ID') and len(trim(url.ID))>
	<cfset ID = #url.ID#>
</cfif>

<cfif isdefined('url.action') and len(trim(url.action))>
	<cfset ID = -1>
</cfif>

<cfif isdefined('form.btnAgregarInfo')>
	<cfquery datasource="#session.DSN#">
    	INSERT INTO CEInfoBancariaSAT(IDcontable,Dlinea,
                                    TESTMPtipo,IBSATdocumento,ClaveSAT,
                                    CBcodigo,TESOPfechaPago,TESOPtotalPago,IBSATbeneficiario,IBSATRFC,IBSAClaveSATtran,IBSATctadestinotran)
        SELECT a.IDcontable, b.Dlinea,
        	 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.txtTipo)#">,
             <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.txtNumDocumento)#">,
             <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.txtBanco)#">,
             <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.txtCuentaOrigen)#">,
         	 a.Efecha,
             <cfqueryparam cfsqltype="cf_sql_money" value="#trim(txtMonto)#">,
             <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.txtBeneficiario)#">,
             <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.txtRFC)#">,
             <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(txtBancoDestino)#">,
             <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(txtCuentaDestino)#">
		FROM HEContables a
 			INNER JOIN HDContables b on a.IDcontable = b.IDcontable
				AND a.Ecodigo = b.Ecodigo
		WHERE a. Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
 			AND a.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDContable#">
 			AND b.Dlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Dlinea#">
    </cfquery>
</cfif>

<cfquery name="rsInfoBancariaSAT" datasource="#session.DSN#">
    SELECT ID,IDcontable,Dlinea linea,
        TESTMPtipo,ClaveSAT,
        IBSATdocumento,IBSATRFC,IBSATbeneficiario,CBcodigo,IBSAClaveSATtran,
        IBSATctadestinotran,TESOPtotalPago
    FROM CEInfoBancariaSAT
    WHERE IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(IDContable)#">
        AND Dlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(Dlinea)#">
	<cfif isdefined('url.ID') or isdefined('url.action')>
		AND ID = #ID#
</cfif>
</cfquery>

<cfif (not isdefined('url.ID')) and rsInfoBancariaSAT.recordcount gt 0 and (not isdefined('url.action'))>
	<table width="100%" border="0" cellspacing="0" cellpadding="2">
		<tr>
            <td align="right" colspan="5"><cfoutput><a href="../../ce/consultas/popUp-CEInfoBancaria.cfm?action=add&IDContable=#IDContable#&Dlinea=#Dlinea#">Agregar informaci&oacute;n Bancaria</a></cfoutput></td>
        </tr>
		<cfoutput>
		<tr bgcolor="E2E2E2" class="subTitulo">
            <!--- <td valign="bottom"><strong>#LB_Tipo#</strong></td>
            <td valign="bottom"><strong>#LB_Banco#</strong></td> --->
            <td valign="bottom"><strong>#LB_NumDocumento#</strong></td>
            <!--- <td valign="bottom"><strong><strong>#LB_RFC#</strong></td> --->
            <td valign="bottom"><strong><strong>#LB_Beneficiario#</strong></td>
            <td valign="bottom"><strong><strong>#LB_CuentaOrigen#</strong></td>
            <!--- <td valign="bottom"><strong><strong>#LB_BancoDestino#</strong></td> --->
            <td valign="bottom"><strong><strong>#LB_CuentaDestino#</strong></td>
            <td valign="bottom"><strong><strong>#LB_Monto#</strong></td>
        </tr>
		</cfoutput>
		<cfset actRow = 1>

		<cfoutput query="rsInfoBancariaSAT">
			<tr style="cursor: pointer;" onMouseOver="javascript: style.color = 'red';" onMouseOut="javascript: style.color = 'black';"
				<cfif actRow MOD 2>
					bgcolor="white"
				<cfelse>
					bgcolor="##fafafa"
				</cfif>
				>
					<!--- <td onClick="window.location.href='popUp-CEInfoBancaria.cfm?IDContable=#rsInfoBancariaSAT.IDContable#+&Dlinea=#rsInfoBancariaSAT.linea#&ID=#rsInfoBancariaSAT.ID#';">
						#rsInfoBancariaSAT.TESTMPtipo#
					</td>
					<td onClick="window.location.href='popUp-CEInfoBancaria.cfm?IDContable=#rsInfoBancariaSAT.IDContable#+&Dlinea=#rsInfoBancariaSAT.linea#&ID=#rsInfoBancariaSAT.ID#';">
						#rsInfoBancariaSAT.ClaveSAT#
					</td> --->
					<td align="center" onClick="window.location.href='popUp-CEInfoBancaria.cfm?IDContable=#rsInfoBancariaSAT.IDContable#+&Dlinea=#rsInfoBancariaSAT.linea#&ID=#rsInfoBancariaSAT.ID#';">
						#rsInfoBancariaSAT.IBSATdocumento#
					</td>
					<!--- <td align="center" onClick="window.location.href='popUp-CEInfoBancaria.cfm?IDContable=#rsInfoBancariaSAT.IDContable#+&Dlinea=#rsInfoBancariaSAT.linea#&ID=#rsInfoBancariaSAT.ID#';">
						#rsInfoBancariaSAT.IBSATRFC#
					</td> --->
					<td onClick="window.location.href='popUp-CEInfoBancaria.cfm?IDContable=#rsInfoBancariaSAT.IDContable#+&Dlinea=#rsInfoBancariaSAT.linea#&ID=#rsInfoBancariaSAT.ID#';">
						#rsInfoBancariaSAT.IBSATbeneficiario#
					</td>
					<td onClick="window.location.href='popUp-CEInfoBancaria.cfm?IDContable=#rsInfoBancariaSAT.IDContable#+&Dlinea=#rsInfoBancariaSAT.linea#&ID=#rsInfoBancariaSAT.ID#';">
						#rsInfoBancariaSAT.CBcodigo#
					</td>
					<!--- <td align="center" onClick="window.location.href='popUp-CEInfoBancaria.cfm?IDContable=#rsInfoBancariaSAT.IDContable#+&Dlinea=#rsInfoBancariaSAT.linea#&ID=#rsInfoBancariaSAT.ID#';">
						#rsInfoBancariaSAT.IBSAClaveSATtran#
					</td> --->
					<td align="center" onClick="window.location.href='popUp-CEInfoBancaria.cfm?IDContable=#rsInfoBancariaSAT.IDContable#+&Dlinea=#rsInfoBancariaSAT.linea#&ID=#rsInfoBancariaSAT.ID#';">
						#rsInfoBancariaSAT.IBSATctadestinotran#
					</td>
					<td align="right" onClick="window.location.href='popUp-CEInfoBancaria.cfm?IDContable=#rsInfoBancariaSAT.IDContable#+&Dlinea=#rsInfoBancariaSAT.linea#&ID=#rsInfoBancariaSAT.ID#';">
						#numberFormat(rsInfoBancariaSAT.TESOPtotalPago,'0.00')#
					</td>
					<!--- <td align="right">
	                     <img border="0" src="/cfmx/sif/imagenes/Borrar01_S.gif"
	                     alt="Eliminar Detalle" onclick="funcBorrar('#rsInfoBancariaSAT.ID#');">
	                </td> --->
				</tr>
				<cfset actRow = actRow + 1>
		</cfoutput>
	</table>
<cfelse>
<table width="100%">
	<tr>
		<td align="center" width="100%">
        <cfoutput>
        	<form name="formPopUp" method="post" action="popUp-CEInfoBancaria.cfm" onsubmit="return validar();">
            <input type="hidden" name="IDContable" 	value="#IDContable#">
            <input type="hidden" name="Dlinea" 		value="#Dlinea#">
                <table width="70%">
                    <tr>
                        <td width="50%" align="right">
                            <strong>#LB_Tipo#:</strong>
                        </td>
                        <td width="50%">
                            <input type="text" name="txtTipo" id="txtTipo" value="<cfif isdefined('rsInfoBancariaSAT') and rsInfoBancariaSAT.RecordCount GT 0>#rsInfoBancariaSAT.TESTMPtipo#</cfif>" style="background-color:##CCC; width:370px"  <cfif isdefined('rsInfoBancariaSAT') and rsInfoBancariaSAT.RecordCount GT 0>readonly</cfif>/>
                        </td>
                    </tr>
                    <tr>
                        <td width="50%" align="right">
                            <strong>#LB_Banco#:</strong>
                        </td>
                        <td width="50%">
                            <input type="text" name="txtBanco" id="txtBanco" value="<cfif isdefined('rsInfoBancariaSAT') and rsInfoBancariaSAT.RecordCount GT 0>#rsInfoBancariaSAT.ClaveSAT#</cfif>" style="background-color:##CCC; width:370px"  <cfif isdefined('rsInfoBancariaSAT') and rsInfoBancariaSAT.RecordCount GT 0>readonly</cfif>/>
                        </td>
                    </tr>
                    <tr>
                        <td width="50%" align="right">
                            <strong>#LB_NumDocumento#:</strong>
                        </td>
                        <td width="50%">
                            <input type="text" name="txtNumDocumento" id="txtNumDocumento" value="<cfif isdefined('rsInfoBancariaSAT') and rsInfoBancariaSAT.RecordCount GT 0>#rsInfoBancariaSAT.IBSATdocumento#</cfif>" style="background-color:##CCC; width:370px"  <cfif isdefined('rsInfoBancariaSAT') and rsInfoBancariaSAT.RecordCount GT 0>readonly</cfif>/>
                        </td>
                    </tr>
                    <tr>
                        <td width="50%" align="right">
                            <strong>#LB_RFC#:</strong>
                        </td>
                        <td width="50%">
                            <input type="text" name="txtRFC" id="txtRFC" value="<cfif isdefined('rsInfoBancariaSAT') and rsInfoBancariaSAT.RecordCount GT 0>#rsInfoBancariaSAT.IBSATRFC#</cfif>" style="background-color:##CCC; width:370px"  <cfif isdefined('rsInfoBancariaSAT') and rsInfoBancariaSAT.RecordCount GT 0>readonly</cfif>/>
                        </td>
                    </tr>
                    <tr>
                        <td width="50%" align="right">
                            <strong>#LB_Beneficiario#:</strong>
                        </td>
                        <td width="50%">
                            <input type="text" name="txtBeneficiario" id="txtBeneficiario" value="<cfif isdefined('rsInfoBancariaSAT') and rsInfoBancariaSAT.RecordCount GT 0>#rsInfoBancariaSAT.IBSATbeneficiario#</cfif>" style="background-color:##CCC; width:370px"  <cfif isdefined('rsInfoBancariaSAT') and rsInfoBancariaSAT.RecordCount GT 0>readonly</cfif>/>
                        </td>
                    </tr>
                    <tr>
                        <td width="50%" align="right">
                            <strong>#LB_CuentaOrigen#:</strong>
                        </td>
                        <td width="50%">
                            <input type="text" name="txtCuentaOrigen" id="txtCuentaOrigen"  value="<cfif isdefined('rsInfoBancariaSAT') and rsInfoBancariaSAT.RecordCount GT 0>#rsInfoBancariaSAT.CBcodigo#</cfif>" style="background-color:##CCC;; width:370px"  <cfif isdefined('rsInfoBancariaSAT') and rsInfoBancariaSAT.RecordCount GT 0>readonly</cfif>/>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <hr  />
                        </td>
                    </tr>
                    <tr>
                        <td width="50%" align="right">
                            <strong>#LB_BancoDestino#:</strong>
                        </td>
                        <td width="50%">
                            <input type="text" name="txtBancoDestino" id="txtBancoDestino" value="<cfif isdefined('rsInfoBancariaSAT') and rsInfoBancariaSAT.RecordCount GT 0>#rsInfoBancariaSAT.IBSAClaveSATtran#</cfif>" style="background-color:##CCC; width:370px"  <cfif isdefined('rsInfoBancariaSAT') and rsInfoBancariaSAT.RecordCount GT 0>readonly</cfif>/>
                        </td>
                    </tr>
                    <tr>
                        <td width="50%" align="right">
                            <strong>#LB_CuentaDestino#:</strong>
                        </td>
                        <td width="50%">
                            <input type="text" name="txtCuentaDestino" id="txtCuentaDestino" value="<cfif isdefined('rsInfoBancariaSAT') and rsInfoBancariaSAT.RecordCount GT 0>#rsInfoBancariaSAT.IBSATctadestinotran#</cfif>"  style="background-color:##CCC; width:370px"  <cfif isdefined('rsInfoBancariaSAT') and rsInfoBancariaSAT.RecordCount GT 0>readonly</cfif>/>
                        </td>
                    </tr>
                    <tr>
                        <td width="50%" align="right">
                            <strong>#LB_Monto#:</strong>
                        </td>
                        <td width="50%">
                            <input type="text" name="txtMonto" id="txtMonto" value="<cfif isdefined('rsInfoBancariaSAT') and rsInfoBancariaSAT.RecordCount GT 0>#rsInfoBancariaSAT.TESOPtotalPago#</cfif>" style="background-color:##CCC; width:370px"  <cfif isdefined('rsInfoBancariaSAT') and rsInfoBancariaSAT.RecordCount GT 0>readonly</cfif>/>
                        </td>
                    </tr>
                    <cfif isdefined('rsInfoBancariaSAT') and rsInfoBancariaSAT.RecordCount EQ 0>
                     <tr>
                        <td colspan="2" align="center">
                            <input type="submit" name = "btnAgregarInfo" id="btnAgregarInfo" value="Agregar"/>
                        </td>
                    </tr>
					<cfelse>
					<tr>
                        <td colspan="2" align="center">
                            <input type="submit" name = "btnRegresar" id="btnRegresar" value="Regresar"/>
                        </td>
                    </tr>
                    </cfif>
                </table>
            </form>
        </cfoutput>
		</td>
	</tr>
</table>
</cfif>
<cfoutput>
	<cfif isdefined('form.btnAgregarInfo')>
        <script language="JavaScript" type="text/javascript">
             if (window.opener.funcRefrescar) {window.opener.funcRefrescar()}
             window.close();
        </script>
    </cfif>

	<script language="JavaScript" type="text/javascript">
        function validar(){

            var msj = "Se presentaron los siguientes errores: \n";
            var  res = true;
                if(document.formPopUp.txtTipo.value==""){
                msj = msj + " -El campo Tipo es requerido \n";
                res = false;
                }
                if(document.formPopUp.txtBanco.value==""){
                msj = msj + " -El campo Banco es requerido \n";
                res = false;
                }
                if(document.formPopUp.txtNumDocumento.value==""){
                msj = msj + " -El campo Numero de Documento es requerido \n";
                res = false;
                }
                if(document.formPopUp.txtRFC.value==""){
                msj = msj + " -El campo RFC es requerido \n";
                res = false;
                }
                if(document.formPopUp.txtBeneficiario.value==""){
                msj = msj + " -El campo Beneficiario es requerido \n";
                res = false;
                }
                if(document.formPopUp.txtCuentaOrigen.value==""){
                msj = msj + " -El campo Cuenta Origen es requerido \n";
                res = false;
                }
                if(document.formPopUp.txtMonto.value==""){
                msj = msj + " -El campo Monto es requerido \n";
                res = false;
                }
                if(res == false)
                {
                alert(msj);
                }
            return res;
        }

        function ShowNewPage(idcontable, linea, id){
        	window.location.href="popUp-CEInfoBancaria.cfm?IDContable="+idcontable"+&Dlinea="+linea+"&ID="+id;
        }
    </script>
</cfoutput>