<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Archivo" default="GestionEmpleados" returnvariable="LB_Archivo" 
xmlfile ="ReporteAnti_form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Titulo" default="Consultas Gestion Empleados" returnvariable="LB_Titulo" 
xmlfile ="ReporteAnti_form.xml"/>

<cf_templatecss>
<cf_htmlReportsHeaders 
	irA="GEReportesAnti.cfm"
	FileName="#LB_Archivo#.xls"
	title="#LB_Titulo#">

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
     <cfelseif #form.estadoAnti# eq 4>
	 	<cfset LvarEstado = 7>
		<cfset LvarEstadoDesc = "Cancelados">
	 </cfif>
<cfelse>
	<cfset LvarEstado = '1,2,3,4,6,7'>
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
		 (select GECnumero from GEcomision where GECid = a.GECid) as Comision,
        
<!---        (select TOP 1 he.ECfechaaplica 
          from TESdetallePago g
          inner join HEContables he
   		  on g.TESDPdocumentoOri = he.Edocbase 
--->          
        <!---  (select TOP 1
                case ISNULL(ec.ECfechacreacion,'')
                when '' then he.ECfechaaplica
                else ec.ECfechacreacion
                end
            from TESdetallePago g
            inner join HDContables he          
            on g.TESDPdocumentoOri = he.Ddocumento
            left join DContables ec
            on g.TESDPidDocumento = ec.IDcontable   
          where a.TESSPid = g.TESSPid) as fechaAplic,--->
          
<!---        (select TOP 1 convert(varchar(5),he.Cconcepto)+'-'+convert(varchar(5),he.Edocumento) 
        from TESdetallePago g
         inner join HEContables he
   		 on g.TESDPdocumentoOri = he.Edocbase  
--->        
		<!---(select TOP 1 
        case ISNULL(ec.ECfechacreacion,'')
            when '' then convert(varchar(5),he.Cconcepto)+'-'+convert(varchar(5),he.Edocumento)
            else convert(varchar(5),ec.Cconcepto)+'-'+convert(varchar(5),ec.Edocumento)
        end
        from TESdetallePago g
        inner join HEContables he
            on g.TESDPidDocumento = he.IDcontable 
        left join EContables ec
            on g.TESDPidDocumento = ec.IDcontable  
        where a.TESSPid = g.TESSPid) as poliza --->
		fechaFiltro = case when a.TESSPid is not null then
			convert(varchar(10),isnull((select top 1 ec.Efecha
					 from TESdetallePago g 
					 inner join DContables dc on g.TESDPdocumentoOri = dc.Ddocumento 
					 inner join EContables ec on ec.IDcontable = dc.IDcontable
					 where a.TESSPid = g.TESSPid),
					 (select top 1 he.Efecha  
					  from TESdetallePago g 
					  inner join HDContables hd on g.TESDPdocumentoOri = hd.Ddocumento 
					  inner join HEContables he on he.IDcontable = hd.IDcontable
					  where a.TESSPid = g.TESSPid)),103)
		else
        
				convert(varchar(10),isnull((select top 1 ec.Efecha
					 from GEanticipo g
					 inner join GEcomision c on g.GECid = c.GECid
					 inner join EContables ec on ec.Edocbase = convert(varchar(50),GEAnumero) + ' - ' +  convert(varchar(50),GECnumero)
					 where a.GEAid = g.GEAid),
					 (select top 1 he.Efecha
					 from GEanticipo g
					 inner join GEcomision c on g.GECid = c.GECid
					 inner join HEContables he on he.Edocbase = convert(varchar(50),GEAnumero) + ' - ' +  convert(varchar(50),GECnumero)
					 where a.GEAid = g.GEAid)),103)
			end,
			fechaAplic = 
			case when a.TESSPid is not null then 
				convert(varchar(10),isnull((select top 1 ec.Efecha
					 from TESdetallePago g 
					 inner join DContables dc on g.TESDPdocumentoOri = dc.Ddocumento 
					 inner join EContables ec on ec.IDcontable = dc.IDcontable
					 where a.TESSPid = g.TESSPid),
					 (select top 1 he.Efecha  
					  from TESdetallePago g 
					  inner join HDContables hd on g.TESDPdocumentoOri = hd.Ddocumento 
					  inner join HEContables he on he.IDcontable = hd.IDcontable
					  where a.TESSPid = g.TESSPid                      
                      )),103)
			else
		 		convert(varchar(10),isnull((select top 1 ec.Efecha
					 from GEanticipo g
					 inner join GEcomision c on g.GECid = c.GECid
					 inner join EContables ec on ec.Edocbase = convert(varchar(50),GEAnumero) + ' - ' +  convert(varchar(50),GECnumero)
					 where a.GEAid = g.GEAid),
					 (select top 1 he.Efecha  
					 from GEanticipo g
					 inner join GEcomision c on g.GECid = c.GECid
					 inner join HEContables he on he.Edocbase = convert(varchar(50),GEAnumero) + ' - ' +  convert(varchar(50),GECnumero)
					 where a.GEAid = g.GEAid)),103)
			end ,	  
        
         poliza = isnull((select top 1 convert(varchar(5),dc.Cconcepto)+'-'+convert(varchar(5),dc.Edocumento)
					 from TESdetallePago g
					inner join DContables dc on g.TESDPdocumentoOri = dc.Ddocumento where a.TESSPid = g.TESSPid),
					(select TOP 1 convert(varchar(5),he.Cconcepto)+'-'+convert(varchar(5),he.Edocumento)
					from TESdetallePago g 
					inner join HDContables he on g.TESDPdocumentoOri = he.Ddocumento where a.TESSPid = g.TESSPid))

        
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
					and e.GELestado 	in (0,1,2,4,5,7)
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
  		(select GECnumero from GEcomision where GECid = a.GECid) as Comision,
        
		
		fechaFiltro = convert(varchar(10),isnull((select top 1 ec.Efecha
					 from TESdetallePago g 
					 inner join DContables dc on g.TESDPdocumentoOri = dc.Ddocumento 
					 inner join EContables ec on ec.IDcontable = dc.IDcontable
					 where a.TESSPid = g.TESSPid),
					 (select top 1 he.Efecha  
					  from TESdetallePago g 
					  inner join HDContables hd on g.TESDPdocumentoOri = hd.Ddocumento 
					  inner join HEContables he on he.IDcontable = hd.IDcontable
					  where a.TESSPid = g.TESSPid)),103),
		fechaAplic = convert (varchar(10),isnull((select top 1 ec.Efecha
					 from TESdetallePago g 
					 inner join DContables dc on g.TESDPdocumentoOri = dc.Ddocumento 
					 inner join EContables ec on ec.IDcontable = dc.IDcontable
					 where a.TESSPid = g.TESSPid),
					 (select top 1 he.Efecha  
					  from TESdetallePago g 
					  inner join HDContables hd on g.TESDPdocumentoOri = hd.Ddocumento 
					  inner join HEContables he on he.IDcontable = hd.IDcontable
					  where a.TESSPid = g.TESSPid
                      )),103),
        
         poliza = isnull((select top 1 convert(varchar(5),dc.Cconcepto)+'-'+convert(varchar(5),dc.Edocumento)
					 from TESdetallePago g
					inner join DContables dc on g.TESDPdocumentoOri = dc.Ddocumento where a.TESSPid = g.TESSPid),
					(select TOP 1 convert(varchar(5),he.Cconcepto)+'-'+convert(varchar(5),he.Edocumento)
					from TESdetallePago g 
					inner join HDContables he on g.TESDPdocumentoOri = he.Ddocumento where a.TESSPid = g.TESSPid))

          
from GEanticipo a
	inner join TESbeneficiario b
	  on a.TESBid = b.TESBid
	inner join Monedas c
	  on a.Mcodigo = c.Mcodigo
	inner join TESdetallePago g  
      on a.TESSPid = g.TESSPid
	left join  TESordenPago f
	  on f.TESOPid = g.TESOPid 
    left join  CuentasBancos e
      on f.CBidPago = e.CBid and e.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">		 
where a.Ecodigo = #session.Ecodigo#		
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
			<td align="center" valign="top" colspan="12"><strong><cf_translate key=LB_SistGastoEmp>Sistema de Gastos de Empleado</cf_translate></strong></td>
		</tr>
		<tr><td align="center" valign="top" colspan="12"><strong><cf_translate key=LB_RepteAnts>Reporte de Anticipos</cf_translate></strong></td>
		</tr>
       	<tr><td align="center" valign="top" colspan="12"><strong><cf_translate key=LB_Del>Del</cf_translate> #form.desde# <cf_translate key=LB_Al>al</cf_translate> #form.hasta#</strong></td>
		</tr>

		<tr><td>&nbsp;</td></tr>
		<tr>
			<td  align="center" class="RLTtopline" bgcolor="CCCCCC" colspan="8" width="33%" align="center" valign="top" nowrap="nowrap" ><cfoutput><strong><cf_translate key=LB_Anticipo>Anticipos</cf_translate> #LvarEstadoDesc#</strong></cfoutput></td>
		</tr>
		<tr>
			<td width="100%" colspan="8" align="center">
				<table width="100%" border="1">
					<tr>
					   <td align="left" valign="top"><strong>Num</strong></td>
					   <td align="left" valign="top"><strong><cf_translate key=LB_FormaPago>Forma de Pago</cf_translate></strong></td>
					   <td align="left" valign="top"><strong><cf_translate key=LB_Cuenta>Cuenta</cf_translate></strong></td>
					   <td align="left" valign="top"><strong>N° <cf_translate key=LB_Anticipo>Anticipo</cf_translate></strong></td>
					   <td align="left" valign="top"><strong>N° <cf_translate key=LB_Comision>Comision</cf_translate></strong></td>
					   <td align="left" valign="top"><strong><cf_translate key=LB_Descripcion>Descripción</cf_translate></strong></td>
					   <td align="left" valign="top"><strong><cf_translate key=LB_Beneficiario>Beneficiario</cf_translate></strong></td>
					   <td align="left" valign="top"><strong><cf_translate key=LB_Monto>Monto</cf_translate></strong></td>
                       <td align="left" valign="top"><strong><cf_translate key=LB_FechaEntregaAnticipo>Fecha Entrega Anticipo</cf_translate></strong></td>
					   <td align="left" valign="top"><strong><cf_translate key=LB_FechaVencimiento>Fecha Vencimiento</cf_translate></strong></td>
					   <td align="left" valign="top"><strong><cf_translate key=LB_Viatico>Viático</cf_translate></strong></td>
					   <td align="left" valign="top"><strong><cf_translate key=LB_PolizaAnticipo>Póliza Anticipo</cf_translate></strong></td>
					</tr>
					<cfset count = 1>
                
                			<cfset desde = "#LSDateFormat(form.desde,'DD/MM/YYYY')#">
							<cfset hasta = "#LSDateFormat(form.hasta,'DD/MM/YYYY')#">
                            <cfset fechaAplic = "#LSDateFormat(rsAnticiposLiq.fechaAplic,'DD/MM/YYYY')#">

					<cfquery name="rsFiltro" dbtype="query" >
						select * from rsAnticiposLiq
                        where fechaAplic >=
                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desde#"> 
                         and  fechaAplic <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hasta#">
                    </cfquery>

					<cfloop query="rsFiltro">

 
                            	<tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
	                            <td align="left" valign="top">#count#</td>
    	                        <td align="left" valign="top">#rsFiltro.FormaPago#</td>
        	                    <td align="left" valign="top">#rsFiltro.cuenta#</td>
            	                <td align="left" valign="top">#rsFiltro.Anticipo#</td>
                	           <cfif len(trim(#rsFiltro.Comision#))>
	   	                       		<td align="left" valign="top">#rsFiltro.Comision#</td>
        	                   <cfelse>
            	                   <td align="left" valign="top">&nbsp;</td>
                	           </cfif>
                    	       <td align="left" valign="top">#rsFiltro.Descripcion#</td>
                       	       <td align="left" valign="top">#rsFiltro.Beneficiario#</td>
                           	   <td align="left" valign="top">#rsFiltro.Monto#-#rsFiltro.Moneda#</td>
	                      	   <td align="left" valign="top">#LSDateFormat(rsFiltro.fechaAplic,'DD-MM-YYYY')#</td>
    	                       <td align="left" valign="top">#LSDateFormat(rsFiltro.FechaVencimiento,'DD-MM-YYYY')#</td>
        	                   <td align="left" valign="top">#rsFiltro.EsViatico#</td>
            	               <td align="left" valign="top">#rsFiltro.poliza#</td>                           
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
				  <p>***<cf_translate key=LB_FinLinea>Fin de Linea</cf_translate>***</p></td></tr>
	</table>
</cfoutput>





