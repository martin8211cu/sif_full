<!---------
	Modificado por: Ana Villavicencio
	Fecha de modificación: 04 de julio del 2005
	Motivo:	Se agregó el nuevo campo TESCFLtipo, esta campo indica el tipo de lote (I = Impresion, R = Reimpresion)
			Se modificó de manera q pudiera utilizarse para la Reimpresión de cheques.La variable para saber en cual 
			opción se encuetra es Reimpresion
----------->
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfif isdefined("form.TESCFDnumformulario") or isdefined("url.btnNuevo")>
	<cfset Modo = "ALTA">
<cfelse>
	<cfset Modo = "CAMBIO">
</cfif>

<cf_navegacion name="TESCFLid">

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
	<form name="form1" method="post" action="impresionCheques_sql.cfm">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="style1" colspan="5">
					Lote de <cfif isdefined('Reimpresion')>Reimpresi&oacute;n<cfelse>Impresi&oacute;n</cfif> de Cheques
				</td>
			</tr>
			<tr>
				<td width="5%">&nbsp;</td>
				<td width="20%">&nbsp;</td>
				<td width="70%">&nbsp;</td>
				<td width="5%">&nbsp;</td>
			</tr>		  
			<tr>
				<td rowspan="10">&nbsp;</td>
			</tr>		
			<cfif not isdefined('Reimpresion')>  
			<tr>
				<td valign="top">
					Cuenta Bancaria de Pago:
				</td>
				<td valign="top">
					<cf_cboTESCBid Dcompleja="true" Dcompuesto="yes" cboTESMPcodigo="TESMPcodigo">
				</td>
			</tr>		  
			<tr>
				<td valign="top">&nbsp;
					
				</td>
			</tr>		  
			<tr>
				<td valign="top">
					Medio de Pago:
				</td>
				<td valign="top">
					<cf_cboTESMPcodigo SoloChks="yes">
					<script language="javascript">
						sbCambiaTESCBid(document.getElementById("CBid"),'TESMPcodigo','');
					</script>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>  
			<tr>
				<td>&nbsp;</td>
				<td>
					<strong>Órdenes de Pago a Incluir en el nuevo Lote de Impresión de Cheques</strong>
					<fieldset>
					<input type="radio" value="1" name="chkTipo" checked>
					Incluir sólo las Órdenes de Pago asignadas a la Cuenta Bancaria y al Medio de Pago<BR>
					<input type="radio" value="2" name="chkTipo">
					Incluir todas las Órdenes de Pago asignadas a la Cuenta Bancaria sin Medio de Pago asignado<BR>
					<input type="radio" value="3" name="chkTipo">
					Seleccionar manualmente las Órdenes de Pago<BR>
					</fieldset>
				</td>
				<td width="100">&nbsp;</td>
			</tr>
			</cfif>
			<tr><td>&nbsp;</td></tr>  
			<tr>
				<td colspan="3" align="center">
					<input name="btnCrear" type="submit" value="Crear Nuevo Lote" onClick="return sbCrear();">
					<input type="button" value="Ir a Lista <cfif isdefined('Impresion')>de Lotes</cfif>" onClick="location.href='<cfif isdefined('Reimpresion')>re</cfif>impresionCheques.cfm'">
					<cfif isdefined('Reimpresion') and not isdefined('form.btnNuevo')>
						<input name="TESCFDnumFormulario" type="hidden" value="#form.TESCFDnumFormulario#">
					</cfif>
					<cfif isdefined('Reimpresion')>
						<input name="Reimpresion" type="hidden" value="1">
					</cfif>
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
		Select	TESCFLid,
				cfl.CBid,
				case TESCFLestado
					when 0 then '<strong>En preparacion</strong>'
					when 1 then '<strong>En impresión</strong>'
					when 2 then '<strong>No Emitido</strong>'
					when 3 then '<strong>Emitido</strong>'
				end as Estado,
				Edescripcion as empPago,
				Bdescripcion as bcoPago,
				Mnombre 	 as monPago,
				CBcodigo,
				cfl.TESMPcodigo,
				TESMPdescripcion,
				TESCFLfecha,
				FMT01COD,
				cfl.TESCFLestado,

				TESCFLcancelarAIni,
				TESCFLcancelarAFin,
				TESCFLimpresoIni,
				TESCFLimpresoFin,
				TESCFLcancelarDIni,
				TESCFLcancelarDFin,
				
				cfl.TESCFTnumInicial, cft.TESCFTnumFinal, cft.TESCFTultimo,
				case cft.TESCFTultimo
					when 0 then cft.TESCFTnumInicial
					else cft.TESCFTultimo+1
				end as TESCFTsiguiente
		from TEScontrolFormulariosL cfl
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
				 on tcb.TESid	= cfl.TESid
				and tcb.CBid	= cfl.CBid
				and tcb.TESCBactiva = 1
			inner join TESmedioPago mp
				 on mp.TESid		= cfl.TESid
				and mp.CBid			= cfl.CBid
				and mp.TESMPcodigo 	= cfl.TESMPcodigo
			left join TEScontrolFormulariosT cft
				 on cft.TESid		= cfl.TESid
				and cft.CBid			= cfl.CBid
				and cft.TESMPcodigo 	= cfl.TESMPcodigo
				and cft.TESCFTnumInicial= cfl.TESCFTnumInicial
		where cfl.TESid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">	
          and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
		  and TESCFLid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">	
			<cfif isdefined('form.TESOPfechaPago_F') and len(trim(form.TESOPfechaPago_F))>
				and TESCFLfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDatetime(form.TESOPfechaPago_F)#">
			</cfif>

			<cfif isdefined('form.CBidPago_F') and len(trim(form.CBidPago_F)) and form.CBidPago_F NEQ '-1'>
				and cfl.CBid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBidPago_F#">
			<cfelse>
				<cfif isdefined('form.EcodigoPago_F') and len(trim(form.EcodigoPago_F)) and form.EcodigoPago_F NEQ '-1'>
					and tcb.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.EcodigoPago_F#">
				</cfif>						
				<cfif isdefined('form.Miso4217Pago_F') and len(trim(form.Miso4217Pago_F)) and form.Miso4217Pago_F NEQ '-1'>
					and tcb.Miso4217=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Miso4217Pago_F#">
				</cfif>							
			</cfif>					
	</cfquery>
	<cfquery datasource="#session.dsn#" name="rsTESCFT">
		select TESCFTnumInicial, TESCFTnumFinal, TESCFTultimo,
				TESCFTimprimiendo,
				case TESCFTultimo
					when 0 then TESCFTnumInicial
					else TESCFTultimo+1
				end as TESCFTsiguiente
		  from TEScontrolFormulariosT
		 where TESid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">	
		   and CBid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CBid#">	
		   and TESMPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsForm.TESMPcodigo#">
		   and TESCFTultimo < TESCFTnumFinal
		   and TESCFTmanual = 0
	</cfquery>
	<cfquery datasource="#session.dsn#" name="rsTESOP">
		<cfif isdefined('Reimpresion')>
			select count(1) as cantidad
			from TEScontrolFormulariosD
			where TESid				  = #session.Tesoreria.TESid#
			  and CBid			      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CBid#">	
			  and TESMPcodigo		  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsForm.TESMPcodigo#">	
			  and TESCFLidReimpresion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.TESCFLid#">
		<cfelse>
			select count(1) as cantidad
			  from TESordenPago
			 where TESid		= #session.Tesoreria.TESid#
			   and CBidPago		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CBid#">	
			   and TESMPcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsForm.TESMPcodigo#">	
			   and TESCFLid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.TESCFLid#">	
		 </cfif>
	</cfquery>
	<cfoutput>
	<form name="form1" method="post" action="impresionCheques_sql.cfm">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="style1" colspan="5">
					Lote de <cfif isdefined('Reimpresion')>Reimpresi&oacute;n<cfelse>Impresi&oacute;n</cfif> de Cheques
				</td>
			</tr>
			<tr>
				<td width="5%">&nbsp;</td>
				<td width="20%">&nbsp;</td>
				<td width="30%">&nbsp;</td>
				<td width="3%">&nbsp;</td>
				<td width="39%">&nbsp;</td>
				<td width="3%">&nbsp;</td>
			</tr>		  
			<tr>
				<td rowspan="20">&nbsp;</td>
				<td valign="top">
					Numero Lote:
				</td>
				<td valign="top">
					<strong>#rsForm.TESCFLid#</strong>
					<input type="hidden" name="TESCFLid" value="#rsForm.TESCFLid#">
				</td>
				<td rowspan="20">&nbsp;</td>
				<td rowspan="20" valign="top">
					<img src="/cfmx/sif/ad/catalogos/formatos/flash-FMT01imgfpre.cfm?FMT01COD=#rsForm.FMT01COD#" width="400">
				</td>
			</tr>		  
			<tr>
				<td valign="top">
					Estado del Lote:
				</td>
				<td valign="top">
					<strong>#rsForm.Estado#</strong>
				</td>
			</tr>		  
			<tr>
				<td valign="top">
					Empresa de Pago:
				</td>
				<td valign="top">
					<strong>#rsForm.empPago#</strong>
				</td>
			</tr>		  
			<tr>
				<td valign="top">
					Banco de Pago:
				</td>
				<td valign="top">
					<strong>#rsForm.bcoPago#</strong>
				</td>
			</tr>		  
			<tr>
				<td valign="top">
					Cuenta Bancaria de Pago:
				</td>
				<td valign="top">
					<strong>#rsForm.CBcodigo#</strong>
				</td>
			</tr>		  
			<tr>
				<td valign="top">
					Moneda de Pago:
				</td>
				<td valign="top">
					<strong>#rsForm.monPago#</strong>
				</td>
			</tr>		  
			<tr>
				<td valign="top">
					Medio de Pago:
				</td>
				<td valign="top">
					<strong>#rsForm.TESMPdescripcion#</strong>
				</td>
			</tr>
			<tr>
				<td valign="top">
					<cfif isdefined('Reimpresion')>
						Cheques a reimprimir:
					<cfelse>
						Ordenes de Pago a imprimir:
					</cfif>
				</td>
				<td valign="top">
					<strong>#rsTESOP.cantidad#</strong>
				</td>
			</tr>
		<cfif isdefined("url.btnSeleccionarOP")>
			<cfquery name="lista" datasource="#session.dsn#">
				<cfif isdefined('Reimpresion')>
					select cfd.TESCFDnumFormulario as ID, TESOPbeneficiario, Miso4217Pago, TESOPtotalPago
					from TEScontrolFormulariosD cfd
					
					left outer join TESordenPago op
					  on cfd.TESOPid = op.TESOPid and
						 cfd.CBid = op.CBidPago and
						 cfd.TESMPcodigo = op.TESMPcodigo
						 
					where cfd.TESid		= #session.Tesoreria.TESid#
					   and CBidPago		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CBid#"> 
					   and cfd.TESMPcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsForm.TESMPcodigo#">
					   and TESCFDfechaEmision  = <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Now(),'mm/dd/yyyy')#">
					   and TESCFDestado = 1
				<cfelse>
					SELECT TESOPid as ID, TESOPnumero, TESOPbeneficiario, Miso4217Pago, TESOPtotalPago
					 FROM TESordenPago
					 where TESid		= #session.Tesoreria.TESid#
					   and CBidPago		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CBid#">
					   and TESCFLid		IS null
					   and TESOPestado = 11
					   and (
							TESMPcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsForm.TESMPcodigo#">
							OR	TESMPcodigo	is null
						   )
				  </cfif>
			</cfquery>
			<cfif isdefined('Reimpresion')>
				<cfset etiqueta = "N° Cheque">
				<cfset etiquetaDat = "ID">
			<cfelse>
				<cfset etiqueta = "N° Orden">
				<cfset etiquetaDat = "TESOPnumero">
			</cfif>
			<tr><td>&nbsp;</td></tr>  
			<tr>
				<td align="center" colspan="2">
					<cfif isdefined('Reimpresion')>
						<strong>Lista de Cheques del d&iacute;a</strong>
					<cfelse>
						<strong>Lista de Ordenes de Pago enviadas a Emisión sin Lote de Impresión Asignadas</strong>
					</cfif>
				</td>
			</tr>  
			<tr><td>&nbsp;</td></tr>  
			<tr>
				<td colspan="2" align="center" nowrap>
					<cfinclude template="/sif/Componentes/pListas.cfc">
						<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
							query="#lista#"
							checkboxes="S"
							desplegar="#etiquetaDat# , TESOPbeneficiario, TESOPtotalPago"
							etiquetas="#etiqueta# , Beneficiario, Monto<BR>#replace(rsForm.monPago,",","")#"
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
					<input type="submit" name="btnSeleccionarOP" value="Seleccionar">
				</td>
			</tr>
		<cfelseif rsForm.TESCFLestado EQ "0">
			<!--- EN PREPARACION --->
					<OBJECT ID="ImprimeX" width="0" height="0"
							CLASSID="CLSID:3FF8E4EF-BD3C-4B2C-A1F4-1E87DD0E2E67"
							CODEBASE="soinPrintDocs.CAB##version=1,0,0,80>
							<span id="ErrorActiveX"></span>
					</OBJECT>
					<script language="javascript">
						if (document.getElementById("ErrorActiveX"))
						{
							if (window.Event)
								alert ("Error ActiveX: El ActiveX 'soinPrintDocs.ocx' sólo puede ejecutarse en Microsoft Internet Explorer.");
							else
								alert ("Error ActiveX: Instale primero el 'soinPrintDocs.ocx'");
							location.href = "<cfif isdefined('Reimpresion')>re</cfif>impresionCheques.cfm";
						}
					</script>
			<cfif rsTESOP.cantidad GT 0>
			<tr>
				<td valign="top">
					Bloque de Formularios:
				</td>
				<td valign="top">
					<select name="TESCFT" id="TESCFT" onChange="sbCambiarTESCFT(this);">
					<cfif rsTESCFT.RecordCount NEQ 1>
						<option value=""></option>
					</cfif>
					<cfloop query="rsTESCFT">
						<cfif rsTESCFT.TESCFTimprimiendo EQ "0">
							<option value="#rsTESCFT.TESCFTnumInicial#,#rsTESCFT.TESCFTnumFinal#,#rsTESCFT.TESCFTsiguiente#">desde #NumberFormat(rsTESCFT.TESCFTnumInicial,"000000")# hasta #NumberFormat(rsTESCFT.TESCFTnumFinal,"000000")#, siguiente #NumberFormat(rsTESCFT.TESCFTsiguiente,"000000")#</option>
						<cfelse>
							<option value="">desde #NumberFormat(rsTESCFT.TESCFTnumInicial,"000000")# hasta #NumberFormat(rsTESCFT.TESCFTnumFinal,"000000")#, (BLOQUE OCUPADO)</option>
						</cfif>
					</cfloop>
					</select>
					<input type="hidden" name="CBid" value="#rsForm.CBid#">
					<input type="hidden" name="TESMPcodigo" value="#rsForm.TESMPcodigo#">
					<input type="hidden" name="TESCFDmsgAnulacion" id="TESCFDmsgAnulacion" value="">
					<script language="javascript">
						function sbCambiarTESCFT(TESCFT)
						{
							if (TESCFT.value == "")
								document.getElementById("TESCFLimpresoIni").value = "";
							else
								document.getElementById("TESCFLimpresoIni").value = TESCFT.value.split(",")[2];
						}

						function sbInicioImpresion()
						{
							var LvarTESCFT				= document.getElementById("TESCFT");
							var LvarTESCFLimpresoIni	= document.getElementById("TESCFLimpresoIni");
							if (LvarTESCFT.value == "")
							{
								alert ("Debe digitar el Bloque de Formularios a Utilizar");
								LvarTESCFT.focus();
								return false;
							}
							if (LvarTESCFLimpresoIni.value == "")
							{
								alert ("Debe digitar el Número del Primer Formulario a Imprimir");
								LvarTESCFLimpresoIni.focus();
								return false;
							}
							var LvarTESCFT		= LvarTESCFT.value.split(",");
							var LvarInicio		= parseInt(LvarTESCFT[0]);
							var LvarFinal		= parseInt(LvarTESCFT[1]);
							var LvarSiguiente	= parseInt(LvarTESCFT[2]);
							var LvarPrimero		= parseInt(LvarTESCFLimpresoIni.value);

							if (LvarPrimero < LvarInicio)
							{
								alert ("El Número del Primer Formulario a Imprimir no puede ser menor al primer formulario del Bloque de Formularios");
								LvarTESCFLimpresoIni.focus();
								return false;
							}

							if (LvarPrimero > LvarFinal)
							{
								alert ("El Número del Primer Formulario a Imprimir no puede ser mayor al ultimo formulario del Bloque de Formularios");
								LvarTESCFLimpresoIni.focus();
								return false;
							}

							if (LvarPrimero > LvarSiguiente)
							{
								if (confirm ("El Siguiente Formulario a imprimir en el Bloque era el " + LvarSiguiente + " pero se ha cambiado esta secuencia \n¿Desea anular los Formularios del " + LvarSiguiente + " al " + (LvarPrimero-1) + "?"))
								{
									var LvarMsgAnulacion = prompt("Anulación de Formularios Iniciales antes de Imprimir el Lote. Debe digitar un Motivo de Anulación!","");
									if (LvarMsgAnulacion && LvarMsgAnulacion != ""){
										document.getElementById("TESCFDmsgAnulacion").value = LvarMsgAnulacion;
										return true;
									}
									if (LvarMsgAnulacion == "")
										alert("Debe digitar un Motivo de Anulación!");
									return false;
								}
								else
									return false;
							}
							return true;
						}
					</script>
				</td>
			</tr>
			<tr>
				<td valign="top">
					N&uacute;mero del 1er formulario:
				</td>
				<td valign="top">
					<input type="text" name="TESCFLimpresoIni" id="TESCFLimpresoIni" value="<cfif rsTESCFT.RecordCount EQ 1>#rsTESCFT.TESCFTsiguiente#</cfif>" size="10">
				</td>
			</tr>		  
			</cfif>
			<tr><td>&nbsp;</td></tr>  
			<tr>
				<td colspan="2" align="center" nowrap>
					<cfif rsTESOP.cantidad GT 0><input name="btnInicioImpresion" type="submit" value="Inicio Impresion" onClick="return sbInicioImpresion();"></cfif>
					<input type="button" name="btnSeleccionarOP" value="Seleccionar <cfif isdefined('Reimpresion')>Cheques<cfelse>Ordenes</cfif>" 
						onClick="location.href='<cfif isdefined('Reimpresion')>re</cfif>impresionCheques.cfm?btnSeleccionarOP=1&TESCFLid=#form.TESCFLid#'">
					<input type="submit" name="btnEliminar" value="Eliminar Lote" onClick="if (!confirm('¿Desea eliminar este Lote de Impresion?')) return false;">
					<input type="button" value="Ir a Lista <cfif not isdefined('Reimpresion')>de Lotes</cfif>" onClick="location.href='<cfif isdefined('Reimpresion')>re</cfif>impresionCheques.cfm'">
				</td>
			</tr>
			<cfquery name="lista" datasource="#session.dsn#">
				<cfif isdefined('Reimpresion')>
					select cfd.TESCFDnumFormulario as ID, TESOPbeneficiario, Miso4217Pago, TESOPtotalPago,
						'<img src=''/cfmx/sif/imagenes/Borrar01_S.gif'' width=''16'' height=''16'' style=''cursor:pointer;'' onClick=''document.nosubmit=true; if (!confirm("¿Desea excluir el Cheque de este Lote de Impresion?")) return false; location.href="impresionCheques_sql.cfm?btnExcluirOP=1&Reimpresion=1&TESCFLid=#form.TESCFLid#&TESCFDnumFormulario=' #LvarCNCT#
						<cf_dbfunction name="to_Char" args="cfd.TESCFDnumFormulario">#LvarCNCT# '";''>' as Borrar
					from TEScontrolFormulariosD cfd
					
					left outer join TESordenPago op
					  on cfd.TESOPid 	   = op.TESOPid and
						 cfd.CBid 	   = op.CBidPago and
						 cfd.TESMPcodigo = op.TESMPcodigo

					where cfd.TESid			  = #session.Tesoreria.TESid#
					  and CBidPago			  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CBid#">
					  and cfd.TESMPcodigo	   	  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsForm.TESMPcodigo#">
					  and TESCFLidReimpresion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
					  and TESCFDfechaEmision  = <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Now(),'mm/dd/yyyy')#">
					  and TESCFDestado   = 1
				<cfelse>
					SELECT TESOPid as ID, TESOPnumero, TESOPbeneficiario, Miso4217Pago, TESOPtotalPago,
						'<img src=''/cfmx/sif/imagenes/Borrar01_S.gif'' width=''16'' height=''16'' style=''cursor:pointer;'' onClick=''document.nosubmit=true; if (!confirm("¿Desea excluir la Orden de Compra de este Lote de Impresion?")) return false; location.href="impresionCheques_sql.cfm?btnExcluirOP=1&TESCFLid=#form.TESCFLid#&TESOPid=' #LvarCNCT#
						<cf_dbfunction name="to_Char" args="TESOPid">
						#LvarCNCT# '";''>' as Borrar
					 FROM TESordenPago
					where TESid	   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">	
					  and TESCFLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">	
				</cfif>
			</cfquery>
			<cfif isdefined('Reimpresion')>
				<cfset etiqueta = "N° Cheque">
			<cfelse>
				<cfset etiqueta = "N° Orden">
			</cfif>
			<cfset MontoMoneda = Replace(rsForm.monPago,',',' -','all')>
			<tr><td>&nbsp;</td></tr>  
			<tr>
				<td colspan="2" align="center" nowrap>
					<cfinclude template="/sif/Componentes/pListas.cfc">
						<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
							query="#lista#"
							desplegar="Borrar,ID, TESOPbeneficiario, TESOPtotalPago"
							etiquetas=" ,#etiqueta#, Beneficiario, Monto<BR>#MontoMoneda#"
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
		<cfelseif rsForm.TESCFLestado EQ "1">
			<!--- EN IMPRESION --->
			<tr>
				<td valign="top">
					Bloque de Formularios utilizado:
				</td>
				<td valign="top">
					<strong>#NumberFormat(rsForm.TESCFTnumInicial,"000000")# - #NumberFormat(rsForm.TESCFTnumFinal,"000000")#</strong>
					<input type="hidden" value="#rsForm.TESCFTnumInicial#,#rsForm.TESCFTnumFinal#,#rsForm.TESCFTsiguiente#">
				</td>
			</tr>		  
			<tr>
				<td valign="top">
					Anulados antes de Impresion:
				</td>
				<td valign="top">
					<cfif rsForm.TESCFLcancelarAIni EQ "">
						<strong>N/A</strong>
					<cfelse>
						<strong>#rsForm.TESCFLcancelarAIni# - #rsForm.TESCFLcancelarAFin#</strong>
					</cfif>
				</td>
			</tr>		  
			<tr>
				<td valign="top">
					Formularios a imprimir:
				</td>
				<td valign="top">
					<strong>#rsForm.TESCFLimpresoIni# - #rsForm.TESCFLimpresoFin#</strong>
				</td>
			</tr>		  
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="2" align="center" nowrap>
					<input type="submit" name="btnCambiarBloque" 		value="Cambiar Bloque Formularios" 	onClick="document.form1.btnImprimir.value='NOINICIO'">
					<input type="submit" name="btnTerminarImpresion" 	value="Terminar Impresion"			onClick="document.form1.btnImprimir.value='ERROR'">
					<input type="button" name="btnIrLista" value="Ir a Lista <cfif not isdefined('Reimpresion')>de Lotes</cfif>" onClick="location.href='<cfif isdefined('Reimpresion')>re</cfif>impresionCheques.cfm'">
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<BR>
					<OBJECT ID="Imprime1"
							CLASSID="CLSID:3FF8E4EF-BD3C-4B2C-A1F4-1E87DD0E2E67"
							CODEBASE="soinPrintDocs.CAB##version=1,0,0,80>
							<span id="ErrorActiveX"></span>
					</OBJECT>
					<input type="hidden" name="btnImprimir" value="">
					<input type="hidden" name="UltimoDoc" value="0">
					<input type="hidden" name="TotalPags" value="0">
					<script language="javascript" FOR="Imprime1"  EVENT="Inicio">
						document.form1.btnImprimir.value = "";
						document.form1.btnCambiarBloque.style.display 	= "none";
						document.form1.btnTerminarImpresion.style.display = "none";
						document.form1.btnIrLista.style.display 			= "none";
					</script>
					<script language="javascript" FOR="Imprime1"  EVENT="NoInicio">
						document.form1.btnImprimir.value = "NOINICIO";
						document.form1.submit();
					</script>
					<script language="javascript" FOR="Imprime1"  EVENT="TerminoConError(LvarUltimoDoc,LvarTotPaginas)">
						document.form1.btnImprimir.value = "ERROR";
						document.form1.UltimoDoc.value = LvarUltimoDoc;
						document.form1.TotalPags.value = LvarTotPaginas;
						document.form1.submit();
					</script>
					<script language="javascript" FOR="Imprime1"  EVENT="TerminoConExito(LvarUltimoDoc,LvarTotPaginas)">
						document.form1.btnImprimir.value = "OK";
						document.form1.UltimoDoc.value = LvarUltimoDoc;
						document.form1.TotalPags.value = LvarTotPaginas;
						document.form1.submit();
					</script>
					<script language="javascript">
						if (document.getElementById("ErrorActiveX"))
						{
							if (window.Event)
								alert ("Error ActiveX: El ActiveX 'soinPrintDocs.ocx' sólo puede ejecutarse en Microsoft Internet Explorer.");
							else
								alert ("Error ActiveX: Instale primero el 'soinPrintDocs.ocx'");
							location.href = "<cfif isdefined('Reimpresion')>re</cfif>impresionCheques.cfm";
						}
					</script>
					<iframe width="00" height="00" id="ifrDatos" src="impresionCheques_datos.cfm?TESCFLid=#form.TESCFLid#&FMT01COD=#rsForm.FMT01COD#">
					</iframe>
					<iframe id="ifrTESCFL" src="" width="0" height="0">
					</iframe>
				</td>
			</tr>		  
		<cfelseif rsForm.TESCFLestado EQ "2">
			<!--- RESULTADO DE LA IMPRESION --->
			<cfquery name="rsDocs" datasource="#session.dsn#">
				select count(1) as cantidad
					 , max(TESCFDnumFormulario) as ultimo
				  from TEScontrolFormulariosD
				 where TESid			= #session.Tesoreria.TESid#
				   and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CBid#">
				   and TESMPcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsForm.TESMPcodigo#">
				   and TESCFLid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
				   and TESCFDestado		= 0
			</cfquery>
			<tr>
				<td valign="top">
					Bloque de Formularios utilizado:
				</td>
				<td valign="top">
					<strong>#NumberFormat(rsForm.TESCFTnumInicial,"000000")# - #NumberFormat(rsForm.TESCFTnumFinal,"000000")#</strong>
					<input type="hidden" value="#rsForm.TESCFTnumInicial#,#rsForm.TESCFTnumFinal#,#rsForm.TESCFTsiguiente#">
				</td>
			</tr>		  
			<tr>
				<td valign="top">
					Anulados antes de Impresion:
				</td>
				<td valign="top">
					<cfif rsForm.TESCFLcancelarAIni EQ "">
						<strong>N/A</strong>
					<cfelse>
						<strong>#rsForm.TESCFLcancelarAIni# - #rsForm.TESCFLcancelarAFin#</strong>
					</cfif>
				</td>
			</tr>		  
			<tr>
				<td valign="top">
					Formularios a imprimir:
				</td>
				<td valign="top">
					<strong>#rsForm.TESCFLimpresoIni# - #rsForm.TESCFLimpresoFin#</strong>
				</td>
			</tr>		  
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="2" align="center">
					<strong>RESULTADO DE LA IMPRESION</strong>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td>
					Ultimo Formulario bien impreso:
				</td>
				<td valign="top">
					<input type="text" 	name="ultimoDoc" id="ultimoDoc" value="#rsForm.TESCFLimpresoFin#" size="10" onKeyPress="document.getElementById('ningunDoc').checked=false">
					<input type="checkbox" name="ningunDoc" id="ningunDoc" onClick="document.getElementById('ultimoDoc').value='0'"> No se imprimió ningún formulario
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td>
					Anular Formularios mal impresos:
				</td>
				<td valign="top">
					<input type="text" name="cancelarDesde" value="" size="10">
					<input type="text" name="cancelarHasta" value="" size="10">
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="2" align="center">
					<input type="hidden" name="TESCFDmsgAnulacion" id="TESCFDmsgAnulacion" value="">
					<input type="submit" name="btnResultado" value="Registrar Resultado" onClick="return sbVerificarResultado();">
					<input type="button" value="Ir a Lista <cfif not isdefined('Reimpresion')>de Lotes</cfif>" onClick="location.href='<cfif isdefined('Reimpresion')>re</cfif>impresionCheques.cfm'">
					<script language="javascript">
						function sbVerificarResultado()
						{
							if (document.all.ultimoDoc.value == "")
							{
								document.all.ultimoDoc.value = 0;
							}

							if (document.all.cancelarDesde.value == "")
							{
								document.all.cancelarDesde.value = 0;
							}
							if (document.all.cancelarHasta.value == "")
							{
								document.all.cancelarHasta.value = document.all.cancelarDesde.value;
							}

							var LvarMSG = ""; 
							
							var LvarUltimo = parseInt(document.all.ultimoDoc.value);
							var LvarDesde  = parseInt(document.all.cancelarDesde.value);
							var LvarHasta  = parseInt(document.all.cancelarHasta.value);
								
							LvarMSG = "CONFIRMACION DEL RESULTADO DE LA IMPRESION DE CHEQUES\n\n";
							LvarMSG = LvarMSG + "Cantidad de Órdenes de Pago enviadas a imprimir:	#rsTESOP.cantidad#\n";
						<cfif rsForm.TESCFLcancelarAIni EQ "">
							LvarMSG = LvarMSG + "Formularios Anulados antes de la impresión:		Ninguno\n";
						<cfelse>
							LvarMSG = LvarMSG + "Formularios Anulados antes de la impresión:		#rsForm.TESCFLcancelarAIni# - #rsForm.TESCFLcancelarAFin#\n";
						</cfif>
							if (LvarUltimo == 0)
							{
								LvarMSG = LvarMSG + "Formularios impresos correctamente:			Ninguno\n";
							}
							else
							{
								LvarMSG = LvarMSG + "Formularios impresos correctamente:			#rsForm.TESCFLimpresoIni# - " + LvarUltimo + "\n";
							}
							if (LvarDesde == 0)
							{
								LvarMSG = LvarMSG + "Formularios Anulados despues de la impresión:		Ninguno\n";
							}
							else
							{
								LvarMSG = LvarMSG + "Formularios Anulados despues de la impresión:		" + LvarDesde +" - " + LvarHasta + "\n";
							}

							LvarMSG = LvarMSG + "\n";
							if (LvarUltimo == 0)
								LvarMSG = LvarMSG + "No se imprimió ninguna órden de pago, el lote vuelve a quedar en preparación\n";
							else
							{
								var LvarPendientes = #rsTESOP.cantidad# - (LvarUltimo - #rsForm.TESCFLimpresoIni# + 1);
								if (LvarPendientes > 0)
								{
									LvarMSG = LvarMSG + "Cantidad de Órdenes de Pago pendientes de imprimir:	" + LvarPendientes + "\n";
									LvarMSG = LvarMSG + "Las Órdenes de Pago pendientes se incluirán en un nuevo lote para su impresión";
								}
							}
							
							if (LvarDesde > LvarHasta)
							{
								alert ("ERROR: El número de formulario a Anular Desde debe ser mayor o igual al formulario Hasta");
								return false;
							}

							if (LvarUltimo == 0)
							{
								if (LvarDesde == 0)
								{
									if (!confirm ("¿No se imprimió ningún cheque pero no hay que cancelar ningún formulario?"))
										return false;
								}
								else if (LvarDesde != #rsForm.TESCFLimpresoIni#)
								{
									alert("ERROR: No se imprimió ningún formulario de cheques, si va a cancelar algún formulario debe iniciar desde #rsForm.TESCFLimpresoIni#");
									return false;
								}
								else
								{
									if (!confirm ("¿No se imprimió ningún cheque pero se deben cancelar los formularios del " + LvarDesde + " al " + LvarHasta + "?"))
										return false;
								}
							}
							else if (LvarUltimo < #rsForm.TESCFLimpresoIni#)
							{
								alert("ERROR: El ultimo formulario bien impreso no puede ser menor a #rsForm.TESCFLimpresoIni#");
								return false;
							}
							else if (LvarUltimo > #rsForm.TESCFLimpresoFin#)
							{
								alert("ERROR: El ultimo formulario bien impreso no puede ser mayor a #rsForm.TESCFLimpresoFin#");
								return false;
							}
							else if (LvarDesde > 0)
							{
								if (LvarDesde != LvarUltimo+1)
								{
									alert("ERROR: Se imprimió hasta el formulario " + LvarUltimo + ", si va a cancelar algún formulario debe iniciar desde " + (LvarUltimo+1));
									return false;
								}
								else
								{
									if (!confirm ("¿Se deben cancelar los formularios del " + LvarDesde + " al " + LvarHasta + "?"))
										return false;
								}
							}
							else if (LvarUltimo == #rsDocs.ultimo#)
							{
								if (!confirm ("¿Se imprimieron todos los formularios correctamente?"))
									return false;
							}
							else
							{
								if (!confirm ("Se imprimieron los formularios desde el #rsForm.TESCFTnumInicial# hasta el " + LvarUltimo + " (menos de los esperados)\n¿Desea continuar sin Anular formularios mal impresos?"))
									return false;
							}
							
							if (LvarDesde > 0)
							{
								var LvarMsgAnulacion = prompt("Anulación de Formularios Finales despues de Imprimir el Lote. Debe digitar un Motivo de Anulación!","");
								if (LvarMsgAnulacion && LvarMsgAnulacion != "")
								{
									document.getElementById("TESCFDmsgAnulacion").value = LvarMsgAnulacion;
								}
								else
								{
									if (LvarMsgAnulacion == "")
										alert("Debe digitar un Motivo de Anulación!");
									return false;
								}
							}
							
							return confirm(LvarMSG);
						}
					</script>
				</td>
			</tr>
		</cfif>
			<tr><td>&nbsp;</td></tr>  
		</table>
		<cfif isdefined('Reimpresion') and not isdefined('form.btnNuevo')>
			<!--- <input name="TESCFDnumFormulario" type="hidden" value="#form.TESCFDnumFormulario#"> --->
			<input name="Reimpresion" type="hidden" value="1">
		</cfif>
	</form>
	</cfoutput>
</cfif>
