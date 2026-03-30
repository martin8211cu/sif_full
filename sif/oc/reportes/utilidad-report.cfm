<cfsetting requesttimeout="900">
<cf_htmlReportsHeaders 
		title="Utilidad bruta de productos"
		filename="utilidad.xls"
		irA="utilidad.cfm?generar=0"
		download="yes"
		preview="no">
<style type="text/css">
* {
	font-family:Verdana, Arial, Helvetica, sans-serif;
	font-size:9px;
}
table.reporte * td {
	vertical-align:text-top;
	white-space:nowrap;
	border-right:1px solid gray;
}
table.reporte tr.par {
	background-color:#ededed;
}
table.reporte tr.non {
	background-color:#ffffff;
}
td.firstcol {
	border-left:1px solid gray;
}
td.noborder {
	border-right:0px none white;
}
table.reporte {
}
tr.subtotal td , tr.titulo td {
	font-weight:bold;
	border-top:1px solid gray;
	border-bottom:1px solid gray;
}
tr.titlerow *  {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 16px;
	font-weight: bold;
	border:0px none white;
}
</style>

<table border="0" cellpadding="2" cellspacing="0" align="center" class="reporte">

<cfoutput>
      <tr class="titlerow">
        <td align="center" colspan="26">
		#HTMLEditFormat(session.Enombre)#</td>
      </tr>
      <tr class="titlerow">
        <td align="center" colspan="26">Utilidad bruta de productos</td>
      </tr>
      <tr class="titlerow">
        <td align="center" colspan="26">
		<cfif form.resumido is '1'>Resumen<cfelse>Detalle</cfif>
		de 
		<cfif form.comparar is 'costo'>costo de ventas<cfelse>ventas vs compras</cfif></td>
      </tr>
      <tr class="titlerow">
        <td align="center" colspan="26">De #HTMLEditFormat(NumberFormat(form.mesini,'00'))#/#HTMLEditFormat(form.perini)# 
							a #HTMLEditFormat(NumberFormat(form.mesfin,'00'))#/#HTMLEditFormat(form.perfin)#</td>
      </tr>
	  <cfif len(form.OC)>
      <tr class="titlerow">
        <td align="center" colspan="26">Orden n&uacute;mero #HTMLEditFormat(form.OC)# y relacionadas</td>
      </tr>
	  </cfif>
</cfoutput>

<cfsavecontent variable="heading">
  <tr class="titulo">
    <td class="firstcol" colspan="3" align="center">OCTtransporte</td>
    <td>&nbsp;</td>
    <td colspan="8" align="center"><cfif form.comparar is 'costo'>Costo<cfelse>Compra</cfif></td>
    <td>&nbsp;</td>
    <td colspan="8" align="center">Venta</td>
    <td>&nbsp;</td>
    <td colspan="4" align="center">Margen</td>
  </tr>
  <tr class="titulo">
    <td class="firstcol">Mes</td>
    <td>Código</td>
    <td>Producto</td>
    <td>&nbsp;</td>
    <td><cfif form.comparar is 'costo'><cfelse>Empresa</cfif></td>
    <td colspan="2"><cfif form.comparar is 'costo'><cfelse>Orden comercial</cfif></td>
    <td colspan="2">Volumen</td>
    <td colspan="2">Importe</td>
    <td>Moneda Local</td>
    <td>&nbsp;</td>
    <td>Empresa</td>
    <td colspan="2">Orden comercial </td>
    <td colspan="2">Volumen</td>
    <td colspan="2">Importe</td>
	<td>Moneda Local</td>
    <td>&nbsp;</td>
    <td colspan="2">Volumen</td>
    <td>Importe</td>
	<td>Moneda Local</td>
  </tr></cfsavecontent>
  <cfset last_cc = ''>
  <cfset last_cp = ''>
  <cfset tot_general = StructNew()><!--- tot_general.moneda.cc/cp --->
  
  <cfoutput query="rep" group="OCTid">
  <cfoutput group="art">
  <cfif CurrentRow neq 1><tr><td colspan="23">&nbsp;</td></tr></cfif>
  <cfif Len(rep.Almcodigo)>
	  <cfset TipoTransporte = 'Almac&eacute;n'>
  <cfelse>
	  <cfset TipoTransporte = 'Transporte'>
  </cfif>
  #Replace (heading, 'OCTtransporte', TipoTransporte & ' ' & OCTtransporte)#
  <cfoutput group="mon"><!--- moneda --->
  <cfset rownum = 0>
  <cfset sum_cpCanTR = 0>
  <cfset sum_cpTotTR = 0>
  <cfset sum_cpLocTR = 0>
  <cfset sum_ccCanTR = 0>
  <cfset sum_ccTotTR = 0>
  <cfset sum_ccLocTR = 0>
  <cfoutput group="mes">
  <cfoutput group="per">
	  <cfset cp_td = ArrayNew(1)>
	  <cfset cc_td = ArrayNew(1)>
	  <cfoutput><!--- generar arreglo para CP y CC --->
	  	<cfset linea = StructNew()>
		<cfset linea.can = rep.can>
		<cfset linea.tot = rep.tot>
		<cfset linea.loc = rep.totloc>
		<cfsavecontent variable="td">
			<td>&nbsp;</td>
			<cfif form.comparar is 'costo' and rep.tipo is 'CP'>
				<td colspan="2" class="noborder"></td>
			<cfelse>
				<td>#HTMLEditFormat(rep.SN)#</td>
				<td>#HTMLEditFormat(rep.OC)#</td>
			</cfif>
			<td><cfif form.resumido is '0'>#HTMLEditFormat(rep.doc)#</cfif></td>
			<td align="right">#NumberFormat(rep.can,',0.00')#</td>
			<td align="right">#HTMLEditFormat(rep.UM)#</td>
			<td align="right">#NumberFormat(rep.tot,',0.00')#</td>
			<td align="right">#HTMLEditFormat(rep.mon)#</td>
			<td align="right">#NumberFormat(rep.totloc,',0.00')#</td>
		</cfsavecontent>
		<cfset linea.td = td>
		<cfif Not StructKeyExists(tot_general, rep.mon)>
			<cfset tot_general[rep.mon] = StructNew()>
			<cfset tot_general[rep.mon].cc = 0>
			<cfset tot_general[rep.mon].cp = 0>
			<cfset tot_general[rep.mon].ccloc = 0>
			<cfset tot_general[rep.mon].cploc = 0>
		</cfif>
		<cfif tipo is 'CP'>
			<cfset ArrayAppend(cp_td, linea)>
			<cfset sum_cpCanTR = sum_cpCanTR + rep.can>
			<cfset sum_cpTotTR = sum_cpTotTR + rep.tot>
			<cfset sum_cpLocTR = sum_cpLocTR + rep.totloc>
			<cfset tot_general[rep.mon].cp = tot_general[rep.mon].cp + rep.tot>
			<cfset tot_general[rep.mon].cploc = tot_general[rep.mon].cploc + rep.totloc>
		<cfelse>
			<cfset ArrayAppend(cc_td, linea)>
			<cfset sum_ccCanTR = sum_ccCanTR + rep.can>
			<cfset sum_ccTotTR = sum_ccTotTR + rep.tot>
			<cfset sum_ccLocTR = sum_ccLocTR + rep.totloc>
			<cfset tot_general[rep.mon].cc = tot_general[rep.mon].cc + rep.tot>
			<cfset tot_general[rep.mon].ccloc = tot_general[rep.mon].ccloc + rep.totloc>
		</cfif>
	  </cfoutput><!--- generar arreglo para CP y CC --->
  <cfloop from="1" to="#Max(ArrayLen(cp_td), ArrayLen(cc_td))#" index="i">
  <cfset rownum=rownum+1>
  <tr class="<cfif rownum mod 2 is 0>par<cfelse>non</cfif>">
    <td class="firstcol">#NumberFormat(rep.mes,'00')#-#NumberFormat(rep.per,'00')#</td>
    <td>#HTMLEditFormat(rep.art)#</td>
    <td>#HTMLEditFormat(rep.des)#</td>
    <cfset margen_can = 0>
	<cfset margen_tot = 0>
	<cfset margen_loc = 0>
	<cfif ArrayLen(cp_td) GE i>
		#cp_td[i].td#
	    <cfset margen_can = margen_can - cp_td[i].can>
	    <cfset margen_tot = margen_tot - cp_td[i].tot>
	    <cfset margen_loc = margen_loc - cp_td[i].loc>
	<cfelse>
		<td colspan="1">&nbsp;</td>
		<td colspan="8">&nbsp;</td>
	</cfif>
	<cfif ArrayLen(cc_td) GE i>
		#cc_td[i].td#
	    <cfset margen_can = margen_can + cc_td[i].can>
	    <cfset margen_tot = margen_tot + cc_td[i].tot>
	    <cfset margen_loc = margen_loc + cc_td[i].loc>
	<cfelse>
		<td colspan="1">&nbsp;</td>
		<td colspan="8">&nbsp;</td>
	</cfif>

    <td align="right">&nbsp;</td>
    <td align="right">#NumberFormat(margen_can,',0.00')#</td>
    <td align="right">#HTMLEditFormat(rep.UM)#</td>
    <td align="right">#NumberFormat(margen_tot,',0.00')#</td>
    <td align="right">#NumberFormat(margen_loc,',0.00')#</td>
    </tr>
  </cfloop></cfoutput><!--- mes ---> </cfoutput> <!--- per --->
  <tr class="subtotal firstcol">
    <td class="firstcol">&nbsp;</td>
    <td colspan="2">Subtotal #HTMLEditFormat(rep.mon)#</td>
    <td>&nbsp;</td>
    <td colspan="3">&nbsp;</td>
    <td align="right">#NumberFormat(sum_cpCanTR,',0.00')#</td>
    <td align="right">#HTMLEditFormat(rep.UM)#</td>
    <td align="right">#NumberFormat(sum_cpTotTR,',0.00')#</td>
	<td align="right">#HTMLEditFormat(rep.mon)#</td>
    <td align="right">#NumberFormat(sum_cpLocTR,',0.00')#</td>
    <td>&nbsp;</td>
    <td colspan="3">&nbsp;</td>
    <td align="right">#NumberFormat(sum_ccCanTR,',0.00')#</td>
    <td align="right">#HTMLEditFormat(rep.UM)#</td>
    <td align="right">#NumberFormat(sum_ccTotTR,',0.00')#</td>
	<td align="right">#HTMLEditFormat(rep.mon)#</td>
    <td align="right">#NumberFormat(sum_ccLocTR,',0.00')#</td>
	
    <td align="right">&nbsp;</td>
    <td align="right">#NumberFormat(sum_ccCanTR - sum_cpCanTR,',0.00')#</td>
    <td align="right">#HTMLEditFormat(rep.UM)#</td>
    <td align="right">#NumberFormat(sum_ccTotTR - sum_cpTotTR,',0.00')#</td>
    <td align="right">#NumberFormat(sum_ccLocTR - sum_cpLocTR,',0.00')#</td>
  </tr>
  </cfoutput><!--- moneda --->
  </cfoutput><!--- articulo ---></cfoutput><!--- transporte --->
  <cfoutput>
  <cfif rep.RecordCount>
  <tr class="subtotal">
  <td colspan="26" class="firstcol">&nbsp;</td>
  </tr>
  <cfset tot_cploc = 0>
  <cfset tot_ccloc = 0>
  <cfloop list="# ListSort( StructKeyList(tot_general), 'textnocase') #" index="mon">
  <tr class="subtotal">
    <td class="firstcol">&nbsp;</td>
    <td colspan="2">Total General #mon#</td>
    <td>&nbsp;</td>
    <td colspan="5">&nbsp;</td>
    <td align="right">#NumberFormat(tot_general[mon].cp,',0.00')#</td>
    <td>&nbsp;</td>
    <td align="right">#NumberFormat(tot_general[mon].cploc,',0.00')#</td>
    <td>&nbsp;</td>
    <td colspan="5">&nbsp;</td>
    <td align="right">#NumberFormat(tot_general[mon].cc,',0.00')#</td>
    <td>&nbsp;</td>
    <td align="right">#NumberFormat(tot_general[mon].ccloc,',0.00')#</td>
	
    <td align="right">&nbsp;</td>
    <td colspan="2">&nbsp;</td>
    <td align="right">#NumberFormat(tot_general[mon].cc - tot_general[mon].cp,',0.00')#</td>
    <td align="right">#NumberFormat(tot_general[mon].ccloc - tot_general[mon].cploc,',0.00')#</td>
  </tr>
  <cfset tot_cploc = tot_cploc + tot_general[mon].cploc>
  <cfset tot_ccloc = tot_ccloc + tot_general[mon].ccloc>
  </cfloop>
  <tr class="subtotal">
    <td class="firstcol">&nbsp;</td>
    <td colspan="2">Total General Moneda local</td>
    <td>&nbsp;</td>
    <td colspan="5">&nbsp;</td>
    <td align="right">&nbsp;</td>
    <td>&nbsp;</td>
    <td align="right">#NumberFormat(tot_cploc,',0.00')#</td>
    <td>&nbsp;</td>
    <td colspan="5">&nbsp;</td>
    <td align="right">&nbsp;</td>
    <td>&nbsp;</td>
    <td align="right">#NumberFormat(tot_ccloc,',0.00')#</td>
	
    <td align="right">&nbsp;</td>
    <td colspan="2">&nbsp;</td>
    <td align="right">&nbsp;</td>
    <td align="right">#NumberFormat(tot_ccloc - tot_cploc,',0.00')#</td>
  </tr>
  <cfelse>
  <tr class="subtotal">
  <td colspan="26" width="800">
  	No hay datos para este reporte
  </td>
  </tr>
  </cfif></cfoutput>
</table>
</html>