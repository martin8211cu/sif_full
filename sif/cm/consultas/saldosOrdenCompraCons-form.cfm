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
	.letra {
		font-size:11px;
	}
	.LetraDetalle{
		font-size:11px;
	}
	.LetraEncab{
		font-size:10px;
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
	<cfset form.fechai = lsparseDateTime(form.fechai) >
</cfif>
<cfif isdefined("url.fechaf") and len(trim(url.fechai)) and not isdefined("form.fechaf")>
	<cfset form.fechaf = Url.fechaf>
	<cfset form.fechaf = lsparseDateTime(form.fechaf) >
</cfif>

<cfif isdefined("form.fechai") and len(trim(form.fechai)) >
	<cfset form.fechai = lsparseDateTime(form.fechai) >
<cfelse>
	<cfset form.fechai = createdate(1900, 01, 01) >
</cfif>
<cfif isdefined("form.fechaf")  and len(trim(form.fechaf)) >
	<cfset form.fechaf = lsparseDateTime(form.fechaf) >
<cfelse>
	<cfset form.fechaf = createdate(6100, 01, 01) >
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

<!----
<cfif isdefined("form.EOidorden1") and len(trim(form.EOidorden1)) and isdefined("form.EOidorden2") and len(trim(form.EOidorden2)) >
	<cfif compare(form.EOidorden1, form.EOidorden2) eq 1 >
		<cfset tmp = form.EOidorden1 >
		<cfset form.EOidorden1 = form.EOidorden2 >
		<cfset form.EOidorden2 = tmp >
	</cfif>
</cfif>
---->

<!--- Rango de fechas --->
<cfif isdefined("form.fechai") and len(trim(form.fechai)) and isdefined("form.fechaf") and len(trim(form.fechaf)) >
	<cfif DateCompare(form.fechai, form.fechaf) eq 1 >
		<cfset tmp = form.fechai >
		<cfset form.fechai = form.fechaf >
		<cfset form.fechaf = tmp >
	</cfif>
</cfif>

<!---*******************	ORIGINAL***************************

	<cfif isdefined("form.SNnumeroi") and len(trim(form.SNnumeroi)) and isdefined("form.SNnumerof") and len(trim(form.SNnumerof))>
		and c.SNnumero between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNnumeroi#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNnumerof#">	
	<cfelseif isdefined("form.SNnumeroi") and len(trim(form.SNnumeroi))>
		and c.SNnumero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNnumeroi#"> 	
	<cfelseif isdefined("form.EOidorden1") and len(trim(form.EOidorden1)) and isdefined("form.EOidorden2") and len(trim(form.EOidorden2))>
		and b.EOidorden between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden1#"> and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden2#">	
	<cfelseif isdefined("form.EOidorden1") and len(trim(form.EOidorden1))>
		and b.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden1#"> 	
	<cfelseif isdefined("form.SNnumerof") and len(trim(form.SNnumerof))>
		and c.SNnumero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNnumerof#"> 	
	</cfif>		
	
	inner join EOrdenCM b
	on a.EOidorden=b.EOidorden
	and b.EOestado = 10
	and EOfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.fechai#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.fechaf#">
		
***************************************************--->

<cfquery name="data" datasource="#session.DSN#">
 select count(1) as CantidadRegistros
 from DOrdenCM a
 
  inner join Unidades k
	   on a.Ucodigo = k.Ucodigo
	   and a.Ecodigo = k.Ecodigo
      
  inner join EOrdenCM b
	   on a.EOidorden=b.EOidorden
	   and b.EOestado = 10
	   and EOfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.fechai#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.fechaf#">
		<cfif isdefined("form.EOnumero1") and len(trim(form.EOnumero1)) and isdefined("form.EOnumero2") and len(trim(form.EOnumero2))>
			and b.EOnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero1#"> and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero2#"> 
		<cfelseif isdefined("form.EOnumero1") and len(trim(form.EOnumero1))>
			and b.EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero1#"> 
		<cfelseif isdefined("form.EOnumero2") and len(trim(form.EOnumero2))>
			and b.EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero2#">
		</cfif>
	  
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
 
 	where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">   
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
			a.DOconsecutivo, 
			a.DOcantidad, 
			a.DOcantsurtida, 
			a.DOcantidad-a.DOcantsurtida as DOsaldo, 
			b.EOfecha,
			k.Ucodigo,
			case a.CMtipo when 'A' then rtrim(ltrim(Acodigo)) #_Cat#' - '#_Cat# d.Adescripcion when 'S' then rtrim(ltrim(e.Ccodigo)) #_Cat#' - '#_Cat#e.Cdescripcion when 'F' then DOdescripcion end as DOdescripcion
	from DOrdenCM a

	inner join Unidades k
		on a.Ucodigo = k.Ucodigo
		and a.Ecodigo = k.Ecodigo
					 
	inner join EOrdenCM b
		on a.EOidorden=b.EOidorden
		and b.EOestado = 10	
		and EOfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.fechai#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.fechaf#">		
		<cfif isdefined("form.EOnumero1") and len(trim(form.EOnumero1)) and isdefined("form.EOnumero2") and len(trim(form.EOnumero2))>
			and b.EOnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero1#"> and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero2#">	
		<cfelseif isdefined("form.EOnumero1") and len(trim(form.EOnumero1))>
			and b.EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero1#"> 
		<cfelseif isdefined("form.EOnumero2") and len(trim(form.EOnumero2))>
			and b.EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero2#">
		</cfif>
		
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

	where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	 	
	
	order by SNnumero, a.EOnumero, a.DOconsecutivo, b.EOfecha

</cfquery>

<!---- 
where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
and a.DOcantidad > a.DOcantsurtida ---->

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

<table width="98%" cellpadding="2" cellspacing="0" align="center">
<cfset corte = ''>
<cfoutput query="data">
	<cfif data.SNcodigo neq corte>
		<cfif data.CurrentRow neq 1>
			<tr><td colspan="10" >&nbsp;</td></tr>		
		</cfif>
		
		<tr><td class="bottomline" width="1%" nowrap><strong>Proveedor:&nbsp;</strong></td><td colspan="10" class="bottomline"><strong>#SNnumero# - #SNnombre#</strong></td></tr>
		<tr class="tituloListas">
			<td class="LetraEncab">Fecha</td>
			<td class="LetraEncab">Orden</td>			
			<td class="LetraEncab">Línea</td>
			<td class="LetraEncab">Descripci&oacute;n</td>
			<td align="right" class="LetraEncab">Cant. Orden</td>
			<td align="right" class="LetraEncab">Unidad</td>
			<td align="right" class="LetraEncab">Cant. Surtida</td>
			<td align="right" class="LetraEncab">Unidad</td>
			<td align="right" class="LetraEncab">Saldo</td>
			<td align="right" class="LetraEncab">Unidad</td>
		</tr>
	</cfif>

	<tr class="<cfif data.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>" >
		<td style="padding-left:5px; " class="LetraDetalle">#LSDateFormat(data.EOfecha,'dd/mm/yyyy')#</td>
		<td style="padding-left:5px; " class="LetraDetalle">#data.EOnumero#</td>
		<td style="padding-left:5px; " class="LetraDetalle">#data.DOconsecutivo#</td>		
		<td style="padding-left:5px; "title="#data.DOdescripcion#" class="LetraDetalle"><cfif len(data.DOdescripcion) gt 40>#mid(data.DOdescripcion,1,40)#...<cfelse>#data.DOdescripcion#</cfif></td>
		<td style="padding-left:5px; "align="right" class="LetraDetalle">#LSCurrencyFormat(data.DOcantidad,'none')#</td>
		<td align="right" class="LetraDetalle">#data.Ucodigo#</td>
		<td style="padding-left:5px; "align="right" class="LetraDetalle">#LSCurrencyFormat(data.DOcantsurtida,'none')#</td>
		<td align="right" class="LetraDetalle">#data.Ucodigo#</td>
		<td style="padding-left:5px; "align="right" class="LetraDetalle">#LSCurrencyFormat(data.DOsaldo,'none')#</td>
		<td align="right" class="LetraDetalle">#data.Ucodigo#</td>
	</tr>
	<cfset corte = data.SNcodigo >
</cfoutput>

	<cfif data.RecordCount gt 0 >
		<tr><td colspan="9" align="center">&nbsp;</td></tr>
		<tr><td colspan="9" align="center" class="LetraDetalle">------------------ Fin del Reporte ------------------</td></tr>
	<cfelse>
		<tr><td colspan="9" align="center">&nbsp;</td></tr>
		<tr><td colspan="9" align="center" class="LetraDetalle">--- No se encontraron datos ----</td></tr>
	</cfif>

</table>
<br>


