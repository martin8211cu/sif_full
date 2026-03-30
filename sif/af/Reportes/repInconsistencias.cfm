<cfset Regresar = "/sif/af/MenuConsultasAF.cfm">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
			<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<cf_web_portlet_start titulo="#nav__SPdescripcion#">
				<cfoutput>#pNavegacion#</cfoutput>

<!---------incosistencia a mostrar----------------->
	<cfset inc_sele="placasRepetidas">
<cfif isdefined("form.TIncosistencias") and len(trim(form.TIncosistencias))> 
	<cfset inc_sele="#form.TIncosistencias#">
</cfif>		
		
<!---Activos con placas Repetidas---->
 <cfif inc_sele eq "placasRepetidas" >
 	<cfset titulo="Reporte de placas Repetidas">
	<cfset desplegar="Aplaca, Adescripcion, CActivos" >
	<cfset etiquetas="Placa, Descripcion, N de Activos" >
	<cfset formatos= "V, V, I" >
	<cfset align="left, left, left," >
	
	<cfset texto = "Mediante este reporte se pueden visualizar 
					un listado de todos aquellos activos que se 
					encuentran inconsistentes, debido a que en el 
					catalogo de Activos las placas se encuentran repetidas.">
					
	<cf_dbtemp name="Activos" returnvariable="Activos" datasource="#session.dsn#">
		<cf_dbtempcol name="Aid" type="integer" mandatory="no">
		<cf_dbtempcol name="Aplaca" type="char(20)" mandatory="no">
		<cf_dbtempcol name="CActivos" type="integer" mandatory="no">
	</cf_dbtemp>				
	<cfquery name="AFtemp" datasource="#session.DSN#">	
		insert into #Activos# 
		select Aid, Aplaca , count(1) 	from Activos  	 
			where Ecodigo= #session.Ecodigo# 		
			and Astatus= 0
			group by Aplaca
			having count(1) >1
	 </cfquery>			
	 <cfquery name="RepActivos" datasource="#session.DSN#">	
		select  b.Aplaca, b.Adescripcion, a.CActivos 
		 	from #Activos# a
				inner join Activos b
					on a.Aid = b.Aid
				
	</cfquery>	
<!---Activos con mas de un vale Vigente--->
 <cfelseif inc_sele eq "variosVales">
 	<cfset titulo="Reporte de Activos con mas de un vale vigente">
	<cfset desplegar="Aplaca, Adescripcion, CVales" >
	<cfset etiquetas="Placa, Descripcion, N de Vales" >
	<cfset formatos= "V, V, I" >
	<cfset align="left, left, left" >
	
	<cfset texto = "Mediante este reporte se pueden visualizar un listado de 
					todos aquellos activos que se encuentran inconsistentes,
					por motivo de que en control de Responsables,
					se tienen dos Responsables vigentes para un mismo Activo.">
<cf_dbtemp name="AFResponsables" returnvariable="AFResponsables" datasource="#session.dsn#">
	<cf_dbtempcol name="Ecodigo" type="integer" mandatory="no">
	<cf_dbtempcol name="Aid" type="integer" mandatory="no">
	<cf_dbtempcol name="CVales" type="integer" mandatory="no">
</cf_dbtemp>

<cfquery name="AFtemp" datasource="#session.DSN#">	
	insert into #AFResponsables#
		select  Ecodigo, Aid, count(1)
			from AFResponsables a
		where Ecodigo = #session.Ecodigo#
			and <cf_dbfunction name="now"> between a.AFRfini and a.AFRffin
		group by Ecodigo, Aid
		having count(1) > 1
</cfquery>

<cfquery name="RepActivos" datasource="#session.DSN#">	
		select b.Aid, b.Aplaca , b.Adescripcion, a.CVales
	from #AFResponsables#  a
		inner join Activos b
			on  a.Aid = b.Aid
		where b.Astatus = 0
</cfquery>		
	
<!---Activos que se encuentran en transito y vigentes a la vez---->
 <cfelseif inc_sele eq "activosTransito">
 	<cfset titulo= "Reporte de de placas Activas y en transito a la vez">
	<cfset desplegar="Aplaca, Adescripcion, CRDRdescripcion" >
	<cfset etiquetas="Placa, Descripcion(Catalogo), Descripcion(Transito)" >
	<cfset formatos= "V, V, V" >
	<cfset align="left, left, left" >
	<cfset texto = "Mediante este reporte se pueden visualizar un listado de 
					todos aquellos activos que se encuentran inconsistentes, 
					ya que encuentra como un  Activo en transito, pero la placa 
					asignada a este Activo, ya existe en el catalogo de Activos Fijos.">
					


 	<cfquery name="RepActivos" datasource="#session.DSN#">	
		select a.Aplaca, a.Adescripcion, c.CRDRdescripcion  
		 from Activos a
			inner join CRDocumentoResponsabilidad c
				on a.Aplaca = c.CRDRplaca
	</cfquery>	
 </cfif>
 
<cfquery name="AFvales" datasource="#session.DSN#">	
select top 10 Aplaca, Adescripcion from Activos
</cfquery>	
		<cfoutput>
		<table width="90%" align="center" border="0" cellspacing="0" cellpadding="0">
		 <tr><td height="30" colspan="2">&nbsp; </td></tr>
		   <tr>
			  <td width="48%" valign="top">
				<table width="95%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					 <td width="527">
							<cf_web_portlet_start border="true" titulo="#titulo#" skin="info1">
									<p align="justify">#texto#</p>
							<cf_web_portlet_end>
				    </td>
				  </tr>
			    </table>
			 </td>
				<td width="52%" valign="middle">
		<form name="incosistencias" method="post" action="repInconsistencias.cfm">
		  <select name="TIncosistencias" onChange="submit()">
			<option value="placasRepetidas" <cfif isdefined("inc_sele") and inc_sele eq "placasRepetidas">selected</cfif> >Placas Repetidas</option>
			<option value="variosVales" 	<cfif isdefined("inc_sele") and inc_sele eq "variosVales">selected</cfif> >Varios Vales</option>
			<option value="activosTransito" <cfif isdefined("inc_sele") and inc_sele eq "activosTransito">selected</cfif> >Activo y en Transito a la vez</option> 
		  </select>
		</form>
			</td>
		  </tr>	
		  <tr><td height="30" colspan="2">&nbsp; </td></tr>
			<tr>
			<td colspan="2">
			<cfinvoke 
				component="sif.Componentes.pListas"
					method="pListaQuery"
						returnvariable="pListaRet">
						<cfinvokeargument name="query" value="#RepActivos#"/>
						<cfinvokeargument name="desplegar" value="#desplegar#"/>
						<cfinvokeargument name="etiquetas" value="#etiquetas#"/>
						<cfinvokeargument name="formatos" value="#formatos#"/>	
						<cfinvokeargument name="align" value="#align#"/>	
						<cfinvokeargument name="irA" value="repInconsistencias_sql.cfm"/>	
						<cfinvokeargument name="mostrar_filtro" value="true"/>	
			</cfinvoke>
		</td></tr>
		</table>
		</cfoutput>
		<cf_web_portlet_end>
<cf_templatefooter>

