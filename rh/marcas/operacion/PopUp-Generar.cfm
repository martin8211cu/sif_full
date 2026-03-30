<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><cf_translate key="LB_RecursosHumanos" XmlFile="/rh/generales.xml">Recursos Humanos</cf_translate></title>
</head>
<body>
<cf_templatecss>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ParametrosparaAnalisisDeMarcasDeReloj"
	Default="Parámetros para análisis de marcas de reloj"	
	returnvariable="LB_ParametrosParaAnalisisDeMarcasDeReloj"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Generar"
	Default="Generar"	
	returnvariable="BTN_Generar"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Cerrar"
	Default="Cerrar"	
	returnvariable="BTN_Cerrar"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_FechaInicialMenorAHoy"
	Default="La fecha hasta no puede ser mayor al día de hoy"	
	returnvariable="MSG_FechaInicialMenorAHoy"/>		
	
<cfoutput>
		
	<cfquery name="rsGrupos" datasource="#session.DSN#">
		select  b.Gid, b.Gdescripcion
		from RHCMGrupos b					
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>	
	<cfset vs_fechaActual = LSDateFormat(now(),'dd/mm/yyyy')>
	<form name="form1" method="post" action="ProcesoGeneraMarcas.cfm" onSubmit="javascript: return funcValidaFecha();">
      <table width="100%" cellpadding="2" cellspacing="0">
        <tr>
          <td width="20%">&nbsp;</td>
        </tr>
        <tr>
          <td colspan="4" align="center"><strong style="color:##003366;font-family:'Times New Roman', Times, serif; font-size:12pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#LB_ParametrosParaAnalisisDeMarcasDeReloj#</strong></td>
        </tr>
        <tr>
          <td colspan="4" align="center"><table width="95%" align="center">
              <tr>
                <td><hr>
                </td>
              </tr>
          </table></td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td align="right" nowrap><strong><cf_translate key="LB_FechaHasta">Fecha hasta</cf_translate>:&nbsp;</strong></td>
          <td width="24%">
		  	<cf_sifcalendario  tabindex="1" form="form1" name="fechaFin" value="#LSDateFormat(now(),'dd/mm/yyyy')#"  onBlur="return funcValidaFecha()">
		  </td>
          <td width="9%" align="right"><strong><cf_translate key="LB_Grupo">Grupo</cf_translate>:&nbsp;</strong></td>
          <td width="47%">
			<select name="FGid" tabindex="2">
              <option value="">--- <cf_translate key="LB_Todos">Todos</cf_translate> ---</option>
              <cfloop query="rsGrupos">
                <option value="#rsGrupos.Gid#">#rsGrupos.Gdescripcion#</option>
              </cfloop>
            </select>
          </td>
        </tr>
        <tr>
          <td align="right"><strong><cf_translate key="LB_Empleado">Empleado</cf_translate>:&nbsp;</strong></td>
          <td colspan="3">
		  	<cf_rhempleado form="form1" size="30" tabindex="3" DEid="FDEid" DEidentificacion="FDEidentificacion" Nombre="FNombre"> 
		  </td>
        </tr>
        <tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
          <td colspan="4" align="center"><table width="23%" cellpadding="0" cellspacing="0">
              <tr>
                <td><input type="submit" name="btnGenerar" value="#BTN_Generar#" tabindex="4"></td>
				<td><input type="submit" name="btnCerrar" value="#BTN_Cerrar#" tabindex="5" onClick="javascript: window.opener.document.form1.action = ''; window.opener.document.form1.submit(); window.close();"></td>
              </tr>
          </table></td>
        </tr>
      </table>
	  <!----Campos de los filtros de la pantalla que llama el popUp---->
	  <input type="hidden" name="btnFiltrar" value="">
	  <input type="hidden" name="DEid" value="<cfif isdefined("url.DEid") and len(trim(url.DEid))>#url.DEid#</cfif>">
	  <input type="hidden" name="RHJid" value="<cfif isdefined("url.RHJid") and len(trim(url.RHJid))>#url.RHJid#</cfif>">
	  <input type="hidden" name="Grupo" value="<cfif isdefined("url.Grupo") and len(trim(url.Grupo))>#url.Grupo#</cfif>">
	  <input type="hidden" name="ver" value="<cfif isdefined("url.ver") and len(trim(url.ver))>#url.ver#</cfif>">
	  <input type="hidden" name="fechaInicio" value="<cfif isdefined("url.fechaInicio") and len(trim(url.fechaInicio))>#url.fechaInicio#</cfif>">
	  <input type="hidden" name="fechaFinal" value="<cfif isdefined("url.fechaFinal") and len(trim(url.fechaFinal))>#url.fechaFinal#</cfif>">
	</form>
	<script type="text/javascript" language="javascript1.2">
		function funcValidaFecha(){
			var inicio = document.form1.fechaFin.value.split('/');
				var fechainicio = inicio[2] + inicio[1] + inicio[0];
				var fechaactual = <cfoutput>'#vs_fechaActual#'</cfoutput>;
				var fechaactual = fechaactual.split('/');
				var fechaactual = fechaactual[2]+fechaactual[1]+fechaactual[0]
				if (fechainicio > fechaactual){
					<cfoutput>alert("#MSG_FechaInicialMenorAHoy#")</cfoutput>;
					document.form1.fechaFin.value = <cfoutput>'#vs_fechaActual#'</cfoutput>;
					return false;
				}			
				return true;
		}
	</script>
</cfoutput>
</body>
</html>