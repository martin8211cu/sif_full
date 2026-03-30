<html><body>
<h1>Contabilidad General</h1><h2>CG_GeneraAsiento</h2>
<a href="index.cfm">&lt;- index</a> | <a href="CG_AplicaAsiento_test.cfm">Aplicar</a><br>
<ul>
<li><a href="?action=genera">Generar asiento de dos l&iacute;neas</a></li>
<li><a href="?action=genera2">Generar asiento de muchas l&iacute;neas</a></li>
<li><a href="?action=nada">Ver asiento generado</a></li>
</ul>
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
<cfelseif url.action is 'genera' or url.action is 'genera2'>
	<cftransaction>
		<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="CreaIntarc" returnvariable="intarc">
		</cfinvoke>
		<cfquery datasource="#session.dsn#">
			insert into #INTARC# (
				INTORI, INTREL, INTDOC, INTREF,
				INTMON, INTTIP, INTDES, INTFEC,
				INTCAM, Periodo, Mes, Ccuenta,
				Mcodigo, Ocodigo, INTMOE)
			select
				'CG', 1, '1', '1',
				500, 'C', 'Linea uno', '20030210',
				1, 2003, 10, Ccuenta,
				1, 1, 500
			from CContables
			<cfif url.action is 'genera2'>
			where Ecodigo = 1 and Cformato like '4000-%' and Cmovimiento = 'S'
			<cfelse>
			where Ecodigo = 1 and Cformato = '4000-11-11'
			</cfif>
		</cfquery>
		<!--- unos ceros por ahi --->
		<cfquery datasource="#session.dsn#">
			insert into #INTARC# (
				INTORI, INTREL, INTDOC, INTREF,
				INTMON, INTTIP, INTDES, INTFEC,
				INTCAM, Periodo, Mes, Ccuenta,
				Mcodigo, Ocodigo, INTMOE)
			select
				'CG', 1, '1', '1',
				000.00, 'C', 'Registros en cero', '20030210',
				1, 2003, 10, Ccuenta,
				1, 1, 000.00
			from CContables
			<cfif url.action is 'genera2'>
			where Ecodigo = 1 and Cformato like '4000-%' and Cmovimiento = 'S'
			<cfelse>
			where Ecodigo = 1 and Cformato = '4000-11-11'
			</cfif>
		</cfquery>
		<cfquery datasource="#session.dsn#">
			insert into #INTARC# (
				INTORI, INTREL, INTDOC, INTREF,
				INTMON, INTTIP, INTDES, INTFEC,
				INTCAM, Periodo, Mes, Ccuenta,
				Mcodigo, Ocodigo, INTMOE)
			select
				'CG', 1, '1', '1',
				500, 'D', 'Linea dos', '20030210',
				1, 2003, 10, Ccuenta,
				1, 1, 500
			from CContables
			<cfif url.action is 'genera2'>
			where Ecodigo = 1 and Cformato like '4000-%' and Cmovimiento = 'S'
			<cfelse>
			where Ecodigo = 1 and Cformato = '4000-11-12'
			</cfif>
		</cfquery>
		<cfquery datasource="#session.dsn#" name="intt" maxrows="50">
			select INTTIP, sum (INTMON) sum_INTMON, count(1) cant_lineas from #intarc# group by INTTIP
		</cfquery>
		<cfdump var="#intt#">
		<cfset inicio_de_componente = Now()>
		
		<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="IDcontable">
			<cfinvokeargument name="Oorigen" value="1">
			<cfinvokeargument name="Cconcepto" value="1">
			<cfinvokeargument name="Eperiodo" value="2003">
			<cfinvokeargument name="Emes" value="2">
			<cfinvokeargument name="Efecha" value="#CreateDate(2003,2,10)#">
			<cfinvokeargument name="Edescripcion" value="Asiento de prueba GeneraAsiento #Now()#">
			<cfinvokeargument name="Edocbase" value="1">
			<cfinvokeargument name="Ereferencia" value="1">
			<cfinvokeargument name="debug" value="no">
			<cfinvokeargument name="interfazconta" value="yes">
		</cfinvoke> 
		
		<cfset fin_de_componente = Now()>
		<cfoutput><br>IDcontable: #IDcontable#<br>
		Transcurrido (componente) : #NumberFormat(fin_de_componente.getTime() - inicio_de_componente.getTime())# ms
		</cfoutput>
	</cftransaction>
</cfif>

<br>
<cfset hora_de_fin = Now()>
<cfoutput>inicio: #hora_de_fin# - #NumberFormat(hora_de_fin.getTime())#<br>
Transcurrido : #NumberFormat(hora_de_fin.getTime() - hora_de_inicio.getTime())# ms
</cfoutput>
<hr>

<cfset dump_asiento()>

</body></html>
