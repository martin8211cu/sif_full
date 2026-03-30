<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_RecursosHumanos"
Default="Recursos Humanos"
XmlFile="/rh/generales.xml"
returnvariable="LB_RecursosHumanos"/>

<cf_templateheader title="#LB_RecursosHumanos#">
<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">

<cfif isdefined ('form.CFpk') and len(trim(form.CFpk)) gt 0 and not isdefined ('form.CFcodigo')>
	<cfquery name="rsDato" datasource="#session.dsn#">
		select CFcodigo from CFuncional where CFid=#form.CFpk#
	</cfquery>
	<cfset form.CFcodigo=#rsDato.CFcodigo#>
</cfif>

<cfif isdefined("Url.CFcodigo") and len(trim(Url.CFcodigo)) NEQ 0 and not isdefined("form.CFcodigo")>
	<cfset form.CFcodigo = Url.CFcodigo>
</cfif> 

<cfif isdefined("Url.Identificacion_filtro") and len(trim(Url.Identificacion_filtro)) NEQ 0 and not isdefined("form.Identificacion_filtro")>
	<cfset form.Identificacion_filtro = Url.Identificacion_filtro>
</cfif> 

<cfif isdefined("Url.Nombre_filtro") and len(trim(Url.Nombre_filtro)) NEQ 0 and not isdefined("form.Nombre_filtro")>
	<cfset form.Nombre_filtro = Url.Nombre_filtro>
</cfif> 	

<cfquery name="rsCFuncional" datasource="#session.dsn#">
	select CFdescripcion from CFuncional where CFcodigo='#form.CFcodigo#' and Ecodigo=#session.Ecodigo#
</cfquery>

<cfif len(trim(rsCFuncional.CFdescripcion)) gt 0>
	<cfset Lvardesc= rsCFuncional.CFdescripcion>
</cfif>

<script language="JavaScript1.2" type="text/javascript">
	function limpiar(){
		document.filtro.reset();
		document.filtro.Identificacion_filtro.value = "";
		document.filtro.Nombre_filtro.value   = "";
	}
</script>

<!---<cfdump var="#form#">--->
<cfset filtro = "">
<cfset navegacion="">
<cfif isdefined("form.Identificacion_filtro") and len(trim(form.Identificacion_filtro)) gt 0 >
	<cfset filtro = filtro & " and b.Pid like '%" & trim(form.Identificacion_filtro) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Identificacion_filtro=" & form.Identificacion_filtro>
</cfif>

<cfif isdefined("form.Nombre_filtro") and len(trim(form.Nombre_filtro)) gt 0 >
	<cfset filtro = filtro & " and upper(rtrim(ltrim( {fn concat({fn concat({fn concat({fn concat(b.Pnombre , ' ' )}, b.Papellido1 )}, ' ' )}, b.Papellido2 )} ))) like '%#ucase(form.Nombre_filtro)#%' " >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Nombre_filtro=" & form.Nombre_filtro>
</cfif>
		
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_UsuarioAutorizadores"
Default="Usuarios Autorizadores"
returnvariable="LB_UsuarioAutorizadores"/>

<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="#LB_UsuarioAutorizadores#">
	<cfset regresar = "/cfmx/rh/admin/catalogos/CFuncional.cfm">	 
	<cfinclude template="/rh/portlets/pNavegacion.cfm">

	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td align="center" colspan="2">
				<strong><font size="2">
				<cf_translate key="LB_PermisoAUsuariosDelTipoDeAccion">Usuarios con autorización para el Centro Funcional</cf_translate>:
				</font></strong> 
				<font size="2"><cfoutput>#Lvardesc#</cfoutput></font>
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td valign="top" width="40%">
			<form style="margin:0;" name="filtro" method="post">
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_INDENTIFICACION"
					Default="Identificaci&oacute;n"
					returnvariable="LB_INDENTIFICACION"/>
	
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_NOMBRE"
					Default="Nombre"
					returnvariable="LB_NOMBRE"/>
	
						<table border="0" width="100%" class="areaFiltro">
							<tr> 
								<cfoutput>
									<td><strong>#LB_INDENTIFICACION#</strong></td>
									<td><strong>#LB_NOMBRE#</strong></td>
								</cfoutput>
							</tr>
							<tr> 
								<td><input type="text" name="Identificacion_filtro" value="<cfif isdefined("form.Identificacion_filtro") and len(trim(form.Identificacion_filtro)) gt 0 ><cfoutput>#form.Identificacion_filtro#</cfoutput></cfif>" size="10" maxlength="10" onFocus="javascript:this.select();" ></td>
								<td><input type="text" name="Nombre_filtro" value="<cfif isdefined("form.Nombre_filtro") and len(trim(form.Nombre_filtro)) gt 0 ><cfoutput>#form.Nombre_filtro#</cfoutput></cfif>" size="40" maxlength="60" onFocus="javascript:this.select();" ></td>
								<td nowrap>
									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="BTN_Filtrar"
									Default="Filtrar"
									XmlFile="/rh/generales.xml"
									returnvariable="BTN_Filtrar"/>
									
									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="BTN_Limpiar"
									Default="Limpiar"
									XmlFile="/rh/generales.xml"
									returnvariable="BTN_Limpiar"/>	
									
									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="BTN_Regresar"
									Default="REgresar"
									XmlFile="/rh/generales.xml"
									returnvariable="BTN_Regresar"/>	
									
									<input type="submit" name="Filtrar" value="<cfoutput>#BTN_Filtrar#</cfoutput>">
									<input type="button" name="Limpiar" value="<cfoutput>#BTN_Limpiar#</cfoutput>" onClick="javascript:limpiar2();">
								</td>
							<input type="hidden" id="CFcodigo" name="CFcodigo" value="<cfif isdefined("form.CFcodigo") and len(trim(form.CFcodigo)) neq 0><cfoutput>#form.CFcodigo#</cfoutput></cfif>">
								<cfif isdefined ('form.CFcodigo') and len(trim(form.CFcodigo)) gt 0>
									<cfquery name="rsCFid" datasource="#session.dsn#">
										select CFid from CFuncional where CFcodigo='#form.CFcodigo#' and Ecodigo=#session.Ecodigo#
									</cfquery>
									<cfif rsCFid.recordcount gt 0>
										<cfset LvarCFid=rsCFid.CFid>
									<cfelse>
										<cfset LvarCFid=''>
									</cfif>
								</cfif>
							</tr>								
						</table>
					</form>
	
	
				<!--- Lista de Usuarios que tienen permisos --->
				<cfquery name="rsUsuariosCF" datasource="#Session.DSN#">
				select distinct Usucodigo
				from CFUsuarios
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and CFid = (select CFid from CFuncional where CFcodigo ='#form.CFcodigo#' and Ecodigo=#session.Ecodigo#)
				</cfquery>
				
				<cfif rsUsuariosCF.recordCount GT 0>
				<cfset filtro = filtro & " and a.Usucodigo in (#ValueList(rsUsuariosCF.Usucodigo, ',')#)">
				<cfelse>
				<cfset filtro = filtro & " and a.Usucodigo = 0">
				</cfif>
				
				<cfinvoke 
				component="rh.Componentes.pListas"
				method="pListaRH"
				returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="Usuario a, DatosPersonales b"/>
				<cfinvokeargument name="columnas" value="a.Usucodigo, b.Pid,{fn concat({fn concat({fn concat({fn concat(b.Pnombre , ' ' )}, b.Papellido1 )}, ' ' )}, b.Papellido2 )}  as nombre,1 as tab,#LvarCFid# as CFpk"/>
				<cfinvokeargument name="desplegar" value="Pid, nombre"/>
				<cfinvokeargument name="etiquetas" value="#LB_INDENTIFICACION#,#LB_NOMBRE#"/>
				<cfinvokeargument name="formatos" value="V, V"/>
				<cfinvokeargument name="filtro" value="a.CEcodigo = #Session.CEcodigo#
				and a.Uestado = 1 
				and a.Utemporal = 0
				and a.datos_personales = b.datos_personales 
				#filtro# 
				order by b.Papellido1, b.Papellido2, b.Pnombre"/>
				<cfinvokeargument name="align" value="left, left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="debug" value="N"/>
				<cfinvokeargument name="incluyeForm" value="true">
				<cfinvokeargument name="formName" value="form2">
				<cfinvokeargument name="irA" value="CFAutorizadores.cfm"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="conexion" value="asp"/>
				</cfinvoke>
			</td>
	
			<td width="60%" valign="top">
				<cfinclude template="CFAutorizadores-form.cfm">
			</td>
		
		</tr>
	</table>


	<script language="JavaScript1.2" type="text/javascript">
	function limpiar2(){
		document.filtro.reset();
		document.filtro.Identificacion_filtro.value = "";
		document.filtro.Nombre_filtro.value   = "";	
	}
	</script>

<cf_web_portlet_end>
<cf_templatefooter>