<!---------
	Modificado por: Ana Villavicencio
	Fecha de modificación: 04 de julio del 2005
	Motivo:	Se agregó el nuevo campo TESCFLtipo, esta campo indica el tipo de lote (I = Impresion, R = Reimpresion)
			Se modificó de manera q pudiera utilizarse para la Reimpresión de cheques.La variable para saber en cual 
			opción se encuetra es Reimpresion
----------->

<cfset LvarOCX			= StructNew()>
<cfset LvarOCX.clsid	= "0FC59281-AD36-4FA6-A1AE-525E7D740FCC">
<cfset LvarOCX.version	= "1.0.98">

<cfif isdefined("form.TESCFDnumformulario") or isdefined("url.btnNuevo")>
	<cfset Modo = "ALTA">
<cfelse>
	<cfset Modo = "CAMBIO">
</cfif>

<cf_navegacion name="TESCFLid">

<cfset LvarReimpresionEspecial = false>

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
			<tr>
				<td valign="top">
					Cuenta Bancaria de Pago:
				</td>
				<td valign="top">
					<cf_cboTESCBid Dcompleja="true" Dcompuesto="yes" none="yes" cboTESMPcodigo="TESMPcodigo" value="-1" tabindex="1">
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
					<cf_cboTESMPcodigo SoloChks="yes" tabindex="1">
					<script language="javascript">
						sbCambiaTESCBid(document.getElementById("CBid"),'TESMPcodigo','');
					</script>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>  
			<cfif not isdefined('Reimpresion')>  
			<tr>
				<td>&nbsp;</td>
				<td>
					<strong>Órdenes de Pago 'En Emision' a Incluir en el nuevo Lote de Impresión de Cheques</strong>
					<fieldset>
					<input type="radio" value="1" name="chkTipo" checked tabindex="1">
					Órdenes de Pago asignadas a la Cuenta Bancaria y al Medio de Pago<BR>
					<table style=" float:inherit">
						<tr>
								
							<td>
								<input type="radio" style="visibility:hidden">
							</td>
							<td>
								Fecha de Pago:
							</td>
							<td>
								desde
							</td>
							<td>
								<cf_sifcalendario form="form1" value="" name="fechaDesde" tabindex="1">
							</td>
							<td>
								&nbsp;-&nbsp;
							</td>
							<td>
								hasta
							</td>
							<td>
								<cf_sifcalendario form="form1" value="" name="fechaHasta" tabindex="1">
							</td>
						</tr>
					</table>							
					<!---
					<input type="radio" value="2" name="chkTipo" tabindex="1">
					Incluir todas las Órdenes de Pago asignadas a la Cuenta Bancaria sin Medio de Pago asignado<BR>
					--->
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
					<input type="button" value="Ir a Lista <cfif isdefined('Impresion')>de Lotes</cfif>" onClick="location.href='<cfif isdefined('Reimpresion')>re</cfif>impresionCheques.cfm'" tabindex="1">
					<cfif isdefined('Reimpresion') and not isdefined('form.btnNuevo')>
						<input name="TESCFDnumFormulario" type="hidden" value="#form.TESCFDnumFormulario#" tabindex="-1">
					</cfif>
					<cfif isdefined('Reimpresion')>
						<input name="Reimpresion" type="hidden" value="1" tabindex="-1">
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
	<cfif isdefined('Reimpresion')>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select TESCFLespecial
			  from TEScontrolFormulariosL
			 where TESid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">	
			   and TESCFLid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">	
		</cfquery>
		<cfset LvarReimpresionEspecial = rsSQL.TESCFLespecial EQ "1">
	</cfif>
	
	<script language="javascript">
		function sbDownload(pObjeto)
		{
			var LvarOCXversion	= "";
			var LvarDebug		= "";
			if (document.getElementById(pObjeto))
			{
				if (document.getElementById(pObjeto).version)
					LvarOCXversion = document.getElementById(pObjeto).version;
				else
					LvarOCXversion = "0";
			}
			if (document.getElementById("ErrorActiveX"))
			{
				if (window.Event)
					LvarDebug = "Error ActiveX: El ActiveX 'soinPrintDocs.ocx' sólo puede ejecutarse en Microsoft Internet Explorer.";
				else
					LvarDebug = "Error ActiveX: Instale primero el 'soinPrintDocs.ocx'";
			}
			else if (LvarOCXversion != "<cfoutput>#LvarOCX.version#</cfoutput>")
				LvarDebug = "Error ActiveX: Se requiere reinstalar la versión '<cfoutput>#LvarOCX.version#</cfoutput>' del 'soinPrintDocs.ocx' (version instalada: '" + LvarOCXversion + "')";
			else
			{
				LvarDebug = "Error ActiveX: No hubo error";
				return;
			}

			LvarDebug += "\n";

			if (document.getElementById(pObjeto))
			{
				LvarDebug += document.getElementById(pObjeto).id + "\n";
				if (document.getElementById(pObjeto).version)
					LvarDebug += "Version=" + LvarOCXversion + "\n";
			}
			if (document.getElementById("ErrorActiveX"))
				LvarDebug += document.getElementById("ErrorActiveX").id + "\n";
			LvarDebug += "finDebug";
			alert(LvarDebug);	

			alert("Instalación:\n1) Baje y abra el soinPrintDocs.zip\n2) Cierre TODAS las instancias de Internet Explorer\n3) Ejecute setup.exe\n4) Si no se pudo instalar ejecute la instalación manual");
			location.href = "impresionCheques_datos.cfm?Download=1";
		}
	</script>
	<iframe width="00" height="00" id="ifrDownload" src=""  frameborder="0" style="display:none;">
	</iframe>

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
				, (
					<cf_dbfunction name="to_char" args="TESCFLid" returnvariable="LvarStrLote">
					select min(<cf_dbfunction name="concat"  args="TESCFLtipo+'. '+#preserveSingleQuotes(LvarStrLote)#" delimiters="+">)
					  from TEScontrolFormulariosL 
					 where TESid			= TEScontrolFormulariosT.TESid
					   and CBid				= TEScontrolFormulariosT.CBid
					   and TESMPcodigo		= TEScontrolFormulariosT.TESMPcodigo
					   and TESCFTnumInicial = TEScontrolFormulariosT.TESCFTnumInicial
					   and TESCFLestado		= 1
					) as Lote
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
					<script language="javascript">var LvarVer = false;</script>
					<input	type="text"
							size="1" 
							onClick="if (!LvarVer) {document.getElementById('ifrDatos').style.display='none';LvarVer = true; return;}  LvarVer = false; document.getElementById('ifrDatos').width='100';document.getElementById('ifrDatos').height='100';document.getElementById('ifrDatos').style.display='';"
							style="cursor:help; border:none;"
							readonly="yes"
							tabindex="-1"
					>
				</td>
			</tr>
			<tr>
				<td width="5%" rowspan="25">&nbsp;</td>
				<td width="20%">&nbsp;</td>
				<td width="20%">&nbsp;</td>
				<td width="3%" rowspan="20">&nbsp;</td>
			</tr>		  
			<tr>
				<td valign="top">
					Numero Lote:
				</td>
				<td valign="top">
					<strong>#rsForm.TESCFLid#</strong>
					<input type="hidden" name="TESCFLid" value="#rsForm.TESCFLid#" tabindex="-1">
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
			<cfset sbListaCheques("SEL")>
			<tr><td>&nbsp;</td></tr>  
			<tr>
				<td colspan="2" align="center" nowrap>
					<input type="submit" name="btnSeleccionarOP" value="Seleccionar" tabindex="1">
				</td>
			</tr>
		<cfelseif rsForm.TESCFLestado EQ "0">
			<!--- EN PREPARACION --->
					<OBJECT ID="ImprimeX" width="0" height="0"
							CLASSID="CLSID:#LvarOCX.clsid#"
							>
							<span id="ErrorActiveX"></span>
					</OBJECT>
					<script language="javascript">
						sbDownload("ImprimeX");
					</script>
			<cfif rsTESOP.cantidad GT 0>
			<tr>
				<td valign="top">
					Bloque de Formularios:
				</td>
				<td valign="top">
					<select name="TESCFT" id="TESCFT" onChange="sbCambiarTESCFT(this);" tabindex="1">
					<cfif rsTESCFT.RecordCount NEQ 1>
						<option value=""></option>
					</cfif>
					<cfset LvarPonerNota = false>
					<cfloop query="rsTESCFT">
						<cfif rsTESCFT.TESCFTimprimiendo EQ "0">
							<option value="#rsTESCFT.TESCFTnumInicial#,#rsTESCFT.TESCFTnumFinal#,#rsTESCFT.TESCFTsiguiente#">desde #NumberFormat(rsTESCFT.TESCFTnumInicial,"000000")# hasta #NumberFormat(rsTESCFT.TESCFTnumFinal,"000000")#, siguiente #NumberFormat(rsTESCFT.TESCFTsiguiente,"000000")#</option>
                        <cfelseif rsTESCFT.Lote NEQ "">
							<cfset LvarPonerNota = true>
                          <option value="">desde #NumberFormat(rsTESCFT.TESCFTnumInicial,"000000")# hasta #NumberFormat(rsTESCFT.TESCFTnumFinal,"000000")#, (OCUPADO por L-#rsTESCFT.Lote#)</option>
						<cfelse>
                          <option value="">desde #NumberFormat(rsTESCFT.TESCFTnumInicial,"000000")# hasta #NumberFormat(rsTESCFT.TESCFTnumFinal,"000000")#, (BLOQUE OCUPADO sin lote en impresión)</option>
                        </cfif>
					</cfloop>
					</select>
					<input type="hidden" name="CBid" value="#rsForm.CBid#" tabindex="-1">
					<input type="hidden" name="TESMPcodigo" value="#rsForm.TESMPcodigo#" tabindex="-1">
					<input type="hidden" name="TESCFDmsgAnulacion" id="TESCFDmsgAnulacion" value="" tabindex="-1">
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

							if (LvarPrimero < LvarSiguiente)
							{
								alert ("El Número del Primer Formulario a Imprimir no puede ser menor al siguiente formulario libre en el Bloque de Formularios");
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
						<cfif rsTESOP.cantidad GT 0>
							document.form1.TESCFT.focus();
						</cfif>
					</script>
				</td>
			</tr>
			<cfif LvarPonerNota>
				<tr>
					<td></td>
					<td>
						<font color="##FF0000">
							&nbsp;&nbsp;&nbsp;L-I. = Lote de Impresión de Cheques
						</font>
					</td>
				</tr>				
				<tr>
					<td></td>
					<td>
						<font color="##FF0000">
							&nbsp;&nbsp;&nbsp;L-R. = Lote de Reimpresión de Cheques
						</font>
					</td>
				</tr>				
			</cfif>
			<tr>
				<td valign="top">
					N&uacute;mero del 1er formulario:
				</td>
				<td valign="top">
					<input type="text" name="TESCFLimpresoIni" id="TESCFLimpresoIni"  tabindex="1"
						value="<cfif rsTESCFT.RecordCount EQ 1>#rsTESCFT.TESCFTsiguiente#</cfif>" size="10">
				</td>
			</tr>		  
			</cfif>
			<tr><td>&nbsp;</td></tr>  
			<tr>
				<td colspan="2" align="center" nowrap>

				<cfif rsTESOP.cantidad GT 0>
					<cfset LvarCantidades = fnVerificaFechas()>
				
					<cfif LvarCantidades.OtrosMeses GT 0>
						<cfset LvarDisabled = "disabled">
					<cfelse>
						<cfset LvarDisabled = "">
					</cfif>
					<cfset LvarActualizarFecha = (LvarCantidades.OtrosMeses GT 0 OR LvarCantidades.OtrosDias NEQ 0) AND not isdefined("reimpresion")>

					<cfif LvarActualizarFecha>
						<table>
							<tr>
								<td>
									<input name="btnActualizarFecha" type="submit" value="Actualizar Fecha Pago" tabindex="1"
											 onclick="if (document.form1.TESOPfechaPago_A.value == '') return false; if (confirm('¿Desea Actualizar la Fecha de Pago de todos los cheques del Lote a ' + document.form1.TESOPfechaPago_A.value + '?') ) {return true;} else {return false;}"
									>
								</td>
								<td>
									<cf_navegacion name="TESOPfechaPago_A" default="#dateformat(now(),"DD/MM/YYYY")#" session>
									<cf_sifcalendario form="form1" value="#form.TESOPfechaPago_A#" name="TESOPfechaPago_A" tabindex="1">												
								</td>
							</tr>
						</table>
					</cfif>
					<input name="btnInicioImpresion" type="submit" value="Inicio Impresion" onClick="return sbInicioImpresion();" #LvarDisabled#  tabindex="1">
				</cfif>
				<cfif NOT LvarReimpresionEspecial>
					<input type="button" name="btnSeleccionarOP" value="Seleccionar <cfif isdefined('Reimpresion')>Cheques<cfelse>Ordenes</cfif>"  tabindex="1"
						onClick="location.href='<cfif isdefined('Reimpresion')>re</cfif>impresionCheques.cfm?btnSeleccionarOP=1&TESCFLid=#form.TESCFLid#'">
				</cfif>
					<input type="submit" name="btnEliminar" value="Eliminar Lote"  tabindex="1"
						onClick="if (!confirm('¿Desea eliminar este Lote de Impresion?')) return false;">
					<input type="button" value="Ir a Lista <cfif not isdefined('Reimpresion')>de Lotes</cfif>"  tabindex="1"
						onClick="location.href='<cfif isdefined('Reimpresion')>re</cfif>impresionCheques.cfm'">
				</td>
			</tr>
			<cfif isdefined("LvarActualizarFecha") AND LvarActualizarFecha>
				<tr>
					<td colspan="2" align="center" style="color:##CC0000;">
						<BR>
						Existen Órdenes de Pago con Fechas de Pago diferentes a la fecha actual
						<BR>
					</td>
				</tr>
			</cfif>
			<cfif isdefined("LvarDisabled") AND LvarDisabled EQ "disabled">
				<tr>
					<td colspan="2" align="center" style="color:##CC0000;">
						<BR>
						Existen Órdenes de Pago con Fechas de Pago que no correponden ni al mes actual ni al siguiente de auxiliares
						<BR>
						(No se puede mandar a imprimir)
					</td>
				</tr>
			</cfif>
			<cfset sbListaCheques('0')>
		<cfelseif rsForm.TESCFLestado EQ "1">
			<!--- EN IMPRESION --->
			<tr>
				<td valign="top">
					Bloque de Formularios utilizado:
				</td>
				<td valign="top">
					<strong>#NumberFormat(rsForm.TESCFTnumInicial,"000000")# - #NumberFormat(rsForm.TESCFTnumFinal,"000000")#</strong>
					<input type="hidden" value="#rsForm.TESCFTnumInicial#,#rsForm.TESCFTnumFinal#,#rsForm.TESCFTsiguiente#"  tabindex="-1">
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
					<cfset LvarCantidades = fnVerificaFechas()>
				
					<cfif LvarCantidades.OtrosMeses GT 0>
						<cfset LvarDisabled = "disabled">
					<cfelse>
						<cfset LvarDisabled = "">
					</cfif>
					<cfset LvarActualizarFecha = (LvarCantidades.OtrosMeses GT 0 OR LvarCantidades.OtrosDias NEQ 0) AND not isdefined("reimpresion")>
				
					<input type="hidden" name="CBid" value="#rsForm.CBid#" tabindex="-1">
					<input type="hidden" name="TESMPcodigo" value="#rsForm.TESMPcodigo#" tabindex="-1">
					<cfif LvarActualizarFecha>
						<table>
							<tr>
								<td>
									<input name="btnActualizarFecha" type="submit" value="Actualizar Fecha Pago" tabindex="1"
											 onclick="if (document.form1.TESOPfechaPago_A.value == '') return false; if (confirm('¿Desea Actualizar la Fecha de Pago de todos los cheques del Lote a ' + document.form1.TESOPfechaPago_A.value + '?') ) {return true;} else {return false;}"
									>
								</td>
								<td>
									<cf_navegacion name="TESOPfechaPago_A" default="#dateformat(now(),"DD/MM/YYYY")#" session>
									<cf_sifcalendario form="form1" value="#form.TESOPfechaPago_A#" name="TESOPfechaPago_A" tabindex="1">												
								</td>
							</tr>
						</table>
					</cfif>
					<input type="submit" name="btnCambiarBloque" 		value="Cambiar Bloque Formularios" 	
						onClick="document.form1.btnImprimir.value='NOINICIO'"  tabindex="1">
					<input type="submit" name="btnTerminarImpresion" 	value="Terminar Impresion"
						#LvarDisabled#
						onClick="document.form1.btnImprimir.value='ERROR'"  tabindex="1">
					<input type="button" name="btnIrLista" value="Ir a Lista <cfif not isdefined('Reimpresion')>de Lotes</cfif>" 
						onClick="location.href='<cfif isdefined('Reimpresion')>re</cfif>impresionCheques.cfm'"  tabindex="1">
				</td>
			</tr>
			<cfif isdefined("LvarActualizarFecha") AND LvarActualizarFecha>
				<tr>
					<td colspan="2" align="center" style="color:##CC0000;">
						<BR>
						Existen Órdenes de Pago con Fechas de Pago diferentes a la fecha actual
					</td>
				</tr>
			</cfif>
			<cfif isdefined("LvarDisabled") AND LvarDisabled EQ "disabled">
				<tr>
					<td colspan="2" align="center" style="color:##CC0000;">
						<BR>
						Existen Órdenes de Pago con Fechas de Pago que no correponden ni al mes actual ni al siguiente de auxiliares
						<BR>
						(No se puede mandar a imprimir)
					</td>
				</tr>
			<cfelse>
				<tr>
					<td colspan="2" align="center">
						<BR>
						<OBJECT ID="Imprime1"
								CLASSID="CLSID:#LvarOCX.clsid#"
								>
								<span id="ErrorActiveX"></span>
						</OBJECT>
						<input type="hidden" name="btnImprimir" value="" tabindex="-1">
						<input type="hidden" name="UltimoDoc" value="0" tabindex="-1">
						<input type="hidden" name="TotalPags" value="0" tabindex="-1">
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
							sbDownload("Imprime1");
						</script>
						<iframe width="00" height="00" id="ifrDatos" src="impresionCheques_datos.cfm?TESCFLid=#form.TESCFLid#&FMT01COD=#rsForm.FMT01COD#<cfif LvarReimpresionEspecial>&Especial=1</cfif>" 
								style="display:none;">
						</iframe>
						<iframe id="ifrTESCFL" src="" width="0" height="0" 
								style="display:none;">
						</iframe>
					</td>
				</tr>		  
			</cfif>
			<cfset sbListaCheques('1')>
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
					<input type="hidden" value="#rsForm.TESCFTnumInicial#,#rsForm.TESCFTnumFinal#,#rsForm.TESCFTsiguiente#" tabindex="-1">
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
					<input type="text" 	name="ultimoDoc" id="ultimoDoc" value="#rsForm.TESCFLimpresoFin#" size="10" onKeyPress="document.getElementById('ningunDoc').checked=false" tabindex="1">
					<input type="checkbox" name="ningunDoc" id="ningunDoc" onClick="document.getElementById('ultimoDoc').value='0'"  tabindex="1"> No se imprimió ningún formulario
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td>
					Anular Formularios mal impresos:
				</td>
				<td valign="top">
					<input type="text" name="cancelarDesde" value="" size="10" tabindex="1">
					<input type="text" name="cancelarHasta" value="" size="10" tabindex="1">
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="2" align="center">
					<input type="hidden" name="TESCFDmsgAnulacion" id="TESCFDmsgAnulacion" value="" tabindex="-1">
					<input type="submit" name="btnResultado" value="Registrar Resultado" onClick="return sbVerificarResultado();" tabindex="1">
					<input type="button" value="Ir a Lista <cfif not isdefined('Reimpresion')>de Lotes</cfif>" onClick="location.href='<cfif isdefined('Reimpresion')>re</cfif>impresionCheques.cfm'" tabindex="1">
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
								LvarMSG = LvarMSG + "Formularios impresos correctamente:			#rsForm.TESCFLimpresoIni# - " + LvarUltimo + " (" + (LvarUltimo - #rsForm.TESCFLimpresoIni-1#) + ")\n";
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
								if (!confirm ("Se imprimieron los formularios desde el #rsForm.TESCFLimpresoIni# hasta el " + LvarUltimo + " (menos de los esperados)\n¿Desea continuar sin Anular formularios mal impresos?"))
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
			<cfset sbListaCheques('2')>
		</cfif>
			<tr><td>&nbsp;</td></tr>  
		</table>
		<cfif isdefined('Reimpresion') and not isdefined('form.btnNuevo')>
			<!--- <input name="TESCFDnumFormulario" type="hidden" value="#form.TESCFDnumFormulario#"> --->
			<input name="Reimpresion" type="hidden" value="1"  tabindex="-1">
		</cfif>
	</form>
	</cfoutput>
</cfif>
<iframe name="ifrDescripcion" id="ifrDescripcion" src="" width="0" height="0">
</iframe>

<script language="javascript">
	function sbVer(tipo, TESOPid)
	{
		LvarIframe = document.getElementById("ifrDescripcion");
		LvarIframe.src = "impresionCheques_sql.cfm?sbVer=1&tipo=" + tipo + "&OP=" + TESOPid;
	}
</script>


<cffunction name="sbListaCheques" output="true">
	<cfargument name="Estado" type="string" default="no">
	<cfinclude template="../../../Utiles/sifConcat.cfm">
	<cfif Arguments.Estado EQ 'SEL'>
		<cfquery name="lista" datasource="#session.dsn#">
			<cfif isdefined('Reimpresion')>
				select cfd.TESCFDnumFormulario as ID, 
						TESOPbeneficiario #_Cat# ' ' #_Cat# coalesce(TESOPbeneficiarioSuf,'') as TESOPbeneficiario, 
						TESOPfechaPago, TESOPtotalPago
				from TEScontrolFormulariosD cfd
				
				left outer join TESordenPago op
				  on cfd.TESOPid = op.TESOPid and
					 cfd.CBid = op.CBidPago and
					 cfd.TESMPcodigo = op.TESMPcodigo
					 
				where cfd.TESid		= #session.Tesoreria.TESid#
				   and CBidPago		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CBid#"> 
				   and <cf_dbfunction name="Date_Format" args="TESCFDfechaEmision,YYYYMMDD"> = '#DateFormat(Now(),'YYYYMMDD')#'
				   and TESCFDestado = 1
				   and cfd.TESCFLidReimpresion is null
			<cfelse>
				SELECT TESOPid as ID, TESOPnumero, TESOPbeneficiario #_Cat# ' ' #_Cat# coalesce(TESOPbeneficiarioSuf,'') as TESOPbeneficiario, TESOPfechaPago, TESOPtotalPago
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
			<cfset etiqueta = "Num.Cheque">
			<cfset etiquetaDat = "ID">
		<cfelse>
			<cfset etiqueta = "Num.Orden">
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
					<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
						query="#lista#"
						checkboxes="S"
						desplegar="#etiquetaDat# , TESOPfechaPago, TESOPbeneficiario, TESOPtotalPago"
						etiquetas="#etiqueta# , Fecha Pago,Beneficiario, Monto<BR>#replace(rsForm.monPago,",","")#"
						formatos="S,D,S,M"
						ajustar="S,S,S,S"
						align="left,center,left,right"
						maxRows="15"
						showLink="no"
						incluyeForm="no"
						showEmptyListMsg="yes"
						keys="ID"
						navegacion="#navegacion#"
					/>		
			</td>
		</tr>
	<cfelseif Arguments.Estado EQ '0'>
		<cfquery name="lista" datasource="#session.dsn#">
			<cfif isdefined('Reimpresion')>
				select 
					cfd.TESCFDnumFormulario as ID, 
				<cfif LvarReimpresionEspecial>
					<cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> as TESOPfechaPago,
				<cfelse>
					op.TESOPfechaPago, 
				</cfif>
					op.TESOPtotalPago
				  , TESOPbeneficiario #_Cat# ' ' #_Cat# coalesce(TESOPbeneficiarioSuf,'') as TESOPbeneficiario
				  , case when <cf_dbfunction name="length"	args="op.TESEcodigo"> > 1 then 
						'<span onclick="sbVer(''E'',' #_Cat# <cf_dbfunction name="to_Char" args="op.TESOPid"> #_Cat# ');" style="cursor:pointer;">SÍ</span>' 
					end as Endoso
                 <!---     , case when len(op.TESOPobservaciones) > 1 then  --->
				  , case when <cf_dbfunction name="islobnotnull" args="op.TESOPobservaciones"> then  
						'<span onclick="sbVer(''O'',' #_Cat# <cf_dbfunction name="to_Char" args="op.TESOPid"> #_Cat# ');" style="cursor:pointer;">SÍ</span>' 
					end as Entrega
				  , case when <cf_dbfunction name="length"	args="op.TESOPinstruccion"> > 1 then 
						'<span onclick="sbVer(''I'',' #_Cat# <cf_dbfunction name="to_Char" args="op.TESOPid"> #_Cat# ');" style="cursor:pointer;">SÍ</span>' 
					end as AlBanco
				<cfif LvarReimpresionEspecial>
				  , ''
				<cfelse>
				  , '<img src=''/cfmx/sif/imagenes/Borrar01_S.gif'' width=''16'' height=''16'' style=''cursor:pointer;'' onClick=''document.nosubmit=true; if (!confirm("¿Desea excluir el Cheque de este Lote de Impresion?")) return false; location.href="impresionCheques_sql.cfm?btnExcluirOP=1&Reimpresion=1&TESCFLid=#form.TESCFLid#&TESCFDnumFormulario=' #_Cat# <cf_dbfunction name="to_Char" args="cfd.TESCFDnumFormulario">#_Cat# '";''>' 
				</cfif>
					as Borrar
				  from TEScontrolFormulariosD cfd
					left outer join TESordenPago op
						 on op.TESOPid		= cfd.TESOPid 
						and op.CBidPago		= cfd.CBid
						and op.TESMPcodigo	= cfd.TESMPcodigo
				where cfd.TESid					= #session.Tesoreria.TESid#
				  and cfd.CBid					= <cfqueryparam cfsqltype="cf_sql_numeric"	value="#rsForm.CBid#">
				  and cfd.TESMPcodigo			= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#rsForm.TESMPcodigo#">
				  and cfd.TESCFLidReimpresion	= <cfqueryparam cfsqltype="cf_sql_numeric"	value="#form.TESCFLid#">
				<cfif NOT LvarReimpresionEspecial>
				  and <cf_dbfunction name="to_sdate" args="cfd.TESCFDfechaEmision">	= <cfqueryparam cfsqltype="cf_sql_date"		value="#Now()#">
				</cfif>
				  and cfd.TESCFDestado   		= 1
			<cfelse>
				select 
				    op.TESOPnumero as ID, 
					op.TESOPfechaPago, 
					op.TESOPtotalPago,
				   	op.TESOPbeneficiario #_Cat# ' ' #_Cat# coalesce(op.TESOPbeneficiarioSuf,'') as TESOPbeneficiario
				  , case when <cf_dbfunction name="length"	args="op.TESEcodigo"> > 1 then 
						'<span onclick="sbVer(''E'',' #_Cat# <cf_dbfunction name="to_Char" args="op.TESOPid"> #_Cat# ');" style="cursor:pointer;">SÍ</span>' 
					end as Endoso
                  <!---  , case when len(op.TESOPobservaciones) > 1 then  --->
				  , case when <cf_dbfunction name="islobnotnull" args="op.TESOPobservaciones"> then  
						'<span onclick="sbVer(''O'',' #_Cat# <cf_dbfunction name="to_Char" args="op.TESOPid"> #_Cat# ');" style="cursor:pointer;">SÍ</span>' 
					end as Entrega
				  , case when <cf_dbfunction name="length"	args="op.TESOPinstruccion"> > 1 then 
						'<span onclick="sbVer(''I'',' #_Cat# <cf_dbfunction name="to_Char" args="op.TESOPid"> #_Cat# ');" style="cursor:pointer;">SÍ</span>' 
					end as AlBanco
				  , '<img src=''/cfmx/sif/imagenes/Borrar01_S.gif'' width=''16'' height=''16'' style=''cursor:pointer;'' onClick=''document.nosubmit=true; if (!confirm("¿Desea excluir la Orden de Compra de este Lote de Impresion?")) return false; location.href="impresionCheques_sql.cfm?btnExcluirOP=1&TESCFLid=#form.TESCFLid#&TESOPid=' #_Cat# <cf_dbfunction name="to_Char" args="TESOPid"> #_Cat# '";''>'
					 as Borrar
				 FROM TESordenPago op
				where TESid	   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">	
				  and TESCFLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">	
			</cfif>
		</cfquery>
		<cfif isdefined('Reimpresion')>
			<cfset etiqueta = "Num.Cheque">
		<cfelse>
			<cfset etiqueta = "Num.Orden">
		</cfif>
		<cfset MontoMoneda = Replace(rsForm.monPago,',',' -','all')>
		<tr><td>&nbsp;</td></tr>  
		<tr>
			<td colspan="2" align="center" nowrap>
					<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
						query="#lista#"
						desplegar="Borrar, ID, TESOPfechaPago, TESOPbeneficiario, TESOPtotalPago, Endoso, Entrega, AlBanco"
						etiquetas="Borrar,#etiqueta#, Fecha<BR>Pago,Beneficiario, Monto<BR>#MontoMoneda#, Endoso, Entrega, Al Banco"
						formatos="S,S,D,S,M,S,S,S"
						ajustar="S,S,S,S,S,S,S,S"
						align="left,left,center,left,right,center,center,center"
						maxRows="15"
						showLink="no"
						incluyeForm="no"
						showEmptyListMsg="yes"
						keys=""
						navegacion="#navegacion#"
					/>		
			</td>
		</tr>
	<cfelseif Arguments.Estado EQ '1'>
		<cfquery name="lista" datasource="#session.dsn#">
			select 
					cfd.TESCFDnumFormulario as Cheque
				<cfif isdefined('Reimpresion')>
				  ,	viejo.TESCFDnumFormulario as VIEJO
				</cfif>
				  , op.TESOPnumero
				<cfif LvarReimpresionEspecial>
				  ,	<cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> as TESOPfechaPago
				<cfelse>
				  ,	op.TESOPfechaPago
				</cfif>
				  , op.TESOPtotalPago
				  ,	op.TESOPbeneficiario #_Cat# ' ' #_Cat# coalesce(op.TESOPbeneficiarioSuf,'') as TESOPbeneficiario
				  , case when <cf_dbfunction name="length"	args="op.TESEcodigo"> > 1 then 				  
						'<span onclick="sbVer(''E'',' #_Cat# <cf_dbfunction name="to_Char" args="op.TESOPid"> #_Cat# ');" style="cursor:pointer;">SÍ</span>' 
					end as Endoso
				  <!--- , case when len(op.TESOPobservaciones) > 1 then  --->
                  , case when <cf_dbfunction name="islobnotnull" args="op.TESOPobservaciones"> then  
						'<span onclick="sbVer(''O'',' #_Cat# <cf_dbfunction name="to_Char" args="op.TESOPid"> #_Cat# ');" style="cursor:pointer;">SÍ</span>' 
					end as Entrega
				  , case when <cf_dbfunction name="length"	args="op.TESOPinstruccion"> > 1 then 
						'<span onclick="sbVer(''I'',' #_Cat# <cf_dbfunction name="to_Char" args="op.TESOPid"> #_Cat# ');" style="cursor:pointer;">SÍ</span>' 
					end as AlBanco
				  , ' ' as Blanco
			  from TEScontrolFormulariosD cfd
				inner join TESordenPago op
				  on cfd.TESOPid 	   	= op.TESOPid
				 and cfd.CBid 	   		= op.CBidPago
				 and cfd.TESMPcodigo 	= op.TESMPcodigo
		<cfif isdefined('Reimpresion')>
				inner join TEScontrolFormulariosD viejo
					 on viejo.TESid					= cfd.TESid
					and viejo.CBid					= cfd.CBid
					and viejo.TESMPcodigo			= cfd.TESMPcodigo
					and viejo.TESCFLidReimpresion	= cfd.TESCFLid
					and viejo.TESOPid				= cfd.TESOPid
					and viejo.TESCFDestado   		= 1
		</cfif>
			where cfd.TESid			= #session.Tesoreria.TESid#
			  and cfd.CBid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CBid#">
			  and cfd.TESMPcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsForm.TESMPcodigo#">
			  and cfd.TESCFLid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
		</cfquery>
		<cfset MontoMoneda = Replace(rsForm.monPago,',',' -','all')>
		<cfif isdefined('Reimpresion')>
			<cfset etiqueta = "Num.Cheque<BR>a Anular">
			<cfset etiquetaDat = "VIEJO">
		<cfelse>
			<cfset etiqueta = " ">
			<cfset etiquetaDat = "Blanco">
		</cfif>
		<tr><td>&nbsp;</td></tr>  
		<tr>
			<td colspan="2" align="center" nowrap>
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
						query="#lista#"
						desplegar="Cheque,#etiquetaDat#,TESOPnumero, TESOPfechaPago, TESOPbeneficiario, TESOPtotalPago, Endoso, Entrega, AlBanco"
						etiquetas="Num. Cheque<BR>a Imprimir,#etiqueta#,Num.Orden, Fecha<BR>Pago,Beneficiario, Monto<BR>#MontoMoneda#, Endoso, Entrega, Al Banco"
						formatos="S,S,S,D,S,M,S,S,S"
						ajustar="S,S,S,S,S,S,S,S,S"
						align="left,left,left,center,left,right,center,center,center"
						maxRows="15"
						showLink="no"
						incluyeForm="no"
						showEmptyListMsg="yes"
						keys="Cheque"
						navegacion="#navegacion#"
					/>		
			</td>
		</tr>
	<cfelseif Arguments.Estado EQ '2'>
		<cfquery name="lista" datasource="#session.dsn#">
			select 
					cfd.TESCFDnumFormulario as Cheque
				<cfif isdefined('Reimpresion')>
				  ,	viejo.TESCFDnumFormulario as VIEJO
				</cfif>
				  , ' ' as Blanco
				  , op.TESOPnumero
				<cfif LvarReimpresionEspecial>
				  ,	<cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> as TESOPfechaPago
				<cfelse>
				  ,	op.TESOPfechaPago
				</cfif>
				  , op.TESOPtotalPago
				  ,	op.TESOPbeneficiario #_Cat# ' ' #_Cat# coalesce(op.TESOPbeneficiarioSuf,'') as TESOPbeneficiario
				  , case when <cf_dbfunction name="length"	args="op.TESEcodigo"> > 1 then 
						'<span onclick="sbVer(''E'',' #_Cat# <cf_dbfunction name="to_Char" args="op.TESOPid"> #_Cat# ');" style="cursor:pointer;">SÍ</span>' 
					end as Endoso
	<!---			  , case when len(op.TESOPobservaciones) > 1 then  --->
                  , case when <cf_dbfunction name="islobnotnull" args="op.TESOPobservaciones"> then  
						'<span onclick="sbVer(''O'',' #_Cat# <cf_dbfunction name="to_Char" args="op.TESOPid"> #_Cat# ');" style="cursor:pointer;">SÍ</span>' 
					end as Entrega
				  , case when <cf_dbfunction name="length"	args="op.TESOPinstruccion"> > 1 then 
						'<span onclick="sbVer(''I'',' #_Cat# <cf_dbfunction name="to_Char" args="op.TESOPid"> #_Cat# ');" style="cursor:pointer;">SÍ</span>' 
					end as AlBanco
			  from TEScontrolFormulariosD cfd
				inner join TESordenPago op
				  on cfd.TESOPid 	   	= op.TESOPid
				 and cfd.CBid 	   		= op.CBidPago
				 and cfd.TESMPcodigo 	= op.TESMPcodigo
		<cfif isdefined('Reimpresion')>
				inner join TEScontrolFormulariosD viejo
					 on viejo.TESid					= cfd.TESid
					and viejo.CBid					= cfd.CBid
					and viejo.TESMPcodigo			= cfd.TESMPcodigo
					and viejo.TESCFLidReimpresion	= cfd.TESCFLid
					and viejo.TESOPid				= cfd.TESOPid
					and viejo.TESCFDestado   		= 1
		</cfif>
			where cfd.TESid			= #session.Tesoreria.TESid#
			  and cfd.CBid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CBid#">
			  and cfd.TESMPcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsForm.TESMPcodigo#">
			  and cfd.TESCFLid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
		</cfquery>
		<cfset MontoMoneda = Replace(rsForm.monPago,',',' -','all')>
		<cfif isdefined('Reimpresion')>
			<cfset etiqueta = "Num.Cheque<BR>a Anular">
			<cfset etiquetaDat = "VIEJO">
		<cfelse>
			<cfset etiqueta = " ">
			<cfset etiquetaDat = "Blanco">
		</cfif>
		<tr><td>&nbsp;</td></tr>  
		<tr>
			<td colspan="2" align="center" nowrap>
					<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
						query="#lista#"
						desplegar="Cheque,#etiquetaDat#,TESOPnumero, TESOPfechaPago, TESOPbeneficiario, TESOPtotalPago, Endoso, Entrega, AlBanco"
						etiquetas="Num. Cheque<BR>a Imprimir,#etiqueta#,Num.Orden, Fecha<BR>Pago,Beneficiario, Monto<BR>#MontoMoneda#, Endoso, Entrega, Al Banco"
						formatos="S,S,S,D,S,M,S,S,S"
						ajustar="S,S,S,S,S,S,S,S,S"
						align="left,left,left,center,left,right,center,center,center"
						maxRows="15"
						showLink="no"
						incluyeForm="no"
						showEmptyListMsg="yes"
						keys="Cheque"
						navegacion="#navegacion#"
					/>		
			</td>
		</tr>
	</cfif>
</cffunction>

<cffunction name="fnVerificaFechas" output="false" returntype="struct">
	<cfif rsTESOP.cantidad EQ 0>
		<cfset LvarCantidades.OtrosMeses	= -1>
		<cfset LvarCantidades.OtrosDias		= -1>
	<cfelse>
		<!--- VERIFICA LA FECHA --->
		<cfquery name="rsParametros" datasource="#session.DSN#">
			select 	<cf_dbfunction name="to_number" args="p1.Pvalor"> as AuxPeriodo,
					<cf_dbfunction name="to_number" args="p2.Pvalor"> as AuxMes
			  from Parametros p1, Parametros p2, Empresas e
			 where p1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			   and p1.Mcodigo = 'GN'
			   and p1.Pcodigo = 50		

			   and p2.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			   and p2.Mcodigo = 'GN'
			   and p2.Pcodigo = 60
		</cfquery>			

		<cfset LvarPrimerDiaAux		= createdate(rsParametros.AuxPeriodo,rsParametros.AuxMes,1)>
		<cfset LvarPrimerDiaSigAux	= dateadd("m",1 ,LvarPrimerDiaAux)>

		<cfquery datasource="#session.dsn#" name="rsSQL">
			select count(1) as cantidad
			  FROM TESordenPago op
			 where TESid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">	
			   and TESCFLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">	
			   and <cf_dbfunction name="Date_Format" args="TESOPfechaPago,YYYYMM"> <> '#DateFormat(LvarPrimerDiaAux,"YYYYMM")#'
			   and <cf_dbfunction name="Date_Format" args="TESOPfechaPago,YYYYMM"> <> '#DateFormat(LvarPrimerDiaSigAux,"YYYYMM")#'
		</cfquery>
		<cfset LvarCantidades.OtrosMeses = rsSQL.cantidad>

		<cfquery datasource="#session.dsn#" name="rsSQL">
			select count(1) as cantidad
			  FROM TESordenPago op
			 where TESid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">	
			   and TESCFLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">	
			   and <cf_dbfunction name="Date_Format" args="TESOPfechaPago,YYYYMMDD"> <> '#DateFormat(now(),"YYYYMMDD")#'
		</cfquery>
		<cfset LvarCantidades.OtrosDias = rsSQL.cantidad>
	</cfif>
	
	<cfreturn LvarCantidades>
</cffunction>
				
<script language="javascript" type="text/javascript">
	<cfif isdefined("url.btnSeleccionarOP")>
	document.form1.btnSeleccionarOP.focus();
	</cfif>
</script>