<style type="text/css">
<!--
.style1 {
	font-size: 16px;
	font-weight: bold;
	color: #FFFFFF;
}
.style2 {
	font-size: 24px;
	font-weight: bold;
}
.style3 {
	font-size: 16px;
	font-weight: bold;
}
-->
</style>

<cfif isdefined('url.f_Ocodigo') and not isdefined('form.f_Ocodigo')>
	<cfset form.f_Ocodigo=url.f_Ocodigo>
</cfif>
<cfif isdefined('url.SPfecha') and not isdefined('form.SPfecha')>
	<cfset form.SPfecha=url.SPfecha>
</cfif>
<cfif isdefined('form.f_Ocodigo') and form.f_Ocodigo NEQ '' and isdefined('form.SPfecha') and form.SPfecha NEQ ''>
	<cfquery name="rsMovimientos" datasource="#session.DSN#">
		select 
			sum((coalesce(b.Unidades_vendidas,0) * (coalesce(b.Precio,0)) - b.Descuento) + 
				(((coalesce(b.Unidades_vendidas,0) * (coalesce(b.Precio,0))) * coalesce(c1.Iporcentaje,0)) / 100
				)) as Total
			, d.Ccodigo
			, d.Cdescripcion
			, b1.Odescripcion
			, 'C' as tipo
			, '' as cuenta
		from ESalidaProd a
			inner join DSalidaProd b
				on b.Ecodigo=a.Ecodigo	
					and b.ID_salprod=a.ID_salprod
		
			inner join Oficinas b1
				on b1.Ecodigo=b.Ecodigo
					and b1.Ocodigo=a.Ocodigo		
		
			inner join Articulos c
				on c.Ecodigo=b.Ecodigo
					and c.Aid=b.Aid
		
			left outer join Impuestos c1
				on c1.Ecodigo=c.Ecodigo
					and c1.Icodigo=c.Icodigo	
		
			inner join Clasificaciones d
				on d.Ecodigo=c.Ecodigo
					and d.Ccodigo=c.Ccodigo
		
		where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.SPestado=10
			<cfif isdefined('form.f_Ocodigo') and form.f_Ocodigo NEQ ''>
				and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.f_Ocodigo#">								
			</cfif>	
			<cfif isdefined('form.SPfecha') and form.SPfecha NEQ ''>
				and a.SPfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.SPfecha)#">								
			</cfif>					
		group by d.Ccodigo, d.Cdescripcion, b1.Odescripcion

	Union
	
		select 
			TDCtotal
			, -1
			, TDCdesc as Cdescripcion
			, g.Odescripcion
			, e.TDCtipo as tipo
			, h.CFformato as cuenta
		from TotDebitosCreditos e
			inner join ESalidaProd f
				on f.Ecodigo=e.Ecodigo
					and f.ID_salprod=e.ID_salprod
					and f.SPestado=10
					<cfif isdefined('form.f_Ocodigo') and form.f_Ocodigo NEQ ''>
						and f.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.f_Ocodigo#">								
					</cfif>	
					<cfif isdefined('form.SPfecha') and form.SPfecha NEQ ''>
						and f.SPfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.SPfecha)#">								
					</cfif>	

			inner join Oficinas g
				on g.Ecodigo=f.Ecodigo
					and g.Ocodigo=f.Ocodigo

			inner join CFinanciera h
				on h.Ecodigo=g.Ecodigo
					and h.CFformato=e.TDCformato

		where e.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
	<cfif isdefined('rsMovimientos') and rsMovimientos.recordCount GT 0>
		<cfquery name="rsOficina" dbtype="query" maxrows="1">
			Select Odescripcion
			from rsMovimientos
		</cfquery>
	</cfif>
</cfif>

<cfset vTotalCred = 0>	
<cfset vTotalDev = 0>	
<cfset LvarListaNon = -1>
<cfif isdefined('rsMovimientos') and rsMovimientos.recordCount GT 0>
<table width="100%" border="0">
  <cfoutput>
    <tr>
      <td colspan="4" align="center"><span class="style2">Estaci&oacute;n:&nbsp;
            <cfif isdefined('rsOficina') and rsOficina.recordCount GT 0>
              #rsOficina.Odescripcion#
                <cfelse>
              &nbsp;
            </cfif>
      </span> </td>
    </tr>
    <tr>
      <td colspan="4" align="center"><span class="style3">
        <cfif isdefined('form.SPfecha') and form.SPfecha NEQ ''>
          #form.SPfecha#
            <cfelse>
          &nbsp;
        </cfif>
      </span> </td>
    </tr>
  </cfoutput>
  <tr>
    <td colspan="4" bgcolor="#000000" align="center"><span class="style1">Balance Contable de las Ventas Diarias</span></td>
  </tr>
  <tr bgcolor="#ACACAC">
    <td width="27%"><strong>Detalle</strong></td>
    <td width="26%" align="center"><strong>Cuenta Contable</strong></td>
    <td width="21%" align="center"><strong>Débito</strong></td>
    <td width="26%" align="center"><strong>Crédito</strong></td>
  </tr>
  <cfoutput query="rsMovimientos">
    <cfset LvarListaNon = (CurrentRow MOD 2)>
    <tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
      <td>&nbsp;&nbsp;&nbsp;&nbsp;#rsMovimientos.Cdescripcion#</td>
      <td align="center">#rsMovimientos.cuenta#</td>
      <cfif rsMovimientos.tipo EQ 'D'>
	  	<cfset vTotalDev = vTotalDev + rsMovimientos.Total>
        <td align="right">#LSCurrencyFormat(rsMovimientos.Total, 'none')#</td>
        <td align="right">&nbsp;</td>
      <cfelse>
		<cfset vTotalCred = vTotalCred + rsMovimientos.Total>
        <td align="right">&nbsp;</td>
        <td align="right">#LSCurrencyFormat(rsMovimientos.Total, 'none')#</td>
      </cfif>
    </tr>
  </cfoutput>
  <tr>
    <td colspan="4"><hr /></td>
  </tr>
  <tr bgcolor="#ACACAC">
    <td colspan="2" align="right"><strong>Total</strong></td>
    <td align="right"><cfoutput><strong>#LSCurrencyFormat(vTotalDev, 'none')#</strong></cfoutput></td>
    <td align="right"><cfoutput><strong>#LSCurrencyFormat(vTotalCred, 'none')#</strong></cfoutput></td>
  </tr>
</table>
<cfelse>
	<table width="100%" border="0">
	  	<tr><td>&nbsp;</td></tr>
	  	<tr><td>&nbsp;</td></tr>		
	  	<tr>
			<td align="center"><strong>--	No existen datos disponibles para la consulta	---</strong></td>
	  	</tr>
		<tr><td>&nbsp;</td></tr>
	</table>	
</cfif>
