<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>

<style type="text/css">
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
		font-size:11px;
		background-color:#F5F5F5;
	}
	.csscomprador {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
		font-size:11px;
		background-color:#FAFAFA;
	}
	.item {
		font-size:10px;
	}
	.letra {
		font-size:10px;
		padding-bottom:5px;
	}
	.letra2 {
		font-size:11px;
		font-weight:bold;
	}
</style>

<cfif isdefined("url.SNcodigoi") and not isdefined("form.SNcodigoi")>
	<cfset form.SNcodigoi = Url.SNcodigoi>
	<cfset form.SNnumeroi = Url.SNnumeroi>
</cfif>
<cfif isdefined("url.SNcodigof") and not isdefined("form.SNcodigof")>
	<cfset form.SNcodigof = Url.SNcodigof>
	<cfset form.SNnumerof = Url.SNnumerof>
</cfif>

<cfif isdefined("url.fechai") and len(trim(url.fechai)) and not isdefined("form.fechai")>
	<cfset form.fechai = Url.fechai>
	<cfset vFechai = lsparseDateTime(form.fechai) >
</cfif>
<cfif isdefined("url.fechaf") and len(trim(url.fechai)) and not isdefined("form.fechaf")>
	<cfset form.fechaf = Url.fechaf>
	<cfset vFechaf = lsparseDateTime(form.fechaf) >
</cfif>

<cfif isdefined("form.fechai") and len(trim(form.fechai)) >
	<cfset vFechai = lsparseDateTime(form.fechai) >
<cfelse>
	<cfset vFechai = createdate(1900, 01, 01) >
</cfif>
<cfif isdefined("form.fechaf")  and len(trim(form.fechaf)) >
	<cfset vFechaf = lsparseDateTime(form.fechaf) >
<cfelse>
	<cfset vFechaf = createdate(6100, 01, 01) >
</cfif>

<cfif isdefined("url.EOidorden1") and not isdefined("form.EOidorden1")>
	<cfset form.EOidorden1 = Url.EOidorden1>
	<cfset form.EOidorden1 = Url.EOidorden1>
</cfif>
<cfif isdefined("url.EOidorden2") and not isdefined("form.EOidorden2")>
	<cfset form.EOidorden2 = Url.EOidorden2>
	<cfset form.EOidorden2 = Url.EOidorden2>
</cfif>

<!--- Rango de proveedores --->
<cfif isdefined("form.SNnumeroi") and len(trim(form.SNnumeroi)) and isdefined("form.SNnumerof") and len(trim(form.SNnumerof)) >
	<cfif compare(form.SNnumeroi, form.SNnumerof) eq 1 >
		<cfset tmp = form.SNnumeroi >
		<cfset form.SNnumeroi = form.SNnumerof >
		<cfset form.SNnumerof = tmp >
	</cfif>
</cfif>

<!--- Rango de ordenes --->
<cfif isdefined("form.EOnumero1") and len(trim(form.EOnumero1)) and isdefined("form.EOnumero2") and len(trim(form.EOnumero2)) >
	<cfif compare(form.EOnumero1, form.EOnumero2) eq 1 >
		<cfset tmp = form.EOnumero1 >
		<cfset form.EOnumero1 = form.EOnumero2 >
		<cfset form.EOnumero2 = tmp >
	</cfif>
</cfif>

<!--- Rango de fechas --->
<cfif isdefined("vFechai") and isdefined("vFechaf") >
	<cfif DateCompare(vFechai, vFechaf) eq 1 >
		<cfset tmp = vFechai >
		<cfset vFechai = vFfechaf >
		<cfset vFechaf = tmp >
	</cfif>
</cfif>

<cfquery name="data" datasource="#session.DSN#">
	select count(1) as CantidadRegistros
	from DOrdenCM a
	 
	inner join Unidades k
	on a.Ucodigo = k.Ucodigo
	and a.Ecodigo = k.Ecodigo
		  
	inner join EOrdenCM b
	on a.EOidorden=b.EOidorden
	and b.EOestado = 10
	and EOfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFechai#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFechaf#">	
	 
	inner join SNegocios c
	on b.SNcodigo=c.SNcodigo
	and b.Ecodigo=c.Ecodigo
	 
	<cfif isdefined("form.SNnumeroi") and len(trim(form.SNnumeroi)) and isdefined("form.SNnumerof") and len(trim(form.SNnumerof))>  
		and c.SNnumero between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNnumeroi#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNnumerof#">
	<cfelseif isdefined("form.SNnumeroi") and len(trim(form.SNnumeroi))>
		and c.SNnumero >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNnumeroi#">
	<cfelseif isdefined("form.SNnumerof") and len(trim(form.SNnumerof))>
		and c.SNnumero <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNnumerof#">
	</cfif> 
	
	inner join CFuncional cf
	on cf.CFid=a.CFid
	 
	where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">   
	<cfif isdefined("form.EOnumero1") and len(trim(form.EOnumero1)) and isdefined("form.EOnumero2") and len(trim(form.EOnumero2))>
		and b.EOnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero1#"> and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero2#"> 
	<cfelseif isdefined("form.EOnumero1") and len(trim(form.EOnumero1))>
		and b.EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero1#"> 
	 </cfif>
</cfquery>
 
<cfif data.CantidadRegistros GT 3000>
	<cf_errorCode	code = "50275"
					msg  = "Se han procesado mas de 3000 registros. La consulta regresa @errorDat_1@. Por favor sea mas especifico en los filtros seleccionados"
					errorDat_1="#data.CantidadRegistros#"
	>
	<cfreturn>
</cfif>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="data" datasource="#session.DSN#">
	select 	c.SNcodigo, c.SNnumero, c.SNnombre, 
			a.EOnumero, 
			m.Miso4217,
			m.Mnombre,
			a.DOconsecutivo, 
			a.DOcantidad, 
			a.DOcantsurtida, 
			a.DOcantidad-a.DOcantsurtida as DOsaldo, 
			b.EOfecha,
			k.Ucodigo,
			case a.CMtipo when 'A' then rtrim(ltrim(Acodigo)) #_Cat#' - '#_Cat# d.Adescripcion when 'S' then rtrim(ltrim(e.Ccodigo)) #_Cat#' - '#_Cat#e.Cdescripcion when 'F' then DOdescripcion end as DOdescripcion,
			cf.CFcodigo,

			(select min(u.Usulogin)
			from UsuarioReferencia ur
			
			inner join Usuario u
			on u.Usucodigo=ur.Usucodigo
			
			where ur.STabla='CMCompradores'
			and ur.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
			and ur.llave=<cf_dbfunction name="to_char" args="b.CMCid">) as comprador,
			
			(select min(u.Usulogin)
			from ESolicitudCompraCM sc
			inner join CMSolicitantes b
			on b.CMSid=sc.CMSid
			
			inner join UsuarioReferencia ur
			on ur.llave = <cf_dbfunction name="to_char" args="sc.CMSid">
			and ur.STabla = 'CMSolicitantes'
			and ur.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
			
			inner join Usuario u
			on u.Usucodigo=ur.Usucodigo
			
			where sc.ESidsolicitud = a.ESidsolicitud) as solicitante,

			#LvarOBJ_PrecioU.enSQL_AS("a.DOpreciou")#,

			a.DOmontodesc as descuento,

			coalesce((
            	select imp.Iporcentaje
				  from Impuestos imp
				 where imp.Ecodigo=a.Ecodigo 
				   and imp.Icodigo=a.Icodigo
			), 0) as impuesto,
			
            (
            	select sum(((doc.DDcantidad*doc.DDpreciou) - doc.DDdesclinea) + (((doc.DDcantidad*doc.DDpreciou) - doc.DDdesclinea)*(coalesce(imp.Iporcentaje ,0)/100)))
				  from HDDocumentosCP doc
            		left join Impuestos imp
            		 on imp.Icodigo=doc.Icodigo
            		and imp.Ecodigo=doc.Ecodigo
            	where doc.DOlinea=a.DOlinea
			) as factura
			
	from DOrdenCM a

	inner join Unidades k
	on a.Ucodigo = k.Ucodigo
	and a.Ecodigo = k.Ecodigo
					 
	inner join EOrdenCM b
	on a.EOidorden=b.EOidorden
	and b.EOestado = 10
	and EOfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFechai#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#vFechaf#">
	
	inner join SNegocios c
	on b.SNcodigo=c.SNcodigo
	and b.Ecodigo=c.Ecodigo
	
	<cfif isdefined("form.SNnumeroi") and len(trim(form.SNnumeroi)) and isdefined("form.SNnumerof") and len(trim(form.SNnumerof))>		
		and c.SNnumero between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNnumeroi#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNnumerof#">
	<cfelseif isdefined("form.SNnumeroi") and len(trim(form.SNnumeroi))>
		and c.SNnumero >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNnumeroi#">
	<cfelseif isdefined("form.SNnumerof") and len(trim(form.SNnumerof))>
		and c.SNnumero <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNnumerof#">
	</cfif>	

	left outer join Articulos d
	on a.Ecodigo=b.Ecodigo
	and a.Aid=d.Aid
	
	left outer join Conceptos e
	on a.Ecodigo=e.Ecodigo
	and a.Cid=e.Cid

	inner join CFuncional cf
	on cf.CFid=a.CFid

	inner join Monedas m
	on m.Ecodigo=b.Ecodigo
	and m.Mcodigo=b.Mcodigo

	where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	 	
	
	<cfif isdefined("form.EOnumero1") and len(trim(form.EOnumero1)) and isdefined("form.EOnumero2") and len(trim(form.EOnumero2))>
		and b.EOnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero1#"> and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero2#">	
	<cfelseif isdefined("form.EOnumero1") and len(trim(form.EOnumero1))>
		and b.EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero1#"> 
	</cfif>
	
	order by SNnumero, comprador, m.Miso4217, a.EOnumero, a.DOconsecutivo, b.EOfecha
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="1" style="padding-left: 5px; padding-right: 10px" align="center">
	<tr> 
	<td colspan="6" align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"><cfoutput>#session.Enombre#</cfoutput></strong></td>
	</tr>
	<tr> 
	<td colspan="6" class="letra" align="center"><b>Consulta de Saldos por Orden de Compra</b></td>
	</tr>
	<cfoutput> 
	<tr>
	<td colspan="6" align="center" class="letra"><b>Fecha de la Consulta:</b> #LSDateFormat(Now(), 'dd/mm/yyyy')# &nbsp; <b>Hora:&nbsp;</b>#TimeFormat(Now(),'medium')#</td>
	</tr>
	</cfoutput> 			
</table>
<br>

<table width="98%" cellpadding="1" border="0" cellspacing="0" align="center">
<cfset corte = ''>

<cfset total = 0>

<cfoutput query="data" group="SNcodigo">
		<tr><td colspan="16" >&nbsp;</td></tr>		
		
		<tr><td class="bottomline" width="1%" nowrap colspan="2"><strong>Proveedor:&nbsp;</strong></td><td colspan="14" class="bottomline"><strong>#SNnumero# - #SNnombre#</strong></td></tr>
		<tr bgcolor="##f5f5f5" >
			<td class="letra2" >Fecha</td>
			<td class="letra2">Orden</td>
			<td class="letra2">Línea</td>
			<td class="letra2">Centro</td>
			<td class="letra2">Solicitante</td>
			<td align="right" class="letra2">Cantidad</td>
			<td align="right" class="letra2">Unidad</td>
			<td align="right" class="letra2">Monto</td>
			<td align="right" class="letra2">Desc.</td>
			<td align="right" class="letra2">Imp.</td>
			<td align="right" class="letra2">SubTotal</td>			
			<td align="right" class="letra2">Cant.</td>
			<td align="right" class="letra2">Monto</td>
			<td align="right" class="letra2">Saldo</td>
		</tr>
		<tr bgcolor="##f5f5f5" >
			<td class="letra2" >&nbsp;</td>
			<td class="letra2">&nbsp;</td>			
			<td class="letra2">&nbsp;</td>
			<td class="letra2">Funcional</td>
			<td class="letra2">&nbsp;</td>
			<td align="right" class="letra2">Orden</td>
			<td align="right" class="letra2">Medida</td>
			<td align="right" class="letra2">OC</td>
			<td align="right" class="letra2">OC</td>
			<td align="right" class="letra2">OC</td>
			<td align="right" class="letra2">&nbsp;</td>			
			<td align="right" class="letra2">Surtida</td>
			<td align="right" class="letra2">Fact.</td>
			<td align="right" class="letra2">&nbsp;</td>
		</tr>
		
		<cfoutput group="comprador">
		
				<cfif data.currentrow neq 1>
				<tr><td>&nbsp;</td></tr>
				</cfif>
				<cfoutput group="Miso4217">
					<tr><td class="csscomprador" width="1%" nowrap colspan="16"><strong>Comprador:&nbsp;</strong><strong>#data.Comprador# / Moneda: #data.Miso4217#</strong></td></tr>
					<cfset total = 0 >
					<cfoutput>
					<cfset total = total + 0 >
					<tr class="<cfif data.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>" style="padding-bottom:5px;">
						<td class="item" colspan="1" >Item:</td>
						<td class="letra" colspan="15"  title="#data.DOdescripcion#" ><cfif len(data.DOdescripcion) gt 40>#mid(data.DOdescripcion,1,40)#...<cfelse>#data.DOdescripcion#</cfif></td>
					</tr>
					<tr class="<cfif data.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>" >
						<td class="letra" style="padding-left:10px; ">#LSDateFormat(data.EOfecha,'dd/mm/yyyy')#</td>
						<td class="letra" style="padding-left:10px; ">#data.EOnumero#</td>
						<td class="letra" style="padding-left:10px; ">#data.DOconsecutivo#</td>		
						<td class="letra" style="padding-left:10px; " >#data.CFcodigo#</td>
						<td class="letra" style="padding-left:10px; " >#data.solicitante#</td>
						<td class="letra" style="padding-left:10px; "align="right">#LSCurrencyFormat(data.DOcantidad,'none')#</td>
						<td class="letra" align="right">#data.Ucodigo#</td>
						<td class="letra" style="padding-left:10px; "align="right">#LvarOBJ_PrecioU.enCF(data.DOpreciou)#</td>
						<td class="letra" style="padding-left:10px; "align="right">#LSCurrencyFormat(data.descuento,'none')#</td>		
						<td class="letra" style="padding-left:10px; "align="right">
							<cfset vImpuesto =  ((data.DOcantidad*data.DOpreciou) - data.descuento)*(data.impuesto/100)>
							#LSCurrencyFormat(vImpuesto,'none')#
						</td>		
						<td class="letra" style="padding-left:10px; "align="right">
							<cfset vSubtotal =  (( data.DOcantidad*data.DOpreciou ) - data.descuento) +  ((( data.DOcantidad*data.DOpreciou ) - data.descuento)*(data.impuesto/100))>
							<cfset total = total + vsubtotal >
							#LSCurrencyFormat(vSubtotal,'none')#
						</td>				
						<td class="letra" style="padding-left:10px; "align="right">#LSCurrencyFormat(data.DOcantsurtida,'none')#</td>
						<td class="letra" style="padding-left:10px; "align="right"><cfif len(trim(data.factura))>#LSCurrencyFormat(data.factura,'none')#</cfif></td>
						<td class="letra" align="right">#LSCurrencyFormat(data.DOcantidad-data.DOcantsurtida,'none')#</td>
					</tr>
					</cfoutput> <!--- TODOS --->
					<tr>
						<td colspan="10" class="letra2" align="right">Total:&nbsp;</td>
						<td align="right" class="letra2">#LSCurrencyFormat(total,'none')#</td>
					</tr>
				</cfoutput> <!--- MONEDA--->
			</cfoutput> <!--- COMPRADOR --->
</cfoutput> <!--- SOCIO --->

	<!--- ultimo total --->
	<!---
	<tr>
		<td colspan="10" class="letra2" align="right">Total:&nbsp;</td>
		<td align="right" class="letra2"><cfoutput>#LSCurrencyFormat(total,'none')#</cfoutput></td>
	</tr>
	--->
	
	<cfif data.RecordCount gt 0 >
		<tr><td colspan="16" align="center">&nbsp;</td></tr>
		<tr><td colspan="16" align="center">------------------ Fin del Reporte ------------------</td></tr>
	<cfelse>
		<tr><td colspan="16" align="center">&nbsp;</td></tr>
		<tr><td colspan="16" align="center">--- No se encontraron datos ----</td></tr>
	</cfif>
</table>
<br>


