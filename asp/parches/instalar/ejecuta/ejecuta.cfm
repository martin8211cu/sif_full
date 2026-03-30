<cf_templateheader title="Ejecutar parche">
<cfinclude template="../mapa.cfm">
<cf_web_portlet_start titulo="Ejecutar parche">

	<cfquery datasource="asp" name="cantidad">
		select count(1) as cantidad
		from APTareas
		where instalacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.instala.instalacion#">
	</cfquery>

	<cfquery datasource="asp" name="corridas" maxrows="1">
		select num_tarea
		from APTareas
		where instalacion =<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.instala.instalacion#">
		  and (inicio is not null or fin is not null)
	</cfquery>

	<cfquery datasource="asp" name="siguiente">
		select num_tarea
		from APTareas
		where instalacion =<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.instala.instalacion#">
		  and (inicio is null or fin is null)
		order by num_tarea asc
	</cfquery>

	<cfparam name="url.num_tarea" default="#siguiente.num_tarea#">
	<cfparam name="url.verlog" default="S">
	<cfparam name="session.instala.verlog" default="#url.verlog#">
	<cfquery datasource="asp" name="seleccionada">
		select num_tarea,tipo,ruta,datasource,inicio,fin
		from APTareas
		where instalacion =<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.instala.instalacion#">
		  and num_tarea = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.num_tarea#" null="#Len(url.num_tarea) EQ 0#">
		order by num_tarea asc
	</cfquery>
	<cfset misc = CreateObject("component", "asp.parches.comp.misc")>
		<cfinvoke component="sif.Componentes.pListas" method="pLista"
			tabla='APTareas t'
			columnas="num_tarea,tipo,ruta,datasource,
				case when fin is not null then 'TERMINADA' when inicio is not null then 'INICIADA' else 'PENDIENTE' end as status,
				case (select coalesce ( max(severidad), -100) from APMensajes m where m.instalacion = t.instalacion and m.num_tarea = t.num_tarea)
					when -1 then '#misc.sev2sevname(-1)#'
					when 0 then '#misc.sev2sevname(0)#'
					when 1 then '#misc.sev2sevname(1)#'
					when 2 then '#misc.sev2sevname(2)#'
					when -100 then null
					else '-REVISAR-'
				end as max_sev"
			conexion="asp"
			filtro="instalacion = '#session.instala.instalacion#' "
			desplegar="num_tarea,tipo,ruta,datasource,status,max_sev"
			etiquetas="Num,Tipo,Ruta,Datasource,Estado,Severidad"
			formatos="S,S,S,S,S,S"
			align="center,center,left,left,left,left"
			irA="ejecuta.cfm"
			keys="num_tarea"
			form_method="get"
			formName="lista2"
			mostrar_filtro="yes"
			filtrar_automatico="yes"
		/>
<br />
<cfif Len(seleccionada.num_tarea)>
	<cf_web_portlet_start tipo="mini" width="400" >
	<form action="ejecuta-control.cfm" method="post">
		<cfoutput>
		<table width="300" border="0" cellspacing="0" cellpadding="2">
          <tr>
            <td width="1">&nbsp;</td>
            <td colspan="3" class="subTitulo">Tarea seleccionada </td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan="2">Número</td>
            <td>#seleccionada.num_tarea#</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan="2">Tipo</td>
            <td>#HTMLEditFormat(seleccionada.tipo)#, #HTMLEditFormat(seleccionada.datasource)#</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan="2">Ruta</td>
            <td>#HTMLEditFormat(seleccionada.ruta)#</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan="3" class="subTitulo">Mostrar bitácora al terminar </td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan="2" valign="top" align="right"><input name="verlog" id="verlog1" type="radio" value="S" <cfif session.instala.verlog IS 'S'>checked="checked"</cfif>/></td>
            <td valign="top"><label for="verlog1">Siempre</label></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan="2" valign="top" align="right"><input name="verlog" id="verlog0" type="radio" value="E" <cfif session.instala.verlog IS 'E'>checked="checked"</cfif> /></td>
            <td valign="top"><label for="verlog0">S&oacute;lo si hay errores o advertencias </label></td>
          </tr>
          
          <tr>
            <td>&nbsp;</td>
            <td colspan="2">&nbsp;</td>
            <td>&nbsp;</td>
          </tr><cfif url.num_tarea neq siguiente.num_tarea>
          <tr>
            <td>&nbsp;</td>
            <td colspan="3"><strong>Precaución:</strong> Esta tarea no es la siguiente.
                Debería <a href="ejecuta.cfm" style="text-decoration:underline">ejecutar la tarea No. #siguiente.num_tarea#</a> en su lugar.<br />                  </td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td width="40" valign="top"><input type="checkbox" name="force" value="1" id="force" /></td>
            <td colspan="2" valign="top"> 
                    <label for="force">Confirmo que deseo ejecutar las tareas en un orden
                      diferente al establecido en el parche, y acepto la responsabilidad
              por cualquier problema que de esto se derive</label>          </td>
            </tr>
          <tr>
            <td colspan="4" align="center">&nbsp;</td>
          </tr>  </cfif>
          <tr>
            <td colspan="4" align="center">
                <input type="hidden" name="num_tarea" value="# seleccionada.num_tarea #" />
                <input type="button" name="verlog" value="Ver Log" class="btnDetalle" onclick="location.href=&quot;ejecuta-resultado.cfm&quot;"/>
				<cfif url.num_tarea eq siguiente.num_tarea>
				 <input type="submit" name="omitir" value="Omitir" class="btnEliminar" onclick="return confirm('¿Desea omitir la tarea, y continuar con la siguiente?')"/>
				 </cfif>
                <input type="submit" name="preparar" value="Ejecutar" class="btnSiguiente"
				<cfif url.num_tarea neq siguiente.num_tarea>
				onclick="if (this.form.force.checked)return true; alert('Debe confirmar si desea ejecutar esta tarea\n en un orden diferente al establecido en el parche.'); return false;"
				</cfif>
				 />
				 </td>
          </tr>
          <tr>
            <td align="center">&nbsp;</td>
            <td align="center">&nbsp;</td>
            <td width="46" align="center">&nbsp;</td>
            <td align="center">&nbsp;</td>
          </tr>
        </table>
		</cfoutput>
	</form>
	<cf_web_portlet_end>
	<cfelse>
	<cf_web_portlet_start tipo="mini" width="400" >
	<form action="javascript:void(0)" method="post">
	<table width="300" border="0" cellspacing="0" cellpadding="2">
  <tr>
    <td>Ejecución terminada.  Pulse siguiente para continuar.</td>
  </tr>
  <tr>
    <td>

		<input type="button" name="verlog" value="Ver Log" class="btnDetalle" onclick="location.href=&quot;ejecuta-resultado.cfm&quot;"/>
		<input type="button" name="terminado" value="Continuar" class="btnSiguiente" onclick="location.href=&quot;../valida/contar2.cfm&quot;"/>
	</td>
  </tr>
</table>

	</form>
	<cf_web_portlet_end></cfif>

<cfif cantidad.cantidad EQ 0  Or corridas.RecordCount EQ 0>
	<form action="prepara-control.cfm" method="post" name="formPrep">
		Oprima el siguiente botón para restablecer las tareas por ejecutar.<br />
		<input type="submit" name="preparar" value="Preparar las tareas por ejecutar" />
	</form>
	<cfif cantidad.cantidad EQ 0>
		<script type="text/javascript">
			window.setTimeout( 'document.formPrep.submit()' , 500);
		</script>
	</cfif>
</cfif>
<cf_web_portlet_end>
<cf_templatefooter>
