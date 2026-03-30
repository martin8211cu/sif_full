<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cfobject component="sif.Componentes.montoEnLetras" name="LvarObj">
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
		font-size:9;
		px;
	}
	.LetraEncab{
		font-size:10px;
		font-weight:bold;
	}
	.visible{
	border:1;
	}
.style3 {
	font-size: 8px;
	font-weight: bold;
}
.style4 {
	font-size: 6px;
}
</style> 
<cfquery name="Empresa" datasource="asp">
		select Efax,Elogo, Etelefono1,ts_rversion from Empresa where Ecodigo = #session.Ecodigo#
</cfquery>
<cfquery name="data" datasource="#session.DSN#">
	select 
	 rtrim(c.Edescripcion) as TituloEmpresa, 
	 f.SNidentificacion as CedulaJuridica,
	 coalesce(f.SNFax,'No disponible') as FaxProveedor, 
	 coalesce('#Empresa.Efax#','') as FaxEmpresa,
	 coalesce('#Empresa.Etelefono1#','') as TelEmpresa,
	 f.SNnumero,
	 coalesce(( select  cc.atencion
                  from SNegocios aa 			    
				inner join  DireccionesSIF cc
					 on cc.id_direccion = aa.id_direccion 
				 where aa.SNcodigo = a.SNcodigo and
                  aa.SNcodigo = a.SNcodigo
                  and  aa.Ecodigo = #session.Ecodigo#      				
               ),f.SNnombre) as contacto, 
	 a.EOfecha as FechaOC, 
	 b.DOconsecutivo,
	 b.DOcantidad,	 
     b.DOdescripcion #_Cat#  case when LEN(j.Acodalterno) > 1 then ' -' #_Cat# j.Acodalterno  else ' ' end #_Cat#
                                           case when LEN(b.numparte) > 1 then ' Num. Parte: ' #_Cat# b.numparte  else ' ' end as Descripcion,
     CASE WHEN b.DOobservaciones IS NOT  NULL AND <cf_dbfunction name="length"	args="b.DOobservaciones"> > 0 THEN  b.DOobservaciones
     ELSE j.Observacion END #_Cat#' - '#_Cat#
     CASE WHEN b.DOalterna IS NOT  NULL AND <cf_dbfunction name="length"	args="b.DOalterna"> > 0 THEN  b.DOalterna
     ELSE j.descalterna END as DescripcionDetalle,
	 #LvarOBJ_PrecioU.enSQL_AS("b.DOpreciou")#,
	 b.DOtotal,
     b.DOimpuestoCosto,
	 (select Msimbolo from Monedas where Ecodigo = a.Ecodigo and Mcodigo = a.Mcodigo) as codMoneda, 
	 a.EOnumero,   
	 a.EOtotal + a.EOdesc - a.Impuesto as SubtotalOC,
	 a.EOdesc as DescuentoOC,
	 a.EOtotal - a.Impuesto as SubTotalConDescOC,
	 a.Impuesto as ImpuestoOC,
	 a.EOtotal as TotalOC, 
	 coalesce(a.EOplazo, 0) as EOplazo,
     a.EOlugarentrega,
	 coalesce(a.Observaciones,'') as DescripcionE,
	 a.EOidorden,
     a.Ecodigo,
	 a.CMCid,
     a.Usucodigo,     
     cmf.CMFPdescripcion,
     coalesce(<cf_dbfunction name="to_char"	args="a.EOrefcot">,'--') as  EOrefcot,
	 b.Icodigo,
     mo.Mnombre,
	 a.EOImpresion, 
     coalesce((select  cc.direccion1 #_Cat# ' '#_Cat# cc.direccion2 
                  from SNegocios aa 			    
				inner join  DireccionesSIF cc
					 on cc.id_direccion = aa.id_direccion 
				 where aa.SNcodigo = a.SNcodigo and
                  aa.SNcodigo = a.SNcodigo
                  and  aa.Ecodigo = #session.Ecodigo#),f.SNdireccion) as Direccion,
     f.SNnombre as NombreProveedor,
     f.SNtelefono, 
     f.SNFax,
     coalesce(<cf_dbfunction name="to_char"	args="es.ESnumero">,'--') as  ESnumero,
     coalesce(j.Acodigo,'--') as Adescripcion,
     cm.CMCnombre,
	 h.Ucodigo, 
	 b.DOfechareq as fechaRequerida,
	 b.DOfechaes as fechaest,
	 case coalesce(I.Iporcentaje,0.00) when 0.00 then 'S' else '&nbsp;' end  exento,
	 (select min(Coalesce(CMCnombre,'')) from CMCompradores where  CMCid = a.CMCid) NombreComprador
	 
		from EOrdenCM a 
        
		INNER join DOrdenCM b
        			on a.EOidorden = b.EOidorden
        LEFT OUTER join Almacen al 
            		on al.Aid  = b.Alm_Aid
		LEFT OUTER join DCotizacionesCM r
					on b.DClinea = r.DClinea
		LEFT OUTER  join CMProcesoCompra s
					on r.CMPid = s.CMPid
		LEFT OUTER  join Empresas c 
					on a.Ecodigo = c.Ecodigo
		LEFT OUTER  join SNegocios f
					on a.Ecodigo = f.Ecodigo
					and a.SNcodigo = f.SNcodigo
      	LEFT OUTER  join CMCompradores cm
					on a.CMCid = cm.CMCid            
		LEFT OUTER  join Unidades h
					on  b.Ecodigo = h.Ecodigo
					and b.Ucodigo = h.Ucodigo
        LEFT OUTER  join Monedas mo
                    on a.Mcodigo = mo.Mcodigo
		LEFT OUTER  join DSolicitudCompraCM g
					on  g.ESidsolicitud = b.ESidsolicitud 
					and g.DSlinea = b.DSlinea 
        LEFT OUTER  join ESolicitudCompraCM es
					on  g.ESidsolicitud = es.ESidsolicitud             
		LEFT OUTER join Articulos j
				    on b.Aid     = j.Aid
		LEFT OUTER join Conceptos k
				    on b.Cid     = k.Cid
		LEFT OUTER join AClasificacion ac
				   on b.Ecodigo = ac.Ecodigo
				   and b.ACcodigo = ac.ACcodigo
				   and b.ACid = ac.ACid  
		LEFT OUTER  join ACategoria atl
				   on b.Ecodigo = atl.Ecodigo
				   and b.ACcodigo = atl.ACcodigo
		LEFT OUTER join CMFormasPago cmf
				   on a.CMFPid = cmf.CMFPid
		LEFT OUTER join Impuestos I
				   on b.Ecodigo = I.Ecodigo
				   and b.Icodigo = I.Icodigo
		where a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
		order by b.DOconsecutivo
</cfquery>


<cfif data.recordCount EQ 0>
	<cf_errorCode	code = "50273" msg = "No se encontraron datos para el detalle de la Orden de Compra">
</cfif>
    <cfquery name="rsEcodigoSDC" datasource="#session.dsn#">
      select EcodigoSDC from Empresas where Ecodigo = #data.Ecodigo#
    </cfquery>      

    <cfquery name="rsComprador" datasource="#session.dsn#">
          select   
          coalesce(a.Poficina, a.Pcelular) as telef, 
          a.Pfax as fax
         from DatosPersonales a 
          inner join Usuario u 
             on  a.datos_personales = u.datos_personales
        where u.Usucodigo = #data.Usucodigo#
    </cfquery>
    
<cfquery name="rsAutoriza" datasource="#session.DSN#">
	select count(1) as cantidad
	from CMAutorizaOrdenes
	where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.EOidorden#">
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
		and CMAestadoproceso <> 10
		and Nivel = ( select max(Nivel)
					  from CMAutorizaOrdenes 
					  where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.EOidorden#">
						and CMAestadoproceso <> 10
						and CMAestado in (1,2) )
	</cfquery>
	<cfif dataComprador.recordCount gt 0 and dataComprador.CMAestadoproceso eq 15>
		<cfquery name="rsComprador2" datasource="#session.dsn#" >
			select CMCnombre 
			from CMCompradores 
			where CMCid = #dataComprador.CMCid#
		</cfquery>
		<cfset NombreAprobador = rsComprador2.CMCnombre>
	</cfif>
<cfelse>
	<cfset NombreAprobador= #data.NombreComprador#>
</cfif>
	<cfoutput>
	 <cfset contador= 0>
		<cfloop query="data">	
			<cfset contador = contador+1>	
			<cfif contador EQ 1>
				<cfset fnColcarEncabezado()>
				<cfset fnColocarEDetalle()>
			</cfif>
			<cfset fnColocarDDetalle()>
			<cfif (isdefined("Url.imprimir") and contador eq max_lineas)>
				<cfset fnCambioPagina()>
				<cfset contador= 0>	
			</cfif>
		</cfloop>
				<cfset FinLineasDetalle()>
				<cfset fnColocarResumen()>
				<cfset fnColocarPiePagina()>
	</cfoutput>

<!---Verificar el estado de la impresion de la orden actualmente
	'I' = Impresa la primera vez 
	' ' = Nunca se ha impreso
	'R' = Reimpresion ----->
<cfquery name="rsEstadoImpresion" datasource="#session.DSN#">
	select ltrim(rtrim(EOImpresion)) as EOImpresion from EOrdenCM 
	where Ecodigo =  #Session.Ecodigo# 
		and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
</cfquery>
<!----ACTUALIZAR EL ESTADO DE LA IMPRESION DE LA OC----->
<cfif isdefined("url.Imprimir") and len(trim(rsEstadoImpresion.EOImpresion)) EQ 0><!----Si la OC todavia no ha sido impresa por primera vez---->
	<cfquery datasource="#session.DSN#">
		update EOrdenCM
		set EOImpresion='I'
		where Ecodigo =  #Session.Ecodigo# 
			and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
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
    <table align="center" width="100%" border="0">
        <tr>
        <td align="center"><p><strong><font size="2">ORDEN DE COMPRA</font></strong></p>        
        </td>
        </tr>
    </table>
	<table width="100%" cellpadding="2" cellspacing="0" border="1" align="center" >
           <tr> 
            <td width="21%" align="center"><cfinvoke 
					 component="sif.Componentes.DButils"
					 method="toTimeStamp"
					 returnvariable="tsurl" arTimeStamp="#Empresa.ts_rversion#"> </cfinvoke>
                    <cfif rsEcodigoSDC.recordcount eq 0>
                       <cfset LvarSDC = #session.EcodigoSDC#>
                    <cfelse>
                       <cfset LvarSDC =   #rsEcodigoSDC.EcodigoSDC#>
                    </cfif>
                     
					<cfoutput> 
						<img src="/cfmx/home/public/logo_empresa.cfm?EcodigoSDC=#LvarSDC#&amp;ts=#tsurl#" class="iconoEmpresa" alt="logo" border="0" height="100" width="150" />
					</cfoutput>
            </td>            
            <td><p class="LetraDetalle">FAVOR DE ANOTAR EN TODOS 
               SUS DOCUMENTOS</p>
              <p class="LetraDetalle"> Y CAJAS DE EMPAQUES ESTE NUMERO</p>
              <p><em class="style4"><span class="LetraDetalle">FECHA DE ELABORACION:</span></em>&nbsp;#LSDateFormat(data.FechaOC,'dd/mm/yyyy')#</p>
            </td>
          <td width="40%" colspan="2"> 
                <table width="100%" border="0" align="center">
                   <tr>
                      <td>&nbsp;&nbsp;&nbsp;</td>
                      <td align="center"><strong>No.</strong>&nbsp;L-#data.EOnumero#</p></td>
                   </tr>
                   <tr>
                      <td colspan="2" align="center"><cfif len(trim(data.EOImpresion)) AND FALSE>
                      <strong>Orden de Compra no valida para su uso.</strong> </cfif>
                      </td>                      
                   </tr>
                </table>
            </td>
      </tr>
			<tr>
			  <td colspan="2">
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
                  <tr><td width="23%"><strong>Proveedor:</strong></td><td colspan="2"><span class="LetraDetalle">#data.NombreProveedor#</span></td>
                  </tr>
                  <tr><td><strong>Direcci&oacute;n:</strong></td><td colspan="2"><span class="LetraDetalle">#data.Direccion#</span></td>
                  </tr>
                  <tr><td><strong>Atenci&oacute;n:</strong></td><td colspan="2"><span class="LetraDetalle">#data.contacto#</span></td>
                  </tr>
                  <tr><td>&nbsp;</td><td width="33%"><strong>Telef:</strong> <span class="LetraDetalle"> #data.SNtelefono#</span></td><td width="44%"><strong>Fax:</strong> <span class="LetraDetalle">&nbsp;#data.SNFax#</span></td>
                  </tr>
                  <tr><td><strong>Facturar a :</strong></td><td colspan="2"><span class="LetraDetalle">#data.TituloEmpresa#</span></td>
                  </tr>
                </table>
             </td>
             <td colspan="2">
                 <table border="0" cellpadding="0" cellspacing="0" width="100%">
                  <tr>
                    <td width="30%"><strong>Comprador:</strong></td>
                    <td colspan="2"><span class="LetraDetalle">#data.CMCnombre#</span></td>
                  </tr>
                  <tr>
                    <td><strong>Telefóno:</strong></td>
                    <td width="26%"><span class="LetraDetalle">#rsComprador.telef#</span></td>
                    <td width="44%"><strong>Fax:</strong><span class="LetraDetalle">&nbsp;#rsComprador.fax#</span></td>
                  </tr>
                  <tr>
                    <td><strong>Moneda:</strong></td>
                    <td colspan="2"><span class="LetraDetalle">#data.Mnombre#</span></td>
                  </tr>
                  <tr>
                    <td nowrap="nowrap"><strong>Entregar mercadería en:</strong></td>
                    <td colspan="2"><span class="LetraDetalle"> &nbsp;#data.EOlugarentrega#</span></td>
                  </tr>
                  <tr>
                    <td>&nbsp;</td><td colspan="2">&nbsp;</td>
                  </tr>
                </table>
             </td>
            </tr>
		</table>
</cffunction>

<cffunction name="fnColocarEDetalle" output="true">
	<table width="100%" border="0" bordercolor="000000" cellspacing="0">
	<tr>
		<td align="left" colspan="3"><strong>Condicion de pago:</strong>&nbsp; #data.CMFPdescripcion#</td>
        <td>&nbsp;</td>
        <td align="left" colspan="6"><strong>Ref. Cotizacion:</strong>&nbsp;#data.EOrefcot#</td>
	</tr> 
    <tr>
     <td colspan="12">
      <hr />
     </td>
    <tr>   	
    <tr>	   
    	<td width="5%" class="LetraEncab"  align="center" nowrap="nowrap">L&iacute;n.</td>
        <td width="5%" class="LetraEncab"  align="center" nowrap="nowrap">Artículo.</td>		
		<td width="33%" class="LetraEncab" align="center" nowrap="nowrap">Descripción</td>
        <td width="40%" class="LetraEncab" align="center" >Desc. Detallada</td>
        <td width="8%" class="LetraEncab"  align="center" nowrap="nowrap">Cantidad</td>
		<td width="13%" class="LetraEncab" align="center" >Precio Unit.</td>
        <td width="10%" class="LetraEncab" align="center" >Impuesto.</td>
        <td width="10%" class="LetraEncab" align="center" >Monto Impuesto.</td>        
        <td width="13%" class="LetraEncab" align="center" nowrap="nowrap">UM</td>        
		<td width="20%" class="LetraEncab" align="center" nowrap="nowrap">Importe</td>
		<td width="4%" class="LetraEncab"  align="center" >Fecha ent.</td>
        <td width="4%" class="LetraEncab"  align="center" nowrap="nowrap">Solic.</td>
    </tr>
    <tr>
       <td colspan="12">
		<div align="center"><hr /></div>
	   </td>
    </tr>
</cffunction>
<cffunction name="fnColocarDDetalle" output="true">
	<tr>
		<td class="LetraDetalle" align="center">#data.DOconsecutivo#</td>
        <td class="LetraDetalle" align="center">#data.Adescripcion#</td>
        <td class="LetraDetalle" align="center">#data.Descripcion#</td>
        <td class="LetraDetalle" align="center">#data.DescripcionDetalle#</td>        
		<td class="LetraDetalle" align="right">#LSNumberFormat(data.DOcantidad,',9.00')#</td>		
		<td class="LetraDetalle" align="right">#LSNumberFormat(data.DOpreciou,',9.000')#</td>
        <td class="LetraDetalle" align="center">#data.Icodigo#</td>
        <td class="LetraDetalle" align="center">#LSNumberFormat(data.DOimpuestoCosto,',9.00')#</td>
        <td class="LetraDetalle" align="center">#data.Ucodigo#</td>        
		<td class="LetraDetalle" align="right">#LSNumberFormat(data.DOtotal,',9.00')#</td>
        <td class="LetraDetalle" align="center">#DateFormat(data.fechaest,'dd/mm/yyyy')#</td>
		<td class="LetraDetalle" align="center">#data.ESnumero#</td>
	</tr>
</cffunction>
<cffunction name="FinLineasDetalle" output="true">
	<tr><td colspan="12">
		<div align="center">------------------------  última Línea -----------------------------</div>
	</td>
    </tr>
    <tr>
      <td colspan="12">
		<div align="center"><hr /></div>
	  </td>
    </tr>
</cffunction>
<cffunction name="fnCambioPagina" output="true">
	</table>
	<BR style="page-break-after:always;">	
</cffunction>
<cffunction name="fnColocarResumen" output="true">
  	 <tr>
       <td colspan="7" >
	      <table width="100%">
			 <tr>
			   <td align="left"><p><strong>OBSERVACIONES:</strong></p>
			     &nbsp;&nbsp;&nbsp;#data.DescripcionE#</td>			    
			 </tr>             
	      </table>
       </td>                                     
	   <td colspan="5" style="border-left:1;">
		<table border="0">
            <tr>
                <td width="7%" nowrap="nowrap" class="LetraEncab">Subtotal:</td>
                <td width="18%" class="LetraDetalle"><cfoutput>#fnGetMsimbolo(data.codMoneda)#</cfoutput>&nbsp;#LSNumberFormat(data.SubtotalOC,',9.00')#</td>
                </tr>
                <tr>
                <td class="LetraEncab">Descuento:</td>
                <td class="LetraDetalle"><cfoutput>#fnGetMsimbolo(data.codMoneda)#</cfoutput>&nbsp;#LSNumberFormat(data.DescuentoOC,',9.00')#</td>
                </tr>               
                <tr>
                <td class="LetraEncab">I.V.A:</td>
                <td class="LetraDetalle"><cfoutput>#fnGetMsimbolo(data.codMoneda)#</cfoutput>&nbsp;#LSNumberFormat(data.ImpuestoOC,',9.00')#</td>
                </tr>
                <tr>
                <td class="LetraEncab">TOTAL:</td>
                <td class="LetraDetalle"><cfoutput>#fnGetMsimbolo(data.codMoneda)#</cfoutput>&nbsp;#LSNumberFormat(data.TotalOC,',9.00')#</td>
            </tr>    
	   </table>
     <tr>
      <td colspan="12">
		<div align="center"><hr /></div>
	  </td>
    </tr>
</cffunction>
<cffunction name="fnColocarPiePagina" output="true">
           <cfset LvarMontoLetras = #LvarObj.fnMontoEnLetras(data.TotalOC)#>
		   <cfset fin= len(ltrim(rtrim(LvarMontoLetras)))-10>
		   <cfset LvarMontoInicio = mid(LvarMontoLetras,1,fin)>
		 
		   <cfset LvarMontoFin = mid(LvarMontoLetras,fin,len(ltrim(rtrim(LvarMontoLetras))))>
				

    <tr>
      	  <td colspan="12">
         <p class="LetraDetalle"><strong>Importe en letras:</strong> #LvarMontoInicio# #data.Mnombre# #LvarMontoFin# ctmos.</p>
         </td>
    </tr>
  	<tr>
      <td colspan="6">
         <p class="LetraDetalle"><strong>Nota:</strong> Trámite de facturas: V 8:00 - 11:45am / Pagos por transferencia: V /Pagos por cheque: K y M </p>
      </td>
      <td colspan="6">
         <p class="LetraDetalle"><strong>Autorización:</strong>  
         <p class="LetraDetalle">#NombreAprobador#
      </td>
     </tr>
     <tr>
      <td colspan="12">
		<div align="center"><hr /></div>
	  </td>
    </tr>

	</table>
	<table align="right">
        <tr>
            <td>&nbsp;</td>
        </tr>
        <tr>
            <td>&nbsp;</td>
        </tr>
		<cfif isdefined("Url.imprimir") and data.recordCount>
			<tr><td align="right" class="LetraDetalle"><strong>Pág. #Ceiling(data.recordCount / max_lineas)#/#Ceiling(data.recordCount / max_lineas)#</strong></td></tr>
		</cfif>
   </table>

</cffunction>
<cffunction name="fnGetMsimbolo" returntype="string" output="false">
    <cfargument name="simbolo">
    <cfif find(Application.dsinfo[session.dsn].type,"sybase,xxx")>
        <cfif asc(arguments.simbolo) EQ 128>
            <cfreturn "€">
        </cfif>
    </cfif>
    <cfreturn "#trim(arguments.simbolo)#">
</cffunction>


