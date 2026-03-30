<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>

<cfif isdefined("url.EDRid") and not isdefined("Form.EDRid")>
	<cfset Form.EDRid = url.EDRid>
</cfif>
<cfquery name="rsReclamos" datasource="#session.DSN#"><!---Datos del documento  de reclamo---->
	select 	ed.EPDid,
			ed.EDRestado,
			DDRlinea,
			dd.Icodigo,
			coalesce(i.Iporcentaje,0) as Iporcentaje, 			<!----Porcentaje de impuesto del documento de recepcion---->
			i.Idescripcion,		
			o.Icodigo as IcodigoOC,
			coalesce(imp.Iporcentaje,0) as IporcentajeOC,		<!----Porcentaje de impuesto de la OC---->
			imp.Idescripcion as IdescripcionOC,
			o.DOcantidad - o.DOcantsurtida as DOcantsaldo,					<!--- Cantidad del saldo en la linea de la orden de compra --->
			dd.Aid,
			Acodigo,
			Adescripcion,
			dd.DDRtipoitem,
			dd.Cid,
			c.Ccodigo,
			c.Cdescripcion,
			dd.DOlinea,
			ed.EDRnumero,
			EDRfecharec,
			EDRobs,
			ed.SNcodigo,
			SNnumero,
			SNnombre,
			SNidentificacion,
			coalesce(DDRcantorigen,0) as DDRcantorigen,
			coalesce(DDRcantrec,0) as DDRcantrec,
			#LvarOBJ_PrecioU.enSQL_AS("coalesce(DDRpreciou,0)", "DDRpreciou")#,
			#LvarOBJ_PrecioU.enSQL_AS("coalesce(DDRprecioorig,0)", "DDRprecioorig")#,
			coalesce(DDRcantreclamo,0) as DDRcantreclamo,
			dd.DOlinea, 
			coalesce((select  min(MontoReclamo)
				from DReclamos rec
				where rec.DDRlinea = dd.DDRlinea),0) as MontoReclamo,
			coalesce((select  min(UnidadesReclamo)
				from DReclamos rec
				where rec.DDRlinea = dd.DDRlinea),0) as UnidadesReclamo,
			coalesce((select  min(UnidadesNoRecibidas)
				from DReclamos rec
				where rec.DDRlinea = dd.DDRlinea),0) as UnidadesNoRecibidas,
			
			p.EOnumero,
			coalesce(o.DOcantidad,0) as DOcantidad,
			coalesce(o.DOcantsurtida,0) as DOcantsurtida,
			dd.DDRobsreclamo,
			coalesce(o.DOmontodesc,0) as DOmontodesc,
			coalesce(o.DOporcdesc,0) as DOporcdesc,
			case 
				when dd.DDRaprobtolerancia = 10 then 1
				else 0
			end DDRaprobtolerancia,			
			coalesce(dd.DDRdescporclin,0) as DDRdescporclin,
			case 
				when (dd.DDRgenreclamo = 1)  and 
					(dd.DDRaprobtolerancia is null or
					dd.DDRaprobtolerancia = 0 or
					dd.DDRaprobtolerancia = 5 or
					dd.DDRaprobtolerancia=20)
											then ((coalesce(clas.Ctolerancia, 0) / 100) * (o.DOcantidad - o.DOcantsurtida))
				else 0
			end Ctolerancia,				<!--- Tolerancia del articulo --->
			case when clas.Ctolerancia is null then 'F'
				 else 'V'
			end as ArticuloTieneTolerancia,
			coalesce(dd.DDRdesclinea,0) as DDRdesclinea,
			o.DOconsecutivo,
			ed.Mcodigo,
			p.Mcodigo as McodigoOC,
			ed.EDRtc,
			p.EOtc,
			case when o.Ucodigo = dd.Ucodigo then 1
				 when cu.CUfactor is not null then cu.CUfactor
				 when cua.CUAfactor is not null then cua.CUAfactor
				 else case when dd.DDRcantorigen = 0 then 0
						   else dd.DDRcantordenconv / dd.DDRcantorigen
						   end
				 end as factorConversionU,									<!--- Factor de conversion (factura a orden) --->	
			mon.Mnombre,
			tra.ETconsecutivo	
	from  EDocumentosRecepcion ed
	
			left outer join EPolizaDesalmacenaje pol
				on ed.EPDid = pol.EPDid
				and ed.Ecodigo = pol.Ecodigo
			   
		   left outer join ETracking tra		  
				on  <cf_dbfunction name="to_number" args="pol.EPembarque"> = tra.ETidtracking
				and pol.Ecodigo = tra.Ecodigo
	
		left outer join Monedas mon
			on ed.Mcodigo = mon.Mcodigo
			and ed.Ecodigo = mon.Ecodigo

		 inner join DDocumentosRecepcion dd
			on dd.EDRid=ed.EDRid
			and dd.Ecodigo=ed.Ecodigo
			and dd.DDRgenreclamo = 1
		
		inner join SNegocios sn
			on sn.SNcodigo=ed.SNcodigo
			and sn.Ecodigo=ed.Ecodigo

	 	inner join DOrdenCM o
			on o.DOlinea = dd.DOlinea
			
			inner join EOrdenCM p
				on o.EOidorden = p.EOidorden

			<!---Impuestos de la orden de compra---->
	  		left outer join Impuestos imp
				on imp.Ecodigo=o.Ecodigo
				and imp.Icodigo=o.Icodigo

		  	left outer join Articulos a
				on a.Ecodigo=dd.Ecodigo
				and a.Aid=dd.Aid

				left outer join Clasificaciones clas
					on clas.Ccodigo = a.Ccodigo
					and clas.Ecodigo = a.Ecodigo
			
				<!--- Factor de conversion de factura a orden si no estaba definido en la tabla ConversionUnidades --->			
				left outer join ConversionUnidadesArt cua
					on cua.Aid = a.Aid
					and a.Ucodigo = dd.Ucodigo
					and cua.Ucodigo = o.Ucodigo
					and cua.Ecodigo = dd.Ecodigo
					
		<!--- Factor de conversion de factura a orden --->
		left outer join ConversionUnidades cu
			on cu.Ecodigo = dd.Ecodigo
			and cu.Ucodigo = dd.Ucodigo
			and cu.Ucodigoref = o.Ucodigo					

	 	 left outer join Conceptos c
			on c.Ecodigo=dd.Ecodigo
			and c.Cid=dd.Cid

		<!---Impuestos del documento de recepcion--->
	  	left outer join Impuestos i
			on i.Ecodigo=dd.Ecodigo
			and i.Icodigo=dd.Icodigo

	where ed.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and ed.EDRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
	order by dd.DOlinea
</cfquery>


<cfif isdefined('rsReclamos') and rsReclamos.recordCount GT 0>
	<cfquery name="rsRepresentante" maxrows="1" datasource="#session.DSN#">
		select SNCnombre,SNCidentificacion
		from SNContactos
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and SNcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReclamos.SNcodigo#">
	</cfquery>
</cfif>
<style type="text/css">
<!--
.style1 {font-weight: bold}
.style2 {
	color: #FF0000;
	font-weight: bold;
}
-->
</style>


<cfif isdefined('rsReclamos') and rsReclamos.recordCount GT 0>
	<table width="100%"  border="0" cellspacing="0" cellpadding="1">
		<tr><td colspan="14">&nbsp;</td></tr>			
		<tr bgcolor="#CCCCCC">
		<td colspan="14" align="center"><strong><cfoutput>#session.CEnombre#</cfoutput></strong></td></tr>			
		<tr bgcolor="#CCCCCC"><td colspan="14" class="navbar" align="center" ><strong>Documento de Reclamo</strong></td></tr>
		<tr><td colspan="14">&nbsp;</td></tr>
		<tr>
			<td colspan="14">
				<cfset vnMontoReclamo = 0>
				<cfoutput>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td width="17%" align="right" nowrap><strong>N&uacute;mero de Reclamo:</strong></td>
						<td width="41%">&nbsp;&nbsp;#rsReclamos.EDRnumero#</td>
						<td width="11%" align="right"><strong>Proveedor: </strong></td>
						<td width="31%" nowrap>&nbsp;&nbsp;(#rsReclamos.SNnumero#) - #rsReclamos.SNnombre#</td>
					  </tr>
					  <tr>
						<td align="right"><strong>Fecha del Reclamo:</strong></td>
						<td>&nbsp;&nbsp;#LSDateFormat(rsReclamos.EDRfechaRec, "mm/dd/yyyy")#</td>
						<td align="right" nowrap><strong>C&eacute;dula Jur&iacute;dica:</strong></td>
						<td>&nbsp;&nbsp;#rsReclamos.SNidentificacion#</td>
					  </tr>
					  <tr>
						<td align="right"><strong>Ingresado por:</strong></td>
						<td>&nbsp;&nbsp;#session.usulogin#</td>
						<td align="right"><strong>Observaciones:</strong></td>
						<td >&nbsp;&nbsp;
							<cfif rsReclamos.EDRobs NEQ ''>
								#rsReclamos.EDRobs#
							<cfelse>
								- No se registraron observaciones - 
							</cfif>
						</td>					  
					  </tr>
					  <tr>
						<td align="right"><strong>Número de factura:</strong></td>
						<td>&nbsp;&nbsp;#rsReclamos.EDRnumero#</td>
						<td align="right"><strong>Moneda:</strong></td>
						<td>&nbsp;&nbsp;#rsReclamos.Mnombre#</td>
					  </tr>
					  <tr>
					  	<td align="right"><strong>No Tracking:</strong></td>
						<td>&nbsp;&nbsp;<cfif len(trim(rsReclamos.ETconsecutivo))>#rsReclamos.ETconsecutivo#<cfelse>---</cfif></td>
					  </tr>
					</table>
				</cfoutput>
				<hr>
			</td>
		</tr>
		<tr bgcolor="#666666"><td colspan="14" nowrap><span class="style1">Detalle del Reclamo</span></td></tr>
		<tr class="areaFiltro">
			<td width="3%"><strong>Línea&nbsp;</strong></td>
			<td width="4%"><strong>No.OC&nbsp;</strong></td>
			<!----<td width="60%"><strong>Item&nbsp;</strong></td>----->
			<td width="3%" align="right"><strong>Cantidad<br>Factura&nbsp;</strong></td>
			<td nowrap align="right" width="3%"><strong>&nbsp;Cantidad<br>&nbsp;Recibida&nbsp;</strong></td>
			<td nowrap width="3%" align="right"><strong>&nbsp;Cantidad<br>&nbsp;Reclamada</strong></td>			
			<td nowrap width="3%" align="right"><strong>&nbsp;Cantidad<br>&nbsp;Excedida</strong></td>						
			<td nowrap align="right" width="10%"><strong>&nbsp;Precio Unit. OC </strong></td>
			<td nowrap align="right" width="10%"><strong>&nbsp;Precio Unit. Fact.</strong></td>
			<td nowrap align="right" width="10%"><strong>&nbsp;Desc.OC</strong></td>
			<td nowrap align="right" width="10%"><strong>&nbsp;Desc.Fact.</strong></td>
			<td nowrap align="right" width="10%"><strong>&nbsp;Imp. OC</strong></td>
			<td nowrap align="right" width="10%"><strong>&nbsp;Imp. Fact.</strong></td>
			<td nowrap align="right" width="20%"><strong>&nbsp;Total l&iacute;nea reclamo</strong></td>
		</tr>
		<cfoutput query="rsReclamos">
			<cfset LvarListaNon = (CurrentRow MOD 2)>
			<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
				<td width="3%">&nbsp;#rsReclamos.DOconsecutivo#</td>
				<td width="4%">&nbsp;#rsReclamos.EOnumero#</td>

				<td width="3%" align="center">&nbsp;#rsReclamos.DDRcantorigen#</td>
				<td align="center" width="3%">&nbsp;#DDRcantrec#</td>
				<td align="center" width="3%">&nbsp;#rsReclamos.UnidadesNoRecibidas#</td>
				
				<td align="center" width="3%">&nbsp;#rsReclamos.UnidadesReclamo#</td>
				
				<td align="right" width="3%">&nbsp;#LvarOBJ_PrecioU.enCF_RPT(DDRprecioorig)#</td>
				<td align="right" width="3%">&nbsp;#LvarOBJ_PrecioU.enCF_RPT(DDRpreciou)#</td>
				<td align="right" width="10%">&nbsp;#LSNumberFormat(rsReclamos.DOmontodesc,',9.00')#</td>
				<td align="right" width="10%">&nbsp;#LSNumberFormat(rsReclamos.DDRdesclinea,',9.00')#</td>				
				<td align="right" width="10%">&nbsp;#IporcentajeOC# %</td>
				<td align="right" width="10%">&nbsp;
					<cfif rsReclamos.EPDid NEQ ''>
						0.00 %
					<cfelse>
						#Iporcentaje# %
					</cfif>				
				</td>
				<td width="10%" align="right">
				&nbsp;#LSNumberFormat(rsReclamos.MontoReclamo,',9.00')#			
				<cfset vnMontoReclamo = vnMontoReclamo + rsReclamos.MontoReclamo>									  																	  				
				</td>
			</tr>
			<tr>
				<td colspan="14">
					<strong>Item:</strong>&nbsp;
					<cfif Aid NEQ ''>
						&nbsp;#Acodigo#-#Adescripcion#
					<cfelse>
						&nbsp;#Ccodigo#-#Cdescripcion#
					</cfif>
				</td>
			</tr>
			<tr>
				<td colspan="14"><strong>Observaciones:&nbsp;</strong><cfif len(trim(DDRobsreclamo))>#DDRobsreclamo#<cfelse>&nbsp;---&nbsp;</cfif></td>
			</tr>
		</cfoutput>		  
		<tr>
			<td colspan="11">&nbsp;</td>			
			<td nowrap align="right" style="border-top:1px solid black;"><strong><font style="font-size:10px">Total del reclamo:&nbsp;</font></strong></td>
			<td nowrap align="right" style="border-top:1px solid black;"><strong><font style="font-size:10px"><cfoutput>#LSNumberFormat(vnMontoReclamo,',9.00')#</cfoutput></font></strong></td>
		</tr>
		<tr><td colspan="14">&nbsp;</td></tr>	
		<tr><td colspan="14"><hr></td></tr>				  
		<tr><td colspan="14">&nbsp;</td></tr>							  
		<tr><td colspan="14">&nbsp;</td></tr>							  
		<tr><td colspan="14">&nbsp;</td></tr>							  
		<tr><td colspan="14">&nbsp;</td></tr>				  			  
		<tr>
			<td colspan="14" align="center">			    
				<cfif isdefined('rsRepresentante') and rsRepresentante.recordCount GT 0>
					  <cfoutput>
						  (#rsRepresentante.SNCnombre#,#rsRepresentante.SNCidentificacion#)
						  <hr>
						  <br>
					  </cfoutput>
			  </cfif>
				  Representante del Proveedor
			</td>
		</tr>			
		<tr>
			<td colspan="14" align="right"></td>
		</tr>  
		<tr><td colspan="14" align="center">La firma de este documento faculta a la Cooperativa a hacer la deducción correspondiente</td></tr>			  
		<tr><td colspan="14">&nbsp;</td></tr>				  			  
  </table>					
	<cfelse>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td colspan="14" align="center"><span class="style2">Error, no existen documentos de reclamos</span></td>
          </tr>
          <tr>
            <td colspan="14">&nbsp;</td>
          </tr>
        </table>
</cfif>
<!----<cfdump var="#vnmonto#">---->

