<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
<script language="JavaScript" type="text/JavaScript">
	function MM_reloadPage(init) {  //reloads the window if Nav4 resized
	  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
		document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
	  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
	}
	MM_reloadPage(true);
</script>

<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cfif isdefined("Url.Cconcepto") and len(trim(Url.Cconcepto)) NEQ 0 and not isdefined("form.Cconcepto")>
	<cfset form.Cconcepto = Url.Cconcepto>
</cfif>					  
<cfparam name="form.Cconcepto" type="numeric">
<cfquery name="rsConceptoContable" datasource="#session.DSN#">
  select Cdescripcion 
	from ConceptoContableE
	where Ecodigo = #session.Ecodigo#
	and Cconcepto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cconcepto#"> 
</cfquery>					
<cfif isdefined("rsConceptoContable") and rsConceptoContable.RecordCount neq 0 and not isdefined("form.Cdescripcion")>
	<cfset form.Cdescripcion = rsConceptoContable.Cdescripcion>
</cfif>
<script language="JavaScript1.2" type="text/javascript">
	function limpiar2(){
		document.filtro.Identificacion_filtro.value = "";
		document.filtro.Nombre_filtro.value   = "";
	}
</script>
<cfset filtro = "">	
<cfif isdefined("form.Identificacion_filtro") and len(trim(form.Identificacion_filtro)) gt 0 >
	<cfset filtro = filtro & " and b.Pid like '%" & trim(form.Identificacion_filtro) & "%'">
</cfif>					  
<cfif isdefined("form.Nombre_filtro") and len(trim(form.Nombre_filtro)) gt 0 >
	<cfset filtro = filtro & " and upper(rtrim(ltrim(b.Pnombre #_Cat#  ' ' #_Cat# b.Papellido1 #_Cat# ' ' #_Cat# b.Papellido2))) like '%#ucase(form.Nombre_filtro)#%'" >
</cfif>
<cfset regresar = "/cfmx/sif/cg/admin/catalogos/ConceptoContableE.cfm">
<cfquery name="rsUsrConceptosContables" datasource="#Session.DSN#">
	select distinct Usucodigo
	from UsuarioConceptoContableE
	where Ecodigo = #Session.Ecodigo#
	and Cconcepto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cconcepto#">
</cfquery>

<cfif rsUsrConceptosContables.recordCount GT 0>
	<cfset filtro = filtro & " and a.Usucodigo in (#ValueList(rsUsrConceptosContables.Usucodigo, ',')#)">
<cfelse>
	<cfset filtro = filtro & " and a.Usucodigo = 0">
</cfif>
<cf_templateheader title="Contabilidad General">
	<cfinclude template="../../portlets/pNavegacion.cfm">
	<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="Permiso Conceptos Contables">		
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td align="center" colspan="2">
				<strong><font size="2"> Permiso Conceptos Contables: </font></strong> <font size="2"><cfoutput>#form.Cdescripcion#</cfoutput></font>
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td valign="top" width="40%">
				<form style="margin:0;" name="filtro" method="post">
					<table border="0" width="100%" class="areaFiltro">
						<tr> 
							<td><strong>Identificaci&oacute;n:</strong></td>
							<td><strong>Nombre:</strong></td>
						</tr>
						<tr> 
							<td>
								<input type="text" name="Identificacion_filtro" value="<cfif isdefined("form.Identificacion_filtro") and len(trim(form.Identificacion_filtro)) gt 0 ><cfoutput>#form.Identificacion_filtro#</cfoutput></cfif>" size="10" maxlength="60" onFocus="javascript:this.select();" >
							</td>
							<td>
								<input type="text" name="Nombre_filtro" value="<cfif isdefined("form.Nombre_filtro") and len(trim(form.Nombre_filtro)) gt 0 ><cfoutput>#form.Nombre_filtro#</cfoutput></cfif>" size="60" maxlength="60" onFocus="javascript:this.select();" >
							</td>
							<td nowrap>
                            	<input type="submit" name="Filtrar" value="Filtrar" class="btnFiltrar">
                                <input type="button" name="Limpiar" value="Limpiar" class="btnLimpiar" onClick="javascript:limpiar2();">
                            </td>
						</tr>
					</table>
					<input type="hidden" id="Cconcepto" name="Cconcepto" value="<cfif isdefined("form.Cconcepto") and len(trim(form.Cconcepto)) neq 0><cfoutput>#form.Cconcepto#</cfoutput></cfif>">
				</form>						
				<!--- Lista de Usuarios que tienen permisos --->
				<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
					<cfinvokeargument name="tabla" 		value="Usuario a, DatosPersonales b"/>
					<cfinvokeargument name="columnas" 	value="a.Usucodigo, b.Pid, b.Pnombre #_Cat# ' '#_Cat# b.Papellido1 #_Cat# ' ' #_Cat# b.Papellido2 as nombre, '#Form.Cconcepto#' as Cconcepto"/>
					<cfinvokeargument name="desplegar" 	value="Pid, nombre"/>
					<cfinvokeargument name="etiquetas" 	value="Identificaci&oacute;n, Nombre"/>
					<cfinvokeargument name="formatos" 	value="V, V"/>
					<cfinvokeargument name="filtro" 	value="a.CEcodigo = #Session.CEcodigo#
						  and a.Uestado = 1 
						  and a.Utemporal = 0
						  and a.datos_personales = b.datos_personales 
						  #filtro# 
						  order by b.Papellido1, b.Papellido2, b.Pnombre"/>
					<cfinvokeargument name="align" 		value="left, left"/>
					<cfinvokeargument name="ajustar" 	value="N"/>
					<cfinvokeargument name="checkboxes" value="N"/>
					<cfinvokeargument name="debug" 		value="N"/>
					<cfinvokeargument name="irA" 		value="ConceptoContablePermiso.cfm"/>
					<cfinvokeargument name="conexion" 	value="asp"/>
				</cfinvoke>
				</td>
				<td width="60%" valign="top">
					<input type="hidden" id="Cdescripcion" name="Cdescripcion" value="<cfif isdefined("form.Cdescripcion") and len(trim(form.Cdescripcion)) neq 0><cfoutput>#form.Cdescripcion#</cfoutput></cfif>">
					<cfinclude template="ConceptoContablePermiso-form.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>