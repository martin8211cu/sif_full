<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

<cf_templateheader title="#LB_RecursosHumanos#">
    <cf_templatecss>
	<link href="../../../css/rh.css" rel="stylesheet" type="text/css">
	<cf_web_portlet_start border="true" titulo="Avance del Programa de Capacitaci&oacute;n" skin="#Session.Preferences.Skin#"> 
	<cfinclude template="/home/menu/pNavegacion.cfm">


<cfquery datasource="#session.dsn#" name="listado">
	select 	coalesce(ltrim(rtrim(pu.RHPcodigoext)),
			ltrim(rtrim(pu.RHPcodigo))) as RHPcodigo, 
			pu.RHPdescpuesto, 
			cf.CFcodigo, 
			cf.CFdescripcion, 
			cf.CFid as CFident, 
			de.DEidentificacion,
			de.DEnombre, 
			de.DEapellido1, 
			de.DEapellido2, 
			de.DEid, 
			gm.RHGMcodigo, 
			gm.Descripcion as RHGMdescripcion,
			coalesce(count(mg.RHGMid),0) as materias_requeridas,
			coalesce(count(RHECid),0)  as materias_cursadas 

	from DatosEmpleado de
		join LineaTiempo lt
			on lt.DEid = de.DEid
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between lt.LTdesde and lt.LThasta
		join RHPlazas p
			on p.Ecodigo = lt.Ecodigo
			and p.RHPid = lt.RHPid
		join RHPuestos pu
			on pu.Ecodigo = lt.Ecodigo
			and pu.RHPcodigo = lt.RHPcodigo
			<cfif Len(url.RHPcodigo)>
			  and pu.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.RHPcodigo#">
			</cfif>
		join CFuncional cf
			on cf.CFid = p.CFid
			<cfif Len(url.CFid)>
			  and cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
			</cfif>
		left join RHGrupoMaterias gm
			on gm.RHGMid = pu.RHGMid
		left join RHMateriasGrupo mg
			on mg.RHGMid = pu.RHGMid
		left join RHEmpleadoCurso ec 
			on ec.DEid = de.DEid 
			and ec.Mcodigo = mg.Mcodigo 
			and ec.RHEMestado in (10,15) 			
	where de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif Len(url.DEid)>
	  and de.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
	</cfif>
	group by coalesce(ltrim(rtrim(pu.RHPcodigoext)),ltrim(rtrim(pu.RHPcodigo))), pu.RHPdescpuesto, cf.CFcodigo, cf.CFdescripcion, cf.CFid, de.DEidentificacion,
		de.DEnombre, de.DEapellido1, de.DEapellido2, de.DEid, gm.RHGMcodigo, gm.Descripcion
</cfquery>
<table width="99%"  border="0" cellpadding="4" cellspacing="0">
  <cfoutput>
  <tr align="center">
    <td colspan="8" class="tituloListas" align="center" style="text-align:center;font-size:18px;background-color:##999999">#HTMLEditFormat(session.Enombre)#</td>
  </tr>
  <tr align="center">
    <td colspan="8" class="tituloListas" align="center" style="text-align:center;font-size:14px;background-color:##999999">Avance del programa de capacitaci&oacute;n</td>
  </tr>
  </cfoutput>
  
  <cfif listado.RecordCount>
  <cfoutput>
  <cfif Len(url.DEid) >
  <tr align="center" >
    <td colspan="8" class="tituloListas" align="center">Empleado: #HTMLEditFormat(listado.DEidentificacion)# - #HTMLEditFormat(listado.DEnombre)# #HTMLEditFormat(listado.DEapellido1)# #HTMLEditFormat(listado.DEapellido2)#</td>
  </tr></cfif>
  <cfif Len(url.CFid)>
  <tr align="center">
    <td colspan="8" class="tituloListas" align="center">Centro Funcional: #HTMLEditFormat(listado.CFcodigo)# - #HTMLEditFormat(listado.CFdescripcion)#</td>
  </tr></cfif>
  <cfif Len(url.RHPcodigo)>
  <tr align="center"  >
    <td colspan="8" class="tituloListas" align="center">Puesto: #HTMLEditFormat(listado.RHPcodigo)# - #HTMLEditFormat(listado.RHPdescpuesto)#</td>
  </tr>
  <tr>
    <td colspan="8" class="tituloListas" align="center">Programa de Capacitaci&oacute;n:
    <cfif Len(listado.RHGMcodigo) OR Len(listado.RHGMdescripcion)>
		  #HTMLEditFormat(listado.RHGMcodigo)# -  #HTMLEditFormat(listado.RHGMdescripcion)# 
	  	<cfelse>
			No tiene
	  </cfif></td>
    </tr>
</cfif></cfoutput> 

<cfoutput query="listado" group="RHPcodigo"> 
<cfif Len(url.RHPcodigo) EQ 0>
  <tr>
    <td colspan="8">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="3" class="tituloListas">Puesto</td>
    <td colspan="5" class="tituloListas">#HTMLEditFormat(RHPcodigo)# - #HTMLEditFormat(RHPdescpuesto)# </td>
    </tr>
  <tr>
    <td colspan="3" class="tituloListas">Programa de Capacitaci&oacute;n</td>
    <td colspan="5" class="tituloListas"><cfif Len(RHGMcodigo) OR Len(RHGMdescripcion)>
		  #HTMLEditFormat(RHGMcodigo)# -  #HTMLEditFormat(RHGMdescripcion)# 
	  	<cfelse>
			No tiene
	  </cfif></td>
    </tr></cfif>
  <cfoutput group="CFident">
  <cfif Len(url.CFid) EQ 0>
  <tr>
    <td width="30" class="tituloListas">&nbsp;</td>
    <td colspan="2" class="tituloListas">Centro Funcional</td>
    <td class="tituloListas">#HTMLEditFormat(CFcodigo)# -  #HTMLEditFormat(CFdescripcion)#</td>
    <td class="tituloListas" colspan="4">&nbsp;</td>
  </tr></cfif>
  <tr>
    <td>&nbsp;</td>
    <td width="30">&nbsp;</td>
    <td width="12%"><strong>C&eacute;dula</strong></td>
    <td width="36%"><strong>Nombre</strong></td>
    <td width="18%" align="right"><strong>Cursos requeridos </strong></td>
    <td width="17%" align="right"><strong>Cursos aprobados</strong></td>
    <td width="12%" align="right"><strong>Progreso (%) </strong></td>
    <td width="12%" align="right">&nbsp;</td>
  </tr>
  
  <cfset theRowCount = 0>
  <cfset total_materias_cursadas = 0>
  <cfset total_materias_requeridas = 0>
  <cfoutput>
	  <cfset theRowCount = theRowCount + 1>
	  <cfset total_materias_cursadas = total_materias_cursadas + materias_cursadas>
	  <cfset total_materias_requeridas = total_materias_requeridas + materias_requeridas>
  </cfoutput>
  
  <cfset theRow = 0>
  <cfoutput><cfset theRow = theRow + 1>
  <cfif theRow mod 2><cfset theClass = "listaPar">
	  <cfelse><cfset theClass = "listaNon"></cfif>
  <tr style="cursor:pointer;" onclick="location.href='detalle.cfm?DEid=#URLEncodedFormat(DEid)#'" 
  	class="#theClass#"
	onmouseover="this.className='#theClass#Sel';" onmouseout="this.className='#theClass#';">
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>#HTMLEditFormat(DEidentificacion)#</td>
    <td>#HTMLEditFormat(DEnombre)# #HTMLEditFormat(DEapellido1)# #HTMLEditFormat(DEapellido2)#</td>
    <td align="right">#NumberFormat(materias_requeridas,'0')#</td>
    <td align="right">#NumberFormat(materias_cursadas,'0')#</td>
    <td align="right"><cfif materias_requeridas>#NumberFormat(materias_cursadas*100/materias_requeridas,'0')#<cfelse>0</cfif> %</td>
	<cfif theRow EQ 1>
		<td align="center" rowspan="#theRowCount#" valign="top">  
			<cfif total_materias_requeridas or total_materias_cursadas>
		<cfchart chartwidth="250" format="png" chartheight="250" show3d="yes">
			<cfchartseries type="pie" colorlist="##339933,##993300" >
				<cfchartdata item="Progreso (#total_materias_cursadas#)" value="#total_materias_cursadas#">
				<cfchartdata item="Faltante (#total_materias_requeridas-total_materias_cursadas#)" value="#total_materias_requeridas-total_materias_cursadas#">
			</cfchartseries>
		</cfchart></cfif></td>
	</cfif>
  </tr></cfoutput></cfoutput> </cfoutput>
  
  <cfelse>
  <tr><td colspan="8"><strong>No se han encontrado datos para la consulta especificada</strong></td></tr>
  
  </cfif>
  <tr><td colspan="8" align="center" class="noprint"><form action="javascript:history.back()" method="get" name="formback"><input type="submit" value="Regresar"></form></td></tr>
</table>


	<cf_web_portlet_end>
<cf_templatefooter>