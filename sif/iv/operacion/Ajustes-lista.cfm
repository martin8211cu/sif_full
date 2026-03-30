<cf_templateheader title="Ajustes de Inventario">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Ajustes de Inventario'>
			<cfinclude template="../../portlets/pNavegacion.cfm">
			<br><table width="99%" align="center" border="0" cellpadding="0" cellspacing="0"><tr><td>
			<cfset filtro = "">
			<cfinclude template="Ajustes-filtro.cfm">   
			<cfquery name="rsQuery" datasource="#session.dsn#">
				select a.EAid, a.EAdocumento, a.EAfecha, a.EAdescripcion, b.Bdescripcion
				from EAjustes a 
				inner join Almacen b 
				  on a.Aid = b.Aid
                  inner join AResponsables c
                   on c.Aid = b.Aid
                   and b.Ecodigo =  c.Ecodigo
				where 1=1
				and b.Ecodigo=#session.Ecodigo#
                 and c.Usucodigo = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_integer" >
				<cfif isdefined("Form.fAid") and form.fAid NEQ "all" >
					and a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.fAid#">
				</cfif>
				<cfif isdefined("Form.fEAdocumento") and form.fEAdocumento NEQ "" >
					and upper(EAdocumento) like upper('%#Form.fEAdocumento#%')
				</cfif>
				<cfif isdefined("Form.fEAdescripcion") and form.fEAdescripcion neq "" >
					and upper(EAdescripcion) like upper('%#Form.fEAdescripcion#%')
				</cfif>
				<cfif isdefined("Form.fEAFecha") and form.fEAFecha neq "" >
				   <cfset Lfecha = LSParseDateTime(Form.fEAFecha)>
					and EAfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#Lfecha#">
				</cfif>
				<cfif isdefined("Form.fUsuario") and form.fUsuario neq "all" >
					and EAusuario = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.fUsuario#">
				</cfif>
				order by a.EAfecha desc, EAid
			</cfquery>
			<form action="Ajustes.cfm" method="post" name="lista" style="margin:0">
				<table width="1%" border="0">
					<tr>
						<td nowrap><input type="checkbox" name="chkall" value="T" onClick="javascript:check_all( this );"></td>
						<td nowrap><strong>Marcar Todos.</strong></td>
					</tr>
				</table>
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
					<cfinvokeargument name="query" 				value="#rsquery#"/>
					<cfinvokeargument name="desplegar" 			value="EAdocumento, EAdescripcion, Bdescripcion, EAfecha"/>
					<cfinvokeargument name="etiquetas" 			value="Documento, Descripci&oacute;n, Almac&eacute;n, Fecha"/>
					<cfinvokeargument name="formatos" 			value="V, V, V, D"/>
					<cfinvokeargument name="align" 				value="left, left, left, left"/>
					<cfinvokeargument name="ajustar" 			value="N"/>
					<cfinvokeargument name="checkboxes" 		value="S"/>
					<cfinvokeargument name="irA" 				value="Ajustes.cfm"/>
					<cfinvokeargument name="keys" 				value="EAid"/>
					<cfinvokeargument name="botones" 			value="Aplicar, Nuevo"/>
					<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
					<cfinvokeargument name="checkbox_function" 	value="unMarkOne()"/>
					<cfinvokeargument name="formname" 			value="lista"/>
					<cfinvokeargument name="incluyeform" 		value="false"/>
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
						document.lista.action = "Ajustes-sql.cfm";
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