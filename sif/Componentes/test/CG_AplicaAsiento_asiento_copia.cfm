<cfquery datasource="#session.dsn#" name="Periodo">
	select Pvalor from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo = 30
</cfquery>
<cfquery datasource="#session.dsn#" name="Mes">
	select Pvalor from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo = 40
</cfquery>
<cfquery datasource="#session.dsn#" name="Origen">
	select Pvalor from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo = 40
</cfquery>
<cfquery datasource="#session.dsn#" name="Historia" maxrows="10">
	select e.IDcontable, e.Cconcepto, e.Edocumento, e.Edescripcion,
		count(1) as lineas,
		sum (case when Dmovimiento = 'D' then Dlocal else 0 end) as DEB,
		sum (case when Dmovimiento = 'C' then Dlocal else 0 end) as CRE
	from HEContables e 
		left outer join HDContables d on e.IDcontable = d.IDcontable
	where e.Edescripcion like 'Asiento de prueba volumen %'
	  and e.Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes.Pvalor#">
	group by e.IDcontable, e.Cconcepto, e.Edocumento, e.Edescripcion
	having sum (case when Dmovimiento = 'D' then Dlocal else 0 end) =
		sum (case when Dmovimiento = 'C' then Dlocal else 0 end)
	order by lineas desc, DEB desc
</cfquery>

Seleccione un chunche del historico:<br>
<table style="font-size:12px;font-family:Arial, Helvetica, sans-serif ">
<tr><td>Edescripcion</td><td>lineas</td><td>DEB</td><td>CRE</td></tr>
<cfoutput query="Historia">
<tr><td><a href="?action=copiar&amp;IDcontable=#IDcontable#">#Edescripcion#</a></td>
<td align="right">#NumberFormat(lineas,',0')#</td>
<td align="right">#NumberFormat(DEB,',0.00')#</td>
<td align="right">#NumberFormat(CRE,',0.00')#</td>
</tr>
</cfoutput>
</table>
<cfparam name="url.IDcontable" default="">
<cfif Len(url.IDcontable) neq 0>
	<cfquery name="seleccionado" dbtype="query">select * from Historia where IDcontable = #url.IDcontable#</cfquery>
	<cfinvoke component="sif.Componentes.Contabilidad" method="Nuevo_Asiento" returnvariable="Edocumento">
		<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#">
		<cfinvokeargument name="Cconcepto" value="#seleccionado.Cconcepto#">
		<cfinvokeargument name="Oorigen" value="">
		<cfinvokeargument name="Eperiodo" value="#Periodo.Pvalor#">
		<cfinvokeargument name="Emes" value="#Mes.Pvalor#">
	</cfinvoke>
	<cftransaction>
		<cfquery datasource="#session.dsn#" name="selectNewid">
			select
			Cconcepto,
			'Asiento de prueba volumen  #DateFormat(Now(),'dd-mm-yyyy')# #TimeFormat(Now(), 'hh:mm:ss')#' as Edescripcion,
			'00' as ECusuario, ' ' as Edocbase, 'N' as ECauxiliar
			from HEContables
			where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.IDcontable#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>	
	
		<cfquery datasource="#session.dsn#" name="newid">
			insert into EContables 
			(Ecodigo, Cconcepto, Eperiodo, Emes,
			Edocumento, Efecha, Edescripcion, ECusuario, Edocbase, ECauxiliar)
			VALUES(
			   #session.Ecodigo#,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectNewid.Cconcepto#"     voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#Periodo.Pvalor#"        	voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#Mes.Pvalor#"            	voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#Edocumento#"      			voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#Now()#">,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="100" value="#selectNewid.Edescripcion#"  voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="30"  value="#selectNewid.ECusuario#"		voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#selectNewid.Edocbase#"      voidNull>,
			   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="1"   value="#selectNewid.ECauxiliar#"    voidNull>
		)
			<cf_dbidentity1>
		</cfquery>
		<cf_dbidentity2 name="newid">
		<cfquery datasource="#session.dsn#">
			insert into DContables (
				Dlinea, IDcontable, Ecodigo, Cconcepto, Eperiodo, Emes,
				Edocumento, Ocodigo, Ddescripcion,
				Ddocumento, Dreferencia, Dmovimiento, Ccuenta,
				Doriginal, Dlocal, Mcodigo, Dtipocambio)
			select
				Dlinea,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#newid.identity#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				Cconcepto,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo.Pvalor#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Mes.Pvalor#">,
	
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Edocumento#">,
				Ocodigo, Ddescripcion,
				Ddocumento, Dreferencia, Dmovimiento, Ccuenta,
				Doriginal, Dlocal, Mcodigo, Dtipocambio
			from HDContables
			where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.IDcontable#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	</cftransaction>
</cfif>
