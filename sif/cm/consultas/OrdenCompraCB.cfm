<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<!--- Query para obtener el nombre del comprador --->
<!--- <cf_dump var="#form#"> --->
<cfset max_lineas = 11 * 1.0>

<cfif isdefined("url.EOidorden") and len(trim(url.EOidorden)) and not isdefined("form.EOidorden")>
	<cfset form.EOidorden = url.EOidorden >
</cfif>

<cfif not isdefined("form.EOidorden") >
	<cfif isdefined("url.EOnumero") and len(trim(url.EOnumero))>
		<cfquery name="rsOrden" datasource="#session.DSN#">
			select EOidorden
			from EOrdenCM
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EOnumero#">
		</cfquery>
		<cfset form.EOidorden = rsOrden.EOidorden >
	</cfif>
</cfif>

<cfif not (isdefined("form.EOidorden") and len(trim(form.EOidorden)))>
	<cf_errorCode	code = "50272" msg = "No ha sido definida la Orden que desa imprimir.">
</cfif>

<!---<cf_templatecss>--->
<style type="text/css">
	.Datos
	{
		font-size:9px;
		font-family:Arial, Helvetica, sans-serif;
		line-height:10px;
	}
</style> 

<cfquery name="data" datasource="#session.DSN#">
	select a.EOidorden,b.CFid,b.CFcuenta,
			a.CMCid,
			b.DOconsecutivo,
			b.Icodigo,
			a.EOnumero,
			a.EOImpresion, 
		   rtrim(c.Edescripcion) as TituloEmpresa, 
           e.CMCnombre as NombreComprador, 
           coalesce(f.SNtelefono,'') as TelefonoProveedor, 
           coalesce(f.SNFax,'') as FaxProveedor, 
           coalesce(f.SNemail,'') as EmailProveedor, 
           f.SNdireccion as Direccion,
           a.EOfecha as FechaOC, 
		   f.SNnumero,
           f.SNnombre as NombreProveedor,
           f.SNidentificacion as CedulaJuridica,
           f.SNtipo,
			a.EOplazo,
			g.ESnumero as NumeroSolicitud,
			h.Ucodigo,
			b.DOcantidad,
			#LvarOBJ_PrecioU.enSQL_AS("b.DOpreciou")#,
			b.DOtotal,
			a.Mcodigo,
			i.Mnombre,
			i.Msimbolo,
			CMtipo,

			<!--- case CMtipo when 'A' then coalesce(b.DOalterna, j.Adescripcion) 
					when 'S' then coalesce(b.DOalterna, k.Cdescripcion)
					when 'F' then coalesce(b.DOalterna, ac.ACdescripcion) 
			end as Descripcion, --->
			<!--- Cambio hecho por: Rodolfo Jimenez Jara, 05-07-2005
			solicitado por:   Nelson Baltodano , Dos Pinos --->
			case CMtipo when 'A' then coalesce(b.DOalterna, '') 
					when 'S' then coalesce(b.DOalterna, '')
					when 'F' then coalesce(b.DOalterna, '') 
			end as Descripcion,

			case CMtipo when 'A' then coalesce(b.DOobservaciones, '') 
					when 'S' then coalesce(b.DOobservaciones, '')
					when 'F' then coalesce(b.DOobservaciones, '') 
			end as ObservacionesOrden,

			case CMtipo when 'A' then coalesce(j.Acodigo,'') when 'S' then coalesce(k.Ccodigo,'') else '' end as CodArticulo,
			case CMtipo when 'A' then coalesce(b.numparte,j.Acodalterno) else '' end as NumeroParte,

			coalesce(ltrim(rtrim(b.DOdescripcion)),'') as DescripcionDetalle,			
			coalesce(b.DOobservaciones,'') as Observacion,

			a.EOtotal as TotalOC,
			a.Impuesto as ImpuestoOC,
			a.EOdesc as DescuentoOC,
			a.EOtotal + a.EOdesc - a.Impuesto as SubtotalOC,

			a.EOnumero as NumeroOC,
		    b.DOfechareq,
		    b.DOfechaes,
		    coalesce(a.Observaciones,'') as Observaciones,
			s.CMPnumero,
			coalesce(b.DOporcdesc, 0.00) as DOporcdesc,
			cmf.CMFPdescripcion,
			a.EOlugarentrega,
			coalesce(b.DOmontodesc,0.00) as DOmontodesc,
			a.EOdiasEntrega,
			al.Almcodigo,
			al.Bdescripcion,
			g.ESidsolicitud
		from EOrdenCM a 

		inner join DOrdenCM b
		  			 left join Almacen al <!--- Se pone un left por que el campo Alm_Aid acepta nulos --->
						on al.Aid  = b.Alm_Aid
					on a.Ecodigo = b.Ecodigo
					and a.EOidorden = b.EOidorden
		
		left outer join CFinanciera cf on cf.CFcuenta=b.CFcuenta   and a.Ecodigo = b.Ecodigo                 

		left outer join DCotizacionesCM r
					on b.DClinea = r.DClinea

		left outer join CMProcesoCompra s
					on r.CMPid = s.CMPid

		inner join Empresas c 
					on a.Ecodigo = c.Ecodigo

		inner join CMCompradores e
					on a.Ecodigo = e.Ecodigo 
					and a.CMCid = e.CMCid

		inner join SNegocios f
					on a.Ecodigo = f.Ecodigo
					and a.SNcodigo = f.SNcodigo

		inner join Unidades h
					on  b.Ecodigo = h.Ecodigo
					and b.Ucodigo = h.Ucodigo

		inner join Monedas i
					on  a.Ecodigo = i.Ecodigo
					and a.Mcodigo = i.Mcodigo                     

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

		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
   		  and a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
		order by b.DOconsecutivo, NumeroParte, CodArticulo
</cfquery>
<!---<cfdump var="#data#">--->
<cfif data.ESidsolicitud EQ "">
	<cfset varIdSolicitud = -1>	
<cfelse>
	<cfset varIdSolicitud = data.ESidsolicitud>
</cfif>	
<cfquery name="rsTipoCompra" datasource="#session.dsn#">
	select ESnumero, ESobservacion,case CMTScodigo 
    when '001' then 'BC'
	when '002' then 'AF'
	when '003' then 'S'
	end as tipoC
    from ESolicitudCompraCM
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    and ESidsolicitud=<cfqueryparam cfsqltype="cf_sql_numeric" value="#varIdSolicitud#">
</cfquery>
<cfset NombreComprador = "">
<cfif isdefined("data") and Len(Trim(data.CMCid))>
	<cfquery name="rsComprador" datasource="#Session.DSN#">
		select Usulogin ,CMCnombre
		from Usuario u 
        inner join  CMCompradores c on u.Usucodigo=c.Usucodigo
		where CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.CMCid#">
	</cfquery>
	<cfset NombreComprador = rsComprador.CMCnombre>
    <cfset idComprador=rsComprador.Usulogin>
</cfif>
 
<cfif data.recordCount EQ 0>
	<cf_errorCode	code = "50273" msg = "No se encontraron datos para el detalle de la Orden de Compra">
</cfif>

<!--- datos de la empresa --->
<cfquery name="dataOrden" dbtype="query" maxrows="1">
	select EOidorden
	from data
</cfquery>

<cfquery name="rsAutoriza" datasource="#session.DSN#">
	select * 
	from CMAutorizaOrdenes
	where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataOrden.EOidorden#">
</cfquery>

<cfif rsAutoriza.recordCount gt 0 >
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
		where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataOrden.EOidorden#">
		and CMAestado in (1,2)
		and CMAestadoproceso <> 10
		and Nivel = ( select max(Nivel)
					  from CMAutorizaOrdenes 
					  where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataOrden.EOidorden#">
						and CMAestadoproceso <> 10
						and CMAestado in (1,2) )
	</cfquery>
	<cfif dataComprador.recordCount gt 0 and dataComprador.CMAestadoproceso eq 15>
		<cfset vCMCid = dataComprador.CMCid >
	</cfif>
<cfelse>
	<cfquery name="dataComprador" dbtype="query" maxrows="1">
		select CMCid
		from data
	</cfquery>
	<cfset vCMCid = dataComprador.CMCid >
</cfif>

<cfquery name="dataEncabezado" dbtype="query" maxrows="1">
	select distinct EOnumero, EOImpresion, Observaciones, TituloEmpresa, CMPnumero, Mnombre,CFid,
		   SNnumero, NombreProveedor, CedulaJuridica, TelefonoProveedor, FaxProveedor, FechaOC
	from data
</cfquery>

<cfquery name="areaResp" datasource="#session.dsn#">
	select CFdescripcion from CFuncional where CFid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#dataEncabezado.CFid#">
</cfquery>

<cfif len(trim(data.Icodigo))>
    <cfquery name="rsImpuesto" datasource="#session.DSN#">
        select Iporcentaje, Idescripcion
        from Impuestos
        where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        and Icodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#data.Icodigo#">
    </cfquery>
    <cfif len(trim(rsImpuesto.Iporcentaje))>
        <cfset vImpuesto = rsImpuesto.Iporcentaje >
    </cfif>
</cfif>

<cfquery name="rsResumen" dbtype="query" maxrows="1">
    select 	EOlugarentrega, 
            CMFPdescripcion, 
            SubtotalOC, 
            TotalOC, 
            DescuentoOC, 
            ImpuestoOC, 
            Observaciones, 
            FechaOC, 
            EOdiasEntrega
    from data
</cfquery>
<cfoutput>

<cfsavecontent variable="encabezado">

<table width="100%" >
	<tr>
    	<td width="25%" class="Datos"> 
   	  <table width="100%"   style=" border-style:solid; " class="Datos">
            	<tr>
                	<td>
                 		<table width="100%"  >	
                          <td width="38%"><img src="/cfmx/sif/cm/consultas/CBachilleres (299x80).jpg" width="66" height="26" alt="logoCB" /></td>
                          <td width="62%"> 
                  			<table width="100%" class="Datos">
                                <tr><td align="center">Secretaria Administrativa</td>
                                <tr><td align="center">CBA-730926-8S8</td></tr>
            				</table>
                  		  </td>
                  		</table>
                    </td>    
                </tr>
                <tr><td>Prolongacion Rancho Vista Hermosa Num. 105</td></tr>
                <tr><td>Col. Los GirasolesC.P. 04920</td></tr>
                <tr><td>Delegación Coyoacán México D.F.</td></tr>
                <tr><td>Tel. 56-24-41-63 Fax: 5684-84-64</td></tr>
                <tr>
                	<td style="border-bottom-style:solid">
                    	<table width="100%" class="Datos">
                        	<tr>
                            	<td>SECTOR</td>
                                <td>SUBSECTOR</td>
                                <td>CLAVE</td>
                            </tr>
                            <tr>
                            	<td>EDUCATIVO</td>
                                <td>EDUCACION MEDIA</td>
                                <td>11-115</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
             		<td align="center" style=" border-bottom:solid"><strong>CONTRATO PEDIDO</strong></td>
             	</tr>
            	<tr>
                	<td>
                    	<table width="100%" border="1" class="Datos">
                        	<tr>
                            	<td>Fecha</td>
                                <td> #DateFormat(dataencabezado.fechaoc,'dd-mmm-yyyy')#</td>
                                <!---<td style="font-size:9px">Hoja Num.</td><cfdump var="#data.Currentrow/max_lineas#">
                                <td><strong>#Int(data.Currentrow / max_lineas)#/#Ceiling(data.recordCount / max_lineas)#</strong></td>--->
                            </tr>
                        </table>
                     </td>
                </tr>
                <tr>
                	<td >
                    	<table width="100%" border="1" class="Datos">
                        	<tr>
                    			<td colspan="2"> Num Pedido</td>
                            	<td> AÑO</td>
                                <td> Comprador</td>
                            </tr>    
                            <tr>
                    			<td colspan="2" align="center" >#rsTipoCompra.tipoC# #data.EOnumero#</td>
                            	<td> #DateFormat(dataencabezado.fechaoc,'yyyy')#</td>
                                <td> #idComprador#</td>
                            </tr>
                         </table>   
                    </td>
                </tr>
                <tr>
                	<td>
                    	<table width="100%" border="1 class="Datos"">
                        	<tr>
                            	<td class="Datos">
                                	REQUISICION Num. #rsTipoCompra.ESnumero#-#rsTipoCompra.ESobservacion#
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
             
        </td>
        <td>&nbsp; </td>
        <td width="40%">
        	<table width="100%" style="border-style:solid;line-height:13px" border="1">
            	<tr>
                	<td>	
                    	<table width="100%" class="Datos"   >
            				<tr><td>Proveedor</td></tr>
                            <tr><td>#dataEncabezado.NombreProveedor#</td></tr>
                            <tr><td>#data.Direccion#</td></tr>
                            <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
                            <tr><td>Tel: #data.telefonoProveedor#</td></tr>
                            <tr><td>e-mail: #data.emailproveedor#</td></tr>
                            <tr><td>&nbsp;</td></tr>
                            <tr><td>RFC #dataEncabezado.CedulaJuridica#</td></tr>
                            <tr><td>&nbsp;</td></tr>
                        </table>    
                </tr>
                <tr>
                	<td>	
                    	<table width="100%" border ="1" class="Datos" >
            				<tr>
                            	<td width="60%">Cotizaciones</td>
                                <td align="center" > Dia Mes Año</td>
                            </tr>
                            <tr>
                            	<td width="60%">(o Ref d)e Fecha</td>
                                <td >&nbsp;</td>
                            </tr>
                        </table>  
                    </td>      
                </tr>
                <tr>
                	<td>	
                    	<table width="100%" border ="1" class="Datos" style ="line-height:11px">
            				<tr>
                            	<td width="30%" align="center"><<<<<<<<<</td>
                                <td>Favor de checar este documento en toda su  correspondencia, documentos y empaques</td>
                            </tr>
                            <tr>
                            	<td width="30%">Fundamento Legal</td>
                                <td>#data.Observaciones#</td>
                            </tr>
                        </table>    
                <tr>
            </table>
        </td>
        <td>&nbsp;</td>
        <td width="20%">
        	<table width="100%" style="border-style:solid;line-height:11px" border="1" class="Datos">
            	<tr>
                	<td>	
                    	<table width="100%" class="Datos" style ="line-height:11px">
            				<tr><td>Efectuar entrega</td></tr>
                            <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
                            <tr><td>Prolongación Rancho</td></tr>
                            <tr><td>Vista Hermosa No. 105</td></tr>
                            <tr><td>Col. Los Girasoles</td></tr>
                            <tr><td>C.P. 04920</td></tr>
                            <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
                        </table>
                    </td>
               </tr> 
               <tr>
               		<td>
                    	<table width="100%" class="Datos" >
                        	<tr><td>Almacen: Entregar Bienes a:</td></tr>
                            <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
                            <tr><td>#areaResp.CFDescripcion#</td></tr>
                            <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
                        </table>
                    </td>
               </tr>            
            </table>
        </td>
        <td>&nbsp;</td>
        <td width="20%">
        	<table width="100%"  border="1" class="Datos" style="border-style:solid;line-height:11px">
            	<tr>
                	<td>	
                    	<table width="100%" class="Datos">
            				<tr><td>La fecha de entrega sera: #data.eodiasentrega#</td></tr>
                            <tr><td>Días Hábiles posteriores a la</td></tr>
                            <tr>
                              <td>Recepción de Pedido por el Proveedor</td></tr>
                            <tr><td>&nbsp;</td></tr>
                        </table>
                    </td>
                </tr> 
                <tr>
                	<td>
                    	<table width="100%" class="Datos">
                			<tr><td>Condiciones de Entrega:</td></tr>
                            <tr><td>&nbsp;</td></tr>
                            <tr><td>#rsResumen.EOlugarentrega#</td></tr>
                            <tr><td>&nbsp;</td></tr>
                        </table>
                   </td>
                </tr>   
                <tr>
                	<td>
                    	<table width="100%" class="Datos" >
                			<tr><td>Condiciones de Pago:</td></tr>
                            <tr><td>&nbsp;</td></tr>
                            <tr><td>20 Dias Máximo</td></tr>
                            <tr><td>(A partir de la Recepción de las Facturas)</td></tr>
                            <tr><td>&nbsp;</td></tr>
                        </table>
                   </td>
                </tr>       
            </table>
        </td>
    </tr>
    
</table>
<table width="100%" border="1" class="Datos">
	<tr>
	    <td width="5%" align="center">Partida</td>        
        <td width="60%" align="center" >Codigo - Descripción de los bienes y/o servicios</td>
        <td width="7%" align="center">Cantidad</td>
        <td width="8%" align="center">Unidad</td>
        <td width="10%" align="center">Precio Unitario</td>
        <td width="10%" align="center">Precio Total Neto</td>
    </tr>
</table>
<cfset contador = 0 >
</cfsavecontent>

<cfset contador = 0 >

<!---
<cfset total_general = 0 >
<cfset totalImpuestos = 0 >
<cfset subtotal_general = 0 >
<cfset total_descuento = 0 >
--->
 <cfloop query="data">
 <cfif (isdefined("Url.imprimir") and contador eq max_lineas) or data.Currentrow eq 1>
		#encabezado#
</cfif>

<table width="100%" border="1" > 
 
  <cfquery name="rsRubro" datasource="#session.dsn#">
  	select SUBSTRING(CFformato,11,9) as rubro from CFinanciera
    where CFcuenta =#data.CFcuenta#
    and Ecodigo = #session.Ecodigo#
  </cfquery>
 <cfset Rubro = rsRubro.rubro>
    <tr>
	    <td width="5%">
        	<table width="100%">
        		<tr><td>#data.DOconsecutivo#</td></tr>
            </table>
        </td>
        <td width="60%">
   	  <table width="100%">
        		<tr><td >#data.DescripcionDetalle# - #Rubro#</td></tr>
            </table>
      </td>
        <td width="7%">
        	<table width="100%">
        		<tr><td align="center">#LSNumberFormat(data.DOcantidad,'9,9.00')#</td></tr>
            </table>
        </td>
        <td  width="8%">
        	<table width="100%">
        		<tr><td align="center">#data.Ucodigo#</td></tr>
            </table>
        </td>
        <td  width="10%">
        	<table width="100%">
       		  <tr><td align="right">#LvarOBJ_PrecioU.enCF_RPT(data.DOpreciou)#</td></tr>
            </table>   
   </td>
         <td  width="10%">
        	<table width="100%">
        		<tr><td align="right">#LSNumberFormat(data.DOtotal,'9,9.00')#</td></tr>
            </table>
        </td>
  	</tr>
    <cfif isdefined("Url.imprimir") and data.Currentrow NEQ data.recordCount and data.Currentrow mod max_lineas EQ 0>
			<tr><td colspan="11" align="left" class="Datos">
					<strong>Pág. #Int(data.Currentrow / max_lineas)#/#Ceiling(data.recordCount / max_lineas)#</strong>
				</td>
			</tr>
			<tr class="pageEnd"><td colspan="11" style="border-bottom:none">&nbsp;</td></tr>
	</cfif>
    <cfset contador = contador + 1 >
 </cfloop>  
 </table>
<table width="100%" >
  <tr> <td align="right" width="90%">Subtotal</td><td align="right">#LSNumberFormat(data.SubtotalOC,'9,9.00')#</td></tr>
   <tr><td align="right">#rsImpuesto.Idescripcion#</td><td align="right">#LSNumberFormat(data.ImpuestoOC,'9,9.00')#</td></tr>
   <tr><td align="right">Total</td><td align="right"> #LSNumberFormat(data.TotalOC,'9,9.00')# </td></tr>
   <cfif data.SNtipo EQ 'F'>
   		<tr><td align="right" style="font-size:7px">Retencion de I.V.A art. 1-A y 3 de Ley del IVA</td><td align="right">- #LSNumberFormat(data.ImpuestoOC,'9,9.00')#</td></tr> 
   <!---<cfelse>  		
   		<tr><td>&nbsp;</td><td>#contador#</td></tr>--->
   </cfif>
 </table>
 <table width="100%" border="1">
        <tr>
        	<cfinvoke component="sif.Componentes.montoEnLetras" method="fnMontoEnLetras" returnvariable="MontoLetras">
              <cfinvokeargument name="Monto" value="#data.TotalOC#">
            </cfinvoke>
        	<td align="center">#Ucase(MontoLetras)#</td>
            <td width="10%" align="right"> Total:</td>
          <td width="10%" align="right"> $ #LSNumberFormat(data.TotalOC,'9,9.00')#</td>
   </tr>
</table>

 <table width="100%" border="1" class="Datos">
        <tr>
        	<td  width="25%">
            	<table width="100%" class="Datos">
                	<tr><td >Departamento de Compras (Nombre y Firma)</td></tr>
                    <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
                    <tr><td style="font-size:10px"><strong>Lucina Kiyoco Caso Coique</strong></td></tr>
                    <tr><td >Fecha:  #DateFormat(dataencabezado.fechaoc,'dd-mm-yyyy')#</td></tr>
                </table>
            </td>	
            <td  width="25%">
            	<table width="100%" class="Datos">
                	<tr><td >Dirección de Servicios Administrativos y Bienes (Nombre y Firma)</td></tr>
                    <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
                    <tr><td style="font-size:10px"><strong>Lic. Jorge Guerrero Almaraz</strong></td></tr>
                    <tr><td>Fecha:  #DateFormat(dataencabezado.fechaoc,'dd-mm-yyyy')#</td></tr>
                </table>
            </td>
            <td  width="25%">
            	<table width="100%" class="Datos">
                	<tr><td >Dirección de Administración Presupuestal y Recursos Finacieros (Nombre y Firma)</td></tr>
                    <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
                    <tr><td style="font-size:10px"><strong>Nombre</strong></td></tr>
                    <tr><td >Fecha:  </td></tr>
                </table>
            </td>
            <td  width="25%">
            	<table width="100%" class="Datos">
                	<tr><td >Secretaría Administrativa (Nombre y Firma)</td></tr>
                    <tr><td>&nbsp;</td></tr><tr><td>&nbsp;</td></tr>
                    <tr><td style="font-size:10px"><strong>C.P. Araceli Ugalde Hernández</strong></td></tr>
                    <tr><td >Fecha:  </td></tr>
                </table>
            </td>
        </tr>
</table>
<cfif isdefined("Url.imprimir") and data.recordCount>
	<tr><td align="right" class="LetraDetalle"><strong>Pág. #Ceiling(data.recordCount / max_lineas)#/#Ceiling(data.recordCount / max_lineas)#</strong></td></tr>
</cfif>
</cfoutput>



<!---Verificar el estado de la impresion de la orden actualmente
	'I' = Impresa la primera vez 
	' ' = Nunca se ha impreso
	'R' = Reimpresion ----->
<cfquery name="rsEstadoImpresion" datasource="#session.DSN#">
	select ltrim(rtrim(EOImpresion)) as EOImpresion from EOrdenCM 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
</cfquery>
<!----ACTUALIZAR EL ESTADO DE LA IMPRESION DE LA OC----->
<cfif isdefined("url.Imprimir") and len(trim(rsEstadoImpresion.EOImpresion)) EQ 0><!----Si la OC todavia no ha sido impresa por primera vez---->
	<cfquery datasource="#session.DSN#">
		update EOrdenCM
		set EOImpresion='I'
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
	</cfquery>	
<cfelseif isdefined("url.Imprimir")>
	<cfquery datasource="#session.DSN#">
		update EOrdenCM
		set EOImpresion='R'
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
	</cfquery>
</cfif>


