<cf_templateheader title="Creación de Parches">
<cfinclude template="mapa.cfm">
<h1>Seleccionar tablas y procedimientos</h1>
<cfquery datasource="asp" name="APEsquema">
	select esquema, nombre, upper(nombre) as upper_nombre
	from APEsquema
	order by upper(nombre)
</cfquery>
<cfform height="300" width="700" id="form1" name="form1" method="post" action="objbuscar-control.cfm" format="#session.parche.form_format#" timeout="60" >
<cf_web_portlet_start width="700" titulo="Introduzca el criterio de búsqueda para agregar tablas y procedimientos al parche">
<cfformgroup type="panel" label="Introduzca el criterio de búsqueda para agregar tablas y procedimientos al parche">
	<table>
	<tr><td><label for="crdesde">Fecha de creación desde</label></td><td>
<cfif session.parche.form_format eq 'flash'>
<cfinput type="datefield" label="Fecha de creación desde" name="crdesde" value="#LSDateFormat(Now())#" width="120"  mask="dd/mm/yyyy" >
<cfelse>
<cf_sifcalendario name="crdesde" value="#DateFormat(Now(),'dd/mm/yyyy')#">
</cfif>
	</td></tr>
	<tr><td><label for="nombre">Filtrar nombre</label></td><td>
<cfinput label="Filtrar nombre" name="nombre" type="text" value="*" size="50"   />
	</td></tr>
	<tr><td><label for="esquema">Esquema</label></td><td>
	<cfselect name="esquema" label="Esquema" width="75"
		selected="#session.parche.info.pdir#" query="APEsquema" value="esquema" display="nombre" >
    </cfselect>
	</td></tr>
	<tr><td>&nbsp;</td><td>
<cfinput label="Mostrar un máximo de 100 tablas" name="checkbox" type="checkbox" id="limitar" value="checkbox" checked="true" disabled="yes" />
<label for="limitar">Mostrar un máximo de 100 tablas</label>
	</td></tr>
	<tr><td colspan="2">
<cfinput type="submit" name="Submit" value="Buscar" class="btnSiguiente" />
	</td></tr>
</table></cfformgroup><cf_web_portlet_end></cfform>
<cf_templatefooter>
