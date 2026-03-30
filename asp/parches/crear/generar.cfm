<cf_templateheader title="Creación de Parches">
<cfinclude template="mapa.cfm">
<cfif Len(session.parche.svnuser) EQ 0>
	<cfset session.parche.msg = 'Debe conectarse a subversion para generar el parche.'>
	<cflocation url="svnlogin.cfm?msg=1">
</cfif>
<h1>Generar y guardar parche </h1>
<cfinvoke component="asp.parches.comp.parche" method="dirparches" returnvariable="dirparches" ></cfinvoke>
<cfoutput>
<cf_web_portlet_start width="700" titulo="Revise los datos del parche que va a guardar">
	<table width="650">
	<tr><td>Secuencia y parche</td><td>
	# HTMLEditFormat(session.parche.info.pdir) #
	# HTMLEditFormat(session.parche.info.pnum) #
	# HTMLEditFormat(session.parche.info.psec) #
	# HTMLEditFormat(session.parche.info.psub) #
	</td></tr>
	<tr><td>Módulo(s) afectado(s)</td><td>
	# HTMLEditFormat(session.parche.info.modulo) #
	</td></tr>
	<tr><td>Nombre del parche</td><td>
	# HTMLEditFormat(session.parche.info.nombre) #
	</td></tr>
	<tr><td>Autor del parche</td><td>
	# HTMLEditFormat(session.parche.info.autor) #
	</td></tr>
	<tr><td>Directorio de parches</td><td>
	# HTMLEditFormat(dirparches) # 
	</td></tr>
	<tr><td>&nbsp;</td><td>
	Se deben regenerar las vistas después de instalar este parche: 
	# YesNoFormat( session.parche.info.vistas )#
	</td></tr>
	<tr><td colspan="2" align="right">
  <form style="margin:0" method="post" action="generar-control.cfm">
    <input name="generar" type="submit" id="generar" value="Generar" class="btnSiguiente" />
  </form>
	</td></tr></table>
	<cf_web_portlet_end>
</cfoutput>
<br />

<cf_web_portlet_start titulo="Información" tipo="light" width="700">
<table width="500" align="center"><tr><td>
<p>
El parche se va a crear usando los siguientes elementos, si aplican:
<ul><li>Archivos fuente</li>
<li>Instrucciones SQL</li>
<li>Definiciones del importador</li>
</ul>
Los siguientes elementos generan pero no se validan:
<ul>
<li>Tablas por validar</li>
</ul>
</p>
</td></tr></table>	<cf_web_portlet_end>
<cf_templatefooter>
