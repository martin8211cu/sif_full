<cfparam name="form.tipo" default="R">
<!--- Define el Modo --->
<!--- Recibe conexion, form, name y desc --->
<cfif isdefined("Url.tipo") and not isdefined("Form.tipo")>
	<cfset form.tipo = url.tipo >
</cfif>
<cfset titulo = "Recepci&oacute;n">
<cfif form.tipo eq 'D'>
	<cfset titulo = "Devoluci&oacute;n">
</cfif>

<!--- Recibe conexion, form, name y desc --->
<cfif isdefined("Url.EOidorden") and not isdefined("Form.EOidorden")>
	<cfparam name="Form.EOidorden" default="#Url.EOidorden#">
</cfif>

<cfif isdefined("Url.EDRnumero") and not isdefined("Form.EDRnumero")>
	<cfparam name="Form.EDRnumero" default="#Url.EDRnumero#">
</cfif>

<cfif isdefined("Url.EDRreferencia") and not isdefined("Form.EDRreferencia")>
	<cfparam name="Form.EDRreferencia" default="#Url.EDRreferencia#">
</cfif>

<cfif isdefined("Url.fecha") and not isdefined("Form.fecha")>
	<cfparam name="Form.fecha" default="#Url.fecha#">
</cfif>

<cfif isdefined("Url.SNnumeroF") and not isdefined("Form.SNnumeroF")>
	<cfparam name="Form.SNnumeroF" default="#Url.SNnumeroF#">
</cfif>

<cfif isdefined("Url.SNcodigoF") and not isdefined("Form.SNcodigoF")>
	<cfparam name="Form.SNcodigoF" default="#Url.SNcodigoF#">
</cfif>

<cfif isdefined("Url.Observaciones") and not isdefined("Form.Observaciones")>
	<cfparam name="Form.Observaciones" default="#Url.Observaciones#">
</cfif>

<cfif isdefined("Url.EDRestado") and not isdefined("Form.EDRestado")>
	<cfparam name="Form.EDRestado" default="#Url.EDRestado#">
</cfif>

<cfif isdefined("Url.Usucodigo") and not isdefined("Form.Usucodigo")>
	<cfparam name="Form.Usucodigo" default="#Url.Usucodigo#">
</cfif>

<cfset filtro = "">
<cfset filtroorden = "">
<cfset filtrosocio = "">
<cfset navegacion = "">

<cfif isdefined("Form.EOidorden") and Len(Trim(Form.EOidorden)) NEQ 0>
	<cfset filtro = filtro & " and CFcodigo = " & Form.EOidorden >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EOidorden=" & Form.EOidorden>
</cfif>
<cfif isdefined("Form.EDRnumero") and Len(Trim(Form.EDRnumero)) NEQ 0>
	<cfset filtroorden = filtroorden & " and upper(EDRnumero) like '%" & #UCase(Form.EDRnumero)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(EDRnumero)) NEQ 0, DE("&"), DE("")) & "EDRnumero=" & Form.EDRnumero>
</cfif>

<cfif isdefined("Form.EDRreferencia") and Len(Trim(Form.EDRreferencia)) NEQ 0>
 	<cfset filtroorden = filtroorden & " and upper(EDRreferencia) like '%" & #UCase(Form.EDRreferencia)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(EDRreferencia)) NEQ 0, DE("&"), DE("")) & "EDRreferencia=" & Form.EDRreferencia>
</cfif>

<cfif isdefined("Form.fecha") and Len(Trim(Form.fecha)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(fecha)) NEQ 0, DE("&"), DE("")) & "fecha=" & Form.fecha>
</cfif>

<cfif isdefined("Form.SNnumeroF") and Len(Trim(Form.SNnumeroF)) NEQ 0>
 	<cfset filtrosocio = filtrosocio & " and SNnumero like '%" & #UCase(Form.SNnumeroF)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SNnumeroF=" & Form.SNnumeroF>
</cfif>

<cfif isdefined("Form.SNcodigoF") and Len(Trim(Form.SNcodigoF)) neq 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SNcodigoF=" & Form.SNcodigoF>
</cfif>

<cfif isdefined("Form.EDRestado") and Len(Trim(Form.EDRestado)) neq 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EDRestado=" & Form.EDRestado>
</cfif>

<cfif isdefined("Form.Usucodigo") and Len(Trim(Form.Usucodigo)) neq 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Usucodigo=" & Form.Usucodigo>
</cfif>

<!--- Obtiene el valor del parámetro de Aprobación de Excesos de Tolerancia por Compradores --->
<cfquery name="rsParametroTolerancia" datasource="#session.dsn#">
	select Pvalor
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="760">
</cfquery>

<script language="JavaScript">
	function limpiar() {
		document.filtroOrden.Usucodigo.value = '';
		document.filtroOrden.EDRnumero.value = '';
		document.filtroOrden.SNcodigoF.value = '';
		document.filtroOrden.SNnombre.value = '';
		document.filtroOrden.SNnumeroF.value = '';
		document.filtroOrden.EDRreferencia.value = '';
		document.filtroOrden.fecha.value = '';
		document.filtroOrden.Nombre.value = '';
		document.filtroOrden.EDRestado.value = '0';
	}
</script>

<cf_templateheader title="	Compras">

		<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Documentos de <cfoutput>#titulo#</cfoutput>'>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
            	<tr><td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td></td></tr>
				<tr>
					<td>
						<cfoutput>
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr>
								<td>
									<!--- Filtro de la lista de documentos de recepción --->
									<form style="margin:0;" name="filtroOrden" method="post" action="documentos-lista.cfm">
									<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
										<tr>
											<td align="right">&nbsp;</td>
											<!--- Número de documento --->
											<td align="right"><strong>N&uacute;mero</strong></td>
											<td>
                                              <input name="EDRnumero" type="text" id="desc" size="20" maxlength="20" value="<cfif isdefined("Form.EDRnumero")>#Form.EDRnumero#</cfif>" onFocus="javascript:this.select();">
                                            </td>
											<!--- Referencia --->
											<td align="right"><strong>Referencia</strong></td>
											<td>
                                              <input name="EDRreferencia" type="text" id="desc" size="20" maxlength="20" value="<cfif isdefined("Form.EDRreferencia")>#Form.EDRreferencia#</cfif>" onFocus="javascript:this.select();">
                                            </td>
											<!--- Fecha del documento --->
											<td align="right"><strong>Fecha</strong></td>
											<td>
												<cfif isdefined("form.fecha")>
													<cf_sifcalendario form="filtroOrden" value="#form.fecha#">
												<cfelse>
													<cf_sifcalendario form="filtroOrden">
												</cfif>
											</td>
											<td>&nbsp;</td>
											<!--- Filtrar --->
											<td align="center">
												<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
												<input name="tipo" type="hidden" id="tipo" value="#form.tipo#">
											</td>
										</tr>
										<tr>
											<td align="right">&nbsp;</td>
											<!--- Usuario que registró la recepción --->
											<td align="right"><strong>Recepciones de:</strong></td>
											<td>
												<cfif isdefined("form.Usucodigo") and form.Usucodigo NEQ ''>
													<cf_sifusuarioE form="filtroOrden" idusuario="#form.Usucodigo#" size="40"  frame="frame1">
												<cfelse>
													<cf_sifusuarioE conlis="true" form="filtroOrden" idusuario="#session.Usucodigo#" size="40"  frame="frame1">
												</cfif>
											</td>
											<!--- Proveedor --->
											<td align="right"><strong>N&uacute;mero Socio</strong></td>
											<td>
												<cfset valSNcodF = ''>
												<cfif isdefined('form.SNcodigoF') and form.SNcodigoF NEQ ''>
													<cfset valSNcodF = form.SNcodigoF>
												</cfif>
												<cf_sifsociosnegocios2 form="filtroOrden" idquery="#valSNcodF#" sntiposocio="P" sncodigo="SNcodigoF" snnumero="SNnumeroF" frame="frame1">
											</td>
											<cfif rsParametroTolerancia.RecordCount gt 0 and rsParametroTolerancia.Pvalor eq 1 and form.tipo eq "R">
												<!--- Estado del documento --->
												<td align="right"><strong>Estado:</strong>&nbsp;</td>
												<td>
													<select name="EDRestado">
														<option value="0" <cfif not isdefined('form.EDRestado') or len(trim(form.EDRestado)) eq 0>selected</cfif>>Todos</option>
														<option value="1" <cfif isdefined('form.EDRestado') and form.EDRestado eq 1>selected</cfif>>No Aplicados</option>
														<option value="2" <cfif isdefined('form.EDRestado') and form.EDRestado eq 2>selected</cfif>>Tolerancia Aprobada</option>
													</select>
												</td>
											<cfelse>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
											</cfif>
											<td>&nbsp;</td>
											<!--- Limpiar filtros --->
											<td align="center"><input name="btnLimpiar" type="button" id="btnLimpiar" value="Limpiar" onClick="javascript:limpiar();"></td>
										</tr>
									</table>
									</form>
								</td>
							</tr>
							<tr>
								<td>
                                	<cfinclude template="../../Utiles/sifConcat.cfm">
									<!--- Obtiene la lista --->
									<cfquery name="rsLista" datasource="#session.DSN#">
										select 	distinct a.EDRid, a.EDRnumero, a.EDRreferencia, a.EDRfechadoc, a.EDRfecharec, 
											   	a.SNcodigo, b.SNnumero,  b.SNnumero #_Cat# '-' #_Cat# b.SNnombre as SNnombre, 
											   	'#form.tipo#'  as tipo, j.Mnombre,
											   	coalesce(
											   		(select sum(DDRtotallin) - sum(DDRdesclinea) + sum(DDRmtoimpfact)
													from DDocumentosRecepcion ddr
													where ddr.EDRid = a.EDRid
													),0)   as totallin,
													(select sum(DDRtotallin) 
															+ case when a.EPDid is null then sum(((DDRtotallincd)*Iporcentaje)/100) else 0 end
															- sum(DDRdesclinea)
													from DDocumentosRecepcion ddr
														left outer join Impuestos im
															on ddr.Ecodigo = im.Ecodigo
															and ddr.Icodigo = im.Icodigo																													
													where ddr.EDRid = a.EDRid
													) as total,
													case when 
														(
														coalesce( 
															(select count(1) 
																from DDocumentosRecepcion ddr
																where ddr.EDRid = a.EDRid
															)
														, 0)
														= 0
														) then a.EDRid else 0 end as inactivecol													
										from EDocumentosRecepcion a
											
											inner join Monedas j
												on a.Mcodigo = j.Mcodigo
												and a.Ecodigo = j.Ecodigo
											
											inner join SNegocios b
											on a.SNcodigo=b.SNcodigo
												and a.Ecodigo=b.Ecodigo
												#preservesinglequotes(filtrosocio)#
										
											inner join TipoDocumentoR c
												on c.TDRcodigo=a.TDRcodigo
											   and a.Ecodigo=c.Ecodigo
											   and c.TDRtipo=<cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo#">
											
											left outer join DDocumentosRecepcion  d
												on a.Ecodigo = d.Ecodigo
											   and a.EDRid = d.EDRid
											   
											   left outer join Impuestos i
												on d.Ecodigo = i.Ecodigo
												and d.Icodigo = i.Icodigo

										where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											<cfif rsParametroTolerancia.RecordCount gt 0 and rsParametroTolerancia.Pvalor eq 1 and form.tipo eq "R">
												<cfif isdefined("Form.EDRestado") and Len(Trim(Form.EDRestado)) gt 0>
													<cfif Form.EDRestado eq 0>
														and a.EDRestado in (0, 5)
													<cfelseif Form.EDRestado eq 1>
														and a.EDRestado = 0
													<cfelseif Form.EDRestado eq 2>
														and a.EDRestado = 5
													</cfif>
												<cfelse>
													and a.EDRestado in (0, 5)
												</cfif>
											<cfelse>
												and a.EDRestado = 0
											</cfif>
											<cfif isdefined("Form.Usucodigo") and Len(Trim(Form.Usucodigo)) NEQ 0>
												and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
 											<cfelse>
												and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">											
											</cfif>
											<cfif isdefined("Form.fecha") and Len(Trim(Form.fecha)) NEQ 0>
												and a.EDRfechadoc = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fecha)#">
											</cfif>
											#preservesinglequotes(filtroorden)#
										order by a.EDRid
									</cfquery>

									<!--- Muestra la lista --->
									<cfinvoke component="sif.Componentes.pListas"
											method="pListaQuery"
											returnvariable="pListaRet">
										<cfinvokeargument name="query" value="#rsLista#"/>
										<cfinvokeargument name="desplegar" value="EDRnumero, EDRreferencia, EDRfechadoc,SNnombre, Mnombre, total"/>
										<cfinvokeargument name="etiquetas" value="N&uacute;mero,Referencia,Fecha, Nombre Socio, Moneda, Total"/>
										<cfinvokeargument name="formatos" value="S,S,D,S,V,M"/>
										<cfinvokeargument name="align" value="left,left,left,left,left,right"/>
										<cfinvokeargument name="ajustar" value="N"/>
										<cfinvokeargument name="keys" value="EDRid"/>
										<cfinvokeargument name="checkboxes" value="S"/>
										<cfinvokeargument name="inactivecol" value="inactivecol"/>
										<cfinvokeargument name="irA" value="documentos.cfm"/>
										<cfinvokeargument name="navegacion" value="#navegacion#"/>
										<cfinvokeargument name="showEmptyListMsg" value="yes"/>
										<cfinvokeargument name="botones" value="Nuevo, Aplicar"/>
									</cfinvoke>
								</td>
							</tr>
						</table>
						</cfoutput>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>

<script language="javascript1.2" type="text/javascript">
	function funcNuevo(){
		document.lista.EDRID.value = '';
		
		<cfif form.tipo eq 'R'>
			document.lista.TIPO.value = 'R';
		<cfelse>
			document.lista.TIPO.value = 'D';
		</cfif>	
	}

<!--- Funciones de los botones de las listas --->
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
		alert("Debe seleccionar al menos un documento !");
		return false;
	}

	function funcAplicar(){
		if (hayAlgunoChequeado()) {
			if (confirm('Desea aplicar los documentos marcados')){
				<cfif form.tipo eq 'R'>
					document.lista.TIPO.value = 'R';
				<cfelse>
					document.lista.TIPO.value = 'D';
				</cfif>	
				document.lista.action = "documentos-sql.cfm";
				return true;
			}else{
				return false;
			}
		}
		return false;
	}

</script>
