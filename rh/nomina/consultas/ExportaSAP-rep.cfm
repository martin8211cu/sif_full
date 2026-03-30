<cfsetting requesttimeout="36000">
<cfif isdefined('url.TipoNomina')>
	<cfset Lvar_Prefijo = 'H'>
<cfelse>
	<cfset Lvar_Prefijo = ''>
</cfif>
	<!--- TABLA TEMPORAL PARA LOS DATOS --->
    <cf_dbtemp name="salidaExportarv2" returnvariable="salida">
    	<cf_dbtempcol name="CPid"   		type="numeric"     	mandatory="yes">
        <cf_dbtempcol name="CPcodigo"  		type="char(12)"    	mandatory="yes">
        <cf_dbtempcol name="Clave"			type="char(4)" 		mandatory="no">
        <cf_dbtempcol name="CFuncional"		type="numeric"		mandatory="no">
        <cf_dbtempcol name="Cuenta"			type="varchar(100)"	mandatory="no">
        <cf_dbtempcol name="DEid"			type="numeric"		mandatory="no">
        <cf_dbtempcol name="Importe"		type="money"		mandatory="no">
        <cf_dbtempcol name="FechaVence"		type="datetime"		mandatory="no">
		<cf_dbtempcol name="Asignacion"		type="varchar(60)"	mandatory="no">
		<cf_dbtempcol name="CodEquiv"		type="char(10)"		mandatory="no">
		<cf_dbtempcol name="TipoM"			type="char(1)"		mandatory="no">
    </cf_dbtemp>
	<cfquery name="rsDatosNomina" datasource="#session.DSN#">
		select CPdesde, CPhasta, CPperiodo, CPmes
		from CalendarioPagos
		where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#">
	</cfquery>
	<cfset meses = "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre">
	<cfset vs_mes = listgetat(meses, rsDatosNomina.CPmes)>
	<cfset Lvar_Asignacion = 'Gasto Nómina ' & vs_mes & ' ' & rsDatosNomina.CPperiodo>
	<cfif ListFind(busca,0)><!--- DEDUCCIONES --->
		<cfquery name="rsDeducciones" datasource="#session.DSN#" blockfactor="100">
			select <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#"> as CPid,
			 	<cfqueryparam cfsqltype="cf_sql_char" value="#url.CPcodigo#"> as CPcodigo,
			 	td.TDClave as Clave,
				 CFid,
				 <cf_dbfunction name="string_part" args="Cformato,6,100"> as Cformato,
				 <cfif isdefined('url.Empleado')>dc.DEid<cfelse>null</cfif> as DEid,
				 montores as montores,
				 <cfqueryparam cfsqltype="cf_sql_date" value="#rsDatosNomina.CPhasta#"> as CPhasta,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_Asignacion#"> as Asignacion,
				 <cfif isdefined('url.CodExterno')>td.TDcodigoext<cfelse>null</cfif> as codigoext,
				 tipo
			from #Lvar_Prefijo#DeduccionesCalculo dc
			inner join DeduccionesEmpleado de
				on de.DEid = dc.DEid
				and de.Did = dc.Did
			inner join TDeduccion td
				on de.TDid = td.TDid
			inner join RCuentasTipo ct
				on ct.RCNid = dc.RCNid
				and ct.referencia = dc.Did
			where dc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#">
				and ct.tiporeg = 60
				<cfif isdefined('url.Clave') and LEN(TRIM(url.Clave))>
				and td.TDclave = '#url.Clave#'
				<cfelse>
				and td.TDclave is not null
				</cfif>
		</cfquery>
 		<cfoutput query="rsDeducciones">
			 <cfquery name="rsDeducciones" datasource="#session.DSN#">
				insert into #salida# (CPid, CPcodigo,Clave,CFuncional,Cuenta,DEid,Importe,FechaVence,Asignacion,CodEquiv,TipoM)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#CPid#">,
					<cfqueryparam cfsqltype="cf_sql_char" 		value="#trim(CPcodigo)#">,
					<cfqueryparam cfsqltype="cf_sql_char" 		value="#trim(Clave)#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#CFid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#trim(Cformato)#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#DEid#" null="#Len(trim(DEid)) EQ 0#">,
					<cfqueryparam cfsqltype="cf_sql_money" 		value="#montores#">,
					<cfqueryparam cfsqltype="cf_sql_date" 		value="#CPhasta#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#trim(Asignacion)#">,
					<cfqueryparam cfsqltype="cf_sql_char" 		value="#codigoext#" null="#Len(trim(codigoext)) EQ 0#">,
					<cfqueryparam cfsqltype="cf_sql_char" 		value="#tipo#">)
			</cfquery>
		</cfoutput>
		<!--- VERIFICAR SI LA DEDUCCIÃ“N RELACIONADA CON LA RENTA TIENE EL CÃ“DIGO SELECCIONADO --->
		<cfquery name="rsRenta" datasource="#session.DSN#">
			Select TDclave
			from TDeduccion
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and TDrenta = 1
			  <cfif isdefined('url.Clave') and LEN(TRIM(url.Clave))>
			  and TDclave = '#url.Clave#'
			  <cfelse>
			  and TDclave is not null
			  </cfif>
		</cfquery>
		<cfif isdefined('rsRenta') and rsRenta.RecordCount EQ 0>
			<cfset Lvar_CRenta = 0>
		<cfelseif isdefined('rsRenta') and rsRenta.RecordCount GT 0>
			<cfset Lvar_CRenta = rsRenta.TDclave>
		</cfif>
		<!--- SI EXISTE UNA DEDUCCION PARA RENTA ENTONCES SE BUSCA EL MONTO DE RENTA EN HSALARIOSEMPLEAO --->
		<cfif Lvar_CRenta GT 0>
			<cfquery name="rsRenta" datasource="#session.DSN#">
				select <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#"> as CPid,
						<cfqueryparam cfsqltype="cf_sql_char" value="#url.CPcodigo#"> as CPcodigo,
						<cfqueryparam cfsqltype="cf_sql_char" value="#Lvar_CRenta#"> as Clave,
						CFid,
						<cf_dbfunction name="string_part" args="Cformato,6,100"> as Cformato,
						null as DEid,
						montores as montores,
						<cfqueryparam cfsqltype="cf_sql_date" value="#rsDatosNomina.CPhasta#"> as CPhasta,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_Asignacion#"> as Asignacion,
						null as codigoext,
						tipo
				from RCuentasTipo
				where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#">
				  and tiporeg = 70
			</cfquery>
			<cfoutput query="rsRenta">
				<cfquery name="rsDeducciones" datasource="#session.DSN#">
					insert into #salida# (CPid, CPcodigo,Clave,CFuncional,Cuenta,DEid,Importe,FechaVence,Asignacion,CodEquiv,TipoM)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#CPid#">,
						<cfqueryparam cfsqltype="cf_sql_char" 		value="#trim(CPcodigo)#">,
						<cfqueryparam cfsqltype="cf_sql_char" 		value="#trim(Clave)#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#CFid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#trim(Cformato)#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#DEid#" null="#Len(trim(DEid)) EQ 0#">,
						<cfqueryparam cfsqltype="cf_sql_money" 		value="#montores#">,
						<cfqueryparam cfsqltype="cf_sql_date" 		value="#CPhasta#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#trim(Asignacion)#">,
						<cfqueryparam cfsqltype="cf_sql_char" 		value="#codigoext#" null="#Len(trim(codigoext)) EQ 0#">,
					<cfqueryparam cfsqltype="cf_sql_char" 		value="#tipo#">)
				</cfquery>
			</cfoutput>
		</cfif>
	</cfif>

	<cfif ListFind(busca,1)><!--- CONCEPTOS DE PAGO --->
		<cfquery name="rsConceptosP" datasource="#session.DSN#" blockfactor="100">
			select <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#"> as CPid,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#url.CPcodigo#"> as CPcodigo,
					ci.CIclave as Clave,
					ct.CFid,
					<cf_dbfunction name="string_part" args="ct.Cformato,6,100"> as Cformato,
					 <cfif isdefined('url.Empleado')>ct.DEid<cfelse>null</cfif> as DEid,
					sum(montores) as montores,
					 <cfqueryparam cfsqltype="cf_sql_date" value="#rsDatosNomina.CPhasta#"> as CPhasta,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_Asignacion#"> as Asignacion,
					 <cfif isdefined('url.CodExterno')>ci.CIcodigoext<cfelse>null</cfif> as codigoext,
					 tipo
			from RCuentasTipo ct
			inner join CIncidentes ci
				  on ci.CIid = ct.referencia
				  and ci.Ecodigo = ct.Ecodigo
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#">
			  and ct.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and tiporeg = 20
			  <cfif isdefined('url.Clave') and LEN(TRIM(url.Clave))>
			  and ci.CIclave = '#url.Clave#'
			  <cfelse>
			  and ci.CIclave is not null
			  </cfif>
			group by ct.CFid, ct.CFormato<cfif isdefined('url.Empleado')>,ct.DEid</cfif><cfif isdefined('url.CodExterno')>,ci.CIcodigoext</cfif>,ci.CIclave, tipo
		</cfquery>
 		<cfoutput query="rsConceptosP">
			 <cfquery name="rsConceptosP" datasource="#session.DSN#">
				insert into #salida# (CPid, CPcodigo,Clave,CFuncional,Cuenta,DEid,Importe,FechaVence,Asignacion,CodEquiv,TipoM)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#CPid#">,
					<cfqueryparam cfsqltype="cf_sql_char" 		value="#trim(CPcodigo)#">,
					<cfqueryparam cfsqltype="cf_sql_char" 		value="#trim(Clave)#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#CFid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#trim(Cformato)#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#DEid#" null="#Len(trim(DEid)) EQ 0#">,
					<cfqueryparam cfsqltype="cf_sql_money" 		value="#montores#">,
					<cfqueryparam cfsqltype="cf_sql_date" 		value="#CPhasta#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#trim(Asignacion)#">,
					<cfqueryparam cfsqltype="cf_sql_char" 		value="#codigoext#" null="#Len(trim(codigoext)) EQ 0#">,
					<cfqueryparam cfsqltype="cf_sql_char" 		value="#tipo#">)
			</cfquery>
		</cfoutput>
	</cfif>
	<cfif ListFind(busca,2)><!--- DETALLE DE CARGAS --->
		<!--- CON EMPLEADO ASOCIADO --->
		<cfquery name="rsDetalleC" datasource="#session.DSN#" blockfactor="100">
			select <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#"> as CPid,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#url.CPcodigo#"> as CPcodigo,
					 b.DCclave as Clave,
					 CFid,
						 <cf_dbfunction name="string_part" args="Cformato,6,100"> as Cformato,
						null as DEid,
						montores,
					 <cfqueryparam cfsqltype="cf_sql_date" value="#rsDatosNomina.CPhasta#"> as CPhasta,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_Asignacion#"> as Asignacion,
					 <cfif isdefined('url.CodExterno')>b.DCcodigoext<cfelse>null</cfif> as codigoext,
					 tipo
			from #Lvar_Prefijo#CargasCalculo a
			inner join DCargas b
				on b.DClinea = a.DClinea
			inner join RCuentasTipo ct
				on ct.RCNid = a.RCNid
				and ct.DEid = a.DEid
				and ct.referencia = a.DClinea
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#">
				and ct.tiporeg in(30,40)
				<cfif isdefined('url.Clave') and LEN(TRIM(url.Clave))>
				and b.DCclave = '#url.Clave#'
				<cfelse>
				and b.DCclave is not null
				</cfif>
		</cfquery>
 		<cfoutput query="rsDetalleC">
			 <cfquery name="rsDetalleC" datasource="#session.DSN#">
				insert into #salida# (CPid, CPcodigo,Clave,CFuncional,Cuenta,DEid,Importe,FechaVence,Asignacion,CodEquiv,TipoM)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#CPid#">,
					<cfqueryparam cfsqltype="cf_sql_char" 		value="#trim(CPcodigo)#">,
					<cfqueryparam cfsqltype="cf_sql_char" 		value="#trim(Clave)#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#CFid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#trim(Cformato)#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#DEid#" null="#Len(trim(DEid)) EQ 0#">,
					<cfqueryparam cfsqltype="cf_sql_money" 		value="#montores#">,
					<cfqueryparam cfsqltype="cf_sql_date" 		value="#CPhasta#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#trim(Asignacion)#">,
					<cfqueryparam cfsqltype="cf_sql_char" 		value="#codigoext#" null="#Len(trim(codigoext)) EQ 0#">,
					<cfqueryparam cfsqltype="cf_sql_char" 		value="#tipo#">)
			</cfquery>
		</cfoutput> 
		<!--- SIN EMPLEADO ASOCIADO --->
		<cfquery name="rsDetalleC1" datasource="#session.DSN#" blockfactor="100">
			select <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#"> as CPid,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#url.CPcodigo#"> as CPcodigo,
					 b.DCclave as Clave,
					 CFid,
						 <cf_dbfunction name="string_part" args="Cformato,6,100"> as Cformato,
						null as DEid,
						montores,
					 <cfqueryparam cfsqltype="cf_sql_date" value="#rsDatosNomina.CPhasta#"> as CPhasta,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_Asignacion#"> as Asignacion,
					 <cfif isdefined('url.CodExterno')>b.DCcodigoext<cfelse>null</cfif> as codigoext,
					 tipo
			from DCargas b
				inner join RCuentasTipo ct
				on ct.referencia = b.DClinea
			where ct.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#">
				and ct.tiporeg = 50
				<cfif isdefined('url.Clave') and LEN(TRIM(url.Clave))>
				and b.DCclave = '#url.Clave#'
				<cfelse>
				and b.DCclave is not null
				</cfif>
		</cfquery>
 		<cfoutput query="rsDetalleC1">
			 <cfquery name="rsDetalleC1" datasource="#session.DSN#">
				insert into #salida# (CPid, CPcodigo,Clave,CFuncional,Cuenta,DEid,Importe,FechaVence,Asignacion,CodEquiv,TipoM)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#CPid#">,
					<cfqueryparam cfsqltype="cf_sql_char" 		value="#trim(CPcodigo)#">,
					<cfqueryparam cfsqltype="cf_sql_char" 		value="#trim(Clave)#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#CFid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#trim(Cformato)#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#DEid#" null="#Len(trim(DEid)) EQ 0#">,
					<cfqueryparam cfsqltype="cf_sql_money" 		value="#montores#">,
					<cfqueryparam cfsqltype="cf_sql_date" 		value="#CPhasta#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#trim(Asignacion)#">,
					<cfqueryparam cfsqltype="cf_sql_char" 		value="#codigoext#" null="#Len(trim(codigoext)) EQ 0#">,
					<cfqueryparam cfsqltype="cf_sql_char" 		value="#tipo#">)
			</cfquery>
		</cfoutput> 
	</cfif>
	<cfif ListFind(busca,3)><!--- INGRESOS (COMPONENTES SALARIALES) --->
		<cfquery name="rsSalarioBase" datasource="#session.DSN#">
			select CSclave
			from ComponentesSalariales
			  where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and CSsalariobase = 1
				<cfif isdefined('url.Clave') and LEN(TRIM(url.Clave))>
				and CSclave = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Clave#">
				<cfelse>
				and CSclave is not null
				</cfif>
		</cfquery>
		<cfif rsSalarioBase.RecordCount>
			<cfquery name="rsIngresos" datasource="#session.DSN#" blockfactor="100">
				select <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#"> as CPid,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#url.CPcodigo#"> as CPcodigo,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#rsSalarioBase.CSclave#"> as Clave,
						 CFid,
						 <cf_dbfunction name="string_part" args="Cformato,6,100"> as Cformato,
						 <cfif isdefined('url.Empleado')>b.DEid<cfelse>null</cfif> as DEid,
						 montores,
						 <cfqueryparam cfsqltype="cf_sql_date" value="#rsDatosNomina.CPhasta#"> as CPhasta,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_Asignacion#"> as Asignacion,
					 tipo
				from RCuentasTipo b
				where b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#">
				and b.tiporeg = 10
<!--- LZ					and montores > 0 no se pueden omitir  Registros --->
			</cfquery>
 		<cfoutput query="rsIngresos">
			 <cfquery name="rsIngresos" datasource="#session.DSN#">
				insert into #salida# (CPid, CPcodigo,Clave,CFuncional,Cuenta,DEid,Importe,FechaVence,Asignacion,TipoM)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#CPid#">,
					<cfqueryparam cfsqltype="cf_sql_char" 		value="#trim(CPcodigo)#">,
					<cfqueryparam cfsqltype="cf_sql_char" 		value="#trim(Clave)#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#CFid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#trim(Cformato)#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#DEid#" null="#Len(trim(DEid)) EQ 0#">,
					<cfqueryparam cfsqltype="cf_sql_money" 		value="#montores#">,
					<cfqueryparam cfsqltype="cf_sql_date" 		value="#CPhasta#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#trim(Asignacion)#">,
					<cfqueryparam cfsqltype="cf_sql_char" 		value="#tipo#">)
			</cfquery>
		</cfoutput>
		</cfif>
	</cfif>
	<!--- SALARIOS--->
	<cfif ListFind(busca,4)>
		<cfquery name="rsSalarios" datasource="#session.DSN#">
			select CBclave
			from CuentasBancos
			  where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
              	and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
				<cfif isdefined('url.Clave') and LEN(TRIM(url.Clave))>
				and CBclave = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Clave#">
				<cfelse>
				and CBclave is not null
				</cfif>
		</cfquery>
		<cfif rsSalarios.RecordCount>
			<cfquery name="rsSalarios" datasource="#session.DSN#" blockfactor="100">
				select <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#"> as CPid,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#url.CPcodigo#"> as CPcodigo,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#rsSalarios.CBclave#"> as Clave,
						 CFid,
						 <cf_dbfunction name="string_part" args="Cformato,6,100"> as Cformato,
						 <cfif isdefined('url.Empleado')>c.DEid<cfelse>null</cfif> as DEid,
						 montores,
						 <cfqueryparam cfsqltype="cf_sql_date" value="#rsDatosNomina.CPhasta#"> as CPhasta,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_Asignacion#"> as Asignacion,
					 	tipo
						 
				from #Lvar_Prefijo#RCalculoNomina a
				inner join CuentasBancos b
				  on b.Ecodigo = a.Ecodigo
				  and b.CBid = a.CBid
				inner join RcuentasTipo c
				  on c.RCNid = a.RCNid 
				  and c.CCuenta = b.CCuenta
				where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#">
                  and b.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
				  and a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and c.Tiporeg in(80,85)
				  <cfif isdefined('url.Clave') and LEN(TRIM(url.Clave))>
				  and CBclave = <cfqueryparam cfsqltype="cf_sql_char" value="#url.Clave#">
				  <cfelse>
				  and CBclave is not null
				  </cfif>
			</cfquery>
			
 		<cfoutput query="rsSalarios">
			 <cfquery name="rsSalarios" datasource="#session.DSN#">
				insert into #salida# (CPid, CPcodigo,Clave,CFuncional,Cuenta,DEid,Importe,FechaVence,Asignacion,TipoM)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#CPid#">,
					<cfqueryparam cfsqltype="cf_sql_char" 		value="#trim(CPcodigo)#">,
					<cfqueryparam cfsqltype="cf_sql_char" 		value="#trim(Clave)#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#CFid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#trim(Cformato)#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#DEid#" null="#Len(trim(DEid)) EQ 0#">,
					<cfqueryparam cfsqltype="cf_sql_money" 		value="#montores#">,
					<cfqueryparam cfsqltype="cf_sql_date" 		value="#CPhasta#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#trim(Asignacion)#">,
					<cfqueryparam cfsqltype="cf_sql_char" 		value="#tipo#">)
			</cfquery>
		</cfoutput>
		</cfif>
	</cfif>
	<cfquery name="rsDatos" datasource="#session.DSN#">
		select CPid, 	
				CPcodigo,
				Clave,
				c.CFcodigo as CFuncional,
				Cuenta,
				a.DEid,
				sum(case when TipoM = 'D' then Importe else Importe *-1 end) as Importe,
				FechaVence,
				Asignacion,
				CodEquiv
			<cfif isdefined('url.Empleado')>
				,case when len(trim(coalesce(DEinfo5,DEidentificacion))) = 0 then 
						DEidentificacion 
				 else 
				 		coalesce(DEinfo5,DEidentificacion) 
				end as Deidentificacion
			</cfif>	
		from #salida# a
		<cfif isdefined('url.Empleado')>
		inner join DatosEmpleado b
			on b.DEid = a.DEid
		</cfif>
		inner join CFuncional c
			on c.CFid = a.CFuncional
		<cfif isdefined('url.Orden') and url.Orden EQ 0>
		group by c.CFcodigo, Cuenta, CPid, CPcodigo,Clave,<cfif isdefined('url.Empleado')> case when len(trim(coalesce(DEinfo5,DEidentificacion))) = 0 then DEidentificacion else coalesce(DEinfo5,DEidentificacion) end,</cfif>a.DEid,FechaVence,Asignacion,CodEquiv
		order by c.CFcodigo, Cuenta, CPid, CPcodigo,Clave,<cfif isdefined('url.Empleado')>DEidentificacion,</cfif>a.DEid,FechaVence,Asignacion,CodEquiv
		<cfelseif isdefined('url.Orden') and url.Orden EQ 1>
		group by  Cuenta, CPid, CPcodigo,Clave,<cfif isdefined('url.Empleado')>case when len(trim(coalesce(DEinfo5,DEidentificacion))) = 0 then DEidentificacion else coalesce(DEinfo5,DEidentificacion) end,</cfif>a.DEid,FechaVence,Asignacion,CodEquiv,c.CFcodigo
		order by  Cuenta, CPid, CPcodigo,Clave,<cfif isdefined('url.Empleado')>DEidentificacion,</cfif>a.DEid,FechaVence,Asignacion,CodEquiv,c.CFcodigo
		<cfelseif isdefined('url.Orden') and url.Orden EQ 2>
		group by  CodEquiv,<cfif isdefined('url.Empleado')>case when len(trim(coalesce(DEinfo5,DEidentificacion))) = 0 then DEidentificacion else coalesce(DEinfo5,DEidentificacion) end,</cfif>	a.DEid,Cuenta, CPid, CPcodigo,Clave,FechaVence,Asignacion,c.CFcodigo
		order by  CodEquiv,<cfif isdefined('url.Empleado')>DEidentificacion,</cfif>	a.DEid,Cuenta, CPid, CPcodigo,Clave,FechaVence,Asignacion,c.CFcodigo
		</cfif>
	</cfquery>
    <style>
	h1.corte {
		PAGE-BREAK-AFTER: always;}
	.tituloAlterno {
		font-size:20px;
		font-weight:bold;
		text-align:center;}
	.titulo_empresa2 {
		font-size:18px;
		font-weight:bold;
		text-align:center;}
	.titulo_reporte {
		font-size:16px;
		font-style:italic;
		text-align:center;}
	.titulo_filtro {
		font-size:14px;
		font-style:italic;
		text-align:center;}
	.titulolistas {
		font-size:14px;
		font-weight:bold;
		background-color:#CCCCCC;
		}
	.titulo_columnar {
		font-size:14px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:right;}
	.listaCorte {
		font-size:10px;
		font-weight:bold;
		background-color: #F4F4F4;
		text-align:left;}
	.listaCorte3 {
		font-size:10px;
		font-weight:bold;
		background-color:  #E8E8E8;
		text-align:left;}
	.listaCorte2 {
		font-size:10px;
		font-weight:bold;
		background-color: #D8D8D8;
		text-align:left;}
	.listaCorte1 {
		font-size:12px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:left;}
	.total {
		font-size:14px;
		font-weight:bold;
		text-align:right;}

	.detalle {
		font-size:11px;
		text-align:left;}
	.detaller {
		font-size:11px;
		text-align:right;}
	.detallec {
		font-size:11px;
		text-align:center;}	
	.mensaje {
		font-size:14px;
		text-align:center;}
	.paginacion {
		font-size:14px;
		text-align:center;}
	</style>
	<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr class="listaCorte1">
			<td><cf_translate key="LB_NumeroDePlantilla">N&uacute;mero de plantilla</cf_translate></td>
			<td><cf_translate key="LB_Clave">Clave</cf_translate></td>
			<cfif isdefined('url.Orden') and url.Orden EQ 0>
			<td><cf_translate key="LB_CentroFuncional">Centro Funcional</cf_translate></td>
			</cfif>
			<td><cf_translate key="LB_Cuenta">Cuenta</cf_translate></td>
			<cfif isdefined('url.Empleado')>
			<td><cf_translate key="LB_NumeroDeEmpleado">N&uacute;mero de Empleado</cf_translate></td>
			</cfif>
			<td><cf_translate key="LB_Importe">Importe</cf_translate></td>
			<td align="center"><cf_translate key="LB_FechaDeVencimiento">Fecha de Vencimiento</cf_translate></td>
			<td><cf_translate key="LB_AsignaciÃ³n">Asignaci&oacute;n</cf_translate></td>
			<cfif isdefined('url.CodExterno')>
			<td><cf_translate key="LB_CodigoDeEquivalencia">C&oacute;digo de Equivalencia</cf_translate></td>
			</cfif>
		</tr>
		<cfoutput query="rsDatos">
		<tr class="detalle">
			<td>#CPcodigo#</td>
			<td>#Clave#</td>
			<cfif isdefined('url.Orden') and url.Orden EQ 0>
			<td>#CFuncional#</td>
			</cfif>
			<td>#Cuenta#</td>
			<cfif isdefined('url.Empleado')>
			<td>#DEidentificacion#</td>
			</cfif>
			<td class="detaller">#LSCurrencyFormat(Importe,'none')#</td>
			<td class="detallec">#LSDateFormat(FechaVence,'dd/mm/yyyy')#</td>
			<td>#Asignacion#</td>
			<cfif isdefined('url.CodExterno')>
			<td>&nbsp;#CodEquiv#</td>
			</cfif>
		</tr>
		</cfoutput>
	</table>