<cfquery name="rs" datasource="#session.DSN#">
	select 
		b.Cdescripcion, 
		a.GPmonto
	from CPGastosProduccion a
		inner join Conceptos b
			on b.Cid = a.Cid
	where a.ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ETid#">
	  and a.GPmonto is not null
	  and a.GPmonto <> 0.00
	order by Cdescripcion	
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
      <td colspan="3" align="center" bgcolor="##EFEFEF"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></strong></td>
    </tr>
    <tr> 
      <td colspan="3" align="center"><b>Consulta de Detalle de Cuotas y Gastos</b></td>
    </tr>
	<tr>
		<td colspan="3" align="center"><b>Fecha de la Consulta:</b> #LSDateFormat(Now(), 'dd/mm/yyyy')# &nbsp; <b>Hora:&nbsp;</b>#TimeFormat(Now(),'medium')#</td>
	</tr>

	<tr><td>&nbsp;</td></tr>

	<tr  class="tituloListas">
		<td><strong>Descripci&oacute;n</strong></td>
		<td align="right"><strong>Monto</strong></td>
		<td>&nbsp;</td>
	</tr>
	<cfset total_general = 0 >
	<cfloop query="rs">
		<tr>
			<td style="text-indent:10" nowrap>#rs.Cdescripcion#</td>
			<td nowrap align="right" <cfif rs.GPmonto lt 0>class="negativo"</cfif> >#LSNumberFormat(rs.GPmonto,',9.00')#</td>
			<td width="1%">&nbsp;</td>
		</tr>

		<!--- pinta el total general --->
		<cfset total_general = total_general + rs.GPmonto >
	</cfloop>
	
	<tr><td>&nbsp;</td></tr>
	<tr class="topline"><td class="topline" style="text-indent:10"><b>Total General:</b></td><td class="topline" colspan="1" align="right"><b><cfif total_general lt 0><font color="##FF0000"></cfif>#LSNumberFormat(total_general,',9.00')#<cfif rs.GPmonto lt 0></font></cfif></b></td></tr>
</table>
</cf_sifHTML2Word>
</cfoutput>