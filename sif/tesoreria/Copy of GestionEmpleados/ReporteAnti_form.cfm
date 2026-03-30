<cf_templatecss>
<cf_htmlReportsHeaders 
	irA="GEReportesAnti.cfm"
	FileName="GestionEmpleados.xls"
	title="Consultas Gestion Empleados">

<style type="text/css">
<!--
.style5 {font-size: 18px; font-weight: bold; }
-->

</style>		
<cfquery datasource="#session.DSN#" name="rsEmpresa">
		select 
				Edescripcion,
				Ecodigo
		from Empresas
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
	
<cfif isdefined ('form.estadoAnti') and #form.estadoAnti# neq 'ALL'>
	 <cfif #form.estadoAnti# eq 1>
	  	<cfset LvarEstado = 4>
		<cfset LvarEstadoDesc = "entregados y vencidos">
	 <cfelseif #form.estadoAnti# eq 2>
	 	<cfset LvarEstado = 4>
		<cfset LvarEstadoDesc = "entregados ">
	 <cfelseif #form.estadoAnti# eq 3>
	 	<cfset LvarEstado = 2>
		<cfset LvarEstadoDesc = "aprobados no entregados">
	 </cfif>
<cfelse>
	<cfset LvarEstado = '2,4'>
	<cfset LvarEstadoDesc = "Todos">	 
</cfif> 	

	<cfquery datasource="#session.dsn#" name="rsDatosConf">
	Select 
	  CCHCdiasvencAnti,
      CCHCdiasvencAntiViat
	  from 
	    CCHconfig
		where Ecodigo = #session.Ecodigo#
	</cfquery>
	
	<cfquery datasource="#session.DSN#" name="rsAnticiposLiq">
	<cfif isdefined('form.FormaPago') and #form.FormaPago# eq 'ALL' or #form.FormaPago# neq '0' >
	select  
         d.CCHdescripcion as FormaPago,
		 '-' as cuenta,
		 case coalesce(a.GEAviatico,'0') when '1'
		     then 
			      	<cf_dbfunction name="dateadd" args="#rsDatosConf.CCHCdiasvencAntiViat#, GEAhasta"> 
			 else  
			        <cf_dbfunction name="dateadd" args="#rsDatosConf.CCHCdiasvencAnti#, GEAhasta">
			end  as FechaVencimiento,
		 b.TESBeneficiario as Beneficiario,
		 a.CCHid,
		 coalesce(a.TESSPid,0) as TESSPid,
	     a.GEAnumero as Anticipo,
		 a.TESBid,
		 a.GEAdescripcion as Descripcion,
		 a.GEAtotalOri as Monto,
		 a.Mcodigo,
		 c.Miso4217 as Moneda,
		 case coalesce(a.GEAviatico,'0')
		    when '0' then 
			  'N' 
			when '1' then
			  'S' 
 		end  as EsViatico,
        a.GEAfechaPagar,
		(select GECnumero from GEcomision where GECid = a.GECid) as Comision
      from GEanticipo a
	inner join 	TESbeneficiario b
	   on a.TESBid = b.TESBid   
    inner join Monedas c
	  on a.Mcodigo = c.Mcodigo
	left outer join CCHica d
      on a.CCHid = d.CCHid 	
where a.Ecodigo = #session.Ecodigo#  
	and (				<!----- Cuando todavia existan detalles que no estan por liquidar: cantidadXliquidar < cantidadAnticipoD--->
			(
				select count(1)
				  from GEliquidacionAnts d
					inner join GEliquidacion e
					 on e.GELid 		= d.GELid
					and e.GELestado 	in (0,1,2,4,5)
				 where d.GEAid = a.GEAid
			) <
			(
				select count(1)
				  from GEanticipoDet f
				 where f.GEAid = a.GEAid
				   and f.GEADmonto - f.GEADutilizado - f.TESDPaprobadopendiente > 0
			) 
	)
<cfif #form.estadoAnti# neq 'ALL'>
   and GEAestado = #LvarEstado#
<cfelse>    
	and GEAestado in (#LvarEstado#)
</cfif>   
   and coalesce(a.CCHid,0) <> 0
   <cfif isdefined('form.FormaPago') and #form.FormaPago# neq 'ALL' and #form.FormaPago# neq '0' >
   and a.CCHid = #form.FormaPago#
   </cfif>
   <cfif #form.estadoAnti# eq 1>
       and 
	     case coalesce(a.GEAviatico,'0') when '1'   
	     then <cf_dbfunction name="dateadd" args="#rsDatosConf.CCHCdiasvencAntiViat#, GEAhasta">  
	     else
		 <cf_dbfunction name="dateadd" args="#rsDatosConf.CCHCdiasvencAnti#, GEAhasta"> 
	  end  <  <cf_dbfunction name="now">   
   
   </cfif> 
   </cfif>
   <cfif isdefined('form.FormaPago') and #form.FormaPago# eq 'ALL'>
      union
   </cfif>
   <cfif isdefined('form.FormaPago') and #form.FormaPago# eq 'ALL' or #form.FormaPago# eq '0' >
	select    distinct
         'Tesoreria' as FormaPago,
		 e.CBdescripcion as  cuenta,
		  
		 case coalesce(a.GEAviatico,'0')
		   when '1'
		     then 
			      	<cf_dbfunction name="dateadd" args="#rsDatosConf.CCHCdiasvencAntiViat#, GEAhasta"> 
			 else  
			        <cf_dbfunction name="dateadd" args="#rsDatosConf.CCHCdiasvencAnti#, GEAhasta">
			end  as FechaVencimiento, 
		 b.TESBeneficiario as Beneficiario,
		 a.CCHid,
		 coalesce(a.TESSPid,0) as TESSPid,
	     a.GEAnumero as Anticipo,
		 a.TESBid,		 
		 a.GEAdescripcion as Descripcion,
		 a.GEAtotalOri as Monto,
		 a.Mcodigo,
		 c.Miso4217 as Moneda,
		 case coalesce(a.GEAviatico,'0')
		    when '0' then 
			  'N' 
			when '1' then
			  'S' 
		end  as EsViatico,
		 a.GEAfechaPagar,
  		(select GECnumero from GEcomision where GECid = a.GECid) as Comision

		  
from GEanticipo a
	inner join TESbeneficiario b
	  on a.TESBid = b.TESBid
	inner join Monedas c
	  on a.Mcodigo = c.Mcodigo
	inner join TESdetallePago g  
      on a.TESSPid = g.TESSPid
	inner join  TESordenPago f
	  on f.TESOPid = g.TESOPid 
    inner join  CuentasBancos e
      on f.CBidPago = e.CBid	
where a.Ecodigo = #session.Ecodigo#
	and e.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">		 	
	and (	<!----- Cuando todavia existan detalles que no estan por liquidar: cantidadXliquidar < cantidadAnticipoD--->
				(
					select count(1)
					  from GEliquidacionAnts d
						inner join GEliquidacion e
						 on e.GELid 		= d.GELid
						and e.GELestado 	in (0,1,2,4,5)
					 where d.GEAid = a.GEAid
				) <
				(
					select count(1)
					  from GEanticipoDet f
					 where f.GEAid = a.GEAid
					   and f.GEADmonto - f.GEADutilizado - f.TESDPaprobadopendiente > 0
				) 
		)

<cfif #form.estadoAnti# neq 'ALL'>
   and GEAestado = #LvarEstado#
<cfelse>    
	and GEAestado in (#LvarEstado#)   
</cfif>     
   and coalesce(a.TESSPid,0) <> 0 
   and coalesce(a.CCHid,0) = 0 
     <cfif #form.estadoAnti# eq 1>  <!---si elegimos los vencidos, nos mostrara las liquidaciones menores a la fecha de hoy---->
       and 
	     case coalesce(a.GEAviatico,'0') when '1'   
	     then <cf_dbfunction name="dateadd" args="#rsDatosConf.CCHCdiasvencAntiViat#, GEAhasta">  
	     else
		 <cf_dbfunction name="dateadd" args="#rsDatosConf.CCHCdiasvencAnti#, GEAhasta"> 
	  end  <  <cf_dbfunction name="now">    
   </cfif>  
 </cfif>  
    order by  cuenta, FormaPago, FechaVencimiento, Beneficiario	
	
</cfquery>
	
   <style type="text/css">
		 .RLTtopline {
		  border-bottom-width: 1px;
		  border-bottom-style: solid;
		  border-bottom-color:#000000;
		  border-top-color: #000000;
		  border-top-width: 1px;
		  border-top-style: solid;
		  
		 } 
		</style>
	
<cfoutput>
	<table align="center" width="100%" border="0" summary="Reporte" cellpadding="0" cellspacing="0">
		<tr class="listaPar">
			<td align="center" valign="top" colspan="12" nowrap="nowrap"><strong>#rsEmpresa.Edescripcion#</strong></td>
		</tr>
		<tr class="listaPar">
			<td align="center" valign="top" colspan="12"><strong>Sistema de Gastos de Empleado</strong></td>
		</tr>
		<tr><td align="center" valign="top" colspan="12"><strong>Reporte de Anticipos</strong></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td  align="center" class="RLTtopline" bgcolor="CCCCCC" colspan="8" width="33%" align="center" valign="top" nowrap="nowrap" ><cfoutput><strong>Anticipos #LvarEstadoDesc#</strong></cfoutput></td>
		</tr>
		<tr>
			<td width="100%" colspan="8" align="center">
				<table width="100%" border="1">
					<tr>
					   <td align="left" valign="top"><strong>Num</strong></td>
					   <td align="left" valign="top"><strong>Forma de Pago</strong></td>
					   <td align="left" valign="top"><strong>Cuenta</strong></td>
					   <td align="left" valign="top"><strong>N° Anticipo</strong></td>
					   <td align="left" valign="top"><strong>N° Comision</strong></td>
					   <td align="left" valign="top"><strong>Descripción</strong></td>
					   <td align="left" valign="top"><strong>Beneficiario</strong></td>
					   <td align="left" valign="top"><strong>Monto</strong></td>
					   <td align="left" valign="top"><strong>Fecha Vencimiento</strong></td>
					   <td align="left" valign="top"><strong>Viático</strong></td>
					
						
					</tr>
					<cfset count = 1>
					<cfloop query="rsAnticiposLiq">
					       <tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
						   <td align="left" valign="top">#count#</td>
					       <td align="left" valign="top">#rsAnticiposLiq.FormaPago#</td>
						   <td align="left" valign="top">#rsAnticiposLiq.cuenta#</td>
						   <td align="left" valign="top">#rsAnticiposLiq.Anticipo#</td>
                           <cfif len(trim(#rsAnticiposLiq.Comision#))>
							   <td align="left" valign="top">#rsAnticiposLiq.Comision#</td>
                           <cfelse>
							   <td align="left" valign="top">&nbsp;</td>
                           </cfif>
						   <td align="left" valign="top">#rsAnticiposLiq.Descripcion#</td>
						   <td align="left" valign="top">#rsAnticiposLiq.Beneficiario#</td>
						   <td align="left" valign="top">#rsAnticiposLiq.Monto#-#rsAnticiposLiq.Moneda#</strong></td>
						   <td align="left" valign="top">#LSDateFormat(rsAnticiposLiq.FechaVencimiento,'DD-MM-YYYY')#</td>
						   <td align="left" valign="top">#rsAnticiposLiq.EsViatico#</td>
					</tr>
					<cfset count = count + 1>				
					</cfloop>
				</table>
			</td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap" colspan="2"></td>
		</tr>
		<tr><td align="center" nowrap="nowrap" colspan="12"><p>&nbsp;</p>
				  <p>***Fin de Linea***</p></td></tr>
	</table>
</cfoutput>





