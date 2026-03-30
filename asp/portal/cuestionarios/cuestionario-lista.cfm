<cfset navegacion = '' >
<cfif isdefined("url.pageNum_Lista") and not isdefined('form.pageNum_Lista') >
	<cfset form.pageNum_Lista = url.pageNum_Lista >
</cfif>
<cfif isdefined("url.fPCcodigo") and not isdefined('form.fPCcodigo') >
	<cfset form.fPCcodigo = url.fPCcodigo >
</cfif>
<cfif isdefined("url.fPCnombre") and not isdefined("form.fPCnombre") >
	<cfset form.fPCnombre = url.fPCnombre >
</cfif>
<cfif isdefined("url.fPCdescripcion") and not isdefined("form.fPCdescripcion") >
	<cfset form.fPCdescripcion = url.fPCdescripcion >
</cfif>

<cfset campos_extra = '' >
<cfif isdefined('form.fPCcodigo') and len(trim(form.fPCcodigo)) >
	<cfset navegacion = navegacion & '&fPCcodigo=#form.fPCcodigo#' >
	<cfset campos_extra = campos_extra & ", '#form.fPCcodigo#' as fPCcodigo" >	
</cfif>
<cfif isdefined("form.fPCnombre")  and len(trim(form.fPCnombre))  >
	<cfset navegacion = navegacion & '&fPCnombre=#form.fPCnombre#' >
	<cfset campos_extra = campos_extra & ", '#form.fPCnombre#' as fPCnombre" >	
</cfif>
<cfif isdefined("form.fPCdescripcion")  and len(trim(form.fPCdescripcion))  >
	<cfset navegacion = navegacion & '&fPCdescripcion=#form.fPCdescripcion#' >
	<cfset campos_extra = campos_extra & ", '#form.fPCdescripcion#' as fPCdescripcion" >	
</cfif>

<cfparam  name="form.pageNum_lista" default="1">
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_DefinicionDeCuestionarios"
Default="Definici&oacute;n de Cuestionarios"
returnvariable="LB_DefinicionDeCuestionarios"/>

<cf_templateheader title="#LB_DefinicionDeCuestionarios#">
<cf_web_portlet_start titulo="#LB_DefinicionDeCuestionarios#">
<cfinclude template="/home/menu/pNavegacion.cfm">

	<cfquery name="rsLista" datasource="sifcontrol">
		select PCid, PCcodigo, PCnombre, PCdescripcion, '#form.pageNum_lista#' as pageNum_lista #preservesinglequotes(campos_extra)#
		from PortalCuestionario
		<!--- filtra si esta en RH, para pso ve todo--->
		<cfif isdefined("session.menues.SScodigo") and ucase(session.menues.SScodigo) neq 'SYS'>
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		<cfelse>
			where 1=1
		</cfif>
		
		<cfif isdefined("form.fPCcodigo") and len(trim(form.fPCcodigo))>
			and upper(PCcodigo) like '%#trim(ucase(form.fPCcodigo))#%' 
		</cfif>
		<cfif isdefined("form.fPCnombre") and len(trim(form.fPCnombre))>
			and upper(PCnombre) like '%#trim(ucase(form.fPCnombre))#%' 
		</cfif>
		<cfif isdefined("form.fPCdescripcion") and len(trim(form.fPCdescripcion))>
			and upper(<cf_dbfunction name="to_char" args="PCdescripcion">) like '%#trim(ucase(form.fPCdescripcion))#%' 
		</cfif>
		
		order by PCnombre
	</cfquery>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CODIGO"
	Default="C&oacute;digo"
	XmlFile="/sif/rh/generales.xml"
	returnvariable="LB_CODIGO"/>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_DESCRIPCION"
	Default="Descripci&oacute;n"
	XmlFile="/sif/rh/generales.xml"
	returnvariable="LB_DESCRIPCION"/>	

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_FILTRAR"
	Default="Filtrar"
	XmlFile="/sif/rh/generales.xml"
	returnvariable="LB_FILTRAR"/>	

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_LIMPIAR"
	Default="Limpiar"
	XmlFile="/sif/rh/generales.xml"
	returnvariable="LB_LIMPIAR"/>	
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nombre"
	Default="Nombre"
	returnvariable="LB_Nombre"/>	

	<cfoutput>
	<table width="100%" cellspacing="0" cellpadding="0">
		<tr>
			<td valign="top">
				<form  onsubmit="return true;" method="post" style="margin:0;" action="cuestionario-lista.cfm" name="filtro" id="filtro">
				<table width="100%" cellpadding="1" cellspacing="0" class="areaFiltro">
					<tr>
						<td><strong>#LB_CODIGO#</strong></td>
						<td><strong>#LB_Nombre#</strong></td>
						<td><strong>#LB_DESCRIPCION#</strong></td>
						<td rowspan="2" width="20%" valign="middle" align="center">
							<input type="submit" name="Filtrar" value="#LB_FILTRAR#" class="btnFiltrar" />
							<input type="submit" name="Limpiar" value="#LB_LIMPIAR#" class="btnLimpiar" />							
						</td>
					</tr>
					<tr>
						<td><input name="fPCcodigo" type="text" size="10" maxlength="10" value="<cfif isdefined('form.fPCcodigo')>#trim(form.fPCcodigo)#</cfif>" onfocus="javascript:this.select();"/></td>
						<td><input name="fPCnombre" type="text" size="30" maxlength="60" value="<cfif isdefined('form.fPCnombre')>#trim(form.fPCnombre)#</cfif>" onfocus="javascript:this.select();"/></td>
						<td><input name="fPCdescripcion" type="text" size="30" maxlength="60" value="<cfif isdefined('form.fPCdescripcion')>#trim(form.fPCdescripcion)#</cfif>" onfocus="javascript:this.select();"/></td>
					</tr>
				</table>
				</form>
				
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
					<cfinvokeargument name="query" 				value="#rsLista#">
					<cfinvokeargument name="desplegar" 			value="PCcodigo,PCnombre,PCdescripcion">
					<cfinvokeargument name="etiquetas" 			value="#LB_CODIGO#,#LB_Nombre#,#LB_DESCRIPCION#">
					<cfinvokeargument name="formatos" 			value="S,S,S">
					<cfinvokeargument name="align" 				value="left,left,left">
					<cfinvokeargument name="ira" 				value="cuestionario.cfm">
					<cfinvokeargument name="botones" 			value="Nuevo">
					<cfinvokeargument name="keys" 				value="PCid">
					<cfinvokeargument name="showEmptyListMsg" 	value="true">
					<cfinvokeargument name="navegacion" 		value="#navegacion#">
				</cfinvoke>	
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</table>
	</cfoutput>

<cf_web_portlet_end><cf_templatefooter>


