<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfobject component="sif.Componentes.montoEnLetras" name="LvarObj">
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cfset max_lineas = 9>
<!---==Obtener el ID de la Orden de Compra==--->
<cfif isdefined("url.EOidorden") and len(trim(url.EOidorden)) and not isdefined("form.EOidorden")>
	<cfset form.EOidorden = url.EOidorden >
</cfif>
<cfif not isdefined("form.EOidorden") >
	<cfif isdefined("url.EOnumero") and len(trim(url.EOnumero))>
		<cfquery name="rsOrden" datasource="#session.DSN#">
			select EOidorden
			from EOrdenCM
			where Ecodigo =  #Session.Ecodigo# 
			and EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EOnumero#">
		</cfquery>
		<cfset form.EOidorden = rsOrden.EOidorden >
	</cfif>
</cfif>
<cfif not (isdefined("form.EOidorden") and len(trim(form.EOidorden)))>
	<cf_errorCode	code = "50272" msg = "No ha sido definida la Orden que desa imprimir.">
</cfif>
<!---===Estilos===--->
<cf_templatecss>
<style type="text/css">
	
	.LetraDetalle{
		font-size:9px;
		px;
	}
	.LetraEncab{
		font-size:10px;
		font-weight:bold;
	}	
	.LetraPeq{
		font-size:6px;
		font-weight:bold;					
		px;	
	}

	.visible{
	border:1;
	}
</style> 
<cfquery name="Empresa" datasource="asp">
		select Efax, Etelefono1,ts_rversion from Empresa where Ecodigo = #session.Ecodigo#
</cfquery>
<cfquery name="rsEmpresaLoc" datasource="#session.DSN#">
		select Mcodigo from Empresas where Ecodigo = #session.Ecodigo#
</cfquery>
<cfquery name="rsMonedaLocal" datasource="#session.DSN#">
		select Msimbolo, Mnombre from Monedas where Mcodigo = #rsEmpresaLoc.Mcodigo#
</cfquery>

<cfquery name="data" datasource="#session.DSN#">
	select rtrim(c.Edescripcion) as TituloEmpresa, 
	 f.SNidentificacion as CedulaJuridica,
	 coalesce(f.SNFax,'No disponible') as FaxProveedor, 
	 coalesce('#Empresa.Efax#','') as FaxEmpresa,
	 coalesce('#Empresa.Etelefono1#','') as TelEmpresa,
	 f.SNnumero,
	 (select min(SNCnombre) from SNContactos where Ecodigo = f.Ecodigo and SNcodigo = f.SNcodigo) as contacto, 
	 a.EOfecha as FechaOC, 
	 coalesce(a.EOFechaAplica, a.EOfecha) as  EOFechaAplica,
	 b.DOconsecutivo,
	 b.DOcantidad,
     b.DOcantSurtida,
     b.DOcantCancel,
	 b.DOdescripcion as DescripcionDetalle,
	 ' ' #_Cat# b.DOobservaciones as DOobservaciones,
	 ' ' #_Cat#b.DOalterna as DOalterna,	
	 #LvarOBJ_PrecioU.enSQL_AS("b.DOpreciou")#,
	 b.DOcontrolCantidad,
	 case when b.DOcontrolCantidad = 1 then b.DOtotal 
		else b.DOtotal-b.DOmontoCancelado end
	 as DOtotal,
	 (select Msimbolo from Monedas where Ecodigo = a.Ecodigo and Mcodigo = a.Mcodigo) as codMoneda,
	 (select Mnombre from Monedas where Ecodigo = a.Ecodigo and Mcodigo = a.Mcodigo) as nomMoneda,
	 a.Mcodigo,
	 a.EOnumero,  
	 a.EOtc, 
	 a.EOtotal + a.EOdesc - a.Impuesto as SubtotalOC,
	 a.EOdesc as DescuentoOC,
	 a.EOtotal - a.Impuesto as SubTotalConDescOC,
	 a.Impuesto as ImpuestoOC,
	 a.EOtotal as TotalOC, 
	 a.EOdiasEntrega,
	 coalesce(a.Observaciones,'') as DescripcionE,
	 a.EOidorden,
	 a.CMCid,
	 b.Icodigo,
     b.Aid,
     b.CMtipo,
	 a.EOImpresion, 
     f.SNdireccion as Direccion,
     f.SNnombre as NombreProveedor,
	 h.Ucodigo, 
	 b.DOfechareq as fechaRequerida,
	 b.DOfechaes as fechaest,
	 s.CMPnumero,
	 s.CMPdescripcion,	
	 s.CMPcodigoProceso,	
	 esc.ESnumero,
	 esc.EStotalest, 
	 mo.Msimbolo,
	 ctp.CMTPDescripcion,
     cf.CFdescripcion,
     a.Rcodigo,
     b.CFcuenta,
     coalesce(a.EOlugarentrega,'** No definido **') as EOlugarentrega,
     a.Observaciones,
	 a.Usucodigo,
	 a.UsucodigoAplica,
     cf.CFuresponsable,
	 cmf.CMFPdescripcion,
	 case a.EOhabiles when 0 then 'Naturales'
	 when 1 then 'Hábiles'
	 end as diasHabiles,
	 case coalesce(I.Iporcentaje,0.00) when 0.00 then 'S' else '&nbsp;' end  exento,
	 (select min(Coalesce(CMCnombre,'')) from CMCompradores where Ecodigo = a.Ecodigo and CMCid = a.CMCid) NombreComprador,
	 cpresup.CPformato,
     cmt.CMTodescripcion,
     cmt.CMTocodigo
		from EOrdenCM a 
		inner join DOrdenCM b
		  			 left join Almacen al <!--- Se pone un left por que el campo Alm_Aid acepta nulos --->
						on al.Aid  = b.Alm_Aid
					on a.Ecodigo = b.Ecodigo
					and a.EOidorden = b.EOidorden		
		left outer join CFinanciera cfinan
				on b.CFcuenta = cfinan.CFcuenta
			left outer join CPresupuesto cpresup
				on cfinan.CPcuenta = cpresup.CPcuenta
		left outer join CFuncional cf
		           on b.CFid = cf.CFid
        left outer join CMTipoorden cmt
		           on cmt.CMTocodigo = a.CMTocodigo           
		left outer join DCotizacionesCM r
					on b.DClinea = r.DClinea
		left outer join CMProcesoCompra s
					on r.CMPid = s.CMPid
		left outer join CMTipoProceso ctp
	                on s.CMTPid = ctp.CMTPid			
<!---		left outer join CMLineasProceso cmp
		            on s.CMPid = cmp.CMPid  --->
		left outer join ESolicitudCompraCM esc
		            on b.ESidsolicitud = esc.ESidsolicitud
		left outer join Monedas mo
		             on esc.Mcodigo = mo.Mcodigo
		inner join Empresas c 
					on a.Ecodigo = c.Ecodigo
		inner join SNegocios f
					on a.Ecodigo = f.Ecodigo
					and a.SNcodigo = f.SNcodigo
		inner join Unidades h
					on  b.Ecodigo = h.Ecodigo
					and b.Ucodigo = h.Ucodigo
		left outer join DSolicitudCompraCM g
					on  g.Ecodigo = b.Ecodigo
					and g.ESidsolicitud = b.ESidsolicitud 
					and g.DSlinea = b.DSlinea 
		left outer join Articulos j
				   on b.Aid=j.Aid
				   and b.Ecodigo=j.Ecodigo 
		left outer join Conceptos k
				   on b.Cid=k.Cid
				   and b.Ecodigo=k.Ecodigo 
		left outer join AClasificacion ac
				   on b.Ecodigo = ac.Ecodigo
				   and b.ACcodigo = ac.ACcodigo
				   and b.ACid = ac.ACid  
		left outer join ACategoria atl
				   on b.Ecodigo = atl.Ecodigo
				   and b.ACcodigo = atl.ACcodigo
		left outer join CMFormasPago cmf
				   on a.CMFPid = cmf.CMFPid
		inner join Impuestos I
				   on b.Ecodigo = I.Ecodigo
				   and b.Icodigo = I.Icodigo
		where a.Ecodigo =  #Session.Ecodigo# 
   		  and a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
		  and (case when b.DOcontrolCantidad = 1
								then case when coalesce(b.DOcantcancel,0) =  b.DOcantidad then 0 else 1 end
						else
								case when coalesce(DOmontoCancelado,0)  = b.DOtotal then 0 else 1 end 
						end) = 1
		order by b.DOdescripcion, b.DOconsecutivo 
</cfquery>
<cfif data.recordCount EQ 0>
	<cf_errorCode	code = "50273" msg = "No se encontraron datos para el detalle de la Orden de Compra">
</cfif>

<cfset TotalOrdenCompra=0>
<cfloop query="data">
	<cfset TotalOrdenCompra= TotalOrdenCompra + (#data.DOpreciou# * #data.DOcantidad#)>
</cfloop>
<cfset LvarFechaOC = createdate(year(data.EOFechaAplica),month(data.EOFechaAplica), day(data.EOFechaAplica))>

<cfquery name="rsTipoCambio" datasource="#session.DSN#">
					select tc.Mcodigo, tc.TCcompra, tc.TCventa
					from Htipocambio tc
					where tc.Ecodigo = #session.Ecodigo#
						and  Mcodigo = #data.Mcodigo#
						and tc.Hfecha <= #LvarFechaOC#
						and tc.Hfechah > #LvarFechaOC#
			
</cfquery>
  <cfset LvarMontoMonedaLocal = #TotalOrdenCompra# * data.EOtc>

<cfif isdefined("data.Rcodigo") and len(trim(#data.Rcodigo#))>
  <cfquery name="rsRetencion" datasource="#session.dsn#">
   select Rcodigo #_Cat#' '#_Cat# Rdescripcion as Rdescripcion,
   Rporcentaje 
    from Retenciones
   where Rcodigo = '#data.Rcodigo#'   
  </cfquery>
</cfif> 
<cfif isdefined("TotalOrdenCompra") and  len(trim(#TotalOrdenCompra#)) and  isdefined("rsRetencion.Rporcentaje") and len(trim(#rsRetencion.Rporcentaje#))>
<cfset MontoRetencion = (#TotalOrdenCompra# *(rsRetencion.Rporcentaje/100))>
</cfif>


<cfif isdefined("data.CFcuenta") and len(trim(#data.CFcuenta#))>
  <cfquery name="rsCFcuenta" datasource="#session.dsn#">
     select CPcuenta from CFinanciera        
      where CFcuenta=<cfqueryparam cfsqltype="cf_sql_numeric" value="#data.CFcuenta#">
  </cfquery>
  <cfif len(trim(#rsCFcuenta.cpcuenta#)) gt 0>
      <cfquery name="rsCPformato" datasource="#session.dsn#">
          Select CPformato from  CPresupuesto where CPcuenta=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCFcuenta.cpcuenta#">
      </cfquery>
  </cfif>
</cfif> 
	 <cfinvoke component="sif.Componentes.CFutils" method="ResponsableCF_usuario" returnvariable="LvarUsuResponsable">
			<cfinvokeargument name="Usucodigo" 	value="#data.Usucodigo#"/>
	</cfinvoke>  

    <cfquery name="rsResponsableCF" datasource="#session.dsn#" maxrows="1">
		select 
		      dp.Pnombre #_Cat#' '#_Cat# dp.Papellido1 #_Cat#' '#_Cat# dp.Papellido2 as ResponsableProv,
		      cf.CFdescripcion
			from CFuncional  cf
		inner join Usuario u
		    on cf.CFuresponsable = u.Usucodigo
		inner join  DatosPersonales dp 
		    on u.datos_personales = dp.datos_personales
		  where  u.Usucodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarUsuResponsable#">	   
	</cfquery>
		
	<cfquery name="rsUsuarioCF" datasource="#session.dsn#">
		select 		   
		   Pnombre #_Cat#' '#_Cat# Papellido1 #_Cat#' '#_Cat# Papellido2 as ResponsableProv
			from  Usuario u		    
		inner join  DatosPersonales dp 
		    on u.datos_personales = dp.datos_personales
		  where  u.Usucodigo = #data.Usucodigo#
	</cfquery>
   
<cfquery name="rsAutoriza" datasource="#session.DSN#">
	select count(1) as cantidad
	from CMAutorizaOrdenes
	where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.EOidorden#">
	  and Ecodigo =  #Session.Ecodigo#  
</cfquery>

<cfif rsAutoriza.cantidad gt 0 >
	<!---
		CMAestado (Estado por cada comprador): 
			0 = En Proceso, 1 = Rechazado, 2 = Aprobado
		CMAestadoproceso (Estado general de la orden de Compra): 
			0 = En Proceso, 5 = Rechazado con posibilidad de revivir, 10 = Rechazado sin opcion de revivir, 15 = Aprobado
		Nivel (Jerarquía de Compradores, el último en autorizar debe ser el que tiene el MAYOR nivel)
	--->

	<!--- ME DICE EL ULTIMO COMPRADOR QUE AUTORIZO O RECHAZO LA ORDEN --->
	<cfquery name="dataComprador" datasource="#session.DSN#" maxrows="1">
		select CMAid, CMCid, Nivel, coalesce(CMAestadoproceso,0) as CMAestadoproceso
		from CMAutorizaOrdenes 
		where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.EOidorden#">
		and CMAestado in (1,2)
  	    and Ecodigo =  #Session.Ecodigo#  
		and CMAestadoproceso <> 10
		and Nivel = ( select max(Nivel)
					  from CMAutorizaOrdenes 
					  where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.EOidorden#">
						and CMAestadoproceso <> 10
						and CMAestado in (1,2) )
	</cfquery>
	<cfif dataComprador.recordCount gt 0 and dataComprador.CMAestadoproceso eq 15>
		<cfquery name="rsComprador" datasource="#session.dsn#" >
			select CMCnombre 
			from CMCompradores 
			where CMCid = #dataComprador.CMCid#
			and Ecodigo =  #Session.Ecodigo#  
		</cfquery>
		<cfset NombreAprobador = rsComprador.CMCnombre>
	</cfif>
<cfelse>
	<cfset NombreAprobador= #data.NombreComprador#>
</cfif>
 <cfoutput>
	 <cfset contador    = 0>
     <cfset UltimoReg   = ''>
         <cfloop query="data">	
			<cfset contador = contador+1>				
			<cfif contador EQ 1>
				<cfset fnColcarEncabezado()>
				<cfset fnColocarEDetalle()>
			</cfif>		
                <cfif  data.CMtipo neq 'A'>
                  <cfset fnColocarDDetalle()>                           
                <cfelseif UltimoReg neq #data.Aid#> 
                   <cfset fnColocarDDetalleArt()>                    	
                <cfelseif UltimoReg eq #data.Aid#>
                   <cfif contador NEQ 1>
                      <cfset contador = contador-1>
                    </cfif>    
                </cfif>    
			<cfif (isdefined("Url.imprimir") and contador eq max_lineas)>
				<cfset fnCambioPagina()>
				<cfset contador= 0>	
			</cfif>
		</cfloop>
			<!---	<cfset FinLineasDetalle()>--->
				<cfset fnColocarResumen()>
                <cfif #trim(data.CMTocodigo)# eq "CT1" OR #trim(data.CMTocodigo)# eq "CT2">
                <cfelse>
					<cfset fnColocarPiePagina()>             
                </cfif>   
	</cfoutput>
<!---Verificar el estado de la impresion de la orden actualmente
	'I' = Impresa la primera vez 
	' ' = Nunca se ha impreso
	'R' = Reimpresion ----->
<cfquery name="rsEstadoImpresion" datasource="#session.DSN#">
	select ltrim(rtrim(EOImpresion)) as EOImpresion from EOrdenCM 
	where Ecodigo =  #Session.Ecodigo# 
		and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
		and Ecodigo =  #Session.Ecodigo#  
</cfquery>
<!----ACTUALIZAR EL ESTADO DE LA IMPRESION DE LA OC----->
<cfif isdefined("url.Imprimir") and len(trim(rsEstadoImpresion.EOImpresion)) EQ 0><!----Si la OC todavia no ha sido impresa por primera vez---->
	<cfquery datasource="#session.DSN#">
		update EOrdenCM
		set EOImpresion='I'
		where Ecodigo =  #Session.Ecodigo# 
			and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
			and Ecodigo =  #Session.Ecodigo#  
	</cfquery>	
<cfelseif isdefined("url.Imprimir")>
	<cfquery datasource="#session.DSN#">
		update EOrdenCM
		set EOImpresion='R'
		where Ecodigo =  #Session.Ecodigo# 
			and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
	</cfquery>
</cfif>


<cffunction name="fnColcarEncabezado" output="true">
<!--- <table width="100%" cellpadding="1" cellspacing="0" align="center" border="1">--->      
	<table width="100%" cellpadding="1" cellspacing="0" align="center" border="0">		
		    <tr>
			 <td width="33%">
             	<cfinvoke 
					 component="sif.Componentes.DButils"
					 method="toTimeStamp"
					 returnvariable="tsurl" arTimeStamp="#Empresa.ts_rversion#"> 
             	</cfinvoke>
				<cfoutput> 
					<img src="/cfmx/home/public/logo_empresa.cfm?EcodigoSDC=#session.EcodigoSDC#&amp;ts=#tsurl#" class="iconoEmpresa" alt="logo" border="0" height="100" width="150" />
				</cfoutput>
            </td>
			<td align="center" width="33%" nowrap="nowrap"><strong><font size="18">
				<cfif #trim(data.CMTocodigo)# eq "CT1" OR #trim(data.CMTocodigo)# eq "CT2">
                	CONTRATO N° ***#data.EOnumero#***
                <br />  #data.CMTodescripcion#
                <cfelse>
                	ORDEN DE COMPRA  N° ***#data.EOnumero#***
                </cfif>
            	</font></strong>
            </td>
			<td valign="bottom" width="33%" align="right">&nbsp;</td>
	       </tr>
	</table>
    </tr>
	   <tr>	    
				<table width="100%" border="1" align="center" cellpadding="1" cellspacing="0">
					<tr>
						<td width="15%" nowrap class="LetraEncab">1.Fecha</td>
						<td width="42%" nowrap class="LetraEncab">2.Nombre del proveedor </td>
						<td width="43%"  nowrap class="LetraEncab">3.Número de cédula jurídica o de identidad </td>						
					</tr>
					<tr>
						<td nowrap class="LetraDetalle">#LSDateFormat(data.EOFechaAplica,'dd/mm/yyyy')#</td>
						<td nowrap class="LetraDetalle">#data.NombreProveedor#</td>
						<td nowrap class="LetraDetalle">#data.CedulaJuridica#</td>						
					</tr>
					<tr>
						<td colspan="2" width="60%" nowrap class="LetraEncab">4.Número y nombre del proceso de contratación </td>
						<td width="40%" nowrap class="LetraEncab">5.Número y monto solicitud bienes y servicios </td>												
					</tr>
					<tr>
						<td  class="LetraDetalle" colspan="2">#data.CMPcodigoProceso#( #data.CMPnumero# - #data.CMPdescripcion#)</td>
						
						<td nowrap class="LetraDetalle"> #data.esnumero# - #data.Msimbolo##LSNumberFormat(data.estotalest,',9.00')#</td>
					</tr>
					<tr>
						<td width="60%" nowrap class="LetraEncab" colspan="2">6.Plazo de entrega o de ejecución</td>
						<td width="40%" nowrap class="LetraEncab">7.Trámite de compra</td>												
					</tr>
					<tr>
						<cfif len(trim(#data.EOdiasEntrega#)) gt 0>
    						<td nowrap class="LetraDetalle" colspan="2">#data.EOdiasEntrega# d&iacute;as #data.diasHabiles#</td>
	    					<td nowrap class="LetraDetalle">#data.CMTPDescripcion#</td>
						<cfelse>							
							<td nowrap class="LetraDetalle" colspan="2"> **No Definidos** </td>			
							<td nowrap class="LetraDetalle">#data.CMTPDescripcion#</td>			
						</cfif>	
					</tr>
					<tr>
						<td colspan="2" width="75%" nowrap class="LetraEncab">8.Lugar de entrega o de ejecución </td>
						<td width="25%"  nowrap class="LetraEncab">9.Retención ISR </td>						
					</tr>
					<tr>
						<td nowrap colspan="2" class="LetraDetalle">#data.EOlugarentrega#</td>
						<cfif isdefined("data.Rcodigo") and len(trim(#data.Rcodigo#))>
							<td nowrap class="LetraDetalle">#rsRetencion.Rdescripcion# - #rsMonedaLocal.Msimbolo# #LSNumberFormat(MontoRetencion * data.EOtc,',9.00')#</td>						
						<cfelse>							
							<td nowrap class="LetraDetalle"> [**No Definida** - 0.00] </td>						
						</cfif>
					</tr>
				</table>		 
<!---</table>--->
</cffunction>

<cffunction name="fnColocarEDetalle" output="true">
	<table width="100%" border="1" bordercolor="000000" cellspacing="0" align="center">
	<tr class="titulolistas">
		<td width="5%" class="LetraEncab"  align="center">10.Cantidad</td>
		<td width="56%" class="LetraEncab"  align="center" colspan="4">11.Descripción</td>
		<td width="15%" class="LetraEncab" align="center">12.Unidad ejecutora o fiscalizadora</td>
		<td width="14%" class="LetraEncab" align="center">13.Partida Presupuestaria</td>
		<td width="5%" class="LetraEncab" align="center">14.Precio Unitario</td>
		<td width="5%" class="LetraEncab"  align="center">15.Monto por Línea</td>
	</tr>
</cffunction>
<cffunction name="fnColocarDDetalle" output="true">	
     <tr>
		<td nowrap class="LetraDetalle">#LSNumberFormat(data.DOcantidad,',9.00')# #data.Ucodigo#</td>
		<td class="LetraDetalle" colspan="4">#data.DescripcionDetalle# <br /> #data.DOobservaciones# <br />#data.DOalterna#</td>
		<td nowrap class="LetraDetalle">#data.CFdescripcion#</td>
		<td nowrap class="LetraDetalle" align="right">#data.CPFormato#</td>
		<td nowrap class="LetraDetalle" align="right">#data.codMoneda##LvarOBJ_PrecioU.enCF_RPT(data.DOpreciou)#</td>
		<td nowrap class="LetraDetalle" align="center">#data.codMoneda##LSNumberFormat(data.DOtotal,',9.00')#</td>
	</tr>
</cffunction>
<!----Agrupa los articulos q son del mismo tipo------>
<cffunction name="fnColocarDDetalleArt" output="true">	
        <cfquery name="rsArtic" dbtype="query">
          select Aid, sum(DOcantidad) as DOcantidad, sum(DOtotal) as DOtotal
           from data
            where CMtipo = 'A'
            and Aid = #data.Aid#
            group by Aid
        </cfquery>  
        <cfif rsArtic.recordcount gt 0>
         <cfquery name="rsDatosArtic" dbtype="query">
          select Ucodigo,DescripcionDetalle, DOobservaciones, DOalterna, CFdescripcion,codMoneda,DOpreciou, CPFormato
           from data
            where Aid = #rsArtic.Aid#          
        </cfquery>     
        </cfif>
	
        <tr>
            <td nowrap class="LetraDetalle">#LSNumberFormat(rsArtic.DOcantidad,',9.00')# #rsDatosArtic.Ucodigo#</td>
            <td class="LetraDetalle" colspan="4">#rsDatosArtic.DescripcionDetalle# <br /> #rsDatosArtic.DOobservaciones# <br />#rsDatosArtic.DOalterna#</td>
            <td nowrap class="LetraDetalle">CONAVI</td>
            <td nowrap class="LetraDetalle" align="right">Varios</td>
            <td nowrap class="LetraDetalle" align="right">#rsDatosArtic.codMoneda##LvarOBJ_PrecioU.enCF_RPT(rsDatosArtic.DOpreciou)#</td>
            <td nowrap class="LetraDetalle" align="center">#rsDatosArtic.codMoneda##LSNumberFormat(rsArtic.DOtotal,',9.00')#</td>
        </tr>		
         <cfset UltimoReg   = #data.Aid#>  
</cffunction>   
    
<cffunction name="fnCambioPagina" output="true">
     </table>
	<BR style="page-break-after:always;">	
</cffunction>
<cffunction name="fnColocarResumen" output="true">
  	 <tr>
	  <td colspan="9">
	     <table width="100%" align="center" border="1" cellpadding="0" cellspacing="0">
			<tr>
			   <td class="LetraEncab" width="70%">16.Monto total en letras</td>
			     <td class="LetraEncab"  width="20%">17.Monto total en números</td>
			    <td class="LetraEncab"  width="10%">18.Fecha tipo cambio</td>
			</tr>
			<tr>
			    <cfset LvarMontoLetras = #LvarObj.fnMontoEnLetras(#TotalOrdenCompra#)#>
				<cfset fin= len(ltrim(rtrim(LvarMontoLetras)))-10>
				<cfset LvarMontoInicio = mid(LvarMontoLetras,1,fin)>
				
				<cfset LvarMontoFin = mid(LvarMontoLetras,fin,len(ltrim(rtrim(LvarMontoLetras))))>
				
			  <td><strong>#LvarMontoInicio# #data.nomMoneda# #LvarMontoFin#</strong></td>
			  
			  <td><strong>#data.codMoneda##LSNumberFormat(TotalOrdenCompra,',9.00')#</strong></td>
			  <td><strong>#LsDateFormat(data.EOFechaAplica,'dd-mm-YYYY')#</strong></td>
			</tr>
			<cfif rsEmpresaLoc.Mcodigo neq data.Mcodigo>
			<tr>
				 <td class="LetraEncab">Monto en colones
				 al tipo de cambio (#rsTipoCambio.TCventa#) </td>
				 <td colspan="2"><strong>#rsMonedaLocal.Msimbolo##LsNumberFormat(TotalOrdenCompra * rsTipoCambio.TCventa,',9.00')#</strong> </td>
			</tr>						
			<tr>
				 <td>Se establece el siguiente monto para financiar el diferencial cambiario de acuerdo a la politica monetaria del gobierno.
     			 </td>
				 <td colspan="2">
				   <strong> #rsMonedaLocal.Msimbolo# #LsNumberFormat(LvarMontoMonedaLocal - (TotalOrdenCompra * rsTipoCambio.TCventa),',9.00')#</strong>
				 </td>
			</tr>		
			
			<tr>
			   <td class="LetraEncab" width="70%">Monto en letras Moneda local</td>
			     <td class="LetraEncab" colspan="2"  width="20%">Monto en números moneda local</td>			    
			</tr>
			<tr>
			  <td><strong>#LvarObj.fnMontoEnLetras(LvarMontoMonedaLocal)#</strong></td>
			  <td colspan="2"><strong> #rsMonedaLocal.Msimbolo##LSNumberFormat(LvarMontoMonedaLocal,',9.00')#</strong></td>
			  
			</tr>
			</cfif>
			<tr>
			  <td colspan="3" class="LetraEncab">
			   19.Forma de pago
			  </td> 			  
			</tr> 
			<tr>
			   <td colspan="3">			   
				   #data.CMFPdescripcion#
			   </td> 
			</tr>
			<tr>
			  <td colspan="3" class="LetraEncab">
			   20.Observaciones
			  </td> 			  
			</tr> 
			<tr>
			   <td colspan="3">			   
			    &nbsp; #data.Observaciones#
			  </td> 
			</tr>									 
	     </table>
	</td>
	</tr>	
	</table>	
</cffunction>
<cffunction name="fnColocarPiePagina" output="true">
			<!---=========Firmas========--->	
	<table width="100%" align="center"cellpadding="0" cellspacing="0" border="1">
		<tr>
			<td class="LetraEncab">21. Nombre del encargado de realizar en documento</td>
			<td class="LetraEncab">21.1 Firma Encargado de elaborar documento</td>
		</tr>
		<tr>
			<td height="30" align="left">#rsUsuarioCF.ResponsableProv#</td>				
			<td height="30" align="center"><div align="center">_______________________________________</div></td>				
		</tr>				
		
		<tr>
			<td class="LetraEncab">22. Nombre del jefe de #rsResponsableCF.CFDescripcion#</td>
			<td class="LetraEncab">22.1 Firma aprobación, #rsResponsableCF.CFDescripcion# </td>
		</tr>				
		<tr>
			<td height="30" align="left">#rsResponsableCF.ResponsableProv#</td>
			<td height="30" align="center"><div align="center">_______________________________________</div></td>
		</tr>					
   </table>
	<table width="100%" align="left">
	<tr><td width="519">&nbsp;</td>
	</tr><tr><td>&nbsp;</td></tr>
		<cfif (len(trim(data.EOImpresion)) EQ 0) or (isdefined("url.primeravez"))>
			<tr>  <td width="667" class=""><div align="left" class="LetraEncab">Original #rsResponsableCF.CFDescripcion#</div></td>
			</tr>	
			<tr> <td class=""><div align="left" class="LetraEncab">Copia 1: Ejecucion Presupuestaria.</div></td></tr>	
			<tr> <td class=""><div align="left" class="LetraEncab">Copia 2: Archivo de Ejecucion Presupuestaria.</div></td></tr>	
			<tr> <td class=""><div align="left" class="LetraEncab">Expediente de Contratacion.</div></td></tr>	
			
		<cfelseif len(trim(data.EOImpresion))>			
			<tr> <td class=""><div align="left" class="LetraEncab">Original #rsResponsableCF.CFDescripcion#.</div></td></tr>
			<tr> <td class=""><div align="left" class="LetraEncab">Copia 1: Ejecucion Presupuestaria.</div></td></tr>
			<tr> <td class=""><div align="left" class="LetraEncab">Copia 2: Archivo de Ejecucion Presupuestaria.</div></td></tr>
			<tr> <td class=""><div align="left" class="LetraEncab">Expediente de Contratacion.</div></td></tr>
			<tr> <td class=""><div align="left" class="LetraEncab">Copia de Original No Negociable.</div></td></tr>
			
		</cfif>	
 </table>

</cffunction>


