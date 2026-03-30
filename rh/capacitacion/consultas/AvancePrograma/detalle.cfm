<cfparam name="url.DEid">
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
	<cfset Session.Params.ModoDespliegue = 1>
	<cfinclude template="../../../expediente/consultas/consultas-frame-header.cfm">

<cfquery datasource="#session.dsn#" name="datos" >
	select coalesce(ltrim(rtrim(pu.RHPcodigoext)),ltrim(rtrim(pu.RHPcodigo))) as RHPcodigo, pu.RHPdescpuesto, cf.CFcodigo, cf.CFdescripcion, cf.CFid as CFident, de.DEidentificacion,
		de.DEnombre, de.DEapellido1, de.DEapellido2, de.DEid, gm.RHGMid, gm.RHGMcodigo, gm.Descripcion as RHGMdescripcion
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
		join CFuncional cf
			on cf.CFid = p.CFid
		left join RHGrupoMaterias gm
			on gm.RHGMid = pu.RHGMid
	where de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and de.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
</cfquery>

<cfquery datasource="#session.dsn#" name="listado" >
	select 	m.Msiglas, 
			m.Mnombre, 
			case when exists (	select 1
								from RHEmpleadoCurso ec
								where ec.DEid =  <cfqueryparam cfsqltype="cf_sql_integer" value="#url.DEid#">
								  and ec.Mcodigo = mg.Mcodigo
								  and ec.RHEMestado in (10,15) <!--- 10=aprobado, 15=convalidado --->
							  ) then 1 else 0 end as cursada,
			(	select max(ec.RHEMnota) 
				from RHEmpleadoCurso ec
				where ec.DEid =  <cfqueryparam cfsqltype="cf_sql_integer" value="#url.DEid#">
				  and ec.Mcodigo = mg.Mcodigo
				  and ec.RHEMestado in (10,15) <!--- 10=aprobado, 15=convalidado --->
			) as nota
				
	from RHMateriasGrupo mg

	join RHMateria m
	on m.Mcodigo = mg.Mcodigo

	where mg.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and mg.RHGMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos.RHGMid#" null="#Len(datos.RHGMid) IS 0#">

	order by m.Msiglas, m.Mnombre
</cfquery>

<cfquery  dbtype="query" name="resumen">
	select count(1) as requeridas, sum(cursada) as cursadas
	from listado
</cfquery>



<cfoutput query="datos">
<table width="99%"  border="0" cellpadding="2" cellspacing="0">
  <tr align="center">
    <td colspan="3" class="tituloListas" align="center" style="text-align:center;font-size:18px;background-color:##999999">#HTMLEditFormat(session.Enombre)#</td>
  </tr>
  <tr align="center">
    <td colspan="3" class="tituloListas" align="center" style="text-align:center;font-size:14px;background-color:##999999">Detalle del avance del programa de capacitaci&oacute;n</td>
  </tr>

  <tr>
    <td width="12%" rowspan="15" valign="top" nowrap class="fileLabel" align="center">
		<cf_sifleerimagen autosize="false" border="false" tabla="RHImagenEmpleado" campo="foto" condicion="DEid = #rsEmpleado.DEid#" conexion="#Session.DSN#" 
		width="75" > </td>
    <td width="12%" nowrap class="fileLabel"><cf_translate key="NombreExp">Nombre Completo</cf_translate></td>
    <td width="36%"><b><font size="3">#rsEmpleado.DEnombre# #rsEmpleado.DEapellido1# #rsEmpleado.DEapellido2#</font></b></td>
  </tr>
  <tr>
    <td class="fileLabel" nowrap><cf_translate key="CedulaExp">#rsEmpleado.NTIdescripcion#</cf_translate></td>
    <td>#rsEmpleado.DEidentificacion#</td>
  </tr>
  <tr>
    <td class="fileLabel" nowrap><cf_translate key="SexExp">Sexo</cf_translate></td>
    <td>#rsEmpleado.Sexo#</td>
  </tr>
  <tr>
    <td class="fileLabel" nowrap><cf_translate key="EstadoCivilExp">Estado Civil</cf_translate></td>
    <td>#rsEmpleado.EstadoCivil#</td>
  </tr>
  <tr>
    <td class="fileLabel" nowrap><cf_translate key="FecNacExp">Fecha de Nacimiento</cf_translate></td>
    <td><cf_locale name="date" value="#rsEmpleado.FechaNacimiento#"/></td>
  </tr>
  <tr>
    <td class="fileLabel" nowrap><cf_translate key="DireccionExp">Direcci&oacute;n</cf_translate></td>
    <td>#rsEmpleado.DEdireccion#</td>
  </tr>
  <tr>
    <td class="fileLabel" nowrap><cf_translate key="NDependietesExp">No. de Dependientes</cf_translate></td>
    <td>#rsEmpleado.DEcantdep#</td>
  </tr>
  <tr>
    <td class="fileLabel" nowrap><cf_translate key="BancoExp">Banco</cf_translate></td>
    <td>#rsEmpleado.Bdescripcion#</td>
  </tr>
  <tr>
    <td class="fileLabel" nowrap><cf_translate key="CuentaCExp">Cuenta Cliente</cf_translate>:</td>
    <td>#rsEmpleado.CBcc# (#rsEmpleado.Mnombre#)</td>
  </tr>
  <tr>
    <td class="fileLabel" >Centro Funcional</td>
    <td>#HTMLEditFormat(CFcodigo)# - #HTMLEditFormat(CFdescripcion)#</td>
  </tr>
  <tr>
    <td class="fileLabel" >Puesto</td>
    <td>#HTMLEditFormat(RHPcodigo)# - #HTMLEditFormat(RHPdescpuesto)# </td>
  </tr>
  <tr>
    <td class="fileLabel" >Programa de Capacitaci&oacute;n</td>
    <td><cfif Len(RHGMcodigo) OR Len(RHGMdescripcion)>
      #HTMLEditFormat(RHGMcodigo)# - #HTMLEditFormat(RHGMdescripcion)#
          <cfelse>
      No tiene
    </cfif></td>
  </tr>
  <tr>
    <td class="fileLabel" >Cursos aprobados / requeridos</td>
    <td>#NumberFormat(resumen.cursadas,'0')# / #NumberFormat(resumen.requeridas,'0')# 
	<cfif Len(resumen.requeridas) and Len(resumen.cursadas) and resumen.requeridas GT 0 and resumen.cursadas GT 0>
        ( #NumberFormat(resumen.cursadas*100/resumen.requeridas,'0')# % )
      </cfif>
  </td>
    </tr>
</table>

</cfoutput>

<cfif Len(datos.RHGMcodigo)>

<table width="600"  border="0" align="center" cellpadding="4" cellspacing="0">
  <tr>
    <td colspan="4" class="tituloListas" align="center"><strong>Cursos requeridos por el Programa de Capacitaci&oacute;n</strong></td>
  </tr>
  <tr>
    <td width="89" class="tituloListas">Siglas</td>
    <td width="368" class="tituloListas">Nombre</td>
    <td width="119"  class="tituloListas" align="center">Cursado</td>
    <td width="119"  class="tituloListas" align="center">Nota</td>
  </tr>
  <cfif listado.RecordCount>
  <cfoutput query="listado">
  <cfif CurrentRow mod 2><cfset theClass = "listaPar">
	  <cfelse><cfset theClass = "listaNon"></cfif>
  <tr class="#theClass#" style="cursor:default " onmouseover="this.className='#theClass#Sel';" onmouseout="this.className='#theClass#';">
    <td>#HTMLEditFormat(Msiglas)#</td>
    <td>#HTMLEditFormat(Mnombre)#</td>
    <td align="center"><cfif (cursada)>S&iacute;<cfelse></cfif></td>
    <td align="center"><cfif len(trim(nota))>#nota#<cfelse></cfif></td>	
  </tr></cfoutput> 
  <cfelse>
  <tr><td colspan="4">Este programa de capacitaci&oacute;n no est&aacute; definido.  (No tiene cursos asignados)</td></tr>
  </cfif>
</table></cfif>

<center class="noprint"><form action="javascript:history.back()" method="get" name="formback"><input type="submit" value="Regresar"></form></center>



	<cf_web_portlet_end>
<cf_templatefooter>