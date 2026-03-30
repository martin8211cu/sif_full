<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="Existen_cuentas_clientes_con_formato_incorrecto_El_formato_debe_ser_numerico_y_de_17_dígitos_continuos"
Default="Existen cuentas clientes con formato incorrecto. El formato debe ser numérico y de 17 dígitos continuos."
returnvariable="MG_CuentaCliente"/> 


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

<cf_dbtemp name="DatosBancos" returnvariable="Datos" datasource="#session.DSN#"><!---Tabla temporal de datos que van a ser insertados ---->
	<cf_dbtempcol name="Datos" 	type="char(194)"  	mandatory="no">
	<cf_dbtempcol name="Orden"	type="int" 			mandatory="no">
</cf_dbtemp>

<!---====== NUMERO ARCHIVO: Calcular el numero de consecutivo de archivo, envio de mas de un archivo el mismo dia ======----->
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
	<cfset vn_consecarchivo = 0>
</cfif>

<!---====== NUMERO NEGOCIO: Número de cédula jurídica de la empresa ====---->
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
<!---====== CEDULA REGISTRO: Cedula del funcionario de la empresa que genera el archivo =====--->
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
	<!---====== TESTKEY ======------>	
	<cf_dbtemp name="TestKey" returnvariable="TestKey" datasource="#session.DSN#">
		<cf_dbtempcol name="Valor1" 			type="varchar(50)"  mandatory="no">
		<cf_dbtempcol name="CBcc"				type="varchar(50)" mandatory="no">
		<cf_dbtempcol name="ValorA"				type="varchar(50)" mandatory="no">
		<cf_dbtempcol name="ValorB"				type="varchar(50)" mandatory="no">
		<cf_dbtempcol name="Largo"				type="int" mandatory="no">
		<cf_dbtempcol name="Liquido"			type="numeric(12,2)" mandatory="no">
		<cf_dbtempcol name="Largo2"				type="int" mandatory="no">
	</cf_dbtemp>		
	<cfquery name="rs1" datasource="#session.DSN#">
		insert into #TestKey# (Valor1,CBcc,ValorA,Largo,Liquido,Largo2)
		select  <cf_dbfunction name="string_part" args="b.CBcc,6,3">,
				coalesce(b.CBcc,a.CBcc) as CBcc,
				coalesce(b.CBcc,a.CBcc) as ValorA,
				coalesce((<cf_dbfunction name="length" args="ltrim(rtrim(b.CBcc))">)-9,0) as columna,
				case DRNliquido when 0 then 1 else DRNliquido end,
				coalesce((<cf_dbfunction name="length" args="ltrim(rtrim(b.CBcc))">)-6,0)
		from DRNomina a
			inner join DatosEmpleado b
				on a.DEid = b.DEid				
		where a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#"> 
		  and a.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
		  and <cf_dbfunction name="length" args="rtrim(b.CBcc)"> > 16
	</cfquery>
	<cfquery name="temporal" datasource="#session.DSN#">
		select * from #TestKey#
	</cfquery>
	<cfif temporal.RecordCount NEQ 0>
		<cfset vn_largo = IIf(temporal.Largo lt 0, '0', '#temporal.Largo#')>
		<cfset vn_largo2 = IIf(temporal.Largo2 lt 0, '0', '#temporal.Largo2#')>
		<cfquery datasource="#session.DSN#">
			update #TestKey# set ValorA = <cf_dbfunction name="string_part" args="ValorA,9,#vn_largo#">
		</cfquery>
		<cfquery datasource="#session.DSN#">
			update #TestKey# set ValorB = <cf_dbfunction name="string_part" args="CBcc,6,#vn_largo2#">
		</cfquery>
		<cftry>
			<cfquery name="TKey" datasource="#session.DSN#">
				select 	sum(<cf_dbfunction name="to_number" args="Valor1"> + <cf_dbfunction name="to_number" args="ValorA">) + sum(floor(<cf_dbfunction name="to_number" args="ValorB">/Liquido)) as TKey
				from #TestKey# 
			</cfquery>
		<cfcatch type="any">
			<cf_throw message="#MG_CuentaCliente#" errorcode="6035">
		</cfcatch>	
		</cftry>
		<cfset vn_testkey = TKey.TKey>	
		<!---========= 1.INSERTAR LINEA DE CONTROL ==========---->
		<cfif 12-len(trim(vs_cedjuridica)) GT 0>
			<cfset vs_cedjuridica = repeatString('0',12-len(trim(vs_cedjuridica)))&vs_cedjuridica>
		</cfif>
		<cfif 12-len(trim(vs_cedusuario)) GT 0>
			<cfset vs_cedusuario = repeatString('0',12-len(trim(vs_cedusuario)))&vs_cedusuario>
		</cfif>
		<cfif 12-len(trim(vn_testkey)) GT 0>
			<cfset vn_testkey = repeatString('0',12-len(trim(vn_testkey)))&vn_testkey>
		</cfif>
		<cfif 3-len(trim(vn_consecarchivo)) GT 0>
			<cfset vn_consecarchivo = repeatString('0',3-len(trim(vn_consecarchivo)))&vn_consecarchivo>
		</cfif>
		<cfquery name="Control" datasource="#session.DSN#">
			insert into #Datos# (Datos,Orden)
			values( 						
					{fn concat('000',
					{fn concat('#trim(Mid(trim(vs_cedjuridica),1,12))#',
					{fn concat('#trim(Mid(trim(vn_consecarchivo),1,12))#',
					{fn concat('#RepeatString('0',6)#',
					{fn concat('#trim(Mid(trim(vs_cedusuario),1,12))#',
					{fn concat('#trim(Mid(trim(vn_testkey),1,12))#',
					{fn concat('#RepeatString('0',6)#',
					{fn concat('#LSDateFormat(now(),'ddmmyyyy')#',
					{fn concat('#RepeatString(' ',21)#','Y'
					)})})})})})})})})}					
					<!----					
					'000'+					
					'#trim(Mid(trim(vs_cedjuridica),1,12))#'+
					'#trim(Mid(trim(vn_consecarchivo),1,12))#'+
					'#RepeatString('0',6)#'+
					'#trim(Mid(trim(vs_cedusuario),1,12))#'+
					'#trim(Mid(trim(vn_testkey),1,12))#'+
					'#RepeatString('0',6)#'+
					'#LSDateFormat(now(),'ddmmyyyy')#'+
					'#RepeatString(' ',21)#'+
					'Y'----->
					,1
					)
		</cfquery>	
		
		<!----======= 2. NUMERO DE CUENTA CLIENTE: Cuenta que debita ==========---->
		<cfquery name="rsCuentaCliente" datasource="#session.DSN#">
			select 	ltrim(rtrim(CBcc)) as CuentaCliente, 
					ERNid as documento,
					coalesce(ERNdescripcion,'Pago de planilla')	as razon				
			from ERNomina 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">  
		</cfquery>
		<!---============ 7. SUMA DE LOS MONTOS A ACREDITAR A C/EMPLEADO(REGISTROS DE DETALLE)(Total a debitar) ==============---->
		<cfquery name="rsMonto"  datasource="#session.DSN#">		
			select 	sum(coalesce(<cf_dbfunction name="to_number" args="(b.DRNliquido) * 100">,0)) as Monto,					
					'1' as Moneda <!---Actualmente solo se tramitan colones---->					
			from ERNomina a
				inner join DRNomina b
					on a.ERNid = b.ERNid								
				inner join Monedas d
					on a.Mcodigo = d.Mcodigo							
			where a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
				and b.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#"> 
			group by case d.Miso4217 when 'CRC' then '01' else '02'  end
		</cfquery>	
		<cfif 17-len(trim(rsCuentaCliente.CuentaCliente)) GT 0>
			<cfset CuentaCliente = repeatString('0',17-len(trim(rsCuentaCliente.CuentaCliente)))&rsCuentaCliente.CuentaCliente>
		<cfelse>
			<cfset CuentaCliente = rsCuentaCliente.CuentaCliente>
		</cfif>
		<cfif 8-len(trim(rsCuentaCliente.documento)) GT 0>
			<cfset documento = repeatString('0',8-len(trim(rsCuentaCliente.documento)))&rsCuentaCliente.documento>
		<cfelse>
			<cfset documento = rsCuentaCliente.documento>
		</cfif>
		<cfif 12-len(trim(rsMonto.Monto)) GT 0>
			<cfset Monto = repeatString('0',12-len(trim(rsMonto.Monto)))&rsMonto.Monto>
		<cfelse>
			<cfset Monto = rsMonto.Monto>
		</cfif>
		<cfif len(trim(rsCuentaCliente.razon)) EQ 0>
			<cfset razon='Pago de planilla'>
		</cfif>
		<cfquery name="insertaLineaRegistroDebita"  datasource="#session.DSN#">		
			insert into #Datos# (Datos,Orden)
			values( 
					{fn concat('000',
					{fn concat('#Mid(trim(CuentaCliente),1,17)#',
					{fn concat('#rsMonto.Moneda#',
					{fn concat('4',
					{fn concat('0000',
					{fn concat('#Mid(documento,1,8)#',
					{fn concat('#Mid(Monto,1,12)#',
					{fn concat('#LSDateFormat(now(),'ddmmyyyy')#',
					{fn concat('0','#Mid(rsCuentaCliente.razon,1,30)#'					
					)})})})})})})})})}
					<!---
					'000'+	
					'#Mid(trim(CuentaCliente),1,17)#'+
					'#rsMonto.Moneda#'+
					'4'+
					'0000'+
					'#Mid(documento,1,8)#'+
					'#Mid(Monto,1,12)#'+
					'#LSDateFormat(now(),'ddmmyyyy')#'+
					'0'+
					'#Mid(rsCuentaCliente.razon,1,30)#'	
					---->						
					,2)				  			
		</cfquery>
	
		<!---=========== 3. INSERTAR LINEAS DE DATOS (Creditos) ===========---->
		<cfquery name="rsDatos" datasource="#session.DSN#"><!---Seleccionar los datos----->
			select 	ltrim(rtrim(coalesce(c.CBcc,b.CBcc))) as CtaCliente,			
					coalesce(<cf_dbfunction name="to_number" args="(b.DRNliquido) * 100">,0) as Monto,
					case c.NTIcodigo when 'C' then '01' else '02' end as TipoCedula,
					c.DEidentificacion as Cedula,
					{fn concat(ltrim(rtrim(c.DEnombre)),{fn concat(' ',{fn concat(ltrim(rtrim(c.DEapellido1)),{fn concat(' ',ltrim(rtrim(c.DEapellido2)))})})})} as Servicio,			
					c.DEemail as Correo,
					'1' as Moneda <!---Actualmente solo se tramitan colones---->
					,b.DRNlinea as documento
					,coalesce(a.ERNdescripcion,'Pago de planilla') as razon	
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
		
		<cfloop query="rsDatos"><!----Insertar en tabla para exportación---->			
			<cfif (17-len(trim(rsDatos.CtaCliente))) GT 0>
				<cfset vCtaCliente = repeatString('0',17-len(trim(rsDatos.CtaCliente)))& rsDatos.CtaCliente>				
			<cfelse>
				<cfset vCtaCliente = rsDatos.CtaCliente>
			</cfif>
			<cfif (8-len(trim(rsDatos.currentRow))) GT 0>
				<cfset vdocumento = repeatString('0',8-len(trim(rsDatos.currentRow)))& rsDatos.currentRow>
			<cfelse>
				<cfset vdocumento = rsDatos.currentRow>
			</cfif>
			<cfif (12-len(trim(rsDatos.Monto))) GT 0>
				<cfset vMonto = repeatString('0',12-len(trim(rsDatos.Monto)))& rsDatos.Monto>
			<cfelse>
				<cfset vMonto = rsDatos.Monto>
			</cfif>
			<cfif len(trim(rsDatos.razon)) EQ 0>
				<cfset vrazon = 'Pago de planilla'>
			<cfelse>
				<cfset vrazon =rsDatos.razon>
			</cfif>
			<cfquery name="Registros" datasource="#session.DSN#">
				insert into #Datos# (Datos,Orden)
				values( 	
						{fn concat('000',
						{fn concat('#Mid(vCtaCliente,1,17)#',
						{fn concat('#rsDatos.Moneda#',
						{fn concat('2',
						{fn concat('0000',
						{fn concat('#Mid(vdocumento,1,8)#',
						{fn concat('#Mid(vMonto,1,12)#',
						{fn concat('#LSDateFormat(now(),'ddmmyyyy')#',
						{fn concat('0','#Mid(vrazon,1,30)#'
						)})})})})})})})})}
						<!---
						'000'+
						'#Mid(vCtaCliente,1,17)#'+
						'#rsDatos.Moneda#'+
						'2'+
						'0000'+
						'#Mid(vdocumento,1,8)#'+
						'#Mid(vMonto,1,12)#'+
						'#LSDateFormat(now(),'ddmmyyyy')#'+
						'0'+
						'#Mid(vrazon,1,30)#'
						---->						
						,
						3)				  
			</cfquery>
		</cfloop>	
		<cfquery name="ERR" datasource="#session.DSN#">
			select Datos,Orden from #Datos#
			order by Orden asc
		</cfquery>
	</cfif>
</cfif>	
