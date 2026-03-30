<cfinvoke key="LB_FuncionariosXSede" default="Reporte General de Funcionarios por Sede" returnvariable=	"LB_FuncionariosXSede"   component="sif.Componentes.Translate"  method="Translate"/>
  <cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>		
	<!---<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">		
	<cf_web_portlet_start titulo="#LB_FuncionariosXSede#">--->

	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">

<!---<cf_dump var="#url#">--->
<cfset form.Estado = 1>
<cfif isdefined('url.Estado')>	
	<cfset form.Estado = #url.Estado#>
</cfif>

<cf_dbfunction name="OP_concat" returnvariable="CAT" >

<cfquery name="rsOficinas" datasource="#session.DSN#">
	select  ofic.Ocodigo,ofic.Odescripcion 		
	from  DatosEmpleado datosEmpl,
	
		LineaTiempo LT
		
		INNER JOIN Oficinas ofic
			on ofic.Ocodigo = LT.Ocodigo 
			and ofic.Ecodigo = LT.Ecodigo
					
		
	where LT.Ecodigo = datosEmpl.Ecodigo
	and LT.DEid= datosEmpl.DEid
		
	and LT.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<cfif isdefined(#form.Estado#) and #url.Estado# EQ 1 >	
		and getdate() between LT.LTdesde and LT.LThasta	
	<cfelse>
		and  not ( getdate() between LT.LTdesde and LT.LThasta)
		and LT.LTid = (select max(LTid)
			from LineaTiempo segLT
			where segLT.Ecodigo = LT.Ecodigo
			and segLT.DEid = LT.DEid)	
	</cfif>
	group by ofic.Ocodigo,ofic.Odescripcion 
	order by ofic.Odescripcion ,ofic.Ocodigo		
</cfquery>

<cfquery name="rsReporte" datasource="#session.DSN#">
	select  ofic.Ocodigo,ofic.Odescripcion ,datosEmpl.DEidentificacion,
		 	datosEmpl.DEnombre #CAT# ' ' #CAT# datosEmpl.DEapellido1  #CAT#' '#CAT# 	   datosEmpl.DEapellido2 as nombre,
			CF.CFdescripcion as escuela
		
	from  DatosEmpleado datosEmpl,
	
		LineaTiempo LT
		
		INNER JOIN Oficinas ofic
			on ofic.Ocodigo = LT.Ocodigo 
			and ofic.Ecodigo = LT.Ecodigo
					
		INNER JOIN RHPlazas PLZ
			on PLZ.RHPid = LT.RHPid
			INNER JOIN CFuncional CF
				on CF.CFid = PLZ.CFid	
		
	where LT.Ecodigo = datosEmpl.Ecodigo
	and LT.DEid= datosEmpl.DEid
		
	and LT.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<cfif #form.Estado# EQ 1 >
		and getdate() between LT.LTdesde and LT.LThasta	
	<cfelse>
		and  not ( getdate() between LT.LTdesde and LT.LThasta)
		and LT.LTid = (select max(LTid)
			from LineaTiempo segLT
			where segLT.Ecodigo = LT.Ecodigo
			and segLT.DEid = LT.DEid)	
	</cfif>
	
	group by ofic.Odescripcion,ofic.Ocodigo ,datosEmpl.DEidentificacion, datosEmpl.DEnombre,datosEmpl.DEapellido1 ,datosEmpl.DEapellido2,
    CF.CFdescripcion

	<cfif isdefined ('url.OrderBy') and #url.OrderBy# EQ 1>
order by ofic.Odescripcion,ofic.Ocodigo,datosEmpl.DEnombre,datosEmpl.DEapellido1,datosEmpl.DEapellido2, datosEmpl.DEidentificacion,CF.CFdescripcion  
	<cfelse>
        order by ofic.Odescripcion, ofic.Ocodigo,CF.CFdescripcion , datosEmpl.DEnombre, datosEmpl.DEapellido1,datosEmpl.DEapellido2,datosEmpl.DEidentificacion
	</cfif>	
</cfquery>


<cfif rsReporte.recordcount GT 3000 and Url.formato neq 'HTML'>
	<br>
	<br>
	<cf_translate  key="LB_SeGeneroUnReporteMasGrandeDeLoPermitido">Se gener&oacute; un reporte más grande de lo permitido.  Proceso Cancelado!</cf_translate>
	<br>
	<br>
	<cfabort>
<cfelseif rsReporte.recordcount EQ 0>
	<br>
	<br>
	<cf_translate  key="LB_NoSeGeneroUnReporteSegunLosFiltrosDados">No se gener&oacute; un reporte seg&uacute;n los filtros dados. Intente de nuevo!</cf_translate>
	<br>
	<br>
	<cfabort>
<cfelseif rsReporte.recordcount NEQ 0>
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	
	 <cfsavecontent variable="Reporte">	
		<table width="95%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">		
		 <tr>	
			<td colspan="4" align="center">				 					
				<cf_EncReporte
				Titulo="#LB_FuncionariosXSede#" 
				Color="##E3EDEF" >		
			</td>		
			<cfoutput query="rsOficinas"> 
			</tr>					
				<tr> <td nowrap class="tituloListas" align="left"><cf_translate key="LB_Sede"> Sede: #Odescripcion#</cf_translate> </td> </tr>			             <tr>
			  	<td nowrap class="tituloListas" align="left"><cf_translate key="LB_Cedula">Cédula</cf_translate> :&nbsp;</td> 
			  	<td nowrap class="tituloListas" align="left"><cf_translate key="LB_Cedula">Nombre</cf_translate> :&nbsp;</td> 
			  	<td nowrap class="tituloListas" align="left"><cf_translate key="LB_Cedula">Escuela</cf_translate> :&nbsp;</td> 					
			  </tr>
		
			<cfquery name="rsFuncionariosxSede" dbtype="query">
				select *
				from rsReporte 		
				where Ocodigo = #Ocodigo#					
			</cfquery>
			
			<cfloop query="rsFuncionariosxSede"> 			  	 			
				<tr>  
				  <td nowrap align="left">#rsFuncionariosxSede.DEidentificacion#</td> 
				  <td nowrap align="left">#rsFuncionariosxSede.nombre#</td> 
				  <td nowrap align="left">#rsFuncionariosxSede.escuela#</td> 				 
				 </tr>
			</cfloop>	 	
			<tr><td>&nbsp;</td></tr>			  
			</cfoutput>				
		</table>	
	</cfsavecontent>
	<cfoutput>	    
	<cfset LvarFileName = "FuncionariosxSede#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
		<cf_htmlReportsHeaders 
			title="#LB_FuncionariosXSede#" 
			filename="#LvarFileName#"
			irA="funcionariosSede.cfm"
			back="no"
			back2="yes" 
			>	
		  <cf_templatecss>	
				  
		 #Reporte#
    </cfoutput>
 
</cfif>

<!---<cf_web_portlet_end>
<cf_templatefooter>	--->