<!---------
	Creado por: Gustavo Fonseca H.
	Fecha: 28-6-2005
	Motivo:	Mantenimiento de Instrucciones de Pago.
----------->

<cfinvoke key="BTN_RegistrarPago" default="Registrar Pago"	returnvariable="BTN_RegistrarPago"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPagos_manual.xml"/>

<cfinclude template="../../../Utiles/sifConcat.cfm">
<cfif isdefined("form.TESTDid") or isdefined("url.btnNuevo")>
	<cfset Modo = "ALTA">
<cfelse>
	<cfset Modo = "CAMBIO">
</cfif>

<cf_navegacion name="TESTLid">

<style type="text/css">
<!--
.style1 {
	font-size: 16px;
	font-weight: bold;
	text-align:center;
}
-->
</style>
<BR>
<cfif MODO EQ "ALTA">
	<cfoutput>
	<form name="form1" method="post" action="impresion_Instrucciones_Pagos_sql.cfm">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="style1" colspan="4">
					Lote de Impresi&oacute;n de Instrucciones de Pago
				</td>
			</tr>
			<tr>
				<td width="5%">&nbsp;</td>
				<td width="20%">&nbsp;</td>
				<td width="70%">&nbsp;</td>
				<td width="5%">&nbsp;</td>
			</tr>		  
			<tr>
				<td>&nbsp;</td>
			</tr>		  
			<tr>
				<td>&nbsp;</td>
				<td valign="top">
					Cuenta Bancaria de Pago:
				</td>
				<td valign="top">
					<cf_cboTESCBid Dcompleja="true" Dcompuesto="yes" cboTESMPcodigo="TESMPcodigo" tabindex="1">
				</td>
			</tr>		  
			<tr>
				<td>&nbsp;</td>
			</tr>		  
			<tr>
				<td>&nbsp;</td>
				<td valign="top">
					Medio de Pago:
				</td>
				<td valign="top">
					<cf_cboTESMPcodigo SoloTipo = 2 tabindex="1">
					<script language="javascript">
						sbCambiaTESCBid(document.getElementById("CBid"),'TESMPcodigo','');
					</script>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>  
			<cfif isdefined('Impresion')>
			<tr>
				<td colspan="2">&nbsp;</td>
				<td>
					<strong>Órdenes de Pago a Incluir en el nuevo Lote de Impresión de Instrucciones de Pago</strong>
					<fieldset>
					<input type="radio" value="1" name="chkTipo" checked tabindex="1">
					Incluir sólo las Órdenes de Pago asignadas a la Cuenta Bancaria y al Medio de Pago<BR>
					<input type="radio" value="2" name="chkTipo" tabindex="1">
					Incluir todas las Órdenes de Pago asignadas a la Cuenta Bancaria sin Medio de Pago asignado<BR>
					<input type="radio" value="3" name="chkTipo" tabindex="1">
					Seleccionar manualmente las Órdenes de Pago<BR>
					</fieldset>
				</td>
				<td width="100">&nbsp;</td>
			</tr>
			</cfif>
			<tr><td>&nbsp;</td></tr>  
			<tr>
				<td colspan="3" align="center">
					<input name="btnCrear" type="submit" value="Crear Nuevo Lote" onClick="return sbCrear();" tabindex="1">
					<input type="button" value="Ir a Lista <cfif isdefined('Impresion')>de Lotes</cfif>" tabindex="1"
					onClick="location.href='impresion_Instrucciones_Pagos.cfm'">
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>  
		</table>
	</form>
	<script language="javascript">
		function sbCrear()
		{
			if (document.form1.CBid.value == "")
			{
				alert("Debe escoger una Cuenta Bancaria de Pago para crear el lote");
				document.form1.CBid.focus();
				return false;
			}
			if (document.form1.TESMPcodigo.value == "")
			{
				alert("Debe escoger un Medio de Pago para crear el lote");
				document.form1.TESMPcodigo.focus();
				return false;
			}
			return true;
		}
	</script>
	</cfoutput>
<cfelse>
	<cfquery datasource="#session.dsn#" name="rsForm">
		Select	TESTLid,
				tl.CBid,
				case TESTLestado
					when 0 then '<strong>En preparacion</strong>'
					when 1 then '<strong>En impresión</strong>'
					when 2 then '<strong>No Emitido</strong>'
					when 3 then '<strong>Emitido</strong>'
				end as Estado,
				Edescripcion as empPago,
				Bdescripcion as bcoPago,
				Mnombre 	 as monPago,
				CBcodigo,
				tl.TESMPcodigo,
				TESMPdescripcion,
				TESTLfecha,
				mp.FMT01COD, fi.FMT01tipfmt, fi.FMT01TXT,
				tl.TESTLestado

		from TEStransferenciasL tl
			inner join TEScuentasBancos tcb
				inner join CuentasBancos cb
					inner join Monedas m
						 on m.Mcodigo 	= cb.Mcodigo
						and m.Ecodigo  	= cb.Ecodigo
					inner join Bancos b
						 on b.Ecodigo 	= cb.Ecodigo
						and b.Bid  		= cb.Bid
					inner join Empresas e
						on e.Ecodigo	= cb.Ecodigo
					 on cb.CBid=tcb.CBid
				 on tcb.TESid	= tl.TESid
				and tcb.CBid	= tl.CBid
				and tcb.TESCBactiva = 1
			inner join TESmedioPago mp
				inner join FMT001 fi
					on fi.FMT01COD = mp.FMT01COD
				 on mp.TESid		= tl.TESid
				and mp.CBid			= tl.CBid
				and mp.TESMPcodigo 	= tl.TESMPcodigo
		where tl.TESid=#session.Tesoreria.TESid#
          and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">				
		  and TESTLid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">	
			<cfif isdefined('form.TESOPfechaPago_F') and len(trim(form.TESOPfechaPago_F))>
				and TESTLfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDatetime(form.TESOPfechaPago_F)#">
			</cfif>

			<cfif isdefined('form.CBidPago_F') and len(trim(form.CBidPago_F)) and form.CBidPago_F NEQ '-1'>
				and tl.CBid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBidPago_F#">
			<cfelse>
				<cfif isdefined('form.EcodigoPago_F') and len(trim(form.EcodigoPago_F)) and form.EcodigoPago_F NEQ '-1'>
					and tcb.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.EcodigoPago_F#">
				</cfif>						
				<cfif isdefined('form.Miso4217Pago_F') and len(trim(form.Miso4217Pago_F)) and form.Miso4217Pago_F NEQ '-1'>
					and tcb.Miso4217=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Miso4217Pago_F#">
				</cfif>							
			</cfif>					
	</cfquery>
	<cfquery datasource="#session.dsn#" name="rsTESOP">
		select count(1) as cantidad
		  from TESordenPago
		 where TESid		= #session.Tesoreria.TESid#
		   and CBidPago		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CBid#">	
		   and TESMPcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsForm.TESMPcodigo#">	
		   and TESTLid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.TESTLid#">	
	</cfquery>
	<cfoutput>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
	<td class="style1" colspan="4">
		Lote de Impresi&oacute;n de Instrucciones de Pago
	</td>
  </tr>
  <tr>
	<td width="2%">&nbsp;</td>
	<td width="50%">&nbsp;</td>
	<td width="2%">&nbsp;</td>
	<td width="30%">&nbsp;</td>
  </tr>		  
  <tr>
	<td>&nbsp;</td>
	<td valign="top">
		<form name="form1" method="post" action="impresion_Instrucciones_Pagos_sql.cfm">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td valign="top" nowrap>
						Numero Lote:
					</td>
					<td valign="top" width="90%">
						<strong>#rsForm.TESTLid#</strong>
						<input type="hidden" name="TESTLid" value="#rsForm.TESTLid#" tabindex="-1">
					</td>
				</tr>		  
				<tr>
					<td valign="top" nowrap>
						Estado del Lote:
					</td>
					<td valign="top">
						<strong>#rsForm.Estado#</strong>
					</td>
				</tr>		  
				<tr>
					<td valign="top" nowrap>
						Empresa de Pago:
					</td>
					<td valign="top">
						<strong>#rsForm.empPago#</strong>
					</td>
				</tr>		  
				<tr>
					<td valign="top" nowrap>
						Banco de Pago:
					</td>
					<td valign="top">
						<strong>#rsForm.bcoPago#</strong>
					</td>
				</tr>		  
				<tr>
					<td valign="top" nowrap>
						Cuenta Bancaria de Pago:
					</td>
					<td valign="top">
						<strong>#rsForm.CBcodigo#</strong>
					</td>
				</tr>		  
				<tr>
					<td valign="top" nowrap>
						Moneda de Pago:
					</td>
					<td valign="top">
						<strong>#rsForm.monPago#</strong>
					</td>
				</tr>		  
				<tr>
					<td valign="top" nowrap>
						Medio de Pago:
					</td>
					<td valign="top">
						<strong>#rsForm.TESMPdescripcion#</strong>
					</td>
				</tr>
				<tr>
					<td valign="top" nowrap>
						Ordenes de Pago a imprimir:&nbsp;
					</td>
					<td valign="top">
						<strong>#rsTESOP.cantidad#</strong>
					</td>
				</tr>
			<cfif isdefined("url.btnSeleccionarOP")>
				<cfquery name="lista" datasource="#session.dsn#">
					SELECT TESOPid as ID, TESOPnumero, TESOPbeneficiario, Miso4217Pago, TESOPtotalPago
					 FROM TESordenPago
					 where TESid		= #session.Tesoreria.TESid#
					   and CBidPago		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CBid#">
					   and TESCFLid		IS null
					   and TESTLid		IS null
					   and TESOPestado = 11
					   and (
							TESMPcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsForm.TESMPcodigo#">
							OR	TESMPcodigo	is null
						   )
				</cfquery>
				<tr><td>&nbsp;</td></tr>  
				<tr>
					<td align="center" colspan="2">
						<strong>Lista de Ordenes de Pago enviadas a Emisión sin Lote de Impresión Asignadas</strong>
						<cfset key = 'TESOPid'>
					</td>
				</tr>  
				<tr><td>&nbsp;</td></tr>  
				<tr>
					<td colspan="2" align="center" nowrap>
					
						<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
							query="#lista#"
							checkboxes="S"
							desplegar="TESOPnumero, TESOPbeneficiario, TESOPtotalPago"
							etiquetas="N° Orden, Beneficiario, Monto<BR>#replace(rsForm.monPago,",","")#"
							formatos="S,S,M"
							ajustar="S,S,S"
							align="left,left,right"
							maxRows="15"
							showLink="no"
							incluyeForm="no"
							showEmptyListMsg="yes"
							keys="ID"
							navegacion="#navegacion#"
						/>		
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>  
				<tr>
					<td colspan="2" align="center" nowrap>
						<input type="submit" name="btnSeleccionarOP" value="Seleccionar" tabindex="1">
					</td>
				</tr>
			<cfelseif rsForm.TESTLestado EQ "0">
				<!--- EN PREPARACION --->
				<cfif rsTESOP.cantidad GT 0>
					<tr>
						<td>
							<input type="hidden" name="CBid" value="#rsForm.CBid#" tabindex="-1">
							<input type="hidden" name="TESMPcodigo" value="#rsForm.TESMPcodigo#" tabindex="-1">
							<input type="hidden" name="TESTDmsgAnulacion" id="TESTDmsgAnulacion" value="" tabindex="-1">
						</td>
					</tr>
				</cfif>
				<tr><td>&nbsp;</td></tr>  
				<tr>
					<td colspan="2" align="center" nowrap>
						<cfif rsTESOP.cantidad GT 0>
							<input name="btnInicioImpresion" type="submit" value="Imprimir" tabindex="1">
						</cfif>
						<input type="button" name="btnSeleccionarOP" value="Seleccionar Ordenes" onClick="location.href='impresion_Instrucciones_Pagos.cfm?btnSeleccionarOP=1&TESTLid=#form.TESTLid#'" tabindex="1">
						<input type="submit" name="btnEliminar" value="Eliminar Lote" onClick="if (!confirm('¿Desea eliminar este Lote de Impresion?')) return false;" tabindex="1">
						<input type="button" value="Ir a Lista de Lotes" onClick="location.href='impresion_Instrucciones_Pagos.cfm'" tabindex="1">
					</td>
				</tr>
				<cfquery name="lista" datasource="#session.dsn#">
					SELECT TESOPid as ID, TESOPnumero, TESOPbeneficiario, Miso4217Pago, TESOPtotalPago,
						'<img src=''/cfmx/sif/imagenes/Borrar01_S.gif'' width=''16'' height=''16'' style=''cursor:pointer;'' onClick=''document.nosubmit=true; if (!confirm("¿Desea excluir la Orden de Compra de este Lote de Impresion?")) return false; location.href="impresion_Instrucciones_Pagos_sql.cfm?btnExcluirOP=1&TESTLid=#form.TESTLid#&TESOPid=' #_Cat#
						<cf_dbfunction name="to_Char" args="TESOPid">
						#_Cat# '";''>' as Borrar
					 FROM TESordenPago
					where TESid	   = #session.Tesoreria.TESid#	
					  and TESTLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">	
				</cfquery>
				<cfset key = 'TESOPid'>
				<tr><td>&nbsp;</td></tr>  
				<tr>
					<td colspan="2" align="center" nowrap>
					
						<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
							query="#lista#"
							desplegar="Borrar,TESOPnumero, TESOPbeneficiario, TESOPtotalPago"
							etiquetas=" ,N° Orden, Beneficiario, Monto<BR>#replace(rsForm.monPago,",","")#"
							formatos="S,S,S,M"
							ajustar="N,S,S,S"
							align="center,left,left,right"
							maxRows="15"
							showLink="no"
							incluyeForm="no"
							showEmptyListMsg="yes"
							keys="ID"
							navegacion="#navegacion#"
						/>		
					</td>
				</tr>
			<cfelseif rsForm.TESTLestado EQ "1">
				<!--- EN IMPRESION: N/A --->
			<cfelse>
				<!--- DESPUES DE LA IMPRESION (no emitido) O REIMPRESION YA EMITIDOS--->
				<cfif isdefined("url.Imprima")>
					<cf_popup
						url="/cfmx/sif/Utiles/cfreportesCarta.cfm?Ecodigo=#Session.Ecodigo#&FMT01COD=#rsform.FMT01COD#&Conexion=#Session.DSN#&TESid=#session.tesoreria.TESid#&CBid=#rsform.CBid#&TESTLid=#form.TESTLid#&TESMPcodigo=#rsform.TESMPcodigo#"
						link="Reporte de Factura"
						boton="false" width="800" height="600" left="0" top="0" resize="yes" ejecutar="true"
						scrollbars="yes"
					>
				</cfif>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td colspan="2" align="center">
						<input type="hidden" name="TESTDmsgAnulacion" id="TESTDmsgAnulacion" value="">
					<cfif rsForm.TESTLestado EQ "2">
						<cfoutput><input type="submit" name="btnResultado" value="#Registrar Pago#"></cfoutput> 
					</cfif>
						<input type="button" name="btnReimprimir" value="Reimprimir" onClick="location.href='impresion_Instrucciones_Pagos.cfm?TESTLid=#form.TESTLid#&Imprima=1'">
						<input type="button" value="Ir a Lista de Lotes" onClick="location.href='impresion_Instrucciones_Pagos.cfm'">
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center" nowrap>
						<BR>
						<cfquery name="lista" datasource="#session.dsn#">
							SELECT op.TESOPid as ID, op.TESOPnumero, op.TESOPbeneficiario, op.Miso4217Pago, op.TESOPtotalPago,
								'<input type="text" name="TESTDreferencia_' #_Cat# <cf_dbfunction name="to_Char" args="td.TESTDid"> #_Cat# '" value="' #_Cat# td.TESTDreferencia #_Cat# '" style="text-align:right;">'
								as REFERENCIA
							 FROM TESordenPago op
							 	inner join TEStransferenciasD td
									 on td.TESid 	= op.TESid
									and td.TESOPid 	= op.TESOPid
									and td.TESTLid	= op.TESTLid
							where op.TESid	   = #session.Tesoreria.TESid#	
							  and op.TESTLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTLid#">	
						</cfquery>
						<cfset key = 'TESOPid'>
						
							<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
								query="#lista#"
								desplegar="TESOPnumero, TESOPbeneficiario, TESOPtotalPago,REFERENCIA"
								etiquetas="N° Orden, Beneficiario, Monto<BR>#replace(rsForm.monPago,",","")#, No.Referencia"
								formatos="S,S,M, S"
								ajustar="S,S,S,N"
								align="center,left,left,right"
								maxRows="15"
								showLink="no"
								incluyeForm="no"
								showEmptyListMsg="yes"
								keys="ID"
								navegacion="#navegacion#"
							/>		
					</td>
				</tr>
			</cfif>
				<tr><td>&nbsp;</td></tr>  
			</table>
		</form>
	</td>
	<td>&nbsp;</td>
	<td valign="top" width="400">
			<cfif rsForm.FMT01tipfmt EQ "3">
			<div style="width:400px; border:1px solid;">
				#rsForm.FMT01TXT#
			</div>
			<cfelse>
            	<img src="/cfmx/sif/ad/catalogos/formatos/flash-FMT01imgfpre.cfm?FMT01COD=#rsForm.FMT01COD#" width="400" border="1">
			</cfif>
	</td>
  </tr>
</table>
	</cfoutput>
</cfif>