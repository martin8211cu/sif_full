<!---======== Tabla temporal de errores  ========--->
<cf_dbtemp name="error" returnvariable="errores" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp> 
<cf_dbfunction name="now" returnvariable="hoy">
<cfset session.Importador.SubTipo = "2">

<cfquery  name="rsImportador" datasource="#session.dsn#">
	select * from #table_name# 
</cfquery>

<cfloop query="rsImportador">
	<!---►►►Avance◄◄◄--->
	<cfset session.Importador.Avance = rsImportador.currentRow/rsImportador.recordCount>
	<cfif (rsImportador.currentRow mod 179 EQ 0)>
		<cfflush interval="64">
	</cfif>
	<!---►►►Existencia de lineas en blanco en el archivo de texto◄◄◄--->
	<cfif len(trim(rsImportador.Aplaca)) eq 0 or len(trim(rsImportador.CRCCcodigoOri)) eq 0 or len(trim(rsImportador.CRCCcodigoDest)) eq 0>
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error! Existen Columnas en el archivo que estan en blanco')
		</cfquery>
	</cfif>
	<!---►►►Existencia de Activos Repetidos en el archivo de texto◄◄◄--->
	<cfquery datasource="#session.dsn#" name="slBusca">
		select Aplaca, count(1) as cantidad
		  from #table_name# 
		where Aplaca = '#rsImportador.Aplaca#'
		 group by Aplaca
		having count(1) > 1
	</cfquery>
	<cfif slBusca.cantidad gt 0 >
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error. La Placa #rsImportador.Aplaca# esta repetida en el archivo!')
		</cfquery>
	</cfif>
	<!---►►►Obtiene el Centro de Custodia Origen◄◄◄--->
	<cfquery name="rsOri" datasource="#session.DSN#">
		select  min(a.CRCCid) as CRCCidOri
		from CRCentroCustodia a
		where CRCCcodigo = '#rsImportador.CRCCcodigoOri#'
	</cfquery>
	<cfif rsOri.CRCCidOri eq ""> 
		<cfquery name="ERRA" datasource="#session.DSN#">
			Insert into #errores# (Error)
			values ('El centro de custodia origen #rsImportador.CRCCcodigoOri# no esta definido')
		</cfquery>
	</cfif>
	<!---►►►Obtiene el Centro de Custodia Destino◄◄◄--->
	<cfquery name="rsDest" datasource="#session.DSN#">
		select  min(CRCCid) as CRCCidDest
		from CRCentroCustodia 
		where CRCCcodigo = '#rsImportador.CRCCcodigoDest#'
	</cfquery>
	<cfif rsDest.CRCCidDest eq ""> 
		<cfquery name="ERRA" datasource="#session.DSN#">
			Insert into #errores# (Error)
			values ('El centro de custodia destino #rsImportador.CRCCcodigoDest# no esta definido')
		</cfquery>
	</cfif>
	<!---►►►Verifica Activo◄◄◄--->
	<cfquery name="rsActivo" datasource="#session.dsn#">
		select distinct
				a.Aid,
				a.Aplaca
		from Activos a
			inner join AFResponsables b
				on a.Aid=b.Aid
				and #hoy# between b.AFRfini and b.AFRffin
		where a.Aplaca='#rsImportador.Aplaca#'
	</cfquery>
	<cfif rsActivo.Aid eq ""> 
		<cfquery name="ERRA" datasource="#session.DSN#">
			Insert into #errores# (Error)
			values ('El Activo Placa:&nbsp;#rsImportador.Aplaca# no existe')
		</cfquery>
	</cfif>
	<!---►►►Valida que el Activo exista en el Centro de custodia Origen◄◄◄--->
	<cfif rsOri.CRCCidOri neq "" and rsActivo.Aid neq ""> 
		<cfquery name="rsvalida" datasource="#session.DSN#">
			select  count(1) as cantidad
			from CRCentroCustodia a
				inner join AFResponsables b
					on a.CRCCid=b.CRCCid
			where b.CRCCid  = #rsOri.CRCCidOri#
			  and b.Aid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsActivo.Aid#">
			  and #hoy# between b.AFRfini and b.AFRffin
		</cfquery>
		<cfif rsvalida.cantidad eq 0> 
			<cfquery name="ERRA" datasource="#session.DSN#">
				Insert into #errores# (Error)
				values ('Error. El Activo #rsImportador.Aplaca# no pertenece al Centro de Custodia Origen #rsImportador.CRCCcodigoOri#.')
			</cfquery>
		</cfif>
	</cfif>
	<!---►►►Verifica que exista el Centro de Custodia Origen◄◄◄--->
	<cfif rsDest.CRCCidDest Neq "" and rsOri.CRCCidOri Neq "">	
		<cfquery name="rsVerificaInsert" datasource="#session.DSN#">
				Select count(1) as cantidad
				from AFResponsables a
						inner join Activos b
							on a.Aid = b.Aid
								and a.Ecodigo = b.Ecodigo 
				where CRCCid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOri.CRCCidOri#">
				  and a.Ecodigo =  #Session.Ecodigo# 
				  and #hoy# between AFRfini and AFRffin 
				and AFRid not in (select AFRid 
					 				from AFTResponsables 
								  where Usucodigo = #Session.Usucodigo#
					  			    and AFTRtipo  = 2) 
	
		</cfquery>
		<cfif rsVerificaInsert.cantidad eq 0> 
			<cfquery name="ERR" datasource="#session.DSN#">
				Insert into #errores# (Error)
				values ('El Centro Funcional Origen no existe #rsImportador.CRCCcodigoOri#')
			</cfquery>
		</cfif>
	</cfif>
</cfloop>	

<cfquery name="ERR" datasource="#session.DSN#">
    select Error as MSG
      from #errores# 
    group by Error
</cfquery>

<cfif ERR.Recordcount eq 0>
	<cfquery name="rsInsert" datasource="#session.DSN#">
		 insert into AFTResponsables(AFRid,Usucodigo,AFTRestado,AFTRtipo,AFTRfini,Ulocalizacion,BMUsucodigo,CRCCid) 
			select
				a.AFRid,
                #Session.Usucodigo#,
                30,
                2,
                #hoy#,
				'00',
				#session.Usucodigo#,
				c.CRCCid
			from #table_name# te
				inner join Activos b
					inner join AFResponsables a
						on a.Aid = b.Aid
				  on b.Aplaca = te.Aplaca
                inner join CRCentroCustodia c
                	 on c.Ecodigo    = b.Ecodigo
                    and c.CRCCcodigo = te.CRCCcodigoDest
			where b.Ecodigo =  #Session.Ecodigo# 
			  and #hoy# between a.AFRfini and a.AFRffin
			  and AFRid not in (select AFRid 
									from AFTResponsables 
								  where Usucodigo = #Session.Usucodigo#
									and AFTRtipo  = 2) 
				and not exists (Select 1 
								 from ADTProceso ADT 
								where ADT.Ecodigo = b.Ecodigo 
								  and ADT.Aid 	  = b.Aid)
	</cfquery>
</cfif>
<cfset session.Importador.SubTipo = 3>