<!--- Tabla Temporal de Errores --->
<cf_dbtemp name="AF_INICIO_ERROR" returnvariable="AF_INICIO_ERROR" datasource="#session.dsn#">
	<cf_dbtempcol name="Mensaje" type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="DatoIncorrecto" type="varchar(40)" mandatory="no">
	<cf_dbtempcol name="ErrorNum" type="integer" mandatory="yes">
</cf_dbtemp>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

<!--- Periodo--->
<cfquery name="rsPeriodo" datasource="#session.DSN#">
	select p1.Pvalor as value from Parametros p1 
	where Ecodigo = #session.Ecodigo#
	and Pcodigo = 50
</cfquery>
<cfif (rsPeriodo.recordcount eq 0) or (rsPeriodo.recordcount gt 0 and  len(trim(rsPeriodo.value)) eq 0)>
	<cf_errorCode	code = "50078" msg = "No se encontró el periodo de auxiliares, Proceso Cancelado!">
</cfif>
<!--- Mes --->
<cfquery name="rsMes" datasource="#session.DSN#">
	select p1.Pvalor as value from Parametros p1 
	where Ecodigo = #session.Ecodigo# 
	and Pcodigo = 60
</cfquery>
<cfif (rsMes.recordcount eq 0) or (rsMes.recordcount gt 0 and 	len(trim(rsMes.value)) eq 0)>
	<cf_errorCode	code = "50079" msg = "No se encontró el mes de auxiliares, Proceso Cancelado!">
</cfif>
<!--- Obtiene la Moneda Local --->
<cfquery name="rsMoneda" datasource="#session.dsn#">
	select Mcodigo as value
	from Empresas 
	where Ecodigo = #session.Ecodigo#
</cfquery>
<cfif (rsMes.recordcount eq 0) or (rsMes.recordcount gt 0 and 	len(trim(rsMes.value)) eq 0)>
	<cf_errorCode	code = "50080"
					msg  = "No se encontró la moneda para la empresa @errorDat_1@, Proceso Cancelado!"
					errorDat_1="#session.Enombre#"
	>
</cfif>
<!---Concepto no existente---->
<cfquery datasource="#session.dsn#">
	insert into #AF_INICIO_ERROR# ( Mensaje, DatoIncorrecto, ErrorNum)
	select '701.Concepto No Existente' as Mensaje, 
	 <cf_dbfunction name="to_char" args="a.Cconcepto"> as DatoIncorrecto,
	 701 as ErrorNum
	from #table_name# a
	  where not exists
	  (
	   select 1 
			from ConceptoContableE b
			 where Ecodigo = #session.Ecodigo#
			 and a.Cconcepto = b.Cconcepto
	  )
</cfquery>
<!---Oficina Origen NO existente---->
<cfquery datasource="#session.dsn#">
	insert into #AF_INICIO_ERROR# ( Mensaje, DatoIncorrecto, ErrorNum)
	select '702.Oficina Origen No Existente' as Mensaje, 
	 <cf_dbfunction name="to_char" args="a.Oficodigoori"> as DatoIncorrecto,
	 702 as ErrorNum
	from #table_name# a
	  where not exists
	  (
	   select 1 
			from Oficinas b
			 where b.Ecodigo = #session.Ecodigo#
			 and a.Oficodigoori = b.Oficodigo
	  )
</cfquery>

<!---Oficina destino No existente---->
<cfquery datasource="#session.dsn#">
	insert into #AF_INICIO_ERROR# ( Mensaje, DatoIncorrecto, ErrorNum)
	select '703.Oficina Destino No Existente' as Mensaje, 
	 <cf_dbfunction name="to_char" args="a.Oficodigodest"> as DatoIncorrecto,
	 703 as ErrorNum
	from #table_name# a
	  where not exists
	  (
	   select 1 
			from Oficinas b
			 where b.Ecodigo = #session.Ecodigo#
			 and a.Oficodigodest = b.Oficodigo
	  )
</cfquery>
<!---=========VALIDACION DE LAS CUENTAS==================--->
<cfquery name="cuentaImportar" datasource="#session.dsn#">
	select Cformatocxc, Cformatocxp
	from #table_name#
</cfquery>
<cfloop query="cuentaImportar">
	<!---Validacion de la cuenta Origen CXC---->
	<cfset LvarFormatoCuentacxc = #cuentaImportar.Cformatocxc#>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select CFmovimiento
		  from CFinanciera
		where CFformato	= '#LvarFormatoCuentacxc#'
		  and Ecodigo 	= #session.Ecodigo#
	</cfquery>
	<cfset LvarRESULT = "OLD">
	<cfif rsSQL.recordCount EQ 0>
		<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCFformato" returnvariable="LvarRESULT">
			<cfinvokeargument name="Lprm_Ecodigo" 			value="#session.Ecodigo#"/>							
			<cfinvokeargument name="Lprm_CFformato" 		value="#LvarFormatoCuentacxc#"/>
			<cfinvokeargument name="Lprm_NoVerificarSinOfi" value="true"/>
			<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
		</cfinvoke>		
	<cfelseif rsSQL.CFmovimiento NEQ "S">
		<cfquery datasource="#session.dsn#">
			insert into #AF_INICIO_ERROR# ( Mensaje, DatoIncorrecto, ErrorNum)
			values(
			'704.Cuenta Financiera por Cobrar no acepta movimientos', 
			 '#LvarFormatoCuentacxc#',
			 704
			)
		</cfquery>
	</cfif>
	<cfif LvarRESULT NEQ "OLD" AND LvarRESULT NEQ "NEW">
		<cfquery datasource="#session.dsn#">
			insert into #AF_INICIO_ERROR# ( Mensaje, DatoIncorrecto, ErrorNum)
			values(
			'704.Error en Cuenta Financiera por Cobrar. #LvarRESULT#', 
			 '#LvarFormatoCuentacxc#',
			 704
			)
		</cfquery>
	</cfif>
	<!---Validacion de la cuenta Destino CXP---->
	<cfset LvarFormatoCuentacxp = #cuentaImportar.Cformatocxp#>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select CFmovimiento
		  from CFinanciera
		where CFformato	= '#LvarFormatoCuentacxp#'
		  and Ecodigo 	= #session.Ecodigo#
	</cfquery>
	
	<cfset LvarRESULT = "OLD">
	<cfif rsSQL.recordCount EQ 0>
		<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCFformato" returnvariable="LvarRESULT">
			<cfinvokeargument name="Lprm_Ecodigo" 			value="#session.Ecodigo#"/>							
			<cfinvokeargument name="Lprm_CFformato" 		value="#LvarFormatoCuentacxp#"/>
			<cfinvokeargument name="Lprm_NoVerificarSinOfi" value="true"/>
			<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
		</cfinvoke>		
	<cfelseif rsSQL.CFmovimiento NEQ "S">
		<cfquery datasource="#session.dsn#">
			insert into #AF_INICIO_ERROR# ( Mensaje, DatoIncorrecto, ErrorNum)
			values(
			'705.Cuenta Financiera por Pagar no acepta movimientos', 
			 '#LvarFormatoCuentacxp#',
			 705
			)
		</cfquery>
	</cfif>
	<cfif LvarRESULT NEQ "OLD" AND LvarRESULT NEQ "NEW">
		<cfquery datasource="#session.dsn#">
			insert into #AF_INICIO_ERROR# ( Mensaje, DatoIncorrecto, ErrorNum)
			values(
			'705.Error en Cuenta Financiera por Pagar. #LvarRESULT#', 
			 '#LvarFormatoCuentacxp#',
			 705
			)
		</cfquery>
	</cfif>
</cfloop>

<!---Relaciones duplicadas en el Archivo--->
<cfquery datasource="#session.dsn#">
insert into #AF_INICIO_ERROR# ( Mensaje, DatoIncorrecto, ErrorNum)
	select '706. Relacion duplicada en el Archivo (Concepto-Oficina Origen-Oficina destino)' as Mensaje, 
	 <cf_dbfunction name="to_char" args="a.Cconcepto">
	 #_Cat# '-'
	 #_Cat# <cf_dbfunction name="to_char" args="a.Oficodigoori">
	 #_Cat# '-'
	 #_Cat# <cf_dbfunction name="to_char" args="a.Oficodigodest"> as DatoIncorrecto,
	 706 as ErrorNum
	from #table_name# a
	 group by a.Cconcepto, Oficodigoori,Oficodigodest
	 having count(1)> 1
</cfquery>
<!---Cuenta ya asignada en la base de datos--->
<cfquery datasource="#session.dsn#">
insert into #AF_INICIO_ERROR# ( Mensaje, DatoIncorrecto, ErrorNum)
	select '707. La realcion ya tiene una cuenta asignada (Concepto-Oficina Origen-Oficina destino)' as Mensaje, 
	 <cf_dbfunction name="to_char" args="arc.Cconcepto"> 
	 #_Cat# '-' 
	 #_Cat# <cf_dbfunction name="to_char" args="arc.Oficodigoori">
	 #_Cat# '-'
	 #_Cat# <cf_dbfunction name="to_char" args="arc.Oficodigodest"> as DatoIncorrecto,
	 707 as ErrorNum
	from #table_name# arc
		   inner join Oficinas ofiN
			on arc.Oficodigoori = ofiN.Oficodigo
            and ofiN.Ecodigo = #session.Ecodigo#

		   inner join Oficinas ofiV
			on arc.Oficodigodest = ofiV.Oficodigo
            and ofiV.Ecodigo = #session.Ecodigo#

		   inner join CFinanciera CtnN
			on arc.Cformatocxc = CtnN.CFformato
            and CtnN.Ecodigo = #session.Ecodigo#

		   inner join CFinanciera CtnV
			on arc.Cformatocxp = CtnV.CFformato
            and CtnV.Ecodigo = #session.Ecodigo#

		   inner join CuentaBalanceOficina CBO
		    on CBO.Ecodigo = #session.Ecodigo#
            and arc.Cconcepto = CBO.Cconcepto
			and ofiN.Ocodigo  = CBO.Ocodigoori
			and ofiV.Ocodigo  = CBO.Ocodigodest
	
</cfquery>

<cfquery name="err" datasource="#session.dsn#">
	select  distinct DatoIncorrecto, Mensaje
	from #AF_INICIO_ERROR#
	order by Mensaje
</cfquery>

<cfif (err.recordcount) EQ 0>
	<cfquery datasource="#Session.Dsn#">
		INSERT into CuentaBalanceOficina (Ecodigo, Cconcepto, Ocodigoori, Ocodigodest,CFcuentacxc,CFcuentacxp) 
			select  #session.Ecodigo#,
			achi.Cconcepto,
			ofiN.Ocodigo,
			ofiV.Ocodigo,
			CtnN.CFcuenta,
			CtnV.CFcuenta
			
		from #table_name# achi
		   inner join Oficinas ofiN
			on achi.Oficodigoori = ofiN.Oficodigo
            and ofiN.Ecodigo = #session.Ecodigo#

		   inner join Oficinas ofiV
			on achi.Oficodigodest = ofiV.Oficodigo
			and ofiV.Ecodigo = #session.Ecodigo#
            
		   inner join CFinanciera CtnN
			on achi.Cformatocxc = CtnN.CFformato
			and CtnN.Ecodigo = #session.Ecodigo#
            
		   inner join CFinanciera CtnV
			on achi.Cformatocxp = CtnV.CFformato
			and CtnV.Ecodigo = #session.Ecodigo#
	</cfquery>	
</cfif>