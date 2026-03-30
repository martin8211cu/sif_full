<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/rh/generales.xml"/>
<cfinvoke key="LB_Codigo" default="C&oacute;digo" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Descripcion" default="Descripci&oacute;n" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
	<cf_templateheader title="#LB_RecursosHumanos#">

		<cf_templatecss>
		<link href="../../css/rh.css" rel="stylesheet" type="text/css">
		<cfif isdefined("Url.RHTid") and len(trim(Url.RHtid)) NEQ 0 and not isdefined("form.RHTid")>
			<cfset form.RHTid = Url.RHTid>
		</cfif> 
		<cfparam name="form.RHTid" type="numeric">
		
		<cfquery name="rsRHTipoAccion" datasource="#session.DSN#">
			select RHTdesc
			from RHTipoAccion
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTid#"> 
		</cfquery>
		<cfif isdefined("rsRHTipoAccion") and rsRHTipoAccion.RecordCount neq 0 and not isdefined("form.RHTdesc")>
			<cfset form.RHTdesc = rsRHTipoAccion.RHTdesc>
		</cfif>

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			key="LB_CatalogoDeComponentesSalarialesAPagar"
			default="Cat&aacute;logo de Componentes Salariales a Pagar"
			returnvariable="LB_CatalogoDeComponentesSalarialesAPagar"/>

		<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="#LB_CatalogoDeComponentesSalarialesAPagar#">
			<cfset regresar = "/cfmx/sif/rh/admin/catalogos/TipoAccion.cfm">
			<cfinclude template="../../portlets/pNavegacion.cfm">

			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td align="center" colspan="2">
						<strong><font size="2">
							<cf_translate key="LB_ComponentesSalarialesAPagar">Componentes Salariales a Pagar</cf_translate>:
						</font></strong> 
						<font size="2"><cfoutput>#form.RHTdesc#</cfoutput></font>
					</td>
				</tr>
				<tr><td colspan="2">&nbsp;</td></tr>
				<tr>
					<td valign="top" width="40%">
						<!--- Lista de Usuarios que tienen permisos --->
						<cfquery name="rsUsuariosTipoAccion" datasource="#Session.DSN#">
							select distinct CSid
							from RHComponentesPagarA
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTid#">
						</cfquery>
						<cfinvoke 
						 component="rh.Componentes.pListas"
						 method="pListaRH"
						 returnvariable="pListaRet">
							<cfinvokeargument name="tabla" value="RHComponentesPagarA a
																	inner join ComponentesSalariales b
																	  on b.Ecodigo = a.Ecodigo
																	  and b.CSid = a.CSid"/>
							<cfinvokeargument name="columnas" value="a.RHTid,a.CSid,CScodigo, CSdescripcion"/>
							<cfinvokeargument name="desplegar" value="CScodigo, CSdescripcion"/>
							<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#"/>
							<cfinvokeargument name="formatos" value="S, S"/>
							<cfinvokeargument name="filtro" value="a.Ecodigo = #Session.Ecodigo#
																	and RHTid = #form.RHTid#"/>
							<cfinvokeargument name="align" value="left, left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="checkboxes" value="N"/>
							<cfinvokeargument name="debug" value="N"/>
							<cfinvokeargument name="irA" value="ComponentesPagar.cfm"/>
							<cfinvokeargument name="mostrar_filtro" value="yes"/>
							<cfinvokeargument name="filtrar_automatico" value="yes"/>
						</cfinvoke>
					</td>
					<td width="60%" valign="top">
						<input type="hidden" id="RHTdesc" name="RHTdesc" value="<cfif isdefined("form.RHTdesc") and len(trim(form.RHTdesc)) neq 0><cfoutput>#form.RHTdesc#</cfoutput></cfif>">
						<cfinclude template="ComponentesPagar-form.cfm">
					</td>
				</tr>
			</table>

			
		<cf_web_portlet_end>
<cf_templatefooter>