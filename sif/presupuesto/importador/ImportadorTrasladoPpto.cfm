<cfscript>
	bcheck1 = false; // Checa Empresa
	bcheck2 = false; // Checa Periodo 
	bcheck3 = false; // Checa Mes 
	bcheck4 = false; // Checa Cuenta Presupuestal Origen
	bcheck5 = false; // Checa Cuenta Presupuestal Destingo
	bcheck6 = false; // Checa Montos que no sean menores o iguales a 0.00
	bcheck7 = false; // Checa quen no existan registros capturados manualmente
</cfscript>

<!--- Checa Validez de la Empresa--->
<cfquery name="rsCheck1" datasource="#Session.DSN#">
		select count(1) as check1
		from #table_name# a
		where not exists(
			select 1
			from Empresas b
			where b.Ecodigo = a.Ecodigo)
</cfquery>
<cfset bcheck1 = rsCheck1.check1 LT 1>

<!--- Checa Validez del Periodo --->
<cfif bcheck1>
	<cfquery name="rsCheck2" datasource="#Session.DSN#">
		select count(1) as check2
		from #table_name# a
		where not exists(
			select 1
			from CPDocumentoE b
			where b.CPCano = a.Periodo
			and CPDEid = #Session.CPDEid#
			and b.Ecodigo = #Session.Ecodigo#)
	</cfquery>
	<cfset bcheck2 = rsCheck2.check2 LT 1>
</cfif>

<!--- Checa Validez del Mes--->
<cfif bcheck2>
	<cfquery name="rsCheck3" datasource="#Session.DSN#">
		select count(1) as check3
		from #table_name# a
		where not exists(
			select 1
			from CPDocumentoE b
			where b.CPCmes = a.Mes
			and b.CPDEid = #Session.CPDEid#
			and b.Ecodigo = #Session.Ecodigo#)
	</cfquery>
	<cfset bcheck3 = rsCheck3.check3 LT 1>
</cfif>


<!--- Checa Validez de la Cuenta Origen--->
<cfif bcheck3>
 	 <cfquery name="rsCheck4" datasource="#Session.DSN#">
            select count(1) as check4
            from #table_name# a
             where a.CuentaOrigen is not null
             and rtrim(a.CuentaOrigen) <> ''
             and not exists(
                select 1
                from CPresupuesto b
                where b.CPformato = a.CuentaOrigen)
      </cfquery>
	  <cfset bcheck4 = rsCheck4.check4 LT 1>
</cfif>

<!--- Checa Validez de la Cuenta Destino--->
<cfif bcheck4>
	    <cfquery name="rsCheck5" datasource="#Session.DSN#">
            select count(1) as check5
            from #table_name# a
             where a.CuentaDestino is not null
             and rtrim(a.CuentaDestino) <> ''
             and not exists(
                select 1
                from CPresupuesto b
                where b.CPformato = a.CuentaDestino
				and Ecodigo = #Session.Ecodigo#)
        </cfquery>
        <cfset bcheck5 = rsCheck5.check5 LT 1>
</cfif>

<!----Checa que no se introduzcan montos menores o iguales a 0)--->
<cfif bcheck5>
	<cfquery name="rsActualizaMontos" datasource="#Session.DSN#">
		update #table_name#
			set Monto = coalesce(Monto, 0.00)
		where Monto is null 
	</cfquery>
	
	<cfquery name="rsCheck6" datasource="#Session.DSN#">
		select count(1) as check6
		from #table_name#
		where Monto <= 0
	</cfquery>
	
	<cfset bcheck6 = rsCheck6.check6 LT 1>
</cfif>

<!----Checa que no existan registros introducidos a mano--->
<cfif bcheck6>
	<cfquery name="rsCheck7" datasource="#Session.DSN#">
		select count(1) as check7
		from #table_name# 		
			where exists (select 1 
			from CPDocumentoD
			where CPDEid = #Session.CPDEid#
			and Ecodigo = #Session.Ecodigo#)
	</cfquery>
	
    <cfset bcheck7 = rsCheck7.check7 LT 1>
</cfif>

<cfif bcheck7>
	<cftransaction action="begin">
	<cftry>	
		<cfquery name="rsRegistros" datasource="#Session.DSN#">
			select Ecodigo, Periodo, Mes, CuentaOrigen, CuentaDestino, Monto
			from #table_name#
		</cfquery>
	
		<cfquery name="rsEnc" datasource="#Session.DSN#">
			select CPPid, CPCano, CPCmes
			from CPDocumentoE
			where CPDEid = #Session.CPDEid#
			and Ecodigo = #Session.Ecodigo#
		</cfquery>
		
		<cfset varLinea = 1>
		
		<cfloop query="rsRegistros">
			<!----Se obtiene la cuenta---->
			<cfquery name="rsCuentaDism" datasource="#Session.DSN#">
				select CPcuenta 
				from CPresupuesto
				where CPformato = '#rsRegistros.CuentaOrigen#'
			</cfquery>
		
			<!----Cuenta que disminuye---->
			<cfquery name="rsCPDocumentoD" datasource="#Session.DSN#">
				insert into CPDocumentoD(
					Ecodigo,
					CPDEid,
					CPDDlinea,
					CPDDtipo,
					CPPid,
					CPCano,
					CPCmes,
					CPcuenta,
					Ocodigo,
					CPDDmonto,
					CPDDsaldo,
					CPDDtipoItem)
				values (#rsRegistros.Ecodigo#,
					#Session.CPDEid#,
					#varLinea# * -1,
					-1,
					#rsEnc.CPPid#,
					#rsEnc.CPCano#,
					#rsEnc.CPCmes#,
					#rsCuentaDism.CPcuenta#,
					0,
					#rsRegistros.Monto#,
					#rsRegistros.Monto#,
					0)
			</cfquery>
		
			<!----Se obtiene la cuenta---->
			<cfquery name="rsCuentaIncr" datasource="#Session.DSN#">
				select CPcuenta 
				from CPresupuesto
				where CPformato = '#rsRegistros.CuentaDestino#'
			</cfquery>
		
			<!----Cuenta que disminuye---->
			<cfquery name="rsCPDocumentoD" datasource="#Session.DSN#">
				insert into CPDocumentoD(
					Ecodigo,
					CPDEid,
					CPDDlinea,
					CPDDtipo,
					CPPid,
					CPCano,
					CPCmes,
					CPcuenta,
					Ocodigo,
					CPDDmonto,
					CPDDsaldo,
					CPDDtipoItem)
			values (#rsRegistros.Ecodigo#,
					#Session.CPDEid#,
					#varLinea#,
					1,
					#rsEnc.CPPid#,
					#rsEnc.CPCano#,
					#rsEnc.CPCmes#,
					#rsCuentaIncr.CPcuenta#,
					0,
					#rsRegistros.Monto#,
					#rsRegistros.Monto#,
					0)
			</cfquery>
		
		<cfset varLinea = VarLinea + 1>	
		</cfloop> 
	<cftransaction action="commit"/>
	<cfcatch>
	<cftransaction action="rollback"/>
		<cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
		<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
	    <cfthrow message="#cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">
	</cfcatch>
	</cftry>
	</cftransaction>
<cfelse>
	<cfif not bcheck1>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'Código de empresa incorrecto' as MSG, a.Ecodigo as EMPRESA
			from #table_name# a
			where not exists(select 1
				from Empresas b
				where b.Ecodigo = a.Ecodigo)			
		</cfquery>

	<cfelseif not bcheck2>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'Periodo no corresponde al registro del encabezado' as MSG, a.Periodo as PERIODO
			from #table_name# a
			where not exists(select 1 from CPDocumentoE b
			where b.CPCano = a.Periodo
			and CPDEid = #Session.CPDEid#
			and b.Ecodigo = #Session.Ecodigo#)
		</cfquery>
		
	<cfelseif not bcheck3>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'Mes no corresponde al registro del encabezado' as MSG, a.Mes as MES
			from #table_name# a
			where not exists(
					select 1
					from CPDocumentoE b
					where b.CPCmes = a.Mes
					and b.CPDEid = #Session.CPDEid#
					and b.Ecodigo = #Session.Ecodigo#)
		</cfquery>
	<cfelseif not bcheck4>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'La cuenta origen no es valida' as MSG, a.CuentaOrigen as CUENTA_ORIGEN
			from #table_name# a
      		where a.CuentaOrigen is not null
            and rtrim(ltrim(a.CuentaOrigen)) <> ''
            and not exists(
                select 1
                from CPresupuesto b
                where b.CPformato = a.CuentaOrigen)
		</cfquery>
	<cfelseif not bcheck5>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'La cuenta destino no es valida' as MSG, a.CuentaDestino as CUENTA_ORIGEN
			from #table_name# a
      		where a.CuentaDestino is not null
            and rtrim(ltrim(a.CuentaDestino)) <> ''
            and not exists(
                select 1
                from CPresupuesto b
                where b.CPformato = a.CuentaDestino)
		</cfquery>
	<cfelseif not bcheck6>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'El monto a transferir debe ser mayor a 0.00' as MSG, a.Monto as MONTO
			from #table_name# a
            where Monto <= 0
		</cfquery>
	<cfelseif not bcheck7>
		<cfquery name="ERR" datasource="#session.DSN#">
			select 'Debe eliminar registros insertados manualmente' as MSG
		</cfquery>
	</cfif>	
</cfif>

