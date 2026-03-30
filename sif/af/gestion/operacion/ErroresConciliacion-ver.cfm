<cffunction name="ObtieneMonedaEmpresa" access="private" output="no" returntype="numeric">
	<cfargument name="Conexion" required="yes">
	<cfargument name="Ecodigo" required="yes">

	<cfquery name="rstemp" datasource="#arguments.conexion#">
		select Mcodigo as Moneda
		from Empresas 
		where Ecodigo = #arguments.ecodigo#
	</cfquery>
	<cfreturn rsTemp.Moneda>
</cffunction>

<cffunction name="ObtienePeriodoActual" access="private" output="no" returntype="numeric">
	<cfargument name="Conexion" required="yes">
	<cfargument name="Ecodigo" required="yes">

	<cfquery name="rstemp" datasource="#arguments.conexion#">
		select <cf_dbfunction name="to_number" args="Pvalor"> as Periodo
		from Parametros
		where Ecodigo = #arguments.ecodigo#
			and Pcodigo = 50
	</cfquery>
	<cfreturn rsTemp.Periodo>
</cffunction>

<cffunction name="ObtieneMesActual" access="private" output="no" returntype="numeric">
	<cfargument name="Conexion" required="yes">
	<cfargument name="Ecodigo" required="yes">

	<cfquery name="rstemp" datasource="#arguments.conexion#">
		select <cf_dbfunction name="to_number" args="Pvalor"> as Mes
		from Parametros
		where Ecodigo = #arguments.ecodigo#
			and Pcodigo = 60
	</cfquery>
	<cfreturn rsTemp.Mes>
</cffunction>

<cffunction name="fnVerificaAsientoAjuste" access="private" output="no" returntype="boolean">
	<cfargument name="Conexion"   type="string" required="yes">
	<cfargument name="Ecodigo"    type="numeric" required="yes">
	<cfargument name="GATperiodo" type="numeric" required="yes">
	<cfargument name="GATmes"     type="numeric" required="yes">
	<cfargument name="Cconcepto" type="numeric" required="yes">
	<cfargument name="Edocumento" type="numeric" required="yes">

	<cfquery name="rsAstAjustes" datasource="#arguments.conexion#">
		Select distinct a.Ocodigo, a.OcodigoAnt
		from GATransacciones a
		where a.Ecodigo     = #arguments.ecodigo#
		  and a.GATperiodo  = #arguments.GATperiodo#
		  and a.GATmes      = #arguments.GATmes#
		  and a.Cconcepto   = #arguments.Cconcepto#
		  and a.Edocumento  = #arguments.Edocumento#
		  and a.Ocodigo    != a.OcodigoAnt
		  and a.OcodigoAnt is not null
	</cfquery>

	<cfif rsAstAjustes.recordcount gt 0>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="fnDocumentoNoConciliado" access="private" output="no" returntype="boolean">
	<cfargument name="Conexion"   type="string" required="yes">
	<cfargument name="Ecodigo"    type="numeric" required="yes">
	<cfargument name="GATperiodo" type="numeric" required="yes">
	<cfargument name="GATmes"     type="numeric" required="yes">
	<cfargument name="Cconcepto" type="numeric" required="yes">
	<cfargument name="Edocumento" type="numeric" required="yes">
	
	<cfquery name="VerificaDoc" datasource="#arguments.conexion#">
		Select count(1) as noconc
		from GATransacciones 
		where Ecodigo 		= #arguments.ecodigo#
		  and GATperiodo 	= #arguments.GATperiodo#
		  and GATmes 		= #arguments.GATmes#
		  and Cconcepto 	= #arguments.Cconcepto#
		  and Edocumento 	= #arguments.Edocumento#
		  and GATestado < 2
	</cfquery>
	<cfif VerificaDoc.noconc GT 0>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="fnProcesoIncompleto" access="private" output="no" returntype="boolean">
	<cfargument name="Conexion"   type="string" required="yes">
	<cfargument name="Ecodigo"    type="numeric" required="yes">
	
	<cfquery name="VerificaInc" datasource="#arguments.conexion#">
     	select count(1) as DocInc
		 from EAadquisicion
		   where Ecodigo  = #arguments.ecodigo#
		   and EAstatus = -1		  
	</cfquery>
	<cfif VerificaInc.DocInc >
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>

<cffunction name="fnVerificaConciliacion" access="private" returntype="query">
	<cfargument name="Conexion"   type="string" required="yes">
	<cfargument name="Ecodigo"    type="numeric" required="yes">
	<cfargument name="GATperiodo" type="numeric" required="yes">
	<cfargument name="GATmes"     type="numeric" required="yes">
	<cfargument name="Cconcepto" type="numeric" required="yes">
	<cfargument name="Edocumento" type="numeric" required="yes">

	<cfset paramPeriodo = ObtienePeriodoActual(Arguments.Conexion, Arguments.Ecodigo)>
	<cfset paramMes = ObtieneMesActual(Arguments.Conexion, Arguments.Ecodigo)>	
	
	<cf_dbtemp name="af_conc_ERRORES" returnvariable="ERRORES" datasource="#arguments.conexion#">
		<cf_dbtempcol name="MsgError" 	type="varchar(250)"	mandatory="yes">
		<cf_dbtempcol name="Valor" 		type="varchar(30)"  mandatory="yes">
		<cf_dbtempcol name="ID" 		type="numeric"  	mandatory="no">
	</cf_dbtemp>
	
	<cfif len(trim(paramPeriodo)) eq 0>
		<cfquery datasource="#arguments.conexion#">
			insert into #ERRORES# (MsgError,Valor)
			select 'Error 40001! No se pudo obtener el periodo del auxiliar', ''
		</cfquery>
	</cfif>
	
	<cfif len(trim(paramMes)) eq 0>
		<cfquery datasource="#arguments.conexion#">
			insert into #ERRORES# (MsgError,Valor)
			Select 'Error 40001! No se pudo obtener el mes del auxiliar', ''
		</cfquery>
	</cfif>	
	
	<!---Valida que no hayan registros del documento por conciliar que tengan estado menor a 1 (Completo)--->
	<cfquery datasource="#arguments.conexion#">
		insert into #ERRORES# (MsgError, Valor)
		select <cf_dbfunction name="concat" args="'La Cuenta ' , cf.CFformato , ' no está completa.'"> , <cf_dbfunction name="to_char" args="count(1)">
		from GATransacciones a
			inner join CFinanciera cf
			on cf.CFcuenta=a.CFcuenta
		where a.Ecodigo    = #arguments.ecodigo#
		and   a.GATperiodo = #arguments.GATperiodo#
		and   a.GATmes     = #arguments.GATmes#
		and   a.Cconcepto  = #arguments.Cconcepto#
		and   a.Edocumento = #arguments.Edocumento#
		and   a.GATestado < 1
		group by cf.CFformato
	</cfquery>

	<!--- Valida que todas las cuentas de las transacciones estén definidas en la tabla de Cuentas de Mayor de Gestion --->
	<cfquery datasource="#arguments.conexion#">
		insert into #ERRORES# (MsgError, Valor)
		select <cf_dbfunction name="concat" args="'La Cuenta ' , cf.CFformato , ' no es de Gestion de Activos '">, <cf_dbfunction name="to_char" args="count(1)">
		from GATransacciones a
			inner join CFinanciera cf
			on cf.CFcuenta=a.CFcuenta				
		where a.Ecodigo    = #arguments.ecodigo#
		and   a.GATperiodo = #arguments.GATperiodo#
		and   a.GATmes     = #arguments.GATmes#
		and   a.Cconcepto  = #arguments.Cconcepto#
		and   a.Edocumento = #arguments.Edocumento#
		and (( 
				select count(1)
				from GACMayor c
				where c.Ecodigo = cf.Ecodigo
				  and c.Cmayor  = cf.Cmayor
				  and <cf_dbfunction name="like" args="rtrim(cf.CFformato),c.Cmascara">
			)) < 1
		group by cf.CFformato
	</cfquery>

	<!--- Valida que las cuentas del asiento que correspondan a Cuentas de Mayor de Gestion estén en las transacciones --->
	<cfquery datasource="#arguments.conexion#">
		insert into #ERRORES# (MsgError, Valor)
		select 
			<cf_dbfunction name="concat"  args="'La Cuenta ' , cf.CFformato , ' es de Gestion de Activos y no está conciliada por un monto:'">, 
			<cf_dbfunction name="to_char" args="sum(a.Dlocal * (case a.Dmovimiento when 'D' then 1.00 else -1.00 end))">
		from HDContables a
			inner join CFinanciera cf
			on cf.CFcuenta=a.CFcuenta
			
			inner join GACMayor c
			on  c.Ecodigo = cf.Ecodigo
			and c.Cmayor  = cf.Cmayor				
		where a.Ecodigo    = #arguments.ecodigo#
		and   a.Eperiodo   = #arguments.GATperiodo#
		and   a.Emes       = #arguments.GATmes#
		and   a.Cconcepto  = #arguments.Cconcepto#
		and   a.Edocumento = #arguments.Edocumento#
		and <cf_dbfunction name="like" args="cf.CFformato,c.Cmascara">
		and (( 
				select count(1)
				from GATransacciones c
				where c.Ecodigo    = a.Ecodigo
				and   c.GATperiodo = a.Eperiodo
				and   c.GATmes     = a.Emes
				and   c.Cconcepto  = a.Cconcepto
				and   c.Edocumento = a.Edocumento
				and   c.CFcuenta   = a.CFcuenta  
			)) < 1
		group by cf.CFformato
		having sum(a.Dlocal * (case a.Dmovimiento when 'D' then 1.00 else -1.00 end)) <> 0
	</cfquery>

	<!--- Verifica que no existan transacciones sin conciliar en el documento --->
	<cfif fnDocumentoNoConciliado(arguments.conexion, arguments.ecodigo, arguments.GATperiodo, arguments.GATmes, arguments.Cconcepto, arguments.Edocumento)>
	<cfquery datasource="#arguments.conexion#">
		insert into #ERRORES# (MsgError, Valor)
		select 'Existen transacciones sin conciliar en el documento: ', <cf_dbfunction name="to_char" args="count(1)">
		from GATransacciones a
		where a.Ecodigo    = #arguments.ecodigo#
		  and a.GATperiodo = #arguments.GATperiodo#
		  and a.GATmes     = #arguments.GATmes#
		  and a.Cconcepto  = #arguments.Cconcepto#
		  and a.Edocumento = #arguments.Edocumento#
		  and a.GATestado < 2
	</cfquery>		
	</cfif>

	<!--- Verifica que no exista una placa repetida dentro del documento en adquisiciones --->
	<cfquery datasource="#arguments.conexion#">
		insert into #ERRORES# (MsgError, Valor, ID)
		select <cf_dbfunction name="concat" args="'La placa: ' , a.GATplaca ,' se encuentra más de una vez dentro del documento.'">, <cf_dbfunction name="to_char" args="count(1)">, min(a.ID)
		from GATransacciones a
		where a.Ecodigo    = #arguments.ecodigo#
		  and a.GATperiodo = #arguments.GATperiodo#
		  and a.GATmes     = #arguments.GATmes#
		  and a.Cconcepto  = #arguments.Cconcepto#
		  and a.Edocumento = #arguments.Edocumento#
		  and a.GATplaca is not null
		  and (select count(1)
				from Activos b
					inner join AFSaldos sa
					 on sa.Aid = b.Aid
					and sa.Ecodigo = b.Ecodigo
				where b.Aplaca = a.GATplaca
				  and b.Ecodigo = a.Ecodigo
				  and sa.AFSperiodo = a.GATperiodo
				  and sa.AFSmes = a.GATmes) < 1
		group by a.GATplaca
		having count(1) > 1
	</cfquery>		
	
	<!--- Verifica que todos los documentos están completos --->	
	<cfquery name="rsDocsIcompletos" datasource="#arguments.conexion#">
		INSERT into #ERRORES# (MsgError,Valor, ID)
		select 'Existen registros incompletos dentro de la relación', a.GATplaca, a.ID
		from GATransacciones a
		where a.Ecodigo    = #arguments.ecodigo#
		  and a.GATperiodo = #arguments.GATperiodo#
		  and a.GATmes     = #arguments.GATmes#
		  and a.Cconcepto  = #arguments.Cconcepto#
		  and a.Edocumento = #arguments.Edocumento#
		  and (
		  			a.GATperiodo is null 	
				or 	a.GATmes is null  
				or 	a.Cconcepto is null  
				or 	a.Edocumento is null  
				or 	a.GATfecha is null  
				or 	a.CFid is null 
				or 	a.CFid <= 0  
				or 	a.ACcodigo is null 
				or 	a.ACcodigo <= 0  
				or 	a.ACid is null 
				or 	a.ACid <= 0  
				or 	a.GATplaca is null 
				or coalesce(<cf_dbfunction name="length"  args="a.GATplaca">,0) = 0
<!---or 	coalesce({fn LENGTH(ltrim(rtrim(a.GATplaca)))},0) = 0 --->
				or 	a.GATdescripcion is null or coalesce(<cf_dbfunction name="length"  args="a.GATdescripcion">,0) = 0
<!---or 	a.GATdescripcion is null or coalesce({fn LENGTH(ltrim(rtrim(a.GATdescripcion)))},0) = 0 --->
				or 	a.AFMid is null or a.AFMid <= 0 
				or 	a.AFMMid is null or a.AFMMid <= 0 
				or 	a.AFCcodigo is null or a.AFCcodigo < 0 
				or 	a.GATfechainidep is null or coalesce(<cf_dbfunction name="length"  args="a.GATfechainidep">,0) = 0
<!---or 	a.GATfechainidep is null or coalesce({fn LENGTH(ltrim(rtrim(a.GATfechainidep)))},0) = 0--->
				or 	a.GATfechainirev is null or coalesce(<cf_dbfunction name="length"  args="a.GATfechainirev">,0) = 0
<!---or 	a.GATfechainirev is null or coalesce({fn LENGTH(ltrim(rtrim(a.GATfechainirev)))},0) = 0 --->
				or 	a.CFcuenta is null 
				or 	a.CFcuenta <= 0 
				or 	a.GATmonto is null
				or 	a.DEid is null   or a.DEid <= 0
				or 	a.CRCCid is null or a.CRCCid <= 0 
				or 	a.CRTDid is null or a.CRTDid <= 0 
			)
	</cfquery>
	
	<!--- Verifica que todos los documentos que tienen vales sean consistentes con la información ( CRDocumentoResponsabilidad ) --->	
	<!--- Verifica que la oficina que tiene Gestion, sea perteneciente al Centro Funcional --->	
	<cfquery name="rsVerificaValeVsGestion" datasource="#arguments.conexion#">
		INSERT into #ERRORES# (MsgError,Valor, ID)
		Select 'El activo tiene información diferente a la información del vale (Verifique que el vale este aplicado en control de responsables)',a.GATplaca, a.ID
		from GATransacciones a
		where a.Ecodigo 	= #arguments.ecodigo#
		  and a.GATperiodo 	= #arguments.GATperiodo#
		  and a.GATmes 		= #arguments.GATmes#
		  and a.Cconcepto 	= #arguments.Cconcepto#
		  and a.Edocumento 	= #arguments.Edocumento#
		  
		  and(select count(1) 
			    from CRDocumentoResponsabilidad b
			   where b.Ecodigo = a.Ecodigo
			   and b.CRDRplaca = a.GATplaca ) > 0
			   
		  and(select count(1) 
			   from CRDocumentoResponsabilidad b					
				  inner join CFuncional cf
				   on cf.CFid    = b.CFid
				  and cf.Ecodigo = b.Ecodigo	
			where b.Ecodigo = a.Ecodigo
			  and b.CRDRplaca = a.GATplaca
			  and b.CFid = a.CFid
			  and b.ACcodigo = a.ACcodigo
			  and b.ACid = a.ACid
			  <!--- Se tiene tolerancia con : and b.GATdescripcion = a.GATdescripcion --->
			  and b.AFMid = a.AFMid
			  and b.AFMMid = a.AFMMid
			  and b.AFCcodigo = a.AFCcodigo
			  <!--- Se tiene tolerancia con : and b.GATmonto = a.GATmonto --->
			  and b.DEid = a.DEid
			  and b.CRCCid = a.CRCCid
			  and b.CRTDid = a.CRTDid
			  and cf.Ocodigo = a.Ocodigo )< 1		
	</cfquery>	
	
	<!--- Verifica que todos los documentos que tienen vales sean consistentes con la información (AFResponsables) --->	
	<cfquery name="rsVerificaValeVsGestionMR" datasource="#arguments.conexion#">
		INSERT into #ERRORES# (MsgError,Valor, ID)
		Select 'El activo tiene información diferente a la información del vale', a.GATplaca, a.ID
		from GATransacciones a
		where a.Ecodigo    = #arguments.ecodigo#
		  and a.GATperiodo = #arguments.GATperiodo#
		  and a.GATmes     = #arguments.GATmes#
		  and a.Cconcepto  = #arguments.Cconcepto#
		  and a.Edocumento = #arguments.Edocumento#		
		  		
		  and (select count(1) 
			from Activos af
				inner join AFResponsables afr
				on  afr.Ecodigo = af.Ecodigo
				and afr.Aid = af.Aid
				and <cf_dbfunction name="now"> between afr.AFRfini and afr.AFRffin
			where af.Ecodigo = a.Ecodigo
			  and af.Aplaca  = a.GATplaca) > 0
			  
		  and (select count(1)
			     from Activos b
				  inner join AFResponsables c
					on c.Ecodigo = b.Ecodigo
				   and c.Aid     = b.Aid
				   
				 inner join CFuncional cf
					on cf.CFid = c.CFid
				   and cf.Ecodigo = c.Ecodigo
					
			where b.Ecodigo  = a.Ecodigo
			  and b.Aplaca   = a.GATplaca
			  and b.ACcodigo = a.ACcodigo
			  and b.ACid     = a.ACid
			  <!--- Se tiene tolerancia con : and b.Adescripcion = a.GATdescripcion --->
			  and b.AFMid    = a.AFMid
			  and b.AFMMid   = a.AFMMid
		  	  and b.AFCcodigo= a.AFCcodigo 
			  and <cf_dbfunction name="now"> between c.AFRfini and c.AFRffin
			  and c.CFid = a.CFid
			  <!--- Se tiene tolerancia con : and c.Monto = a.GATmonto --->
			  and c.DEid = a.DEid
			  and c.CRCCid = a.CRCCid
			  and c.CRTDid = a.CRTDid
			  <!--- Verifica que la oficina que tiene Gestion, sea perteneciente al Centro Funcional --->	
			  and cf.Ocodigo = a.Ocodigo)< 1				
	</cfquery>
	
	<!--- Verifica si el documento ya fue procesado --->
	<cfquery name="rsValProcesamiento" datasource="#arguments.conexion#">
		INSERT into #ERRORES# (MsgError,Valor)
		select 'Error, El documento ya fue procesado. Proceso Cancelado!', EAcpdoc
		from EAadquisicion 
		where Ecodigo   = #arguments.ecodigo#
		and EAcpidtrans = 'GA'
		and EAcpdoc     = '#arguments.GATperiodo##numberformat(arguments.GATmes, "00")##arguments.Cconcepto#-#arguments.Edocumento#'
	</cfquery>
	
	<!--- Valida que no vayan transacciones de adquisicion con monto negativos --->
	<cfquery name="rsValAdq" datasource="#arguments.conexion#">
		INSERT into #ERRORES# (MsgError,Valor, ID)
		Select 'La transaccion de adquisicin presenta un monto negativo', a.GATplaca, a.ID
		from GATransacciones a
		where a.Ecodigo 		= #arguments.ecodigo#
			and a.GATperiodo 	= #arguments.GATperiodo#
			and a.GATmes 		= #arguments.GATmes#
			and a.Cconcepto 	= #arguments.Cconcepto#
			and a.Edocumento 	= #arguments.Edocumento#
			and a.GATmonto < 0
			and ( 
				select count(1) 
				from Activos b 
				where b.Ecodigo = a.Ecodigo
				  and b.Aplaca = a.GATplaca
				) < 1
	</cfquery>	
	
	<!--- Valida que no vayan transacciones de mejora con vida util negativa --->
	<cfquery name="rsValMej" datasource="#arguments.conexion#">
		INSERT into #ERRORES# (MsgError,Valor, ID)
		select 'La transacción de mejora tiene una vida util negativa', a.GATplaca, a.ID
		from GATransacciones a
			inner join Activos b
			on  b.Ecodigo = a.Ecodigo
			and b.Aplaca  = a.GATplaca
		where a.Ecodigo 		= #arguments.ecodigo#
			and a.GATperiodo 	= #arguments.GATperiodo#
			and a.GATmes 		= #arguments.GATmes#
			and a.Cconcepto 	= #arguments.Cconcepto#
			and a.Edocumento 	= #arguments.Edocumento#
			and a.GATmonto > 0
			and a.GATvutil < 0
	</cfquery>	
	
	
	<!--- Valida que no vayan transacciones de retiro sin motivo de retiro --->
	<cfquery name="rsValRet" datasource="#arguments.conexion#">
		INSERT into #ERRORES# (MsgError,Valor, ID)
		select 'La transaccin de retiro no tiene definido un motivo',a.GATplaca, a.ID
		from GATransacciones a
			inner join Activos b
			on  b.Ecodigo = a.Ecodigo
			and b.Aplaca  = a.GATplaca
		where a.Ecodigo 	= #arguments.ecodigo#
		  and a.GATperiodo 	= #arguments.GATperiodo#
		  and a.GATmes 		= #arguments.GATmes#
		  and a.Cconcepto 	= #arguments.Cconcepto#
		  and a.Edocumento 	= #arguments.Edocumento#
		  and a.GATmonto < 0
		  and a.AFRmotivo is null
	</cfquery>
	
	<!--- Verifica que los centros funcionales esten asociados a un centro de custodia para las adquisiciiones--->
	<cfquery name="rstemp" datasource="#arguments.conexion#">
		INSERT into #ERRORES# (MsgError,Valor, ID)
		select 'El Centro Funcional no est asociado a ningn Centro de Custodia', a.GATplaca, a.ID
		from GATransacciones a
		where a.Ecodigo     = #arguments.ecodigo#
		  and a.GATperiodo 	= #arguments.GATperiodo#
		  and a.GATmes 		= #arguments.GATmes#
		  and a.Cconcepto 	= #arguments.Cconcepto#
		  and a.Edocumento 	= #arguments.Edocumento#
		  and a.GATestado   = 2
		  and a.GATplaca 	is not null
		  and not exists (
			select 1
			from CRCCCFuncionales b
			where b.CFid = a.CFid
			)
		  and not exists (	
		  	select 1
			from Activos b
			where b.Ecodigo = a.Ecodigo
			  and b.Aplaca  = a.GATplaca
			)
	</cfquery>

	<!--- valida saldos en cero en las adquisiciones--->
	<cfquery name="rsValidaSaldos" datasource="#arguments.conexion#">
		INSERT into #ERRORES# (MsgError, Valor, ID)
		select 'El Activo no tiene saldos para el periodo-mes: (#paramPeriodo#-#paramMes#)', a.GATplaca, a.ID
		from GATransacciones a
			inner join Activos b
			 on b.Ecodigo = a.Ecodigo
			and b.Aplaca  = a.GATplaca
		where a.Ecodigo     = #arguments.ecodigo#
		  and a.GATperiodo 	= #arguments.GATperiodo#
		  and a.GATmes 		= #arguments.GATmes#
		  and a.Cconcepto 	= #arguments.Cconcepto#
		  and a.Edocumento 	= #arguments.Edocumento#
		  and a.GATestado 	= 2
		  and a.GATmonto 	<> 0
		  and a.GATplaca 	is not null
		  and ((
			select count(1)
			from AFSaldos c
			where c.Aid        = b.Aid
			  and c.Ecodigo    = b.Ecodigo
			  and c.AFSperiodo = #paramPeriodo#
			  and c.AFSmes     = #paramMes#
			)) < 1 
	</cfquery>
			
	<!--- Verifica que el activo no este con una transaccion de mejora pendiente --->		
	<cfquery name="rsValidaSaldos" datasource="#arguments.conexion#">
		INSERT into #ERRORES# (MsgError, Valor, ID)
		select 'El Activo tiene transacciones de mejora pendiente de aplicar', a.GATplaca, a.ID
		from GATransacciones a
			inner join Activos b
			 on b.Ecodigo = a.Ecodigo
			and b.Aplaca  = a.GATplaca
		where a.Ecodigo     = #arguments.ecodigo#
		  and a.GATperiodo 	= #arguments.GATperiodo#
		  and a.GATmes 		= #arguments.GATmes#
		  and a.Cconcepto 	= #arguments.Cconcepto#
		  and a.Edocumento 	= #arguments.Edocumento#
		  and a.GATestado 	= 2
		  and a.GATmonto 	<> 0
		  and a.GATplaca 	is not null
		  and ((
			select count(1)
			from ADTProceso tm
			where tm.Aid 	   = b.Aid
			  and tm.Ecodigo   = b.Ecodigo
			  and tm.TAperiodo = #paramPeriodo#
			  and tm.TAmes     = #paramMes#
			  and tm.IDtrans   = 2
			)) > 1 
	</cfquery>

	<!--- Verifica que el activo no este con una transaccion de retiro pendiente --->		
	<cfquery name="rsValidaSaldos" datasource="#arguments.conexion#">
		INSERT into #ERRORES# (MsgError, Valor, ID)
		select 'El Activo tiene transacciones de retiro pendiente de aplicar', a.GATplaca, a.ID
		from GATransacciones a
			inner join Activos b
			 on b.Ecodigo = a.Ecodigo
			and b.Aplaca  = a.GATplaca
		where a.Ecodigo     = #arguments.ecodigo#
		  and a.GATperiodo 	= #arguments.GATperiodo#
		  and a.GATmes 		= #arguments.GATmes#
		  and a.Cconcepto 	= #arguments.Cconcepto#
		  and a.Edocumento 	= #arguments.Edocumento#
		  and a.GATestado 	= 2
		  and a.GATmonto 	<> 0
		  and a.GATplaca 	is not null
		  and ((
			select count(1)
			from ADTProceso tm
			where tm.Aid 	   = b.Aid
			  and tm.Ecodigo   = b.Ecodigo
			  and tm.TAperiodo = #paramPeriodo#
			  and tm.TAmes     = #paramMes#
			  and tm.IDtrans   = 5
			)) > 1 
	</cfquery>


	<!--- Verifica que el activo no este completamente depreciado y la mejora no toque la VU --->
	<cfquery datasource="#arguments.conexion#" name="saldovuAct">
		INSERT into #ERRORES# (MsgError, Valor, ID)
		select 'El activo está completamente depreciado y no se le está mejorando la vida útil:', a.GATplaca, a.ID
		from GATransacciones a
			inner join Activos b 
			on  a.GATplaca  = b.Aplaca
			and a.Ecodigo  = b.Ecodigo

			inner join AFSaldos c
			on  c.Aid        = b.Aid
			and c.Ecodigo    = b.Ecodigo
			and c.AFSperiodo = #paramPeriodo#
			and c.AFSmes     = #paramMes#
			and c.AFSsaldovutiladq = 0
					
		where a.Ecodigo     = #arguments.ecodigo#
		  and a.GATperiodo 	= #arguments.GATperiodo#
		  and a.GATmes 		= #arguments.GATmes#
		  and a.Cconcepto 	= #arguments.Cconcepto#
		  and a.Edocumento 	= #arguments.Edocumento#
		  and a.GATestado 	= 2
		  and a.GATmonto 	> 0
		  and a.GATplaca 	is not null
		  and a.GATvutil    = 0
	</cfquery>


	<!--- 
			Se valida en los retiros que no se esté retirando un monto mayor que el monto disponible de los saldos del activo
			Se debe de considerar el valor de rescate del activo para no retirar un monto mayor que el disponible
			NOTA: La validación se hace sumando el monto en GATmonto porque este está grabado en negativo 
	--->
	<cfquery datasource="#arguments.conexion#" name="saldovuAct">
		INSERT into #ERRORES# (MsgError, Valor, ID)
		select 
			case 
			when (c.AFSvaladq + c.AFSvalmej + c.AFSvalrev) - (c.AFSdepacumadq + c.AFSdepacummej + c.AFSdepacumrev) - b.Avalrescate + a.GATmonto < 0
				then 'El monto a retirar para la placa es mayor que el valor en libros del Activo'
			when (c.AFSvaladq + c.AFSvalmej - b.Avalrescate) < 0
				then 'El monto a retirar para la placa es es mayor que el costo del Activo'
			end	
			, a.GATplaca, a.ID
		from GATransacciones a
			inner join Activos b 
			on  a.GATplaca  = b.Aplaca
			and a.Ecodigo  = b.Ecodigo

			inner join AFSaldos c
			on  c.Aid        = b.Aid
			and c.Ecodigo    = b.Ecodigo
			and c.AFSperiodo = #paramPeriodo#
			and c.AFSmes     = #paramMes#
					
		where a.Ecodigo     = #arguments.ecodigo#
		  and a.GATperiodo 	= #arguments.GATperiodo#
		  and a.GATmes 		= #arguments.GATmes#
		  and a.Cconcepto 	= #arguments.Cconcepto#
		  and a.Edocumento 	= #arguments.Edocumento#
		  and a.GATestado 	= 2
		  and a.GATmonto 	< 0
		  and a.GATplaca 	is not null
		  and (
		  		(c.AFSvaladq + c.AFSvalmej + c.AFSvalrev) - (c.AFSdepacumadq + c.AFSdepacummej + c.AFSdepacumrev) - b.Avalrescate + a.GATmonto < 0
		  	or
				(c.AFSvaladq + c.AFSvalmej - b.Avalrescate) < 0
			   )
	</cfquery>

	<!--- Valida que las adquisiciones tengan únicamente un vale en tránsito, para las adquisiciones --->
	<cfquery datasource="#arguments.conexion#" name="saldovuAct">
		insert into #ERRORES# (MsgError, Valor, ID)
		select 'La transacción de adquisición tiene más de un documento en Tránsito', a.GATplaca, a.ID
		from GATransacciones a
		where a.Ecodigo    = #arguments.ecodigo#
		  and a.GATperiodo = #arguments.GATperiodo#
		  and a.GATmes     = #arguments.GATmes#
		  and a.Cconcepto  = #arguments.Cconcepto#
		  and a.Edocumento = #arguments.Edocumento#
		  and a.GATplaca is not null
		  and (select count(1)
				from Activos b
					inner join AFSaldos sa
					on sa.Aid = b.Aid
					and sa.Ecodigo = b.Ecodigo
					
				where b.Aplaca = a.GATplaca
				  and b.Ecodigo = a.Ecodigo
				  and sa.AFSperiodo = a.GATperiodo
				  and sa.AFSmes = a.GATmes) < 1
			and (select count(1)
					from CRDocumentoResponsabilidad b
					where b.Ecodigo = a.Ecodigo
					and b.CRDRplaca = a.GATplaca ) > 1
	</cfquery>	
<!---Valida que exista un documento en transito--->
	<cfquery datasource="#arguments.conexion#" name="saldovuAct">
		insert into #ERRORES# (MsgError, Valor, ID)
		select 'La transacción de adquisición no tiene un documento en Tránsito', a.GATplaca, a.ID
		from GATransacciones a
		where a.Ecodigo    = #arguments.ecodigo#
		  and a.GATperiodo = #arguments.GATperiodo#
		  and a.GATmes     = #arguments.GATmes#
		  and a.Cconcepto  = #arguments.Cconcepto#
		  and a.Edocumento = #arguments.Edocumento#
		  and a.GATplaca is not null
		  and (select count(1)
				from Activos b
					inner join AFSaldos sa
					on sa.Aid = b.Aid
					and sa.Ecodigo = b.Ecodigo		
				where b.Aplaca = a.GATplaca
				  and b.Ecodigo = a.Ecodigo
				  and sa.AFSperiodo = a.GATperiodo
				  and sa.AFSmes = a.GATmes) < 1
				  
			and (select count(1)
					from CRDocumentoResponsabilidad b
					where b.Ecodigo = a.Ecodigo
					and b.CRDRplaca = a.GATplaca ) = 0
					
			and (select count(1) 
				  from AClasificacion c 
				 where c.Ecodigo     = a.Ecodigo
				 and   c.ACid        = a.ACid
				 and   c.ACcodigo    = a.ACcodigo
				 and   c.ACexigeVale = 'S' ) > 0
	</cfquery>	

	<!--- Valida que las transacciones sobre activos existentes no tengan más de vale Vigente --->
	<cfquery datasource="#arguments.conexion#">
		insert into #ERRORES# (MsgError, Valor, ID)
		select 'El Activo está inconsistente posee más de un vale de Responsabilidad', a.GATplaca, a.ID
		from GATransacciones a
			inner join Activos b
			on b.Ecodigo = a.Ecodigo
			and b.Aplaca = a.GATplaca
		where a.Ecodigo    = #arguments.ecodigo#
		  and a.GATperiodo = #arguments.GATperiodo#
		  and a.GATmes     = #arguments.GATmes#
		  and a.Cconcepto  = #arguments.Cconcepto#
		  and a.Edocumento = #arguments.Edocumento#
		  and a.GATplaca is not null
		  and (
				select count(1)
				from AFResponsables afr
				where afr.Aid     = b.Aid
				  and afr.Ecodigo = b.Ecodigo
				  and <cf_dbfunction name="now"> between afr.AFRfini and afr.AFRffin
				) > 1
	</cfquery>	
		<!--- Valida que las transacciones sobre activos existentes tengan un vale Activo(Si possen vales inactivos entran en la validacion) --->
	<cfquery datasource="#arguments.conexion#">
		insert into #ERRORES# (MsgError, Valor, ID)
		select 'El Activo está inconsistente no posee vale de Responsabilidad ACTIVO', a.GATplaca, a.ID
		from GATransacciones a
			inner join Activos b
			on b.Ecodigo = a.Ecodigo
			and b.Aplaca = a.GATplaca
		where a.Ecodigo    = #arguments.ecodigo#
		  and a.GATperiodo = #arguments.GATperiodo#
		  and a.GATmes     = #arguments.GATmes#
		  and a.Cconcepto  = #arguments.Cconcepto#
		  and a.Edocumento = #arguments.Edocumento#
		  and a.GATplaca is not null
		  and (
				select count(1)
				from AFResponsables afr
				where afr.Aid     = b.Aid
				  and afr.Ecodigo = b.Ecodigo
				  and <cf_dbfunction name="now"> between afr.AFRfini and afr.AFRffin
				) < 1
		
	</cfquery>	

	<!--- Valida que las transacciones de retiros no se encuentren en la cola de procesos de Activos --->
	<cfquery datasource="#arguments.conexion#">
		insert into #ERRORES# (MsgError, Valor, ID)
		select 'El Activo con transacción de retiro en la Cola de Procesos. No se puede procesar en este momento', a.GATplaca, a.ID
		from GATransacciones a
			inner join Activos b
			on b.Ecodigo = a.Ecodigo
			and b.Aplaca = a.GATplaca
		where a.Ecodigo    = #arguments.ecodigo#
		  and a.GATperiodo = #arguments.GATperiodo#
		  and a.GATmes     = #arguments.GATmes#
		  and a.Cconcepto  = #arguments.Cconcepto#
		  and a.Edocumento = #arguments.Edocumento#
		  and a.GATplaca is not null
		  and a.GATmonto   < 0
		  and (
		  		select count(1)			
				from CRColaTransacciones cp
				where cp.Aid = b.Aid
			) > 0
	</cfquery>
<!---Valida de la existencia de cuentas de relacion--->
	<cfquery datasource="#arguments.conexion#">
		insert into #ERRORES# (MsgError, Valor, ID)
		Select 	<cf_dbfunction name="concat" args="'No existe la cuenta de relación de la oficina: ' , ofi2.Oficodigo , ' a la oficina  ' , ofi1.Oficodigo">, a.GATplaca, a.ID
		from GATransacciones a
			inner join Oficinas ofi1
				on ofi1.Ocodigo = a.Ocodigo
			   and ofi1.Ecodigo = a.Ecodigo
			   
			inner join Oficinas ofi2
				on ofi2.Ocodigo = a.OcodigoAnt
			   and ofi2.Ecodigo = a.Ecodigo
		where a.Ecodigo    = #arguments.ecodigo#
		  and a.GATperiodo = #arguments.GATperiodo#
		  and a.GATmes     = #arguments.GATmes#
		  and a.Cconcepto  = #arguments.Cconcepto#
		  and a.Edocumento = #arguments.Edocumento#
		  and a.OcodigoAnt is not null
		  and a.Ocodigo   <> a.OcodigoAnt
		  and (
		  	not exists (	
				select 1
				from CuentaBalanceOficina cb
						inner join ConceptoContable b
							 on b.Ecodigo   = cb.Ecodigo
							and b.Cconcepto = cb.Cconcepto
							and b.Oorigen = 'AFGA'
				where cb.Ecodigo     = a.Ecodigo
				  and cb.Ocodigoori  = a.OcodigoAnt
				  and cb.Ocodigodest = a.Ocodigo )

		   or 
		   	not exists (	
				select 1
				from CuentaBalanceOficina cb
						inner join ConceptoContable b
							 on b.Ecodigo   = cb.Ecodigo
							and b.Cconcepto = cb.Cconcepto
							and b.Oorigen   = 'AFGA'
				where cb.Ecodigo     = a.Ecodigo
				  and cb.Ocodigoori  = a.Ocodigo
				  and cb.Ocodigodest = a.OcodigoAnt ) 
			  )
		</cfquery>

	<cfquery name="rsErr" datasource="#arguments.conexion#" maxrows="110">
		Select *
		from #ERRORES#
		order by MsgError
	</cfquery>	
	<cfreturn rsErr>
</cffunction>