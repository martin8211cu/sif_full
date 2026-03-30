<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Registro_de_Asistencia_a_Cursos"
	Default="Registro de Asistencia a Cursos"
	returnvariable="LB_Asistencia"/>

<cfset campos_extra = '' >

<cfif isdefined("url.filtro_RHIAid") and Len(url.filtro_RHIAid)>
	<cfset campos_extra = campos_extra & ", '#url.filtro_RHIAid#' as filtro_RHIAid" >
</cfif>
<cfif isdefined("url.filtro_RHACid") and len(url.filtro_RHACid)>
	<cfset campos_extra = campos_extra & ", '#url.filtro_RHACid#' as filtro_RHACid" >
</cfif>
<cfif isdefined("url.filtro_RHGMid") and Len(url.filtro_RHGMid)>
	<cfset campos_extra = campos_extra & ", '#url.filtro_RHGMid#' as filtro_RHGMid" >
</cfif>
<cfif isdefined("url.filtro_Mnombre") and Len(url.filtro_Mnombre)>
	<cfset campos_extra = campos_extra & ", '#url.filtro_Mnombre#' as filtro_Mnombre" >
</cfif>
<cfif isdefined("url.filtro_RHCfdesde") and Len(url.filtro_RHCfdesde)>
	<cfset campos_extra = campos_extra & ", '#url.filtro_RHCfdesde#' as filtro_RHCfdesde" >
</cfif>
<cfif isdefined("url.filtro_RHCfhasta") and Len(url.filtro_RHCfhasta)>
	<cfset campos_extra = campos_extra & ", '#url.filtro_RHCfhasta#' as filtro_RHCfhasta" >
</cfif>
<cfparam name="url.pageNum_lista" default="1">
<cfif isdefined("url.pageNum_lista") and Len(url.pageNum_lista)>
	<cfset campos_extra = campos_extra & ",'#url.pageNum_lista#' as pageNum_lista" >
</cfif>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Sin_Clasificar"
	Default="Sin Clasificar"
	returnvariable="LB_Sin_Clasificar"/> 

<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2109" default="" returnvariable="valP"/>

<cfquery datasource="#session.dsn#" name="cursos">
	select 	c.RHCid, 
			c.Mcodigo, 
			m.Mnombre, 
			i.RHIAnombre,
			<cf_dbfunction name="concat" args="'<em>&nbsp;'|coalesce (ac.RHACdescripcion,'#LB_Sin_Clasificar#')|'</em>'" delimiters ="|"> as RHACdescripcion,
			RHCfdesde,
			RHCfhasta,
			c.RHCcupo,
			(c.RHCcupo - ( select count(1) from RHEmpleadoCurso ec where ec.RHCid = c.RHCid )) as disponible
			#preservesinglequotes(campos_extra)#

	from RHCursos c

	inner join RHMateria m
		on m.Mcodigo = c.Mcodigo
		and m.CEcodigo = #session.CEcodigo#

	inner join RHInstitucionesA i
		on i.RHIAid = c.RHIAid

	left join RHAreasCapacitacion ac
		on m.RHACid = ac.RHACid
	
	<!--- Grupo de materias --->
	<cfif isdefined("url.filtro_RHGMid") and Len(url.filtro_RHGMid) and url.filtro_RHGMid neq 'null'>
		join RHMateriasGrupo mg 
			on m.Mcodigo = mg.Mcodigo
		  	and mg.RHGMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.filtro_RHGMid#"> 
	</cfif>
	
	where exists (  select 1
					from RHEmpleadoCurso ec, DatosEmpleado de
					where ec.RHCid=c.RHCid
					and ec.DEid = de.DEid
					and de.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
	<cfif isdefined("url.filtro_RHIAid") and Len(url.filtro_RHIAid)>
		and c.RHIAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.filtro_RHIAid#">
	</cfif>

	<cfif isdefined("url.filtro_RHGMid") and url.filtro_RHGMid eq 'null'>
		and not exists ( select 1 from RHMateriasGrupo mg 
						 where m.Mcodigo = mg.Mcodigo
			  			 and mg.RHGMid is null )
	</cfif>

	<!--- muestra solo los cursos que no han sido calificados --->
	and exists( select 1
				from  RHEmpleadoCurso ec 
                     inner join LineaTiempo lt 
                    on lt.DEid= ec.DEid 
                    inner join RHCursos c
                    on c.RHCfdesde between lt.LTdesde and lt.LThasta 
				where ec.RHCid = c.RHCid
				  and ec.RHEMestado in(0)
				  <cfif valP gt 0>
                    and ec.RHECestado = 50
				   </cfif>)

	<cfif isdefined("url.filtro_RHACid") and url.filtro_RHACid eq 'null'>
		and m.RHACid is null
	<cfelseif isdefined("url.filtro_RHACid") and Len(url.filtro_RHACid)>
		and m.RHACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.filtro_RHACid#">
	</cfif>

	<cfif isdefined("url.filtro_Mnombre") and Len(url.filtro_Mnombre)>
		and upper(m.Mnombre) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(url.filtro_Mnombre)#%">
	</cfif>

	<cfif isdefined("url.filtro_RHCfdesde") and Len(url.filtro_RHCfdesde)>
		and c.RHCfdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(url.filtro_RHCfdesde)#">
	</cfif>

	<cfif isdefined("url.filtro_RHCfhasta") and Len(url.filtro_RHCfhasta)>
		and c.RHCfhasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(url.filtro_RHCfhasta)#">
	</cfif>

	<!---order by i.RHIAnombre, coalesce (ac.RHACdescripcion,'Sin Clasificar'), m.Mnombre, c.RHCfdesde--->
	order by c.RHCfdesde desc, i.RHIAnombre, m.Mnombre
</cfquery>

<cfquery datasource="#session.dsn#" name="inst">
	select RHIAid, RHIAnombre
	from RHInstitucionesA
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and RHIAid in (select RHIAid from RHCursos where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
	order by RHIAnombre
</cfquery>

<cfquery datasource="#session.dsn#" name="area">
	select RHACid, RHACdescripcion
	from RHAreasCapacitacion
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	order by RHACdescripcion
</cfquery>

<cfquery datasource="#session.dsn#" name="grupo">
	select RHGMid, Descripcion
	from RHGrupoMaterias
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	order by Descripcion
</cfquery>

<cf_templateheader title="#LB_RecursosHumanos#">
	<cf_web_portlet_start titulo="#LB_Asistencia#">
		<form name="filtro" method="get" action="">
			<table width="100%" border="0" cellpadding="2" class="areaFiltro"> 
				<tr>
					<td width="1%" nowrap="nowrap"><strong>Instituci&oacute;n:</strong></td>
					<td nowrap="nowrap"><strong>&Aacute;rea de Capacitaci&oacute;n:</strong></td>
					<td nowrap="nowrap"><strong>Grupo de Cursos:</strong></td>
					<td rowspan="4" align="center"><input type="submit" class="btnFiltrar" value="Buscar"></td>
				</tr>
				<tr>
					<td width="250" align="left">
						<select name="filtro_RHIAid" style="width:250px">
							<option value="">-Seleccione Instituci&oacute;n-</option>
							<cfoutput query="inst">
								<option value="#HTMLEditFormat(inst.RHIAid)#" <cfif ISDEFINED("url.filtro_RHIAid") and inst.RHIAid eq url.filtro_RHIAid>selected</cfif>>#HTMLEditFormat(inst.RHIAnombre)#</option>
							</cfoutput>
						</select>
					</td>
					<td align="left">
						<select name="filtro_RHACid" style="width:150px">
							<option value="">-todas-</option>
							<option value="null" <cfif ISDEFINED("url.filtro_RHACid") and url.filtro_RHACid eq 'null'>selected</cfif>>-sin clasificar-</option>
							<cfoutput query="area">
								<option value="#HTMLEditFormat(RHACid)#" <cfif ISDEFINED("url.filtro_RHACid") and url.filtro_RHACid is area.RHACid>selected</cfif>>#HTMLEditFormat(RHACdescripcion)#</option>
							</cfoutput>
						</select>
					</td>
					<td align="left">
						<select name="filtro_RHGMid" style="width:150px">
							<option value="">-todos-</option>
							<option value="null" <cfif ISDEFINED("url.filtro_RHGMid") and url.filtro_RHGMid eq 'null'>selected</cfif>>-sin clasificar-</option>
							<cfoutput query="grupo">
								<option value="#HTMLEditFormat(RHGMid)#" <cfif ISDEFINED("url.filtro_RHGMid") and url.filtro_RHGMid is grupo.RHGMid>selected</cfif>>#HTMLEditFormat(Descripcion)#</option>
							</cfoutput>
						</select>
					</td>
				</tr>
				<tr>
					<td width="1%" nowrap="nowrap"><strong>Nombre Curso:</strong></td>
					<td nowrap="nowrap"><strong>Fecha de Inicio:</strong></td>
					<td nowrap="nowrap"><strong>Fecha de Finalizaci&oacute;n:</strong></td>
				</tr>
				<tr>
					<td><input type="text" size="30" maxlength="100" id="filtro_Mnombre" name="filtro_Mnombre" value="<cfif isdefined('url.filtro_Mnombre') and len(trim(url.filtro_Mnombre))><cfoutput>#url.filtro_Mnombre#</cfoutput></cfif>"></td>
					<td><cfparam name="url.filtro_RHCfdesde" default=""><cf_sifcalendario form="filtro" name="filtro_RHCfdesde" value="#url.filtro_RHCfdesde#"></td>
					<td><cfparam name="url.filtro_RHCfhasta" default=""><cf_sifcalendario form="filtro" name="filtro_RHCfhasta" value="#url.filtro_RHCfhasta#"></td>
				</tr>
			</table>
		</form>		
		<cfset navegacion="">
		<cfinvoke component="rh.Componentes.pListas" method="pListaQuery" mostrar_filtro="no" >
			<cfinvokeargument name="query" value="#cursos#"/>
			<cfinvokeargument name="desplegar" value="RHIAnombre,Mnombre, RHCfdesde, RHCfhasta, RHCcupo,disponible"/>
			<cfinvokeargument name="etiquetas" value="Institucion,Curso,Inicia,Termina,Cupo,Disponible"/>
			<cfinvokeargument name="formatos" value="S, S, D, D, I, I"/>
			<cfinvokeargument name="align" value="left,left,center,center,right,right"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="irA" value="asistencia.cfm"/>
			<cfinvokeargument name="checkboxes" value="N">
			<cfinvokeargument name="keys" value="RHCid">
			<cfinvokeargument name="formName" value="listaCursos">
			<!---<cfinvokeargument name="cortes" value="RHIAnombre,RHACdescripcion">--->
			<cfinvokeargument name="showEmptyListMsg" value="true">
			<cfinvokeargument name="EmptyListMsg" value="*** NO SE HAN REGISTRADO CURSOS ***">
			<cfinvokeargument name="navegacion" value="#navegacion#">
		</cfinvoke>
<cf_templatefooter>