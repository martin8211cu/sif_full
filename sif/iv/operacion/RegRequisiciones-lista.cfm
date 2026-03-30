<cf_templateheader title="Requisiciones ">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Requisiciones'>
			<cfparam name="LvarUsuarioAprobador" default="false">
			<cfparam name="LvarUsuarioDespachador" default="false">
			<cfparam name="LvarEstado" default="0">
			<cfinclude template="../../portlets/pNavegacion.cfm">
			<br><table width="99%" align="center" border="0" cellpadding="0" cellspacing="0"><tr><td>
			<cfset filtro = "">
			<cfinclude template="RegRequisiciones-filtro.cfm">
			<cfquery name="rsQuery" datasource="#session.dsn#">
				select a.ERid, a.ERFecha, a.ERdocumento, a.ERdescripcion, a.ERtotal, b.Bdescripcion,a.Estado,a.ERFechaA 
				from (ERequisicion a inner join Almacen b on a.Ecodigo = b.Ecodigo and a.Aid = b.Aid)
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				and a.EcodigoRequi = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
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
				
				<cfif isdefined("Form.fEstado") and form.fEstado neq "-1" >
					and a.Estado = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.fEstado#">
				</cfif>
				
				<cfif LvarUsuarioAprobador eq 'true' or LvarEstado EQ 0>
					and Estado = 0
				<cfelseif LvarUsuarioDespachador eq 'true'>
					and Estado in (1,2)
				</cfif>
				and a.Aid in (select ar.Aid
									from Usuario u
									inner join DatosPersonales d
										on u.datos_personales = d.datos_personales
									inner join AResponsables ar
										on  u.Usucodigo = ar.Usucodigo
									inner join Almacen a
										on ar.Aid = a.Aid	
										and ar.Ocodigo = a.Ocodigo
										and ar.Ecodigo = a.Ecodigo
									where u.Usucodigo = #session.Usucodigo#
									)
				order by ERFecha desc, ERid
			</cfquery>
			
			<cfif LvarUsuarioAprobador eq 'true'>
				<cfset LvarDirec2 = "RequisicionesAP-form.cfm ">
			<cfelseif LvarUsuarioDespachador eq 'true' >
				<cfset LvarDirec2 = "RequisicionesDesp-form.cfm">
			<cfelse>
				<cfset LvarDirec2 = "RegRequisiciones.cfm">
			</cfif>
			
			<form action="<cfoutput>#LvarDirec2#</cfoutput>" method="post" name="lista" style="margin:0">
				<input type="hidden" name="LvarUsuarioAprobador" value="<cfoutput>#LvarUsuarioAprobador#</cfoutput>">
				<input type="hidden" name="LvarUsuarioDespachador" value="<cfoutput>#LvarUsuarioDespachador#</cfoutput>">
				<input type="hidden" name="LvarCaptura" value="SI">	
				<!---<cfset modo = "">
				<input type="hidden" name="modo" value="LISTA">--->
				<table width="1%" border="0">
					<tr>
						<td nowrap><input type="checkbox" name="chkall" value="T" onClick="javascript:check_all( this );"></td>
						<td nowrap><strong>Marcar Todos.</strong></td>
					</tr>
				</table>
				<cfif LvarUsuarioAprobador eq 'true'>
					<cfset botones = ''>
					<cfset checkboxes = 'N'>
				<cfelseif LvarUsuarioDespachador eq 'true'>
					<cfset botones = ''>
					<cfset checkboxes = 'N'>
				<cfelse>
					<cfset botones = 'Nuevo, Enviar_Aprobar'>
					<cfset checkboxes = 'S'>
				</cfif>
				<cfinvoke 
						component="sif.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsquery#"/>
					<cfinvokeargument name="desplegar" value="ERdocumento, ERdescripcion, Bdescripcion, ERFecha, ERFechaA"/>
					<cfinvokeargument name="etiquetas" value="Documento, Descripci&oacute;n, Almac&eacute;n, Fecha, Aprobado"/>
					<cfinvokeargument name="formatos" value="V, V, V, D, D"/>
					<cfinvokeargument name="align" value="left, left, left, left, left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="checkboxes" value="#checkboxes#"/>
					<cfinvokeargument name="irA" value="#LvarDirec2#"/>
					<cfinvokeargument name="keys" value="ERid"/>
					<cfinvokeargument name="botones" value="#botones#"/>
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
						return (confirm("¿Está seguro de que desea enviar a aprobar los documentos seleccionados?"));
					} else {
						alert('Debe seleccionar al menos un documento antes de enviar a aprobar');
						return false;
					}
				}
				function funcEnviar_Aprobar() {
					if (algunoMarcado())
						document.lista.action = "RegRequisiciones-sql.cfm";
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