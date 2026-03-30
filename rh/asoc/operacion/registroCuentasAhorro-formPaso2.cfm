<cfquery name="rsACAportesTipo" datasource="#Session.Dsn#">
    SELECT ACATid, ACATcodigo, ACATdescripcion, TDid, DClinea, ACATorigen
    FROM ACAportesTipo
    WHERE ACATid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ACATid#">
</cfquery>
<cfset modo = "">
<cfquery name="rsAsociadoID" datasource="#Session.Dsn#">
	SELECT ACAid 
    FROM ACAsociados
    WHERE DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
</cfquery>
<cfset Form.ACAid = rsAsociadoID.ACAid>

<cfinvoke component="rh.asoc.Componentes.ACAportesAsociado" method="init" returnvariable="Aporte">
<cfset ExisteAporte = Aporte.ExisteAporte(form.ACAid,rsACAportesTipo.ACATid)>

<cfif len(trim(rsACAportesTipo.TDid)) GT 0>
	<cfset modo = "DEDUCCIONES">
	<cfinvoke component="rh.asoc.Componentes.ACDeducciones" method="init" returnvariable="Deducciones">
	<cfset rsDeducciones = Deducciones.getDeduccionesEmpleado(Form.DEid,rsACAportesTipo.TDid)>
<cfelseif len(trim(rsACAportesTipo.DClinea)) GT 0>
	<cfset modo = "CARGAS">
	<cfinvoke component="rh.asoc.Componentes.ACCargas" method="init" returnvariable="Cargas">
	<cfset rsCargas = Cargas.getCargasEmpleado(Form.DEid,rsACAportesTipo.DClinea)>
</cfif>

<cfset Lvar_Activo = 0>
<cfinclude template="/rh/asoc/portlets/pAsociado.cfm">
<cfif isdefined("rsAsociado.Tcodigo") and len(trim(rsAsociado.Tcodigo)) GT 0 and rsAsociado.Tcodigo GT 0>
    <cfquery name="rsCalendarioPagos" datasource="#session.dsn#">
        select min(CPdesde) as CPdesde
        from CalendarioPagos b
        where b.Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsAsociado.Tcodigo#">
          and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
          and b.CPfcalculo is null
          and b.CPtipo in(0,2)
    </cfquery>
</cfif>
<table width="400" align="center" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="center">
        <cfoutput>
        <form action="registroCuentasAhorro.cfm" method="post" name="form1">
            <input type="hidden" name="DEid" value="#Form.DEid#">
            <input type="hidden" name="ACATid" value="#Form.ACATid#">
            <input type="hidden" name="Paso" value="#Form.Paso#"> 
            <cfif (modo EQ "DEDUCCIONES")>
            <input type="hidden" name="Did" <cfif (rsDeducciones.recordcount GT 0)>value="#rsDeducciones.Did#"</cfif>>
            </cfif>
            <cfif (modo EQ "CARGAS")>
            <input type="hidden" name="DClinea" value="#rsCargas.DClinea#">
            </cfif>
            <table width="100%" border="0" cellspacing="2" cellpadding="2" align="center">
                <tr>
                    <td nowrap align="right"><strong>#LB_Tipo_de_Aporte#:</strong></td>
                    <td>
                        #rsACAportesTipo.ACATcodigo# #rsACAportesTipo.ACATdescripcion#
                    </td>
                </tr>
                <cfif modo EQ "DEDUCCIONES">
					<cfloop query="rsDeducciones">
                    	<cfquery name="rsvACAportesAsociado" datasource="#session.dsn#">
                        	select 1 from ACAportesAsociado where ACAestado = 0 and Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDeducciones.Did#">
                        </cfquery>
                        <cfset Lvar_dedHab = (rsvACAportesAsociado.recordcount EQ 0)>
                        <cfset Lvar_dedSel = 0>
                        <tr>
                        	<td colspan="2">
                                <fieldset>
                                    <legend>
                                        <input type="radio" name="opt" id="opt" onclick="javascript: funcSetDeduccion(#Did#);" <cfif not Lvar_dedHab>disabled<cfelseif Lvar_dedHab and Lvar_dedSel EQ 0><cfset Lvar_dedSel = Lvar_dedSel + 1>checked</cfif> /> <label for="opt">#Ddescripcion#</label>
                                    </legend>
                                    <table width="100%" border="0" cellspacing="2" cellpadding="2">
                                        <cfif not Lvar_dedHab>
                                            <tr>
                                                <td colspan="4" style="color:##FF0000" nowrap="nowrap">
                                                    <strong>#MSG2_Paso2Deducciones#</strong>
                                                </td>
                                            </tr>
                                        </cfif>
                                        <tr>
                                            <td nowrap><strong>#LB_Descripcion#</strong></td>
                                            <td nowrap>#Ddescripcion#</td>
                                            <td nowrap><strong>#LB_Fecha_de_Inicio#</strong></td>
                                            <td nowrap>#LSDateFormat(Dfechaini,'dd/mm/yyyy')#</td>
                                        </tr>
                                        <tr>
                                            <td nowrap><strong><cfif Dmetodo EQ 0>#LB_Porcentaje#<cfelse>#LB_Monto#</cfif></strong></td>
                                            <td nowrap>#LSCurrencyFormat(Dvalor,'none')#<cfif Dmetodo EQ 0>%</cfif></td>
                                            <td nowrap><strong>#LB_Fecha_Final#</strong></td>
                                            <td nowrap><cfif len(trim(Dfechafin)) GT 0>#LSDateFormat(Dfechafin,'dd/mm/yyyy')#<cfelse>#LB_Indefinido#</cfif></td>
                                        </tr>
                                    </table>
                                </fieldset>
                            </td>
                        </tr>
					</cfloop>
				<cfelseif modo EQ "CARGAS">
					<cfloop query="rsCargas">
                        <cfquery name="rsvACAportesAsociado" datasource="#session.dsn#">
                        	select 1 
							from ACAportesAsociado a
							inner join ACAportesTipo b
								on b.ACATid = a.ACATid
							inner join ACAsociados c
								on c.ACAid = a.ACAid
                            where a.ACATid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ACATid#">
							  and a.ACAestado = 0
                            and b.DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCargas.DClinea#">
                            and c.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
                        </cfquery>
                        <cfset Lvar_carHab = (rsvACAportesAsociado.recordcount EQ 0)>
                        <cfset Lvar_carSel = 0>
<!---                         <cfif rsCargas.currentrow eq 1>
                            <tr>
                                <td colspan="2" style="color:##FF0000" nowrap="nowrap">
	                                <strong>#MSG_Paso2Cargas#</strong>
                                </td>
                            </tr>
                        </cfif> --->
                        <tr>
                            <td colspan="2">
                                <fieldset>
                                    <legend>
                                        <input type="radio" name="opt" id="opt"  onclick="javascript: funcSetCarga(#DClinea#);" <cfif not Lvar_carHab>disabled<cfelseif Lvar_carHab and Lvar_carSel EQ 0><cfset Lvar_carSel = Lvar_carSel + 1>checked</cfif> /> <label for="opt">#DCdescripcion#</label>
                                    </legend>
                                    <table width="100%" border="0" cellspacing="2" cellpadding="2">
                                        <tr>
                                            <td nowrap><strong>#LB_Descripcion#</strong></td>
                                            <td nowrap>#DCdescripcion#</td>
                                            <td nowrap><strong>#LB_Fecha_de_Inicio#</strong></td>
                                            <td nowrap>#LSDateFormat(Now(),'dd/mm/yyyy')#</td>
                                        </tr>
                                        <tr>
                                            <td nowrap><strong><cfif DCmetodo EQ 1>#LB_Porcentaje#<cfelse>#LB_Monto#</cfif></strong></td>
                                            <td nowrap>
                                                <cfif rsACAportesTipo.ACATorigen EQ 'O'>
                                                    #LSCurrencyFormat(DCvaloremp,'none')#<cfif DCmetodo EQ 1>%</cfif>
                                                <cfelseif rsACAportesTipo.ACATorigen EQ 'P'>
                                                    #LSCurrencyFormat(DCvalorpat,'none')#<cfif DCmetodo EQ 1>%</cfif>
                                                </cfif>
                                            </td nowrap>
                                            <td nowrap><strong>#LB_Fecha_Final#</strong></td>
                                            <td nowrap>#LB_Indefinido#</td>
                                        </tr>
                                    </table>
                                </fieldset>
                            </td>
                        </tr>
					</cfloop>
			</cfif>
			<cfif not ExisteAporte>
            <tr>
                <td colspan="2">
                    <fieldset>
                        <legend>
                            <input type="radio" name="opt" id="opt" 
								<cfif (modo EQ "CARGAS" and rsCargas.recordcount GT 0) or (modo EQ "DEDUCCIONES" and rsDeducciones.recordcount) >disabled</cfif> 
								<cfif (modo EQ "DEDUCCIONES" and rsDeducciones.recordcount EQ 0) 
									or (modo EQ "CARGAS" and rsCargas.recordcount EQ 0)>checked</cfif> 
                            	onclick="javascript: funcNueva();"
                            /> 
                            <label for="opt">
                            	Nueva 
									<cfif MODO EQ "DEDUCCIONES">#LB_Deduccion#
									<cfelseif MODO EQ "CARGAS">#LB_Carga#
									</cfif>
                            </label>
                        </legend>
						<table width="100%" border="0" cellspacing="2" cellpadding="2">
                          <tr>
                            <td nowrap align="right"><strong>#LB_Fecha_de_Inicio#:</strong></td>
                            <td>
                               <!---  <cfif isdefined("rsCalendarioPagos") and rsCalendarioPagos.recordcount GT 0 and not (modo EQ "CARGAS" and rsCargas.recordcount GT 0)>
                                    <cfset ACAAfechaInicioValue = rsCalendarioPagos.CPdesde>
                                    <cf_sifcalendario name="ACAAfechaInicio" value="#LSDateFormat(ACAAfechaInicioValue,'dd/mm/yyyy')#" readonly="#modo EQ 'DEDUCCIONES' and rsDeducciones.recordcount GT 0#">
                                <cfelse> --->
                                    <cf_sifcalendario name="ACAAfechaInicio" value="#LSDateFormat(Now(),'dd/mm/yyyy')#"  readonly="#(modo EQ 'CARGAS' and rsCargas.recordcount GT 0) or (modo EQ 'DEDUCCIONES' and rsDeducciones.recordcount GT 0)#">
                               <!---  </cfif> --->
                            </td>
                            <td width="100%">&nbsp;</td>
                          </tr>
						</table>
                    </fieldset>
                </td>
            </tr>
			</cfif>
			<cfset Lvar_botonesInc=''>
			<cfif not ExisteAporte><cfset Lvar_botonesInc = 'Siguiente'></cfif>
            <cf_botones modo="ALTA" includebefore="Anterior" include="#Lvar_botonesInc#" exclude="ALTA">
        </form>
        </cfoutput>
    </td>
  </tr>
</table>
<cf_qforms>
	<cfif not ExisteAporte>
	<cfif modo EQ "DEDUCCIONES">
        <cf_qformsrequiredfield args="opt,#JS_Deduccion#">
    <cfelseif modo EQ "CARGAS">
        <cf_qformsrequiredfield args="opt,#LB_Carga#">
    </cfif>
	<cfif NOT (modo EQ "CARGAS" and rsCargas.recordcount GT 0)>
        <cf_qformsrequiredfield args="ACAAfechaInicio,#LB_Fecha_de_Inicio#">
    </cfif>
	</cfif>
</cf_qforms>
<cfoutput>
<script language="javascript" type="text/javascript">
	function funcSiguiente(){
		<cfif (modo EQ "DEDUCCIONES")>
		objForm.ACAAfechaInicio.required = document.form1.Did.value=='';
		<cfelseif (modo EQ "CARGAS")>
		objForm.ACAAfechaInicio.required = document.form1.DClinea.value=='';
		</cfif>
		document.form1.Paso.value=#Form.Paso+1#;
		document.form1.action = "registroCuentasAhorro.cfm";
	}
	function funcAnterior(){
		deshabilitarValidacion();
		document.form1.Paso.value=#Form.Paso-1#;
		document.form1.action = "registroCuentasAhorro.cfm";
	}
	<cfif (modo EQ "DEDUCCIONES")>
	function  funcSetDeduccion(Did){
		document.form1.Did.value=Did;
	}
	</cfif>
	<cfif (modo EQ "CARGAS")>
	function  funcSetCarga(DClinea){
		document.form1.DClinea.value=DClinea;
	}
	</cfif>
	function funcNueva(){
		<cfif (modo EQ "DEDUCCIONES")>
		document.form1.Did.value='';
		<cfelseif (modo EQ "CARGAS")>
		document.form1.DClinea.value='';
		</cfif>
	}
</script>
</cfoutput>