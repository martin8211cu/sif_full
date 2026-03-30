<cfquery name="rsForm" datasource="#Session.Dsn#">
	select a.ACAAid, a.ACAid, a.ACATid, a.ACAAtipo, a.ACAAporcentaje, a.ACAAmonto, a.Did, 
	    a.ACAAfechaInicio, a.BMUsucodigo, a.BMfecha, a.ts_rversion,
        b.DEid, c.DClinea
    from ACAportesAsociado a
		inner join ACAsociados b
        on b.ACAid = a.ACAid
        inner join ACAportesTipo c
        on c.ACATid = a.ACATid
    where a.ACAAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ACAAid#">
</cfquery>
<cfinvoke component="rh.asoc.Componentes.ACParametros" method="init" returnvariable="Parametros">
<cfset Lvar_Periodo = Parametros.Get("10","Periodo")>
<cfset Lvar_Mes = Parametros.Get("20","Mes")>
<cfquery name="rsSaldos" datasource="#Session.Dsn#">
	select 1
    from ACAportesSaldos a
    where a.ACAAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ACAAid#">
      and a.ACASperiodo <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Periodo#">
      and a.ACASmes <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Mes#">
    union
    select 1
    from ACAportesSaldos a
    where a.ACAAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ACAAid#">
      and a.ACASperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Periodo#">
      and a.ACASmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Mes#">
      and (a.ACAAaporteMes > 0.00 or a.ACAAaporteMesInt > 0.00)
</cfquery>
<cfquery name="rsACAportesTipo" datasource="#Session.Dsn#">
    SELECT ACATid, ACATcodigo, ACATdescripcion, TDid, DClinea, ACATorigen
    FROM ACAportesTipo
    WHERE ACATid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.ACATid#">
</cfquery>
<cfset modo = "">
<cfset vNuevo = True>
<cfif len(trim(rsACAportesTipo.TDid)) GT 0 and len(trim(rsForm.Did)) GT 0>
	<cfset modo = "DEDUCCIONES">
	<cfinvoke component="rh.asoc.Componentes.ACDeducciones" method="init" returnvariable="Deducciones">
	<cfset rsDeduccion = Deducciones.getDeduccionesEmpleadoByDid(rsForm.Did,true)>
    <cfset vNuevo = Deducciones.vNuevo(rsForm.Did)>
<cfelseif len(trim(rsACAportesTipo.DClinea)) GT 0 and len(trim(rsForm.DClinea)) GT 0>
	<cfset modo = "CARGAS">
	<cfinvoke component="rh.asoc.Componentes.ACCargas" method="init" returnvariable="Cargas">
	<cfset rsCarga = Cargas.getCargasEmpleado(rsForm.DEid,rsForm.DClinea)>
    <cfset vNuevo = Cargas.vNuevo(rsForm.DEid,rsForm.DClinea)>
</cfif>
<cfset vNuevo = vNuevo AND rsSaldos.recordcount EQ 0>
<cfset Form.ACAid = rsForm.ACAid>
<cfset Lvar_Activo = 0>
<cfinclude template="/rh/asoc/portlets/pAsociado.cfm">
<table width="470" align="center" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>
        <cfoutput>
        <form action="registroCuentasAhorro-sql.cfm" method="post" name="form1">
            <input type="hidden" name="DEid" value="#rsForm.DEid#">
            <input type="hidden" name="ACAid" value="#rsForm.ACAid#">
            <input type="hidden" name="ACATid" value="#rsForm.ACATid#">
            <input type="hidden" name="ACAAid" value="#rsForm.ACAAid#">
			<cfset ts = "">	
            <cfinvoke 
                component="sif.Componentes.DButils"
                method="toTimeStamp"
                returnvariable="ts">
                    <cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
            </cfinvoke>
            <input type="hidden" name="ts_rversion" value="#ts#">
            <cfif (modo EQ "DEDUCCIONES")>
                <input type="hidden" name="Did" value="#rsForm.Did#">
                <cfif not vNuevo>
                <input type="hidden" name="ACAAtipo" value="#rsForm.ACAAtipo#">
                <input type="hidden" name="ACAAporcentaje" value="#rsForm.ACAAporcentaje#">
                <input type="hidden" name="ACAAfechaInicio" value="#rsForm.ACAAfechaInicio#">
				</cfif>
			</cfif>
            <cfif (modo EQ "CARGAS")>
            	<input type="hidden" name="DClinea" value="#rsForm.DClinea#">
                <input type="hidden" name="ACAAtipo" value="#rsForm.ACAAtipo#">
                <input type="hidden" name="ACAAporcentaje" value="#rsForm.ACAAporcentaje#">
                <input type="hidden" name="ACAAmonto" value="#rsForm.ACAAmonto#">
                <cfif  not vNuevo><input type="hidden" name="ACAAfechaInicio" value="#rsForm.ACAAfechaInicio#"></cfif>
            </cfif>
            <table width="100%" border="0" cellspacing="2" cellpadding="2" align="center">
                <tr>
                    <td nowrap align="right"><strong>#LB_Tipo_de_Aporte#:</strong>  #rsACAportesTipo.ACATcodigo# #rsACAportesTipo.ACATdescripcion#</td>
                    <td nowrap="nowrap">
                      <strong>#LB_Fecha_de_Inicio#:</strong> #LSDateFormat(rsForm.ACAAFechaInicio,'dd/mm/yyyy')#
                    </td>
                </tr>
                <cfif modo EQ "DEDUCCIONES" and not vNuevo>
					<tr>
						<td colspan="2" align="center">
							<fieldset>
								<legend><strong>#LB_DeduccionRelacionada#</strong></legend>
								<table width="100%" border="0" cellspacing="2" cellpadding="2" align="center">
									<tr>
										<td nowrap><strong>#LB_Descripcion#</strong></td>
										<td nowrap>#rsDeduccion.Ddescripcion#</td>
										<td nowrap><strong>#LB_Fecha_de_Inicio#</strong></td>
										<td nowrap>#LSDateFormat(rsDeduccion.Dfechaini,'dd/mm/yyyy')#</td>
									</tr>
									<tr>
										<td nowrap><strong><cfif rsDeduccion.Dmetodo EQ 0>#LB_Porcentaje#<cfelse>#LB_Monto#</cfif></strong></td>
										<td nowrap> <cf_inputNumber name="ACAAmonto" value="#rsForm.ACAAmonto#"><!--- #LSCurrencyFormat(rsDeduccion.Dvalor,'none')# ---><cfif rsDeduccion.Dmetodo EQ 0>%</cfif></td>
										<td nowrap><strong>#LB_Fecha_Final#</strong></td>
										<td nowrap><cfif len(trim(rsDeduccion.Dfechafin)) GT 0>#LSDateFormat(rsDeduccion.Dfechafin,'dd/mm/yyyy')#<cfelse>#LB_Indefinido#</cfif></td>
									</tr>
								</table>
							</fieldset>
						</td>
					</tr>
				<cfelseif modo EQ "CARGAS">
                        <tr>
                            <td colspan="2" align="center">
                                <fieldset>
                                    <legend>#LB_CargaRelacionada#</legend>
                                    <table width="100%" border="0" cellspacing="2" cellpadding="2" align="center">
                                        <tr>
                                            <td nowrap><strong>#LB_Descripcion#</strong></td>
                                            <td nowrap>#rsCarga.DCdescripcion#</td>
                                            <td nowrap><strong>#LB_Fecha_de_Inicio#</strong></td>
                                            <td nowrap>
                                            	<cfif vNuevo>
                                                	<cf_sifcalendario name="ACAAfechaInicio" value="#LSDateFormat(rsForm.ACAAfechaInicio,'dd/mm/yyyy')#">
                                            	<cfelse>
	                                                #LSDateFormat(rsCarga.CEdesde,'dd/mm/yyyy')#
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
                                            <td nowrap><cfif len(trim(rsCarga.CEhasta)) GT 0>#LSDateFormat(rsCarga.CEhasta,'dd/mm/yyyy')#<cfelse>#LB_Indefinido#</cfif></td>
                                        </tr>
                                    </table>
                                </fieldset>
                            </td>
                        </tr>
            <cfelse>
          	            <tr>
                            <td colspan="2" align="center">
                                <fieldset>
                                    <legend>Nueva #LB_Deduccion#</legend>
                                    <table width="100%" border="0" cellspacing="2" cellpadding="2" align="center">
                                        <tr>
                                            <td nowrap align="right"><strong>#LB_Fecha_de_Inicio#:</strong></td>
                                            <td>
                                                <cf_sifcalendario name="ACAAfechaInicio" value="#LSDateFormat(rsForm.ACAAfechaInicio,'dd/mm/yyyy')#">
                                            </td>
                                        </tr>
										<tr>
                                            <td nowrap align="right"><strong>#LB_Tipo#:</strong></td>
                                            <td>
                                                <select name="ACAAtipo" onchange="javascript: funcChangeTipo();">
                                                  <option value="P" <cfif rsForm.ACAAtipo EQ "P">selected</cfif>>Porcentaje</option>
                                                  <option value="M" <cfif rsForm.ACAAtipo EQ "M">selected</cfif>>Monto</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap align="right" id="tdPorcentajeLb" style="visibility:"><strong>#LB_Porcentaje#:</strong></td>
                                            <td align="left" id="tdPorcentajeFld" style="visibility:">
                                                <cf_inputNumber name="ACAAporcentaje" value="#rsForm.ACAAporcentaje#" enteros="2" decimales="2">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td nowrap align="right" id="tdMontoLb" style="visibility:"><strong>#LB_Monto#:</strong></td>
                                            <td align="left" id="tdMontoFld" style="visibility:">
                                                <cf_inputNumber name="ACAAmonto" value="#rsForm.ACAAmonto#">
                                            </td>
                                        </tr>
                                    </table>
                                </fieldset>
                            </td>
                        </tr>
			</cfif>
			<tr>
				<td colspan="2" nowrap="nowrap" align="center">
				<cfset exclude = "">
				<cfif not vNuevo><cfif modo EQ "CARGAS"><cfset exclude = "Cambio,Baja"><cfelse><cfset exclude = "Baja"></cfif></cfif>
				<cf_botones modo="CAMBIO" exclude="#exclude#" include="Regresar">
				</td>
			</tr>
        </form>
        </cfoutput>
		</table>
    </td>
  </tr>
</table>
<cf_qforms>
	<cfif modo EQ "DEDUCCIONES" and not vNuevo>
	<cfelseif modo EQ "CARGAS">
    	<cf_qformsrequiredfield args="ACAAfechaInicio,#LB_Fecha_de_Inicio#">
	<cfelse>
        <cf_qformsrequiredfield args="ACAAfechaInicio,#LB_Fecha_de_Inicio#">
        <cf_qformsrequiredfield args="ACAAtipo,#LB_Tipo#">
        <cf_qformsrequiredfield args="ACAAporcentaje,#LB_Porcentaje#">
        <cf_qformsrequiredfield args="ACAAmonto,#LB_Monto#">
    </cfif>
</cf_qforms>
<cfoutput>
<script language="javascript" type="text/javascript">
<cfif modo EQ "DEDUCCIONES" and not vNuevo>
<cfelseif modo EQ "CARGAS">
<cfelse>
	function funcChangeTipo(){
		var vTipo = document.form1.ACAAtipo.value;
		if (vTipo=='P')	{
			document.form1.ACAAmonto.value='0.00';
			document.form1.ACAAporcentaje.disabled=false;
			document.form1.ACAAmonto.disabled=true;
		} else {
			document.form1.ACAAporcentaje.value='0.00';
			document.form1.ACAAporcentaje.disabled=true;
			document.form1.ACAAmonto.disabled=false;
		}
	}
	funcChangeTipo();
</cfif>
	function funcNuevo(){
		document.form1.ACAAid.value = "";
		document.form1.action = "registroCuentasAhorro.cfm";
	}
</script>
</cfoutput>