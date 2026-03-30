<cf_templateheader title="Reversión de Estimación">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reversión de Estimación'>
			<cfinclude template="../../../portlets/pNavegacion.cfm">
			<br><table width="99%" align="center" border="0" cellpadding="0" cellspacing="0"><tr><td>
			<cfset filtro = "">
			<cfinclude template="NoFac-filtro.cfm"> 
			<cfquery name="rsQuery" datasource="#session.dsn#">
				select a.CCTcodigo,a.Ddocumento,b.CCTCodigoRef,a.Dtotal,a.Dsaldo,a.Dfecha 
				from Documentos a
				inner join CCTransacciones b
				ON b.Ecodigo   = a.Ecodigo
				AND b.CCTcodigo = a.CCTcodigo
				AND b.CCTestimacion = 1
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and a.Dsaldo <> 0.00	
				and a.Dsaldo = a.Dtotal
				<cfif isdefined("form.FCCTcodigo") and len(trim(form.FCCTcodigo))>
					and a.CCTcodigo =  <cfqueryparam cfsqltype="cf_sql_char" value="#form.FCCTcodigo#">
				</cfif>	
				<cfif isdefined("form.FDdocumento") and len(form.FDdocumento)>
					and a.Ddocumento =  <cfqueryparam cfsqltype="cf_sql_char" value="#form.FDdocumento#">
				</cfif>	
				<cfif isdefined("form.FDfecha") and len(form.FDfecha)>
					and a.Dfecha >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#lsparsedatetime(Form.FDfecha)#">
				</cfif>			
			</cfquery>
			<form action="NoFac-sql.cfm" method="post" name="lista" style="margin:0">
				<table width="1%" border="0">
					<tr>
						<td nowrap><input type="checkbox" name="chkall" value="T" onClick="javascript:check_all( this );"></td>
						<td nowrap><strong>Marcar Todos.</strong></td>
						<td nowrap>&nbsp;&nbsp;&nbsp;<strong>Tipo de reversi&oacute;n</strong> :</td>
						<td nowrap>
						<select name="TIPO">
							<option value="">(Escoja un Tipo de Reversión...)</option>
							<option value="false">Por cuenta contable de balance</option>
							<option value="true">Por cuenta contable de origen</option>
						</select>
						</td>
					</tr>
				</table>
				<cfinvoke 
						component="sif.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsquery#"/>
					<cfinvokeargument name="desplegar" value="CCTcodigo,Ddocumento,Dtotal,Dsaldo,Dfecha"/>
					<cfinvokeargument name="etiquetas" value="Origen,Documento,Total,Saldo,Fecha"/>
					<cfinvokeargument name="formatos" value="V,V,M,M,D"/>
					<cfinvokeargument name="align" value="left,left, right, right, center"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="checkboxes" value="S"/>
					<cfinvokeargument name="irA" value="NoFac-sql.cfm"/>
					<cfinvokeargument name="keys" value="CCTcodigo,Ddocumento,CCTCodigoRef"/>
					<cfinvokeargument name="botones" value="Aplicar"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="checkbox_function" value="unMarkOne()"/>
					<cfinvokeargument name="formname" value="lista"/>
					<cfinvokeargument name="showLink" value="false"/>
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
					if (document.lista.TIPO.value =='') 
					{
						alert('Debe seleccionar un Tipo de Reversión');
						return false;
					}
					if (algunoMarcado())
						document.lista.action = "NoFac-sql.cfm";
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