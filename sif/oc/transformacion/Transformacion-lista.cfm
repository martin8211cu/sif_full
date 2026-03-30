<cf_templateheader title="Transformaci&oacute;n de Productos en Transito">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Transformaci&oacute;n de Productos en Transito'>
			<cfinclude template="../../portlets/pNavegacion.cfm">
			<br><table width="99%" align="center" border="0" cellpadding="0" cellspacing="0"><tr><td>
			<cfset filtro = "">
			<cfinclude template="TransfProdTransito-filtro.cfm">
			<cfquery name="rsQuery" datasource="#session.dsn#">
				Select 
						{fn concat({fn concat(OCTtipo, '-')},OCTtransporte)} as Transporte, 
						tt.OCTid, tt.OCTTid,tt.OCTTdocumento,tt.OCTTobservaciones,tt.OCTTfecha
				from  OCtransporteTransformacion tt
					inner join OCtransporte t
						on t.OCTid = tt.OCTid
				where OCTTestado =0
				and tt.Ecodigo  =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				<cfif form.OCTtipoF NEQ "">
					and t.OCTtipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OCTtipoF#">
				</cfif>
				<cfif form.OCTtransporteF NEQ "">
					and t.OCTtransporte = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OCTtransporteF#">
				</cfif>
				<cfif form.OCTTdocumentoF NEQ "">
					and upper(tt.OCTTdocumento) like '%#ucase(form.OCTTdocumentoF)#%'
				</cfif>
				<cfif form.OCTTobservacionesF NEQ "">
					and upper(tt.OCTTobservaciones) like '%#ucase(form.OCTTobservacionesF)#%'
				</cfif>
				<cfif form.OCTTfechaF NEQ "">
					and tt.OCTTfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#form.OCTTfechaF#">
				</cfif>
				order by tt.OCTTfecha desc, tt.OCTTdocumento
			</cfquery>
			<form action="TransfProdTransito.cfm" method="post" name="lista" style="margin:0">
				<table width="1%" border="0">
					<tr>
						<td nowrap><input type="checkbox" name="chkall" value="T" onClick="javascript:check_all( this );"></td>
						<td nowrap><strong>Marcar Todos.</strong></td>
					</tr>
				</table>
				<cfinvoke 
						component="sif.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsquery#"/>
					<cfinvokeargument name="desplegar" value="Transporte, OCTTdocumento,OCTTobservaciones,OCTTfecha"/>
					<cfinvokeargument name="etiquetas" value="Transporte, Documento, Descripci&oacute;n,Fecha"/>
					<cfinvokeargument name="formatos" value="S, V, V, D"/>
					<cfinvokeargument name="align" value="left, left, left, left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="checkboxes" value="S"/>
					<cfinvokeargument name="irA" value="TransfProdTransito.cfm"/>
					<cfinvokeargument name="keys" value="OCTTid"/>
					<cfinvokeargument name="botones" value="Aplicar,Nuevo"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="checkbox_function" value="unMarkOne()"/>
					<cfinvokeargument name="formname" value="lista"/>
					<cfinvokeargument name="incluyeform" value="false"/>
				</cfinvoke>
			</form>
			<script language="JavaScript1.2" type="text/javascript">
				<!--//
				function existe(form, name){
					if (form[name] != undefined) {
						return true
					}
					else{
						return false
					}
				}
				function check_all(obj){
					var form = eval('lista');
					
					if (existe(form, "chk")){
						if (obj.checked){
							if (form.chk.length){
								for (var i=0; i<form.chk.length; i++){
									form.chk[i].checked = "checked";
								}
							}
							else{
								form.chk.checked = "checked";
							}
						}
					}
				}
				function algunoMarcado(){
					var aplica = false;
					if (document.lista.chk) {
						if (document.lista.chk.value) {
							aplica = document.lista.chk.checked;
						} else {
							for (var i=0; i<document.lista.chk.length; i++) {
								if (document.lista.chk[i].checked) { 
									aplica = true;
									break;
								}
							}
						}
					}
					if (aplica) {
						return (confirm("¿Está seguro de que desea aplicar los documentos seleccionadas?"));
					} else {
						alert('Debe seleccionar al menos un documento antes de Aplicar');
						return false;
					}
				}
				function funcAplicar() {
					if (algunoMarcado())
						document.lista.action = "TransfProdTransito-sql.cfm";
					else
						return false;
				}
				function unMarkOne(){
					document.lista.chkall.checked = false;
				}
				//-->
			</script>
			<br></td></tr></table>
		<cf_web_portlet_end>
	<cf_templatefooter>