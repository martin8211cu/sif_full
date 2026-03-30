
<!--- Pasa la llave del Url al Form --->
<cfif isdefined("url.idDetalle") and len(trim(url.idDetalle))>
	<cfset form.idDetalle = url.idDetalle>
</cfif>
<cfif isdefined("url.CCTcodigo") and len(trim(url.CCTcodigo))>
	<cfset form.CCTcodigo = url.CCTcodigo>
</cfif>
<!--- Establezco el modo del detalle de documentos de cxc --->
<cfset modocxc = "ALTA">
<cfif isdefined("form.idDetalle") and len(trim(form.idDetalle)) GT 0 and isdefined("form.CCTcodigo") and len(trim(form.CCTcodigo)) GT 0 >
	<cfset modocxc = "CAMBIO">
</cfif>

<!--- Consultas del form de documentos de CXC --->
<!--- 1. Obtiene los datos del Documento de CXC cuando el modo es CAMBIO --->
<cfif modocxc EQ "CAMBIO">
	<cfquery name="rsDocCompensacionDCxC" datasource="#session.dsn#">
		SELECT a.idDetalle,
		       a.idDocCompensacion,
		       a.CCTcodigo,
		       a.Ddocumento,
		       a.BMUsucodigo,
		       a.Referencia,
		       a.ts_rversion,
		       a.Dmonto,
		       a.DmontoRet,
		       a.Dmonto + coalesce(DmontoRet, 0) AS DmontoDoc,
		       b.Dsaldo,
		       b.SNcodigo,
		       b.CCTcodigo
		FROM DocCompensacionDCxC a
		LEFT OUTER JOIN Documentos b ON b.Ecodigo = a.Ecodigo
		AND b.CCTcodigo = a.CCTcodigo
		AND b.Ddocumento = a.Ddocumento
		WHERE a.idDetalle = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDetalle#">
		  AND a.idDocCompensacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDocCompensacion#">
		  AND a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>
</cfif>

<cfset LB_Socio = t.Translate('LB_Socio','Socio')>
<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacci&oacute;n','/sif/generales.xml')>
<cfset LB_GrpDeb = t.Translate('LB_GrpDeb','Documentos a cobrar en CxC (Débitos)')>
<cfset LB_GrpCre = t.Translate('LB_GrpCre','Documentos a Favor del Cliente (Créditos)')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_Reten = t.Translate('LB_Reten','Retención')>
<cfset LB_Saldo = t.Translate('LB_Saldo','Saldo')>
<cfset LB_MontoDoc = t.Translate('LB_MontoDoc','Monto Doc')>
<cfset LB_Monto = t.Translate('LB_Monto','Monto','/sif/generales.xml')>

<cfoutput>
	<form action="DocCC-sql.cfm" name="formcxc" method="post" onSubmit="">
		<cfoutput>
			<cfif isdefined("form.Fecha_F")  and LEN(TRIM(form.Fecha_F))>
				<input name="Fecha_F" type="hidden" value="#form.Fecha_F#" tabindex="-1">
			</cfif>
			<cfif isdefined("form.DocCompensacion_F") and LEN(TRIM(form.DocCompensacion_F))>
				<input name="DocCompensacion_F" type="hidden" value="#form.DocCompensacion_F#" tabindex="-1">
			</cfif>
			<cfif isdefined("form.SNcodigo_F") and len(trim(form.SNcodigo_F))>
				<input name="SNcodigo_F" type="hidden" value="#form.SNcodigo_F#" tabindex="-1">
			</cfif>
			<cfif isdefined("form.CCTcodigo") and len(trim(form.CCTcodigo))>
				<input name="CCTcodigo" type="hidden" value="#form.CCTcodigo#" tabindex="-1">
			</cfif>
		</cfoutput>
		<table width="1%" align="center"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td valign="top" nowrap align="right"><strong>#LB_Socio# :&nbsp;</strong></td>
				<td>
					<cfif (modocxc neq "ALTA")>
						<cf_sifsociosnegocios2 form="formcxc" size="45" frame="frSNcodigocxc" SNcodigo="SNcodigocxc" tabindex="1"
							idquery="#rsDocCompensacionDCxC.SNcodigo#"
							modificable="false"
						>
					<cfelse>
						<cf_sifsociosnegocios2 form="formcxc" size="45" frame="frSNcodigocxc" SNcodigo="SNcodigocxc" tabindex="1"
							idquery="#rsDocCompensacion.SNcodigo#"
							relacionadoId="#rsDocCompensacion.SNid#"
						>
					</cfif>
					<script language="javascript" type="text/javascript">
						function funcSNnumero(){
							limpiarDocumentoCxC();
						}
					</script>
				</td>
			</tr>
			<tr>
				<td valign="top" nowrap align="right"><p><strong>#LB_Transaccion# :&nbsp;</strong></p>    </td>
				<td>
					<select name="CCTcodigo" id="CCTcodigo"  tabindex="1" onChange="javascript: limpiarDocumentoCxC();" <cfif (modocxc neq "ALTA")>disabled</cfif>>
						<cfquery name="rsTransaccionesCxC" datasource="#session.dsn#">
							SELECT CCTtipo,
							       CCTcodigo,
							       CCTdescripcion
							FROM CCTransacciones
							WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
							AND CCTCompensacion = 1
							AND CCTcodigo <> 'CO'
							ORDER BY CCTtipo DESC,
							         CCTcodigo
						</cfquery>
						<cfset LvarCCTtipo="">
						<cfloop query="rsTransaccionesCxC">
							<cfif LvarCCTtipo NEQ rsTransaccionesCxC.CCTtipo>
								<cfset LvarCCTtipo = rsTransaccionesCxC.CCTtipo>
								<cfif LvarCCTtipo EQ "D">
									<optgroup label="#LB_GrpDeb#">
								<cfelse>
									<optgroup label="#LB_GrpCre#">
								</cfif>
							</cfif>
							<option value="#rsTransaccionesCxC.CCTcodigo#" <cfif (modocxc neq "ALTA" AND rsTransaccionesCxC.CCTcodigo EQ rsDocCompensacionDCxC.CCTcodigo)>selected</cfif>>#rsTransaccionesCxC.CCTdescripcion#</option>
						</cfloop>
					</select>
				</td>
			</tr>
			<tr>
				<td align="right"><strong>#LB_Documento#&nbsp;:&nbsp;</strong></td>
				<td rowspan="2">
					<table width="1%"  border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td>
								<input name="HDdocumento" type="hidden"  tabindex="-1"
									value="<cfif (modocxc neq "ALTA")>#rsDocCompensacionDCxC.Ddocumento#</cfif>">
								<input name="Ddocumento" id="Ddocumento" type="text" size="22" tabindex="1"
									maxlength="22" <cfif isdefined('rsDocCompensacionDCxC')>disabled</cfif>
									onBlur="javascript: getDdocumentocxc(this.value) ;"
									value="<cfif (modocxc neq "ALTA")>#rsDocCompensacionDCxC.Ddocumento#</cfif>">
							</td>
							<td>
								<a href="javascript: conlisDdocumentoscxc();"
									onMouseOver="javascript: window.status=''; return true;"
									onMouseOut="javascript: window.status=''; return true;"
									tabindex="-1">
								<img src="/cfmx/sif/imagenes/Description.gif"
									alt="Lista de Documentos de CXC"
									name="imagen" width="18" height="14" border="0"
									align="absmiddle">
								</a>
							</td>
							<td nowrap="nowrap">
								&nbsp;<strong>#LB_Reten#:</strong>
								<input name="RetencionCxC" value=""	size="10" style="border:none"/>
							</td>
						</tr>
						<tr>
							<td>
								<input name="Dsaldo" type="text" readonly="true" size="20" maxlength="18" style="text-align: right" class="cajasinborde"
									value="<cfif (modocxc neq "ALTA")>#LSCurrencyFormat(rsDocCompensacionDCxC.Dsaldo,'none')#<cfelse>0.00</cfif>">
								<iframe id="frDdocumentocxc" frameborder="0" width="0" height="0"></iframe>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr><td align="right"><strong>#LB_Saldo#&nbsp;:&nbsp;</strong></td></tr>
			<cfif LvarTipoCompDocs EQ 2 or LvarTipoCompDocs EQ 3>
				<cfset LvarMontoReadOnly = true>
			<tr>
				<td align="right"><strong>#LB_MontoDoc#&nbsp;:&nbsp;</strong></td>
				<td>
					<cfif (modocxc neq "ALTA")>
					<cf_monto form="formcxc" name="DmontoDocCxC" value="#rsDocCompensacionDCxC.DmontoDoc#" tabindex="1">
					<cfelse>
					<cf_monto form="formcxc" name="DmontoDocCxC" tabindex="1">
					</cfif>
					<strong id="lblRetencionCxC">- #LB_Reten#:</strong>
					<cfif (modocxc neq "ALTA")>
					<cf_monto form="formcxc" name="DmontoRetCxC" value="#rsDocCompensacionDCxC.DmontoRet#" tabindex="1">
					<cfelse>
					<cf_monto form="formcxc" name="DmontoRetCxC" tabindex="1">
					</cfif>
				</td>
			</tr>
			<cfelse>
				<cfset LvarMontoReadOnly = false>
			</cfif>
			<tr>
				<td align="right"><strong>#LB_Monto#&nbsp;:&nbsp;</strong></td>
				<td>
					<cfif (modocxc neq "ALTA")>
					<cf_monto form="formcxc" name="Dmonto" value="#rsDocCompensacionDCxC.Dmonto#" tabindex="1" readonly="#LvarMontoReadOnly#">
					<cfelse>
					<cf_monto form="formcxc" name="Dmonto" tabindex="1" readonly="#LvarMontoReadOnly#">
					</cfif>
				</td>
			</tr>
		</table>
		<cfif (TipoCompensacion EQ 2 and Session.Menues.SMcodigo EQ 'CC')>
			<cf_botones formname="formcxc" sufijo="cxc" modo="#modocxc#" include="Masivo" includevalues="Agregar Masivo" tabindex="1">
		<cfelse>
			<cfif isDefined("rslistacxc") and rslistacxc.RecordCount GT 0>
				<cf_botones formname="formcxc" sufijo="cxc" modo="#modocxc#" Exclude="Alta" tabindex="1">
			<cfelse>
				<cf_botones formname="formcxc" sufijo="cxc" modo="#modocxc#" tabindex="1">
			</cfif>
		</cfif>
		<cfif isdefined("rsDocCompensacionDCxC.idDetalle")>
			<input type="hidden" name="idDetalle" value="#rsDocCompensacionDCxC.idDetalle#" tabindex="-1">
			<cfinvoke component="sif.Componentes.DButils"
			method="toTimeStamp"
			returnvariable="ts"
			arTimeStamp="#rsDocCompensacionDCxC.ts_rversion#"/>
			<input type="hidden" name="timestampcxc" value="#ts#" tabindex="-1">
		</cfif>
		<input type="hidden" name="idDocCompensacion" value="#rsDocCompensacion.idDocCompensacion#" tabindex="-1">
		<input type="hidden" name="TipoCompensacion" value="#TipoCompensacion#" tabindex="-1">
	</form>
	<!---cf_qforms form="formcxc" objForm="objFormCxC"--->
	<cfif LvarTipoCompDocs EQ 2 or LvarTipoCompDocs EQ 3>
		<cfset DmontoVer = "DmontoDocCxC">
	<cfelse>
		<cfset DmontoVer = "Dmonto">
	</cfif>
<cfset MSG_ElCmp 	= t.Translate('MSG_ElCmp','El campo')>
<cfset MSG_DebeCont = t.Translate('MSG_DebeCont','debe contener un valor menor o igual que')>
<cfset MSG_ValCorr = t.Translate('MSG_ValCorr','Valor correspondiente al saldo del documento.')>
<cfset MSG_MontoCero = t.Translate('MSG_MontoCero','El campo Monto no puede ser menor o igual que cero.')>
<cfset MSG_DebeSel = t.Translate('MSG_DebeSel','Debe seleccionar el Socio de Negocios')>
<cfset MSG_DebeSelTT = t.Translate('MSG_DebeSelTT','Debe seleccionar el Tipo de Transacción')>

<!---script language="javascript" type="text/javascript">
			function __isLessThanSaldo(){
				if (objFormCxC._allowSubmitOnError){
					objFormCxC._allowSubmitOnError = false;
					return;
				}
				if (parseFloat(qf(this))>parseFloat(qf(objFormCxC.Dsaldo.obj))){
					this.error="#MSG_ElCmp# " + this.description + " " + "#MSG_DebeCont#";
					this.error+=fm(objFormCxC.Dsaldo.obj.value) + ". " + "#MSG_ValCorr#";
				}
				if (parseFloat(qf(objFormCxC.Dmonto.obj.value))<=0){
					this.error="#MSG_MontoCero#";
				}
			}
			//objFormCxC.addValidator('isLessThanSaldo',__isLessThanSaldo());
			objFormCxC.CCTcodigo.description = "#JSStringFormat('Transaccin')#";
			objFormCxC.Ddocumento.description = "#JSStringFormat('Documento')#";
			objFormCxC.#DmontoVer#.description = "#JSStringFormat('Monto')#";
			objFormCxC.#DmontoVer#.validateLessThanSaldo();
			objFormCxC.required("CCTcodigo,Ddocumento,#DmontoVer#");
			function funcNuevocxc(){
				objFormCxC.required("CCTcodigo,Ddocumento,#DmontoVer#",false);
				objFormCxC._allowSubmitOnError = true;
			}
			function funcBajacxc(){
				objFormCxC.required("CCTcodigo,Ddocumento,#DmontoVer#",false);
				objFormCxC._allowSubmitOnError = true;
			}
			function fnfinalcxc(){
				objFormCxC.CCTcodigo.obj.disabled=false;
				objFormCxC.Ddocumento.obj.disabled=false;
				objFormCxC.Dmonto.obj.value=qf(objFormCxC.Dmonto.obj);
			}
			<cfif isdefined("rsDocCompensacionDCxC")>
				objFormCxC.#DmontoVer#.obj.focus();
			<cfelse>
				objFormCxC.SNnumero.obj.focus();
			</cfif>
	</script--->
	<!--- JavaScript para Documentos --->
	<script type="text/javascript">
			function funcAltacxc(){
				var lvarCCTcodigo = document.getElementById('CCTcodigo');
				var lvarDdocumento = document.getElementById('Ddocumento');
				if (document.formcxc.SNcodigocxc.value==''){
					alert("#JSStringFormat('#MSG_DebeSel#')#");
					limpiarDocumentoCxC();
					return false;
				}
				if (lvarCCTcodigo.value === ''){
					alert("#JSStringFormat('#MSG_DebeSelTT#')#");
					limpiarDocumentoCxC();
					return false;
				}
				if (lvarDdocumento.value === ''){
					alert("Debe seleccionar un documento CxC.");
					limpiarDocumentoCxC();
					return false;
				}
				return true;
			}

			function limpiarDocumentoCxC(){
				document.formcxc.HDdocumento.value = "";
				document.formcxc.Ddocumento.value = "";
				document.formcxc.Dsaldo.value = "0.00";
				document.formcxc.Dmonto.value = "0.00";
			}
			function listoParaObtenerDocCxC(){
				var lvarCCTcodigo = document.getElementById('CCTcodigo');
				if (document.formcxc.SNcodigocxc.value==''){
					alert("#JSStringFormat('#MSG_DebeSel#')#");
					limpiarDocumentoCxC();
					return false;
				}
				if (lvarCCTcodigo.value === ''){
					alert("#JSStringFormat('#MSG_DebeSelTT#')#");
					limpiarDocumentoCxC();
					return false;
				}
				return true;
			}
			function getDdocumentocxc(Ddocumento){
				<cfif not isdefined("rsDocCompensacionDCxC")>
					if (document.formcxc.HDdocumento.value!=Ddocumento&&listoParaObtenerDocCxC()){
						var lvarCCTcodigo = document.getElementById('CCTcodigo');
						window.HDdocumento = document.formcxc.HDdocumento;
						window.Ddocumento = document.formcxc.Ddocumento;
						window.Dsaldo = document.formcxc.Dsaldo;
						window.Dmonto = document.formcxc.Dmonto;
						document.getElementById("frDdocumentocxc").src = "Neteo-Ddocumentocxcquery.cfm?Ddocumento="+Ddocumento+"&Mcodigo=#rsDocCompensacion.Mcodigo#&CCTcodigo="+lvarCCTcodigo.value+"&SNcodigo="+document.formcxc.SNcodigocxc.value+"&TipoCompensacionDocs=";
					}
				</cfif>
			}
			function conlisDdocumentoscxc(){
				<cfif not isdefined("rsDocCompensacionDCxC")>
					if (listoParaObtenerDocCxC()){
						
						var lvarCCTcodigo = document.getElementById('CCTcodigo');
						var width = 600;
						var height = 500;
						var top = (screen.height - height) / 2;
						var left = (screen.width - width) / 2;
						var nuevo = window.open("Neteo-Ddocumentocxcconlis.cfm?Typ=C&Mcodigo=#rsDocCompensacion.Mcodigo#&CCTcodigo="+lvarCCTcodigo.value+"&SNcodigo="+document.formcxc.SNcodigocxc.value,'ListaDocumentosCxC','menu=no, scrollbars=yes, top='+top+', left='+left+', width='+width+', height='+height);
						nuevo.focus();
					}
				</cfif>
			}
			function funcMasivocxc(){
				var width = 750;
				var height = 650;
				var top = (screen.height - height) / 2;
				var left = (screen.width - width) / 2;
				var nuevo = window.open("Neteo-Ddocumentocxcmasivo.cfm?Mcodigo=#rsDocCompensacion.Mcodigo#&idDocCompensacion=#rsDocCompensacion.idDocCompensacion#",'ListaDocumentosCxC','menu=no, scrollbars=yes, top='+top+', left='+left+', width='+width+', height='+height);
				nuevo.focus();
				return false;
			}

			<cfif LvarTipoCompDocs EQ 2 or LvarTipoCompDocs EQ 3>
				function fnDmontoCxC ()
				{
					if (document.formcxc.RetencionCxC.value == "N/A")
						document.formcxc.DmontoRetCxC.value	= "0.00";

					var LvarMontoDoc = parseFloat(qf(document.formcxc.DmontoDocCxC.value));
					var LvarMontoRet = parseFloat(qf(document.formcxc.DmontoRetCxC.value));
					document.formcxc.Dmonto.value = fm(LvarMontoDoc-LvarMontoRet,2);
				}

				function funcDmontoDocCxC ()
				{
					fnDmontoCxC ()
				}

				function funcDmontoRetCxC ()
				{
					fnDmontoCxC ()
				}

				function sbRetencionCxC (r, p, m, mm)
				{
					var LvarPrc = 0;
					var LvarMnt = 0;
					if (p != "") LvarPrc = parseFloat(p);
					if (m != "") LvarMnt = parseFloat(m);

					if (r == "")
					{
						document.formcxc.RetencionCxC.value	= "N/A";
						document.formcxc.DmontoRetCxC.value	= "0.00";
						document.formcxc.DmontoRetCxC.style.display = "none";
						document.getElementById("lblRetencionCxC").style.display = "none";
						return;
					}

					if (LvarPrc == 0)
					{
						document.formcxc.DmontoRetCxC.value	= "0.00";
						document.formcxc.DmontoDocCxC.value	= fm(m,2);
						document.formcxc.Dmonto.value		= fm(m,2);
					}
					else if (LvarMnt == 0)
					{
						document.formcxc.DmontoRetCxC.value	= "0.00";
						document.formcxc.DmontoDocCxC.value	= "0.00";
						document.formcxc.Dmonto.value		= "0.00";
					}
				<cfif isdefined("form.RcodigoCxC")>
					else if (mm)
					{
						document.formcxc.DmontoRetCxC.value	= fm("#rsDocCompensacionDCxC.DmontoRet#",2);
						document.formcxc.DmontoDocCxC.value	= fm("#rsDocCompensacionDCxC.Dmonto + rsDocCompensacionDCxC.DmontoRet#",2);
						document.formcxc.Dmonto.value		= fm("#rsDocCompensacionDCxC.Dmonto#",2);
					}
				</cfif>
					else
					{
						var LvarRet = LvarMnt * LvarPrc/100;
						document.formcxc.DmontoRetCxC.value	= fm(LvarRet,2);
						document.formcxc.DmontoDocCxC.value	= fm(m,2);
						document.formcxc.Dmonto.value		= fm(m - LvarRet,2);
					}

					document.formcxc.RetencionCxC.value	= r + "=" + fm(LvarPrc,2) + "%";
				}
				<cfif isdefined("form.RcodigoCxC")>
					<cfoutput>
					sbRetencionCxC ("#form.RcodigoCxC#", "#form.Rporcentaje#", "#rsDocCompensacionDCxC.Dmonto#", true);
					</cfoutput>
				</cfif>
			</cfif>
	</script>
</cfoutput>