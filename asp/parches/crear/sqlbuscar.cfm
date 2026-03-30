<cf_templateheader title="Creación de Parches">
<cfinclude template="mapa.cfm">

<h1>Seleccionar archivos SQL</h1>
<cfquery datasource="asp" name="APEsquema">
	select esquema, nombre, upper(nombre) as upper_nombre
	from APEsquema
	order by upper(nombre)
</cfquery>
<p>
	Suba los archivos que desee ejecutar en el servidor.</p>
<!---<p>El archivo <cfoutput>#session.parche.info.nombre#.sql</cfoutput> se generará automáticamente, con las instrucciones para el llenado de Control_Parches. No debe incluirlo en esta lista. </p>--->
<cfform height="300" width="700" id="form1" name="form1" method="post"
	 action="sqlbuscar-control.cfm" format="html" timeout="60" 
	 enctype="multipart/form-data" >
<cf_web_portlet_start width="700"
	titulo="Indique los nombre de los archivos SQL que desea incluir en el parche">
	<table>
	<tr><td>
		<label for="esquema">Esquema</label></td><td>
		<cfselect name="esquema" label="Esquema" width="75"
			selected="#session.parche.info.pdir#" query="APEsquema" value="esquema" display="nombre">
		</cfselect>
	</td></tr>
	<tr>
	  <td valign="top">
	  	<label for="descripcion">Descripci&oacute;n	  </label><br />
			Se incluirá en<br /> 
			la documentación<br />del parche.<br />
			Por favor sea claro<br />
			en su descripci&oacute;n.<br />
			<em>(m&aacute;x. 255 chars.)</em>
	  </td>
		<td valign="top">
		  <cftextarea name="descripcion" id="descripcion" cols="50" 
			rows="8" required="yes" maxlength="255" validate="maxlength,regex" 
			pattern="([^\s]+\s){4}"
			message="Debe describir el archivo SQL con al menos cinco palabras, para un máximo de 255 caracteres"></cftextarea></td>
		</tr>
	<tr><td colspan="2">
		<label for="ruta">Scripts de base de datos (dependiendo del tipo):</label>
	</td></tr>
	<cfset LvarTipos = "Sybase|syb,SQL Server|mss,Oracle|ora,DB2|db2">
	<cfloop list="#LvarTipos#" index="LvarTip">
		<cfset LvarTipo = listToArray(LvarTip,"|")>
		<tr>
			<cfoutput>
			<td align="right">&nbsp;&nbsp;#LvarTipo[1]#:&nbsp;</td>
			<td>
				<cfinput name="ruta_#LvarTipo[2]#" id="ruta_#LvarTipo[2]#" label="Nombre del archivo para #LvarTipo[1]#" size="50" 
					type="file" required="yes" 
					message="El nombre del archivo #LvarTipo[1]# es requerido. Asegúrese que el dialecto SQL sea correcto."
					pattern="\.[sS][qQ][lL]$" validate="regex" >
			</td>
			</cfoutput>
		</tr>
	</cfloop>
	<tr><td colspan="2">
		<input type="submit" name="Submit" value="Agregar" class="btnGuardar" />
	</td></tr>
</table>
<cf_web_portlet_end></cfform>


<cfif session.parche.cant_sql>
<cfinclude template="sqlconfirmar.cfm">
</cfif>

<cf_templatefooter>
