<cf_navegacion name="CBid">
<cf_navegacion name="TESMPcodigo">

<cfif LvarTipoDoc eq "ANULAR">
	<cfquery name="Tipo" datasource="#session.DSN#">
		select '-1' as value, '-- Todos -- ' as description from dual
		union all
		select 'M' as value, 'Multa' as description from dual
		union all
		select 'E' as value, 'Embargo' as description from dual
		union all
		select 'C' as value, 'CESIÓN' as description from dual
		order by value
	</cfquery>

	<cfquery name="Estado" datasource="#session.DSN#">
		select -1 as value, '-- Todos -- ' as description from dual
		union all
		select 0 as value, 'En Preparacion' as description from dual
		union all
		select 1 as value, 'En Aprobacion' as description from dual
		union all
		select 2 as value, 'Pendiente' as description from dual
		union all
		select 3 as value, 'Aprobado' as description from dual
		union all
		select 4 as value, 'Rechazado' as description from dual
		union all
		select 5 as value, 'Anulado' as description from dual
		union all
		select 10 as value, 'Pagado' as description from dual
		order by value
	</cfquery>

	<cfquery name="Nivel" datasource="#session.DSN#">
		select '' as value, '-- Todos -- ' as description from dual
		union all
		select 'O' as value, 'OC' as description from dual
		union all
		select 'D' as value, 'CxP' as description from dual
		order by value
	</cfquery>
</cfif>

<cf_dbfunction name="OP_CONCAT" returnvariable="_Cat">
<cfquery datasource="#session.dsn#" name="lista">
	select
			c.CPCid,
			case c.CPCtipo
				when 'M' then 1 else 2
			end as Orden,
			case c.CPCtipo
				when 'M' then 'MULTA'
				when 'E' then 'EMBARGO'
				when 'C' then 'CESIÓN'
			end as Tipo,
			c.CPCdocumento,
			c.CPCdescripcion,
			c.CPCfecha,
			sno.SNnombre as SNorigen,
			case c.CPCnivel
				when 'S' then ''
				when 'O' then 'OC:'		#_Cat# (select <cf_dbfunction name="to_char" args="EOnumero" datasource="#session.dsn#"> from EOrdenCM where EOidorden = c.EOidorden)
				when 'D' then 'CxP:'	#_Cat# (select CPTcodigo #_Cat# '-' #_Cat# Ddocumento from HEDocumentosCP where IDdocumento = c.IDdocumento)
			end as DOC,
			snd.SNnombre as SNdestino,
		
			m.Miso4217,
			c.CPCmonto,
			c.CPCmonto - c.CPCpagado as Saldo,
			c.CPCmonto - c.CPCpagado - c.TESDPaprobadoPendiente as SaldoNeto,

			case c.CPCestado
				when 0 then 	'En Preparacion'
				when 1 then 	'En Aprobacion'
				when 2 then 	'Pendiente'
				when 3 then 	'Aprobado'
				when 4 then 	'Rechazado'
				when 5 then 	'Anulado'
				when 10 then 	'Pagado'
			end as estado
	from	CPCesion c
		inner join SNegocios sno
			on sno.SNid = c.SNidOrigen
		left join SNegocios snd
			on snd.SNid = c.SNidDestino
		inner join Monedas m
			 on m.Ecodigo = c.Ecodigo
			and m.Mcodigo = c.Mcodigo
	where c.Ecodigo = #session.Ecodigo#
	<cfif LvarTipoDoc EQ "CESION">
	  and c.CPCtipo = 'C'
	  and c.CPCestado = 0
	<cfelseif LvarTipoDoc EQ "EMBARGO">
	  and c.CPCtipo = 'E'
	  and c.CPCestado = 0
	<cfelseif LvarTipoDoc EQ "MULTA">
	  and c.CPCtipo = 'M'
	  and c.CPCestado = 0
	<cfelseif LvarTipoDoc EQ "APROBAR">
	  and c.CPCestado = 1	<!--- En Aprobacion --->
	<cfelseif LvarTipoDoc EQ "ANULAR">
	  and c.CPCestado = 3	<!--- Aprobados --->
	</cfif>
	<cfif LvarTipoDoc eq "ANULAR">
		<cfif isdefined('form.filtro_Tipo') and len(trim(form.filtro_Tipo)) and #form.filtro_Tipo# neq '-1' >
			and upper(c.CPCtipo) like upper('%#form.filtro_Tipo#%')
		</cfif>	
		<cfif isdefined('form.filtro_Estado')and len(trim(form.filtro_Estado)) and #form.filtro_Estado# neq '-1' >
			and c.CPCestado = #form.filtro_Estado#
		</cfif>	
		<cfif isdefined('form.filtro_Doc')and len(trim(form.filtro_Doc)) and #form.filtro_Doc# neq 'S' >
			and upper(c.CPCnivel) like upper('%#form.filtro_Doc#%')
		</cfif>	
		<cfif isdefined('form.filtro_CPCdocumento')and len(trim(form.filtro_CPCdocumento)) >
			and upper(c.CPCdocumento) like upper('%#form.filtro_CPCdocumento#%')
		</cfif>	
		<cfif isdefined('form.filtro_CPCdescripcion')and len(trim(form.filtro_CPCdescripcion)) >
			and upper(c.CPCdescripcion) like upper('%#form.filtro_CPCdescripcion#%')
		</cfif>	
		<cfif isdefined('form.filtro_CPCfecha')and len(trim(form.filtro_CPCfecha)) >
			and c.CPCfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedatetime(form.filtro_CPCfecha)#"> 
		</cfif>	
		<cfif isdefined('form.filtros_CPCmonto')and len(trim(form.filtros_CPCmonto)) >
			and c.CPCmonto = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.filtros_CPCmonto,',','','all')#">
		</cfif>	
	</cfif>
	order by sno.SNnombre, Orden, CPCfecha, CPCid
</cfquery>

<cfif LvarTipoDoc EQ "APROBAR" OR LvarTipoDoc EQ "ANULAR">
	<cfset LvarBotones = "">
<cfelse>
	<cfset LvarBotones = "Nuevo">
</cfif>

<cfif LvarTipoDoc eq "ANULAR">
	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
		query="#lista#"
		cortes="SNorigen"
		desplegar="Tipo, CPCdocumento, CPCdescripcion, CPCfecha, Doc, Estado, Miso4217, CPCmonto, SaldoNeto"
		etiquetas="Tipo, Numero, Descripcion, Fecha, Documento, Estado, , Monto, Saldo"
		formatos="S,S,S,D,S,S,U,M,U"
		align="left,left,left,left,left,left,left,left,left"
		ajustar="N"
		ira="#LvarRoot#"
		keys="CPCid"
		filtrar_automatico="true"
		mostrar_filtro="true"
		showEmptyListMsg="yes"
		EmptyListMsg="--- No se existen Documentos de Afectación al Pago definidos ---"
		botones="#LvarBotones#"
		rsTipo="#Tipo#"
		rsEstado="#Estado#"
		rsDOC="#Nivel#"
	/>	
<cfelse>
	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
		query="#lista#"
		cortes="SNorigen"
		desplegar="Tipo, CPCdocumento, CPCdescripcion, CPCfecha, Doc, Estado, Miso4217, CPCmonto, SaldoNeto"
		etiquetas="Tipo, Numero, Descripcion, Fecha, Documento, Estado, , Monto, Saldo"
		formatos="S,S,S,D,S,S,U,M,U"
		align="left,left,left,left,left,left,left,left,left"
		ajustar="N"
		ira="#LvarRoot#"
		keys="CPCid"
		showEmptyListMsg="yes"
		EmptyListMsg="--- No se existen Documentos de Afectación al Pago definidos ---"
		botones="#LvarBotones#"
	/>		
</cfif>
