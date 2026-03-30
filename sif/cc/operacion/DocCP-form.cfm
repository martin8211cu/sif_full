
<!--- Pasa llave de Url al Form --->
<cfif isdefined("url.idDetalle") and len(trim(url.idDetalle))>
	<cfset form.idDetalle = url.idDetalle>
</cfif>
<cfif isdefined("url.CPTcodigo") and len(trim(url.CPTcodigo))>
	<cfset form.CPTcodigo = url.CPTcodigo>
</cfif>
<cfif isdefined("url.idDocumento") and len(trim(url.idDocumento))>
	<cfset form.idDocumento = url.idDocumento>
</cfif>
<!--- Establezco el modo --->
<cfset modocxp = "ALTA">
<cfif isdefined("form.idDetalle") and len(trim(form.idDetalle)) GT 0 and isdefined("form.CPTcodigo") and len(trim(form.CPTcodigo)) GT 0 and isdefined("form.idDocumento") and len(trim(form.idDocumento)) GT 0 >
	<cfset modocxp = "CAMBIO">
</cfif>
<!--- Consultas del form de documentos de CXP --->
<!--- 1. Obtiene los datos del Documento de CXP cuando el modo es CAMBIO --->
<cfif (modocxp NEQ "ALTA")>
	<cfquery name="rsDocCompensacionDCxP" datasource="#session.dsn#">
		select 	a.idDetalle, a.idDocCompensacion, a.idDocumento, a.CPTcodigo, a.Ddocumento, a.BMUsucodigo, a.Referencia,
				a.Dmonto, a.DmontoRet, a.Dmonto + coalesce(DmontoRet,0) as DmontoDoc,
				a.ts_rversion, b.EDsaldo, b.SNcodigo, b.CPTcodigo
		from DocCompensacionDCxP a
			left outer join EDocumentosCP b
				on b.CPTcodigo = a.CPTcodigo
				and b.Ddocumento = a.Ddocumento
				and b.IDdocumento = a.idDocumento
		where a.idDetalle = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDetalle#">
			and a.idDocCompensacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDocCompensacion#">
	</cfquery>
</cfif>

<cfset LB_Socio = t.Translate('LB_Socio','Socio','Neteo1.xml')>
<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacci&oacute;n','/sif/generales.xml')>
<cfset LB_GrpDeb = t.Translate('LB_GrpDeb','Documentos a Favor de la Empresa (Débitos)','Neteo1.xml')>
<cfset LB_GrpCre = t.Translate('LB_GrpCre','Documentos a pagar en CxP (Créditos)','Neteo1.xml')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento','Neteo1.xml')>
<cfset LB_Reten = t.Translate('LB_Reten','Retención','Neteo1.xml')>
<cfset LB_Saldo = t.Translate('LB_Saldo','Saldo','Neteo1.xml')>
<cfset LB_MontoDoc = t.Translate('LB_MontoDoc','Monto Doc','Neteo1.xml')>
<cfset LB_Monto = t.Translate('LB_Monto','Monto','/sif/generales.xml')>
<cfset LB_MontoNet = t.Translate('LB_MontoNet','Monto Neteo','Neteo1.xml')>

<cfoutput>
	<form action="DocCP-sql.cfm" name="formcxp" method="post" onSubmit="javascript: return fnfinalcxp();">
		<table width="100%" align="center"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td valign="top" nowrap><strong>#LB_Socio# : </strong></td>
				<td>
					<cfif (modocxp NEQ "ALTA")>
						<cf_sifsociosnegocios2 form="formcxp" size="45" frame="frSNcodigocxp" SNcodigo="SNcodigocxp" SNnumero="SNnumerocxp"
							idquery="#rsDocCompensacionDCxP.SNcodigo#"
							modificable="false"
						>
					<cfelse>
						<cf_sifsociosnegocios2 form="formcxp" size="45" frame="frSNcodigocxp" SNcodigo="SNcodigocxp" SNnumero="SNnumerocxp"
							idquery="#rsDocCompensacion.SNcodigo#"
							relacionadoId="#rsDocCompensacion.SNid#"
						>
					</cfif>
					<script language="javascript" type="text/javascript">
						function funcSNnumerocxp(){
							limpiarDocumentoCxP();
						}
					</script>
				</td>
			</tr>
			<tr>
				<td valign="top" nowrap><strong>#LB_Transaccion# :&nbsp;</strong></td>
				<td>
					<select name="CPTcodigo" onChange="javascript: limpiarDocumentoCxP();" <cfif (modocxp NEQ "ALTA")>disabled</cfif>>
						<cfquery name="rsTransaccionesCxP" datasource="#session.dsn#">
							select CPTtipo, CPTcodigo, CPTdescripcion
							from CPTransacciones
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
							AND CPTCompensacion = 1
							order by CPTtipo, CPTcodigo
						</cfquery>
						<cfset LvarCPTtipo="">
						<cfloop query="rsTransaccionesCxP">
							<cfif LvarCPTtipo NEQ rsTransaccionesCxP.CPTtipo>
								<cfset LvarCPTtipo = rsTransaccionesCxP.CPTtipo>
								<cfif LvarCPTtipo EQ "C">
									<optgroup label="#LB_GrpCre#">
								<cfelse>
									<optgroup label="#LB_GrpDeb#">
								</cfif>
							</cfif>
							<option value="#rsTransaccionesCxP.CPTcodigo#" <cfif (modocxp NEQ "ALTA" AND rsTransaccionesCxP.CPTcodigo EQ rsDocCompensacionDCxP.CPTcodigo)>selected</cfif>>#rsTransaccionesCxP.CPTdescripcion#</option>
						</cfloop>
					</select>
				</td>
			</tr>
			<tr>
				<td><strong>#LB_Documento#&nbsp;:&nbsp;</strong></td>
				<td rowspan="2">
					<table width="1%"  border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td>
								<input name="HDdocumento" type="hidden"
									value="<cfif (modocxp NEQ "ALTA")>#rsDocCompensacionDCxP.Ddocumento#</cfif>">
								<input name="Ddocumento" type="text" size="22" maxlength="22" <cfif (modocxp NEQ "ALTA")>disabled</cfif>
									onBlur="javascript: getDdocumentocxp(this.value) ;"
									value="<cfif (modocxp NEQ "ALTA")>#rsDocCompensacionDCxP.Ddocumento#</cfif>">
							</td>
							<td>
								<a href="javascript: conlisDdocumentoscxp();"
									onMouseOver="javascript: window.status=''; return true;"
									onMouseOut="javascript: window.status=''; return true;"
									tabindex="-1">
									<img src="/cfmx/sif/imagenes/Description.gif"
										alt="Lista de Documentos de CXP"
										name="imagen" width="18" height="14" border="0"
										align="absmiddle">
								</a>
							</td>
							<td nowrap="nowrap">
								&nbsp;<strong>#LB_Reten#:</strong>
								<input name="RetencionCxP" value=""	size="10" style="border:none"/>
							</td>
						</tr>
						<tr>
							<td>
								<input name="idDocumento" type="hidden"
									value="<cfif (modocxp NEQ "ALTA")>#rsDocCompensacionDCxP.idDocumento#</cfif>">
								<input name="EDsaldo" type="text" readonly="true" size="20" maxlength="18" style="text-align: right" class="cajasinborde"
									value="<cfif (modocxp NEQ "ALTA")>#LSCurrencyFormat(rsDocCompensacionDCxP.EDsaldo,'none')#<cfelse>0.00</cfif>">
								<iframe id="frDdocumentocxp" frameborder="0" width="0" height="0"></iframe>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td><strong>#LB_Saldo#&nbsp;:&nbsp;</strong></td>
			</tr>
			<cfif LvarTipoCompDocs EQ 2 or LvarTipoCompDocs EQ 3>
				<cfset LvarMontoReadOnly = true>
			<tr>
				<td><strong>#LB_MontoDoc#&nbsp;:&nbsp;</strong></td>
				<td>
					<cfif (modocxp neq "ALTA")>
					<cf_monto form="formcxp" name="DmontoDocCxP" value="#rsDocCompensacionDCxP.DmontoDoc#" tabindex="1">
					<cfelse>
					<cf_monto form="formcxp" name="DmontoDocCxP" tabindex="1">
					</cfif>
					<strong id="lblRetencionCxP">- #LB_Reten#:</strong>
					<cfif (modocxp neq "ALTA")>
					<cf_monto form="formcxp" name="DmontoRetCxP" value="#rsDocCompensacionDCxP.DmontoRet#" tabindex="1">
					<cfelse>
					<cf_monto form="formcxp" name="DmontoRetCxP" tabindex="1">
					</cfif>
				</td>
			</tr>
			<cfelse>
				<cfset LvarMontoReadOnly = false>
			</cfif>
			<tr>
				<td><strong>#LB_MontoNet#&nbsp;:&nbsp;</strong></td>
				<td>
					<cfif (modocxp neq "ALTA")>
					<cf_monto form="formcxp" name="Dmonto" value="#rsDocCompensacionDCxP.Dmonto#" tabindex="1" readonly="#LvarMontoReadOnly#">
					<cfelse>
					<cf_monto form="formcxp" name="Dmonto" tabindex="1" readonly="#LvarMontoReadOnly#">
					</cfif>
				</td>
		  </tr>
		</table>
		<cf_botones formname="formcxp" sufijo="cxp" modo="#modocxp#">
		<cfif isdefined("rsDocCompensacionDCxP.idDetalle")>
			<input type="hidden" name="idDetalle" value="#rsDocCompensacionDCxP.idDetalle#">
			<cfinvoke component="sif.Componentes.DButils"
			method="toTimeStamp"
			returnvariable="ts"
			arTimeStamp="#rsDocCompensacionDCxP.ts_rversion#"/>
			<input type="hidden" name="timestampcxp" value="#ts#">
		</cfif>
		<input type="hidden" name="idDocCompensacion" value="#rsDocCompensacion.idDocCompensacion#">
		<input type="hidden" name="TipoCompensacion" value="#TipoCompensacion#">
		<cfif isdefined("form.CPTcodigo") and len(trim(form.CPTcodigo))>
			<input name="CPTcodigo" type="hidden" value="#form.CPTcodigo#" tabindex="-1">
		</cfif>
	</form>
	<cf_qforms form="formcxp" objForm="objFormCxP" modo="#modocxp#">

	<cfif LvarTipoCompDocs EQ 2 or LvarTipoCompDocs EQ 3>
		<cfset DmontoVer = "DmontoDocCxP">
	<cfelse>
		<cfset DmontoVer = "Dmonto">
	</cfif>

<cfset MSG_ElCmp 	= t.Translate('MSG_ElCmp','El campo','Neteo-Common-formcxc.cfm')>
<cfset MSG_DebeCont = t.Translate('MSG_DebeCont','debe contener un valor menor o igual que','Neteo-Common-formcxc.cfm')>
<cfset MSG_ValCorr = t.Translate('MSG_ValCorr','Valor correspondiente al saldo del documento.','Neteo-Common-formcxc.cfm')>
<cfset MSG_MontoCero = t.Translate('MSG_MontoCero','El campo Monto no puede ser menor o igual que cero.','Neteo-Common-formcxc.cfm')>
<cfset MSG_DebeSel = t.Translate('MSG_DebeSel','Debe seleccionar el Socio de Negocios','Neteo-Common-formcxc.cfm')>
<cfset MSG_DebeSelTT = t.Translate('MSG_DebeSelTT','Debe seleccionar el Tipo de Transacción','Neteo-Common-formcxc.cfm')>

	<script language="javascript" type="text/javascript">
		<!--//
			function __isLessThanSaldoCP(){
				if (objFormCxP._allowSubmitOnError){
					objFormCxP._allowSubmitOnError = false;
					return;
				}
				if (parseFloat(qf(this))>parseFloat(qf(objFormCxP.EDsaldo.obj))){
					this.error= #MSG_ElCmp# + " " + this.description + " "+ #MSG_DebeCont#;
					this.error+=fm(objFormCxP.EDsaldo.obj.value) + ". " + #MSG_ValCorr#;
				}
				if (parseFloat(qf(objFormCxP.Dmonto.obj.value))<=0){
					this.error="#MSG_MontoCero#";
				}
			}
			objFormCxP.addValidator('isLessThanSaldoCP',__isLessThanSaldoCP);
			objFormCxP.CPTcodigo.description = "#JSStringFormat('Transacción')#";
			objFormCxP.Ddocumento.description = "#JSStringFormat('Documento')#";
			objFormCxP.#DmontoVer#.description = "#JSStringFormat('Monto')#";
			objFormCxP.#DmontoVer#.validateLessThanSaldoCP();
			objFormCxP.required("CPTcodigo,Ddocumento,#DmontoVer#");
			function funcNuevocxp(){
				objFormCxP.required("CPTcodigo,Ddocumento,#DmontoVer#",false);
				objFormCxP._allowSubmitOnError = true;
			}
			function funcBajacxp(){
				objFormCxP.required("CPTcodigo,Ddocumento,#DmontoVer#",false);
				objFormCxP._allowSubmitOnError = true;
			}
			function fnfinalcxp(){
				objFormCxP.CPTcodigo.obj.disabled=false;
				objFormCxP.Ddocumento.obj.disabled=false;
				objFormCxP.Dmonto.obj.value=qf(objFormCxP.Dmonto.obj);
			}
			<cfif not isdefined('rsDocCompensacionDCxP')>
				objFormCxP.SNnumerocxp.obj.focus();
			<cfelse>
				objFormCxP.#DmontoVer#.obj.focus();
			</cfif>
		//-->
	</script>
	<script language="javascript" type="text/javascript">
		<!--//
			function limpiarDocumentoCxP(){
				document.formcxp.HDdocumento.value="";
				document.formcxp.Ddocumento.value="";
				document.formcxp.idDocumento.value="";
				document.formcxp.EDsaldo.value="0.00";
				document.formcxp.Dmonto.value="0.00";
			}
			function listoParaObtenerDocCxP(){
				if (document.formcxp.SNcodigocxp.value==''){
					alert("#JSStringFormat('#MSG_DebeSel#')#");
					limpiarDocumentoCxP();
					return false;
				}
				if (document.formcxp.CPTcodigo.value==''){
					alert("#JSStringFormat('#MSG_DebeSelTT#')#");
					limpiarDocumentoCxP();
					return false;
				}
				return true;
			}

			function getDdocumentocxp(Ddocumento){
				<cfif not isdefined('rsDocCompensacionDCxP')>
					if (document.formcxp.HDdocumento.value!=Ddocumento&&listoParaObtenerDocCxP()){
						window.HDdocumento = document.formcxp.HDdocumento;
						window.Ddocumento = document.formcxp.Ddocumento;
						window.idDocumento = document.formcxp.idDocumento;
						window.EDsaldo = document.formcxp.EDsaldo;
						window.Dmonto = document.formcxp.Dmonto;
						document.getElementById("frDdocumentocxp").src = "Neteo-Ddocumentocxpquery.cfm?Ddocumento="+Ddocumento+"&Mcodigo=#rsDocCompensacion.Mcodigo#&CPTcodigo="+document.formcxp.CPTcodigo.value+"&SNcodigo="+document.formcxp.SNcodigocxp.value;
					}
				</cfif>
			}
			function conlisDdocumentoscxp(){
				<cfif not isdefined('rsDocCompensacionDCxP')>
					if (listoParaObtenerDocCxP()){
						var width = 600;
						var height = 500;
						var top = (screen.height - height) / 2;
						var left = (screen.width - width) / 2;
						var nuevo = window.open("Neteo-Ddocumentocxpconlis.cfm?Typ=C&Mcodigo=#rsDocCompensacion.Mcodigo#&CPTcodigo="+document.formcxp.CPTcodigo.value+"&SNcodigo="+document.formcxp.SNcodigocxp.value,'ListaDocumentosCxP','menu=no, scrollbars=yes, top='+top+', left='+left+', width='+width+', height='+height);
						nuevo.focus();
					}
				</cfif>
			}

			<cfif LvarTipoCompDocs EQ 2 or LvarTipoCompDocs EQ 3>
				function fnDmonto ()
				{
					if (document.formcxp.RetencionCxP.value == "N/A")
						document.formcxp.DmontoRetCxP.value	= "0.00";

					var LvarMontoDoc = parseFloat(qf(document.formcxp.DmontoDocCxP.value));
					var LvarMontoRet = parseFloat(qf(document.formcxp.DmontoRetCxP.value));
					document.formcxp.Dmonto.value = fm(LvarMontoDoc-LvarMontoRet,2);
				}

				function funcDmontoDocCxP ()
				{
					fnDmonto ()
				}

				function funcDmontoRetCxP ()
				{
					fnDmonto ()
				}

				function sbRetencionCxP (r, p, m, mm)
				{
					var LvarPrc = 0;
					var LvarMnt = 0;
					if (p != "") LvarPrc = parseFloat(p);
					if (m != "") LvarMnt = parseFloat(m);

					if (r == "")
					{
						document.formcxp.RetencionCxP.value	= "N/A";
						document.formcxp.DmontoRetCxP.value	= "0.00";
						document.formcxp.DmontoRetCxP.style.display = "none";
						document.getElementById("lblRetencionCxP").style.display = "none";
						return;
					}

					if (LvarPrc == 0)
					{
						document.formcxp.DmontoRetCxP.value	= "0.00";
						document.formcxp.DmontoDocCxP.value	= fm(m,2);
						document.formcxp.Dmonto.value		= fm(m,2);
					}
					else if (LvarMnt == 0)
					{
						document.formcxp.DmontoRetCxP.value	= "0.00";
						document.formcxp.DmontoDocCxP.value	= "0.00";
						document.formcxp.Dmonto.value		= "0.00";
					}

				<cfif isdefined("form.RcodigoCxP")>
					else if (mm)
					{
						document.formcxp.DmontoRetCxP.value	= fm("#rsDocCompensacionDCxP.DmontoRet#",2);
						document.formcxp.DmontoDocCxP.value	= fm("#rsDocCompensacionDCxP.Dmonto + rsDocCompensacionDCxP.DmontoRet#",2);
						document.formcxp.Dmonto.value		= fm("#rsDocCompensacionDCxP.Dmonto#",2);
					}
				</cfif>
					else
					{
						var LvarRet = LvarMnt * LvarPrc/100;
						document.formcxp.DmontoRetCxP.value	= fm(LvarRet,2);
						document.formcxp.DmontoDocCxP.value	= fm(m,2);
						document.formcxp.Dmonto.value		= fm(m - LvarRet,2);
					}

					document.formcxp.RetencionCxP.value	= r + "=" + fm(LvarPrc,2) + "%";
				}
				<cfif isdefined("form.RcodigoCxP")>
					<cfoutput>
					sbRetencionCxP ("#form.RcodigoCxP#", "#form.Rporcentaje#", "#rsDocCompensacionDCxP.Dmonto#", true);
					</cfoutput>
				</cfif>
			</cfif>
		//-->
	</script>
</cfoutput>