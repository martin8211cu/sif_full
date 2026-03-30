<cfparam name="url.fecha" default="">
<cfif REFind('^[0-9]{2}/[0-9]{2}/[0-9]{4}$', url.fecha) is 0>
	<cfset url.fecha = DateFormat(Now(), 'DD/MM/YYYY')>
</cfif>
<cfinvoke component="rh.Componentes.AgendaMedica" method="AgendaMedica" returnvariable="CodigoAgendaMedica">
	<cfinvokeargument name="create" value="no">
	<cfinvokeargument name="throw"  value="no">
</cfinvoke>
<cfif CodigoAgendaMedica neq 0>
	<cflocation url="Consultorio.cfm">
</cfif>

<cfset ComponenteAgenda = CreateObject("Component", "home.Componentes.Agenda")>

<cf_template>
<cf_templatearea name="body">

<cf_web_portlet_start titulo="Agenda M&eacute;dica">
<cfinclude template="/home/menu/pNavegacion.cfm">
<style type="text/css">
<!--
.ConfigInfo {font-size: 16px}
-->
</style>

<cfquery datasource="asp" name="Agendas">
	select *
	from ORGAgenda
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	  and tipo_agenda = 'R'
</cfquery>

<cfoutput>
  <div class="tituloListas">Consultas para el #url.fecha#</div>
  <table width="73%"  border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="7%" valign="top"></td>
      <td colspan="2" valign="top">&nbsp;</td>
    </tr>
    <tr>
      <td valign="top"></td>
      <td colspan="2" valign="top"><span class="ConfigInfo">
        Bienvenido a #session.Enombre#.<br>
        Como este es su primer ingreso a la agenda m&eacute;dica, hay que inicializar la agenda.</span></td>
    </tr>
    <tr>
      <td rowspan="3" valign="top"></td>
      <td width="4%" valign="top"><div class="ConfigInfo"><img src="arrow_rt.gif" width="12" height="17"></div></td>
      <td width="89%" valign="top"><span class="ConfigInfo">Nueva agenda </span></td>
    </tr>
    <tr>
      <td rowspan="2" valign="top">&nbsp;</td>
      <td valign="top">Si desea crear una agenda nueva para administrar las citas de esta empresa, haga clic en este bot&oacute;n para definir el horario de atenci&oacute;n de esta nueva agenda.</td>
    </tr>
    <tr>
      <td valign="top">        <cf_boton texto="&nbsp;&nbsp;Definir&nbsp;Agenda&nbsp;&gt;&gt;&nbsp;&nbsp;" index="2bis" 
					estilo="2" link="Configura-sql.cfm?new=yes">
</td> </tr>
<cfif Agendas.RecordCount>
    <tr>
      <td rowspan="3" valign="top"></td>
      <td valign="top"><span class="ConfigInfo"><img src="arrow_rt.gif" width="12" height="17"></span></td>
      <td valign="top"><div class="ConfigInfo">Deseo utilizar una de las agendas ya existentes:
		<form action="Configura-sql.cfm" method="get" style="margin:0 " name="form1" id="form1">
            <select name="agenda" id="usar_agenda">
			<cfloop query="Agendas">
              <option value="#agenda#">#HTMLEditFormat(nombre_agenda)#</option></cfloop>
            </select></form>
      </div></td>
    </tr>
    <tr>
      <td rowspan="2" valign="top">&nbsp;</td>
      <td valign="top">Si desea utilizar una de las agendas ya existentes, selecci&oacute;nela de la lista y oprima este bot&oacute;n para continuar trabajando con esta agenda. Se le solicitar&aacute; que confirme o modifique el horar de esta agenda, ya que podr&iacute;a necesitar ampliarlo para atender los empleados de esta empresa. </td>
    </tr>
    <tr>
      <td valign="top">
        <cf_boton texto="&nbsp;&nbsp;Usar&nbsp;Agenda&nbsp;&gt;&gt;&nbsp;&nbsp;" index="3bis" 
					estilo="2" funcion="form1.submit();"></td>
    </tr>
</cfif>
    <tr>
      <td valign="top"></td>
      <td colspan="2" valign="top">&nbsp;</td>
    </tr>
  </table>

</cfoutput>
<cf_web_portlet_end>

</cf_templatearea>
</cf_template>