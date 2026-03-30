<cf_templateheader title="Anulación de Transacciones">
		<cf_web_portlet_start titulo="Anulación de Transacciones">
			<cfinclude template="../../portlets/pNavegacion.cfm">

			<!--- Maximos digitos para el numero del doc de recepcion --->
			<cfquery name="rsMaxDig" datasource="#session.DSN#">
				select Pvalor
				from Parametros
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Pcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="720">
			</cfquery>

			<cfset maxCarNum = 16>
			
			<cfif isdefined('rsMaxDig') and rsMaxDig.recordCount GT 0 and rsMaxDig.Pvalor NEQ ''>
				<cfset maxCarNum = rsMaxDig.Pvalor>
			</cfif>
			
			<!--- Anulación de Facturas --->
			<cfif isdefined("form.chk") and (isdefined("form.boton"))>
			
				<cfset documentosNoAnulados = "">
				
				<cfloop list="#form.chk#" index="pkEDIid">
				
					<cfset apkEDIid = ListToArray(pkEDIid,'|')>
					<cfset pkEDIid = apkEDIid[1]>
					
					<!--- Valida que no existan en Pólizas de Desalmacenaje cerradas --->
					<cfquery name="rsExisteEnPolizaCerrada" datasource="#session.dsn#">
						select 1
							from EDocumentosI a
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and a.EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pkEDIid#">
								and a.EDIestado = 10
								and (exists(
									select 1
									from DDocumentosI x
										inner join FacturasPoliza  y 
											inner join EPolizaDesalmacenaje z
												on z.EPDid = y.EPDid 
												and z.Ecodigo = y.Ecodigo 
												and z.EPDestado = 10
											on y.DDlinea = x.DDlinea 
											and y.Ecodigo = x.Ecodigo 
									where x.Ecodigo = a.Ecodigo 
									and x.EDIid = a.EDIid
								)
								or exists(
									select 1 
									from DDocumentosI x 
										inner join CMImpuestosPoliza y 
											inner join EPolizaDesalmacenaje z
												on z.EPDid = y.EPDid
												and z.Ecodigo = y.Ecodigo 
												and z.EPDestado = 10
											on y.DDlinea = x.DDlinea 
											and y.Ecodigo = x.Ecodigo 
									where x.Ecodigo = a.Ecodigo 
									and x.EDIid = a.EDIid
								))
					</cfquery>
					
					<cfquery name="rsTieneReferencia" datasource="#session.dsn#">
						select 1
						from EDocumentosI edi
						where edi.EDIidRef = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pkEDIid#">
					</cfquery>
					
					<cfif rsExisteEnPolizaCerrada.RecordCount gt 0>
						<cfset documentosNoAnulados = documentosNoAnulados & ",#pkEDIid#">
					<cfelseif rsTieneReferencia.RecordCount gt 0>
						<cfset documentosNoAnulados = documentosNoAnulados & ",#pkEDIid#">
					<cfelse>
						<cftransaction>
	
							<cfquery datasource="#session.dsn#">
								delete from FacturasGastoItem
								where FPid in (
									select FPid from FacturasPoliza where EPDid in (
										select EPDid from DDocumentosI 
										where EPDid in (
											select EPDid from DDocumentosI where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
												and EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pkEDIid#">
											and EPDid is not null
										) or EPDid in (
											select EPDid from DPolizaDesalmacenaje where DDlinea in ( 
												select DDlinea from DDocumentosI where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
												and EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pkEDIid#">
											)
											and EPDid is not null
										) or EPDid in (
											select EPDid from FacturasPoliza where DDlinea in ( 
												select DDlinea from DDocumentosI where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
												and EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pkEDIid#">
											)
											and EPDid is not null
										) or EPDid in (
											select EPDid from CMImpuestosPoliza where DDlinea in ( 
												select DDlinea from DDocumentosI where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
												and EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pkEDIid#">
											)
											and EPDid is not null
										)
									)
								)
							</cfquery>
	
							<cfquery datasource="#session.dsn#">
								delete from CMImpuestosItem
								where EPDid in (
									select EPDid from DDocumentosI where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
												and EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pkEDIid#">
									and EPDid is not null
								) or EPDid in (
									select EPDid from DPolizaDesalmacenaje where DDlinea in ( 
										select DDlinea from DDocumentosI where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
												and EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pkEDIid#">
									)
									and EPDid is not null
								) or EPDid in (
									select EPDid from FacturasPoliza where DDlinea in ( 
										select DDlinea from DDocumentosI where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
												and EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pkEDIid#">
									)
									and EPDid is not null
								) or EPDid in (
									select EPDid from CMImpuestosPoliza where DDlinea in ( 
										select DDlinea from DDocumentosI where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
												and EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pkEDIid#">
									)
									and EPDid is not null
								)
							</cfquery>
	
							<cfquery datasource="#session.dsn#">
								delete from FacturasPoliza where DDlinea in ( 
									select DDlinea from DDocumentosI where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
												and EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pkEDIid#">
								)
								
							</cfquery><cfquery datasource="#session.dsn#">
								delete  from CMImpuestosPoliza where DDlinea in ( 
									select DDlinea from DDocumentosI where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
												and EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pkEDIid#">
								)
							</cfquery>
							
							<cfif form.Boton EQ 'btnAnular'>
								<!--- Actualiza el estado de la factura a cancelada (60) --->
								<cfquery name="uEPD" datasource="#session.DSN#">
									update EDocumentosI
									set EDIestado = 60,
										BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
										EDmotivoanul = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.MOTIVOANULA#">
									where EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pkEDIid#">
										and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								</cfquery>
							</cfif>							
						</cftransaction>
					</cfif>
				</cfloop>
								
				<cfif documentosNoAnulados neq ''>
					<cflocation url="anulaEDocumentosI-transaccion.cfm?VPintado=1&Lista=#documentosNoAnulados#">
				</cfif>
			</cfif>
			
			<cfif isdefined("url.DdocumentoF") and not isdefined("form.DdocumentoF")>
				<cfset form.DdocumentoF = url.DdocumentoF>
			</cfif>
			<cfif isdefined("url.fechaF") and not isdefined("form.fechaF")>
				<cfset form.fechaF = url.fechaF>
			</cfif>
			<cfif isdefined("url.SNnumeroF") and not isdefined("form.SNnumeroF")>
				<cfset form.SNnumeroF = url.SNnumeroF>
			</cfif>
			<cfif isdefined("url.SNcodigoF") and not isdefined("form.SNcodigoF")>
				<cfset form.SNcodigoF = url.SNcodigoF>
			</cfif>
			
			<!--- Filtro de las listas Aplicadas --->
			<table width="99%" align="center" cellpadding="0" cellspacing="0">
				<cfoutput>
				<tr>
					<td>
						<form style="margin:0;" name="filtroOrden" method="post" action="">						
						<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
							<tr>
								<td align="right"><strong>Documento:</strong></td>
								<td> 
									<input name="DdocumentoF" type="text" id="desc"
										<cfif isdefined('rsMaxDig') and rsMaxDig.recordCount GT 0 and rsMaxDig.Pvalor NEQ ''>
											 size="25" maxlength="#rsMaxDig.Pvalor#" 
										<cfelse>
											 size="25" maxlength="16" 
										</cfif>									
										value="<cfif isdefined("Form.DdocumentoF") and Form.DdocumentoF NEQ ''>#Form.DdocumentoF#</cfif>" onFocus="javascript:this.select();">
								</td>
								<td align="right"><strong>Fecha</strong></td>
								<td>
									<cfset fechaParam = "" >
									<cfif isdefined('form.fechaF') and form.fechaF NEQ ''>
										<cfset fechaParam = LSDateFormat(form.fechaF,'dd/mm/yyyy') >
									</cfif>
									<cf_sifcalendario form="filtroOrden" value="#fechaParam#" tabindex="1" name="fechaF">													
								</td>

								<td align="right"><strong>N&uacute;mero Socio</strong></td>
								<td> 
									<cfset valSNcodF = ''>
									<cfif isdefined('form.SNcodigoF') and form.SNcodigoF NEQ ''>
										<cfset valSNcodF = form.SNcodigoF>
									</cfif>												
									<cf_sifsociosnegocios2 form="filtroOrden" idquery="#valSNcodF#" sntiposocio="P" sncodigo="SNcodigoF" snnumero="SNnumeroF" frame="frame1">												
								</td>
			
								<td align="center">
									<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
								</td>
							</tr>
						</table>
							<fieldset><legend>Justificación</legend>
							<table  align="center"  border="0" cellspacing="0" cellpadding="0">
							  <tr>
								<td><textarea name="EDmotivoanul" rows="3" cols="125"></textarea></td>
							  </tr>
							  <tr>
								<td class="Ayuda" align="center"><span class="style1">Indíque en esta área el motivo de la anulación</span></td>
							  </tr>
							</table>
							</fieldset>
						</form>
					</td>
				</tr>
				</cfoutput>				
				<tr><td>
				
				<!--- Manejo del Filtro de las lista Aplicadas--->
				<cfset navegacion = "">
				
				<!--- MotivoAnula: campo para guardar el textarea que indica el motivo de la anulacion 
					  Boton: campo para indicar que se hizo click en alguno de los botones (anular)--->				
				<cfquery name="rsLista" datasource="#session.DSN#">
					Select a.EDIid, a.Ddocumento, a.Mcodigo, a.EDIfecha, b.Mnombre, 
						c.SNnumero, c.SNnombre, '' as MotivoAnula, '' as Boton,
						(select count(1) from DDocumentosI x where x.Ecodigo = a.Ecodigo and x.EDIid = a.EDIid) as CantidadLineas,
						(select sum(DDItotallinea) from DDocumentosI x where x.Ecodigo = a.Ecodigo and x.EDIid = a.EDIid) as SumaLineas,
						(select count(1) from DDocumentosI x inner join DPolizaDesalmacenaje y on y.DDlinea = x.DDlinea and y.Ecodigo = x.Ecodigo where x.Ecodigo = a.Ecodigo and x.EDIid = a.EDIid)
						+ (select count(1) from DDocumentosI x inner join FacturasPoliza y on y.DDlinea = x.DDlinea and y.Ecodigo = x.Ecodigo where x.Ecodigo = a.Ecodigo and x.EDIid = a.EDIid)
						+ (select count(1) from DDocumentosI x inner join CMImpuestosPoliza y on y.DDlinea = x.DDlinea and y.Ecodigo = x.Ecodigo where x.Ecodigo = a.Ecodigo and x.EDIid = a.EDIid) as CantidadLineasPoliza
					from EDocumentosI a
						inner join Monedas b
							on a.Mcodigo=b.Mcodigo
							and a.Ecodigo=b.Ecodigo
						inner join SNegocios c
							on a.SNcodigo=c.SNcodigo
							and a.Ecodigo=c.Ecodigo
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and a.EDIestado = 10
					and a.EPDid is not null
					and not exists(
						select 1 
						from DDocumentosI x 
							inner join FacturasPoliza  y 
								inner join EPolizaDesalmacenaje z
									on z.EPDid = y.EPDid 
									and z.Ecodigo = y.Ecodigo 
									and z.EPDestado = 10
								on y.DDlinea = x.DDlinea 
								and y.Ecodigo = x.Ecodigo 
						where x.Ecodigo = a.Ecodigo 
						and x.EDIid = a.EDIid
					)
					and not exists(
						select 1 
						from DDocumentosI x 
							inner join CMImpuestosPoliza y 
								inner join EPolizaDesalmacenaje z
									on z.EPDid = y.EPDid
									and z.Ecodigo = y.Ecodigo 
									and z.EPDestado = 10
								on y.DDlinea = x.DDlinea 
								and y.Ecodigo = x.Ecodigo 
						where x.Ecodigo = a.Ecodigo 
						and x.EDIid = a.EDIid
					)
					<cfif isdefined("Form.DdocumentoF") and Len(Trim(Form.DdocumentoF)) NEQ 0>
						and upper(Ddocumento) like '%#UCase(Form.DdocumentoF)#%'
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DdocumentoF=" & Form.DdocumentoF>
					</cfif>
					<cfif isdefined("Form.fechaF") and Len(Trim(Form.fechaF)) NEQ 0>
						and EDIfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fechaF)#">
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fechaF=" & Form.fechaF>
					</cfif>
					<cfif isdefined("Form.SNnumeroF") and Len(Trim(Form.SNnumeroF)) NEQ 0>
						and upper(SNnumero) like '%#UCase(Form.SNnumeroF)#%'
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SNnumeroF=" & Form.SNnumeroF>
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SNcodigoF=" & Form.SNcodigoF>
					</cfif>
						and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					Order by Ddocumento, EDIfecha
				</cfquery>
				
				<!--- Lista de Facturas Aplicadas ---->
				<cfinvoke component="sif.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet"> 
					<cfinvokeargument name="query" value="#rsLista#"/> 
					<cfinvokeargument name="desplegar" value="Ddocumento, EDIfecha, SNnumero, SNnombre, Mnombre, sumaLineas"/>
					<cfinvokeargument name="etiquetas" value="Documento, Fecha, N&uacute;mero de Socio, Nombre Socio, Moneda, Total"/>
					<cfinvokeargument name="formatos" value="S,D,S,S,S,N"/> 
					<cfinvokeargument name="align" value="left,left,left,left,left,right"/> 
					<cfinvokeargument name="ajustar" value="N"/> 
					<cfinvokeargument name="checkboxes" value="S"/> 
					<cfinvokeargument name="irA" value="anulaEDocumentosI-transaccion.cfm"/> 
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="showEmptyListMsg" value="yes"/>
					<cfinvokeargument name="botones" value="Anular"/>
					<cfinvokeargument name="keys" value="EDIid,CantidadLineasPoliza"/>
				</cfinvoke> 
				</td></tr>
			</table>
			
			<!--- Funciones de los botones de las listas --->
			<script language="javascript" type="text/javascript">
				<!--//
				function hayAlgunoChequeado(){
					if (document.lista.chk) {
						if (document.lista.chk.value) {
							if (document.lista.chk.checked)
								return true;
						} else {
							for (var i=0; i<document.lista.chk.length; i++) {
								if (document.lista.chk[i].checked) return true;
							}
						}
					}
					alert("Debe seleccionar al menos un documento!");
					return false;
				}
	
				function funcAnular(){
					if (hayAlgunoChequeado()) {
						if (document.filtroOrden.EDmotivoanul.value != ''){									//Evalua que se haya digitado un motivo para la anulación 					
							if (VerificaBorrarLineas()){
								document.lista.MOTIVOANULA.value = document.filtroOrden.EDmotivoanul.value;	//Se asigna a el input creado por la lista el textarea EDmotivoanul, porque el submit que se hace es de la lista no del form que contiene el text area
								document.lista.BOTON.value = 'btnAnular';									//Se asigna un valor al input boton(creado por la lista) para ejecutar el anulado de las transacciones
								document.lista.action = 'anulaEDocumentosI.cfm';							//Se envia al mismo archivo
								document.lista.submit();
								return true;
							}
						}else{alert('Debe indicar un motivo de anulación')}
					}
					return false;
				}
			
				function VerificaBorrarLineas() {
					if (document.lista.chk) {
						if (document.lista.chk.value) {
							if (document.lista.chk.checked) {
								if (document.lista.chk.value.split('|')[1]>0)
									return confirm('Una o mas de las líneas del documento seleccionado es utilizada en una Póliza de Desalmacenaje que está en proceso, si anula la factura las líneas serán eliminadas de la Póliza de desalmacenaje, desea anular la factura de todas maneras?');
							}								
						} else {
							for (var i=0; i<document.lista.chk.length; i++) {
								if (document.lista.chk[i].checked){
									if (document.lista.chk[i].value.split('|')[1]>0)
										return confirm('Una o mas de las líneas del documento seleccionado es utilizada en una Póliza de Desalmacenaje que está en proceso, si anula la factura las líneas serán eliminadas de la Póliza de desalmacenaje, desea anular la factura de todas maneras?');
								}
							}
						}
					}
					return confirm('Desea Anular las facturas marcadas?');
				}
				//-->
			</script>
			<br>
		<cf_web_portlet_end>
<cf_templatefooter>