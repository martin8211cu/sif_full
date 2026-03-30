<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 2-3-2006.
		Motivo: Se utiliza la tabla CGPeriodosProcesados para sacar el combo de los periodos y así mejorar el 
		rendimiento de la pantalla. 
 --->


<cfif isdefined("LvarInfo")>
	<cfset LvarAction     = 'EstadoResultados-result_INFO.cfm'>
	<cfset LvarFuncines   = '../../cg/consultas/Funciones.cfm'>
	<cfset LvarTitle 	  = 'Información hacia Entes Externos'>
<cfelse>
	<cfset LvarAction     = 'EstadoResultados-result.cfm'>
	<cfset LvarFuncines   = 'Funciones.cfm'>
	<cfset LvarTitle 	  = 'Contabilidad General'>
</cfif>

<cfif not isdefined("form.ADMIN")>
	<cfset form.ADMIN = 'N'>
</cfif>
<cf_templateheader title="#LvarTitle#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Estado de Resultados'>
		<cfinclude template="../../portlets/pNavegacion.cfm">
		<cfinclude template="#LvarFuncines#">
		<cfset periodo=get_val(30).Pvalor>
		<cfset mes=get_val(40).Pvalor>
		<cfset formato = get_val(10).Pvalor>
		<cfset cantniv = ArrayLen(listtoarray(formato,'-'))>
		<cfset Unidades = 1 >
		<cfset lvarB15V = get_val(3900).Pvalor>
		<cfif len(trim(lvarB15V)) gt 0>
			<cfset lvarB15M = get_moneda(lvarB15V).Mnombre>
		<cfelse>
			<cfset lvarB15M = "">
		</cfif>
		<cfquery name="rsOficinas" datasource="#Session.DSN#">
			select Ocodigo, Odescripcion 
			from Oficinas 
			where Ecodigo = #Session.Ecodigo#
		</cfquery>

        <cfquery name="rsGruposOficina" datasource="#Session.DSN#">
                select GOid, GOcodigo, GOnombre
                from AnexoGOficina
                where Ecodigo = #session.Ecodigo#
                order by GOcodigo
        </cfquery>

		<cfquery name="rsPeriodos" datasource="#Session.DSN#">
			select distinct Speriodo
			from CGPeriodosProcesados
			where Ecodigo = #session.Ecodigo#
			order by Speriodo desc
		</cfquery>

		<cfquery name="rsMonedas" datasource="#Session.DSN#">
			select Mcodigo as Mcodigo, Mnombre, Msimbolo, Miso4217, ts_rversion 
			from Monedas
			where Ecodigo = #Session.Ecodigo#
		</cfquery>
		
		<cfset longitud = len(Trim(rsMonedas.Miso4217))>
		<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
			select a.Mcodigo, b.Mnombre, b.Msimbolo, b.Miso4217
			from Empresas a, Monedas b 
			where a.Ecodigo = #Session.Ecodigo#
			  and a.Mcodigo = b.Mcodigo
		</cfquery>

		<cfquery name="rsParam" datasource="#Session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo = #Session.Ecodigo#
			and Pcodigo = 660
		</cfquery>
		<cfif rsParam.recordCount> 
			<cfquery name="rsMonedaConvertida" datasource="#Session.DSN#">
				select Mcodigo, Mnombre
				from Monedas
				where Ecodigo = #Session.Ecodigo#
				and Mcodigo = #rsParam.Pvalor#
			</cfquery>
		</cfif>
		<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
		  <form name="form1" method="post" action="<cfoutput>#LvarAction#</cfoutput>" onsubmit="return sinbotones()">
            <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
              <tr>
                <td colspan="4">&nbsp; </td>
              </tr>
              <tr>
                <td width="30%" align="right">Grupo Oficina:</td>
                <td width="24%">
					<select name="GOid">
						<option value="-1">Todas</option>
						<cfoutput query="rsGruposOficina">
						  <option value="#GOid#">#GOnombre#</option>
						</cfoutput>
                	</select>
				</td>
              <tr>
                <td width="30%" align="right">Oficina:</td>
                <td width="24%">
					<select name="Oficina">
						<option value="-1">Todas</option>
						<cfoutput query="rsOficinas">
						  <option value="#Ocodigo#">#Odescripcion#</option>
						</cfoutput>
                	</select>
				</td>
                <td align="right">Per&iacute;odo:</td>
                <td>
                  <select name="periodo">
						<cfloop query = "rsPeriodos">
							<option value="<cfoutput>#rsPeriodos.Speriodo#</cfoutput>"><cfoutput>#rsPeriodos.Speriodo#</cfoutput></option>" <cfif periodo EQ "#rsPeriodos.Speriodo#">selected</cfif>></option>
						</cfloop>
		           </select>
                </td>
              </tr>
              <tr>
                <td align="right">Moneda:</td>
                <td rowspan="2" valign="top"><table border="0" cellspacing="0" cellpadding="2">
                  <tr>
                    <td nowrap><input name="mcodigoopt" type="radio" value="-2" checked></td>
                    <td nowrap> Local:</td>
                    <td><cfoutput><strong>#rsMonedaLocal.Mnombre#</strong></cfoutput></td>
                  </tr>
                  <cfif isdefined("rsMonedaConvertida")>
                    <tr>
                      <td nowrap><input name="mcodigoopt" type="radio" value="-3" tabindex="6"></td>
                      <td nowrap>                      Convertida:</td>
                      <td><cfoutput><strong>#rsMonedaConvertida.Mnombre#</strong></cfoutput></td>
                    </tr>
					</cfif>
					<tr>
				  	  <td nowrap><input name="mcodigoopt" type="radio" value="-4" tabindex="6"></td>
				  	  <td nowrap>                      Informe B15:</td>
				  	  <td><cfoutput><strong>#lvarB15M#</strong><input name="Mcodigo" type="hidden" value="#lvarB15V#"></cfoutput></td>
					</tr>
                    <tr>
                      <td nowrap><input name="mcodigoopt" type="radio" value="0"></td>
                      <td nowrap> Origen:</td>
                      <td><select name="Mcodigo">
                          <cfoutput query="rsMonedas">
                            <option value="#rsMonedas.Mcodigo#"
						   <cfif isdefined('rsMonedas') and isdefined('rsMonedaLocal')>
								<cfif rsMonedas.Mcodigo EQ rsMonedaLocal.Mcodigo >selected</cfif>
							</cfif>
							>#rsMonedas.Mnombre#</option>
                          </cfoutput>
                      </select></td>
                    </tr>
                </table>
                </td>
                <td width="4%" align="right" >Mes:</td>
                <td width="42%">
                  <select name="mes" size="1">
                    <option value="1" <cfif mes EQ 1>selected</cfif>>Enero</option>
                    <option value="2" <cfif mes EQ 2>selected</cfif>>Febrero</option>
                    <option value="3" <cfif mes EQ 3>selected</cfif>>Marzo</option>
                    <option value="4" <cfif mes EQ 4>selected</cfif>>Abril</option>
                    <option value="5" <cfif mes EQ 5>selected</cfif>>Mayo</option>
                    <option value="6" <cfif mes EQ 6>selected</cfif>>Junio</option>
                    <option value="7" <cfif mes EQ 7>selected</cfif>>Julio</option>
                    <option value="8" <cfif mes EQ 8>selected</cfif>>Agosto</option>
                    <option value="9" <cfif mes EQ 9>selected</cfif>>Setiembre</option>
                    <option value="10" <cfif mes EQ 10>selected</cfif>>Octubre</option>
                    <option value="11" <cfif mes EQ 11>selected</cfif>>Noviembre</option>
                    <option value="12" <cfif mes EQ 12>selected</cfif>>Diciembre</option>
                  </select>
                </td>
              </tr>
              <tr>
                <td align="right">&nbsp;</td>
                <td align="right">Nivel:</td>
                <td>
                  <select name="nivel">
                    <cfloop index="i" from="1" to="#cantniv#">
                      <option value="<cfoutput>#i#</cfoutput>" <cfif i EQ 2>selected</cfif>><cfoutput>#i#</cfoutput></option>
                    </cfloop>
                  </select>
                </td>
              </tr>

              <tr>
			  	<td></td>
                <td><input type="checkbox" name="toExcel"/>Generar a Excel </td>
				<td align="right" >Unidades:</td>
				<td> 
					<select name="Unidades" size="1" tabindex="1">
						<option value="1" <cfif Unidades EQ 1>selected</cfif>>Moneda</option>
						<option value="1000" <cfif Unidades EQ 2>selected</cfif>>Miles</option>
						<option value="1000000" <cfif Unidades EQ 3>selected</cfif>>Millones</option>
					</select> 
				</td>              
			  
			  </tr>

              <tr>
                <td colspan="4" align="rigth">&nbsp;</td>
              </tr>
              <tr>
                <td colspan="4" align="center">
                 <input type="submit" name="Submit" value="Consultar">
                </td>
              </tr>
              <tr>
                <td colspan="4">&nbsp;</td>
              </tr>
            </table>
			<cfoutput>
			<input type="hidden" name="ADMIN" value= "#form.ADMIN#" >
			</cfoutput>
		</form>
	<cf_web_portlet_end>
<cf_templatefooter>
