<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cfinvoke key="LB_nav__SPdescripcion" default="Comportamientos Por Habilidad"  returnvariable="LB_nav__SPdescripcion" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Codigo" default="C&oacute;digo"  returnvariable="LB_Codigo" component="sif.Componentes.Translate"  method="Translate" />	
<cfinvoke key="LB_Descripcion" default="Descripci&oacute;n"  returnvariable="LB_Descripcion" component="sif.Componentes.Translate"  method="Translate" />
<cfinvoke key="LB_Habilidad" default="Habilidad"  returnvariable="LB_Habilidad" component="sif.Componentes.Translate"  method="Translate" />
<cfinvoke key="LB_ListaHabilidades" default="Lista de Habilidades"  returnvariable="LB_ListaHabilidades" component="sif.Componentes.Translate"  method="Translate" />
<cfinvoke key="LB_Peso" default="Peso"  returnvariable="LB_Peso" component="sif.Componentes.Translate"  method="Translate" />
<cfinvoke key="LB_GrupoDeNiveles" default="Grupo de niveles"  returnvariable="LB_GrupoDeNiveles" component="sif.Componentes.Translate"  method="Translate" />
<cfinvoke key="LB_ListaDeGruposDeNivel" default="Lista de Grupos de Nivel"  returnvariable="LB_ListaDeGruposDeNivel" component="sif.Componentes.Translate"  method="Translate" />
<cfinvoke key="MSG_LaSumaDeLosPesosDebeSerCien" default="La suma de los pesos debe ser cien"  returnvariable="MSG_PesosCien" component="sif.Componentes.Translate"  method="Translate" />	

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("url.FILTRO_RHCOcodigo") and len(trim(url.FILTRO_RHCOcodigo))>
	<cfset form.FILTRO_RHCOcodigo = url.FILTRO_RHCOcodigo>
</cfif>
<cfif isdefined("url.FILTRO_RHCOpeso") and len(trim(url.FILTRO_RHCOpeso))>
	<cfset form.FILTRO_RHCOpeso = url.FILTRO_RHCOpeso>
</cfif>
<cfif isdefined("Form.FILTRO_RHCOcodigo") and Len(Trim(Form.FILTRO_RHCOcodigo)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FILTRO_RHCOcodigo=" & Form.FILTRO_RHCOcodigo>
	<cfset filtro = filtro & " and upper(ltrim(rtrim(a.RHCOcodigo))) like '%" & UCase(Form.FILTRO_RHCOcodigo) & "%'">
</cfif>
<cfif isdefined("Form.FILTRO_RHCOpeso") and Len(Trim(Form.FILTRO_RHCOpeso)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FILTRO_RHCOpeso=" & Form.FILTRO_RHCOpeso>
	<cfset filtro = filtro & ' and RHCOpeso=#form.FILTRO_RHCOpeso#'>
</cfif>

<cf_templateheader title="#LB_nav__SPdescripcion#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	<cfif isdefined("Url.RHCOid") and not isdefined("Form.RHCOid")>
		<cfparam name="Form.RHCOid" default="#Url.RHCOid#">
		<cfset form.modo = 'CAMBIO'>
	</cfif>
	<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
		<cfoutput>#pNavegacion#</cfoutput>
		<table width="100%" style="vertical-align:top" border="0" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td width="50%" valign="top">		
					<cfquery name="rsLista" datasource="#session.DSN#">
						select 	a.RHCOid,
								<cf_dbfunction name="concat" args="b.RHHcodigo,' - ',b.RHHdescripcion"> as Habilidad,
								b.RHHid,
								b.RHHcodigo,
								b.RHHdescripcion,
								a.RHCOcodigo,
								a.RHCOdescripcion,
								a.RHCOpeso
						from RHComportamiento a
							inner join RHHabilidades b
								on a.RHHid = b.RHHid
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							#PreserveSingleQuotes(filtro)#
						order by b.RHHid,a.RHCOid
					</cfquery>
					<cfinvoke component="rh.Componentes.pListas" method="pListaQuery"
						query="#rsLista#"
						Cortes="Habilidad"
						desplegar="RHCOcodigo,RHCOpeso"
						etiquetas="#LB_Codigo#,#LB_Peso#"
						formatos="S,S"
						align="left,right"
						ira=""
						showEmptyListMsg="yes"
						keys="RHCOid"	
						MaxRows="20"						
						filtrar_automatico="true"
						mostrar_filtro="true"
						navegacion="#navegacion#"
					/>						
			  	</td>
				<td width="50%" valign="top" align="center">	
					<cfinclude template="Comportamientos-form.cfm">
				</td>
			</tr>
		</table>	
	<cf_web_portlet_end>
	
<cf_templatefooter>
