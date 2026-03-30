<!----      Parametrizaciones requeridas      ----->
<!----    
      - Cuenta Bancaria:               15 dígitos.
                                       Unicamente caracteres numericos.
      - Código del banco I-banking:
                                       Max 6 digitos        
                                       Unicamente caracteres numericos.
      - Cuenta bancaria del empleado:                               
                                       15 dígitos.
                                       Unicamente caracteres numericos.
------>	 
	
	<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
	<cf_dbtemp name="planilla" returnvariable="planilla" datasource="#session.dsn#">
		<cf_dbtempcol name="detalle"  type="char(255)" mandatory="no">
	</cf_dbtemp>

	<cf_dbtemp name="planilla2" returnvariable="planilla2" datasource="#session.dsn#">
		<cf_dbtempcol name="detalle"  type="char(255)" mandatory="no">
	</cf_dbtemp>

<cfquery name="Nomina" datasource="#session.dsn#">
	Select count(1) as existe from ERNomina
	where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
</cfquery>

<cfif nomina.existe EQ 1 >
	<cfset Historico =''>
<cfelse>
	<cfset Historico='H'>
</cfif>
	
<!---  VALIDACION DE LOS INSUMOS NECESARIOS --->
	<!--- CUENTA EMPRESA: LONGITUD: 15 CARACTERES SIN GUIONES>  --->
			<cfquery name="Error1" datasource="#session.dsn#">
				insert into #planilla2# (detalle)					 	
				select distinct 'Error 1, La cuenta ' #_Cat# Iaba #_Cat# ' no tiene la longitud de 15 caracteres'		
				from HERNomina a
				inner join HDRNomina b
					on a.ERNid=b.ERNid
				inner join DatosEmpleado c
					on c.DEid=b.DEid
				inner join Bancos d
					on c.Bid = d.Bid
				where a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
				and c.Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and d.Bid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
				and <cf_dbfunction name="length" args="Iaba"  datasource="#session.dsn#"> <> 15			
			</cfquery> 
		
	<!--- CUENTA EMPRESA: CONTENIDO: SOLO DIGITOS NUMERICOS>  --->		
		<cf_dbfunction name="findOneOf"			args="Iaba,^0-9"  datasource="#session.dsn#" returnvariable="LvarIabaNum">
	      
		  <cfquery name="Error2" datasource="#session.dsn#">
				insert into #planilla2# (detalle)					
				select distinct 'Error 2, La cuenta ' #_Cat# Iaba #_Cat# ' debe contener unicamente digitos numericos, verifique informacion en catalogo de bancos'		
				from HERNomina a
				inner join HDRNomina b
					on a.ERNid=b.ERNid
				inner join DatosEmpleado c
					on c.DEid=b.DEid
				inner join Bancos d
					on c.Bid = d.Bid
				where a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
				and c.Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and d.Bid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
				and #preserveSingleQuotes(LvarIabaNum)#
			</cfquery>   
			          				
<!--- CUENTA EMPLEADO: LONGITUD: 15 CARACTERES SIN GUIONES> --->
		 <cfquery name="Error3" datasource="#session.dsn#">
			insert into #planilla2# (detalle)
			select distinct 'Error3, La Cuenta del Empleado debe ser de longitud 15 caracteres numerico '  #_Cat# DEidentificacion #_Cat# ' , ' #_Cat# DEnombre #_Cat#' '#_Cat#  DEapellido1  #_Cat#' '#_Cat#  DEapellido2 #_Cat# ', ' #_Cat# DEcuenta as Funcionario
			from HERNomina a
			inner join HDRNomina b
				on a.ERNid=b.ERNid
			inner join DatosEmpleado c
				on c.DEid=b.DEid
			inner join Bancos d
				on c.Bid = d.Bid
			where a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
			and c.Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and d.Bid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
			and <cf_dbfunction name="length"	args="DEcuenta"  datasource="#session.dsn#"> <> 15			
		</cfquery>  
		
<!--- CUENTA EMPLEADO: CONTENIDO: SOLO DIGITOS NUMERICOS>  --->		
	<cf_dbfunction name="findOneOf"			args="DEcuenta,^0-9"  datasource="#session.dsn#" returnvariable="LvarDEcuentaNum">
      
	  <cfquery name="Error4" datasource="#session.dsn#">
			insert into #planilla2# (detalle)					
			select distinct 'Error4, La Cuenta del Empleado debe contener unicamente digitos numerico'  #_Cat# DEidentificacion #_Cat# ',' #_Cat# DEnombre #_Cat# ',' #_Cat# DEapellido1 #_Cat# ',' #_Cat# DEapellido2 #_Cat# ',' #_Cat# DEcuenta as Funcionario		
			from HERNomina a
			inner join HDRNomina b
				on a.ERNid=b.ERNid
			inner join DatosEmpleado c
				on c.DEid=b.DEid
			inner join Bancos d
				on c.Bid = d.Bid
			where a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
			and c.Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and d.Bid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
			and #preserveSingleQuotes(LvarDEcuentaNum)#
		</cfquery>   
		
<!--- CUENTA EMPRESA: LONGITUD: 6 CARACTERES SIN GUIONES>  --->
			<cfquery name="Error5" datasource="#session.dsn#">
				insert into #planilla2# (detalle)					 	
				select distinct 'Error 5, El código ' #_Cat# d.Bcodigocli #_Cat# ' no debe tener una longitud mayor de 6 caracteres'		
				from HERNomina a
				inner join HDRNomina b
					on a.ERNid=b.ERNid
				inner join DatosEmpleado c
					on c.DEid=b.DEid
				inner join Bancos d
					on c.Bid = d.Bid
				where a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
				and c.Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and d.Bid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
				and <cf_dbfunction name="length" args="d.Bcodigocli"  datasource="#session.dsn#"> > 6			
			</cfquery> 
		
	<!--- CUENTA EMPRESA: CONTENIDO: SOLO DIGITOS NUMERICOS>  --->		
		<cf_dbfunction name="findOneOf"			args="d.Bcodigocli,^0-9"  datasource="#session.dsn#" returnvariable="LvarBcodigocliNum">
	      
		  <cfquery name="Error6" datasource="#session.dsn#">
				insert into #planilla2# (detalle)					
				select distinct 'Error 6, El Codigo ' #_Cat# d.Bcodigocli #_Cat# ' debe contener unicamente digitos numericos, verifique informacion en catalogo de bancos'		
				from HERNomina a
				inner join HDRNomina b
					on a.ERNid=b.ERNid
				inner join DatosEmpleado c
					on c.DEid=b.DEid
				inner join Bancos d
					on c.Bid = d.Bid
				where a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
				and c.Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and d.Bid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
				and #preserveSingleQuotes(LvarBcodigocliNum)#
			</cfquery>   					
			
		<cfquery name="Errores" datasource="#session.dsn#">
			Select count(1) as cantidad 
			from #planilla2#
		</cfquery>
		
<cfif Errores.cantidad EQ 0>
		<cfif Historico EQ 'H'>
				<cfquery name="montos" datasource="#session.dsn#">
					select sum(HDRNliquido) as suma_montos 
					from HDRNomina a
					 inner join HERNomina b
					   on a.ERNid = b.ERNid
					 inner join DatosEmpleado c
					   on 	a.DEid = c.DEid 
					where 						
						a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#"> and
					    c.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#"> and
						a.HDRNliquido > 0
				</cfquery>				
				<cfquery name="nomina" datasource="#session.dsn#">
					select distinct HERNdescripcion as descripcion, 
						   d.Iaba as cuenta_empresa, 
						   a.HERNfinicio as desde, 
						   a.HERNffin as hasta,
						   RIGHT('000000' #_Cat# d.Bcodigocli,6) as CodigoCliente						   
					from HERNomina a
					inner join HDRNomina b
						on a.ERNid=b.ERNid
					inner join DatosEmpleado c
						on c.DEid=b.DEid
					inner join Bancos d
						on c.Bid = d.Bid
					where a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
					and c.Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					and d.Bid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
				</cfquery>								
		<cfelse>
				<cfquery name="montos" datasource="#session.dsn#">
					select sum(DRNliquido) as suma_montos 
					from DRNomina a 
					inner join  ERNomina b
					  on a.ERNid = b.ERNid 
					inner join  DatosEmpleado c
					  on a.DEid = c.DEid  
					where 						
						a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#"> and						 
						c.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#"> and
						a.DRNliquido > 0
				</cfquery>
				
				<cfquery name="nomina" datasource="#session.dsn#">
					select distinct ERNdescripcion as descripcion, 
						   d.Iaba as cuenta_empresa, 
						   a.ERNfinicio as desde, 
						   a.ERNffin as hasta,
						   RIGHT('000000' #_Cat# d.Bcodigocli,6) as CodigoCliente
					from ERNomina a
					inner join DRNomina b
						on a.ERNid=b.ERNid
					inner join DatosEmpleado c
						on c.DEid=b.DEid
					inner join Bancos d
						on c.Bid = d.Bid
					where a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
					and c.Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					and d.Bid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
				</cfquery>
		</cfif>
		<!--- Registro Tipo 1 - Encabezado --->	
		<!--- Consecutivo obtenido desde RHParametros ---->
		<cfquery name="rsNumeroDoc" datasource="#session.dsn#">
          select Pvalor as NumeroDoc
            from RHParametros 
           where Pcodigo = 210
             and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">              		
		</cfquery>				
		<cf_dbfunction name="today" returnvariable="LvarHoy">
		<cfquery name="cuentas" datasource="#session.dsn#">			
		insert into #planilla# (detalle)
			select 
		        '1' #_Cat#            																										<!--- Tipo de Registro (siempre es 1) --->
				'#nomina.CodigoCliente#' #_Cat# 	<!--- Cuenta de la empresa--->
				<cf_dbfunction name="date_format"	args="#LvarHoy#,dd"  datasource="#session.dsn#">  			  #_Cat#     
				<cf_dbfunction name="date_format"	args="#LvarHoy#,mm"  datasource="#session.dsn#">              #_Cat# 
				<cf_dbfunction name="date_format"	args="#LvarHoy#,yyyy"  datasource="#session.dsn#">            #_Cat# 
				<cf_dbfunction name="sRepeat"	args="'0',6"         datasource="#session.dsn#">                  #_Cat#			<!--- Transferencia real--->
				RIGHT('000000' #_Cat#('#rsNumeroDoc.NumeroDoc#'),6) #_Cat# 			 																						<!--- Transferencia interna--->
				'1'       #_Cat# 			 																						<!--- Tipo de Transferencia  (1=1 Deb  a N Creditos)--->				
				<cf_dbfunction name="sRepeat"	args="'0',4"         datasource="#session.dsn#">  #_Cat#   							<!--- CÃ³digo de error--->
				<cf_dbfunction name="sRepeat"	args="'0',12"        datasource="#session.dsn#">  #_Cat#   							<!--- Total transferencia--->
				<cf_dbfunction name="sRepeat"	args="'0',7"         datasource="#session.dsn#">  #_Cat#   							<!--- Tipo de Cambio Compra--->
				<cf_dbfunction name="sRepeat"	args="'0',7"         datasource="#session.dsn#">  #_Cat#   							<!--- Tipo de Cambio Venta--->
				<cf_dbfunction name="sRepeat"	args="'0',10"        datasource="#session.dsn#">   						         	<!--- Fijo 10 ceros --->
			    as salida
				from dual				
		</cfquery>	
		<!--- Registro del Debito (una sola linea, del patrono ) --->	
	    <cf_dbfunction name="to_char"	args="#nomina.cuenta_empresa#" datasource="#session.dsn#" returnvariable="LvarCuenta">
		<cf_dbfunction name="today" returnvariable="LvarHoy2">		
	    <cfquery name="cuentas" datasource="#session.dsn#">
			insert into #planilla# (detalle)
			select 	'2' #_Cat#       								<!--- 2=Debito   3=Credito   ---->			    
				<cf_dbfunction name="sPart"	 args="#nomina.cuenta_empresa#,6,3" datasource="#session.dsn#" > #_Cat#  			<!--- Oficina de apertura de cta ---->
				<cf_dbfunction name="sPart"	 args="#nomina.cuenta_empresa#,1,3" datasource="#session.dsn#" > #_Cat#	   			<!--- 100=Cta Corr   200=Cta Ahorros  300=Cta Electr ---->
				<cf_dbfunction name="sPart"	 args="#nomina.cuenta_empresa#,4,2" datasource="#session.dsn#" > #_Cat# 			<!--- 01=Colones   02=Dolares ---->
				<cf_dbfunction name="sPart"	 args="#preserveSingleQuotes(LvarCuenta)#,9,7" datasource="#session.dsn#" > #_Cat# 	<!--- Cta empresa con digito verificador ---->
				<cf_dbfunction name="date_format"	args="#LvarHoy2#,ddmmyyyy"  datasource="#session.dsn#"> #_Cat#       		<!--- NÃºmero de comprobante  ---->
				RIGHT('000000000000' #_Cat#('#montos.suma_montos#' * 100),12) #_Cat# <!--- Total de salarios a pagar  ----> 	<!----- lpad(('#montos.suma_montos#' * 100),12,'0') ---->
				' '#_Cat#  
				LEFT('#nomina.descripcion#'#_Cat# '                             ',29) #_Cat# <!---- Concepto de pago  ----> <!----- rpad('#nomina.descripcion#',29,' ') #_Cat#  ----> 				 			
				'00'
				as salida
			from dual
		</cfquery>		
		<!--- Registro de los CrÃ©ditos  (una lÃ­nea por cada empleado) --->		
		<cfif Historico EQ 'H'>
				<cfquery name="cuentas" datasource="#session.dsn#">
					insert into #planilla# (detalle)
					select 	
						'3'  #_Cat#          <!--- 2=Debito   3=Credito    ---->
						<cf_dbfunction name="sPart"	 args="c.DEcuenta,6,3" datasource="#session.dsn#"  >  #_Cat# 	<!--- Oficina de apertura de cta  ---->  <!---- substring(c.DEcuenta,6,3)  ---->
						<cf_dbfunction name="sPart"	 args="c.DEcuenta,1,3" datasource="#session.dsn#"  >  #_Cat#	<!--- 100=Cta Corr   200=Cta Ahorros  300=Cta Electr-- 01=Colones   02=Dolares  ---->
						<cf_dbfunction name="sPart"	 args="c.DEcuenta,4,2" datasource="#session.dsn#"  >  #_Cat# 	<!--- 01=Colones   02=Dolares  ---->
						<cf_dbfunction name="sPart"	 args="c.DEcuenta,9,6" datasource="#session.dsn#"  >  #_Cat#    <!--- Cta empl. sin digito verificador  ---->
						<cf_dbfunction name="sPart"	 args="c.DEcuenta,15,1" datasource="#session.dsn#" >  #_Cat#    <!--- Cta empl (solo el digito verificador)   ---->
				        LEFT(<cf_dbfunction name="sPart"	 args="c.DEidentificacion, 1, 8" datasource="#session.dsn#" >#_Cat# '        ',8)  #_Cat#   			<!--- cedula = comprobante  ---->
						RIGHT('000000000000' #_Cat#(a.HDRNliquido * 100),12) #_Cat#   <!--- Salario lÃ­quido del empleado  ---->  <!-----lpad((a.HDRNliquido  * 100),12,'0')  #_Cat#----->
						LEFT(<cf_dbfunction name="sPart" args="upper(HDRNapellido1) #_Cat# ' ' #_Cat# upper(HDRNapellido2) #_Cat# ' ' #_Cat# upper(HDRNnombre),1,30" datasource="#session.dsn#"> #_cat# '                                                 ',30) #_Cat# 
						<!---- Concepto de pago ----> <!----rpad(substr(upper(HDRNapellido1) #_Cat#' ' #_Cat# upper(HDRNapellido2) #_Cat#' ' #_Cat# upper(HDRNnombre),1,30),30,' ')  #_Cat#------>
						'00' as Salida
					from 
						HDRNomina a , HERNomina b, DatosEmpleado c
					where 
						a.ERNid = b.ERNid and
						a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#"> and
						a.DEid = c.DEid and 
						c.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#"> and
						a.HDRNliquido > 0
				</cfquery>					
		<cfelse>
		    	<cfquery name="cuentas" datasource="#session.dsn#">
					insert into #planilla# (detalle)
					select 	
						'3'  #_Cat#          <!--- 2=Debito   3=Credito    ---->
						<cf_dbfunction name="sPart"	 args="c.DEcuenta,6,3" datasource="#session.dsn#"  >  #_Cat# 	<!--- Oficina de apertura de cta  ---->  <!---- substring(c.DEcuenta,6,3)  ---->
						<cf_dbfunction name="sPart"	 args="c.DEcuenta,1,3" datasource="#session.dsn#"  >  #_Cat#	<!--- 100=Cta Corr   200=Cta Ahorros  300=Cta Electr-- 01=Colones   02=Dolares  ---->
						<cf_dbfunction name="sPart"	 args="c.DEcuenta,4,2" datasource="#session.dsn#"  >  #_Cat# 	<!--- 01=Colones   02=Dolares  ---->
						<cf_dbfunction name="sPart"	 args="c.DEcuenta,9,6" datasource="#session.dsn#"  >  #_Cat#    <!--- Cta empl. sin digito verificador  ---->
						<cf_dbfunction name="sPart"	 args="c.DEcuenta,15,1" datasource="#session.dsn#" >  #_Cat#    <!--- Cta empl (solo el digito verificador)   ---->
				        LEFT(<cf_dbfunction name="sPart"	 args="c.DEidentificacion, 1, 8" datasource="#session.dsn#" >#_Cat# '        ',8)  #_Cat#   			<!--- cedula = comprobante  ---->
						RIGHT('000000000000' #_Cat#(a.DRNliquido * 100),12) #_Cat#   <!--- Salario lÃ­quido del empleado  ---->  <!-----lpad((a.HDRNliquido  * 100),12,'0')  #_Cat#----->
						LEFT(<cf_dbfunction name="sPart" args="upper(DRNapellido1) #_Cat# ' ' #_Cat# upper(DRNapellido2) #_Cat# ' ' #_Cat# upper(DRNnombre),1,30" datasource="#session.dsn#"> #_cat# '                                                 ',30) #_Cat# 
						'00' as Salida
					from 
						DRNomina a , ERNomina b, DatosEmpleado c
					where 
						a.ERNid = b.ERNid and
						a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#"> and
						a.DEid = c.DEid and 
						c.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#"> and
						a.DRNliquido > 0
				</cfquery>		
		</cfif>
		<!--- Linea de Totales --->		
		<cfif Historico EQ 'H'>
			<cf_dbfunction name="sPart"	 args="c.DEcuenta,9,6" datasource="#session.dsn#" returnvariable="LvarDEcuentaPart" >
			<cf_dbfunction name="to_number"	args="#LvarDEcuentaPart#"  datasource="#session.dsn#" returnvariable="LvarDEcuentaPart2" >
			
			<cf_dbfunction name="sPart"	 args="#nomina.cuenta_empresa#,9,6" datasource="#session.dsn#" returnvariable="LvarCuentaEmpPart">
			<cf_dbfunction name="to_number"	args="#LvarCuentaEmpPart#"  returnvariable="LvarCuentaEmpPart2">
			
					<cfquery name="total" datasource="#session.dsn#">
						select coalesce(sum(#preserveSingleQuotes(LvarDEcuentaPart2)#),0) 
							+  coalesce(#preserveSingleQuotes(LvarCuentaEmpPart2)#,0) as suma_cta
						from HDRNomina a, HERNomina b, DatosEmpleado c
						where
							a.ERNid = b.ERNid and
							a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#"> and
							a.DEid = c.DEid and 
							c.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#"> and
							a.HDRNliquido > 0
					</cfquery>					
		<cfelse>
			<cf_dbfunction name="sPart"	 args="c.DEcuenta,9,6" datasource="#session.dsn#" returnvariable="LvarDEcuentaPart" >
			<cf_dbfunction name="to_number"	args="#LvarDEcuentaPart#"  datasource="#session.dsn#" returnvariable="LvarDEcuentaPart2" >
			
			<cf_dbfunction name="sPart"	 args="#nomina.cuenta_empresa#,9,6" datasource="#session.dsn#" returnvariable="LvarCuentaEmpPart">
			<cf_dbfunction name="to_number"	args="#LvarCuentaEmpPart#"  returnvariable="LvarCuentaEmpPart2">
			
					<cfquery name="total" datasource="#session.dsn#">
						select coalesce(sum(#preserveSingleQuotes(LvarDEcuentaPart2)#),0) 
							+  coalesce(#preserveSingleQuotes(LvarCuentaEmpPart2)#,0) as suma_cta
						from DRNomina a, ERNomina b, DatosEmpleado c
						where
							a.ERNid = b.ERNid and
							a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#"> and
							a.DEid = c.DEid and 
							c.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#"> and
							a.DRNliquido > 0
					</cfquery>					
		</cfif>
		<cfset suma_cuentas = total.suma_cta>
		<cfif len(trim(suma_cuentas))  >
		     <!---- El campo suma_montos es la sumatoria de los débitos y los créditos , el valor montos.suma_montos trae solo la sumatoria de los salarios 
	                de los empleados (creditos) al duplicarse genera un monto q incluye el debito + el credito por partida doble   	     
		      ----->   
			<cfquery name="cuentas" datasource="#session.dsn#">
				insert into #planilla# (detalle)
				  select 
					'4' #_Cat#             								<!--- Tipo de Registro (siempre es 4)   --->
					RIGHT('000000000000000' #_Cat# (#montos.suma_montos#*2)*100,15) #_Cat#      <!--- Suma de montos                          ---><!--- lpad((#montos.suma_montos# * 100 * 2),15,'0')#_Cat#  ------>
					RIGHT('0000000000' #_Cat# #suma_cuentas#,10) #_Cat#    				<!--- Suma de cuentas sin dÃ­gito verificador   --->  <!-----lpad(#suma_cuentas#,10,'0') #_Cat#------>	
					<cf_dbfunction name="sRepeat"	args="0,10"        datasource="#session.dsn#">   #_Cat#           					<!--- Lugar para el testkey (lo calcula el programa del cliente)   --->	
					<cf_dbfunction name="sRepeat"	args="0,12"        datasource="#session.dsn#">   #_Cat#           					<!--- Monto en dÃ³lares (colones x TC compra   --->	
					<cf_dbfunction name="sRepeat"	args="0,12"        datasource="#session.dsn#">   #_Cat#           					<!--- Monto en colones     --->	
					<cf_dbfunction name="sRepeat"	args="0,8"        datasource="#session.dsn#">                  				<!--- N/A                   --->	
			        as salida
			from dual
			</cfquery>
		<cfelse>
			<cfthrow message="Error Procesando Exportador del Banco Nacional, solicite soporte del producto al proveedor de Servicio">
		</cfif>	
			
		<!--- quita tildes y caracteres raros --->		
		<cfquery name="rs_nombre" datasource="#session.DSN#">
			select detalle from #planilla#
			where <cf_dbfunction name="findOneOf"			args="detalle&^A-Za-z ,.:;-''ñÑ/\*$@¿?+!¡()0-9" delimiters="&" datasource="#session.dsn#">
		</cfquery>			
		<cfloop query="rs_nombre">
				<cfset nombre_nuevo = lcase(rs_nombre.detalle) >
				<cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"Ã¡","a","ALL") >
				<cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"Ã©","e","ALL") >
				<cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"Ã­","i","ALL") >
				<cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"Ã³","o","ALL") >
				<cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"Ãº","u","ALL") >
				<cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"Ã±","n","ALL") >
				<cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"Ã¤","a","ALL") >
				<cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"Ã«","e","ALL") >
				<cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"Ã¯","i","ALL") >			
				<cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"Ã¶","o","ALL") >
				<cfset nombre_nuevo = ReplaceNoCase(nombre_nuevo,"Ã¼","u","ALL") >							
				
				<cfset nombre_nuevo = REReplaceNoCase(nombre_nuevo,"[^A-Za-z0-9]","","ALL") >
				<cfset nombre_nuevo = ucase(nombre_nuevo) >	
		
				<cf_dbfunction name="findOneOf"			args="rs_nombre.detalle,A-Za-z0-9"  datasource="#session.dsn#" returnvariable="LvarDEcuentaNum">
				<cfquery name="cuentas" datasource="#session.dsn#">
					insert into #planilla2# (detalle)					
					 values ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#nombre_nuevo#">)
				</cfquery>
		</cfloop>
		
		<cfquery name="rs_nombre" datasource="#session.DSN#">
		 insert into #planilla2# (detalle)				
		   select detalle from #planilla#
			where <cf_dbfunction name="findOneOf"			args="detalle,A-Za-z0-9" datasource="#session.dsn#">
		</cfquery>			
</cfif>			
		
<cfquery name="ERR" datasource="#session.dsn#">
	select <cf_dbfunction name="sPart"	 args="detalle,1,150" datasource="#session.dsn#"> from #planilla2#
	order by 1
</cfquery>

<!--- Consecutivo obtenido desde RHParametros ---->
<cfquery name="UpdateNumeroDoc" datasource="#session.dsn#">
  update  RHParametros   
     set Pvalor =  
  case when (Pvalor > 999999)  then
        1
   else
      Pvalor + 1
   end   
   where Pcodigo = 210
     and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">              		
</cfquery>
<script language="javascript">
  window.location.reload();
</script>