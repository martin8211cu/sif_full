<cfquery name="rsACAportesTipo" datasource="#Session.Dsn#">
    SELECT ACATid, ACATcodigo, ACATdescripcion, TDid, DClinea, ACATorigen
    FROM ACAportesTipo
    WHERE ACATid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ACATid#">
</cfquery>
<cfset Lvar_CARGANEW = FALSE>
<cfif len(trim(rsACAportesTipo.DClinea)) GT 0 and len(trim(Form.DClinea)) EQ 0 >
	<cfset Form.DClinea = rsACAportesTipo.DClinea>
    <cfset Lvar_CARGANEW = TRUE>
</cfif>
<cfset modo = "">
<cfif len(trim(rsACAportesTipo.TDid)) GT 0 and len(trim(Form.Did)) GT 0>
	<cfset modo = "DEDUCCIONES">
	<cfinvoke component="rh.asoc.Componentes.ACDeducciones" method="init" returnvariable="Deducciones">
	<cfset rsDeduccion = Deducciones.getDeduccionesEmpleadoByDid(Form.Did)>
<cfelseif len(trim(rsACAportesTipo.DClinea)) GT 0 and len(trim(Form.DClinea)) GT 0>
	<cfset modo = "CARGAS">
	<cfinvoke component="rh.asoc.Componentes.ACCargas" method="init" returnvariable="Cargas">
	<cfset rsCarga = Cargas.getCargasEmpleado(Form.DEid,Form.DClinea)>
</cfif>
<cfquery name="rsAsociadoID" datasource="#Session.Dsn#">
	SELECT ACAid 
    FROM ACAsociados
    WHERE DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
</cfquery>
<cfset Form.ACAid = rsAsociadoID.ACAid>
<cfset Lvar_Activo = 0>
<cfinclude template="/rh/asoc/portlets/pAsociado.cfm">
<table width="400" align="center" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
        <cfoutput>
        <form action="registroCuentasAhorro-sql.cfm" method="post" name="form1">
            <input type="hidden" name="DEid" value="#Form.DEid#">
            <input type="hidden" name="ACAid" value="#Form.ACAid#">
            <input type="hidden" name="ACATid" value="#Form.ACATid#">
            <input type="hidden" name="Paso" value="#Form.Paso#"> 
            <cfif (modo EQ "DEDUCCIONES")>
                <input type="hidden" name="Did" value="#rsDeduccion.Did#">
                <input type="hidden" name="ACAAtipo" value="<cfif rsDeduccion.Dmetodo EQ 0>P<cfelse>M</cfif>">
                <input type="hidden" name="ACAAporcentaje" value="<cfif rsDeduccion.Dmetodo EQ 0>#rsDeduccion.Dvalor#<cfelse>0.00</cfif>">
                <input type="hidden" name="ACAAmonto" value="<cfif rsDeduccion.Dmetodo EQ 0>0.00<cfelse>#rsDeduccion.Dvalor#</cfif>">
                <input type="hidden" name="ACAAfechaInicio" value="#rsDeduccion.Dfechaini#">
			</cfif>
            <cfif (modo EQ "CARGAS")>
            	<input type="hidden" name="DClinea" value="#Form.DClinea#">
                <input type="hidden" name="ACAAtipo" value="<cfif rsCarga.DCmetodo EQ 0>M<cfelse>P</cfif>">
                <input type="hidden" name="ACAAporcentaje" value="<cfif rsCarga.DCmetodo GT 0><cfif rsACAportesTipo.ACATorigen EQ 'O'>#rsCarga.DCvaloremp#<cfelse>#rsCarga.DCvalorpat#</cfif><cfelse>0.00</cfif>">
                <input type="hidden" name="ACAAmonto" value="<cfif rsCarga.DCmetodo EQ 0><cfif rsACAportesTipo.ACATorigen EQ 'O'>#rsCarga.DCvaloremp#<cfelse>#rsCarga.DCvalorpat#</cfif><cfelse>0.00</cfif>">
                <cfif not Lvar_CARGANEW><input type="hidden" name="ACAAfechaInicio" value="#LSDateFormat(Now(),'dd/mm/yyyy')#"></cfif>
            </cfif>
            <table width="100%" border="0" cellspacing="2" cellpadding="2">
                <tr>
                    <td nowrap align="right"><strong>#LB_Tipo_de_Aporte#:</strong></td>
                    <td colspan="2">
                        #rsACAportesTipo.ACATcodigo# #rsACAportesTipo.ACATdescripcion#
                    </td>
                </tr>
                <cfif modo EQ "DEDUCCIONES">
					    <tr>
                        	<td colspan="2">
                                <fieldset>
                                    <legend>#rsDeduccion.Ddescripcion#</legend>
                                    <table width="100%" border="0" cellspacing="2" cellpadding="2">
                                        <tr>
                                            <td nowrap><strong>#LB_Descripcion#</strong></td>
                                            <td nowrap>#rsDeduccion.Ddescripcion#</td>
                                            <td nowrap><strong>#LB_Fecha_de_Inicio#</strong></td>
                                            <td nowrap>#LSDateFormat(rsDeduccion.Dfechaini,'dd/mm/yyyy')#</td>
                                        </tr>
                                        <tr>
                                            <td nowrap><strong><cfif rsDeduccion.Dmetodo EQ 0>#LB_Porcentaje#<cfelse>#LB_Monto#</cfif></strong></td>
                                            <td nowrap>#LSCurrencyFormat(rsDeduccion.Dvalor,'none')#<cfif rsDeduccion.Dmetodo EQ 0>%</cfif></td>
                                            <td nowrap><strong>#LB_Fecha_Final#</strong></td>
                                            <td nowrap><cfif len(trim(rsDeduccion.Dfechafin)) GT 0>#LSDateFormat(rsDeduccion.Dfechafin,'dd/mm/yyyy')#<cfelse>#LB_Indefinido#</cfif></td>
                                        </tr>
                                    </table>
                                </fieldset>
                            </td>
                        </tr>
				<cfelseif modo EQ "CARGAS">
                        <tr>
                            <td colspan="2">
                                <fieldset>
                                    <legend>#rsCarga.DCdescripcion#</legend>
                                    <table width="100%" border="0" cellspacing="2" cellpadding="2">
                                        <tr>
                                            <td nowrap><strong>#LB_Descripcion#</strong></td>
                                            <td nowrap>#rsCarga.DCdescripcion#</td>
                                            <td nowrap><strong>#LB_Fecha_de_Inicio#</strong></td>
                                            <td nowrap>
                                            	<cfif Lvar_CARGANEW>
													<cf_sifcalendario name="ACAAfechaInicio" value="#Form.ACAAfechaInicio#">
												<cfelse>
	                                                #LSDateFormat(Now(),'dd/mm/yyyy')#
                                                </cfif>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap><strong><cfif rsCarga.DCmetodo EQ 1>#LB_Porcentaje#<cfelse>#LB_Monto#</cfif></strong></td>
                                            <td nowrap>
                                                <cfif rsACAportesTipo.ACATorigen EQ 'O'>
                                                    #LSCurrencyFormat(rsCarga.DCvaloremp,'none')#<cfif rsCarga.DCmetodo EQ 1>%</cfif>
                                                <cfelseif rsACAportesTipo.ACATorigen EQ 'P'>
                                                    #LSCurrencyFormat(rsCarga.DCvalorpat,'none')#<cfif rsCarga.DCmetodo EQ 1>%</cfif>
                                                </cfif>
                                            </td nowrap>
                                            <td nowrap><strong>#LB_Fecha_Final#</strong></td>
                                            <td nowrap>#LB_Indefinido#</td>
                                        </tr>
                                    </table>
                                </fieldset>
                            </td>
                        </tr>
            <cfelse>
          	            <tr>
                            <td colspan="2">
                                <fieldset>
                                    <legend> Nueva 
                                                <cfif len(trim(rsACAportesTipo.TDid)) GT 0 >
                                                    #LB_Deduccion#
                                                <cfelseif len(trim(rsACAportesTipo.DClinea)) GT 0 >
                                                    #LB_Carga#
                                                </cfif>
                                    </legend>
                                    <table width="100%" border="0" cellspacing="2" cellpadding="2">
                                        <tr>
                                            <td nowrap align="right"><strong>#LB_Fecha_de_Inicio#:</strong></td>
                                            <td>
                                                <cf_sifcalendario name="ACAAfechaInicio" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
                                            </td>
                                            <td width="100%">&nbsp;</td>
                                        </tr>
										<tr>
                                            <td nowrap align="right"><strong>#LB_Tipo#:</strong></td>
                                            <td>
                                                <select name="ACAAtipo" onchange="javascript: funcChangeTipo();">
                                                  <option value="P" >Porcentaje</option>
                                                  <option value="M" >Monto</option>
                                                </select>
                                            </td>
                                            <td>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td nowrap align="right" id="tdPorcentajeLb" style="visibility:"><strong>#LB_Porcentaje#:</strong></td>
                                            <td align="right" id="tdPorcentajeFld" style="visibility:">
                                                <cf_inputNumber name="ACAAporcentaje" enteros="2" decimales="2">
                                            </td>
                                            <td>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td nowrap align="right" id="tdMontoLb" style="visibility:"><strong>#LB_Monto#:</strong></td>
                                            <td align="right" id="tdMontoFld" style="visibility:">
                                                <cf_inputNumber name="ACAAmonto">
                                            </td>
                                            <td>&nbsp;</td>
                                        </tr>
                                    </table>
                                </fieldset>
                            </td>
                        </tr>
			</cfif>
            <cf_botones modo="ALTA" includebefore="Anterior">
        </form>
        </cfoutput>
    </td>
  </tr>
</table>
<cf_qforms>
	<cfif modo NEQ "DEDUCCIONES" AND modo NEQ "CARGAS">
        <cf_qformsrequiredfield args="ACAAfechaInicio,#LB_Fecha_de_Inicio#">
        <cf_qformsrequiredfield args="ACAAtipo,#LB_Tipo#">
        <cf_qformsrequiredfield args="ACAAporcentaje,#LB_Porcentaje#">
        <cf_qformsrequiredfield args="ACAAmonto,#LB_Monto#">
    </cfif>
</cf_qforms>
<cfoutput>
<script language="javascript" type="text/javascript">
	function funcAnterior(){
		deshabilitarValidacion();
		document.form1.Paso.value=#Form.Paso-1#;
		document.form1.action = "registroCuentasAhorro.cfm";
	}
	<cfif modo NEQ "DEDUCCIONES" AND modo NEQ "CARGAS" and len(trim(rsACAportesTipo.DClinea)) EQ 0 >
	function funcChangeTipo(){
		var vTipo = document.form1.ACAAtipo.value;
		document.form1.ACAAporcentaje.value='0.00';
		document.form1.ACAAmonto.value='0.00';
		if (vTipo=='P')	{
			document.form1.ACAAporcentaje.disabled=false;
			document.form1.ACAAmonto.disabled=true;
		} else {
			document.form1.ACAAporcentaje.disabled=true;
			document.form1.ACAAmonto.disabled=false;
		}
	}
	funcChangeTipo();
	</cfif>
</script>
</cfoutput>