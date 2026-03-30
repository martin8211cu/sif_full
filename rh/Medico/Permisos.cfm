<!--- <cfinvoke component="rh.Componentes.AgendaMedica" method="AgendaMedica" returnvariable="CodigoAgendaMedica">
	<cfinvokeargument name="create" value="yes">
</cfinvoke> --->

<cf_template>
<cf_templatearea name="body">

<cf_web_portlet_start titulo="Agenda M&eacute;dica - Opciones">
<cfinclude template="/home/menu/pNavegacion.cfm">

  <div class="tituloListas">Usuarios autorizados para utilizar esta agenda </div>
	<cfparam name="url.modif" default="0">
	<cfif url.modif is '1'><br><strong style="color:#996600">Permisos actualizados exitosamente.</strong><br><br></cfif>
<cfinvoke 
	 component="rh.Componentes.pListas"
	 method="pListaRH">
		<cfinvokeargument name="tabla" value="Usuario u, DatosPersonales dp, ORGPermisosAgenda pa"/>
		<cfinvokeargument name="columnas" value="distinct u.Usucodigo, dp.Pnombre , dp.Papellido1 , dp.Papellido2,
			case when u.Usucodigo = #session.Usucodigo# then 0 else 1 end as soyyo,
			case when pa.propietario= 1 then 'S' else 'N' end propietario,
			case when pa.lectura    = 1 then 'S' else 'N' end lectura,
			case when pa.escritura  = 1 then 'S' else 'N' end escritura,
			case when pa.citar      = 1 then 'S' else 'N' end citar"/>
		<cfinvokeargument name="desplegar" value="Pnombre,Papellido1,Papellido2,propietario,lectura,escritura,citar"/>
		<cfinvokeargument name="etiquetas" value="Nombre,Apellidos,&nbsp;,Propietario,Lectura,Escritura,Citar "/>
		<cfinvokeargument name="formatos" value=""/>
		<cfinvokeargument name="formName" value="lista"/>
		<cfinvokeargument name="filtro" value=" dp.datos_personales = u.datos_personales
			  and u.CEcodigo = #session.CEcodigo#
			  and u.Utemporal = 0
			  and u.Usucodigo = pa.Usucodigo 
			  and pa.agenda = #url.ag#
			  and (pa.propietario = 1 or pa.lectura = 1 or pa.escritura = 1 or pa.citar = 1)
			order by soyyo, propietario desc, Pnombre, Papellido1, Papellido2"/>
		<cfinvokeargument name="align" value="left,left,left,left,left,left,left"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="checkboxes" value="N"/>
		<cfinvokeargument name="maxRows" value="0"/>
		<cfinvokeargument name="botones" value=""/>
		<cfinvokeargument name="irA" value="DarPermiso.cfm?ag=#url.ag#"/>
		<cfinvokeargument name="conexion" value="asp"/>
	</cfinvoke>  
  
<br>

<table>
    <tr>
      <td>&nbsp;</td>
      <td>
	  <cf_boton texto="&nbsp;&nbsp;&lt;&lt;&nbsp;Regresar&nbsp;&nbsp;" index="1" 
					estilo="2" link="Consultorio.cfm">
	  
      <td> <cf_boton texto="&nbsp;&nbsp;Nuevo&nbsp;Permiso...&nbsp;&nbsp;" index="2" 
					estilo="2" link="NuevoPermiso.cfm?ag=#url.ag#"> </td>
    </tr></table>
  
<br>
<br>
<cf_web_portlet_end>

</cf_templatearea>
</cf_template>