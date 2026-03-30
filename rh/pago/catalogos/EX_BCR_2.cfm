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

<cf_dbtemp name="Datos" returnvariable="Datos" datasource="#session.DSN#"><!---Tabla temporal de datos que van a ser insertados ---->
	<cf_dbtempcol name="Datos" 	type="char(194)"  	mandatory="no">
	<cf_dbtempcol name="Orden"	type="int" 			mandatory="no">
</cf_dbtemp>


<!--- prefijo para indicar si se trata de nominas en historico o en proceso--->
<cfset pre="">
<cfif isdefined("url.estado") and len(trim(#url.estado#)) GT 0 and trim(#url.estado#) EQ "h">
	<cfset pre="H">
</cfif>

<!---====== 3. CONSECUTIVO ARCHIVO: Calcular el numero de consecutivo de archivo, envio de mas de un archivo el mismo da ======----->
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

<!---- =================== Modificación 20/06/2006 (Solicitado por Freddy Leiva) ===================
<cfquery name="rsCedJuridica" datasource="asp">
	select ltrim(rtrim(Eidentificacion)) as cedulajuridica
	from Empresa
	where Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#url.EcodigoASP#">
</cfquery>
<cfif isdefined("rsCedJuridica") and len(trim(rsCedJuridica.cedulajuridica))>
	<cfset vs_cedjuridica = Replace(rsCedJuridica.cedulajuridica,'-','','all')><!---Reemplazando los guiones--->
<cfelse>
	<cfquery name="ERR" datasource="#session.DSN#">
		select 'No se ha definido la cédula jurdica (Identificacin) de la empresa' as Error
		from dual
	</cfquery>
</cfif>
---->
<!---====== 5. CEDULA REGISTRO: Cedula del funcionario de la empresa que genera el archivo =====--->
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
	<!---====== 6. TESTKEY ======------>
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
				case #pre#DRNliquido when 0 then 1 else #pre#DRNliquido end,
				coalesce((<cf_dbfunction name="length" args="ltrim(rtrim(b.CBcc))">)-6,0)
		from #pre#DRNomina a
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
			<cfthrow message="Existen cuentas clientes con formato incorrecto. El formato debe ser numérico y de 17 dígitos continuos.">
		</cfcatch>	
		</cftry>
		<cfset vn_testkey = TKey.TKey>	
		
		<cf_dbfunction name="OP_concat" returnvariable="_Cat">
		
		<!---========= INSERTAR LINEA DE CONTROL ==========---->
		<cfquery name="Control" datasource="#session.DSN#">
			INSERT INTO #Datos# (Datos,Orden)
			SELECT '000'
							#_Cat# (case when #12-len(trim(Mid(trim(vs_cedjuridica),1,12)))# > 0 then '#trim(RepeatString('0',12-len(trim(Mid(trim(vs_cedjuridica),1,12)))))#' end )
							#_Cat#'#trim(Mid(trim(vs_cedjuridica),1,12))#'
							#_Cat#(case when #3-len(vn_consecarchivo)# > 0 then '#RepeatString('0',3-len(vn_consecarchivo))#' end )
							#_Cat#'#Mid(vn_consecarchivo,1,3)#'
							#_Cat#'#LSDateFormat(now(),'ddmmyyyy')#'
							#_Cat#(case when #12-len(Mid(trim(vs_cedusuario),1,12))# > 0 then '#RepeatString('0',12-len(Mid(trim(vs_cedusuario),1,12)))#' end )
							#_Cat#<cfif Mid(trim(vs_cedusuario),1,12) gt 0>'#Mid(trim(vs_cedusuario),1,12)#'<cfelse>null</cfif>
							#_Cat#(case when #12-len(Mid(vn_testkey,1,12))# > 0 then '#RepeatString('0',12-len(Mid(vn_testkey,1,12)))#' end )
							#_Cat#(case when #len(vn_testkey)# > 0 then '#Mid(vn_testkey,1,12)#' end)				
							#_Cat#'#RepeatString('0',6)#'
							#_Cat#'#RepeatString(' ',6)#'
							#_Cat#'TLB'
							#_Cat#'#RepeatString(' ',128)#'
							#_Cat#'D'
							,1
			FROM dual			
		</cfquery>	
		
		<!---========= INSERTAR LINEA DE REGISTRO PARA CUENTA A DEBITAR (Solicitado por Freddy Leiva 20/06/2006) ==========---->
		<!----======= 2. NUMERO DE CUENTA CLIENTE: Cuenta que debita ==========---->
		<cfquery name="rsCuentaCliente" datasource="#session.DSN#">
			select ltrim(rtrim(CBcc)) as CuentaCliente
			from #pre#ERNomina 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">  
		</cfquery>
		<!---============ 7. SUMA DE LOS MONTOS A ACREDITAR A C/EMPLEADO(REGISTROS DE DETALLE)(Total a debitar) ==============---->
		<cfquery name="rsMonto"  datasource="#session.DSN#">		
			SELECT 	sum(coalesce(<cf_dbfunction name="to_number" args="(b.#pre#DRNliquido) * 100">,0)) as Monto,					
					case d.Miso4217 when 'CRC' then '01' else '02' end as Moneda
			FROM #pre#ERNomina a
				inner join #pre#DRNomina b
					on a.ERNid = b.ERNid								
				inner join Monedas d
					on a.Mcodigo = d.Mcodigo							
			WHERE a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
				and b.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#"> 
			GROUP BY case d.Miso4217 when 'CRC' then '01' else '02'  end
		</cfquery>	
		<cfquery name="insertaLineaRegistroDebita"  datasource="#session.DSN#">		
			INSERT INTO #Datos# (Datos,Orden)
			SELECT 	'000'
					#_Cat#(case when #17-len(Mid(trim(rsCuentaCliente.CuentaCliente),1,17))# > 0 then '#RepeatString('0',17-len(Mid(trim(rsCuentaCliente.CuentaCliente),1,17)))#' end ) 
					#_Cat#'#Mid(trim(rsCuentaCliente.CuentaCliente),1,17)#'
					#_Cat#'#rsMonto.Moneda#'
					#_Cat#'4'
					#_Cat#'0000'
					#_Cat#(case when #8-len(Mid(vn_documento,1,8))# > 0 then '#RepeatString('0',8-len(Mid(vn_documento,1,8)))#' end ) 
					#_Cat#'#Mid(vn_documento,1,8)#'
					#_Cat#(case when #12-len(Mid(rsMonto.Monto,1,12))# > 0 then '#RepeatString('0',12-len(Mid(rsMonto.Monto,1,12)))#' end ) 
					#_Cat#'#Mid(rsMonto.Monto,1,12)#'
					#_Cat#'#LSDateFormat(now(),'ddmmyyyy')#'
					#_Cat#'00'
					#_Cat#'01'
					#_Cat#(case when #20-len(Mid(vs_cedjuridica,1,20))# > 0 then '#RepeatString('0',20-len(Mid(Replace(vs_cedjuridica,'-','','all'),1,20)))#' end ) 
					#_Cat#'#mid(Replace(vs_cedjuridica,'-','','all'),1,20)#'
					#_Cat#'    Pago de planilla'
					#_Cat#'#RepeatString(' ',25)#'
					#_Cat#'#RepeatString(' ',20)#'
					#_Cat#'#RepeatString(' ',50)#'
					,2
			FROM dual
		</cfquery>
		<!---=========== INSERTAR LINEAS DE DATOS ===========---->
		<cfquery name="rsDatos" datasource="#session.DSN#"><!---Seleccionar los datos----->
			SELECT 	ltrim(rtrim(coalesce(c.CBcc,b.CBcc))) as CtaCliente,			
					coalesce(<cf_dbfunction name="to_number" args="(b.#pre#DRNliquido) * 100">,0) as Monto,
					case c.NTIcodigo when 'C' then '01' else '02' end as TipoCedula,
					c.DEidentificacion as Cedula,
					ltrim(rtrim(c.DEnombre))#_Cat#' '#_Cat#ltrim(rtrim(c.DEapellido1))#_Cat#' '#_Cat#ltrim(rtrim(c.DEapellido2)) as Servicio,			
					c.DEemail as Correo,
					case d.Miso4217 when 'CRC' then '01' else '02' end as Moneda
			FROM #pre#ERNomina a
				inner join #pre#DRNomina b
					on a.ERNid = b.ERNid								
					inner join Monedas d
						on b.Mcodigo = d.Mcodigo			
					inner join DatosEmpleado c
						on b.DEid = c.DEid
						and c.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
			where a.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
				and b.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#"> 
				and b.#pre#DRNliquido != 0
		</cfquery>
		
		<cfloop query="rsDatos"><!----Insertar en tabla para exportación---->
			<cfquery name="Registros" datasource="#session.DSN#">
				INSERT INTO #Datos# (Datos,Orden)
				SELECT   '000'
						#_Cat#(case when #17-len(Mid(rsDatos.CtaCliente,1,17))# > 0 then '#RepeatString('0',17-len(Mid(rsDatos.CtaCliente,1,17)))#' end ) 
						#_Cat#'#Mid(rsDatos.CtaCliente,1,17)#'
						#_Cat#'#rsDatos.Moneda#'
						#_Cat#'2'
						#_Cat#'0000'
						#_Cat#(case when #8-len(Mid(vn_documento,1,8))# > 0 then '#RepeatString('0',8-len(Mid(vn_documento,1,8)))#' end ) 
						#_Cat#'#Mid(vn_documento,1,8)#'
						#_Cat#(case when #12-len(Mid(rsDatos.Monto,1,12))# > 0 then '#RepeatString('0',12-len(Mid(rsDatos.Monto,1,12)))#' end ) 
						#_Cat#'#Mid(rsDatos.Monto,1,12)#'
						#_Cat#'#LSDateFormat(now(),'ddmmyyyy')#'
						#_Cat#'00'
						#_Cat#'#rsDatos.TipoCedula#'
						#_Cat#(case when #20-len(Mid(rsDatos.Cedula,1,20))# > 0 then '#RepeatString('0',20-len(Mid(Replace(rsDatos.Cedula,'-','','all'),1,20)))#' end ) 
						#_Cat#'#mid(Replace(rsDatos.Cedula,'-','','all'),1,20)#'
						#_Cat#'#mid(rsDatos.Servicio,1,20)#'
						#_Cat#(case when #20-len(mid(rsDatos.Servicio,1,20))# > 0 then '#RepeatString(' ',20-len(mid(rsDatos.Servicio,1,20)))#' end ) 
						#_Cat#'#RepeatString(' ',25)#'
						#_Cat#'#RepeatString(' ',20)#'
						#_Cat#'#RepeatString(' ',50)#'S
						,3				  
				FROM dual
			</cfquery>
		</cfloop>
		<cfquery name="ERR" datasource="#session.DSN#">
			SELECT * FROM #Datos#
			ORDER BY Orden asc
		</cfquery>		
	</cfif>
</cfif>	