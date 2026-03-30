<cf_templateheader title="Creación de Parches">
<cfinclude template="mapa.cfm">
<h1>Parche generado</h1>
<cfoutput>

<cf_web_portlet_start titulo="Parche Generado" width="700">

<p>El parche y ha sido generado en el directorio:</p>
<ul><li>
	<a href="file:///#HTMLEditFormat( Replace( session.parche.destPath, '\', '/', 'all') )#" target="_blank">
#  HTMLEditFormat( session.parche.destPath ) # </a></li>
  <li>
    <a href="/cfmx/Mis%20Parches/#session.parche.info.nombre#" target="_blank">
      Ver en el navegador </a>
  </li>
  <li>
    <a href="/cfmx/Mis%20Parches/#session.parche.info.nombre#/#session.parche.info.nombre#.jar" target="_blank">
      Descargar archivo JAR</a>
  </li>
</ul>
<p>En este mismo directorio se ha creado el archivo JAR del parche. </p>
<p>Revise y si modifica el parche, vuelva a empacar el archivo JAR.</p>
<p>También puede modificar el parche aquí y volverlo a generar si es necesario. </p>
<br />
<cfinclude template="lista-errores.cfm"/>

<cf_web_portlet_end>
</cfoutput>
<cf_templatefooter>
