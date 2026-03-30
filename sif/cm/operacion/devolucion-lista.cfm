<cfparam name="form.tipo" default="D">
<cfset titulo = "Devoluci&oacute;n">

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

<cfif isdefined("Url.SNnumero") and not isdefined("Form.SNnumero")>
	<cfparam name="Form.SNnumero" default="#Url.SNnumero#">
</cfif>

<cfif isdefined("Url.Observaciones") and not isdefined("Form.Observaciones")>
	<cfparam name="Form.Observaciones" default="#Url.Observaciones#">
</cfif>

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
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SNnumero=" & Form.SNnumeroF>
</cfif>
<script language="JavaScript">
	function limpiar() {
		document.filtroOrden.Usucodigo.value = '';
		document.filtroOrden.Nombre.value = '';
		document.filtroOrden.EDRnumero.value = '';
		document.filtroOrden.EDRreferencia.value = '';
		document.filtroOrden.EDRreferencia.value = '';
		document.filtroOrden.Usucodigo.value = '';
		document.filtroOrden.SNcodigoF.value = '';
		document.filtroOrden.SNnombre.value = '';
		document.filtroOrden.SNnumeroF.value = '';
		document.filtroOrden.fecha.value = '';
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
									<form style="margin:0;" name="filtroOrden" method="post" action="devolucion-lista.cfm">
									<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
										
										<tr>
											<td align="right">&nbsp;</td>
											<td align="right"><strong>N&uacute;mero</strong></td>
											<td>
                                              <input name="EDRnumero" type="text" id="desc" size="20" maxlength="20" value="<cfif isdefined("Form.EDRnumero")>#Form.EDRnumero#</cfif>" onFocus="javascript:this.select();">
                                            </td>
											<td align="right"><strong>Referencia</strong></td>
											<td>
                                              <input name="EDRreferencia" type="text" id="desc" size="20" maxlength="20" value="<cfif isdefined("Form.EDRreferencia")>#Form.EDRreferencia#</cfif>" onFocus="javascript:this.select();">
                                            </td>
											<td align="right"><strong>Fecha</strong></td>
											<td>
											<cfif isdefined("Form.fecha") and Len(Trim(Form.fecha)) NEQ 0>
												<cf_sifcalendario form="filtroOrden" value="#Form.fecha#">
											<cfelse>
												<cf_sifcalendario form="filtroOrden">
											</cfif>
											
											
											</td>
											<td>&nbsp;</td>
						
											<td align="center">
												<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
												<input name="tipo" type="hidden" id="tipo" value="#form.tipo#">
											</td>
										</tr>
										<tr>
										  <td align="right">&nbsp;</td>
										  <td align="right"><strong>Solicitante</strong></td>
										  <td>
                                            <cfif not isdefined("form.Usucodigo")>
                                              <cf_sifusuarioE conlis="true" form="filtroOrden" idusuario="#session.Usucodigo#" size="40"  frame="frame1">
                                              <cfelse>
                                              <cf_sifusuarioE form="filtroOrden" idusuario="#form.Usucodigo#" size="40"  frame="frame1">
                                            </cfif>
                                          </td>
										  <td align="right"><strong>N&uacute;mero Socio</strong></td>
										  <td>
                                            <cfset valSNcodF = ''>
                                            <cfif isdefined('form.SNcodigoF') and form.SNcodigoF NEQ ''>
                                              <cfset valSNcodF = form.SNcodigoF>
                                            </cfif>
                                            <cf_sifsociosnegocios2 form="filtroOrden" idquery="#valSNcodF#" sntiposocio="P" sncodigo="SNcodigoF" snnumero="SNnumeroF" frame="frame1"> </td>
										  <td>&nbsp;</td>
										  <td align="right">&nbsp;</td>
										  <td>&nbsp;</td>
										  <td align="center"><input name="btnLimpiar" type="button" id="btnLimpiar" value="Limpiar" onClick="javascript:limpiar();"></td>
									  </tr>
									</table>
									</form>
								</td>
							</tr>	
							<tr>
								<td>
                                	<cfinclude template="../../Utiles/sifConcat.cfm">
									<cfquery name="rsLista" datasource="#session.DSN#">
										select distinct a.EDRid, a.EDRnumero, a.EDRreferencia, a.EDRfechadoc, a.EDRfecharec, 
											   a.SNcodigo, b.SNnumero,  b.SNnumero #_Cat# '' #_Cat# b.SNnombre as SNnombre, 
											   '#form.tipo#'  as tipo,
											    (select sum(DDRtotallin)
												from DDocumentosRecepcion ddr
												where ddr.EDRid = a.EDRid
												group by ddr.EDRid ) - a.EDRdescpro + a.EDRimppro as totallin
										from EDocumentosRecepcion a
											
											inner join SNegocios b
											on a.SNcodigo=b.SNcodigo
												and a.Ecodigo=b.Ecodigo
												#preservesinglequotes(filtrosocio)#
										
											inner join TipoDocumentoR c
											on c.TDRcodigo=a.TDRcodigo
											   and a.Ecodigo=c.Ecodigo
											   and c.TDRtipo=<cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo#">
											inner join DDocumentosRecepcion  d
											on a.Ecodigo = d.Ecodigo
											   and a.EDRid = d.EDRid
										
										where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											and a.EDRestado=0
											<cfif isdefined("Form.fecha") and Len(Trim(Form.fecha)) NEQ 0>
												and a.EDRfechadoc = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fecha)#">
											</cfif>
											#preservesinglequotes(filtroorden)#
									</cfquery>
								
									<cfinvoke component="sif.Componentes.pListas"
											method="pListaQuery"
											returnvariable="pListaRet"> 
										<cfinvokeargument name="query" value="#rsLista#"/> 
										<cfinvokeargument name="desplegar" value="EDRnumero, EDRreferencia, EDRfechadoc,SNnombre, totallin"/>
										<cfinvokeargument name="etiquetas" value="N&uacute;mero,Referencia,Fecha, Nombre Socio, Total"/>
										<cfinvokeargument name="formatos" value="S,S,D,S, M"/> 
										<cfinvokeargument name="align" value="left,left,left,left, right"/> 
										<cfinvokeargument name="ajustar" value="N"/> 
										<cfinvokeargument name="checkboxes" value="S"/> 
										<cfinvokeargument name="keys" value="EDRid"/>
										<cfinvokeargument name="irA" value="devolucion.cfm"/> 
										<cfinvokeargument name="navegacion" value="#navegacion#"/>
										<cfinvokeargument name="showEmptyListMsg" value="yes"/>
										<cfinvokeargument name="botones" value="Nuevo,Aplicar"/>
										<cfinvokeargument name="maxrows" value="1"/>
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
		document.lista.TIPO.value = 'D';
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
				document.lista.action = "devolucion-sql.cfm";
				return true;
			}else{
				return false;
			}
		}
		return false;
	}
	
</script>