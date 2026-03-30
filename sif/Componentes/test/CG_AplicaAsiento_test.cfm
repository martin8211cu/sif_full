<html><body>
<h1>Contabilidad General</h1><h2>CG_AplicaAsiento</h2>
<a href="index.cfm">&lt;- index</a> | <a href="CG_GeneraAsiento_test.cfm">GeneraAsiento</a><br>

<ul>
<li><a href="?action=asiento_10k">Crear / incrementar asiento</a></li>
<li><a href="?action=postea">Postear asiento</a></li>
<li><a href="?action=copiar">Copiar asiento posteado</a></li>
<li><a href="?action=nada">Ver asiento</a></li></ul>

<cfset session.dsn = 'minisif'>
<cfset session.Ecodigo = 1>
<cfset hora_de_inicio = Now()>
<cfoutput>inicio: #hora_de_inicio# - #NumberFormat(hora_de_inicio.getTime())#<br></cfoutput>
<cffunction name="dump_asiento">
	<cfquery datasource="#session.dsn#" name="enc">
	select e.IDcontable, e.Cconcepto, e.Edocumento, e.Edescripcion,
		count(1) as lineas,
		sum (case when Dmovimiento = 'D' then Dlocal else 0 end) as DEB,
		sum (case when Dmovimiento = 'C' then Dlocal else 0 end) as CRE
	from EContables e 
		left outer join DContables d on e.IDcontable = d.IDcontable
	where e.Edescripcion like 'Asiento de prueba %'
	  and e.Emes = 2
	group by e.IDcontable, e.Cconcepto, e.Edocumento, e.Edescripcion
	</cfquery>
	<cfdump var="#enc#" label="Asientos de Prueba">
</cffunction>

<cfset dump_asiento()>

<cfparam name="url.action" default="">
<cfif url.action is 'asiento_10k'>
	<cfinclude template="CG_AplicaAsiento_asiento_10k.cfm">
<cfelseif url.action is 'copiar'>
	<cfinclude template="CG_AplicaAsiento_asiento_copia.cfm">
<cfelseif url.action is 'postea'>
	<cfif Len(enc.IDcontable) is 0>
		<b style="color:red;font-size:24px">No hay asiento de prueba</b>
	<cfelse>
		<cfinvoke component="sif.Componentes.CG_AplicaAsiento" method="CG_AplicaAsiento">
			<cfinvokeargument name="IDcontable" value="#enc.IDcontable#">
		</cfinvoke>
	</cfif>
</cfif>


<br>
<cfset hora_de_fin = Now()>
<cfoutput>inicio: #hora_de_fin# - #NumberFormat(hora_de_fin.getTime())#<br>
Transcurrido : #NumberFormat(hora_de_fin.getTime() - hora_de_inicio.getTime())# ms
</cfoutput>
<hr>

<cfset dump_asiento()>

</body></html>
