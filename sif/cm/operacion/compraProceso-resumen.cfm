<cfif modo EQ "CAMBIO">
	<cfinclude template="../../Utiles/sifConcat.cfm">
	<cfquery name="rsProcesoCompra" datasource="#Session.DSN#">
		select 
			tgc.TGdescripcion as TGdescripcionC,
			tgp.TGdescripcion as TGdescripcionP,
			a.CMPid, 
			a.CMPdescripcion, 
			a.GCcritid, 
			a.Usucodigo, 
			a.fechaalta, 
			a.CMPfechapublica, 
			a.CMPfmaxofertas, 
			a.CMPestado,
			a.CMPnumero,
			a.CMFPid,
			a.CMIid,
			a.CMPcodigoProceso,
			b.GCcritdesc,
			rtrim(c.CMIcodigo) #_Cat# ' - ' #_Cat# c.CMIdescripcion as Incoterm,
			d.CMFPdescripcion as FormaPago
		from CMProcesoCompra a
			
			left outer join GruposCriteriosCM b
			on a.GCcritid = b.GCcritid
			and a.Ecodigo = b.Ecodigo
			
			left outer join CMIncoterm c
			on a.Ecodigo = c.Ecodigo
			and a.CMIid = c.CMIid
			
			left outer join CMFormasPago d
			on a.Ecodigo = d.Ecodigo
			and a.CMFPid = d.CMFPid
			
		  left outer join TiposGarantia tgc
				on tgc.TGid  = a.TGidC
				  
		  left outer join TiposGarantia tgp
				on tgp.TGid  = a.TGidP 			
			
		where a.CMPid = #Session.Compras.ProcesoCompra.CMPid#
		and a.Ecodigo = #Session.Ecodigo#
	</cfquery>

	<cfquery name="rsCondicionesProceso" datasource="#Session.DSN#">
		select a.CCid, a.CPpeso, b.CCdesc
		from CMCondicionesProceso a, CCriteriosCM b
		where a.CMPid = #Session.Compras.ProcesoCompra.CMPid#
		and a.CCid = b.CCid
	</cfquery>
    
    <cf_dbfunction name="to_char" args="e.DSlinea" returnvariable="DSlinea">
    <cf_dbfunction name="concat"  args="'<a href=''##'' onclick=''javascript:return AlmacenarObjetos('+ #PreserveSingleQuotes(DSlinea)# +');''><img border=''0'' id=''img'+ #PreserveSingleQuotes(DSlinea)# +'''  src=''/cfmx/sif/imagenes/OP/folder-go.gif''>'" returnvariable="DocAD" delimiters="+">
                    <cf_dbfunction name="concat"  args="'<a href=''##'' onclick=''javascript:return AlmacenarObjetos('+ #PreserveSingleQuotes(DSlinea)# +');''><img border=''0'' id=''img'+ #PreserveSingleQuotes(DSlinea)# +'''  src=''/cfmx/sif/imagenes/ftv2folderopen.gif''>'" returnvariable="DocSAD" delimiters="+">
	<cfquery name="rsDetalleProcesoCompra" datasource="#Session.DSN#">
		select a.ESidsolicitud, b.CMTSdescripcion, a.ESnumero, a.ESobservacion, a.ESfecha, c.CFcodigo, c.CFdescripcion, d.CMSnombre, 
			   e.DSlinea, e.DSdescripcion, e.DScant, f.Udescripcion,
			   g.CFcodigo as CFcodigoDet, g.CFdescripcion as CFdescripcionDet,
			   case e.DStipo when 'A' then (select min(Acodigo) from Articulos x where x.Ecodigo = e.Ecodigo and x.Aid = e.Aid) 
							 when 'S' then (select min(Ccodigo) from Conceptos x where x.Ecodigo = e.Ecodigo and x.Cid = e.Cid) 
							 else ''
			   end as CodigoItem,
			   e.DScant - e.DScantsurt as CantDisponible, b.CMTSaprobarsolicitante,
               case when (select count(*) from DDocumentosAdjuntos dax where dax.DSlinea= e.DSlinea) > 0
                                     		then #PreserveSingleQuotes(DocAD)# 
                                            else #PreserveSingleQuotes(DocSAD)# 
                                            end as Doc
		from ESolicitudCompraCM a
		
			 inner join CMTiposSolicitud b
				on a.Ecodigo = b.Ecodigo
				and a.CMTScodigo = b.CMTScodigo
				and b.CMTScompradirecta = 0
			 
			 inner join CFuncional c
				on a.Ecodigo = c.Ecodigo
				and a.CFid = c.CFid
			 
			 inner join CMSolicitantes d
				on a.Ecodigo = d.Ecodigo
				and a.CMSid = d.CMSid
			 
			 inner join DSolicitudCompraCM e
				on a.Ecodigo = e.Ecodigo
				and a.ESidsolicitud = e.ESidsolicitud
				and e.DSlinea in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.ProcesoCompra.DSlinea#" list="yes" separator=",">)
			 
			 inner join Unidades f
				on e.Ecodigo = f.Ecodigo
				and e.Ucodigo = f.Ucodigo

			left outer join CFuncional g
				on e.CFid = g.CFid
			 
		where a.Ecodigo = #lvarFiltroEcodigo#
		and a.ESestado in (20,40)
	</cfquery>
		
	<cfquery name="rsSolicitudes" dbtype="query">
		select distinct ESidsolicitud, CMTSdescripcion, ESnumero, ESobservacion, ESfecha, CFcodigo, CFdescripcion, CMSnombre
		from rsDetalleProcesoCompra
		order by ESnumero
	</cfquery>
    
    <cfquery name="rsAprobarSolicitante" dbtype="query">
		select count(1) as cantidad
		from rsDetalleProcesoCompra
		where CMTSaprobarsolicitante = 1
	</cfquery>

	<cfquery name="rsProveedores" datasource="#Session.DSN#">
		select a.CMPlinea, b.SNcodigo, b.SNnumero, b.SNnombre
		from CMProveedoresProceso a, SNegocios b
		where a.CMPid = #Session.Compras.ProcesoCompra.CMPid#
		and a.Ecodigo  = #Session.Ecodigo#
		and a.Ecodigo = b.Ecodigo
		and a.SNcodigo = b.SNcodigo
		and b.SNtiposocio <> 'C'
		order by b.SNnumero
	</cfquery>

</cfif>
<script language="JavaScript" type="text/javascript">
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function ConlisReporte(opcion) {		
		//La variable local es para indicar cual archivo jasper mostrar: 0= Solicitud de cotización de importación 1: Solicitud de cotización local 
		//el parametro opcion indica a)'proveedor': Cuando se imprimira la cotización por proveedor b) 'proceso': Se imprimiran todas las líneas de la cotización
		if (opcion == 'proveedor'){
			if (confirm('¿Presione ACEPTAR si desea imprimir la solicitud local y CANCELAR para imprimir la solicitud de Importación?')) 
				{local = 1} 
			else 
				{local = 0}				
			var params = "";
				params = "?CMPid=" + <cfoutput>#Session.Compras.ProcesoCompra.CMPid#</cfoutput>+"&local="+local+"&opcion=proveedor"
			popUpWindow("/cfmx/sif/cm/operacion/ConlisReporte.cfm"+params,50,50,1100,800);
		}
		else{
			if (confirm('¿Presione ACEPTAR si desea imprimir la solicitud local y CANCELAR para imprimir la solicitud de Importación?')) 
				{local = 1} 
			else 
				{local = 0}				
			var params = "";
				params = "?CMPid=" + <cfoutput>#Session.Compras.ProcesoCompra.CMPid#</cfoutput>+"&local="+local+"&opcion=proceso";
				popUpWindow("/cfmx/sif/cm/operacion/ConlisReporte.cfm"+params,50,50,1100,800);		
		}
	}
	
	function ConliSociosNoinvitados(vnValor) {		
		//vnTodos indica que: 1:Se seleccionaron algunos proveedores, 0:Se seleccionaron TODOS  
		if (vnValor > 0){ 
			popUpWindow("/cfmx/sif/cm/operacion/compraProceso-ProvNoInvitacion.cfm?vnTodos=1",250,200,650,400);
		}
		else{popUpWindow("/cfmx/sif/cm/operacion/compraProceso-ProvNoInvitacion.cfm?vnTodos=0",250,200,650,400);}
	}
	function AlmacenarObjetos(valor){
		if (valor != ""){			
			var PARAM  = "ObjetosSolicitudes.cfm?Modulo=SC&DSlinea1="+valor;
			open(PARAM,'','left=50,top=150,scrollbars=yes,resizable=no,width=1000,height=400');	
		}
		return false;
	}	
</script>
<cfoutput>

<form name="form1" method="post" action="#GetFileFromPath(GetTemplatePath())#">
	<input type="hidden" name="opt" value="">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	  </tr>
	  <cfif modo EQ "CAMBIO">
	  <tr>
	  	<td colspan="2">
			<table width="98%"  border="0" cellspacing="0" cellpadding="0" align="center">
			  <tr>
				<td colspan="2" class="tituloListas">Datos del Proceso de Compra</td>
			  </tr>
			  <tr>
				<td nowrap valign="top">
					<table width="100%"  border="0" cellspacing="0" cellpadding="2">
					  <tr>
                        <td class="fileLabel" align="right">N&uacute;mero:</td>
                        <td>
                          #rsProcesoCompra.CMPnumero#
                        </td>
				      </tr>
					  <tr>
						<td class="fileLabel" align="right">Descripci&oacute;n:</td>
						<td>
							#rsProcesoCompra.CMPdescripcion#
						</td>
					  </tr>
					   <tr>
						<td class="fileLabel" align="right">c&oacute;digo del proceso:</td>
						<td>
							#rsProcesoCompra.CMPcodigoProceso#
						</td>
					  </tr>
					  <tr>
						<td class="fileLabel" align="right">Fecha de Publicaci&oacute;n:</td>
						<td>
							#LSDateFormat(rsProcesoCompra.CMPfechapublica, 'dd/mm/yyyy')#
						</td>
					  </tr>
					  <tr>
						<td class="fileLabel" align="right">Fecha M&aacute;xima para Cotizaci&oacute;n:</td>
						<td>
							#LSDateFormat(rsProcesoCompra.CMPfmaxofertas, 'dd/mm/yyyy')# &nbsp; - &nbsp; #LSTimeFormat(rsProcesoCompra.CMPfmaxofertas,"hh:mm tt")#
							
						</td>
					  </tr>
					  <tr>
                        <td class="fileLabel" align="right">Forma de pago:</td>
                        <td>
						  <cfif len(Trim(rsProcesoCompra.FormaPago)) EQ 0>
							--Ninguno--
						  <cfelse>
							#rsProcesoCompra.FormaPago#
						  </cfif>
                        </td>
				      </tr>
					  <tr>
                        <td class="fileLabel" align="right">Incoterm:</td>
                        <td>
						  <cfif Trim(rsProcesoCompra.Incoterm) EQ "-">
							--Ninguno--
						  <cfelse>
							#rsProcesoCompra.Incoterm#
						  </cfif>
                        </td>
				      </tr>
						
					  <tr>
						<td class="fileLabel" align="right">Garantía - Cumplimiento:</td>
						<td>
							#rsProcesoCompra.TGdescripcionC#
							
						</td>
					  </tr>
					  
					  
					  <tr>
						<td class="fileLabel" align="right">Garantía - Participación:</td>
						<td>
							#rsProcesoCompra.TGdescripcionP#
							
						</td>
					  </tr>
					  <tr>
					    <td class="fileLabel" align="right">&nbsp;</td>
					    <td>&nbsp;</td>
				      </tr>
					</table>			
				</td>
				<td valign="top">
					<table width="100%"  border="0" cellspacing="0" cellpadding="2">
					  <tr>
						<td class="fileLabel" align="right" nowrap>Grupo de Criterios:</td>
						<td nowrap>
							#rsProcesoCompra.GCcritdesc#
						</td>
					  </tr>
					  <tr>
						<td colspan="2" nowrap>
							<fieldset>
								<legend><strong>Criterios para el Proceso de Compra</strong></legend>
								<table width="100%"  border="0" cellspacing="0" cellpadding="2">
								  <cfloop query="rsCondicionesProceso">
								  <tr>
									<td nowrap>#rsCondicionesProceso.CCdesc#</td>
									<td nowrap>
										#LSNumberFormat(rsCondicionesProceso.CPpeso, ',9.00')#
									</td>
								  </tr>
								  </cfloop>
								</table>
							</fieldset>
						</td>
					  </tr>
					</table>			
				</td>
			  </tr>
			</table>
		</td>
	  </tr>
	  <tr>
		<td colspan="2">&nbsp;</td>
	  </tr>
	  <cfset iCount = 1>
	  <tr>
	    <td colspan="2">
			<table width="98%"  border="0" cellspacing="0" cellpadding="0" align="center">
			  <tr>
			  	<td colspan="6" align="center">
					<cfif rsPublica.RecordCount gt 0 and rsPublica.Pvalor eq '1'>
						<input type="submit" name="btnGuardar" class="btnnormal"   value="<cfif ProcesoPublicado>Actualizar Publicación<cfelse>Publicar</cfif>" onClick="javascript: if (confirm('¿Está seguro(a) de que desea publicar esta compra?')) { this.form.action = 'compraProceso-publicacion.cfm'; funcSiguiente(); } else { return false; } "> <!--- onMouseOver="javascript: this.className='botonDown2';" onMouseOut="javascript: this.className='botonUp2';"> --->
						<input type="submit" name="btnImprime" class="btnimprimir" value="Imprimir cotización de proveedores" onClick="javascript: ConlisReporte('proveedor');">
						<input type="submit" name="btnImprime" class="btnimprimir" value="Imprimir cotización del proceso" onClick="javascript: ConlisReporte('proceso');">
					<cfelse>
						<cfif ProcesoPublicado>
							<input type="submit" name="btnGuardar" value="Continuar >>" onClick="javascript: funcSiguiente(); "> <!--- onMouseOver="javascript: this.className='botonDown2';" onMouseOut="javascript: this.className='botonUp2';"> --->
						<cfelse>
							<input type="submit" name="btnAceptar" value="Guardar" onClick="javascript: if (confirm('¿Está seguro(a) de que desea guardar esta compra?')) { this.form.action = 'compraProceso-publicacion.cfm'; funcSiguiente(); } else { return false; } "> <!--- onMouseOver="javascript: this.className='botonDown2';" onMouseOut="javascript: this.className='botonUp2';"> --->
						</cfif>
					</cfif>
				</td>
			  </tr>
<!----***********************---->			  
			  <tr>
			  	<td colspan="6" align="center">
					<cfif rsPublica.RecordCount gt 0 and rsPublica.Pvalor eq '1'>
						<input type="button" value="Verificar asignación de líneas del proceso" class="btnnormal" onClick="javascript: ConliSociosNoinvitados(#rsProveedores.recordCount#);">
					</cfif>
				</td>
			  </tr>
<!----***********************---->			  
			  <tr>
				<td colspan="6">&nbsp;</td>
			  </tr>
			  <tr>
				<td  colspan="6" class="tituloListas">Lista de Proveedores Invitados a Participar</td>
			  </tr>
			<cfif rsProveedores.recordCount EQ 0>
				<tr>
					<td colspan="2" align="center"><strong>TODOS LOS PROVEEDORES ESTAN INVITADOS A PARTICIPAR</strong></td>
				</tr>
			<cfelse>
			  <tr>
				<td style="padding-right: 5px;" class="tituloListas" width="20%" nowrap>N&uacute;mero</td>
				<td style="padding-right: 5px;" nowrap class="tituloListas">Nombre</td>
			  </tr>
				<cfloop query="rsProveedores">
				  <tr class=<cfif (iCount MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
					<td style="padding-right: 5px;" nowrap>#rsProveedores.SNnumero#</td>
					<td style="padding-right: 5px;" nowrap>#rsProveedores.SNnombre#</td>
				  </tr>
				  <cfset iCount = iCount + 1>
				</cfloop>
			</cfif>
			</table>
		</td>
      </tr>
	  <tr>
		<td colspan="2">&nbsp;</td>
	  </tr>
	  <cfset iCount = 1>
	  <tr>
	    <td colspan="2">
			<table width="98%"  border="0" cellspacing="0" cellpadding="2" align="center">
			  <tr>
				<td colspan="5" class="tituloListas">Lista de Itemes de Compra</td>
			  </tr>
			  <tr>
				<td nowrap class="tituloListas" style="padding-right: 5px;">Tipo de Solicitud</td>
				<td align="right" nowrap class="tituloListas" style="padding-right: 5px;">No. Solicitud</td>
				<td align="center" nowrap class="tituloListas" style="padding-right: 5px;">Fecha</td>
				<td nowrap class="tituloListas" style="padding-right: 5px;">Centro Funcional</td>
				<td nowrap class="tituloListas">Solicitante</td>
			  </tr>
			  
			  <cfloop query="rsSolicitudes">
				  <cfset solicitud = rsSolicitudes.ESidsolicitud>
				  <tr class=<cfif (iCount MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
					<td style="border-top: 1px solid black; padding-right: 5px;" nowrap>#rsSolicitudes.CMTSdescripcion#</td>
					<td align="right"  style="border-top: 1px solid black; padding-right: 5px;"nowrap>#rsSolicitudes.ESnumero#</td>
					<td style="border-top: 1px solid black; padding-right: 5px;" align="center" nowrap>#LSDateFormat(rsSolicitudes.ESfecha, 'dd/mm/yyyy')#</td>
					<td style="border-top: 1px solid black; padding-right: 5px;" nowrap>#rsSolicitudes.CFcodigo# - #rsSolicitudes.CFdescripcion#</td>
					<td style="border-top: 1px solid black;">#rsSolicitudes.CMSnombre#</td>
				  </tr>
				  <tr class=<cfif (iCount MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
				    <td colspan="5">#rsSolicitudes.ESobservacion#</td>
			      </tr>
				  <cfset iCount = iCount + 1>
				  <cfquery name="rsSolicitudesDetalle" dbtype="query">
					select distinct DSlinea, CodigoItem, DSdescripcion, DScant, CantDisponible, Udescripcion, CFcodigoDet, CFdescripcionDet, Doc
					from rsDetalleProcesoCompra
					where ESidsolicitud = #rsSolicitudes.ESidsolicitud#
					order by DSlinea
				  </cfquery>
				  <tr>
					<td colspan="5" nowrap>
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
						  <tr>
							<td style="padding-right: 5px;" class="tituloListas" width="2%" nowrap>&nbsp;</td>
							<td style="padding-right: 5px;" class="tituloListas" width="28%" nowrap>Item</td>
							<td style="padding-right: 5px;" width="9%" align="right" nowrap class="tituloListas">Cantidad</td>
							<td class="tituloListas" width="19%" nowrap>Unidad</td>
						    <td class="tituloListas" width="42%" nowrap>Ctro. Funcional</td>
                            <td class="tituloListas" width="42%" nowrap>Documentos</td>
						  </tr>
						<cfloop query="rsSolicitudesDetalle">
						  <tr class=<cfif (iCount MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
							<td style="padding-right: 5px;" nowrap>-</td>
							<td style="padding-right: 5px;" nowrap>#rsSolicitudesDetalle.CodigoItem# - #rsSolicitudesDetalle.DSdescripcion#</td>
							<td style="padding-right: 5px;" align="right" nowrap>#rsSolicitudesDetalle.CantDisponible#<!----#rsSolicitudesDetalle.DScant#----></td>
							<td nowrap>#rsSolicitudesDetalle.Udescripcion#</td>
						    <td nowrap>
								<cfif Len(Trim(rsSolicitudesDetalle.CFcodigoDet))>
									#rsSolicitudesDetalle.CFcodigoDet# - #rsSolicitudesDetalle.CFdescripcionDet#
								<cfelse>
									---
								</cfif>
							</td>
                            <td nowrap><cfif Len(Trim(rsSolicitudesDetalle.Doc))>#rsSolicitudesDetalle.Doc#</cfif></td>
						  </tr>
						  <cfset iCount = iCount + 1>
						</cfloop>
					  </table>
					</td>
				  </tr>
			  </cfloop>
			  <tr>
				<td colspan="5">&nbsp;</td>
			  </tr>
			</table>
		</td>
      </tr>
	  </cfif>

	  <cfif isdefined("rsSolicitudesDetalle") and  rsSolicitudesDetalle.RecordCount GT 10>
		  <tr align="center">
			<td colspan="2">
				<!--- Lee parametro de Publicacion --->
				<cfquery name="rsPublica" datasource="#session.DSN#">
					select Pvalor 
					from Parametros 
					where Ecodigo=#Session.Ecodigo# 
					  and Pcodigo=570
				</cfquery>
				<cfif rsPublica.RecordCount gt 0 and rsPublica.Pvalor eq '1'>
					<input type="submit"  name="btnGuardar" value="<cfif ProcesoPublicado>Actualizar Publicación<cfelse>Publicar</cfif>" onClick="javascript: if (confirm('¿Está seguro(a) de que desea publicar esta compra?')) { this.form.action = 'compraProceso-publicacion.cfm'; funcSiguiente(); } else { return false; } "><!---  onMouseOver="javascript: this.className='botonDown2';" onMouseOut="javascript: this.className='botonUp2';"> --->
					<input type="submit"  name="btnImprime" value="Imprimir" onClick="javascript: ConlisReporte();">
				<cfelse>
					<cfif ProcesoPublicado>
						<input type="submit"  name="btnGuardar" value="Continuar >>" onClick="javascript: funcSiguiente(); "> <!--- onMouseOver="javascript: this.className='botonDown2';" onMouseOut="javascript: this.className='botonUp2';"> --->
					<cfelse>
						<input type="submit"  name="btnAceptar" value="Guardar" onClick="javascript: if (confirm('¿Está seguro(a) de que desea guardar esta compra?')) { this.form.action = 'compraProceso-publicacion.cfm'; funcSiguiente(); } else { return false; } " ><!--- onMouseOver="javascript: this.className='botonDown2';" onMouseOut="javascript: this.className='botonUp2';"> --->
					</cfif>
				</cfif>
			</td>
		  </tr>
		  <tr align="center">
			<td colspan="2">&nbsp;</td>
		  </tr>
	  </cfif>
	</table>
</form>
</cfoutput>
