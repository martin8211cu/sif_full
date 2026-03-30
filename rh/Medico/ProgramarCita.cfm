<cfparam name="url.DEid">
<cfparam name="url.empresa">

<cfparam name="url.fecha" default="#DateFormat(Now(), 'DD/MM/YYYY')#">
<cfif REFind('^[0-9]{2}/[0-9]{2}/[0-9]{4}$', url.fecha) is 0>
	<cfset fecha = Now()>
<cfelse>
	<cfset fecha = LSParseDateTime(url.fecha)>
</cfif>
<cfinvoke component="rh.Componentes.AgendaMedica" method="AgendaMedica" returnvariable="CodigoAgendaMedica">
</cfinvoke>

<cfquery datasource="#session.dsn#" name="empleado">
	select de.DEidentificacion as cedula,  {fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )} as nombre,
		e.EcodigoSDC
	from DatosEmpleado de
		join Empresas e
			on de.Ecodigo = e.Ecodigo
	where de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.empresa#">
	  and de.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
</cfquery>

<cfif empleado.RecordCount is 0>
	<cf_errorCode	code="51914" msg="El empleado no existe">
</cfif>

<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec" />

<cfset emp_ref = sec.getUsuarioByRef(url.DEid, empleado.EcodigoSDC, 'DatosEmpleado' )>

<cfif emp_ref.RecordCount is 0>
	<cf_errorCode	code="51915" msg="El empleado @errorDat_1@/@errorDat_2@ no está relacionado como usuario"
					errorDat_1="#empleado.EcodigoSDC#"
					errorDat_2="#url.DEid#"
	>
</cfif>

<cfset ComponenteAgenda = CreateObject("Component", "home.Componentes.Agenda")>
<cfset CodigoAgenda = ComponenteAgenda.AgendaDeUsuario(emp_ref.Usucodigo)>
<cfset CitasParaHoy = ComponenteAgenda.ListarCitas(CodigoAgenda, fecha)>
	<cfquery datasource="asp" name="rsAgendaMedica">
		select escala
		from ORGAgenda
		where agenda = #url.agenda#
	</cfquery>
<cfset Disponible = ComponenteAgenda.TiempoLibre(url.agenda, fecha).Fragment(rsAgendaMedica.escala).getQuery()>
<cfset hoy = CreateDate(Year(Now()),Month(Now()),Day(Now()))>
<cfset horahoy = TimeFormat(Now(),'HHMM')>

<cfif fecha lt hoy>
  <cfquery dbtype="query" name="Disponible">
  select * from Disponible
  where 1 = 0
  </cfquery>
<cfelseif fecha is hoy>
  <cfquery dbtype="query" name="Disponible">
  select * from Disponible
  where inicio > #horahoy#
  </cfquery>
</cfif>


<cf_template>
<cf_templatearea name="body">


<cf_web_portlet_start titulo="Mi agenda">
<cfinclude template="/home/menu/pNavegacion.cfm">
<cfoutput>
  <div class="tituloListas">Programar nueva cita m&eacute;dica</div>
  <br></cfoutput>

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><form name="form1" method="post" action="ProgramarCitaSQL.cfm" >
	<table border="0">
      <tr>
        <td width="20">&nbsp;</td>
        <td colspan="5">Fecha: <strong><cfoutput>#LSDateFormat(fecha,'DD/MM/YYYY')#
		<input type="hidden" name="fecha" value="#LSDateFormat(fecha,'DD/MM/YYYY')#">
		<input type="hidden" name="DEid" value="#HTMLEditFormat(url.DEid)#">
		<input type="hidden" name="empresa" value="#HTMLEditFormat(url.empresa)#">
    <input type="hidden" name="agenda" value="#url.agenda#">
		
		</cfoutput></strong></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td colspan="5">Empleado: <cfoutput>#empleado.cedula# #empleado.nombre#</cfoutput></td>
        </tr>
      <tr>
        <td>&nbsp;</td>
        <td width="120">&nbsp;</td>
        <td width="20">&nbsp;</td>
        <td width="120">&nbsp;</td>
        <td width="20">&nbsp;</td>
        <td width="120">&nbsp;</td>
      </tr>
      <cfif Disponible.RecordCount>
        <tr>
          <td>&nbsp;</td>
          <td colspan="5">Seleccione un horario </td>
          </tr>
          <tr>
        <cfoutput query="Disponible">
            <td><input type="radio" name="cita" value="#inicio#,#final#"
				id="citanum#Disponible.CurrentRow#" <cfif Disponible.CurrentRow is 1>checked</cfif>></td>
            <td><label for="citanum#Disponible.CurrentRow#" style="cursor:pointer ">
			#REReplace(inicio,'([0-9]{1,2})([0-9]{2})', '\1:\2')#-#REReplace(final,'([0-9]{1,2})([0-9]{2})', '\1:\2')#</label></td>
			<cfif Disponible.CurrentRow Mod 3 is 0><cfset WriteOutput('</tr><tr>')></cfif>
        </cfoutput>
          </tr>
        <tr>
          <td>&nbsp;</td>
          <td colspan="5">&nbsp;</td>
          </tr>
        <tr>
          <td>&nbsp;</td>
          <td colspan="5">
		  <cf_boton texto="&nbsp;&nbsp;Continuar&nbsp;&gt;&gt;&nbsp;&nbsp;" index="1" 
					estilo="2" size="200" funcion="form1.submit();">

		  </td>
          </tr>
        <cfelse>
        <tr>
          <td>&nbsp;</td>
          <td colspan="5">No hay horario disponible para esta fecha</td>
          </tr>
        <tr>
          <td>&nbsp;</td>
          <td colspan="5">&nbsp;</td>
          </tr>
        <tr>
          <td>&nbsp;</td>
          <td colspan="5">
		  <cf_boton texto="&nbsp;&nbsp;&lt;&lt;&nbsp;Regresar&nbsp;&nbsp;" index="1" 
					estilo="2" size="200" funcion="history.go(-1);">
		</td>
          </tr>
      </cfif>
    </table>
</form></td>

    <td valign="top"><cf_calendario value="#fecha#" onChange="location.href='?DEid=#url.DEid#&empresa=#url.empresa#&fecha='+escape(dmy)" ></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>

<cf_web_portlet_end>

</cf_templatearea>
</cf_template>
