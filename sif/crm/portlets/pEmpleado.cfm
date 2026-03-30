<cfif isdefined('form.DEid')>
	<cfquery name="rsEncabEmpleado" datasource="#Session.DSN#">
		select (DEapellido1 + ' ' + DEapellido2 + ', ' + DEnombre) as nombreEmpl, DEidentificacion, NTIdescripcion
		from DatosEmpleado de, NTipoIdentificacion ti
		where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			and de.NTIcodigo=ti.NTIcodigo
	</cfquery>
</cfif>

<!--- Encabezado con los datos del empleado --->
<cfif isdefined('rsEncabEmpleado')>
  <cfoutput> 
    <table width="100%" border="0" cellspacing="6" cellpadding="6">
      <tr>
        <td width="6%" height="127" align="center" valign="top"> 
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
            	Imagen no Disponible 
			</cfif>
		</td>
		<td width="94%" valign="middle">
			<table width="100%" border="0" cellspacing="0" cellpadding="6" class="sectionTitle">
			  <tr> 
				<td colspan="2" align="center" class="tituloListas">Informaci&oacute;n del Empleado</td>
			  </tr>
			  <tr> 
				<td width="33%" class="fileLabel">Nombre completo</td>
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
