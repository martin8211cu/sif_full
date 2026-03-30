<cfif isdefined("url.pageNum_lista") and not isdefined("form.pageNum_lista") >
	<cfset form.pageNum_lista = url.pageNum_lista >
</cfif>

<cfif isdefined("url.fPCcodigo") and len(trim(url.fPCcodigo)) and not isdefined("form.fPCcodigo")>
	<cfset form.fPCcodigo = url.fPCcodigo >
</cfif>
<cfif isdefined("url.fPCnombre") and len(trim(url.fPCnombre)) and not isdefined("form.fPCnombre")>
	<cfset form.fPCnombre = url.fPCnombre >
</cfif>
<cfif isdefined("url.fPCdescripcion") and len(trim(url.fPCdescripcion)) and not isdefined("form.fPCdescripcion")>
	<cfset form.fPCdescripcion = url.fPCdescripcion >
</cfif>

<cf_template template="#session.sitio.template#">
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_DefinicionDeCuestionarios"
Default="Definici&oacute;n de Cuestionarios"
returnvariable="LB_DefinicionDeCuestionarios"/>


<cf_templatearea name="title">
	<cfoutput>#LB_DefinicionDeCuestionarios#</cfoutput>
</cf_templatearea>
<cf_templatearea name="body">

<cf_web_portlet titulo="#LB_DefinicionDeCuestionarios#">
<cfinclude template="/home/menu/pNavegacion.cfm">

	<cfparam name="pageNum_lista" default="1">
	<cfset navegacion = '' >
	<cfset campos = '' >	
	<cfif isdefined("form.pageNum_lista") and len(trim(form.pageNum_lista)) >
		<cfset campos = campos & ",'#form.pageNum_lista#' as pageNum_lista" >		
	</cfif>
	<cfif isdefined("form.fPCcodigo") and len(trim(form.fPCcodigo)) >
		<cfset navegacion = navegacion & '&fPCcodigo=#form.fPCcodigo#' >
		<cfset campos = campos & ",'#form.fPCcodigo#' as fPCcodigo" >
	</cfif>
	<cfif isdefined("form.fPCnombre") and len(trim(form.fPCnombre)) >
		<cfset navegacion = navegacion & '&fPCnombre=#form.fPCnombre#' >
		<cfset campos = campos & ",'#form.fPCnombre#' as fPCnombre" >		
	</cfif>
	<cfif isdefined("form.fPCdescripcion") and len(trim(form.fPCdescripcion)) >
		<cfset navegacion = navegacion & '&fPCdescripcion=#form.fPCdescripcion#' >
		<cfset campos = campos & ",'#form.fPCdescripcion#' as fPCdescripcion" >		
	</cfif>

	<cfquery name="rsLista" datasource="sifcontrol">
		select PCid, PCcodigo, PCnombre, PCdescripcion #preservesinglequotes(campos)#
		from PortalCuestionario
		<!--- filtra si esta en RH, para pso ve todo--->
		<cfif isdefined("session.menues.SScodigo") and ucase(session.menues.SScodigo) neq 'SYS'>
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		<cfelse>
			where 1=1
		</cfif>
		<cfif isdefined("form.fPCcodigo") and len(trim(form.fPCcodigo)) >
			and upper(PCcodigo) like '%#trim(ucase(form.fPCcodigo))#%'
		</cfif>
		<cfif isdefined("form.fPCnombre") and len(trim(form.fPCnombre)) >
			and upper(PCnombre) like '%#trim(ucase(form.fPCnombre))#%'
		</cfif>
		<cfif isdefined("form.fPCdescripcion") and len(trim(form.fPCdescripcion)) >
			and PCdescripcion like '%#trim(form.fPCdescripcion)#%'
		</cfif>
		
		order by PCnombre
	</cfquery>
	
	<TABLE width="100%" border="0" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top" width="150">
				<cfinclude template="../menu.cfm">
			</td>
			<td valign="top">
				<table width="100%" cellspacing="0" cellpadding="0">
					<tr><td bgcolor="#e5e5e5" style="padding:3px;"><strong>Lista de Cuestionarios</strong></td></tr>
					<tr>
						<td>
							<cfoutput>
							<form name="filtro" method="post" action="cuestionario-lista.cfm" style="margin:0;">
							<table class="areaFiltro" width="100%" cellpadding="2" cellspacing="0">
								<tr>
									<td align="right"><strong>C&oacute;digo:</strong></td>
									<td><input name="fPCcodigo" value="<cfif isdefined("form.fPCcodigo") and len(trim(form.fPCcodigo)) >#form.fPCcodigo#</cfif>" size="10" maxlength="10" /></td>
									<td align="right"><strong>Nombre:</strong></td>
									<td><input name="fPCnombre" size="30" maxlength="60" value="<cfif isdefined("form.fPCnombre") and len(trim(form.fPCnombre)) >#form.fPCnombre#</cfif>" /></td>
									<td align="right"><strong>Descripci&oacute;n:</strong></td>
									<td><input name="fPCdescripcion" size="30" maxlength="255" value="<cfif isdefined("form.fPCdescripcion") and len(trim(form.fPCdescripcion)) >#form.fPCdescripcion#</cfif>"/></td>
									<td><input type="submit" name="btnFiltrar" value="Filtrar" class="btnFiltrar" /></td>
								</tr>	
							</table>
							</form>
							</cfoutput>
						</td>
					</tr>
					<tr>
						<td valign="top">
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_CODIGO"
							Default="C&oacute;digo"
							XmlFile="/rh/generales.xml"
							returnvariable="LB_CODIGO"/>
					
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_DESCRIPCION"
							Default="Descripci&oacute;n"
							XmlFile="/rh/generales.xml"
							returnvariable="LB_DESCRIPCION"/>	
							
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_Nombre"
							Default="Nombre"
							returnvariable="LB_Nombre"/>
							
							<cfinvoke component="rh.Componentes.pListas" method="pListaQuery">
								<cfinvokeargument name="query" 				value="#rsLista#">
								<cfinvokeargument name="desplegar" 			value="PCcodigo, PCnombre,PCdescripcion">
								<cfinvokeargument name="etiquetas" 			value="#LB_CODIGO#,#LB_Nombre#,#LB_DESCRIPCION#">
								<cfinvokeargument name="formatos" 			value="S,S,S">
								<cfinvokeargument name="align" 				value="left,left,left">
								<cfinvokeargument name="ira" 				value="cuestionario-tabs.cfm">
								<cfinvokeargument name="botones" 			value="Nuevo">
								<cfinvokeargument name="keys" 				value="PCid">
								<cfinvokeargument name="showEmptyListMsg" 	value="true">
								<cfinvokeargument name="navegacion"			value="#navegacion#">
								<cfinvokeargument name="maxRows" 			value="25">
							</cfinvoke>	
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
				</table>
			
			</td>
		</tr>
	</TABLE>


</cf_web_portlet>
</cf_templatearea>
</cf_template>


