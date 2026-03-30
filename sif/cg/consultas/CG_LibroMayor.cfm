<cfquery name="rsPeriodosProcesados" datasource="#Session.DSN#">
    select distinct Speriodo 
    from CGPeriodosProcesados pp 
    where pp.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
    order by Speriodo desc
</cfquery>

<cfquery name="rsParam" datasource="#Session.DSN#">
    select Pvalor 
    from Parametros where Ecodigo =	<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    and Pcodigo = 660
</cfquery>

<cfif isdefined("url.mes") and len(trim(url.mes))>
  <cfset mes = url.mes>
</cfif>

<cfif isdefined("url.mes2") and len(trim(url.mes2))>
  <cfset mes = url.mes2>
</cfif>

<cfinclude template="Funciones.cfm">
<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>

<cfset periodo="#get_val(30).Pvalor#">
<cfset mes="#get_val(40).Pvalor#">
<cf_templateheader title="Libro Mayor">
	<cfinclude template="../../portlets/pNavegacion.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Libro Mayor'>
	
		<form name="form1" method="post" action="CG_LibroMayor_Reporte.cfm" >
		  <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
			<tr>
			  <td nowrap><div align="right"></div></td>
			  <td width="21%" nowrap><div align="right"></div></td>
			  <td colspan="3">&nbsp;</td>
			</tr>
			<tr>
			  <td nowrap width="19%">&nbsp;</td>
			  <td nowrap><div align="right">Desde:&nbsp;</div></td>
			  <td width="14%" align="left">
			  	<select name="periodoini" tabindex="1">
				  <cfoutput query="rsPeriodosProcesados">
					<option value="#rsPeriodosProcesados.Speriodo#" <cfif isdefined("url.periodo") and url.periodo eq #rsPeriodosProcesados.Speriodo#>selected</cfif>> #rsPeriodosProcesados.Speriodo#</option>
				  </cfoutput>
				</select>
			  </td>
			  <td width="24%"><select name="mesini" size="1" tabindex="2">
				  <option value="1" <cfif mes EQ 1>selected</cfif>>Enero</option>
				  <option value="2" <cfif mes EQ 2>selected</cfif>>Febrero</option>
				  <option value="3" <cfif mes EQ 3>selected</cfif>>Marzo</option>
				  <option value="4" <cfif mes EQ 4>selected</cfif>>Abril</option>
				  <option value="5" <cfif mes EQ 5>selected</cfif>>Mayo</option>
				  <option value="6" <cfif mes EQ 6>selected</cfif>>Junio</option>
				  <option value="7" <cfif mes EQ 7>selected</cfif>>Julio</option>
				  <option value="8" <cfif mes EQ 8>selected</cfif>>Agosto</option>
				  <option value="9" <cfif mes EQ 9>selected</cfif>>Septiembre</option>
				  <option value="10" <cfif mes EQ 10>selected</cfif>>Octubre</option>
				  <option value="11" <cfif mes EQ 11>selected</cfif>>Noviembre</option>
				  <option value="12" <cfif mes EQ 12>selected</cfif>>Diciembre</option>
				</select></td>
			  <td width="22%">&nbsp;</td>
			</tr>
			<tr>
			  <td nowrap>&nbsp;</td>
			  <td nowrap><div align="right">Hasta:&nbsp;</div></td>
			  <td><select name="periodofin" tabindex="3">
				  <cfoutput query="rsPeriodosProcesados">
					<option value="#rsPeriodosProcesados.Speriodo#" <cfif isdefined("url.periodo2") and url.periodo2 eq #rsPeriodosProcesados.Speriodo#>selected</cfif>>#rsPeriodosProcesados.Speriodo#</option>
				  </cfoutput>
				</select>
			  </td>
			  <td><select name="mesfin" size="1" tabindex="4">
				  <option value="1" <cfif mes EQ 1>selected</cfif>>Enero</option>
				  <option value="2" <cfif mes EQ 2>selected</cfif>>Febrero</option>
				  <option value="3" <cfif mes EQ 3>selected</cfif>>Marzo</option>
				  <option value="4" <cfif mes EQ 4>selected</cfif>>Abril</option>
				  <option value="5" <cfif mes EQ 5>selected</cfif>>Mayo</option>
				  <option value="6" <cfif mes EQ 6>selected</cfif>>Junio</option>
				  <option value="7" <cfif mes EQ 7>selected</cfif>>Julio</option>
				  <option value="8" <cfif mes EQ 8>selected</cfif>>Agosto</option>
				  <option value="9" <cfif mes EQ 9>selected</cfif>>Septiembre</option>
				  <option value="10" <cfif mes EQ 10>selected</cfif>>Octubre</option>
				  <option value="11" <cfif mes EQ 11>selected</cfif>>Noviembre</option>
				  <option value="12" <cfif mes EQ 12>selected</cfif>>Diciembre</option>
				</select></td>
			  <td>&nbsp;</td>
			</tr>
			<tr>
                <td colspan="5" align="center">&nbsp;</td>
			</tr>
			<tr>
                <td colspan="5" align="center"><input type="checkbox" name="chkCierre" value="">&nbsp;Incluir Asientos de Cierre</td>
			</tr>
			<tr>
                <td colspan="5" align="center">&nbsp;</td>
			</tr>
			<tr>
			  <td colspan="5"><div align="center">
				  <input type="submit" name="Submit" value="Consultar" tabindex="13">
				  &nbsp;
				  <input type="Reset" name="Limpiar" value="Limpiar" tabindex="14">
				</div></td>
			</tr>
			<tr>
			  <td>&nbsp;</td>
			  <td><div align="right"></div></td>
			  <td colspan="3">&nbsp;</td>
			</tr>
		  </table>
		  <div align="center"></div>
		</form>
	<cf_web_portlet_end>
<cf_templatefooter>
