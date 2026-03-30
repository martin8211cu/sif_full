<cfif not isdefined("Session.Modulo")>
	<cfset Session.Modulo = "IV">
</cfif>
<cfquery datasource="#session.DSN#" name="rsEmpresa">
	select Edescripcion 
	from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<link rel="stylesheet" href="../../css/asp.css" type="text/css">
<cf_sifHTML2Word Titulo="Artículos">
	<style type="text/css">
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
			
		.subTituloRep {
			font-weight: bold; 
			font-size: x-small; 
			background-color: #F5F5F5;
		}
	}
	</style>
	<cfif isdefined("url.ckPend")>
		<cfset form.ckPend = url.ckPend>
	</cfif>
	<cfset anno = 0>
	<cfset mes = 0>
	<cfquery name="rsAnno" datasource="#session.DSN#">
		select Pvalor 
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo= 50
	</cfquery>
	<cfquery name="rsMes" datasource="#session.DSN#">
		select Pvalor 
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo= 60
	</cfquery>
	<cfset anno = rsAnno.Pvalor>
	<cfset mes = rsMes.Pvalor >
	<form name="form1" method="post">
	<table width="80%" border="0" cellspacing="0" cellpadding="1" style="padding-left: 5px; padding-right: 10px" align="center">
		<tr> 
		  <td colspan="10" align="center"  bgcolor="#EFEFEF"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></strong></td>
		</tr>
		<tr> 
		  <td colspan="10">&nbsp;</td>
		</tr>
		<tr> 
		  <td colspan="10" align="center"><font size="3"><b><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">Processing Fee Summary</strong></b></font></td>
		</tr>
	
		<tr>
			<td colspan="10" align="center"><font size="2"><b>For Month Ending: </b><cfoutput>#MonthAsString(rsMes.Pvalor)#</cfoutput><b></b>, <cfoutput>#rsAnno.Pvalor#</cfoutput>&nbsp;</font></td>
		</tr>
		<cfif isdefined('Url.ETid') and ltrim(rtrim(Url.ETid)) NEQ 0 and not isdefined("form.ETid")>
			<cfset form.ETid = Url.ETid>
		</cfif>
	
	<!--- Rodolfo Jimenez Jara, 12/02/2004, SOIN, CentroAmerica --->
	
	<cfquery datasource="#session.DSN#" name="rsSales">
		select  
			coalesce(sum(a.CCVPpreciouloc * case when t.CCTtipo = 'C' then -1.00 else 1.00 end) , 0.00)     as Monto, 
			coalesce(sum(a.CCVPcantidad * case when t.CCTtipo = 'C' then -1.00 else 1.00 end) ,0.00)        as BBL, 
			coalesce(sum(a.CCVPpreciouloc * case when t.CCTtipo = 'C' then -1.00 else 1.00 end * 2), 0.00)  as MontoShell, 
			coalesce(sum(a.CCVPcantidad * case when t.CCTtipo = 'C' then -1.00 else 1.00 end * 2), 0.00)    as BBLShell
		from Articulos b
			inner join CCVProducto a
					inner join CCTransacciones t
							 on t.CCTcodigo = a.CCTcodigo
							and t.Ecodigo   = a.Ecodigo
				on a.Aid = b.Aid
				and a.CCVPestado = 0
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		   and b.Aconsumo = 0  
	</cfquery> 
	<cfquery datasource="#session.DSN#" name="rsOwnConsuption">
		select  
			coalesce(sum(a.CCVPpreciouloc * case when t.CCTtipo = 'C' then -1.00 else 1.00 end) , 0.00)     as Monto, 
			coalesce(sum(a.CCVPcantidad * case when t.CCTtipo = 'C' then -1.00 else 1.00 end) ,0.00)        as BBL, 
			coalesce(sum(a.CCVPpreciouloc * case when t.CCTtipo = 'C' then -1.00 else 1.00 end * 2), 0.00)  as MontoShell, 
			coalesce(sum(a.CCVPcantidad * case when t.CCTtipo = 'C' then -1.00 else 1.00 end * 2), 0.00)    as BBLShell
		from Articulos b
			inner join CCVProducto a
					inner join CCTransacciones t
							 on t.CCTcodigo = a.CCTcodigo
							and t.Ecodigo   = a.Ecodigo
				on a.Aid = b.Aid
				and a.CCVPestado = 0
		where b.Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and b.Aconsumo = 1   
	</cfquery> 	
	<cfquery datasource="#session.DSN#" name="rsPurchases">			
		select  
			coalesce(sum(a.Kcosto) *-1, 0)    as Monto, 
			coalesce(sum(a.Kunidades*-1),0)   as BBL, 
			coalesce(sum(a.Kcosto*-2),0)      as MontoShell, 
			coalesce(sum(a.Kunidades * -2),0) as BBLShell
		from Kardex a
			inner join Articulos b
					 on b.Aid = a.Aid
					and b.Aconsumo = 0
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.Kperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#anno#">  
		  and a.Kmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#mes#">  
		  and a.Ktipo = 'E'
	</cfquery> 	
	<cfquery datasource="#session.DSN#" name="rsInventory">
		select  
			coalesce(sum( (tr.DTinvfinal - tr.DTinvinicial + tr.DTperdidaganancia) * coalesce(b.Acosto, 1)) *1, 0)   as Monto , 
			coalesce(sum((tr.DTinvfinal - tr.DTinvinicial + tr.DTperdidaganancia)*1),0)                            as BBL, 
			coalesce(sum((tr.DTinvfinal - tr.DTinvinicial + tr.DTperdidaganancia) * coalesce(b.Acosto, 1) * 2),0)    as MontoShell , 
			coalesce(sum((tr.DTinvfinal - tr.DTinvinicial + tr.DTperdidaganancia) * 2),0)                          as BBLShell
		from DTransformacion tr
			inner join Articulos b
			     on b.Aid = tr.Aid
		where tr.ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETid#">   
	</cfquery> 		
	<cfquery datasource="#session.DSN#" name="rsFess">
			select 
				coalesce(sum(GPmonto*-1),0)     as Monto, 
				coalesce(sum(GPmonto* -2),0)    as MontoShell
			from CPGastosProduccion
			where ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETid#">
	</cfquery> 
	<cfoutput> 
	<tr> 
	  <td colspan="15" >&nbsp;</td>
	</tr>
	<tr  class="tituloListas">
		<td nowrap ><div align="center" ><font size="1"></font></div></td>
		<td nowrap ><div align="center" ><font size="1"><strong>Amount</strong></font></div></td>
		<td nowrap ><div align="center"><font size="1"><strong>BBL</strong></font></div></td>
		<td nowrap ><div align="center"><font size="1"><strong>Amount SHELL</strong></font></div></td>
		<td nowrap ><div align="center"><font size="1"><strong>BBL/SHELL</strong></font></div></td>
	</tr>
	<cfset lineas = 0>
	<cfset SalesMonto = 0>
	<cfset OwnMonto = 0>
	<cfset PurchasesMonto = 0>
	<cfset InventoryMonto = 0>			
	<cfloop query="rsSales">	
		<cfset SalesMonto = rsSales.Monto>
		<tr align="right">
			<td nowrap bgcolor="##FFFFFF" ><div align="left"><strong><a href="DetalleVentas.cfm?ETid=#form.ETid#">Sales</a></strong></div></td>
			<td align="left" nowrap bgcolor="##FAFAFA"><div align="right"><a href="DetalleVentas.cfm?ETid=#form.ETid#">#LSNumberFormat(rsSales.Monto,",9.00")#</a></div></td>
			<td nowrap bgcolor="##FAFAFA"><div align="right"><a href="DetalleVentas.cfm?ETid=#form.ETid#">#LSNumberFormat(rsSales.BBL,",9.00")#</a> </div></td>
			<td nowrap bgcolor="##FFFFFF"><div align="right"><a href="DetalleVentas.cfm?ETid=#form.ETid#">#LSNumberFormat(rsSales.MontoShell,",9.00")#</a></div></td>
			<td nowrap><div align="right"><a href="DetalleVentas.cfm?ETid=#form.ETid#">#LSNumberFormat(rsSales.BBLShell,",9.00")#</a></div></td>
		</tr>
	</cfloop>
	<cfloop query="rsOwnConsuption">	
		<cfset OwnMonto = rsOwnConsuption.Monto>
		<tr align="right">
		  <td nowrap bgcolor="##FFFFFF" ><div align="left"><strong><a href="DetalleConsumoPropio.cfm?ETid=#form.ETid#">Own
		  Consumption </a>:</strong></div></td>

		  <td align="left" nowrap bgcolor="##FAFAFA">
			<div align="right"><a href="DetalleConsumoPropio.cfm?ETid=#form.ETid#">#LSNumberFormat(rsOwnConsuption.Monto,",9.00")#</a></div></td>
					  
			<td nowrap bgcolor="##FAFAFA"><div align="right">
			  <a href="DetalleConsumoPropio.cfm?ETid=#form.ETid#">#LSNumberFormat(rsOwnConsuption.BBL,",9.00")#</a> </div></td>
			<!--- <td nowrap><div align="center">#rsArticulo.Adescripcion#</div></td> --->
		  <td nowrap bgcolor="##FFFFFF"><div align="right"><a href="DetalleConsumoPropio.cfm?ETid=#form.ETid#">#LSNumberFormat(rsOwnConsuption.MontoShell,",9.00")#</a></div>
		  </td>
			<td nowrap>
				<div align="right"><a href="DetalleConsumoPropio.cfm?ETid=#form.ETid#">#LSNumberFormat(rsOwnConsuption.BBLShell,",9.00")#</a></div>
		  </td>
		</tr>
	</cfloop>
	<cfloop query="rsPurchases">	
		<cfset PurchasesMonto = rsPurchases.Monto>
		<tr align="right">
		  <td nowrap bgcolor="##FFFFFF" ><div align="left"><strong>Less:</strong></div></td>
		  <td align="left" nowrap bgcolor="##FAFAFA">&nbsp;</td>
		  <td nowrap bgcolor="##FAFAFA">&nbsp;</td>
		  <td nowrap bgcolor="##FFFFFF">&nbsp;</td>
		  <td nowrap>&nbsp;</td>
		</tr>
		<tr align="right">
		  <td nowrap bgcolor="##FFFFFF" ><div align="left"><strong><a href="DetalleCompras.cfm?ETid=#form.ETid#&periodo=#anno#&mes=#mes#">&nbsp;&nbsp;&nbsp;Purchases</a></strong></div></td>

		  <td align="left" nowrap bgcolor="##FAFAFA">
			<div align="right"><a href="DetalleCompras.cfm?ETid=#form.ETid#&periodo=#anno#&mes=#mes#">#LSNumberFormat(rsPurchases.Monto,",9.00")#</a></div></td>
					  
			<td nowrap bgcolor="##FAFAFA"><div align="right">
			  <a href="DetalleCompras.cfm?ETid=#form.ETid#&periodo=#anno#&mes=#mes#">#LSNumberFormat(rsPurchases.BBL,",9.00")#</a> </div></td>
			<!--- <td nowrap><div align="center">#rsArticulo.Adescripcion#</div></td> --->
		  <td nowrap bgcolor="##FFFFFF"><div align="right"><a href="DetalleCompras.cfm?ETid=#form.ETid#&periodo=#anno#&mes=#mes#">#LSNumberFormat(rsPurchases.MontoShell,",9.00")#</a></div>
		  </td>
			<td nowrap>
				<div align="right"><a href="DetalleCompras.cfm?ETid=#form.ETid#&periodo=#anno#&mes=#mes#">#LSNumberFormat(rsPurchases.BBLShell,",9.00")#</a></div>
		  </td>
		</tr>
	</cfloop>
	<cfloop query="rsInventory">	
	<cfset InventoryMonto = rsInventory.Monto>
	<tr align="right">
		<td nowrap bgcolor="##FFFFFF" ><div align="left"><strong><a href="DetalleCambioInventario.cfm?ETid=#form.ETid#">&nbsp;&nbsp;&nbsp;Inventory Change</a></strong></div></td>
		<td align="left" nowrap bgcolor="##FAFAFA"><div align="right"><a href="DetalleCambioInventario.cfm?ETid=#form.ETid#">#LSNumberFormat(rsInventory.Monto,",9.00")#</a></div></td>
		<td nowrap bgcolor="##FAFAFA"><div align="right"><a href="DetalleCambioInventario.cfm?ETid=#form.ETid#">#LSNumberFormat(rsInventory.BBL,",9.00")#</a> </div></td>
		<td nowrap bgcolor="##FFFFFF"><div align="right"><a href="DetalleCambioInventario.cfm?ETid=#form.ETid#">#LSNumberFormat(rsInventory.MontoShell,",9.00")#</a></div></td>
		<td nowrap><div align="right"><a href="DetalleCambioInventario.cfm?ETid=#form.ETid#">#LSNumberFormat(rsInventory.BBLShell,",9.00")#</a></div></td>
	</tr>
	</cfloop>
	<tr>
	  <td bgcolor="##FFFFFF" class="topline" ><strong>
	  <cfset totalMonto = 0>
	  GrossProcessing Fee</strong></td>
	  <td height="22" align="left" bgcolor="##FAFAFA" class="topline" ><strong>
	  <cfset totalMonto = SalesMonto+OwnMonto+PurchasesMonto+InventoryMonto>
	  </strong>		        <div align="right"><strong>#LSNumberFormat(totalMonto,",9.00")#</strong></div></td>
	  <td align="left" bgcolor="##FAFAFA" class="topline"><strong>
	  <cfset TotalBBL = rsSales.BBL+rsOwnConsuption.BBL+rsPurchases.BBL+rsInventory.BBL> 
	  </strong>		        <div align="right"><strong>#LSNumberFormat(TotalBBL,",9.00")#</strong></div></td>
	  <td align="left" bgcolor="##FFFFFF" class="topline"><strong>
	  <cfset TotalMontoShell = rsSales.MontoShell+rsOwnConsuption.MontoShell+rsPurchases.MontoShell+rsInventory.MontoShell>
	  </strong>
		<div align="right"><strong>#LSNumberFormat(TotalMontoShell,",9.00")#</strong></div>
	  </td>
	  <td align="left" bgcolor="##FFFFFF" class="topline"><strong>
	  <cfset TotalBBLShell = rsSales.BBLShell+rsOwnConsuption.BBLShell+rsPurchases.BBLShell+rsInventory.BBLShell>
	  </strong><div align="right"><strong>#LSNumberFormat(TotalBBLShell,",9.00")#</strong></div></td>
	</tr>
	<tr>
	  <td align="right" nowrap bgcolor="##FFFFFF" class="topline"><div align="left"><strong><a href="DetalleCuotas.cfm?ETid=#form.ETid#">&nbsp;&nbsp;&nbsp;Fees &amp; Expenses </a></strong></div></td>
	  <td align="left" nowrap bgcolor="##FAFAFA" class="topline"><div align="right"><a href="DetalleCuotas.cfm?ETid=#form.ETid#">#LSNumberFormat(rsFess.Monto,",9.00")#</a></div></td>
	  <td align="right" nowrap bgcolor="##FAFAFA" class="topline">&nbsp;</td>
	  <td align="right" nowrap bgcolor="##FFFFFF" class="topline"><div align="right"><a href="DetalleCuotas.cfm?ETid=#form.ETid#">#LSNumberFormat(rsFess.MontoShell,",9.00")#</a></div></td>
	  <td align="right" nowrap class="topline">&nbsp;</td>
	</tr>
	<tr>
		<td align="left" nowrap bgcolor="##FFFFFF" class="topline"><div align="left"><strong>TTL Processing Fee</strong></div></td>
		<td align="right" nowrap bgcolor="##FAFAFA" class="topline"><cfset totalTTL = totalMonto +rsFess.Monto><div align="right">#LSNumberFormat(totalTTL,",9.00")#</div></td>
		<td align="right" nowrap bgcolor="##FAFAFA" class="topline">&nbsp;</td>
		<td align="right" nowrap bgcolor="##FFFFFF" class="topline"><cfset totalTTLShell = TotalMontoShell +rsFess.MontoShell>#LSNumberFormat(totalTTLShell,",9.00")#</td>
		<td align="right" nowrap class="topline">&nbsp;</td>
	</tr>
  	<td colspan="15" >&nbsp;</td>
</tr>
<input name="ETid" type="hidden" value="#form.ETid#">
</cfoutput> 			
</form>
</cf_sifHTML2Word>