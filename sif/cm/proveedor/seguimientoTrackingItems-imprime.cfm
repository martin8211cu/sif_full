

<style type="text/css">
	.tablaborde {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #CCCCCC;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #CCCCCC;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #CCCCCC;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #CCCCCC;
		
	}

	.letra {
		font-size:11px;
	}
</style>

<cfif isdefined("url.ETidtracking_move1") and not isdefined("form.ETidtracking_move1")>
	<cfset form.ETidtracking_move1 = Url.ETidtracking_move1>
</cfif>
<cfinclude template="../../Utiles/sifConcat.cfm">

<table width="100%" border="0" cellspacing="0" cellpadding="1" style="padding-left: 5px; padding-right: 10px" align="center">
	<tr> 
	<td colspan="8" align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"><cfoutput>#session.Enombre#</cfoutput></strong></td>
	</tr>
	<tr> 
	<td colspan="8" class="letra" align="center"><b>Consulta Items de Tracking de Embarque</b></td>
	</tr>
	<cfoutput> 
	<tr>
	<td colspan="8" align="center" class="letra"><b>Fecha de la Consulta:</b> #LSDateFormat(Now(), 'dd/mm/yyyy')# &nbsp; <b>Hora:&nbsp;</b>#TimeFormat(Now(),'medium')#</td>
	</tr>
	</cfoutput> 			
</table>
<br>

<cfquery name="rsTracking" datasource="sifpublica">
	select ETnumtracking, cncache 
	from ETracking
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  	and ETidtracking=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETidtracking_move1#">
</cfquery>

<cfquery name="rsItems" datasource="#rsTracking.cncache#">
	select 	eti.ETIcantidad,
			eti.ETcantfactura,
			eti.ETcantrecibida,
			eti.ETcostodirecto + eti.ETcostoindfletes + eti.ETcostoindfletesPoliza
			+ eti.ETcostoindseg + eti.ETcostoindsegPoliza + eti.ETcostoindsegpropio
			+ eti.ETcostoindgastos + eti.ETcostoindimp as CostoTotal,
			eti.ETcostorecibido,
			eti.ETIdescripcion,
			eti.DOlinea, 
			a.DOconsecutivo,
			a.CMtipo,
			a.DOcantidad, 
			case CMtipo when 'A' then Adescripcion
       			when 'S' then Cdescripcion
       			when 'F' then j.ACdescripcion#_Cat#'/'#_Cat#k.ACdescripcion end as descripcion,
			mon.Mnombre,
			a.EOnumero
				
	from ETrackingItems eti
	
		left outer join Monedas mon
			on eti.Mcodigo = mon.Mcodigo
			and eti.Ecodigo = mon.Ecodigo
			
		inner join DOrdenCM a
			on a.DOlinea = eti.DOlinea
		
		-- Articulos
		left outer join Articulos f
		on a.Aid=f.Aid
		and a.Ecodigo=f.Ecodigo
		and f.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  
		-- Conceptos
		left outer join Conceptos h
		on a.Cid=h.Cid
		and a.Ecodigo=h.Ecodigo
		and h.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		 
		-- Activos
		left outer join ACategoria j
		on a.ACcodigo=j.ACcodigo
		and a.Ecodigo=j.Ecodigo
		 
		left outer join AClasificacion k
		on a.ACcodigo=k.ACcodigo
		and a.ACid=k.ACid
		and a.Ecodigo=k.Ecodigo
		
	where 	eti.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  	and eti.ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETidtracking_move1#">
		and eti.ETIestado = 0
</cfquery>

<cfoutput>
<table width="98%" class="tablaborde" align="center" border="0" cellpadding="2" cellspacing="0" bgcolor="##F5F5F5">
	<tr>
		<td width="10%" nowrap colspan="7"><strong>N&uacute;mero de Tracking:</strong>&nbsp;#rsTracking.ETnumtracking#</td>
		<!---<td width="22%" nowrap>#rsTracking.ETnumtracking#</td>--->
	</tr>
</table>
</cfoutput>
<br>
<cfoutput>
<table align="center" width="98%" cellpadding="2" cellspacing="0">
	<tr class="tituloListas">
		<td width="5%" nowrap style="border-top:1px solid black; border-bottom:1px solid black; border-left:1px solid black; border-right:1px solid black;"><strong>Línea</strong></td>
		<!----<td width="60%" nowrap style="border-top:1px solid black; border-bottom:1px solid black; border-right:1px solid black;"><strong>Descripci&oacute;n</strong></td>---->
		<td width="8%" nowrap style="border-top:1px solid black; border-bottom:1px solid black; border-right:1px solid black;"><strong>No Orden</strong></td>
		<td width="10%" nowrap align="left" style="border-top:1px solid black; border-bottom:1px solid black; border-right:1px solid black;"><strong>Cantidad Disponible</strong></td>
		<td width="10%" nowrap align="left" style="border-top:1px solid black; border-bottom:1px solid black; border-right:1px solid black;"><strong>Cantidad Facturada</strong></td>
		<td width="10%" nowrap align="left" style="border-top:1px solid black; border-bottom:1px solid black; border-right:1px solid black;"><strong>Cantidad Recibida</strong></td>
		<td width="20%" nowrap align="right" style="border-top:1px solid black; border-bottom:1px solid black; border-right:1px solid black;"><strong>Costo Total</strong></td>
		<td width="20%" nowrap align="right" style="border-top:1px solid black; border-bottom:1px solid black; border-right:1px solid black;"><strong>Costo Recibido</strong></td>
		<td width="5%" nowrap align="right" style="border-top:1px solid black; border-bottom:1px solid black; border-right:1px solid black;"><strong>Moneda</strong></td>
	</tr>
	
	<cfloop query="rsItems">
		<tr>		
			<td colspan="8" style="border-bottom:1px solid black; border-right:1px solid black; border-left:1px solid black; border-top:1px solid black;"><table width="100%"><tr>
				<td width="4%"><strong>Item:</strong></td>
				<td width="96%"><cfoutput>#rsItems.ETIdescripcion#</cfoutput></td>
			</tr></table></td>
		</tr>
		<tr>
			<td nowrap  width="5%" style="border-left:1px solid black; border-right:1px solid black;">#rsItems.DOconsecutivo#</td>
			<!---<td nowrap width="40%" style="border-bottom:1px solid black;border-right:1px solid black;"><cfif len(trim(rsItems.ETIdescripcion))>#rsItems.ETIdescripcion#<cfelse>-</cfif></td>---->
			<td nowrap width="8%" style="border-right:1px solid black;"><cfif len(trim(rsItems.ETIdescripcion))>#rsItems.EOnumero#<cfelse>-</cfif></td>
			<td align="right" nowrap width="10%" style="border-right:1px solid black;"><cfif len(trim(rsItems.ETIcantidad))>#LSNumberFormat(rsItems.ETIcantidad, ',9.00')#<cfelse>-</cfif></td>
			<td align="right" nowrap width="10%" style="border-right:1px solid black;"><cfif len(trim(rsItems.ETIcantidad))>#LSNumberFormat(rsItems.ETcantfactura, ',9.00')#<cfelse>-</cfif></td>
			<td align="right" nowrap width="10%" style="border-right:1px solid black;"><cfif len(trim(rsItems.ETIcantidad))>#LSNumberFormat(rsItems.ETcantrecibida, ',9.00')#<cfelse>-</cfif></td>
			<td align="right" nowrap width="10%" style="border-right:1px solid black;"><cfif len(trim(rsItems.ETIcantidad))>#LSNumberFormat(rsItems.CostoTotal, ',9.00')#<cfelse>-</cfif></td>
			<td align="right" nowrap width="10%" style="border-right:1px solid black;"><cfif len(trim(rsItems.ETIcantidad))>#LSNumberFormat(rsItems.ETcostorecibido, ',9.00')#<cfelse>-</cfif></td>
			<td align="right" nowrap width="5%" style="border-right:1px solid black;">#rsItems.Mnombre#</td>
		</tr>
	</cfloop>
	<tr>		
		<td colspan="8" style="border-top:1px solid black;">&nbsp;</td>
	</tr>
	
	<cfif rsItems.RecordCount gt 0 >
		<tr><td colspan="8" align="center">&nbsp;</td></tr>
		<tr><td colspan="8" align="center">------------------ Fin del Reporte ------------------</td></tr>
	<cfelse>
		<tr><td colspan="8" align="center">&nbsp;</td></tr>
		<tr><td colspan="8" align="center">--- No se encontraron datos ----</td></tr>
	</cfif>

</table>
</cfoutput>

<br>