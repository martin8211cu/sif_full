<cfif Len(session.parche.svnuser) EQ 0>
	<cfset session.parche.msg = 'Debe conectarse a subversion para preparar el parche.'>
	<cflocation url="svnlogin.cfm?msg=1">
</cfif>
<cf_templateheader title="Creación de Parches">
<cfinclude template="mapa.cfm">
<h1>Seleccionar archivos</h1>
<p>
Indique los archivos que desea incluir dentro de su parche.<br />
Puede indicar más de un autor o ruta, separándolos por comas.<br />
En el <em>Nombre</em> puede especificar un nombre de archivo, o
bien una expresión regular para buscar varios archivos.
</p>
<cfinvoke component="asp.parches.comp.svnclient" method="get_info" wc="#session.parche.reposURL#" returnvariable="svninfo" />
<cfform height="300" width="700" id="form1" name="form1" method="post" action="svnbuscar-control.cfm" format="#session.parche.form_format#" timeout="60" >
<cf_web_portlet_start titulo="Introduzca el criterio de búsqueda para agregar archivos al parche" width="700">
<cfformgroup type="panel" label="Introduzca el criterio de búsqueda para agregar archivos al parche">
	<table>
	<tr><td><label for="reposURL">Repositorio de fuentes</label></td><td>
<cfinput label="Repositorio de fuentes" name="reposURL" type="text" id="wcdir" value="#session.parche.reposURL#" size="50"  readonly="yes"  />
	</td></tr>
	<tr><td><label for="svnBranch">Branch</label></td><td>
<cfformgroup type="horizontal" label="Branch">
<cfinput name="svnBranch" type="text" id="svnBranch" value="#session.parche.svnBranch#" size="10"  readonly="yes"   />
<label for="head">HEAD rev</label>
<cfinput label="HEAD rev." name="head" type="text" id="head" value="#svninfo.Revision#" size="10" readonly="true" />
</cfformgroup>
	</td></tr>
	<tr><td><label for="rev1">Fecha desde</label></td><td>
<cfif session.parche.form_format eq 'flash'>
<cfinput type="datefield" label="Fecha desde" name="rev1" value="#LSDateFormat(Now())#" width="120"  mask="dd/mm/yyyy" >
<cfelse>
<cf_sifcalendario name="rev1" value="#DateFormat(Now(),'dd/mm/yyyy')#">
</cfif>
	</td></tr>
	<tr><td><label for="autor">Filtrar autor(es)</label></td><td>
<cfinput label="Filtrar autor(es)" name="autor" type="text" value="#session.parche.svnuser#" size="50"   />
	</td></tr>
	<tr><td><label for="ruta">Ruta (prefijos)</label></td><td>
<cfinput label="Ruta (prefijos)" name="ruta" type="text" value="/" size="50"   />
	</td></tr>
	<tr><td><label for="rutarex">Nombre (reg.exp.)</label></td><td>
<cfinput label="Nombre (reg.exp.)" name="rutarex" type="text" value="" size="50"   />
	</td></tr>
	<!---
	<tr><td>&nbsp;</td><td>
<cfinput label="Mostrar un máximo de 100 archivos" name="checkbox" type="checkbox" id="limitar" value="checkbox" checked="true" disabled="yes" />
<label for="limitar">Mostrar un máximo de 100 archivos</label>
	</td></tr>--->
	<tr><td colspan="2">
<cfinput type="submit" name="Submit" value="Buscar" class="btnSiguiente" />
	</td></tr>
</table></cfformgroup><cf_web_portlet_end></cfform>
<cf_templatefooter>
