<cfinvoke component="rh.Componentes.AgendaMedica" method="AgendaMedica" returnvariable="CodigoAgendaMedica">
	<cfinvokeargument name="create" value="yes">
</cfinvoke>
<cfparam name="url.b" default="">
<cfset url.b = Replace(url.b, "'", '')>

<cf_template>
<cf_templatearea name="body">

<cf_web_portlet_start titulo="Agenda M&eacute;dica - Opciones">
<cfinclude template="/home/menu/pNavegacion.cfm">

  <div class="tituloListas">Seleccione el usuario que desea autorizar </div>
  
  
  <form action="" method="get" name="form1" id="form1">
  Buscar: <cfoutput><input type="text" name="b" value="#url.b#" onFocus="this.select()">
  <input type="hidden" name="ag" value="#url.ag#"></cfoutput>

  <input type="submit" name="go" value="Buscar">

  </form><script type="text/javascript">form1.b.focus();</script>
	<cfinvoke 
	 component="rh.Componentes.pListas"
	 method="pListaRH">
		<cfinvokeargument name="tabla" value="Usuario u, DatosPersonales dp"/>
		<cfinvokeargument name="columnas" value="distinct u.Usucodigo, dp.Pnombre , dp.Papellido1 , dp.Papellido2"/>
		<cfinvokeargument name="desplegar" value="Pnombre,Papellido1,Papellido2"/>
		<cfinvokeargument name="etiquetas" value="Nombre,Apellidos, "/>
		<cfinvokeargument name="formatos" value=""/>
		<cfinvokeargument name="formName" value="lista"/>
		<cfinvokeargument name="filtro" value=" dp.datos_personales = u.datos_personales
			  and u.CEcodigo = #session.CEcodigo#
			  and u.Utemporal = 0
			  and (upper(dp.Pnombre)    like '%#UCase(url.b)#%'
				or upper(dp.Papellido1) like '%#UCase(url.b)#%'
				or upper(dp.Papellido2) like '%#UCase(url.b)#%')
			  and u.Usucodigo not in (
				select Usucodigo from ORGPermisosAgenda pa
				where pa.agenda = #url.ag#
				  and (pa.propietario = 1 or pa.lectura = 1 or pa.escritura = 1 or pa.citar = 1)
			  )
			order by Pnombre, Papellido1, Papellido2"/>
		<cfinvokeargument name="align" value="left,left,left"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="checkboxes" value="N"/>
		<cfinvokeargument name="maxRows" value="0"/>
		<cfinvokeargument name="botones" value=""/>
		<cfinvokeargument name="irA" value="DarPermiso.cfm?ag=#url.ag#"/>
		<cfinvokeargument name="conexion" value="asp"/>
	</cfinvoke>


<table>
    <tr>
      <td>&nbsp;</td>
      <td>
	  <cf_boton texto="&nbsp;&nbsp;&lt;&lt;&nbsp;Regresar&nbsp;&nbsp;" index="1" 
					estilo="2" funcion="location.href='Permisos.cfm?ag=#url.ag#';">
	  
      <td>&nbsp;   </td>
    </tr></table>
  
<br>
<br>
<cf_web_portlet_end></cf_templatearea></cf_template>