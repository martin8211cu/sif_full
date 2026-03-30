<cfif Not StructKeyExists(Server, 'migracion')>
	<cfset Server.migracion = StructNew()>
</cfif>
<cfparam name="Server.migracion" type="struct">
<cfparam name="Server.migracion.rc" default="-">
<cfparam name="Server.migracion.ced" default="-">
<cfparam name="Server.migracion.tasaerr" default="-">
<cfparam name="Server.migracion.elap" default="-">
<cfparam name="Server.migracion.errorcount" default="0">
<cfparam name="Server.migracion.procesados" default="0">
<cfparam name="Server.migracion.resta" default="-">
<cfparam name="Server.migracion.prom" default="-">
<cfparam name="Server.migracion.pct" default="0">
<html><head><title>Migración de cuentas de clientes</title>
<link href="migrar_cuentas.css" rel="stylesheet" type="text/css" />
</head><body>

<cftry>
	<cfquery datasource="#session.dsn#" name="bytype_q">
		select count(1) as cnt, min(msg) as msg, stack
		from migra_error
		group by stack
		order by cnt desc
	</cfquery>
<cfcatch type="any">
</cfcatch></cftry>

<cfoutput>
<table border="0" cellspacing="2" cellpadding="1" width="959" bgcolor="white" id="status_table" style="<cfif isDefined('url.sub')>display:none</cfif>">
  <tr>
    <td width="168" bgcolor="##CCCCCC">Avance</td>
    <td width="200" bgcolor="##CCCCCC"><div id="div_pctouter" style="width:200px;border:1px solid ##0000CC">
	<div id="div_pct" style="width:#Int(200*Server.migracion.pct)#px;background-color:##0000CC">&nbsp;</div>
	</div></td>
    <td width="577" rowspan="8" valign="top" bgcolor="##CCCCCC">
	<cfif IsDefined('bytype_q')>
		<strong>Resumen de errores por tipo</strong>
		<table>
		<cfloop query="bytype_q">
			<tr><td valign="top" align="right"><a href="migrar_cuentas_error.cfm?linea=# HTMLEditFormat( ListFirst ( stack, Chr(10)) ) #" target="myframe"># NumberFormat( cnt )#</a>
			</td><td valign="top" style="cursor:pointer" onclick="window.open('migrar_cuentas_error.cfm?linea=# HTMLEditFormat( ListFirst ( stack, Chr(10)) ) #', 'myframe')">#HTMLEditFormat( msg )#</td></tr>
		</cfloop>	
		</table>
	</cfif>
	</td>
  </tr>
  <tr>
    <td bgcolor="##CCCCCC">Cédulas procesadas</td>
    <td bgcolor="##CCCCCC">#HTMLEditFormat( Server.migracion.rc )#</td>
    </tr>
  <tr>
    <td bgcolor="##CCCCCC">Cédula</td>
    <td bgcolor="##CCCCCC">#HTMLEditFormat( Server.migracion.ced )#</td>
    </tr>
  <tr>
    <td bgcolor="##CCCCCC">Cédulas con error</td>
    <td bgcolor="##CCCCCC"># NumberFormat( Server.migracion.errorcount )# / # NumberFormat( Server.migracion.procesados)# (#HTMLEditFormat( Server.migracion.tasaerr )#)</td>
    </tr>
  <tr>
    <td bgcolor="##CCCCCC">Transcurrido</td>
    <td bgcolor="##CCCCCC">#HTMLEditFormat( Server.migracion.elap )#</td>
    </tr>
  <tr>
    <td bgcolor="##CCCCCC">Restante</td>
    <td bgcolor="##CCCCCC">#HTMLEditFormat( Server.migracion.resta )#</td>
    </tr>
  <tr>
    <td bgcolor="##CCCCCC">Duración promedio</td>
    <td bgcolor="##CCCCCC">#HTMLEditFormat( Server.migracion.prom )#</td>
    </tr>
</table>
</cfoutput>
<cfif isDefined('url.sub')>
	<script type="text/javascript">
		window.parent.document.getElementById('status_table').innerHTML =
			document.getElementById('status_table').innerHTML;
	</script>
<cfelse>
	<p>
	<a href="migrar_cuentas_prepare.cfm" target="myframe">Preparar</a> |
	<a href="migrar_cuentas_start.cfm" target="myframe">Ejecutar</a> |
	<a href="migrar_cuentas.cfm?sub" target="updateframe">Actualizar ahora</a> |
	<a href="javascript:actualizar()" id="onofflink">Actualización automática OFF</a> |
	<a href="migrar_cuentas_stop.cfm" target="myframe">Detener</a> |
	<a href="migrar_cuentas_error.cfm" target="myframe">Errores</a> |
	</p>
	<iframe src="about:blank" name="myframe" width="900" height="500" frameborder="0"></iframe>
	<iframe src="about:blank" name="updateframe" width="1" height="1" frameborder="0"></iframe>
	<p>&nbsp;</p>
	<script type="text/javascript">
		function actualizar(){
			if (document.onoff = !document.onoff) {
				document.getElementById('onofflink').innerHTML = 'Actualización automática ON';
				document.myint = window.setInterval('window.open("migrar_cuentas.cfm?sub","updateframe")', 2000);
			} else {
				document.getElementById('onofflink').innerHTML = 'Actualización automática OFF';
				window.clearInterval(document.myint);
			}
		}
	</script>
</cfif>
</body></html>
