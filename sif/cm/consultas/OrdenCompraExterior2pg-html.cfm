<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfif isdefined("rsTipoOC.EOnumero") and rsTipoOC.EOnumero NEQ 0>
	<cfset url.EOnumero = rsTipoOC.EOnumero>
</cfif>
<cfif isdefined("form.EOidorden") and len(trim(form.EOidorden)) and not isdefined("ulr.EOidorden")>
	<cfset url.EOidorden = form.EOidorden>
</cfif>

<cfquery name="data" datasource="#session.DSN#">
	select	EO.EOidorden,
			EO.CMCid, 
			Em.Edescripcion, 
			Em.EIdentificacion as iden,
			Em.EDireccion1 as dir1,
			Em.EDireccion2 as dir2,
			Dir.direccion1,
			Dir.codPostal,
			Emp.Etelefono1,
			Emp.Efax,
			EO.EOnumero, 
			EO.EOfecha,
			<cf_dbfunction name="dateadd" args="EO.EOdiasEntrega, EO.EOfecha"> as FechaArrivo,
			EO.EOtotal, 
			EO.EOplazo,
			((select min(CMFPdescripcion) from CMFormasPago fp where fp.CMFPid = EO.CMFPid)) as FormaPago,
			DO.DOconsecutivo,
			rtrim(coalesce(DO.DOalterna,'') #_Cat# ' - ' #_Cat#coalesce (DO.DOobservaciones,'')) as DOalterna,
			EO.CRid,
			coalesce(EO.EOtipotransporte,'') as EOtipotransporte,		
			
			case CMtipo 	when 'A' then ltrim(rtrim(f.Acodigo))#_Cat#'-'#_Cat#coalesce(DO.DOdescripcion, Adescripcion)
							when 'S' then ltrim(rtrim(h.Ccodigo ))#_Cat#'-'#_Cat#coalesce(DO.DOdescripcion, Cdescripcion)
							when 'F' then ltrim(rtrim(k.ACcodigodesc))#_Cat#'-'#_Cat#DO.DOdescripcion end as item,
			DO.Ucodigo,		
			DO.DOcantidad,
			#LvarOBJ_PrecioU.enSQL_AS("DO.DOpreciou")#,
			DO.DOtotal,
			imp.Iporcentaje,
			DO.DOtotal, 	
			DO.DOfechareq,	
			DO.DOmontodesc,	
			Mo.Mnombre,
			Mo.Msimbolo,
			Sn.SNidentificacion,
			Sn.SNnombre,
			Sn.SNtelefono,
			Sn.SNdireccion,
			Sn.SNcodigo,
			Sn.SNnumero,
			DSC.DSconsecutivo,
			DSC.ESnumero,
			case CMtipo 	when 'A' then DO.numparte
							when 'S' then '*'
							when 'F' then '*'
						end as numparte,
			inc.CMIcodigo #_Cat#' - '#_Cat#inc.CMIdescripcion as Incoterm,
			EO.EOImpresion,
			al.Almcodigo,
			al.Bdescripcion		
	from	EOrdenCM EO
			
			left outer join CMIncoterm inc
				on EO.CMIid = inc.CMIid
				and EO.Ecodigo = inc.Ecodigo
					
			inner join DOrdenCM DO

				left join Almacen al <!--- Se pone un left por que el campo Alm_Aid acepta nulos --->
						on al.Aid  = DO.Alm_Aid
			
				on  EO.EOidorden  = DO.EOidorden
				
				inner join Impuestos imp
					on DO.Icodigo = imp.Icodigo
					and DO.Ecodigo = imp.Ecodigo
	
				<!--- Articulos --->
				left outer join Articulos f
					on DO.Aid=f.Aid
					and DO.Ecodigo=f.Ecodigo
					and f.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  
				<!--- Conceptos --->
				left outer join Conceptos h
					on DO.Cid=h.Cid
					and DO.Ecodigo=h.Ecodigo
					and h.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	 
				<!--- Activos --->
				left outer join ACategoria j
					on DO.ACcodigo=j.ACcodigo
					and DO.Ecodigo=j.Ecodigo
	 
				left outer join AClasificacion k
					on DO.ACcodigo=k.ACcodigo
					and DO.ACid=k.ACid
					and DO.Ecodigo=k.Ecodigo
				
				left outer join DSolicitudCompraCM DSC
					on DO.Ecodigo = DSC.Ecodigo			
					and DO.DSlinea = DSC.DSlinea
	 
			inner join Monedas Mo
				on  EO.Ecodigo = Mo.Ecodigo
				and EO.Mcodigo = Mo.Mcodigo 
		
			inner join SNegocios Sn
				on EO.Ecodigo = Sn.Ecodigo
				and EO.SNcodigo = Sn.SNcodigo
				
			inner join Empresas Em
				on EO.Ecodigo = Em.Ecodigo
				
				inner join Empresa Emp
					on Em.EcodigoSDC=Emp.Ecodigo	
				
					inner join Direcciones Dir
						on Emp.id_direccion=Dir.id_direccion
				
	where 	
	<cfif isdefined ('url.EOidorden') >
		EO.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EOidorden#">
	<cfelse>
	    EO.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and EO.EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EOnumero#">
	</cfif>
	order by  DO.DOconsecutivo, numparte, item, EO.EOnumero
</cfquery>
<!--- Datos del Contacto del Proveedor 
	Por ahora se toma el primer contacto, no se ha definido algún criterio de selección,
	Nelson Bltonado, lo hablara mas adelante con Freddy Leyva.
	Rodolfo Jimenez Jara, SOIN, Centroamerica, 14/07/2005
--->
<cfquery name="rsSNContactos" datasource="#session.DSN#">
	select
		SNC.SNCnombre,
		SNC.SNCfax,
		SNC.SNCtelefono
	from EOrdenCM EO
	inner join SNegocios Sn
		on EO.Ecodigo = Sn.Ecodigo
		and EO.SNcodigo = Sn.SNcodigo
		left outer join SNContactos SNC
			on Sn.SNcodigo = SNC.SNcodigo
			and Sn.Ecodigo = SNC.Ecodigo
	where 	
        <cfif isdefined ('url.EOidorden') >
            EO.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EOidorden#">
        <cfelse>
	        EO.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
            and EO.EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EOnumero#">
        </cfif>
</cfquery>
<!--- datos de la empresa --->
<cfquery name="dataEmpresa" dbtype="query" maxrows="1">
	select	Edescripcion as enombre, 
			direccion1 as direccion,
			codPostal as apartado,
			Etelefono1 as telefono,
			Efax as fax
	from data
</cfquery>

<!--- datos de la empresa --->
<cfquery name="dataOrden" dbtype="query" maxrows="1">
	select	EOidorden
	from data
</cfquery>

<cfquery name="rsAutoriza" datasource="#session.DSN#">
	select * 
	from CMAutorizaOrdenes
	where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataOrden.EOidorden#">
</cfquery>

<cfif rsAutoriza.recordCount gt 0 >
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

<cfset pagina = 1 >
<!--- <cfdocument format="pdf" fontembed="yes" scale="100" unit="cm"> --->
<cfsavecontent variable="encabezado">
	<cfoutput>
	<style type="text/css">
		.areaNumero {
			BORDER-RIGHT: ##000000 2px solid;
			PADDING-RIGHT: 3px;
			BORDER-TOP: ##000000 2px solid;
			PADDING-LEFT: 3px;
			PADDING-BOTTOM: 3px;
			BORDER-LEFT: ##000000 2px solid;
			COLOR: ##000000;
			PADDING-TOP: 3px;
			BORDER-BOTTOM: ##000000 2px solid;
	
		}
	</style> 
	<!---<br style='page-break-after:always'>--->
	<table width="100%" border="0" align="center" cellpadding="1" cellspacing="0">
		<tr><td colspan="4"><HR size="1" color="##000000"></td></tr>
		<tr><td colspan="2" style="width:50%" height="10%"><font size="2"><strong>#dataEmpresa.Enombre#</strong></font></td>
			<td colspan="2" rowspan="5" align="right" style="width:90%" >
				<table style="width:100%" cellpadding="0" cellspacing="0" class="areaNumero" height="10%">
					<tr><td align="center"><strong><font size="2">MARKS</strong></font></td></tr>
					<tr><td align="center"><strong><font size="2">MARCAS</strong></font></td></tr>
					<tr><td align="center"><strong><font size="2">Coprole</strong></font></td></tr>
					<tr><td><font size="3"><strong>No. #data.EOnumero#</strong></font></td></tr>
					<tr><td nowrap>Please refer to the above<br> number in all invoices and <br> correspondence.<br>Favor referirse al n&uacute;mero<br> arriba indicado en las <br> 
					facturas y correspondencia</td>
					</tr>
				</table>
		  </td>
		</tr>
		<tr>
			<td width="7%" style="height:10%">PBX:</td>
			<td width="65%" style="height:10%">#dataEmpresa.telefono#</td>
		</tr>
		<tr>
			<td style="height:10%">Fax:&nbsp;</td>
			<td style="height:10%">#dataEmpresa.fax#</td>
		</tr>
		<tr>
			<td height="10%">Apartado:&nbsp;</td>
			<td height="10%">#dataEmpresa.apartado#</td>
		</tr>
		
		<tr>
		<td height="10%">NIT:&nbsp;</td>
		<td height="10%">#data.iden#&nbsp;</td>
		</tr>
		<tr>
		<td height="10%">Dirección:&nbsp;</td>
		<td height="10%">#data.dir1#&nbsp;/&nbsp;#data.dir2#&nbsp;</td>
		</tr>
		
		<tr><td colspan="2">&nbsp;</td></tr>		
		<tr><td colspan="4"><HR size="1" color="##000000"></td></tr>
	</table>
	</cfoutput>
</cfsavecontent>

<!--- DATOS DE PAGINA INICIAL  --->
<cfoutput>
<table width="99%" align="center" cellpadding="0" cellspacing="0">
	<tr><td>#encabezado#</td></tr>
	<cfset pagina = pagina + 1 >
	
	<cfquery name="dataEncabezado" dbtype="query" maxrows="1">
		select 	ESnumero, EOfecha, SNnombre, SNdireccion, Edescripcion, EOplazo, FormaPago, FechaArrivo, EOtotal, Mnombre, CRid, EOtipotransporte,
				Incoterm, EOImpresion
		from data
	</cfquery>

	<tr>
		<td>
			<table width="100%" border="0" cellpadding="4" cellspacing="0">
				<tr><td width="1%" nowrap>Tr&aacute;mite No.:</td><td colspan="3">#dataEncabezado.ESnumero#</td></tr>
				<tr><td>Date (Fecha):</td><td>#LSdateFormat(dataEncabezado.EOfecha,'dd/mm/yyyy')#</td></tr>
				<tr><td>Supplier (Casa Exportadora):</td><td colspan="3">#dataEncabezado.SNnombre#</td></tr>
				<tr><td>Address (Direcci&oacute;n):</td><td colspan="3">#dataEncabezado.SNdireccion#</td></tr>
				<tr><td>Representative (Representante):</td><td colspan="3">#rsSNContactos.SNCnombre#</td></tr>
				<tr><td>Phone (Tel&eacute;fono):</td><td colspan="3">#rsSNContactos.SNCtelefono#</td></tr>
				<tr><td>Fax (Representante):</td><td colspan="3">#rsSNContactos.SNCfax#</td></tr>
				<tr><td>Shipper(Embarcador):</td>
					<td colspan="3">
						<cfif isdefined ("dataEncabezado.CRid") and (dataEncabezado.CRid NEQ '')>
							<cfquery name="rsEmbarque" datasource="sifcontrol">
								select CRcodigo#_Cat#'-'#_Cat#CRdescripcion as embarque
								from Courier
								where CRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataEncabezado.CRid#">
							</cfquery>
							<cfoutput>#rsEmbarque.embarque#</cfoutput>
						</cfif>	
					</td>
				</tr>
				<tr><td>Shipment(Embarque):</td><td colspan="3">#dataEncabezado.EOtipotransporte#</td></tr>
				<tr>
				  <td nowrap>Consign and airmail documents to<br>
				    (Consignar y enviar documentos por v&iacute;a a&eacute;rea a):</td><td colspan="3">#dataEncabezado.Edescripcion#</td></tr>
				<tr><td>Terms of Payment (T&eacute;rminos de Pago):</td><td colspan="3">#dataEncabezado.FormaPago#</td></tr>
				<tr><td>Arrive date (Fecha de arribo):</td><td colspan="3">#LSdateFormat(dataEncabezado.FechaArrivo,'dd/mm/yyyy')#</td></tr>
				<tr><td>Incoterm:</td><td>#dataEncabezado.Incoterm#</td></tr>
				<tr><td>&nbsp;</td></tr>
				
				<cfif data.recordcount gt 5 >
					<tr>
						<td><font size="2">Monto Total:</font></td>
						<td><font size="2">#LSNumberFormat(dataEncabezado.EOtotal,',9.00')#</font></td>
						<td colspan="2">
							<table width="100%">
								<td width="1%" align="right">Moneda:</td>
								<td>#dataEncabezado.Mnombre#</td>
							</table>
						</td>
					</tr>
				</cfif>
			</table>
		</td>
	</tr>
	
	<cfif data.recordCount gt 5 >
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
	<cfelse>
		<tr><td colspan="2">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr class="titulolistas">
					<td width="6%" align="center"><strong>Line</strong></td>
					<td width="6%" align="center"><strong>Solic.</strong></td>
					<td width="33%"><strong>Description</strong></td>
					<td width="10%" nowrap>&nbsp;<strong>## Parts</strong></td>
					<td width="8%"><strong>UM</strong></td>
					<td width="12%" align="right"><strong>Quantity</strong></td>
					<td width="12%" align="right"><strong>Unit Price <br>Precio Unit</strong></td>
					<td width="12%" align="right"><strong>Total</strong></td>
					
				</tr>
				
				<cfloop query="data">
					<cfset vnImpuesto = (((data.DOtotal - data.DOmontodesc)*data.Iporcentaje)/100)> 
					<cfset vnMontoLinea = data.DOtotal + vnImpuesto - data.DOmontodesc>
					<!---#LSNumberFormat(data.DOtotal,',9.00')#----->

					<tr>
						<td align="center">#data.DOconsecutivo#</td>
						<td align="center">#data.ESnumero#</td>
						<td>#data.item#</td>
						<td>&nbsp;<cfif data.numparte NEQ '*'>#data.numparte#</cfif></td>
						<td>#data.Ucodigo#</td>
						<td align="right">#LSNumberFormat(data.DOcantidad,',9.00')#</td>
						<td align="right">#LvarOBJ_PrecioU.enCF_COMAS(data.DOpreciou)#</td>
						<td align="right">#LSNumberFormat(vnMontoLinea,',9.00')#</td>
						
					</tr>
					<tr>
						<td colspan="1" align="right">Bodega&nbsp;</td>
						<td colspan="6">#data.Almcodigo# -	#data.Bdescripcion#</td>
					</tr>
					<tr>
						<td width="12%" align="right"><strong>Observaciones:</strong></td>
						<td align="left" colspan="7">&nbsp;&nbsp;<cfif isdefined("data.DOalterna") and len(trim(data.DOalterna)) gt 0>#data.DOalterna#<cfelse>N/A</cfif></td>
					</tr>
				</cfloop>
				
				<cfquery name="rsTotal" dbtype="query" maxrows="1">
					select EOtotal
					from data
				</cfquery>
				
				<tr>
					<td colspan="7" align="right"><strong>Total: #data.Msimbolo#&nbsp;</strong></td>
					<td colspan="1" align="right"><strong>#LSNumberFormat(rsTotal.EOtotal,',9.0000')#</strong></td>
				</tr>
				<tr><td colspan="8" align="center">------------------ Fin del Reporte ------------------</td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td>&nbsp;</td></tr>
			</table>
		</td></tr>
	</cfif>

	<tr>
		<td colspan="4">
			<table width="100%" cellpadding="0" cellspacing="0">

				<tr>
					<td width="50%">&nbsp;</td>
					<td width="35%">
						<cfif isdefined("vCMCid") and len(trim(vCMCid))>
							<cfquery datasource="#session.dsn#" name="compradorts">
								select CMFfirma, ts_rversion 
								from CMFirmaComprador
								where CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vCMCid#">
							</cfquery>
							<cfif Len(compradorts.CMFfirma) GT 1>
								<cfinvoke component="sif.Componentes.DButils"
										  method="toTimeStamp"
										  returnvariable="tsurl">
									<cfinvokeargument name="arTimeStamp" value="#compradorts.ts_rversion#"/>
								</cfinvoke>
								<!--- Es para presentar la imagen tanto en el correo como en la consulta --->
								<cfif isdefined("form.btnEnviar")>
									<img src="CID:firma" ALT="IETF logo"> 
								<cfelse>
									<cfset ts2 = LSTimeFormat(Now(), 'hhmmss')> 
									<img src="/cfmx/sif/cm/catalogos/firma_comprador.cfm?CMCid=#vCMCid#&ts=#tsurl#&ts2=#ts2#" border="0">
								</cfif>
									
							</cfif>
						</cfif>
					</td>
					<td width="15%">&nbsp;</td>
				</tr>
				
				<tr>
					<td width="50%">&nbsp;</td>
					<td width="35%"><hr></td>
					<td width="15%">&nbsp;</td>
				</tr>

				<tr>
					<td width="50%">&nbsp;</td>
					<td width="35%">
						<cfif isdefined("vCMCid") and len(trim(vCMCid))>
							<cfquery name="rsComprador" datasource="#session.dsn#" >
								select CMCnombre 
								from CMCompradores 
								where CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vCMCid#">
							</cfquery>
							<cfif len(trim(rsComprador.CMCnombre)) GT 0>
								<strong>#rsComprador.CMCnombre#</strong>
							</cfif>
						</cfif>
					</td>
					<td width="15%">&nbsp;</td>
				</tr>
				
				<tr>
					<td colspan="3">&nbsp;</td>
				</tr>

				<tr>
					<td style="padding-left:80px;">Representante</td>
					<td colspan="2">P/ #dataEncabezado.Edescripcion#</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td><font size="-1">Important Instructions: Commercial invoices must be in SPANISH and FOUR copies 
	showing net and gross weights and SIGNED by shippers. The following legend must appear: Declaramos bajo 
	juramento que los precios y detalles de esta factura son verdaderos: Two original copies of Bill of 
	Landing but no consular invoices needed DO NOT INSURE, we are covered under a floating policy in 
	our country. <cfif len(trim(dataEncabezado.EOImpresion)) EQ 0>ORIGINAL - PROVEEDOR<cfelse>(COPIA - NO - NEGOCIABLE)</cfif></font></td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr><td><hr size="1" color="##000000"></td></tr>
	
	
</table>

</cfoutput>
<!--- </cfdocument> --->
<cfif data.recordCount gt 5 >
	<br style='page-break-after:always'>

	<!--- DATOS DE DETALLE --->
	<cfset contador = 0 >
	<cfoutput>
	
	<table width="99%" align="center" cellpadding="2" cellspacing="0">
		<cfloop query="data">
			<cfif contador eq 20 >
				<cfset pagina = pagina + 1 >
				<!---<br style='page-break-after:always'>--->
				<tr><td colspan="7">
				
					<br style='page-break-after:always'>
					<table width="100%" border="0" align="center" cellpadding="3" cellspacing="0">
						<tr><td colspan="4"><HR size="1" color="##000000"></td></tr>
						<tr><td colspan="3"><font size="2"><strong>#dataEmpresa.Enombre#</strong></font></td></tr>
						<tr>
							<td width="1%">Tel&eacute;fono:&nbsp;</td>
							<td width="80%">#dataEmpresa.telefono#</td>
						</tr>
						<tr>
							<td>Fax:&nbsp;</td>
							<td>#dataEmpresa.fax#</td>
						</tr>
						<tr>
							<td>Apartado:&nbsp;</td>
							<td>#dataEmpresa.apartado#</td>
						<tr>
							<td colspan="4" align="right">
								<table width="30%" cellpadding="0" cellspacing="0" class="areaNumero">
									<tr><td align="center"><font size="2"><strong>MARKS</strong></font></td></tr>
									<tr><td align="center"><font size="2"><strong>MARCAS</strong></font></td></tr>
									<tr><td align="center"><font size="2"><strong>Coprole</strong></font></td></tr>
									<tr><td><font size="3"><strong>No. #data.EOnumero#</strong></font></td></tr>
									<tr><td>Please refer to the above number in all invoices and correspondance.<br>
									Favor referirse al n&uacute;mero arriba indicado en las facturas y correspondencia. </td>
									</tr>
								</table>
							</td>
						</tr>
						<tr><td colspan="4"><HR size="1" color="##000000"></td></tr>
					</table>
				
				</td></tr>
				<tr class="titulolistas">
					<td><strong>Line</strong></td>
					<td><strong>Solic.</strong></td>
					<td><strong>Description</strong></td>
					<td><strong>UM</strong></td>
					<td><strong>Quatity</strong></td>
					<td><strong>Unit Price <br>Precio Unit</strong></td>
					<td><strong>Total</strong></td>
				</tr>
				<cfset contador = 0 >
			<cfelseif data.currentrow eq 1 >
				<tr><td colspan="7">
					<table width="100%" border="0" align="center" cellpadding="3" cellspacing="0">
						<tr><td colspan="4"><HR size="1" color="##000000"></td></tr>
						<tr><td colspan="3"><font size="2"><strong>#dataEmpresa.Enombre#</strong></font></td></tr>
						<tr>
							<td width="1%">Tel&eacute;fono:&nbsp;</td>
							<td width="80%">#dataEmpresa.telefono#</td>
						</tr>
						<tr>
							<td>Fax:&nbsp;</td>
							<td>#dataEmpresa.fax#</td>
						</tr>
						
						<tr>
							<td>Apartado:&nbsp;</td>
							<td>#dataEmpresa.apartado#</td>
						<tr>
							<td colspan="4" align="right">
								<table width="30%" cellpadding="0" cellspacing="0" class="areaNumero">
									<tr><td align="center"><font size="2"><strong>MARKS</strong></font></td></tr>
									<tr><td align="center"><font size="2"><strong>MARCAS</strong></font></td></tr>
									<tr><td align="center"><font size="2"><strong>Coprole</strong></font></td></tr>
									<tr><td><font size="3"><font size="3"><strong>No. #data.EOnumero#</strong></font></td></tr>
									<tr><td>Please refer to the above number in all invoices and correspondance.<br>Favor referirse al n&uacute;mero arriba indicado en las facturas y correspondencia</td></tr>
								</table>
							</td>
						</tr>
						<tr><td colspan="4"><HR size="1" color="##000000"></td></tr>
					</table>
				</td></tr>
	
				<tr class="titulolistas">
					<td><strong>Line</strong></td>
					<td><strong>Solic.</strong></td>
					<td><strong>Description</strong></td>
					<td><strong>UM</strong></td>
					<td align="right"><strong>Quatity</strong></td>
					<td align="right"><strong>Unit Price <br>Precio Unit</strong></td>
					<td align="right"><strong>Total</strong></td>
				</tr>
			</cfif>
			<tr>
				<td align="center">#data.DOconsecutivo#</td>
				<td align="center">#data.ESnumero#</td>
				<td>#data.item#</td>
				<td>#data.Ucodigo#</td>
				<td align="right">#LSNumberFormat(data.DOcantidad,',9.00')#</td>
				<td align="right">#LvarOBJ_PrecioU.enCF_COMAS(data.DOpreciou)#</td>
				<td align="right">#LSNumberFormat(data.DOtotal,',9.00')#</td>
			</tr>
			<tr>
				<td colspan="1" align="right">Bodega&nbsp;</td>
				<td colspan="6">#data.Almcodigo# -	#data.Bdescripcion#</td>
			</tr>
			<tr>
				<td width="1%" align="right"><strong>Observaciones:</strong></td>
				<td align="left" colspan="7">&nbsp;&nbsp;<cfif isdefined("data.DOalterna") and len(trim(data.DOalterna)) gt 0>#data.DOalterna#<cfelse>N/A</cfif></td>
			</tr>
			
			<cfset contador = contador + 1 >
		</cfloop>
	
		<cfquery name="rsTotal" dbtype="query" maxrows="1">
			select EOtotal
			from data
		</cfquery>
		
		<tr>
			<td colspan="5" align="right"><strong><font size="2">Total:</font></strong></td>
			<td colspan="2" align="right"><strong><font size="2">#LSNumberFormat(rsTotal.EOtotal,',9.00')#</font></strong></td>
		</tr>
	
  </cfoutput>
		<tr><td colspan="7" align="center">------------------ Fin del Reporte ------------------</td></tr>
	</table>
</cfif>
<!----Verificar el estado de la impresion de la OC
	'I' = Impresa la primera vez 
	' ' = Nunca se ha impreso
	'R' = Reimpresion ----->
<cfquery name="rsEstadoImpresion" datasource="#session.DSN#">
	select ltrim(rtrim(EOImpresion)) as EOImpresion from EOrdenCM 
	where
		<cfif isdefined ('url.EOidorden') >
            EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EOidorden#">
        <cfelse>
	        Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            and EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EOnumero#">
        </cfif>
</cfquery>

<!----ACTUALIZAR EL ESTADO DE LA IMPRESION DE LA OC----->
<cfif isdefined("url.Imprimir") and len(trim(rsEstadoImpresion.EOImpresion)) EQ 0><!----Si la OC todavia no ha sido impresa por primera vez---->
	<cfquery datasource="#session.DSN#">
		update EOrdenCM
		set EOImpresion='I'
		where
		<cfif isdefined ('url.EOidorden') >
            EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EOidorden#">
        <cfelse>
	        Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            and EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EOnumero#">
        </cfif>
	</cfquery>	 	
<cfelseif isdefined("url.Imprimir")>
	<cfquery datasource="#session.DSN#">
		update EOrdenCM
		set EOImpresion='R'
		where
		<cfif isdefined ('url.EOidorden') >
            EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EOidorden#">
        <cfelse>
	        Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            and EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EOnumero#">
        </cfif>
	</cfquery>
</cfif>
