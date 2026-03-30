<cfparam name="modo" default="ALTA"></cfparam>
<cfif isdefined('url.modo') and len(trim('url.modo'))>
	<cfset modo=#url.modo#>
</cfif>
<cfif modo neq 'ALTA' and isdefined('url.PTid') and len(trim('url.PTid'))>
	<cfset form.PTid=url.PTid>
</cfif>
<cfparam name="modo" default="ALTA"></cfparam>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
<cfoutput>#pNavegacion#</cfoutput>
<cf_web_portlet_start border="true" titulo="Catalogo de Turnos" skin="#Session.Preferences.Skin#">
<table width="100%" border="1" cellspacing="0" cellpadding="0">
			<tr>
				<td valign="top">
					<cf_dbfunction name="OP_CONCAT" returnvariable="_Cat">
					<cfquery name="rsSelectTurnos" datasource="#session.dsn#">
						select PTid, PTcodigo, 
							case when (PThoraini/60) < 10 then '0' #_Cat# <cf_dbfunction name="to_char" args="PThoraini/60"> else <cf_dbfunction name="to_char" args="PThoraini/60"> end
								#_Cat#':'#_Cat#
								case when PThoraini -(PThoraini/60)*60 < 10 then '0' #_Cat# <cf_dbfunction name="to_char" args="PThoraini -(PThoraini/60)*60"> else <cf_dbfunction name="to_char" args="PThoraini -(PThoraini/60)*60"> end
							as PThoraini,
							case when (PThorafin/60) < 10 then '0' #_Cat# <cf_dbfunction name="to_char" args="PThorafin/60"> else <cf_dbfunction name="to_char" args="PThorafin/60"> end
								#_Cat#':'#_Cat#
								case when PThorafin -(PThorafin/60)*60 < 10 then '0' #_Cat# <cf_dbfunction name="to_char" args="PThorafin -(PThorafin/60)*60"> else <cf_dbfunction name="to_char" args="PThorafin -(PThorafin/60)*60"> end
							as PThorafin
							from PTurnos
						where Ecodigo = #session.Ecodigo#
						<cfif isdefined('form.filtro_PTcodigo') and len(trim(form.filtro_PTcodigo))>
						and lower(PTcodigo) like lower(<cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.filtro_PTcodigo#%">)
						</cfif>
					</cfquery>
					
					<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
						query="#rsSelectTurnos#" 
						conexion="#session.dsn#"
						desplegar="PTcodigo, PThoraini, PThorafin"
						etiquetas="Código del Turno ,Hora Inicio, Hora Final"
						formatos="S,S,S"
						mostrar_filtro="true"
						align="left,left,left"
						checkboxes="N"
						ira="turnos.cfm"
						keys="PTid">
					</cfinvoke>
				</td>
				<td width="50%" valign="top">
					<cfinclude template="turnos_form.cfm">
				</td>
			</tr>
		</table>
<cfoutput>
<script language="javascript1.2" type="text/javascript">
	lista.filtro_PThoraini.style.visibility = 'hidden';
	lista.filtro_PThorafin.style.visibility = 'hidden';
</script>
</cfoutput>
<cf_web_portlet_end>
<cf_templatefooter>