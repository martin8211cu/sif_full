<cfparam name="url.Ecodigo" default="#Session.Ecodigo#">
<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfif isdefined("url.EOnumero") and len(url.EOnumero) and not isdefined("form.EOnumero")>
	<cfquery name="rsBuscaIDorden" datasource="#session.dsn#">
		select min(EOidorden) as EOidorden
		from EOrdenCM
		where Ecodigo = #url.Ecodigo#
		  and EOnumero = #url.EOnumero#
	</cfquery>
	<cfset form.EOidorden = rsBuscaIDorden.EOidorden>
</cfif>
<cfif isdefined("url.EOidorden") and not isdefined("form.EOidorden")>
	<cfset form.EOidorden = Url.EOidorden>
</cfif>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cf_dbfunction name="to_char" args="b.EOidorden" returnvariable="IdOrden">
<cf_dbfunction name="to_char" args="b.DOlinea" returnvariable="IdDolinea">
<cf_dbfunction name="concat"  args="'<a href=''##'' onclick=''javascript:return ventanaSecundaria('+ #PreserveSingleQuotes(IdOrden)# +','+ #PreserveSingleQuotes(IdDolinea)# +');''>'" returnvariable="EnlaceCance" delimiters="+">
	
<cfquery name="qryLista" datasource="#session.dsn#">
	select 	a.EOidorden, a.Observaciones, a.EOfecha, a.EOtc, a.EOnumero, a.NAP, a.NRP, a.Impuesto,
			a.EOtotal, a.NAPcancel, a.EOdesc, a.EOestado, a.EOjustificacion,a.EOtc,
			b.DOdescripcion, b.DOcantidad, b.DOcantsurtida, b.DOfechareq, b.DOtotal, 
			#LvarOBJ_PrecioU.enSQL_AS("b.DOpreciou")#, 
		    #PreserveSingleQuotes(EnlaceCance)# as Enlace,         
			b.Icodigo, b.DOlinea,
			b.DOdescripcion, b.DOalterna,
			b.DOmontoSurtido,b.DOmontoCancelado,
			c.Mnombre,
			d.CMCnombre, d.CMCcodigo,
			e.Ucodigo,
			f.CFcodigo, f.CFdescripcion,
			g.SNnumero, g.SNnombre,
			h.Bdescripcion, h.Almcodigo,
			i.Iporcentaje, 
			a.ETidtracking, 
			j.CMTgeneratracking,
			j.CMTOcodigo #_Cat#' '#_Cat#j.CMTOdescripcion as  CMTOdescripcion,
			b.DOobservaciones,
			b.DOconsecutivo,
			case CMtipo 	when 'A' then ltrim(rtrim(Acodigo))
       						when 'S' then ltrim(rtrim(n.Ccodigo))
      						 when 'F' then ' ' end as codigo,
			case CMtipo 	when 'A' then Adescripcion
       						when 'S' then Cdescripcion
      						 when 'F' then o.ACdescripcion#_Cat#'/'#_Cat#k.ACdescripcion end as Item,
           sc.ESnumero,
		   sc.DSconsecutivo,
           coalesce(b.DOcantcancel,0) as DOcantcancel
	from EOrdenCM a					
			LEFT OUTER JOIN DOrdenCM b 
        		on a.EOidorden = b.EOidorden
                
            LEFT OUTER JOIN DSolicitudCompraCM sc
            	ON sc.DSlinea = b.DSlinea
            	
			LEFT OUTER JOIN Articulos m <!---Articulos--->
				on b.Aid = m.Aid
      
			LEFT OUTER JOIN Conceptos n<!---Conceptos--->
				on b.Cid = n.Cid
 
			LEFT OUTER JOIN ACategoria o <!---Activos--->
				 on b.ACcodigo = o.ACcodigo
				and a.Ecodigo  = o.Ecodigo
 
			LEFT OUTER JOIN AClasificacion k
				 on b.ACcodigo	= k.ACcodigo
				and b.ACid		= k.ACid
				and a.Ecodigo   = k.Ecodigo

			LEFT OUTER JOIN Unidades e
				 on b.Ucodigo = e.Ucodigo
				and a.Ecodigo = e.Ecodigo

			LEFT OUTER JOIN Impuestos i
				 on b.Icodigo = i.Icodigo
				and a.Ecodigo = i.Ecodigo
			
			LEFT OUTER JOIN CFuncional f
				on  b.CFid = f.CFid
		
			LEFT OUTER JOIN Almacen h
				on b.Alm_Aid = h.Aid
		
            LEFT OUTER JOIN Monedas c
                on a.Mcodigo = c.Mcodigo

			LEFT OUTER JOIN CMCompradores d
				on a.CMCid = d.CMCid

			LEFT OUTER JOIN SNegocios g
				on a.SNcodigo = g.SNcodigo
			   and a.Ecodigo  = g.Ecodigo
			
			LEFT OUTER JOIN CMTipoOrden j
				 on a.CMTOcodigo = j.CMTOcodigo
				and a.Ecodigo    = j.Ecodigo

	where a.EOidorden = #form.EOidorden#
	order by b.DOconsecutivo	
</cfquery>
	<cfquery name="rsDSLinea" datasource="#session.dsn#">
	   select distinct(b.CMPid) 
       	from DOrdenCM a
	    	inner join CMLineasProceso b
				on a.DSlinea = b.DSlinea 
	    where a.Ecodigo   = #url.Ecodigo# 
          and a.EOidorden =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
	</cfquery>
	<cfif rsDSLinea.recordcount gt 0>
		<cfquery name="rsCodigoProceso" datasource="#session.dsn#" maxrows="1">
	     Select CMPcodigoProceso 
         	from CMProcesoCompra 
          where Ecodigo = #url.Ecodigo# 
            and CMPid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDSLinea.CMPid#">
		</cfquery>			
	</cfif>
    <cfset count = 0>
<script language="JavaScript" type="text/javascript">
	var popUpOrden = 0;
	var popUpFac   = 0;	
	function popUpOrdenC(URLStr, left, top, width, height)
	{
		if(popUpOrden)
		{
			if(!popUpOrden.closed) popUpOrden.close();
		}
		popUpOrden = open(URLStr, 'popUpOrden', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}

	function popUpFact(URLStr, left, top, width, height)
	{
		if(popUpFac)
		{
			if(!popUpFac.closed) popUpFac.close();
		}
		popUpFac = open(URLStr, 'popUpFac', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}

	
	function formato(id){
		popUpOrdenC('/cfmx/sif/cm/operacion/imprimeOrden.cfm?consultar=true&EOidorden='+id+'&tipoImpresion=1&Ecodigo=<cfoutput>#url.Ecodigo#</cfoutput>', 160,200,800,430 )
	}
	function facturas(id){
		popUpFact('/cfmx/sif/cm/consultas/OrdenCompra-facturas.cfm?&Ecodigo=<cfoutput>#url.Ecodigo#</cfoutput>&EOidorden='+id, 160,200,800,430 )
	}
	function LinCanceladas(id){
		popUpFact('/cfmx/sif/cm/consultas/OrdenesCanceladasDet.cfm?Ecodigo=&EOidorden='+id, 160,200,800,430 )
	}
</script>


<cfoutput query="qryLista" group="EOidorden">
<br>
<table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
	<tr>
		<td  class="tituloListas"><strong>Datos de la Orden de Compra</strong></td>
		<td class="tituloListas" nowrap="nowrap" align="right"><strong><a href="javascript:formato('#qryLista.EOidorden#');">Ver Orden de Compra</a></strong></td>
		<td class="tituloListas" nowrap="nowrap" style="padding-left:20px;" align="right"><strong><a href="javascript:facturas('#qryLista.EOidorden#');">Ver Facturas de la Orden</a></strong></td>
		<td class="tituloListas" nowrap="nowrap" style="padding-left:20px;" align="right"><strong><a href="javascript: LinCanceladas('#qryLista.EOidorden#');">Ver Lineas Canceladas</a></strong></td>
	</tr>	
	<tr>
		<td colspan="4"><strong>#CMTOdescripcion#</strong></td>
	</tr>
  <tr>
  <td colspan="4">&nbsp;</td>
  </tr>
  <tr>
		<td  nowrap valign="top"><strong>N&uacute;mero de Orden&nbsp;:&nbsp;</strong></td>
		<td valign="top">#EOnumero#
	 <cfif isdefined('rsCodigoProceso')>
		     <cfif rsCodigoProceso.recordcount gt 0 and count eq 0>- (<strong>Código del proceso:</strong> <cfdump var="#rsCodigoProceso.CMPcodigoProceso#)"><cfset count += 1> </cfif>
			 </cfif>
		</td>
		<td nowrap valign="top"><strong>Comprador&nbsp;:&nbsp;</strong></td>
		<td valign="top">#CMCcodigo# - #CMCnombre#</td>
  </tr>
  <tr>
		<td  nowrap width="18%" valign="top"><strong>Fecha de la Orden:&nbsp;</strong></td>
		<td width="39%" valign="top">#LSDateFormat(EOfecha,'dd/mm/yyy')#</td>
		<td nowrap  width="10%" valign="top"><strong>Proveedor&nbsp;:&nbsp;</strong></td>
		<td width="33%" valign="top">#SNnumero# - #SNnombre#</td>
  </tr>
 <tr>
		<td nowrap valign="top"><strong>Observaciones&nbsp;:&nbsp;</strong></td>
		<td valign="top">#Observaciones#</td>
		<td nowrap valign="top"><strong>Moneda&nbsp;:&nbsp;</strong></td>
		<td valign="top">#Mnombre#</td>
  	</tr>
  	<tr>
		<td nowrap valign="top"><strong>Estado&nbsp;:&nbsp;</strong></td>
		<td valign="top">
			<!--- Estados posibles de la Orden--->
			<CFIF ISDEFINED('qryLista.EOestado') AND LEN(TRIM(qryLista.EOestado))>
            	<CFIF 	   qryLista.EOestado EQ 0>
                <CFELSEIF  qryLista.EOestado EQ -10>Pendiente de Aprobación Presupuestal
                <CFELSEIF  qryLista.EOestado EQ -8>Rechazada por el aprobador
                <CFELSEIF  qryLista.EOestado EQ -7>En proceso de firmas
                <CFELSEIF  qryLista.EOestado EQ 0>Pendiente
                <CFELSEIF  qryLista.EOestado EQ 5>Pendiente Vía Proceso
                <CFELSEIF  qryLista.EOestado EQ 7>Pendiente OC Directa
                <CFELSEIF  qryLista.EOestado EQ 8>Pendiente Vía Contrato
                <CFELSEIF  qryLista.EOestado EQ 9>Autorizada por jefe Compras
                <CFELSEIF  qryLista.EOestado EQ 10>Orden Aplicada
                <CFELSEIF  qryLista.EOestado EQ 55>Orden Cancelada Parcialmente Surtida
                <CFELSEIF  qryLista.EOestado EQ 60>Orden Cancelada
                <CFELSEIF  qryLista.EOestado EQ 70>Orden Anulada
                <CFELSEIF  qryLista.EOestado EQ 101>Aprobado Mutiperiodo
                <CFELSE>Desconocido</CFIF>
            <CFELSE>
            	- No especificado -
            </CFIF>
		</td>
	
		<td valign="top"><strong>Tipo Cambio&nbsp;:&nbsp;</strong></td>				
		<td valign="top">#EOtc#</td>
	</tr>
	<cfif qryLista.CMTgeneratracking eq 1 >
	<tr>
		<td valign="top"><strong>Control de Seguimiento&nbsp;:&nbsp;</strong></td>	
		<td valign="top">
			<cfif len(trim(qryLista.ETidtracking)) >
				<cfquery name="rsTracking" datasource="sifpublica">
					select ETnumtracking, ETconsecutivo
					from ETracking
					where Ecodigo=#url.Ecodigo#
					and ETidtracking=<cfqueryparam cfsqltype="cf_sql_numeric" value="#qryLista.ETidtracking#">
				</cfquery>
				#rsTracking.ETconsecutivo#
		  <cfelse>
				N/A
			</cfif>
		</td>					
	</tr>
	</cfif>
	<cfif len(trim(EOjustificacion))>
		<tr>		
			<td valign="top"><strong>Justificación&nbsp;:&nbsp;</strong></td>					
			<td valign="top" colspan="3">#EOjustificacion#</td>
		</tr>	
	</cfif>
	<cfif qryLista.EOestado NEQ 100>
		<tr>			
			<cfif isdefined('qryLista.EOestado') and len(trim(qryLista.EOestado)) and qryLista.EOestado EQ 10>
				<cfif qryLista.NAP EQ 0 or qryLista.NAP EQ ''>
					<td valign="top"><strong>NAP&nbsp;:&nbsp;</strong></td>	
					<td valign="top">N/A</td>
				<cfelse>
					<td valign="top"><strong>NAP&nbsp;:&nbsp;</strong></td>
					<td valign="top">#NAP#</td>	
				</cfif>
				<cfelseif isdefined('qryLista.EOestado') and len(trim(qryLista.EOestado)) and qryLista.EOestado EQ -10>
					<cfif qryLista.NRP EQ 0 or qryLista.NRP EQ ''>
						<td valign="top"><strong>NRP&nbsp;:&nbsp;</strong></td>	
						<td valign="top">N/A</td>
					<cfelse>
						<td valign="top"><strong>NRP&nbsp;:&nbsp;</strong></td>	
						<td valign="top">#NRP#</td>
					</cfif>
				<cfelseif isdefined('qryLista.EOestado') and len(trim(qryLista.EOestado)) and qryLista.EOestado EQ 60>
					<cfif qryLista.NAPcancel EQ 0 or qryLista.NAPcancel EQ ''>
						<td valign="top"><strong>Cancelado&nbsp;:&nbsp;</strong></td>	
						<td valign="top">N/A</td>
					<cfelse>	
						<td width="18%" valign="top"><strong>Cancelado&nbsp;:&nbsp;</strong></td>	
						<td width="39%" valign="top">#NAPcancel#</td>
					</cfif>
				<cfelse>
					<td valign="top">&nbsp;</td>	
					<td valign="top">&nbsp;</td>
		</cfif>
		</tr>
	</cfif> 
	<tr>
		<td colspan="4">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="4" style="padding-right: 5px; border-bottom: 1px solid black; " ><strong>Detalles de la Orden de Compra</strong></td>
	</tr>
</table>
</cfoutput>
<!----</cfoutput>--->

<table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
	<tr>
    	<td nowrap width="5%" class="tituloListas" style="padding-right: 5px;  border-bottom: 1px solid black;">SC</td>
		<td nowrap width="5%" class="tituloListas" style="padding-right: 5px;  border-bottom: 1px solid black;">Línea</td>
		<td width="17%" class="tituloListas" style="border-left: 1px solid black; padding-right: 5px; border-bottom: 1px solid black; ">C&oacute;digo</td>
		<td width="40%" class="tituloListas" style="border-left: 1px solid black; padding-right: 5px; border-bottom: 1px solid black; ">&Iacute;tem</td>
		<td width="2%" nowrap align="right" class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">Cant.</td>
		<td width="2%" nowrap align="right" class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">Cant.Surt.</td>
        <td width="2%" nowrap align="right" class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">Cant.Canc.</td>
		<td width="2%" nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black; ">Unidad</td>
		<td width="5%" nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black; ">Ctro Funcional</td>
		<td width="5%" nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black; ">Almacén</td>
		<td width="3%" nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black; ">Fecha Req.</td>
		<td width="10%" nowrap align="right" class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">Precio Unit.</td>
		<td width="2%" nowrap class="tituloListas" style="padding-right: 5px; border-bottom:  1px solid black; border-left: 1px solid black; ">Impuesto</td> 
		<td width="15%" align="right" nowrap class="tituloListas" style="padding-right: 5px;  border-bottom: 1px solid black; border-left: 1px solid black;">Total línea</td>
		<td width="15%" align="right" nowrap class="tituloListas" style="padding-right: 5px; border-top: 1px solid black; border-bottom: 1px solid black; border-left: 1px solid black;">Total Surtido</td>
		<td width="15%" align="right" nowrap class="tituloListas" style="padding-right: 5px; border-top: 1px solid black; border-bottom: 1px solid black; border-left: 1px solid black;">Total Cancel</td>
	</tr>
	<cfoutput query="qryLista"><!----group="EOidorden"> --->
		<cfif qryLista.RecordCount eq 1 and len(qryLista.DOlinea) eq 0>
		<tr class=<cfif (currentRow MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
			<td  align="center" colspan="<cfif not isdefined("url.imprimir")>13<cfelse>12</cfif>" style="padding-right: 5px; border-bottom: 1px solid black; text-align:center">&nbsp;-- No hay detalles en la Solicitud de Compra --&nbsp;</td>
		</tr>
		<cfelse>
		<tr class=<cfif (currentRow MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
        	<td style="padding-right: 5px; border-bottom: 1px solid black;">&nbsp;#ESnumero#-#DSconsecutivo#</td>
			<td width="5%" style="padding-right: 5px; border-bottom: 1px solid black;">&nbsp;#DOconsecutivo#&nbsp;</td>
			<td width="17%" style="border-left: 1px solid black;padding-right: 5px; border-bottom: 1px solid black;">&nbsp;#codigo#&nbsp;</td>
			<td width="40%" style="border-left: 1px solid black;padding-right: 5px; border-bottom: 1px solid black;">&nbsp;#DOdescripcion#&nbsp;</td>
			<td with="2%" align="center" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#DOcantidad#&nbsp;</td> 
			<td width="2%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#DOcantsurtida#&nbsp;</td>
            <td width="2%" align="center" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#DOcantcancel#</td>
			<td width="2%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#trim(Ucodigo)#&nbsp;</td>
			<td width="5%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#CFcodigo#&nbsp;</td>
			<td width="5%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#Almcodigo#&nbsp;</td>
			<td width="3%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#LSDateFormat(DOfechareq,'dd/mm/yyy')#&nbsp;</td>
			<td width="10%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#LvarOBJ_PrecioU.enCF_RPT(DOpreciou)#&nbsp;</td>
			<td width="5%" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#Icodigo# (#Iporcentaje#%)&nbsp;</td> 
			<td width="15%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#LSCurrencyFormat(DOtotal,'none')#&nbsp;</td>
			<td width="15%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#LSCurrencyFormat(DOmontoSurtido,'none')#&nbsp;</td>
			<td width="15%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">&nbsp;#LSCurrencyFormat(DOmontoCancelado,'none')#&nbsp;</td>
		</tr>
		
		<tr class=<cfif (currentRow MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
			<td style="padding-right: 5px; border-bottom: 1px solid black;">&nbsp;</td>
			<td style="padding-right: 5px; border-bottom: 1px solid black;" nowrap="nowrap"><strong>Descripci&oacute;n alterna:&nbsp;</strong></td>
			<td colspan="16" width="5%" style="padding-left: 5px; border-bottom: 1px solid black;">#DOalterna#&nbsp;</td>
		</tr>
		<tr class=<cfif (currentRow MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
			<td style="padding-right: 5px; border-bottom: 1px solid black;">&nbsp;</td>
			<td style="padding-right: 5px; border-bottom: 1px solid black;"><strong>Observaciones:&nbsp;</strong></td>
			<td colspan="16" width="5%" style="padding-left: 5px; border-bottom: 1px solid black;">#DOobservaciones#&nbsp;</td>
		</tr>

		</cfif>
</cfoutput>
</table>

<cfoutput>
<table width="99%" align="center"  border="0" cellspacing="2" cellpadding="2" style="border-top:1px solid black; ">
	<cfquery name="rsTotales" datasource="#session.DSN#">
		select coalesce(sum(DOtotal),0) as Subtotal
		from DOrdenCM 
		where EOidorden=#form.EOidorden#
		and  Ecodigo = #url.Ecodigo#
	</cfquery>
	<tr>
		<td rowspan="4" width="100%">&nbsp;</td>
		<td >Subtotal&nbsp;:&nbsp;</td>
		<td align="right">#LSCurrencyFormat(rsTotales.Subtotal,'none')#</td>
	</tr>
	<tr>
		<td >Descuentos&nbsp;:&nbsp;</td>
		<td align="right">#LSCurrencyFormat(qryLista.EOdesc,'none')#</td>
	</tr>
	<tr>
		<td >Impuestos&nbsp;:&nbsp;</td>
		<td align="right">#LSCurrencyFormat(qryLista.Impuesto,'none')#</td>
	</tr>
	<tr>
		<td ><strong>Total&nbsp;:&nbsp;</strong></td>
		<td align="right"><strong>#LSCurrencyFormat(qryLista.EOtotal,'none')#</strong></td>
	</tr>
</table> 
</cfoutput>

<cfif not isdefined("url.imprimir")>
<script type="text/javascript" language="javascript1.2" >
	function info(index){
		open('../consultas/RepOrden-info.cfm?index='+index, 'Orden','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=500,height=400,left=250, top=200,screenX=250,screenY=200');	
	}
</script>
</cfif>