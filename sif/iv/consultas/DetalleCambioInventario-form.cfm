<cfquery name="rs" datasource="#session.DSN#">
	select 
		b.Acodigo, 
		b.Adescripcion, 
		sum(DTinvinicial) as Inicial, 
		sum(DTperdidaganancia) as PerdidaGanancia, 
		sum(DTinvfinal) as Final, 
		sum(DTinvfinal - DTinvinicial + DTperdidaganancia) as Cambio, 
		coalesce(sum((DTinvfinal - DTinvinicial + DTperdidaganancia) * b.Acosto),0) as Monto
	from DTransformacion a
		inner join Articulos b
				on b.Aid = a.Aid
	where a.ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ETid#">
	group by b.Acodigo, b.Adescripcion
	order by Acodigo, Adescripcion
	<!---compute sum(sum((DTinvfinal - DTinvinicial + DTperdidaganancia) * b.Acosto))--->
</cfquery>

<cfquery datasource="#session.DSN#" name="rsEmpresa">
	select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<!--- sacar total por Acodigo y total general--->
<style type="text/css" >
	.negativo {color:#FF0000;}
	.articulo {color:#000000; }
	.encabReporte {
		background-color: #006699;
		font-weight: bold;
		color: #FFFFFF;
		padding-top: 10px;
		padding-bottom: 10px;
	}
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: #CCCCCC;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
	.subTituloRep {
		font-weight: bold; 
		font-size: x-small; 
		background-color: #F5F5F5;
	}
</style>

<cfoutput>
<cf_sifHTML2Word>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr><td>&nbsp;</td></tr>
    <tr> 
      <td colspan="7" align="center" bgcolor="##EFEFEF"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></strong></td>
    </tr>
    <tr> 
      <td colspan="7" align="center"><b>Consulta de Detalle de Cambio de Inventario</b></td>
    </tr>
	<tr>
		<td colspan="7" align="center"><b>Fecha de la Consulta:</b> #LSDateFormat(Now(), 'dd/mm/yyyy')# &nbsp; <b>Hora:&nbsp;</b>#TimeFormat(Now(),'medium')#</td>
	</tr>

	<tr><td>&nbsp;</td></tr>

	<tr  class="tituloListas">
		<td><strong>C&oacute;digo</strong></td>
		<td align="left"><strong>Art&iacute;culo</strong></td>
		<td align="right"><strong>Inicial</strong></td>
		<td align="right"><strong>Final</strong></td>
		<td align="right"><strong>Cambio</strong></td>
		<td align="right"><strong>Monto</strong></td>
		<td>&nbsp;</td>
	</tr>

	<cfset total_general = 0 >
	<cfset total_inicial_general  = 0 >
	<cfset total_final_general = 0 >
	<cfset total_cambio_general = 0 >
	<cfloop query="rs" >
		<tr>
			<td style="text-indent:10" nowrap>#rs.Acodigo#</td>
			<td style="text-indent:10" nowrap>#rs.Adescripcion#</td>
			<td style="text-indent:10" nowrap align="right">#LSNumberFormat(rs.Inicial,',9.00')#</td>
			<td style="text-indent:10" nowrap align="right">#LSNumberFormat(rs.Final,',9.00')#</td>
			<td style="text-indent:10" nowrap align="right">#LSNumberFormat(rs.Cambio,',9.00')#</td>
			<td nowrap align="right" <cfif rs.Monto lt 0>class="negativo"</cfif> >#LSNumberFormat(rs.Monto,',9.00')#</td>
			<td width="1%">&nbsp;</td>
		</tr>

		<cfset total_general = total_general + rs.Monto >
		<cfset total_inicial_general = total_inicial_general + rs.Inicial >
		<cfset total_final_general = total_final_general + rs.Final >
		<cfset total_cambio_general = total_cambio_general + rs.Cambio >
	</cfloop>
	
	<!--- pinta el total general --->
	<tr><td>&nbsp;</td></tr>
	<tr class="topline">
		<td class="topline" style="text-indent:10"><b>Total General:</b>
		</td>
		
		<td class="topline" align="right" colspan="2"><b><cfif total_inicial_general lt 0><font color="##FF0000"></cfif>#LSNumberFormat(total_inicial_general,',9.00')#<cfif rs.Monto lt 0></font></cfif></b>
		<td class="topline" align="right"><b><cfif total_final_general lt 0><font color="##FF0000"></cfif>#LSNumberFormat(total_final_general,',9.00')#<cfif rs.Monto lt 0></font></cfif></b>
		<td class="topline" align="right"><b><cfif total_cambio_general lt 0><font color="##FF0000"></cfif>#LSNumberFormat(total_cambio_general,',9.00')#<cfif rs.Monto lt 0></font></cfif></b>
		<td class="topline" align="right"><b><cfif total_general lt 0><font color="##FF0000"></cfif>#LSNumberFormat(total_general,',9.00')#<cfif rs.Monto lt 0></font></cfif></b>
		</td>
	</tr>
</table>
</cf_sifHTML2Word>
</cfoutput>

