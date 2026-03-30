<cfquery name="anos" datasource="minisif">
	select distinct CPCano
	from CPresupuestoControl
	where Ecodigo = #session.ecodigo#
	order by CPCano
</cfquery>
<cfquery name="monedas" datasource="minisif">
	Select distinct a.Mcodigo, b.Mnombre
	from CPTipoCambioProyectadoMes a inner join Monedas b on a.Ecodigo = b.Ecodigo and a.Mcodigo = b.Mcodigo
	where a.Ecodigo = #session.ecodigo#
	order by Mnombre
</cfquery>
<cfquery name="rsOficinas" datasource="minisif">
	select Ocodigo, Odescripcion 
	from Oficinas 
	where Ecodigo = #session.ecodigo#
</cfquery>
<cfquery name="meses" datasource="minisif">
	select distinct CPCmes, case when CPCmes = 1 then 'Enero' 
								 when CPCmes = 2 then 'Febrero' 
								 when CPCmes = 3 then 'Marzo' 
								 when CPCmes = 4 then 'Abril' 
								 when CPCmes = 5 then 'Mayo' 
								 when CPCmes = 6 then 'Junio' 
								 when CPCmes = 7 then 'Julio' 
								 when CPCmes = 8 then 'Agosto' 
								 when CPCmes = 9 then 'Septiembre' 
								 when CPCmes = 10 then 'Octubre' 
								 when CPCmes = 11 then 'Noviembre' 
								when CPCmes = 12 then 'Diciembre' 
							end as mes
	from CPresupuestoControl
	where Ecodigo = #session.ecodigo#
	order by CPCmes
</cfquery>

<cfset filtro = "">
<cfset navegacion = "">



<cfoutput>
<form name="form1" method="get" action="ConsGastosPresupuesto-rep.cfm">

<table width="100%" border="0" cellspacing="0" cellpadding="2">
  <tr> 
    <td width="92" nowrap class="fileLabel"><strong> Del Per&iacute;odo: </strong></td>
	<td width="831"><select name="CPCano" accesskey="1" tabindex="1">
					
            <cfloop query="anos">
                <option value="#anos.CPCano#">#anos.CPCano#</option>
             </cfloop>       </select></td>
    </tr>
  <tr>
    <td nowrap class="fileLabel"><strong>Del Mes</strong></td>
	<td><select name="CPCmes">
		
      <cfloop query="meses">
        <option value="#meses.CPCmes#">#meses.mes#</option>
      </cfloop>
    </select>	</td>
	</tr>
  <tr>
    <td align="left" nowrap><strong>Oficina:</strong></td>
    <td align="left" nowrap><select name="Oficina">
		<option value="">Todos</option>
      <cfloop query="rsOficinas">
        <option value="#rsOficinas.Ocodigo#">#rsOficinas.Odescripcion#</option>
      </cfloop>
    </select></td>
  </tr>
  <tr>
    <td align="left" nowrap><div align="left"><strong>Formato:&nbsp; </strong></div></td>
    <td align="left" nowrap><select name="formato">
        <option value="html">En l&iacute;nea (HTML)</option>
        <option value="pdf">Adobe PDF</option>
        <option value="xls">Microsoft Excel</option>
    </select></td>
    </tr>
  <tr>
  	<td colspan="2" valign="middle" align="center"><input type="submit" value="Consultar" name="Reporte">      </td>
  </tr>
</table>
</form>
</cfoutput>




