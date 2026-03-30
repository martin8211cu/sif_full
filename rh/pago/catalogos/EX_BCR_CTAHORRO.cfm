<!---=====================================================================================================================================---->
<!--- ARCHIVO QUE GENERA TXT CON LOS DATOS DE LA PLANILLA PARA EL BCR CUANDO SE UTILIZA EL FORMATO DE LA CUENTA DE AHORRO
	EN EL CAMPO CUENTA (DatosEmpleado.DEcuenta)DEL MANTENIMIENTO DE EMPLEADOS DEBERA INGRESARSE LA CUENTA EN EL SIGTE FORMATO
		FORMATO DE LA CUENTA: 215-00293583 DONDE :
			POSICION 1 - 3 = CORRESPONDE A LA OFICINA (215)
			POSICION 5 - 11 = NUMERO DE CUENTA DE AHORRO (0029358)
			POSICION 12     = DIGITO QUE SIGUE AL NUMERO DE CUENTA (3)--->
<!---=====================================================================================================================================---->
<cfparam name="url.Bid" 		type="numeric">	
<cfparam name="url.EcodigoASP" 	type="numeric" default="#session.EcodigoSDC#">	
<cfparam name="url.ERNid" 		type="numeric">	
<cfset vn_consecarchivo = 0>	<!---Consecutivo del archivo ---->
<cfset vs_cedjuridica 	= ''>	<!---Cedula juridica de la empresa ---->
<cfset vs_cedusuario 	= ''>	<!---Cedula del empleado que genera el archivo ---->
<cfset vn_testkey 		= 0>	<!---Testkey calculado ----->
<cfset vn_documento 	= 0>	<!---Documento---->
<cfset vb_cedregistro = true >  <!---Variable booleana para validar que el usuario pueda realizar la exportacion---->
<cfset vb_cedjuridica = true >  <!---Variable booleana para validar que la empresa tenga cedula juridica---->

<cf_dbtemp name="DatosBancosCtaAhorro" returnvariable="Datos" datasource="#session.DSN#"><!---Tabla temporal de datos que van a ser insertados ---->
	<cf_dbtempcol name="Datos" 	type="varchar(194)"	mandatory="no">
	<cf_dbtempcol name="Orden"	type="int" 			mandatory="no">
</cf_dbtemp>

<cf_dbtemp name="TempErrores" returnvariable="Errores" datasource="#session.DSN#"><!---Tabla temporal de errores ---->
	<cf_dbtempcol name="error" 		type="varchar(255)"	mandatory="no">
	<cf_dbtempcol name="ordenerror"	type="int" 			mandatory="no">
</cf_dbtemp>

<!---====== 1. CONSECUTIVO ARCHIVO: Calcular el nmero de consecutivo de archivo, envio de mas de un archivo el mismo da ======----->
<cfquery name="rsConsecutivo_1" datasource="#session.DSN#">
	select <cf_dbfunction name="to_number" args="Pvalor">  as consecutivo
	from RHParametros  
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		and Pcodigo = 210
</cfquery>
<cfif isdefined("rsConsecutivo_1") and rsConsecutivo_1.RecordCount NEQ 0>
	<cfset vn_consecarchivo = rsConsecutivo_1.consecutivo>
<cfelse>
	<cfset vn_consecarchivo = 1>
</cfif>
<cfif rsConsecutivo_1.consecutivo GTE 1000>
	<cfset vn_consecarchivo = 1 >
</cfif>

<!---====== 2. NUMERO NEGOCIO: Número de cédula jurídica de la empresa ====---->
<cfquery name="rsCedJuridica" datasource="#session.DSN#">
	select ltrim(rtrim(Bcodigocli)) as cedulajuridica			
	from Bancos 
	where Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfif isdefined("rsCedJuridica") and len(trim(rsCedJuridica.cedulajuridica))>
	<cfset vs_cedjuridica = Replace(rsCedJuridica.cedulajuridica,'-','','all')><!---Reemplazando los guiones--->
<cfelse>
	<cfquery name="ERR" datasource="#session.DSN#">
		select 'No se ha definido la cédula jurídica (Identificación) de la empresa' as Error
		from dual
	</cfquery>
	<cfset vb_cedjuridica = false >
</cfif>

<!---====== 3. CEDULA REGISTRO: Cedula del funcionario de la empresa que genera el archivo =====--->
<cfquery name="rsCedRegistra" datasource="#session.DSN#"><!--- Cedula(Identificacion) del funcionario ---->
	select b.Pid as Identificacion
	from Usuario a
		inner join DatosPersonales b
			on a.datos_personales = b.datos_personales 
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
</cfquery>
<cfif isdefined("rsCedRegistra") and len(trim(rsCedRegistra.Identificacion))>
	<cfset vs_cedusuario = trim(Replace(rsCedRegistra.Identificacion,'-','','all'))><!---Reemplazando los guiones--->
<cfelse>
	<cfquery name="ERR" datasource="#session.DSN#">
		select 'El usuario no puede realizar la exportación' as Error
		from dual
	</cfquery>
	<cfset vb_cedregistro = false >
</cfif>

<cfif vb_cedregistro and vb_cedjuridica>
	<!---====== Temporal para el test key ======------>
	<cf_dbtemp name="TestKey56" returnvariable="TestKey" datasource="#session.DSN#">
		<cf_dbtempcol name="oficina" 			type="varchar(3)"  		mandatory="no">
		<cf_dbtempcol name="cuenta"				type="varchar(12)" 		mandatory="no">
		<cf_dbtempcol name="CuentaOrigen"		type="varchar(25)" 		mandatory="no">
		<cf_dbtempcol name="TKP1"				type="numeric(20)" 		mandatory="no">		
		<cf_dbtempcol name="oficinacuenta"		type="varchar(12)" 		mandatory="no">
		<cf_dbtempcol name="monto"				type="numeric(12,2)" 	mandatory="no">
		<cf_dbtempcol name="TKP2"				type="numeric(20,2)" 	mandatory="no">				
		<cf_dbtempcol name="fechapago"			type="date" 			mandatory="no">
	</cf_dbtemp>
	<!---====== 4. OBTENER LOS DATOS DE DEBITO Y CREDITOS ======------>
	<!----=====================================================================---->
	<!----====================== Datos de creditos ======================---->
	<!----=====================================================================---->
	<cfquery name="rsDatos" datasource="#session.DSN#"><!---Seleccionar los datos----->
		select 	ltrim(rtrim(c.DEcuenta)) as CtaAhorro,
				case when c.CBTcodigo = 0 then 1 else 2 end as TipoCuenta, <!---1=Corriente,2=Ahorros--->
				coalesce(<cf_dbfunction name="to_number" args="(b.DRNliquido) * 100">,0) as Monto,
				'1' as Moneda,					
				coalesce(a.ERNdescripcion,'Pago de planilla') as razon,	
				(select max(y.CPfpago) from CalendarioPagos y where y.CPid = a.RCNid) as fechapago
				<!----Datos para tabla de errores--->
				,c.DEidentificacion
				,{fn concat(c.DEapellido1,
				{fn concat(' ',
				{fn concat(c.DEapellido2,
				{fn concat(' ',c.DEnombre
				)})})})} as empleado
		from ERNomina a
			inner join DRNomina b
				on a.ERNid = b.ERNid								
				inner join Monedas d
					on b.Mcodigo = d.Mcodigo			
				inner join DatosEmpleado c
					on b.DEid = c.DEid
					and c.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
		where a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
			and b.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#"> 
			and b.DRNliquido != 0	
	</cfquery>
	
	<!----=====================================================================---->
	<!----========================== Datos de debito ==========================---->
	<!----=====================================================================---->
	<!---- Numero de cuenta cliente: Cuenta que debita ---->
	<cfquery name="rsCuentaCliente" datasource="#session.DSN#">
		select 	ltrim(rtrim(CBcc)) as CuentaCliente
				,coalesce(ERNdescripcion,'Pago de planilla') as razon	
		from ERNomina
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">  
	</cfquery>
	<!--- Suma de los montos a acreditar a c/empleado (Registros de detalle) (Total a debitar)---->
	<cfquery name="rsMonto"  datasource="#session.DSN#">		
		select 	sum(coalesce(<cf_dbfunction name="to_number" args="(b.DRNliquido) * 100">,0)) as Monto,					
				'1' as Moneda,
				a.RCNid	
		from ERNomina a
			inner join DRNomina b
				on a.ERNid = b.ERNid								
			inner join Monedas d
				on a.Mcodigo = d.Mcodigo							
		where a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
			and b.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#"> 
		group by 	case d.Miso4217 when 'CRC' then '01' else '02'  end
					,a.RCNid
	</cfquery>
	<cfquery name="rsFechaPago" datasource="#session.DSN#">
		select CPfpago as fechapago from CalendarioPagos
		where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMonto.RCNid#">
	</cfquery>
	<!----=====================================================================---->
	<!----===================== Verificar formato de cuentas ==================---->
	<!----=====================================================================---->
	<!---Para verificar el formato de las cuentas xxx-yyyyyyyz---->
	<cfloop query="rsDatos">	
		<cfset vs_oficina = mid(rsDatos.CtaAhorro,1,3)>
		<cfset vs_guion = mid(rsDatos.CtaAhorro,4,1)>
		<cfset vs_cuenta = mid(rsDatos.CtaAhorro,5,7)>
		<cfset vs_numero = mid(rsDatos.CtaAhorro,5,1)>
		<cfif (not IsNumeric(vs_oficina)) or (vs_guion NEQ '-') or (not IsNumeric(vs_cuenta)) or (not IsNumeric(vs_numero)) or (len(rsDatos.CtaAhorro) GT 12)>
			<cfquery datasource="#session.DSN#">
				insert into #Errores# (error,ordenerror)
				values({fn concat('Identificacion:',
						{fn concat('#rsDatos.DEidentificacion#',
						{fn concat(' Nombre: ',
						{fn concat('#rsDatos.empleado#',
						{fn concat(' Cta.Ahorro: ',
						'#rsDatos.CtaAhorro#'
						)})})})})}
						,3 
					  )
			</cfquery>
		</cfif>	
	</cfloop>
	<cfquery name="rsErrores" datasource="#session.DSN#">
		select * from #Errores#
	</cfquery>
	<cfif rsErrores.RecordCount NEQ 0>
		<cfquery datasource="#session.DSN#">
			insert into #Errores# (error,ordenerror)
			values('Los siguientes empleados tienen el formato de la cuenta incorrecto:',2)
		</cfquery>
		<cfquery datasource="#session.DSN#">
			insert into #Errores# (error,ordenerror)
			values('El formato de la cuenta debe ser XXX-YYYYYYYZ. Donde X corresponde a la oficina, Y corresponde a la cuenta y Z corresponde a el dígito de la cuenta',1)
		</cfquery>	
		<cfquery name="ERR" datasource="#session.DSN#">
			select * from #Errores#
			order by ordenerror
		</cfquery>
	<!---Fin de error en el formato de las cuentas de ahorro--->	
	<cfelse>		
		<!----=====================================================================---->
		<!----======================= 5.CALCULAR EL TEST KEY =======================---->
		<!----=====================================================================---->		
		<!---Inserta los creditos--->
		<cfquery name="rs1" datasource="#session.DSN#">
			insert into #TestKey# (oficina,cuenta,oficinacuenta,CuentaOrigen,monto, fechapago)
			select  <cf_dbfunction name="string_part" args="b.DEcuenta,1,3"> as oficina,
					<cf_dbfunction name="string_part" args="b.DEcuenta,1,12"> as cuenta,
					<cf_dbfunction name="string_part" args="b.DEcuenta,1,12"> as oficinacuenta,
					rtrim(b.DEcuenta) as DECUENTA,
					case DRNliquido when 0 then 1 else DRNliquido end,
					(select max(y.CPfpago) 
							from ERNomina x, CalendarioPagos y 
							where x.RCNid = y.CPid and x.ERNid = a.ERNid) as fechapago
			from DRNomina a
				inner join DatosEmpleado b
					on a.DEid = b.DEid				
			where a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#"> 
			  and a.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
			  and <cf_dbfunction name="length" args="rtrim(b.DEcuenta)"> = 12
			  and DRNliquido <> 0
		</cfquery>
		<cfquery datasource="#session.DSN#"><!----Cortar para obtener el valor de la cuenta--->
			update #TestKey# set cuenta = <cf_dbfunction name="string_part" args="cuenta,5,8">
		</cfquery>
		<cfquery datasource="#session.DSN#"><!----Obtener el oficina&cuenta--->		
			update #TestKey# set oficinacuenta = 
			<cf_dbfunction name="concat" args="ltrim(rtrim(oficina)),ltrim(rtrim(cuenta))">
		</cfquery>	
		<!---Inserta el debito
				Asumiendo que en el CBcc es un formato de cuenta cliente NO de ahorro.  Este formato
				es: A00000BBBCCCCCCCD.  Donde A es el codigo que indica si es cuenta corriente (1) o 
				Ahorro(2). B es el codigo de oficina. C el numero de cuenta. D el digito que sigue al
				numero de cuenta (despues del guion). Para un total de 17 digitos.
		--->

		<cfquery datasource="#session.DSN#">
			insert into #TestKey# (oficina,cuenta,
								   oficinacuenta,
								   CuentaOrigen,
								   monto, 
								   fechapago)
			values(	
									'#mid(trim(rsCuentaCliente.CuentaCliente),7,3)#',
									'#mid(trim(rsCuentaCliente.CuentaCliente),10,8)#',
									{fn concat('#mid(trim(rsCuentaCliente.CuentaCliente),7,3)#',
					  				'#mid(rtrim(rsCuentaCliente.CuentaCliente),10,8)#')},		
									'#rsCuentaCliente.CuentaCliente#',
									(#rsMonto.Monto#/100),
									<cfqueryparam cfsqltype="cf_sql_date" value="#rsFechaPago.fechapago#">									
				   )
		</cfquery>
		<cfquery name="temporal" datasource="#session.DSN#">
			select * from #TestKey#
		</cfquery>	
		<cfif temporal.RecordCount NEQ 0>
			<cfquery name="CalcTKey" datasource="#session.DSN#">
				update #TestKey#
				set TKP1 = (<cf_dbfunction name="to_number" args="oficina"> + 
				           <cf_dbfunction name="to_number" args="cuenta">),
				    TKP2 = floor(<cf_dbfunction name="to_number" args="oficinacuenta">/monto)
			</cfquery>
			<cfquery name="TKey" datasource="#session.DSN#"><!---El floor() es para quitar los decimales--->
				select 	sum(TKP1) + floor(sum(TKP2)) as Tkey
				from #TestKey# 
			</cfquery>

			<!---
			<cfquery name="TKeyLZ" datasource="#session.DSN#">
				select <cf_dbfunction name="to_number" args="oficina">  as Oficina,
					   <cf_dbfunction name="to_number" args="cuenta">  as Cuenta ,
					   <cf_dbfunction name="to_number" args="oficina"> + <cf_dbfunction name="to_number" args="cuenta"> as TESTKE1,
					   <cf_dbfunction name="to_number" args="oficinacuenta"> as OficinaCuenta,
					  	monto as Monto,
				        floor(<cf_dbfunction name="to_number" args="oficinacuenta">/monto) as TESTKEY2,
				        CuentaOrigen
				from #TestKey# 
			</cfquery>
			
			<cfquery name="TKeyLZ" datasource="#session.DSN#">
				select *
				from #TestKey# 
			</cfquery>			
			<cfdump var="#TKeyLZ#">
			<cfdump var="#TKEY#">
			<cf_dump var="#vn_testkey#">			
			--->			
			<cfset vn_testkey = TKey.TKey>	

			<!----=====================================================================---->
			<!----=================== 6.INSERTAR LINEA DE CONTROL =====================---->
			<!----=====================================================================---->
			<cfquery name="Control" datasource="#session.DSN#">
				insert into #Datos# (Datos,Orden)
				values( 												
						{fn concat('000',
						{fn concat((case when #12-len(trim(Mid(vs_cedjuridica,1,12)))# > 0 then '#trim(RepeatString('0',12-len(trim(Mid(vs_cedjuridica,1,12)))))#' else '' end ),
						{fn concat('#mid(vs_cedjuridica,1,12)#',
						{fn concat((case when #3-len(trim(Mid(vn_consecarchivo,1,3)))# > 0 then '#trim(RepeatString('0',3-len(trim(Mid(vn_consecarchivo,1,3)))))#' else '' end ),
						{fn concat('#mid(vn_consecarchivo,1,3)#',
						{fn concat('000000',
						{fn concat((case when #12-len(trim(Mid(vs_cedusuario,1,12)))# > 0 then '#trim(RepeatString('0',12-len(trim(Mid(vs_cedusuario,1,12)))))#' else '' end ),
						{fn concat('#Mid(vs_cedusuario,1,12)#',
						{fn concat((case when #12-len(trim(Mid(vn_testkey,1,12)))# > 0 then '#trim(RepeatString('0',12-len(trim(Mid(vn_testkey,1,12)))))#' else '' end ),
						{fn concat('#trim(Mid(trim(vn_testkey),1,12))#',
						{fn concat('000000',
						{fn concat('#LSDateFormat(now(),'ddmmyyyy')#',
						{fn concat('#RepeatString(' ',21)#',
						'Y')})})})})})})})})})})})})}						
						,1
						)				
			</cfquery>			
			<!----=====================================================================---->
			<!----=========== 7.INSERTAR LINEA DE REGISTRO PARA CUENTA A DEBITAR =======---->
			<!----=====================================================================---->
			<cfquery name="insertaLineaRegistroDebita"  datasource="#session.DSN#">		
				insert into #Datos# (Datos,Orden)
				select 	
						{fn concat('000',
						{fn concat((case when #17-len(Mid(rsCuentaCliente.CuentaCliente,1,17))# > 0 then '#RepeatString('0',17-len(Mid(rsCuentaCliente.CuentaCliente,1,17)))#' else '' end ),
						{fn concat('#Mid(trim(rsCuentaCliente.CuentaCliente),1,17)#',
						{fn concat('#rsMonto.Moneda#',
						{fn concat('4',
						{fn concat('0000',
						{fn concat((case when #8-len(Mid(vn_consecarchivo,1,8))# > 0 then '#RepeatString('0',8-len(Mid(vn_consecarchivo,1,8)))#' else '' end ) ,
						{fn concat('#Mid(vn_consecarchivo,1,8)#',					
						{fn concat((case when #12-len(Mid(rsMonto.Monto,1,12))# > 0 then '#RepeatString('0',12-len(Mid(rsMonto.Monto,1,12)))#' else '' end ) ,
						{fn concat('#Mid(rsMonto.Monto,1,12)#',
						{fn concat('#LSDateFormat(now(),'ddmmyyyy')#0',
						{fn concat('#mid(rsCuentaCliente.razon,1,30)#',
							(case when #30-len(Mid(rsCuentaCliente.razon,1,30))# > 0 then '#RepeatString(' ',30-len(Mid(rsCuentaCliente.razon,1,30)))#' else '' end )
						)})})})})})})})})})})})}
						,2						  
				from dual
			</cfquery>
			<!----=====================================================================---->
			<!----=============== 8.INSERTAR LINEAS DE DATOS (CREDITOS)================---->
			<!----=====================================================================---->
			<cfloop query="rsDatos"><!----Insertar en tabla para exportación---->
				<cfset vn_consecarchivo = vn_consecarchivo + 1>
				<cfquery name="Registros" datasource="#session.DSN#">
					insert into #Datos# (Datos,Orden)
					select 	
							{fn concat('000',
							{fn concat('#mid(rsDatos.TipoCuenta,1,1)#',
							{fn concat('00000',
							{fn concat('#mid(rsDatos.CtaAhorro,1,3)#',
							{fn concat('#mid(rsDatos.CtaAhorro,5,7)#',
							{fn concat('#mid(rsDatos.CtaAhorro,12,1)#',
							{fn concat('#rsDatos.Moneda#',
							{fn concat('2',
							{fn concat('0000',
							{fn concat((case when #8-len(Mid(vn_consecarchivo,1,8))# > 0 then '#RepeatString('0',8-len(Mid(vn_consecarchivo,1,8)))#' else '' end ),
							{fn concat('#Mid(vn_consecarchivo,1,8)#',
							{fn concat((case when #12-len(Mid(rsDatos.Monto,1,12))# > 0 then '#RepeatString('0',12-len(Mid(rsDatos.Monto,1,12)))#' else '' end ),
							{fn concat('#Mid(rsDatos.Monto,1,12)#',
							{fn concat('#LSDateFormat(now(),'ddmmyyyy')#',
							{fn concat('0',
							{fn concat('#Mid(rsDatos.razon,1,30)#',
								(case when #30-len(Mid(rsDatos.razon,1,30))# > 0 then '#RepeatString(' ',30-len(Mid(rsDatos.razon,1,30)))#' else '' end )
							)})})})})})})})})})})})})})})})}						
							,3				  
					from dual
				</cfquery>
			</cfloop>
			<cfquery name="ERR" datasource="#session.DSN#">
				select * from #Datos#
				order by Orden asc
			</cfquery>	
		<cfelse>
			<cfquery name="ERR" datasource="#session.DSN#">
				select 'Existen cuentas de ahorro con formato incorrecto. El formato de la cuenta es xxx-yyyyyyyz.  
						Donde x corresponde a la oficina, y corresponde a la cuenta y z corresponde a el dígito de la cuenta'
				from dual
			</cfquery>
		</cfif><!---Fin de formato cuenta testkey--->
	</cfif>	<!---Fin de formato de cuentas correcto/incorrecto--->
</cfif><!---Fin de cedula juridica/usuario logueado--->
<cf_dbfunction name="to_number" args="Pvalor" returnvariable="Pvalor">
<cfquery name="rsConsecutivo_1" datasource="#session.DSN#">
	update RHParametros 
	set Pvalor = <cf_dbfunction name="to_char" args="#Pvalor#+1">
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
	and Pcodigo = 210
</cfquery>
