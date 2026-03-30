<cfquery name="rs" datasource="#session.DSN#">
	select 
		b.Acodigo as Codigo, 
		b.Adescripcion as Articulo, 
		a.CCTcodigo as TipoTransaccion, 
		a.Ddocumento as Documento,
		a.CCVPcantidad  * case when t.CCTtipo = 'C' then -1.00 else 1.00 end as Cantidad, 
		a.CCVPpreciouloc * case when t.CCTtipo = 'C' then -1.00 else 1.00 end as Precio
	from CCVProducto a
		inner join CCTransacciones t
				 on t.CCTcodigo = a.CCTcodigo
				and t.Ecodigo   = a.Ecodigo
		inner join Articulos b
			 on b.Aid = a.Aid
			and b.Aconsumo = 1
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.CCVPestado = 0
	order by b.Acodigo
</cfquery>

<cfquery datasource="#session.DSN#" name="rsEmpresa">
	select Edescripcion 
	from Empresas
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
	
	.tituloListas{ 
		color:#FFFFFF;   
		background-color:#006699;
	}
	
</style>

<cfoutput>
<cf_sifHTML2Word>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr><td>&nbsp;</td></tr>
    <tr> 
      <td colspan="5" align="center" bgcolor="##EFEFEF"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></strong></td>
    </tr>
    <tr> 
      <td colspan="5" align="center"><b>Consulta de Detalle de Consumo Propio</b></td>
    </tr>
	<tr>
		<td colspan="5" align="center"><b>Fecha de la Consulta:</b> #LSDateFormat(Now(), 'dd/mm/yyyy')# &nbsp; <b>Hora:&nbsp;</b>#TimeFormat(Now(),'medium')#</td>
	</tr>

	<tr><td>&nbsp;</td></tr>

	<tr  class="tituloListas">
		<td><strong>Documento</strong></td>
		<td align="center"><strong>Tipo de Transacci&oacute;n</strong></td>
		<td align="right"><strong>Monto</strong></td>
		<td align="right"><strong>Cantidad</strong></td>
		<td>&nbsp;</td>
	</tr>

	<cfset hayCorte = false >
	<cfset corte = ''>
	<cfset total_corte   = 0 >
	<cfset total_general = 0 >
	<cfset total_cantidad_corte   = 0 >
	<cfset total_cantidad_general = 0 >

	<cfloop query="rs" >
		<cfset vCodigo = trim(rs.Codigo) >

		<cfif Compare(corte, vCodigo) neq 0 >
			<cfif corte neq ''>
				<tr class="topline">
					<td class="topline" style="text-indent:10"><b>Total:</b></td>
					<td class="topline" align="right" style="text-indent:10">&nbsp;</td>
					<td class="topline" align="right" style="text-indent:10"><b><cfif total_corte lt 0><font color="##FF0000"></cfif>#LSNumberFormat(total_corte,',9.00')#<cfif total_general lt 0></font></cfif></b></td>
					<td class="topline" align="right" style="text-indent:10"><b><cfif total_cantidad_corte lt 0><font color="##FF0000"></cfif>#LSNumberFormat(total_cantidad_corte,',9.00')#<cfif total_cantidad_general lt 0></font></cfif></b></td>
				</tr>
				<tr><td>&nbsp;</td></tr>
			</cfif>

			<cfset total_general = total_general + total_corte >
			<cfset total_corte = 0 >
			<cfset total_cantidad_general = total_cantidad_general + total_cantidad_corte >
			<cfset total_cantidad_corte = 0 >
			<cfset hayCorte = true >
			
			<tr><td colspan="7" class="tituloListas"><font size="1">#vCodigo# - #rs.Articulo#</font></td></tr>
		<cfelse>
			<cfset hayCorte = false >
		</cfif>

		<cfset total_corte = total_corte + rs.Precio>
		<cfset total_cantidad_corte = total_cantidad_corte + rs.Cantidad>

		<tr>
			<td style="text-indent:10" nowrap>#rs.Documento#</td>
			<td nowrap align="center">#rs.TipoTransaccion#</td>
			<td nowrap align="right" <cfif rs.cantidad lt 0>class="negativo"</cfif> >#LSNumberFormat(rs.Precio,',9.00')#</td>
			<td nowrap style="text-indent:10 " align="right" <cfif rs.Precio lt 0>class="negativo"</cfif> >#LSNumberFormat(rs.Cantidad,',9.00')#</td>
			<td width="1%">&nbsp;</td>
		</tr>

		<cfset corte = trim(vCodigo)>
	</cfloop>
	
	<!--- pinta el total para el ultimo corte --->
	<tr class="topline"><td class="topline" style="text-indent:10"><b>Total:</b></td><td class="topline" align="right" style="text-indent:10">&nbsp;</td>
	  <td class="topline" align="right"><b><cfif total_corte lt 0><font color="##FF0000"></cfif>
	    #LSNumberFormat(total_corte,',9.00')#
      <cfif total_general lt 0></font></cfif></b></td>
	  <td class="topline" align="right"><b><cfif total_cantidad_corte lt 0><font color="##FF0000"></cfif>#LSNumberFormat(total_cantidad_corte,',9.00')#<cfif total_cantidad_general lt 0></font></cfif></b></td>
	</tr>
	
	<!--- pinta el total general --->
	<cfset total_general = total_general + total_corte >
	<cfset total_cantidad_general = total_cantidad_general + total_cantidad_corte >
	<tr><td>&nbsp;</td></tr>
	<tr class="topline">
		<td class="topline" style="text-indent:10"><b>Total General:</b></td>
		<td class="topline" style="text-indent:10">&nbsp;</td>
		<td class="topline" align="right"><b><cfif total_general lt 0><font color="##FF0000"></cfif>#LSNumberFormat(total_general,',9.00')#<cfif rs.cantidad lt 0></font></cfif></b></td>
		<td class="topline" align="right"><b><cfif total_cantidad_general lt 0><font color="##FF0000"></cfif>#LSNumberFormat(total_cantidad_general,',9.00')#<cfif rs.cantidad lt 0></font></cfif></b></td>
	</tr>
</table>
</cf_sifHTML2Word>
</cfoutput>

