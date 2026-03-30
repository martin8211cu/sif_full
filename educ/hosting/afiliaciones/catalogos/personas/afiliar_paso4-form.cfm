<cfparam name="url.id_persona" type="numeric">
<cfparam name="url.id_programa" type="numeric">
<cfparam name="url.id_vigencia" type="numeric">

<cfquery datasource="#session.dsn#" name="data">
	select *
	from sa_personas
	where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_persona#" null="#Len(url.id_persona) Is 0#">
</cfquery>


<cfquery datasource="#session.dsn#" name="progs">
	select 
		p.id_programa, p.nombre_programa,
		v.id_vigencia, v.nombre_vigencia, v.costo, v.periodicidad, v.tipo_periodo,
		a.fecha_desde, a.fecha_hasta, v.cantidad_carnes, v.generar_carnes
	from sa_programas p
		join sa_vigencia v
			on p.id_programa = v.id_programa
		left join sa_afiliaciones a
			on  a.id_programa = p.id_programa
			and a.id_programa = v.id_programa
			and a.id_vigencia = v.id_vigencia
	where p.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	  and p.id_programa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_programa#">
	  and a.id_programa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_programa#">
	  and v.id_programa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_programa#">
	  and a.id_vigencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_vigencia#">
	  and v.id_vigencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_vigencia#">
	  and a.id_persona  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_persona#">
</cfquery>

<cfquery datasource="#session.dsn#" name="sa_entrada">
	select *
	from sa_entrada
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	  and id_programa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_programa#">
	  and id_persona  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_persona#">
	  and id_vigencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_vigencia#">
</cfquery>

<cfoutput>
	
	<script type="text/javascript">
	<!--
		function funcRegresar(){
			location.href='sa_personas.cfm?id_persona=#JSStringFormat(URLEncodedFormat(url.id_persona))#';
		}
	//-->
	</script>
	<!---
	<style type="text/css" media="screen, print">
      @font-face {
        font-family: "IDAutomationHC39M_FREE";
        src: url("http://websdc/cfmx/hosting/afiliaciones/font/IDAutomationHC39M_FREE.pfm");
      }
      .barcode { font-family: "IDAutomationHC39M_FREE", serif }
    </style>
	--->
	
	<cfif isdefined("url.back_prog") and url.back_prog is 1>
		<cfset form_action = '../programas/afiliados.cfm'>
	<cfelse>
		<cfset form_action = 'sa_personas.cfm'>
	</cfif>
	
	<form action="#form_action#" onsubmit="return validar(this);" method="get" name="form1" id="form1">
			<table width="559" cellpadding="2" cellspacing="2" summary="Tabla de entrada">
			<tr>
			  <td colspan="5" class="subTitulo">
			Afiliar a un Programa </td>
			  </tr>
				<tr><td width="115" valign="top">Nombre
				</td>
				  <td colspan="4" valign="top">#HTMLEditFormat(data.Pnombre)# #HTMLEditFormat(data.Papellido1)# #HTMLEditFormat(data.Papellido2)#</td>
			    </tr>
				<tr>
				  <td valign="top">Correo Electr&oacute;nico </td>
				  <td colspan="4" valign="top">#HTMLEditFormat(data.Pemail1)#                  </td>
			  </tr>
				<tr><td valign="top">C&eacute;dula</td>
				  <td colspan="4" valign="top">#HTMLEditFormat(data.Pid)#</td>
			    </tr>
				<tr>
				  <td align="left" nowrap>Programa</td>
				  <td colspan="4" valign="top">#progs.nombre_programa# #progs.nombre_vigencia#</td>
			  </tr>
				<tr>
				  <td align="left" nowrap>Periodo</td>
				  <td colspan="4" valign="top">#DateFormat(progs.fecha_desde,'dd/mm/yyyy')# - #DateFormat(progs.fecha_hasta,'dd/mm/yyyy')#</td>
			  </tr>
				<tr>
				  <td align="left" nowrap>Costo</td>
				  <td colspan="4" valign="top">#NumberFormat(progs.costo,',0.00')#                      <cfif progs.tipo_periodo is 'U'>
    Pago &Uacute;nico
    <cfelseif progs.tipo_periodo is 'S'>
    <cfif progs.periodicidad is 1>
      Cada Semana
        <cfelse>
      Cada #progs.periodicidad# Semanas
    </cfif>
    <cfelseif progs.tipo_periodo is 'S'>
    <cfif progs.periodicidad is 1>
      Cada Mes
        <cfelse>
      Cada #progs.periodicidad# Meses
    </cfif>
</cfif>				  </td>
</tr>
                <tr>
                  <td align="left">Carn&eacute;s / Entradas </td>
                  <td colspan="4" align="left">
				  <cfif progs.generar_carnes>
				  #progs.cantidad_carnes#
				  <cfelse>No se utilizan
				  </cfif></td>
                </tr><cfif progs.generar_carnes and progs.cantidad_carnes><tr>
			  <td colspan="5" class="subTitulo">
			Carn&eacute;s asignados </td>
			  </tr>
                <tr>
                  <td align="left">&nbsp;</td>
                  <td width="77" align="left">Fila</td>
                  <td width="86" align="left">Asiento</td>
                  <td colspan="2" align="left">N&uacute;mero</td>
                </tr>
				
				<cfloop query="sa_entrada">
                <tr>
                  <td align="left">&nbsp; </td>
                  <td align="left">#sa_entrada.fila#</td>
                  <td align="left">#sa_entrada.asiento#</td>
                  <td width="110" align="left"><img src="../../font/barcode-sample.gif" width="110" height="22" border="0"></td>
                  <td width="137" align="left">#sa_entrada.codigo_barras#</td>
                </tr></cfloop></cfif>
              <tr>
<td colspan="5" align="left">&nbsp;</td>
</tr>


<tr><td colspan="5" class="formButtons">
<input type="submit" name="btnTerminado" value="Terminado">
</td></tr>
</table>
<cfif isdefined("url.back_prog") and url.back_prog is 1>
	<input type="hidden" name="id_programa"  value="#HTMLEditFormat(url.id_programa)#">
	<input type="hidden" name="id_vigencia"  value="#HTMLEditFormat(url.id_vigencia)#">
<cfelse>
	<input type="hidden" name="id_persona"   value="#HTMLEditFormat(data.id_persona)#">
</cfif>
</form>
</cfoutput>	
