<cfif isdefined('form.DEid')and Len(Trim(form.DEid)) NEQ 0>
	<cfquery name="rsEncabEmpleado" datasource="#Session.DSN#">
		select {fn concat({fn concat({fn concat({fn concat(DEapellido1, ' ')}, DEapellido2)}, ', ')}, DEnombre)} as nombreEmpl, DEidentificacion, NTIdescripcion
		from DatosEmpleado de
		  inner join NTipoIdentificacion ti
		    on de.NTIcodigo=ti.NTIcodigo
		where DEid=<cfqueryparam  cfsqltype="cf_sql_integer"value="#form.DEid#">			 
	</cfquery>
</cfif>

<!--- Encabezado con los datos del Jugador --->
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
				<td colspan="2" align="center" class="#Session.Preferences.Skin#_thcenter"><cf_translate key="InformacionDelJugador" xmlfile="/rh/generales.xml">Informaci&oacute;n del Jugador</cf_translate></td>
			  </tr>
			  <tr> 
				<td width="33%" class="fileLabel"><cf_translate key="LB_Nombre_Completo" xmlfile="/rh/generales.xml">Nombre completo</cf_translate></td>
				<td width="67%">#rsEncabEmpleado.nombreEmpl#</td>
			  </tr>
			  <tr> 
				<td class="fileLabel">#rsEncabEmpleado.NTIdescripcion#</td>
				<td>#rsEncabEmpleado.DEidentificacion#</td>
			  </tr>
		  </table>		
		</td>
      </tr>
    </table>
  </cfoutput> 
</cfif>
