<cf_templateheader title="Requisiciones Intercompa&ntilde;&iacute;a">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Requisiciones Intercompa&ntilde;&iacute;a'>
			<cfinclude template="../../portlets/pNavegacion.cfm">
			<br><table width="99%" align="center" border="0" cellpadding="0" cellspacing="0"><tr><td>
			<cfset filtro = "">
			<cfinclude template="RequisicionesInter-filtro.cfm">

			<cfquery name="rsQuery" datasource="#session.dsn#">
				select 	a.ERid, 
						a.ERFecha, 
						a.ERdocumento, 
						a.ERdescripcion, 
						a.ERtotal, 
						b.Bdescripcion

				from ERequisicion a 
				inner join Almacen b 
				on a.Ecodigo = b.Ecodigo 
				and a.Aid = b.Aid

				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				  and a.EcodigoRequi != <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				<cfif isdefined("Form.fAid") and form.fAid NEQ "all" >
					and a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.fAid#">
				</cfif>
				<cfif isdefined("Form.fERdocumento") and form.fERdocumento NEQ "" >
					and upper(ERdocumento) like upper('%#Form.fERdocumento#%')
				</cfif>
				<cfif isdefined("Form.fERdescripcion") and form.fERdescripcion neq "" >
					and upper(ERdescripcion) like upper('%#Form.fERdescripcion#%')
				</cfif>
				<cfif isdefined("Form.fERFecha") and form.fERFecha neq "" >
				<cfset Lfecha = LSParseDateTime(Form.fERFecha)>
					and ERFecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#Lfecha#">
				</cfif>
				<cfif isdefined("Form.fUsuario") and form.fUsuario neq "all" >
					and ERusuario = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.fUsuario#">
				</cfif>
				order by ERFecha desc, ERid
			</cfquery>
			<form action="RequisicionesInter.cfm" method="post" name="lista" style="margin:0">
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
					<cfinvokeargument name="desplegar" value="ERdocumento, ERdescripcion, Bdescripcion, ERFecha"/>
					<cfinvokeargument name="etiquetas" value="Documento, Descripci&oacute;n, Almac&eacute;n, Fecha"/>
					<cfinvokeargument name="formatos" value="V, V, V, D"/>
					<cfinvokeargument name="align" value="left, left, left, left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="checkboxes" value="S"/>
					<cfinvokeargument name="irA" value="RequisicionesInter.cfm"/>
					<cfinvokeargument name="keys" value="ERid"/>
					<cfinvokeargument name="botones" value="Aplicar, Nuevo"/>
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
						document.lista.action = "RequisicionesInter-sql.cfm";
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