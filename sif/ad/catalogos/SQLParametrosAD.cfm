<cftransaction>
	<cfif isDefined("Form.Aceptar")>
		<cfif isdefined("Form.Mcodigo") and Len(trim(Form.Mcodigo)) GT 0>
			<cfquery name="ParametrosCG" datasource="#Session.DSN#">
			update Empresas set Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">
			where Ecodigo = #session.Ecodigo#
			</cfquery>
		</cfif>


		<cfif isDefined("Form.hayFormatoCuentasContables") and Len(Trim(hayFormatoCuentasContables)) GT 0>
			<cfif Form.hayFormatoCuentasContables EQ "1">
				<cfset a = updateDato(10,Form.mascara)>
			<cfelseif Form.hayFormatoCuentasContables EQ "0">
				<cfset b = insertDato(10,'CO','Formato de Cuentas Contables',Form.mascara)>
			</cfif>
		</cfif>

		<cfif isDefined("Form.hayInterfazConta") and Len(Trim(hayInterfazConta)) GT 0>
			<cfset a = insertDato(20,'GN','Interfaz con Contabilidad',Form.InterfazConta)>
		</cfif>
		
		<cfif isDefined("Form.hayPeriodo") and Len(Trim(hayPeriodo)) GT 0>
			<cfif Form.hayPeriodo EQ "1">
				<cfset a = updateDato(30,Form.periodo)>
			<cfelseif Form.hayPeriodo EQ "0">
				<cfset b = insertDato(30,'CG','Periodo Contable',Form.periodo)>
			</cfif>
		</cfif>

		<cfif isDefined("Form.hayMes") and Len(Trim(hayMes)) GT 0>
			<cfif Form.hayMes EQ "1">
				<cfset a = updateDato(40,Form.mes)>
			<cfelseif Form.hayMes EQ "0">
				<cfset b = insertDato(40,'CG','Mes Contable',Form.mes)>
			</cfif>
		</cfif>

		<cfif isDefined("Form.hayPeriodoAux") and Len(Trim(hayPeriodoAux)) GT 0>
			<cfif Form.hayPeriodoAux EQ "1">
				<cfset a = updateDato(50,Form.periodoAux)>
			<cfelseif Form.hayPeriodoAux EQ "0">
				<cfset b = insertDato(50,'GN','Periodo Auxiliares',Form.periodoAux)>
			</cfif>
		</cfif>

		<cfif isDefined("Form.hayMesAux") and Len(Trim(hayMesAux)) GT 0>
			<cfif Form.hayMesAux EQ "1">
				<cfset a = updateDato(60,Form.mesAux)>
			<cfelseif Form.hayMesAux EQ "0">
				<cfset b = insertDato(60,'GN','Mes Auxiliares',Form.mesAux)>
			</cfif>
		</cfif>

		<cfif isDefined("Form.hayMesFiscal") and Len(Trim(hayMesFiscal)) GT 0>
			<cfif Form.hayMesFiscal EQ "1">
				<cfset a = updateDato(45,Form.mesFiscal)>
			<cfelseif Form.hayMesFiscal EQ "0">
				<cfset b = insertDato(45,'CG','Primer Mes Fiscal Contable',Form.mesFiscal)>
			</cfif>
		</cfif>

		<cfif isDefined("Form.hayUsaConlis") and Len(Trim(hayUsaConlis)) GT 0>
			<cfset a = insertDato(280,'CG','¿Usa Conlis?',Form.UsaConlis)>
		</cfif>

		<cfif isDefined("Form.hayFormatoPlacas") and Len(Trim(hayFormatoPlacas)) GT 0>
			<cfif Form.hayFormatoPlacas EQ "1">
				<cfset a = updateDato(250,Form.mascaraPlacas)>
			<cfelseif Form.hayFormatoPlacas EQ "0">
				<cfset b = insertDato(250,'AF','Formato de Máscara de Placas',Form.mascaraPlacas)>
			</cfif>
		</cfif>

		<cfif isDefined("Form.hayParametrosDefinidos") and Len(Trim(hayParametrosDefinidos)) GT 0>
			<cfif Form.hayParametrosDefinidos EQ "1">
				<cfset a = updateDato(5,Form.ParametrosDefinidos)>
			<cfelseif Form.hayParametrosDefinidos EQ "0">
				<cfset b = insertDato(5,'GN','Parametrización del Sistema ya definida',Form.ParametrosDefinidos)>
			</cfif>
		</cfif>
		<cfquery name="minESNid" datasource="#session.dsn#">
			select min(ESNid) as ESNid
			from EstadoSNegocios
			where Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfif Len(minESNid.ESNid) EQ 0>
			<cfquery name="rsEstadoSN" datasource="#session.DSN#">
				insert into EstadoSNegocios (Ecodigo,ESNcodigo,ESNdescripcion,ESNfacturacion,BMUsucodigo)
				values(#session.Ecodigo#,
						'1',
						'Activo',
						1,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="rsEstadoSN">
			<cfset EstadoID = rsEstadoSN.identity>
		<cfelse>
			<cfset EstadoID = minESNid.ESNid>
		</cfif>
	</cfif>
	
	<cfif isDefined("Form.hayPlanCuentas") and Len(Trim(form.hayPlanCuentas)) GT 0>
		<cfif Form.hayPlanCuentas NEQ '-1'>
			<cfset a = updateDato(1,fnChk("form.chkPlanCuentas"))>
		<cfelse>
			<cfset b = insertDato(1,'CG','Usa Plan de Cuentas',fnChk("form.chkPlanCuentas"))>
		</cfif>
	</cfif>
	
    <!---►►Parametro 2: No Construcción de Cuentas por Complemento Financiero del Origen Contable◄◄--->
	<cfif isdefined("form.chkCtaOrigenCotable")>
		<cfset LvarFormaConstruir = "N">
	<cfelse>
		<cfset LvarFormaConstruir = "S">
	</cfif>
    <cfset insertDato(2,'CG','Forma de Construcción de Cuentas S=Normal, N=Por Origen Contable',LvarFormaConstruir)>
    
    <!---►►Parametro 890: Construcción de Cuentas para Conceptos de Servicio◄◄--->
    <cfparam name="form.ConsCuentConSer" default="" >
	<cfset insertDato(890,'CM','Forma de Construccion de Cuentas para Servicio',form.ConsCuentConSer)>
    <!---►►Parametro 892: Construcción de Cuentas para Conceptos de Consumo de Inventario◄◄--->
    <cfparam name="form.ConsCuentConInv" default="" >
	<cfset insertDato(892,'CM','Forma de Construccion de Cuentas Consumo de Inventario',form.ConsCuentConInv)>
    
    <!---►►Parametro 5200: Indicar Cuentas Manualmente◄◄--->
    <cfset insertDato(5200,'CG','Permitir indicar Cuentas para Servicio',fnChk("form.chkCuentaManual"))>
	
	<!---►►Parametro 5400: Indicar Cuentas Manualmente en CxC◄◄--->
    <cfset insertDato(5400,'CC','Permitir indicar Cuentas para Servicio en CxC',fnChk("form.chkCuentaManualCxC"))>
           
	<cfif isDefined("Form.hayConLetras") and Len(Trim(form.hayConLetras)) GT 0>
		<cfif Form.hayConLetras NEQ '-1'>
			<cfset a = updateDato(12,fnChk("form.chkConLetras"))>
		<cfelse>
			<cfset b = insertDato(12,'CG','Permite Letras en Cuenta Financiera',fnChk("form.chkConLetras"))>
		</cfif>
	</cfif>
	<cfif isDefined("Form.chkActividadEmpresarial") and Len(Trim(form.chkActividadEmpresarial)) GT 0>
		<cfset insertDato(2200,'CG','Activar Transaccionabilidad de Actividad Empresarial','S')>
	<cfelse>
		<cfset insertDato(2200,'CG','Activar Transaccionabilidad de Actividad Empresarial','N')>
	</cfif>

	<!---Formato del Socio de Negocios--->
    <!--- Si no existe el parámetro lo inserta sin validar nada, si ya existe el parámetro entonces valida que no exista otro socio además del Genérico (SNcodigo 9999) --->
	<cfif isDefined("Form.hayFormatoSNegocios") and hayFormatoSNegocios EQ 1>
		<cfquery name="rsSNegocios" datasource="#Session.DSN#">
			select count(1) as cantidadSN 
				from SNegocios 
					where Ecodigo = #session.Ecodigo#
					and SNcodigo <> 9999  
		</cfquery>
        <!--- si no hay socios a parte del genérico lo actualiza --->
		<cfif rsSNegocios.cantidadSN EQ 0>
			<cfset a = updateDato(611,Form.mascaraSNegocios)>
		</cfif>
	<cfelseif isDefined("Form.hayFormatoSNegocios") and Form.hayFormatoSNegocios EQ 0>
        <cfset b = insertDato(611,'CC','Formato de Máscara de Socio de Negocios',Form.mascaraSNegocios)>
    </cfif>
	<cfif isDefined("Form.formularPor")>
        <cfset b = insertDato(2300,'CG','Concepto A Formular',Form.formularPor)>
    </cfif>
	<cfif isDefined("Form.rsOrdenCtsAnti")>
        <cfset insertDato(2500,'CG','Orden de las cuentas para Anticipos(CXP/CXC)',Form.rsOrdenCtsAnti)>
    </cfif>
    <cfif isDefined("Form.chkProvCorp")>
        <cfset insertDato(5100,'CC','Proveeduría Corporativa','S')>
   	<cfelse>
    	<cfset insertDato(5100,'CC','Proveeduría Corporativa','N')>
    </cfif>
</cftransaction>

<form action="ParametrosAD.cfm" method="post" name="sql"></form>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

<!--- Inserta un registro en la tabla de Parámetros --->
<cffunction name="insertDato" >		
	<cfargument name="pcodigo" 		type="numeric" required="true">
	<cfargument name="mcodigo" 		type="string"  required="true">
	<cfargument name="pdescripcion" type="string"  required="true">
	<cfargument name="pvalor" 		type="string"  required="true">			
	
	<cfquery name="rsCheck" datasource="#session.DSN#">
		select count(1) as cantidad
		from Parametros 
		where Ecodigo = #session.Ecodigo#
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#"> 
	</cfquery>
	
	<cfif rsCheck.cantidad eq 0>
		<cfquery datasource="#Session.DSN#">
			insert into Parametros (Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor)
			values (
				#session.Ecodigo#, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.mcodigo)#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pdescripcion)#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pvalor)#"> 
				)
		</cfquery>	
	<cfelse>
		<cfquery datasource="#Session.DSN#">
			update Parametros set 
            	Pvalor 		 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pvalor)#">,
                Pdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.Pdescripcion)#">
			where Ecodigo = #session.Ecodigo#
			  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
		</cfquery>			
	</cfif>
	<cfreturn true>
</cffunction>

<!--- Actualiza los datos del registro según el pcodigo --->
<cffunction name="updateDato" >					
	<cfargument name="pcodigo" type="numeric" required="true">
	<cfargument name="pvalor" type="string" required="true">			
	<cfquery name="updDato" datasource="#Session.DSN#">
		update Parametros set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pvalor)#"> 
		where Ecodigo = #session.Ecodigo# 
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
	</cfquery>
	<cfreturn true>
</cffunction>

<!--- Actualiza los datos del registro según el pcodigo --->
<cffunction name="fnChk" returntype="string">
	<cfargument name="nombre" type="string" required="true">			
	<cfif isdefined(Arguments.nombre)>
		<cfreturn "S">
	<cfelse>
		<cfreturn "N">
	</cfif>
</cffunction>
