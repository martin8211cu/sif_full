


<!--- Archivo BCR PAGO EMPRESAS --->
<!--- Datos de ParametrizaciÃ³n:
CEDULA EMPRESA --- InformaciÃ³n del Portal IdentificaciÃ³n de la Empresa. Formato: X-XXX-XXXXXX
CUENTA BANCOS EMPRESA --- InformaciÃ³n de la CuentaCliente asociada al Banco con que se pago 17 digitos
CUENTA EMPLEADOS --- Cuenta donde se le paga al Empleado Formato: XXX-YYYYYYYZ (Oficina-Cuenta-Digito Verificador) y Cedula de Identifidad o Cedula Alternativa (Dato Variable 5) --->

<!---Paramerametros que trae el exportador--->
<cfparam name="url.Bid" 		type="string" default="">	
<cfparam name="url.ERNid" 		type="string" default="">	
<cfparam name="url.RCNid" 		type="string" default="">
<cfparam name="url.EcodigoASP" 	type="numeric" default="#session.EcodigoSDC#">	
	

<cf_dbtemp name="reporte" returnvariable="reporte" datasource="#session.dsn#">
	<cf_dbtempcol name="Consecutivo"	type="char(3)" mandatory="no">
	<cf_dbtempcol name="Concepto"		type="char(1)" mandatory="no">
	<cf_dbtempcol name="Oficina" 		type="char(3)" mandatory="no">
	<cf_dbtempcol name="Cuenta" 		type="char(17)" mandatory="no">
	<cf_dbtempcol name="Moneda" 		type="char(2)" mandatory="no">
	<cf_dbtempcol name="Cedula" 		type="char(20)" mandatory="no">
	<cf_dbtempcol name="Nombre" 		type="char(50)" mandatory="no">
	<cf_dbtempcol name="Monto" 			type="numeric" mandatory="no">
	<cf_dbtempcol name="TipoCedula" 	type="char(1)" mandatory="no">
	<cf_dbtempcol name="TipoRegistro" 	type="char(1)" mandatory="no"><!--- 1 = Empleados, 2 = Encabezado , 3 = contable--->
</cf_dbtemp>

<cf_dbtemp name="salida" returnvariable="salida" datasource="#session.dsn#">
	<cf_dbtempcol name="datos"	type="char(194)" mandatory="no">
	<cf_dbtempcol name="consecutivo"	type="numeric" mandatory="no">	
</cf_dbtemp>

<cf_dbfunction name="OP_concat" returnvariable="_Cat">

<cfset Errs=''>

<!---Identificacion de la Empresa---->
<cfquery name="rsEmpresaDatos" datasource="asp">
	select <cf_dbfunction name="sReplace"     args="Eidentificacion|'-'|''"  delimiters="|"> as Eidentificacion ,Enombre
	from Empresa
	where Ereferencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfif rsEmpresaDatos.RecordCount GT 0>	
		<cfif LSIsNumeric(rsEmpresaDatos.Eidentificacion) EQ false>
			<cfset Errs =  Errs & 'La Identificaci&oacute;n de la empresa #rsEmpresaDatos.Eidentificacion# posee digitos NO numerales. <br>'>
		</cfif>
		<cfif Errs NEQ ''>
			<cfset Errs =  Errs & 'Ingrese a la Informaci&oacute;n de la Empresa (Administraci&oacute;n del Portal) y modifique la Identificaci&oacute;n<br><br><br>'>		
		</cfif>
    <cfelse>
			<cfset Errs =  Errs & 'No se ha definido la Identificaci&oacute; de la Empresa <br>'>
			<cfset Errs =  Errs & 'Ingrese a la Informaci&oacute;n de la Empresa (Administraci&oacute;n del Portal) y modifique la Identificaci&oacute;n<br><br><br>'>		
</cfif>
<cfif Errs NEQ ''>
		<cfset Errs = 'Errores en Informaci&oacute; de la Empresa <br><br>' & Errs>
</cfif>

<cfset url.Estado='P'>
<cfquery name="TipoCambio" datasource="#session.DSN#">
		Select  distinct coalesce(b.RCtc,1) as TipoCambio
				from ERNomina a inner join
				RCalculoNomina b
				on a.RCNid = b.RCNid
				Where ERNid in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#url.ERNid#">)
</cfquery>

<cfif TipoCambio.recordcount EQ 0>
		<cfset url.Estado='H'>
		<cfquery name="HTipoCambio" datasource="#session.DSN#">
				Select distinct coalesce(b.RCtc,1) as TipoCambio
				from HERNomina a inner join
				HRCalculoNomina b
				on a.RCNid = b.RCNid
				Where ERNid in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#url.ERNid#">)
		</cfquery>			
</cfif>
<cfif isdefined('url.Estado') and url.Estado EQ 'h'>
	
	<!---Optiene la Cuenta en que se realizo el pago del Banco correspondiente--->
	<cfquery name="rsEmpresaCuenta" datasource="#session.DSN#">
		select distinct c.CBcc
		from HERNomina b 
		
		inner join HDRNomina a 
		on a.ERNid = b.ERNid
		
		inner join HRCalculoNomina e
		on e.RCNid = b.RCNid
		
		inner join CuentasBancos c
		on  e.CBid = c.CBid  
		
		where a.ERNid in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#url.ERNid#">)
		and b.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
	</cfquery>
	<!---Validacion de la Cuenta de la empresa--->
	<cfset Errs2 = ''>
	<cfif rsEmpresaCuenta.RecordCount GT 0>	
		<cfif len(trim(rsEmpresaCuenta.CBcc)) NEQ 17>
			<cfset Errs2 =  Errs2 & 'La cuenta bancaria de la empresa #rsEmpresaCuenta.CBcc# debe tener 17 digitos <br>'>
		</cfif>
		<cfif LSIsNumeric(rsEmpresaCuenta.CBcc) EQ false>
			<cfset Errs2 =  Errs2 & 'La cuenta bancaria de la empresa #rsEmpresaCuenta.CBcc# posee digitos NO numerales. <br>'>
		</cfif>
    <cfelse>
			<cfset Errs2 =  Errs2 & 'No se ha definido una Cuenta de Bancos. <br>'>
			<cfset Errs2 =  Errs2 & 'Ingrese a Par&aacute;metros RH, Cat&aacute;logo de Bancos, Cuentas Bancarias e indique la Cuenta Cliente. <br><br><br>'>					
	</cfif>
	<cfif Errs2 NEQ ''>
			<cfset Errs2 =  Errs2 & 'Errores Cuenta Bancaria de la Empresa <br><br>'& Errs2 & 'Ingrese a Par&aacute;metros RH, Cat&aacute;logo de Bancos, Cuentas Bancarias y modifique los inconvenientes en el campo Cuenta Cliente. <br><br><br>'>		
	</cfif>
	<cfset ofiEmpresa = ''>
	<cfset cuentaEmpresa = '#rsEmpresaCuenta.CBcc#'>
	
	<!---Validacion de la Cuentas Empleados--->
	<cfquery name="InsertDatos" datasource="#session.DSN#">
		select c.DEcuenta, c.DEid,
		 coalesce(c.DEdato5,c.DEidentificacion) as DEidentificacion
		 ,#_Cat# c.DEnombre  #_Cat# ' ' #_Cat# c.DEapellido1  #_Cat# ' ' #_Cat# DEapellido2 as empleado
		from  HERNomina b
			  inner join  HDRNomina a
				on a.ERNid = b.ERNid
			  inner join  DatosEmpleado c
				on c.DEid = a.DEid
		where 
			a.ERNid in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#url.ERNid#">)
			and c.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
	</cfquery>
	<cfset Errs3 = ''>	
	<cfloop query="InsertDatos">
		<cfif len(trim(InsertDatos.DEcuenta)) NEQ 12>
			<cfset Errs3 =  Errs3 & 'La cuenta #InsertDatos.DEcuenta#  del empleado #InsertDatos.DEidentificacion# - #InsertDatos.empleado# no cumple con la cantidad de digitos permitidos. <br>'>
		</cfif>
		<cfif mid(InsertDatos.DEcuenta,4,1) NEQ '-'>
			<cfset Errs3 =  Errs3 & 'La cuenta #InsertDatos.DEcuenta#  del empleado #InsertDatos.DEidentificacion# - #InsertDatos.empleado#  debe poseer como separador un guion en la cuenta.<br>'>
		</cfif>
		<cfif LSIsNumeric(mid(InsertDatos.DEcuenta,1,3)) EQ false>
			<cfset Errs3 =  Errs3 & 'La cuenta #InsertDatos.DEcuenta#  del empleado #InsertDatos.DEidentificacion# - #InsertDatos.empleado#  posee digitos NO numerales. <br>'>
		</cfif>
		<cfif LSIsNumeric(mid(InsertDatos.DEcuenta,5,8)) EQ false>
			<cfset Errs3 =  Errs3 & 'La cuenta #InsertDatos.DEcuenta#  del empleado #InsertDatos.DEidentificacion# - #InsertDatos.empleado#  posee digitos NO numerales. <br>'>
		</cfif>
		<cfif Errs3 NEQ ''>
			<cfset Errs3 = Errs3 &"<br>">
		</cfif>	
	</cfloop>
	<cfif Errs3 NEQ ''>
		<cfset Errs3 =  Errs3 & 'Corriga los inconvenientes en el Cat&aacute;logo de Empleados, Cuenta de ahorros del Empleado <br><br>'>
		<cfset Errs = Errs & 'Errores Cuentas de los Empleados<br><br>' & Errs3>
	</cfif>
	<cfif len(trim(Errs))>
		<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&ErrMsg=Errores Encontrados<br>&ErrDet=#URLEncodedFormat(Errs)#" addtoken="no">
		<cfabort>
	</cfif>
	<!---Fin de Validacion de las cuentas--->
	<!---Suma salarios--->
	<cfquery name="rsSalarios" datasource="#session.DSN#">
		select coalesce(<cf_dbfunction name="to_number" args="(SUM(y.HDRNliquido)/#HTipoCambio.TipoCambio#) * 100">,0)as monto
		from  HERNomina x
			  inner join  HDRNomina y
				on y.ERNid = x.ERNid
			  inner join  DatosEmpleado w
				on w.DEid = y.DEid
		where 
			x.ERNid in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#url.ERNid#">)
			and w.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
	</cfquery>

	<!---<cfdump var="#rsSalarios.monto#">--->
	<!---Insercion Datos Empresa--->
	<cfquery name="InsertDatos" datasource="#session.DSN#">
		insert into #reporte# (Consecutivo,Concepto,Oficina,Cuenta,Moneda,Cedula,Nombre,Monto,TipoCedula)
		values( 
			'0',																					<!---consecutivo, se actualiza adelante--->
			'2',																					<!---??????--->
			'#ofiEmpresa#',																			<!---Primeros tres digitos de la cuenta--->
			'#cuentaEmpresa#',																		<!---Cuenta Bancaria para DepÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â³sito, ultimos 7 digitos --->
			'2',																					<!---Dolares para todos los casos--->
			'#rsEmpresaDatos.Eidentificacion#',														<!---Identificacion de la empresa--->								
			'Nominas Varias',																		<!---Nombre de la nomina--->
			#rsSalarios.monto#,																		<!---Suma de los salarios de los empleados--->
			'1')																					<!---2=Empleado, 1=Empresa--->
																								
	</cfquery>

	<!---Insercion Datos de Empleados--->
	<cfquery name="InsertDatos" datasource="#session.DSN#">
		insert into #reporte# (Consecutivo,Concepto,Oficina,Cuenta,Moneda,Cedula,Nombre,Monto,TipoCedula)
		select 
			'0' as Consecutivo,																				<!---consecutivo, se actualiza adelante--->
			'2' as Concepto,																				<!---??????--->
			<cf_dbfunction name="sPart"		args="c.DEcuenta,1,3"> as Oficina,								<!---??????--->
			<cf_dbfunction name="sPart"		args="c.DEcuenta,5,8"> as cuenta,								<!---Cuenta Bancaria Asociada al Banco--->
			'2' as Moneda,																					<!---Dolares para todos los casos--->
			<cf_dbfunction name="sReplace"     args="coalesce(c.DEdato5,c.DEidentificacion)|'-'|''"  delimiters="|"> as Cedula,	<!---Identificacion del Empleado--->
			left(c.DEnombre #_Cat#' '#_Cat# c.DEapellido1 #_Cat#' '#_Cat#  c.DEapellido2,50)  as nombre,									<!---Nombre completo del Empleado--->
			<cf_dbfunction name="to_number" args ="round(round(a.HDRNliquido/#HTipoCambio.TipoCambio#,2) * 100,0)"> as Monto, 	<!---Monto salario liquido--->
			'2' as TipoCedula																									<!---2=Empleado, 1=Empresa--->
																							
		from  HERNomina b
			  inner join  HDRNomina a
				on a.ERNid = b.ERNid
			  inner join  DatosEmpleado c
				on c.DEid = a.DEid
		where 
			a.ERNid in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#url.ERNid#">)
			and c.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
	</cfquery>
	
	<!---<cfdump var="#url.ERNid#">
	<cf_dumptable var="#reporte#">--->
	
<cfelse>
	
	<!---Optiene la Cuenta en que se realizo el pago del Banco correspondiente--->
	<cfquery name="rsEmpresaCuenta" datasource="#session.DSN#">
		select distinct c.CBcc
		from ERNomina b 
		
		inner join DRNomina a 
		on a.ERNid = b.ERNid
		
		inner join RCalculoNomina e
		on e.RCNid = b.RCNid
		
		inner join CuentasBancos c
		on  e.CBid = c.CBid  
		
		where a.ERNid in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#url.ERNid#">)
		and b.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
	</cfquery>
	
	<!---Validacion de la Cuenta de la empresa--->
	<cfset Errs2 = ''>
	<cfif rsEmpresaCuenta.RecordCount GT 0>	
		<cfif len(trim(rsEmpresaCuenta.CBcc)) NEQ 17>
			<cfset Errs2 =  Errs2 & 'La cuenta bancaria de la empresa #rsEmpresaCuenta.CBcc# debe tener 17 digitos <br>'>
		</cfif>
		<cfif LSIsNumeric(rsEmpresaCuenta.CBcc) EQ false>
			<cfset Errs2 =  Errs2 & 'La cuenta bancaria de la empresa #rsEmpresaCuenta.CBcc# posee digitos NO numerales. <br>'>
		</cfif>
		<cfif Errs2 NEQ ''>
			<cfset Errs =  Errs & Errs2 & 'Ingrese a Par&aacute;metros RH, Cat&aacute;logo de Bancos, Cuentas Bancarias y modifique los inconvenientes en el campo Cuenta Cliente. <br><br><br>'>		
		</cfif>
    <cfelse>
			<cfset Errs =  Errs & 'No se ha definido una Cuenta de Bancos. <br>'>
			<cfset Errs =  Errs & 'Ingrese a Par&aacute;metros RH, Cat&aacute;logo de Bancos, Cuentas Bancarias e indique la Cuenta Cliente.<br><br><br>'>					
	</cfif>
	<cfset ofiEmpresa = ''>
	<cfset cuentaEmpresa = '#rsEmpresaCuenta.CBcc#'>
	
	<!---Validacion de la Cuentas Empleados--->
	<cfquery name="InsertDatos" datasource="#session.DSN#">
		select c.DEcuenta, c.DEid, coalesce(c.DEdato5,c.DEidentificacion) as DEidentificacion, #_Cat# c.DEnombre  #_Cat# ' ' #_Cat# c.DEapellido1  #_Cat# ' ' #_Cat# DEapellido2 as empleado
		from  ERNomina b
			  inner join  DRNomina a
				on a.ERNid = b.ERNid
			  inner join  DatosEmpleado c
				on c.DEid = a.DEid
		where 
			a.ERNid in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#url.ERNid#">)
			and c.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
	</cfquery>
	<cfset Errs3 = ''>
	<cfloop query="InsertDatos">
		<cfif len(trim(InsertDatos.DEcuenta)) NEQ 12>
			<cfset Errs3 =  Errs3 & 'La cuenta #InsertDatos.DEcuenta#  del empleado #InsertDatos.DEidentificacion# - #InsertDatos.empleado# no cumple con la cantidad de digitos permitidos. <br>'>
		</cfif>
		<cfif mid(InsertDatos.DEcuenta,4,1) NEQ '-'>
			<cfset Errs3 =  Errs3 & 'La cuenta #InsertDatos.DEcuenta#  del empleado #InsertDatos.DEidentificacion# - #InsertDatos.empleado#  debe poseer como separador un guion en la cuenta.<br>'>
		</cfif>
		<cfif LSIsNumeric(mid(InsertDatos.DEcuenta,1,3)) EQ false>
			<cfset Errs3 =  Errs3 & 'La cuenta #InsertDatos.DEcuenta#  del empleado #InsertDatos.DEidentificacion# - #InsertDatos.empleado#  posee digitos NO numerales. <br>'>
		</cfif>
		<cfif LSIsNumeric(mid(InsertDatos.DEcuenta,5,8)) EQ false>
			<cfset Errs3 =  Errs3 & 'La cuenta #InsertDatos.DEcuenta#  del empleado #InsertDatos.DEidentificacion# - #InsertDatos.empleado#  posee digitos NO numerales. <br>'>
		</cfif>
		<cfif Errs3 NEQ ''>
			<cfset Errs3 = Errs3 & "<br>">
		</cfif>	
	</cfloop>
	<cfif Errs3 NEQ ''>
		<cfset Errs3 =  Errs3 & 'Corriga los inconvenientes en el Cat&aacute;logo de Empleados, Cuenta de ahorros del Empleado <br><br>'>
		<cfset Errs = Errs & Errs3>
	</cfif>
	
		<cfif len(trim(Errs))>
		<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&ErrMsg=Errores Encontrados<br>&ErrDet=#URLEncodedFormat(Errs)#" addtoken="no">
		<cfabort>
	</cfif>

	<!---Fin de Validacion de las cuentas--->
	
	<!---Suma salarios--->
	<cfquery name="rsSalarios" datasource="#session.DSN#">
		select 
		coalesce(<cf_dbfunction name="to_number" args="(SUM(y.DRNliquido)/#TipoCambio.TipoCambio#) * 100">,0)as monto,
		x.ERNdescripcion as HERNdescripcion
					from  ERNomina x
						  inner join  DRNomina y
							on y.ERNid = x.ERNid
						  inner join  DatosEmpleado w
							on w.DEid = y.DEid
		where 
			x.ERNid in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#url.ERNid#">)
			and w.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
		Group by x.ERNdescripcion
	</cfquery>
	
	<!---Insercion Datos Empresa--->
	<cfquery name="InsertDatos" datasource="#session.DSN#">
		insert into #reporte# (Consecutivo,Concepto,Oficina,Cuenta,Moneda,Cedula,Nombre,Monto,TipoCedula)
		values( 
			'0',																					<!---consecutivo, se actualiza adelante--->
			'2',																					<!---??????--->
			'#ofiEmpresa#',																			<!---Primeros tres digitos de la cuenta--->
			'#cuentaEmpresa#',																		<!---Cuenta Bancaria para DepÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â³sito, ultimos 7 digitos --->
			'2',																					<!---Dolares para todos los casos--->
			'#rsEmpresaDatos.Eidentificacion#',														<!---Identificacion de la empresa--->								
			'Nominas varias',																		<!---Nombre de la nomina--->
			#rsSalarios.monto#,																		<!---Suma de los salarios de los empleados--->
			'1')																					<!---2=Empleado, 1=Empresa--->
	</cfquery>	
	<!---Insercion Datos de Empleados--->
	<cfquery name="InsertDatos" datasource="#session.DSN#">
		insert into #reporte# (Consecutivo,Concepto,Oficina,Cuenta,Moneda,Cedula,Nombre,Monto,TipoCedula)
		select 
			'0' as Consecutivo,																				<!---consecutivo, se actualiza adelante--->
			'2' as Concepto,																				<!---??????--->
			<cf_dbfunction name="sPart"		args="c.DEcuenta,1,3"> as Oficina,								<!---??????--->
			<cf_dbfunction name="sPart"		args="c.DEcuenta,5,8"> as cuenta,								<!---Cuenta Bancaria Asociada al Banco--->
			'2' as Moneda,																					<!---Dolares para todos los casos--->
			<cf_dbfunction name="sReplace"     args="coalesce(c.DEdato5,c.DEidentificacion)|'-'|''"  delimiters="|"> as Cedula,	<!---Identificacion del Empleado--->
			left(c.DEnombre #_Cat#' '#_Cat# c.DEapellido1 #_Cat#' '#_Cat#  c.DEapellido2,50)  as nombre,									<!---Nombre completo del Empleado--->
			coalesce(<cf_dbfunction name="to_number" args="(a.DRNliquido/#TipoCambio.TipoCambio#) * 100">,0) as Monto,			<!---Monto salario liquido--->
			'2' as TipoCedula																									<!---2=Empleado, 21Empresa--->
		from  ERNomina b
			  inner join  DRNomina a
				on a.ERNid = b.ERNid
			  inner join  DatosEmpleado c
				on c.DEid = a.DEid
		where 
			a.ERNid in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#url.ERNid#">)
			and c.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#">
	</cfquery>
</cfif>

<cfset dd = iif(len(trim(datepart('d',now()))) EQ 1, '0'& datepart('d',now()), datepart('d',now()) )>
<cfset mm = iif(len(trim(datepart('m',now()))) EQ 1, '0'& datepart('m',now()), datepart('m',now()) )>
<cfset yyyy = '#datepart('yyyy',now())#'>

<!---genera el consecutivo--->
<cfquery name="rsConsecutivo" datasource="#session.DSN#">
	select * from #reporte# 
</cfquery>
<cfset cont = 1>
<cfloop query="rsConsecutivo">
	<cfquery datasource="#session.DSN#">
		update #reporte# 
		set  Consecutivo = '#cont#'
		where Cedula ='#rsConsecutivo.Cedula#'
	</cfquery>
	<cfset cont = cont+1>
</cfloop>

<!---Modifica los valores para que contengan la cantidad de caracteres que el cliente especifica para cada dato--->
	<cf_dbfunction name="to_char" args="Concepto" returnvariable="LvarConcepto">
	<cf_dbfunction name="string_part" args="rtrim(#LvarConcepto#)|1|3" 	returnvariable="LvarConceptoStr"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarConceptoStr#"  		returnvariable="LvarConceptoStrL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="'0'|3-coalesce(#LvarConceptoStrL#,0)" 	returnvariable="ConceptoFinal" delimiters="|">

	<cf_dbfunction name="to_char" args="Oficina" returnvariable="LvarOficina">
	<cf_dbfunction name="string_part" args="rtrim(#LvarOficina#)|1|3" 	returnvariable="LvarOficinaStr"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarOficinaStr#"  		returnvariable="LvarOficinaStrL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="'0'|3-coalesce(#LvarOficinaStrL#,0)" 	returnvariable="OficinaFinal" delimiters="|">
				
	
	<cf_dbfunction name="to_char" args="Cuenta" returnvariable="LvarCuenta">
	<cf_dbfunction name="sReplace"     args="coalesce(#LvarCuenta#,'')|'-'|''" 	returnvariable="LvarCuenta" delimiters="|">
		<cf_dbfunction name="string_part" args="rtrim(#LvarCuenta#)|1|17" 	returnvariable="LvarCuentaStr"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarCuentaStr#"  		returnvariable="LvarCuentaStrL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="'0'|17-coalesce(#LvarCuentaStrL#,0)" 	returnvariable="CuentaFinal" delimiters="|">
				
	<cf_dbfunction name="to_char" args="Cuenta" returnvariable="LvarCuentaE">
	<cf_dbfunction name="sReplace"     args="coalesce(#LvarCuentaE#,'')|'-'|''" 	returnvariable="LvarCuentaE" delimiters="|">
		<cf_dbfunction name="string_part" args="rtrim(#LvarCuentaE#)|1|8" 	returnvariable="LvarCuentaEStr"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarCuentaEStr#"  		returnvariable="LvarCuentaEStrL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="'0'|8-coalesce(#LvarCuentaEStrL#,0)" 	returnvariable="CuentaFinalE" delimiters="|">
				
	
	<cf_dbfunction name="to_char" args="Moneda" returnvariable="LvarMoneda">
	<cf_dbfunction name="string_part" args="rtrim(#LvarMoneda#)|1|2" 	returnvariable="LvarMonedaStr"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarMonedaStr#"  		returnvariable="LvarMonedaStrL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="'0'|2-coalesce(#LvarMonedaStrL#,0)" 	returnvariable="MonedaFinal" delimiters="|">
	
	<cf_dbfunction name="to_char" args="Consecutivo" returnvariable="LvarConsecutivo">
	<cf_dbfunction name="string_part" args="rtrim(#LvarConsecutivo#)|1|8" 	returnvariable="LvarConsecutivoStr"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarConsecutivoStr#"  		returnvariable="LvarConsecutivoStrL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="'0'|8-coalesce(#LvarConsecutivoStrL#,0)" 	returnvariable="ConsecutivoFinal" delimiters="|">
	
	
	<cf_dbfunction name="to_char" args="Monto" returnvariable="LvarMonto">
	<cf_dbfunction name="string_part" args="rtrim(#LvarMonto#)|1|12" 	returnvariable="LvarMontoStr"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarMontoStr#"  		returnvariable="LvarMontoStrL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="'0'|12-coalesce(#LvarMontoStrL#,0)" 	returnvariable="MontoFinal" delimiters="|">
	
	<cf_dbfunction name="to_char" args="Cedula" returnvariable="LvarCedula">
	<cf_dbfunction name="string_part" args="rtrim(#LvarCedula#)|1|20" 	returnvariable="LvarCedulaStr"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarCedulaStr#"  		returnvariable="LvarCedulaStrL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="' '|20-coalesce(#LvarCedulaStrL#,0)" 	returnvariable="CedulaFinal" delimiters="|">
				
	
	<cf_dbfunction name="to_char" args="Nombre" returnvariable="LvarNombre">
	<cf_dbfunction name="string_part" args="rtrim(ltrim(#LvarNombre#))|1|35" 	returnvariable="LvarNombreStr"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarNombreStr#"  		returnvariable="LvarNombreStrL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="' '|35-coalesce(#LvarNombreStrL#,0)" 	returnvariable="NombreFinal" delimiters="|">
	
	
	<cf_dbfunction name="to_char" args="Cedula" returnvariable="LvarEmpresa">
	<cf_dbfunction name="sReplace"     args="coalesce(#LvarEmpresa#,'')|'-'|''" 	returnvariable="LvarEmpresa" delimiters="|">
	<cf_dbfunction name="string_part" args="rtrim(#LvarEmpresa#)|1|12" 	returnvariable="LvarEmpresaStr"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarEmpresaStr#"  		returnvariable="LvarEmpresaStrL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="'0'|12-coalesce(#LvarEmpresaStrL#,0)" 	returnvariable="EmpresaFinal" delimiters="|">
	
	
	<cf_dbfunction name="to_char" args="Consecutivo" returnvariable="LvarConsecutivoEmpresa">
	<cf_dbfunction name="string_part" args="rtrim(#LvarConsecutivoEmpresa#)|1|3" 	returnvariable="LvarConsecutivoEmpresaStr"  delimiters="|">
		<cf_dbfunction name="length"      args="#LvarConsecutivoEmpresaStr#"  		returnvariable="LvarConsecutivoEmpresaStrL" delimiters="|" >
				<cf_dbfunction name="sRepeat"     args="'0'|3-coalesce(#LvarConsecutivoEmpresaStrL#,0)" 	returnvariable="ConsecutivoEmpresaFinal" delimiters="|">
	
	<cfset ceros30 = RepeatString('0', 30)>
	<cfset blancos6 = RepeatString(' ', 6)>
	<cfset blancos128 = RepeatString(' ', 128)>
	<cfset blancos80 = RepeatString(' ', 80)>

<!---Concatena los datos en una sola hilera--->
<cfquery name="ERR" datasource="#session.DSN#">
		insert into #salida#(datos, consecutivo)
		select  
		'000' #_Cat#
		#preservesinglequotes(EmpresaFinal)# #_CAT# #preservesinglequotes(LvarEmpresaStr)#  #_Cat#
		#preservesinglequotes(ConsecutivoEmpresaFinal)# #_CAT# #preservesinglequotes(LvarConsecutivoEmpresaStr)# #_Cat#
		'#dd#' #_Cat#
		'#mm#' #_Cat#
		'#yyyy#' #_Cat#
		'#ceros30#' #_Cat#
		'#blancos6#' #_Cat#
		'TLB' #_Cat#
		'#blancos128#' #_Cat#
		'D' as Datos , 1 as orden
		from  #reporte# 
		where  TipoCedula ='1'
</cfquery>	

<cfquery name="ERR" datasource="#session.DSN#">
	insert into #salida#(datos, consecutivo)
	select 
		'000' #_Cat#
		#preservesinglequotes(CuentaFinal)# #_CAT# #preservesinglequotes(LvarCuentaStr)# #_Cat#
		#preservesinglequotes(MonedaFinal)# #_CAT# #preservesinglequotes(LvarMonedaStr)# #_Cat#
		'4' #_Cat#
		'0000' #_Cat#
		#preservesinglequotes(ConsecutivoFinal)# #_CAT# #preservesinglequotes(LvarConsecutivoStr)#  #_Cat#
		#preservesinglequotes(MontoFinal)# #_CAT# #preservesinglequotes(LvarMontoStr)#   #_Cat#
		'#dd#' #_Cat#
		'#mm#' #_Cat#
		'#yyyy#' #_Cat#
		'000'   #_Cat#
		TipoCedula  #_Cat# 
		#preservesinglequotes(LvarCedulaStr)#  #_Cat# #preservesinglequotes(CedulaFinal)# #_CAT#
		#preservesinglequotes(LvarNombreStr)#  #_CAT# #preservesinglequotes(NombreFinal)# #_CAT# '#blancos80#' as Datos								 , 2 as orden 
		from  #reporte#  		
		where  TipoCedula ='1'
</cfquery>

<cfquery name="ERR" datasource="#session.DSN#">
	insert into #salida#(datos, consecutivo)
	select  
		'000' #_Cat#
		'152' #_Cat#
		'0' #_Cat#
		Concepto #_Cat#
		#preservesinglequotes(OficinaFinal)# #_CAT# #preservesinglequotes(LvarOficinaStr)# #_Cat#
		#preservesinglequotes(CuentaFinalE)# #_CAT# #preservesinglequotes(LvarCuentaEStr)# #_Cat#
		'1' #_Cat#
		#preservesinglequotes(MonedaFinal)# #_CAT# #preservesinglequotes(LvarMonedaStr)# #_Cat#
		'2' #_Cat#
		'0000' #_Cat#
		#preservesinglequotes(ConsecutivoFinal)# #_CAT# #preservesinglequotes(LvarConsecutivoStr)#  #_Cat#
		#preservesinglequotes(MontoFinal)# #_CAT# #preservesinglequotes(LvarMontoStr)#   #_Cat#
		'#dd#' #_Cat#
		'#mm#' #_Cat#
		'#yyyy#' #_Cat#
		'000'   #_Cat#
		TipoCedula  #_Cat#
		#preservesinglequotes(LvarCedulaStr)#  #_Cat# #preservesinglequotes(CedulaFinal)# #_CAT#
		#preservesinglequotes(LvarNombreStr)#  #_CAT# #preservesinglequotes(NombreFinal)# #_CAT# '#blancos80#' as Datos , 3 as orden
		from  #reporte# 
		where  TipoCedula ='2'
</cfquery>

<cfquery name="ERR" datasource="#session.DSN#">
	Select datos 
	from #salida#
	order by consecutivo
</cfquery>


