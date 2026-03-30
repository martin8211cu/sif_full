<cfsetting requesttimeout="1800">
<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<!----<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>---->

<cf_dbtemp name="ID18tmp_V3" returnvariable="CFformatos" datasource="#session.DSN#">
	<cf_dbtempcol name="CFformatoSF" type="varchar(100)"  mandatory="yes">
	<cf_dbtempcol name="CmayorSF"    type="varchar(4)"    mandatory="no">
	<cf_dbtempcol name="CdetSF"      type="varchar(100)"  mandatory="no">
	<cf_dbtempcol name="CFcuenta"    type="numeric"       mandatory="no">
	<cf_dbtempcol name="Ccuenta"     type="numeric"       mandatory="no">
	<cf_dbtempcol name="CFformato"   type="varchar(100)"  mandatory="no">
</cf_dbtemp>			

<cf_dbtemp name="Detalles" returnvariable="Detalles" datasource="#session.DSN#">
	<cf_dbtempcol name="ID" type="numeric" mandatory="yes">
	<cf_dbtempcol name="Cmayor" type="varchar(10)"  mandatory="yes">
	<cf_dbtempcol name="CFformato" type="varchar(100)" mandatory="yes">
	<cf_dbtempcol name="CFcuenta" type="numeric" mandatory="yes">
	<cf_dbtempcol name="Ccuenta" type="numeric" mandatory="yes">
	<cf_dbtempcol name="SaldoContable" type="money"  mandatory="yes">
	<cf_dbtempcol name="SaldoConvertido" type="money" mandatory="yes">
    <cf_dbtempcol name="Tipo" type="varchar(1)" mandatory="yes"> 
	<cf_dbtempcol name="Monto" type="money" mandatory="yes">
	<cf_dbtempcol name="Naturaleza" type="varchar(1)" mandatory="yes"> 
</cf_dbtemp>


<cfquery name="rsVariables" datasource="#session.DSN#">
	select convert (datetime, convert(varchar(4),#Form.fltPeriodo#)+right(('0'+convert(varchar,#Form.fltMes#)),2)+'25')    as Fecha, right(('0'+convert(varchar,#Form.fltMes#)),2) as Mes			
</cfquery>

<!----Periodo Contable--->
<cfquery name="rsAnoContable" datasource="#session.DSN#">
 	select Pvalor as Ano from Parametros 
	where Pcodigo = 30 
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!----Mes Contable--->
<cfquery name="rsMesContable" datasource="#session.DSN#">
 	select Pvalor as Mes from Parametros 
	where Pcodigo = 40 
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!----Oficina--->
<cfquery name="rsOficina" datasource="#session.DSN#">
	select Ocodigo, Oficodigo from Oficinas 
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!----Centro Funcional--->
<cfquery name="rsCFuncional" datasource="#session.DSN#">
	select CFid, CFcodigo, CFdescripcion from CFuncional 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!----Moneda Local--->
<cfquery name="rsMoneda" datasource="#session.DSN#">
	select Mcodigo from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>


<!----Cuenta para segunda conversión B15--->
<cfquery name="rsCtaB15_2" datasource="#session.DSN#">
	select Ccuenta, CFcuenta, CFformato, CmayorSF,
    Naturaleza = (select Cbalancen from CtasMayor where Cmayor = CF.Cmayor and Ecodigo = CF.Ecodigo)				    				    
	from CFinanciera CF
	where CF.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    and CFcuenta = convert(integer,(select Pvalor from Parametros 
    								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                                    and Pcodigo = 3700))
</cfquery>

<cfset Validacion = 2>
<cfif Form.fltPeriodo LT rsAnoContable.Ano>
	<cfset Validacion = 2>
<cfelseif rsAnoContable.Ano EQ Form.fltPeriodo and Form.fltMes EQ rsMesContable.Mes>	
	<cfset Validacion = 1>	
</cfif>

<cfif Validacion EQ 1>
	<cfthrow message="No se puede generar el efecto de conversión de un periodo que no se ha cerrado contablemente">
</cfif> 

	<cfset LvarCconcepto      = 300>
	<cfset LvarEperiodo       = Form.fltPeriodo>
	<cfset LvarEmes           = Form.fltMes>
	<cfset LvarEfecha         = rsVariables.Fecha>
	<cfset LvarEdescripcion   = 'Resultado de Conversión a Moneda Informe'>
	<cfset LvarEdocbase       = #Form.fltPeriodo#&rsVariables.Mes>
	<cfset LvarEreferencia    = ''>
	<cfset LvarFalta          = rsVariables.Fecha>
	<cfset LvarECIreversible  = 0>
    
<cfquery name="rsRegistrosContables" datasource="#session.DSN#">
	select distinct F.CmayorSF, F.CFformato, F.CFcuenta, F.Ccuenta, sum(((S.SLinicial+DLdebitos)-CLcreditos)) as SaldoContable,
    Naturaleza = (select Cbalancen from CtasMayor where Cmayor = F.CmayorSF and Ecodigo = F.Ecodigo)					    				    from SaldosContables S 
	inner join CFinanciera F on S.Ccuenta = F.Ccuenta and F.Ecodigo = S.Ecodigo
	where S.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and S.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.fltPeriodo#">
	and S.Smes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.fltMes#"> 
	and CFmovimiento = 'S'
    and S.Ccuenta != #rsCtaB15_2.Ccuenta#
	group by F.CmayorSF, S.Ccuenta, F.CFformato, F.CFcuenta, F.Ccuenta, F.Ecodigo
</cfquery>

<cfquery name="rsConvertidos" datasource="#session.DSN#">
	select distinct SC.Ccuenta, SC.Speriodo, SC.Smes, SC.Ecodigo, sum(SLSaldoFinal) as SaldoConvertido 						    
    from SaldosContablesConvertidos SC
	inner join CFinanciera CF on CF.Ccuenta = SC.Ccuenta and CF.Ecodigo = SC.Ecodigo 
	where SC.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and SC.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.fltPeriodo#">
	and SC.Smes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.fltMes#"> 
	and B15 = 2 
	and CFmovimiento = 'S'
    and SC.Ccuenta != #rsCtaB15_2.Ccuenta#
	group by SC.Ccuenta,SC.Speriodo, SC.Smes, SC.Ecodigo
</cfquery>
	
<cfif rsConvertidos.recordcount EQ 0>
	<cfthrow message="No hay registros para la póliza">
</cfif>

<cfset ID = 1>
<cfloop query="rsRegistrosContables">
	<cfquery datasource="#session.DSN#">
   		insert into #Detalles#(ID,
        					 Cmayor,
							 CFformato,
							 CFcuenta,
							 Ccuenta,
							 SaldoContable,
							 SaldoConvertido,
	    					 Tipo,
                             Monto,
                             Naturaleza) 
 						values(#ID#,
                        	 '#rsRegistrosContables.CmayorSF#',
                         	 '#rsRegistrosContables.CFformato#', 
                             #rsRegistrosContables.CFcuenta#, 
                             #rsRegistrosContables.Ccuenta#, 
                             #rsRegistrosContables.SaldoContable#, 
                             0,
                             '',
                             0,
                             '#rsRegistrosContables.Naturaleza#')
    </cfquery>
    <cfset ID = ID + 1>
</cfloop>

<cfloop query="rsConvertidos">
	<cfquery datasource="#session.DSN#">
    	update #Detalles# set SaldoConvertido = isnull(#rsConvertidos.SaldoConvertido#,0) 
        where Ccuenta = #rsConvertidos.Ccuenta#	 
	</cfquery>
</cfloop>

<cfquery datasource="#session.DSN#">
	delete #Detalles# where SaldoContable = SaldoConvertido 
</cfquery>

<cfquery name="RegistrosDif" datasource="#session.DSN#">
	select * from #Detalles# where SaldoContable != SaldoConvertido -----and Ccuenta != #rsCtaB15_2.Ccuenta#
</cfquery>

<cfloop query="RegistrosDif">
	<cfset Saldo = RegistrosDif.SaldoConvertido - RegistrosDif.SaldoContable>
	<cfif Saldo GT 0>	 		
          	<cfquery datasource="#session.DSN#">
	        	update #Detalles# set Tipo = 'D', 
            					Monto = abs(#Saldo#)
					        where Ccuenta = #RegistrosDif.Ccuenta#	
                            and Tipo = ''
                            and Monto = 0 
            </cfquery>
            
            <cfquery name="IDmax" datasource="#session.DSN#">
	        	select max(ID) + 1 as MaxID from #Detalles#
            </cfquery>
            <cfset MaxID = IDmax.MaxID>
           	<cfquery datasource="#session.DSN#">
		   		insert into #Detalles#(ID,
                			 Cmayor,
							 CFformato,
							 CFcuenta,
							 Ccuenta,
							 SaldoContable,
							 SaldoConvertido,
	    					 Tipo,
                             Monto,
                             Naturaleza) 
 						values(#MaxID#,
                        	 '#rsCtaB15_2.CmayorSF#',
                         	 '#rsCtaB15_2.CFformato#', 
                             #rsCtaB15_2.CFcuenta#, 
                             #rsCtaB15_2.Ccuenta#, 
                             0, 
                             0,
                             'C',
                             abs(#Saldo#),
                             '#rsRegistrosContables.Naturaleza#')
		    </cfquery>
    <cfelse>
        	<cfquery datasource="#session.DSN#">
	        	update #Detalles# set Tipo = 'C', 
            					Monto = abs(#Saldo#) 
					        where Ccuenta = #RegistrosDif.Ccuenta#	 
                            and Tipo = ''
                            and Monto = 0 
            </cfquery>
            <cfquery name="IDmax" datasource="#session.DSN#">
	        	select max(ID) + 1 as MaxID from #Detalles#
            </cfquery>
            <cfset MaxID = IDmax.MaxID>
           	<cfquery datasource="#session.DSN#">
		   		insert into #Detalles#(ID,
                			 Cmayor,
							 CFformato,
							 CFcuenta,
							 Ccuenta,
							 SaldoContable,
							 SaldoConvertido,
	    					 Tipo,
                             Monto,
                             Naturaleza) 
 						values(#MaxID#,
                        	 '#rsCtaB15_2.CmayorSF#',
                         	 '#rsCtaB15_2.CFformato#', 
                             #rsCtaB15_2.CFcuenta#, 
                             #rsCtaB15_2.Ccuenta#, 
                             0, 
                             0,
                             'D',
                             abs(#Saldo#),
                             '#rsRegistrosContables.Naturaleza#')
		    </cfquery>        
    </cfif>    
</cfloop>

<cfquery datasource="#session.dsn#">
		insert into #CFformatos# 
			(CFformatoSF, CFcuenta, Ccuenta)
		select 
			CFformato, 
			max(coalesce(CFcuenta, 0)), max(coalesce(Ccuenta, 0))
		from #Detalles#
		group by CFformato
</cfquery>

<cfquery datasource="#session.dsn#">
		update #CFformatos# 
			set 
				CmayorSF = <cf_dbfunction name="sPart"	args="CFformato, 2, 3">, 
				CdetSF   = <cf_dbfunction name="sPart"	args="CFformato, 5, 100">
</cfquery>

<!--- Actualizar las cuentas que no tienen guiones. Formato similar a Versión 5 de SIF --->
<cfquery datasource="#session.DSN#">
			update #CFformatos#
			set CFcuenta = ( 
					select min(cf.CFcuenta)
					from CFinanciera cf
					where cf.CFformato  = #CFformatos#.CFformatoSF
                    -----cf.CmayorSF  = #CFformatos#.CmayorSF
					---and cf.CdetSF  = #CFformatos#.CdetSF 
					  and cf.Ecodigo =  #session.ecodigo# 
					)
		where CFformatoSF NOT LIKE '%-%'
		  and CFcuenta = 0
</cfquery>

<!--- Actualizar las cuentas que tienen guiones. Formato de Version 6 de SIF  --->
<cfquery datasource="#session.DSN#">
			update #CFformatos#
			set CFcuenta = ( 
					select min(cf.CFcuenta)
					from CFinanciera cf
					where cf.CFformato  = #CFformatos#.CFformatoSF
					  and cf.Ecodigo    =  #session.ecodigo# 
					)
		where CFformatoSF LIKE '%-%'
		  and CFcuenta = 0
</cfquery>

<!--- Actualizar el campo Ccuenta de las cuentas que tienen CFcuenta --->
<cfquery datasource="#session.DSN#">
		update #CFformatos#
		set Ccuenta = ( 
				select min(cf.Ccuenta)
				from CFinanciera cf
				where cf.CFcuenta  = #CFformatos#.CFcuenta
				)
		where CFcuenta is not null
		  and CFcuenta > 0
</cfquery>

<!--- Actualizar el campo Ccuenta de las cuentas que tienen CFcuenta --->
	<cfquery datasource="#session.DSN#">
		update #CFformatos#
		set CFformato = ( 
				select min(cf.CFformato)
				from CFinanciera cf
				where cf.CFcuenta  = #CFformatos#.CFcuenta
				)
		where CFcuenta is not null
</cfquery>
					
<!--- Actualiza Ccuenta y CFcuenta en la tabla ID18 --->
<cfquery datasource="#session.dsn#">
		update #Detalles#
		set  Ccuenta  = (( select min(cf.Ccuenta)  from #CFformatos# cf where cf.CFformatoSF = #Detalles#.CFformato )),
			 CFcuenta = (( select min(cf.CFcuenta) from #CFformatos# cf where cf.CFformatoSF = #Detalles#.CFformato ))
		  where CFcuenta is null
</cfquery>			

<!--- Actualiza CFformato en la tabla ID18 si la cuenta no es nula y el formato de cuenta no tiene guiones --->
	<cfquery datasource="#session.dsn#">
		update #Detalles#
		set  CFformato  = (( select min(cf.CFformato) from #CFformatos# cf where cf.CFcuenta = #Detalles#.CFcuenta ))
		where CFcuenta is not null
	</cfquery>			
		
<cfquery name="rsFormatos" datasource="#session.DSN#">
		select distinct CFformato
		from #Detalles#
		where CFcuenta is null
		  and CFformato NOT LIKE '%-%'
</cfquery>

<cfloop query="rsFormatos">

		<!--- Obtiene la cuenta mayor --->
		<cfset LvarCuentaMayor = Mid(rsFormatos.CFformato,1,4)>
		<cfset LvarCuentaControl = rsFormatos.CFformato>
		<cfset LvarCuentaTotal = rsFormatos.CFformato>
		
		<!--- OBTIENE LA MASCARA DE LA CUENTA --->
		<cfquery name="rsMascara" datasource="#session.DSN#">
			select  CPVformatoF 
			from CPVigencia
			where Ecodigo =   #session.ecodigo#
			  and Cmayor  =  '#LvarCuentaMayor#'
		</cfquery>
		
		<cfif rsMascara.recordcount eq 0>
			<cfthrow message="No existe mascara para la cuenta contable #LvarCuentaMayor#">
		</cfif>
		
		<cfset Mascara = rsMascara.CPVformatoF>
		<cfset Cuenta="">
		
		<cfloop condition="find('-',Mascara,1) GT 0">
		
			<cfset pos = find("-",Mascara,1)>
			<cfset subhilera = Mid(LvarCuentaTotal,1,pos-1)>
			<cfset LvarCuentaTotal = Mid(LvarCuentaTotal,pos,len(LvarCuentaTotal))>
			<cfset Mascara = Mid(Mascara,pos+1,len(Mascara))>
		
			<cfif Cuenta eq "">
				<cfset Cuenta = subhilera>
			<cfelse>
				<cfset Cuenta = Cuenta & "-" & subhilera>
			</cfif>
		
		</cfloop>

		<cfset Cuenta = Cuenta & "-" & LvarCuentaTotal>
		
		<cfloop condition="Mid(Cuenta,len(Cuenta),1) EQ '-'">
			<cfset Cuenta = Mid(Cuenta,1,len(Cuenta)-1)>			
		</cfloop>
		
		<cfquery datasource="#session.DSN#">
			update #Detalles#
			set CFformato   = '#Cuenta#'
			where CFformato = '#LvarCuentaControl#'
			and CFcuenta is null
		</cfquery>
</cfloop>

<cfquery name="rsTotales" datasource="#session.DSN#">
		select
			sum(case when Tipo = 'D' then Monto else 0.00 end) as Debitos,
			sum(case when Tipo = 'C' then Monto else 0.00 end) as Creditos,
			count(1) as Cantidad
		from #Detalles#
</cfquery>

<cfset LvarTotalDebitos = rsTotales.Debitos>
<cfset LvarTotalCreditos = rsTotales.Creditos>
<cfset LvarTotalRegistros = rsTotales.Cantidad>

<cftransaction>
<!--- Insercion en la Tabla de Interfaz de Asientos (Encabezado) --->
<cfquery name="rsInput" datasource="#session.DSN#">
		insert into EContablesImportacion 
			(
				   Ecodigo
				,  Cconcepto
				,  Eperiodo
				,  Emes
				,  Efecha
				,  Edescripcion
				,  Edocbase
				,  Ereferencia
				,  BMfalta
				,  BMUsucodigo
				,  ECIreversible                
			)
			values (
				   #Session.Ecodigo#
				,  #LvarCconcepto#
				,  #LvarEperiodo#
				,  #LvarEmes#
				,  <cfqueryparam cfsqltype="cf_sql_date" value="#LvarEfecha#">
				,  <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarEdescripcion#">
				,  <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarEdocbase#">
				,  <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarEreferencia#">
				,  <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFalta#">
				,  #Session.Usucodigo#
				,  #LvarECIreversible#
               	)
                                	
			<cf_dbidentity1 datasource="#session.DSN#" verificar_transaccion="false">
</cfquery>
<cf_dbidentity2 datasource="#session.DSN#" name="rsInput" verificar_transaccion="false">
	
<cfif rsInput.recordCount EQ 0>
	<cftransaction action="rollback">
	<cfthrow message="No existen datos de Entrada para la generación de la póliza.">
</cfif>

<cfset ECImp_id = rsInput.identity>

<!----Actualiza los consecutivos de las polizas---->
<cfquery datasource="#session.DSN#">
	declare
	@a int 
	select
	@a = 1 
	update
	#Detalles# set ID = @a, @a=@a+1 
</cfquery>
		
<!--- Insercion en la Tabla de Interfaz de Asientos (Detalle) --->
<cfquery name="rsInput" datasource="#session.DSN#">
		INSERT into DContablesImportacion (			  
				  ECIid, 				DCIconsecutivo,			  Ecodigo,				  DCIEfecha,
				  Eperiodo,				Emes,					  Ddescripcion,			  Ddocumento,
				  Dreferencia,			Dmovimiento,			  CFformato,			  Ccuenta,
				  CFcuenta,				Ocodigo,				  Mcodigo,				  Doriginal,
				  Dlocal,				Dtipocambio,			  Cconcepto,			  BMfalta,
				  BMUsucodigo,			EcodigoRef,				  Referencia1,			  Referencia2,
				  Referencia3, 			CFid, 					  CFcodigo
			)
			select	#ECImp_id#, 		a.ID,					#session.Ecodigo#, 			getdate()
					, #LvarEperiodo#, 	#LvarEmes#, 			'Poliza de resultado de conversión', 	'#LvarEperiodo#-#LvarEmes#'
					, '',	a.Tipo, 			a.CFformato, 		a.Ccuenta
					, a.CFcuenta, 		#rsOficina.Ocodigo#, 				#rsMoneda.Mcodigo#, 			 0
					, a.Monto, 		1, 			300, 		getdate()
					, #Session.Usucodigo#, #session.Ecodigo#, 		'', 		''
					, '',    #rsCFuncional.CFid#,			'#rsCFuncional.CFcodigo#'
			  from #Detalles# a
</cfquery>
  
<!--- Consulta para verificar si se tiene que aplicar el asiento importado --->
<cfquery name="rsPvalor" datasource="#session.DSN#">
	select Pvalor from Parametros where Ecodigo = #session.Ecodigo# and Pcodigo = 2400
</cfquery>

<cfif rsPvalor.Pvalor eq 1>	   
     <cfinvoke component="sif.Componentes.CG_AplicaImportacionAsiento" method="CG_AplicaImportacionAsiento">
			<cfinvokeargument name="ECIid" value="#ECImp_id#">
			<cfinvokeargument name="TransaccionActiva" value="true">
     </cfinvoke>	   
</cfif>

</cftransaction>

<cfquery datasource="#session.DSN#">
	delete from #CFformatos#
</cfquery>
    
<cfquery datasource="#session.DSN#">
	delete from #Detalles#
</cfquery>
    
<cfthrow type="toUser" message="Se genero la póliza de Resultado de Conversion">



