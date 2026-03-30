<cfsetting requesttimeout="3600">
<cfif not isdefined('form.CMPid') and isdefined('url.CMPid')>
	<cfset form.CMPid = url.CMPid>
</cfif>
	
<title>Garantías</title>

<cfquery name="rsConsulta" datasource="#session.dsn#">
	select 
		tp.TGdescripcion, coalesce(tp.TGmonto,0) as TGmonto, CMPcodigoProceso, m.Miso4217,
		TGmanejaMonto, tp.Mcodigo,
		case when TGmanejaMonto = 1 then 'Monto' else 'Porcentaje ' end as descripcionM,
		case when tp.TGporcentaje is null then 0 else tp.TGporcentaje end as TGporcentaje,
		c.CMPnumero,
		c.CMPdescripcion	
	from CMProcesoCompra c
	inner join TiposGarantia tp
		on tp.TGid = c.TGidP	
	left outer join Monedas m
		on m.Mcodigo = tp.Mcodigo		
	where c.CMPid = #form.CMPid#
</cfquery>

    <cf_htmlreportsheaders
        title="Garantías" 
        filename="Garantías#session.Usulogin##LSDateFormat(now(),'yyyymmdd')#.xls" 
        back="no"
        irA="" >
		  
    <cfif not isdefined("form.btnDownload")>
        <cf_templatecss>
    </cfif>	
<form action="GarantiaDetalleP.cfm" method="post" name="form1">
	<table width="100%" border="0" align="center">
	<tr><td colspan="2">&nbsp;</td></tr>
		<tr>			
			<td> 			
			<cfif isdefined('CMPid') and len(trim(#CMPid#)) gt 0>
		        <input type="hidden" name="CMPid" value="<cfoutput>#CMPid#</cfoutput>"/> 
			</cfif>
			</td>
		</tr>
	
		<tr>
			<td>
				<strong>Proceso: <cfoutput>#rsConsulta.CMPnumero# - #rsConsulta.CMPdescripcion#</cfoutput></strong>
			</td>
		</tr>
		<tr>	
			<td>	
				<strong> Garantía Participación: <cfoutput>(#rsConsulta.TGdescripcion# - #rsConsulta.descripcionM#: <cfif #rsConsulta.TGmanejaMonto# eq 1>
			#rsConsulta.Miso4217# #numberformat(rsConsulta.TGmonto)# <cfelse> #rsConsulta.TGporcentaje#)</cfif></cfoutput></strong>				
			</td>
		</tr>
		
		<tr>			
			<td align="center" width="50%">
				<strong> Lista del Proveedores</strong>
			</td>
		</tr>
	</table>
</form>

<cfset fnObtieneDatos()>
<cfset registros = 0 >
<cfflush interval="20">
<cfset LvarColSpan = 7>
<table width="100%" cellpadding="0" cellspacing="1" border="0">	
	<cfoutput>
    <tr>
    <td colspan="#LvarColSpan#">&nbsp;</td>
    </tr>
    </cfoutput>
    <tr nowrap="nowrap" align="center" class="tituloListas">
        <td colspan="0" align="left" nowrap="nowrap">Proveedor</td>
        <td colspan="0" align="left" nowrap="nowrap">Cotización</td>
        <td colspan="0" align="left" nowrap="nowrap">Moneda</td>
        <td colspan="0" align="left" nowrap="nowrap">Garantía Participación</td>
        <td colspan="0" align="left" nowrap="nowrap">Moneda</td>
        <td colspan="0" align="left" nowrap="nowrap">Cumplimiento</td>
        <td colspan="0" align="left" nowrap="nowrap">Fecha de Vencimiento</td>
    </tr>
	<tr>
		<td colspan="7" class="tituloAlterno"></td>
	</tr>			
    <cfflush>
   	 <cfloop query="rsProv">	
		 
		  <cfquery name="rsLocal" datasource="#session.dsn#">
			  select Mcodigo 
			  from Empresas 
			  where Ecodigo = #session.Ecodigo#
   	 </cfquery>
    
		 <cfif rsLocal.Mcodigo eq rsProv.Mcodigo2>
			<cfset LvarTC = 1.00>
		 <cfelse>
			 	<cfif #rsProv.Mcodigo2# neq ''>
					<cfquery name="rsTC" datasource="#session.DSN#">
						select TCventa, TCcompra
						from Htipocambio
						where Mcodigo = #rsProv.Mcodigo2#
						  and Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsProv.COEGFechaRecibe#">
						  and Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#rsProv.COEGFechaRecibe#">
					</cfquery>
					<cfset LvarTC = #rsTC.TCcompra#>
				<cfelse>
					<cfset LvarTC = 0>
				</cfif>
		 </cfif>
	
		 <cfif rsLocal.Mcodigo eq rsProv.Mcodigo>
			<cfset LvarTCG = 1.00>
		<cfelse>
			<cfset LvarTCG = 0>

			 <cfif #rsProv.Mcodigo# neq '' and #rsConsulta.TGmanejaMonto# eq 0>
				<cfquery name="rsTCG" datasource="#session.DSN#">
					select TCventa, coalesce(TCcompra,0) as TCcompra
					from Htipocambio
					where Mcodigo = #rsProv.Mcodigo#
					  and Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsProv.COEGFechaRecibe#">
					  and Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#rsProv.COEGFechaRecibe#">
				</cfquery>
				<cfif #rsTCG.recordcount# neq 0>
					<cfset LvarTCG = #rsTCG.TCcompra#>
				<cfelse>
					<cfset LvarTCG = 0>
				</cfif>
			<cfelseif #rsProv.Mcodigo# neq '' and #rsConsulta.TGmanejaMonto# eq 1>
				<cfquery name="rsTCG" datasource="#session.DSN#">
					select TCventa, coalesce(TCcompra,0) as TCcompra
					from Htipocambio
					where Mcodigo = #rsConsulta.Mcodigo#
					  and Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsProv.COEGFechaRecibe#">
					  and Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#rsProv.COEGFechaRecibe#">
				</cfquery>
				<cfif #rsTCG.recordcount# neq 0>
					<cfset LvarTCG = #rsTCG.TCcompra#>
				<cfelse>
					<cfset LvarTCG = 0>
				</cfif>
			</cfif>
		</cfif>
		 <cfif #rsProv.ECtotal# neq ''>
			<cfset LvarM = #rsProv.ECtotal#>
		 <cfelse>
			<cfset LvarM = 0>
		 </cfif>
		 
		 <cfif #rsProv.monto# neq ''>
			<cfset LvarM2 = #rsProv.monto#>
		 <cfelse>
			<cfset LvarM2 = 0>
		 </cfif>	 
 
		<cfset registros = registros + 1 >
		<cfset LvarMonto =  #numberformat(LvarM  * LvarTC, "9.00")#>
		
		<cfset LvarMontoG = #numberformat(LvarM2 * LvarTCG,  "9.00")#>
		
		<cfif #rsConsulta.TGmanejaMonto# eq 1><!---Por Monto--->
		<cfset LvarMontoGarantia = #numberformat(rsConsulta.TGmonto * LvarTCG,  "9.00")#>
			 <cfif #LvarMontoGarantia# eq #LvarMontoG#>
				<cfset cumplio = 'ok'>
			 <cfelseif  #LvarMontoG# lt #LvarMontoGarantia#>
				<cfset cumplio = 'Falta'>
			 <cfelse>
				<cfset cumplio = 'ok'>
			 </cfif>	
		<cfelse><!---Por Porcentaje--->
			 <cfif (((#LvarMonto# * (#rsConsulta.TGporcentaje#/100)) eq #LvarMontoG#) or ((#LvarMonto# * (#rsConsulta.TGporcentaje#/100)) gt #LvarMontoG#) )>
				<cfset cumplio = 'ok'>
			 <cfelseif  #LvarMontoG# lt (#LvarMonto# * #rsConsulta.TGporcentaje#)>
				<cfset cumplio = 'Falta'>
			 <cfelse>
				<cfset cumplio = 'ok'>
			 </cfif>	
		</cfif> 			
		<cfif registros neq 0>
		  <cfoutput>
				<tr class="<cfif rsProv.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
					 <td align="left">#rsProv.SNnombre#</td>
					 <td align="left" nowrap="nowrap">#rsProv.ECdescprov# (#NumberFormat(LvarMonto,',9.99')#)</td>
					 <td align="left" nowrap="nowrap">#rsProv.moneda#</td>	
					 <td align="left" nowrap="nowrap">#NumberFormat(LvarMontoG,',9.99')#</td>	
					 <td align="left" nowrap="nowrap">#rsProv.moneda2#</td>	
					 <td align="left" nowrap="nowrap">#cumplio#</td>
					 <td align="left" nowrap="nowrap">#DateFormat(Fecha,'dd/mm/yyyy')#</td>	
				</tr>				
		  </cfoutput>
	  </cfif>
        <cfflush>
    </cfloop>
    <tr>
    	<td>&nbsp;</td>
    </tr>
    <cfoutput>
        <tr>
            <td colspan="#LvarColSpan#">&nbsp;</td>
        </tr>
		  <cfif registros lte 0 >
		  <tr><td colspan="10" align="center">--- No se encontraron registros ---</td></tr>
		  </cfif>
        <tr>
            <td align="center" nowrap="nowrap" colspan="#LvarColSpan#" class="tituloListas">---Fin de Consulta---</td>
        </tr>
        <tr>
            <td align="center" colspan="#LvarColSpan#">
                <hr />            
            </td>
        </tr>
		  
				<tr>
					<td colspan="10" align="center"><input type="button" name="btncerrar" value="Cerrar" onClick="javascript:cerrarVentana()"> </td>
				</tr>	
		  
	</cfoutput>
</table>
    
<cffunction name="fnObtieneDatos" access="private" output="no">
    <cfquery datasource="#session.DSN#" name="rsProv">
			select distinct 
				m.Miso4217 as moneda,
				gr.COEGFechaRecibe, 
			  ((
				 select  min(CODGFechaFin) from COHDGarantia b where b.COEGid = gr.COEGid
				)) as Fecha,
				m2.Miso4217 moneda2,
				gr.Mcodigo, 
				a.CMPlinea, 
				b.SNcodigo, 
				b.SNnumero, 
				b.SNnombre,
				c.Mcodigo as Mcodigo2, 
				c.ECdescprov, 
				coalesce(c.ECtotal,0) as ECtotal,
				coalesce(gr.COEGMontoTotal,0) as monto
		  from CMProveedoresProceso a
			inner join SNegocios b 
				 on a.Ecodigo = b.Ecodigo 
				 and a.SNcodigo = b.SNcodigo
			inner join CMProcesoCompra d 
				 on d.CMPid = a.CMPid 
				 
			left outer join ECotizacionesCM c 
				 on c.CMPid = d.CMPid 
				 and c.SNcodigo = b.SNcodigo
				 
			left outer join Monedas m
				 on m.Mcodigo = c.Mcodigo 
			inner join CMProceso pr 
				on pr.CMPid_CM = d.CMPid
			left outer join COHEGarantia gr 
				on gr.CMPid = pr.CMPid
				and gr.SNid = b.SNid 
				and gr.COEGVersionActiva  = 1
				
  			left outer join Monedas m2 on m2.Mcodigo = gr.Mcodigo 
				
			left outer join TiposGarantia tg 
				on tg.TGtipo = gr.COEGTipoGarantia
			where a.CMPid = #form.CMPid# and a.Ecodigo = #session.Ecodigo#
		  and b.SNtiposocio <> 'C' 
			group by  m.Miso4217,gr.COEGFechaRecibe, gr.COEGMontoTotal,gr.Mcodigo, a.CMPlinea, c.ECtotal, c.ECdescprov, b.SNcodigo, b.SNnumero, b.SNnombre, pr.CMPid,a.CMPid,c.Mcodigo,
			c.Ecodigo,c.ECconsecutivo,b.SNid,gr.COEGid,m2.Miso4217 
			order by b.SNnumero 			
	</cfquery>
</cffunction>

<script language="javascript1.2" type="text/javascript"> 
	function cerrarVentana(){
		window.close();
	}
</script> 





