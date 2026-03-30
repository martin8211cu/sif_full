<cfif isdefined('form.DEid')and Len(Trim(form.DEid)) NEQ 0>
	<cfquery name="rsEncabEmpleado" datasource="#Session.DSN#">
		select {fn concat({fn concat({fn concat({fn concat(DEapellido1, ' ')}, DEapellido2)}, ', ')}, DEnombre)} as nombreEmpl, DEidentificacion, NTIdescripcion
		from DatosEmpleado de
		  inner join NTipoIdentificacion ti
		    on de.NTIcodigo=ti.NTIcodigo
		where DEid=<cfqueryparam  cfsqltype="cf_sql_integer"value="#form.DEid#">			 
	</cfquery>
</cfif>
<cfparam name="MostrarSelecionEmpleado" default="false">
<!--- Encabezado con los datos del empleado --->
<cfif isdefined('rsEncabEmpleado')>
  <cfoutput> 
    <table width="100%" border="0" cellspacing="6" cellpadding="6">
      <tr>
        <td width="6%" height="115" align="center" valign="top"> 
          <cfif isdefined('form.DEid')>
            	<cfoutput>
				<table border="1" cellspacing="0" cellpadding="0">
				  <tr> 
					<td>
					<cf_sifleerimagen autosize="false" border="false" tabla="RHImagenEmpleado" campo="foto" condicion="DEid = #form.DEid#" conexion="#Session.DSN#" width="75" height="100">
					</td>
				  </tr>
				</table>
				</cfoutput>
            <cfelse>
            	<cf_translate key="LB_Imagen_No_Disponible" xmlfile="/rh/generales.xml">Imagen no Disponible </cf_translate>
		  </cfif>
		</td>
		<td width="94%" valign="top">
			<table width="100%" height="100%" border="0" cellpadding="6" cellspacing="0" class="sectionTitle">
              <tr> 
				<td colspan="2" align="center" class="#Session.Preferences.Skin#_thcenter"><cf_translate key="InformacionDelEmpleado" xmlfile="/rh/generales.xml">Informaci&oacute;n del Empleado</cf_translate></td>
			  </tr>
              <cfif MostrarSelecionEmpleado>
                  <tr> 
                    <td colspan="2" align="right" class="fileLabel">
                        <label id="letiqueta1">
                            <a href="javascript: if(window.ElegirEmpleado)ElegirEmpleado();else regresar();"><cf_translate key="LB_Seleccione_un_Empleado">Seleccione un empleado</cf_translate></a>
                        </label>
                        <a href="javascript: if(window.ElegirEmpleado)ElegirEmpleado();else regresar();"><img src="/cfmx/rh/imagenes/iindex.gif" name="imageBusca" border="0" id="imageBusca"></a>
                    </td>
                  </tr>
              </cfif>
			  <tr> 
				<td width="33%" class="fileLabel"><cf_translate key="LB_Nombre_Completo" xmlfile="/rh/generales.xml"><strong>Nombre completo:</strong></cf_translate></td>
				<td width="67%">#rsEncabEmpleado.nombreEmpl#</td>
			  </tr>
			  <tr> 
				<td class="fileLabel"><strong>#rsEncabEmpleado.NTIdescripcion#:</strong></td>
				<td>#rsEncabEmpleado.DEidentificacion#</td>
			  </tr>
		  </table>		
		</td>
      </tr>
    </table>
  </cfoutput> 
</cfif>
<script language="javascript" type="text/javascript">
	function regresar(){history.back(1);}
</script>
