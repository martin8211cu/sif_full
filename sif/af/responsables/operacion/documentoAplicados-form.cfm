<!--- Definición del modo de la pantalla --->
<cfif isdefined("form.CRDRid") and len(trim(form.CRDRid))>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<!--- Consulta si esta en algún sistema auxiliar --->
<cfquery name="rsDoc" datasource="#session.dsn#">
	select CRDRutilaux 
	from CRDocumentoResponsabilidad
	where  CRDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CRDRid#">
</cfquery>

<!--- Obtiene los datos de la tabla de Parámetros según el pcodigo --->
<cffunction name="ObtenerDato" returntype="query">
	<cfargument name="pcodigo" type="numeric" required="true">	
	<cfquery name="rs" datasource="#Session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo = #Session.Ecodigo#  
		  and Pcodigo = #Arguments.pcodigo#
	</cfquery>
	<cfreturn #rs#>
</cffunction>

<!--- Consulta de la tabla CRDocumentoResponsabilidad en modo CAMBIO --->
<cfif modo neq "ALTA" >
	<cfquery name="rsForm" datasource="#session.dsn#">
		select a.CRDRid, a.CRTDid, a.CRTCid, a.DEid, a.CFid, a.CRDRdescripcion, a.CRDRfdocumento, a.CRCCid, 
				a.CRDRplaca, a.CRDRdescdetallada, a.CRDRserie, a.CRDRtipodocori, a.CRDRdocori, a.CRDRlindocori, a.Monto,
				a.EOidorden, a.DOlinea, a.ts_rversion, 
				rtrim(b.CRTDcodigo) as CRTDcodigo, 
				b.CRTDdescripcion, 
				rtrim(c.CRTCcodigo) as CRTCcodigo, 
				c.CRTCdescripcion, 
				rtrim(d.DEidentificacion) as DEidentificacion, 
				<cf_dbfunction name="concat" args="d.DEapellido1 ,' ' ,d.DEapellido2 ,' ',d.DEnombre "> as DEnombrecompleto, 
				rtrim(e.CFcodigo) as CFcodigo, 
				e.CFdescripcion,
				rtrim(f.CRCCcodigo) as CRCCcodigo, 
				f.CRCCdescripcion,
				g.ACcodigo,
				rtrim(g.ACcodigodesc) as ACcodigodesc,
				g.ACdescripcion,
				g.ACmascara,
				h.ACid,
				rtrim(h.ACcodigodesc) as Cat_ACcodigodesc,h.ACdescripcion as Cat_ACdescripcion,
				i.AFCcodigo,
				rtrim(i.AFCcodigoclas) as AFCcodigoclas,
				i.AFCdescripcion,
				j.AFMid,
				rtrim(j.AFMcodigo) as AFMcodigo,
				j.AFMdescripcion,
				k.AFMMid,
				rtrim(k.AFMMcodigo) as AFMMcodigo,
				k.AFMMdescripcion,
				l.EOnumero, l.DOconsecutivo,
				a.CRorigen,
				g.ACatId idCategoria,
				h.AClaId idClase
				
		from CRDocumentoResponsabilidad a 
				left outer join CRTipoDocumento b on 
					a.CRTDid = b.CRTDid
				left outer join CRTipoCompra c on 
					a.CRTCid = c.CRTCid
				left outer join DatosEmpleado d on
					a.DEid = d.DEid
				left outer join CFuncional e on
					a.CFid = e.CFid
				left outer join CRCentroCustodia f on
					a.CRCCid = f.CRCCid
				left outer join ACategoria g on
					a.ACcodigo = g.ACcodigo
					and a.Ecodigo = g.Ecodigo
				left outer join AClasificacion h on
					a.ACcodigo = h.ACcodigo
					and a.ACid = h.ACid
					and a.Ecodigo = h.Ecodigo
				left outer join AFClasificaciones i on
					a.AFCcodigo = i.AFCcodigo
					and a.Ecodigo = i.Ecodigo
				left outer join AFMarcas j on
					a.AFMid = j.AFMid
				left outer join AFMModelos k on
					a.AFMMid = k.AFMMid
				left outer join DOrdenCM l on
					a.DOlinea = l.DOlinea
					
		where CRDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRDRid#">
	 </cfquery>
</cfif>

<cfif (modo eq "CAMBIO") >
	<cfset paramsUri = ''>
	<cfset paramsUri = paramsUri & '&CRDRid=#form.CRDRid#'>
</cfif>

<!--- Pintado del formulario --->
<cfoutput>
<form  name="form1" method="post" action="documentoAplicados-sql.cfm" >		
	<cfif (modo neq "ALTA")>
		<input type="hidden" name="CRDRid" id="CRDRid" value="#rsForm.CRDRid#">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts" artimestamp="#rsForm.ts_rversion#"/>
		<input type="hidden" name="ts_rversion" id="ts_rversion" value="#ts#">
	</cfif>

	<table width="500" align="center" border="0" cellspacing="0" cellpadding="2">
		<tr>
			<td width="150" nowrap="nowrap" class="fileLabel"><p><strong>Centro de Custodia:</strong>&nbsp;</p></td>				
			<td width="700" nowrap="nowrap" class="fileLabel" colspan="3" >#rsForm.CRCCcodigo# - #rsForm.CRCCdescripcion#</td>
			<cfif (modo eq "CAMBIO") >
				<td><cf_rhimprime datos="/sif/af/responsables/operacion/documento-Impr.cfm" paramsuri="#paramsUri#"></td>
			</cfif>
		</tr>
		<tr>
			<td  colspan="5" nowrap="nowrap" class="fileLabel">&nbsp;</td>
		</tr>
		<tr>
			<td  colspan="5"  nowrap="nowrap" class="subtitulo_seccion_small">
				<!--- INI Información del Activo --->
				<div id="div_CF" style="display:;">
					<fieldset>
					<legend>Informaci&oacute;n del Activo</legend>
						<table width="100%"  border="0" cellspacing="2" cellpadding="2">
							<tr>
								<td nowrap="nowrap" class="fileLabel"><p><strong>Categor&iacute;a:</strong>&nbsp;</p></td>
								<td nowrap="nowrap" class="fileLabel">#rsForm.ACcodigodesc# - #rsForm.ACdescripcion#</td>
								<td nowrap="nowrap" class="fileLabel">&nbsp;</td>
								<td nowrap="nowrap" class="fileLabel"><p><strong>Clase:</strong>&nbsp;</p></td>
								<td nowrap="nowrap" class="fileLabel">#rsForm.Cat_ACcodigodesc# - #rsForm.Cat_ACdescripcion#</td>
							</tr>
							<tr>
								<td nowrap="nowrap" class="fileLabel"><p><strong>Placa:</strong>&nbsp;</p></td>
								<td nowrap="nowrap" class="fileLabel">#rsForm.CRDRplaca#</td>
								<td nowrap="nowrap" class="fileLabel">&nbsp;</td>
								<td nowrap="nowrap" class="fileLabel"><p><strong>Descripci&oacute;n:</strong>&nbsp;</p></td>
								<td nowrap="nowrap" class="fileLabel">#rsForm.CRDRdescripcion#</td>
							</tr>
							<tr>
								<td nowrap="nowrap" class="fileLabel"><p><strong>Marca:&nbsp;</strong></p></td>
								<td nowrap="nowrap" class="fileLabel">#rsForm.AFMcodigo# - #rsForm.AFMdescripcion#</td>
								<td nowrap="nowrap" class="fileLabel">&nbsp;</td>
								<td nowrap="nowrap" class="fileLabel"><p><strong>Modelo:&nbsp;</strong></p></td>
								<td nowrap="nowrap" class="fileLabel">#rsForm.AFMMcodigo# - #rsForm.AFMMdescripcion#</td>
							</tr>
							<tr>
								<td nowrap="nowrap" class="fileLabel"><p><strong>Tipo:</strong>&nbsp;</p></td>
								<td nowrap="nowrap" class="fileLabel">#rsForm.AFCcodigoclas# - #rsForm.AFCdescripcion#</td>
								<td nowrap="nowrap" class="fileLabel">&nbsp;</td>	
								<td nowrap="nowrap" class="fileLabel"><p><strong>Descripci&oacute;n Detallada:</strong>&nbsp;</p></td>
								<td nowrap="nowrap" class="fileLabel">#rsForm.CRDRdescdetallada#</td>
							</tr>
							<tr>
								<td nowrap="nowrap" class="fileLabel"><p><strong>Serie:&nbsp;</strong></p></td>
								<td nowrap="nowrap" class="fileLabel">#rsForm.CRDRserie#</td>
								<td nowrap="nowrap" class="fileLabel">&nbsp;</td>	
								<td nowrap="nowrap" class="fileLabel"><p><strong>Monto:</strong>&nbsp;</p></td>
								<td nowrap="nowrap" class="fileLabel">#LSNumberFormat(rsForm.Monto, ',9.00')#</td>
							<tr>
						</table>
					</fieldset>
				</div>
				<!--- FIN Información del Activo --->
			</td>				
		</tr>
		<tr>
			<td  colspan="5" nowrap="nowrap" class="fileLabel">&nbsp;</td>
		</tr>
		<tr>
			<td  colspan="5"  nowrap="nowrap" class="subtitulo_seccion_small">
				<!--- Información del Documento --->
				<div id="div_CF" style="display:;">
					<fieldset>
					<legend>Informaci&oacute;n del Documento</legend>
						<table width="100%"  border="0" cellspacing="2" cellpadding="2">
							<tr>
								<td nowrap="nowrap" class="fileLabel"><p><strong>Tipo de Documento:</strong>&nbsp;</p></td>
								<td nowrap="nowrap" class="fileLabel">#rsForm.CRTDcodigo# - #rsForm.CRTDdescripcion#</td>
								<td nowrap="nowrap" class="fileLabel">&nbsp;</td>
								<td nowrap="nowrap" class="fileLabel"><p><strong>Fecha</strong>:&nbsp;</p></td>
								<td nowrap="nowrap" class="fileLabel">#LSDateFormat(rsForm.CRDRfdocumento,'dd/mm/yyyy')#</td>
							</tr>
							<tr>
								<td nowrap="nowrap" class="fileLabel"><p><strong>Empleado:</strong>&nbsp;</p></td>
								<td nowrap="nowrap" class="fileLabel">#rsForm.DEidentificacion# - #rsForm.DEnombrecompleto#</td>
								<td nowrap="nowrap" class="fileLabel">&nbsp;</td>
								<td nowrap="nowrap" class="fileLabel"><p><strong>Centro Funcional:&nbsp;</strong></p></td>
								<td nowrap="nowrap" class="fileLabel">#rsForm.CFcodigo# - #rsForm.CFdescripcion#</td>
							</tr>
						</table>
					</fieldset>
				</div>
			</td>
		</tr>
		<tr>
			<td  colspan="5" nowrap="nowrap" class="fileLabel">&nbsp;</td>
		</tr>
		<tr>
			<td  colspan="5"  nowrap="nowrap" class="subtitulo_seccion_small">
				<!--- Información del Documento Origen (Factura, Orden de Compra) --->
				<div id="div_CF" style="display:;">
					<fieldset>
					<legend>Informaci&oacute;n del Origen</legend>
						<table width="100%"  border="0" cellspacing="2" cellpadding="2">
							<tr>
								<td nowrap="nowrap" class="fileLabel"><p><strong>Tipo de Compra:</strong>&nbsp;</p></td>
								<td nowrap="nowrap" class="fileLabel" colspan="2">#rsForm.CRTCcodigo# - #rsForm.CRTCdescripcion#</td>
								<td nowrap="nowrap" class="fileLabel">&nbsp;</td>
								<td nowrap="nowrap" class="fileLabel">&nbsp;</td>
							</tr>
							<tr>
								<td nowrap="nowrap" class="fileLabel"><p><strong>Documento:</strong>&nbsp;</p></td>
								<td nowrap="nowrap" class="fileLabel" colspan="2">#rsForm.CRDRdocori#</td>
								<td nowrap="nowrap" class="fileLabel"><p><strong>Orden de Compra:&nbsp;</strong></p></td>
								<td nowrap="nowrap" class="fileLabel"><cfif LEN(TRIM(rsForm.EOnumero))>#rsForm.EOnumero#<cfelse>No definido</cfif></td>
							</tr>
							<tr>
								<td nowrap="nowrap" class="fileLabel"><p><strong>L&iacute;nea:&nbsp;</strong></p></td>
								<td nowrap="nowrap" class="fileLabel" colspan="2"><cfif LEN(TRIM(rsForm.CRDRlindocori))>#rsForm.CRDRlindocori#<cfelse>No definido</cfif></td>
								<td nowrap="nowrap" class="fileLabel"><p><strong>Línea de O.C.:&nbsp;</strong></p></td>
								<td nowrap="nowrap" class="fileLabel"><cfif LEN(TRIM(rsForm.DOconsecutivo))>#rsForm.DOconsecutivo#<cfelse>No definido</cfif></td>
							</tr>
							<cfset OrigenA = ObtenerDato(1110)>
							<tr>
								<td nowrap="nowrap" class="fileLabel"><p><strong><cfif OrigenA.RecordCount gt 0 and len(trim(OrigenA.Pvalor))><cfoutput>#OrigenA.Pvalor#</cfoutput><cfelse>Origen</cfif>:&nbsp;</strong></p></td>
								<td nowrap="nowrap" class="fileLabel" colspan="2"><cfif LEN(TRIM(rsForm.CRorigen))>#rsForm.CRorigen#<cfelse>No definido</cfif></td>
							</tr>
						</table>
					</fieldset>
				</div>
			</td>
		</tr>
		<!---===Datos Variables===--->
		<tr><td colspan="5">&nbsp;</td></tr>
		<tr>
			<td colspan="5">
			<cfif modo NEQ 'ALTA'>
				<fieldset><legend>Otros Datos</legend>
						<cfset Tipificacion = StructNew()> 
						<cfset temp = StructInsert(Tipificacion, "AF", "")> 
						<cfset temp = StructInsert(Tipificacion, "AF_CATEGOR", "#rsForm.idCategoria#")> 
						<cfset temp = StructInsert(Tipificacion, "AF_CLASIFI", "#rsForm.idClase#")> 
					<cfinvoke component="sif.Componentes.DatosVariables" method="PrintDatoVariable" returnvariable="Cantidad">
						<cfinvokeargument name="DVTcodigoValor" value="AF">
						<cfinvokeargument name="Tipificacion"   value="#Tipificacion#">
						<cfinvokeargument name="DVVidTablaVal"  value="#rsForm.CRDRid#">
						<cfinvokeargument name="form" 			value="form1">
						<cfinvokeargument name="NumeroColumas"  value="3">
						<cfinvokeargument name="DVVidTablaSec" 	value="1"><!---(0=Activos)(1=CRDocumentoResponsabilidad) (2=DSActivosAdq)--->
						<cfinvokeargument name="readonly" 		value="true">
					</cfinvoke>
					<cfif Cantidad EQ 0>
						<div align="center">No Existen Datos Variables Asignados al Activo</div>
					</cfif>
				</fieldset>
			</cfif>
			</td>
		</tr>
		<cfif rsDoc.CRDRutilaux EQ 1>
			<tr>
				<td  colspan="5" nowrap="nowrap" class="fileLabel">&nbsp;</td>
			</tr>
			<tr>
				<td  colspan="5"  nowrap="nowrap" class="subtitulo_seccion_small">
					<!--- Información del Documento --->
					<div id="div_CF" style="display:;">
						<fieldset>
						<legend></legend>
							<table width="100%"  border="0" cellspacing="2" cellpadding="2">
								<tr align="center">
									<td nowrap="nowrap" class="fileLabel" style="color:##FF0000; font-weight:bold; ">
										<p>Este documento no puede ser modificado porque ya fue utilizado en un sistema auxiliar.</p>
									</td>
								</tr>
							</table>
						</fieldset>
					</div>
				</td>
			</tr>
		</cfif>
	</table>
	
	<!--- Definición de botones --->
	<cfset include = "">
	<cfset exclude = "">		
	<cfset include = ListAppend(include,"Regresar")>
	<cfif rsDoc.CRDRutilaux NEQ 1>
		<cfset include = ListAppend(include,"Recuperar")>
	</cfif>
	<cfset exclude = ListAppend(exclude,"Nuevo")>
	<cfset exclude = ListAppend(exclude,"Baja")>
	<cfset exclude = ListAppend(exclude,"Cambio")>
	<cf_botones modo="#modo#" include="#include#" exclude="#exclude#" tabindex="9">

</form>
</cfoutput>

<script language="javascript" type="text/javascript">
	function funcRegresar() {
		document.form1.action="documentoAplicados.cfm";
		<cfif (modo neq "ALTA")>
			document.form1.CRDRid.value = "";
		</cfif>
		return true;
	}
	
	<cfif modo neq "ALTA" >
		function funcRecuperar(){
			if (!confirm('Desea Aplicar el documento?')){
				return false;
			}
		}
	</cfif>
</script>