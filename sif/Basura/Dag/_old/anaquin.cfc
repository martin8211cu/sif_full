<cfcomponent>
	<cffunction name="doit" access="public" returntype="boolean">
		<cfargument name="caja" type="string" required="true" hint="Código de caja.">
		<cfargument name="fecha" type="date" required="false" default="#Now()#" hint="Fecha proceso.">
		<cfargument name="Periodo" type="numeric" default="0" required="no"><!---Si se envían No se sacan de la tabla de parámetros--->
		<cfargument name="Mes" type="numeric" default="0" required="no"><!---Si se envían No se sacan de la tabla de parámetros--->
		<cfargument name="debug" type="boolean" required="false" default="false" hint="Mostrar comentarios y devolver los cambios al final.">
		<cfset var showStruts=false>
		<cfset var showPseudo=true>
		<cfset var done=false>
		<!--- Preprocesamiento de Argumentos --->
		<!--- Quita hh:mm:ss a la Fecha --->
		<cfset Lvar_fecha = CreateDate(Year(Arguments.fecha),Month(Arguments.fecha),Day(Arguments.fecha))>
		<cfset Lvar_fechastr = "#RepeatString('0',2-Len(Day(Arguments.fecha)))##Day(Arguments.fecha)##RepeatString('0',2-Len(Month(Arguments.fecha)))##Month(Arguments.fecha)##Year(Arguments.fecha)#">
		<!--- Obtiene el Periodo y Mes de Auxiliares --->
		<cfif Arguments.Periodo neq 0>
			<cfset Lvar_Periodo = Arguments.Periodo>
		<cfelse>
			<cfquery name="rsPeriodo" datasource="#session.dsn#">
				select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as value
				from Parametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and Pcodigo = 50
					and Mcodigo = 'GN'
			</cfquery>
			<cfif rsPeriodo.recordcount>
				<cfset Lvar_Periodo = rsPeriodo.value>
			</cfif>
		</cfif>
		<cfif Arguments.Mes neq 0>
			<cfset Lvar_Mes = Arguments.Mes>
		<cfelse>
			<cfquery name="rsMes" datasource="#session.dsn#">
				select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as value
				from Parametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and Pcodigo = 60
					and Mcodigo = 'GN'
			</cfquery>
			<cfif rsMes.recordcount>
				<cfset Lvar_Mes = rsMes.value>
			</cfif>
		</cfif>
		<!--- Obtiene la Moneda Local --->
		<cfquery name="rsMoneda" datasource="#session.dsn#">
			select Mcodigo as value
			from Empresas 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		<cfif rsMes.recordcount>
			<cfset Lvar_Monloc = rsMoneda.value>
		</cfif>
		<!--- Crea la FechaAux a partir del periodo / mes de auxiliares y le pone el último día del mes --->
		<cfset Lvar_fechaaux = CreateDate(fnIsNull(Lvar_Periodo,01), fnIsNull(Lvar_Mes,01), 01)>
		<cfset Lvar_fechaaux = DateAdd("m",1,Lvar_fechaaux)>
		<cfset Lvar_fechaaux = DateAdd("d",-1,Lvar_fechaaux)>
		<cfif debug>
			<!--- Pinta los valores obtenidos hasta el momento para debug --->
			<cfoutput>
				<h1>DEBUG</h1><br>
				<p>
				<strong>Periodo</strong> = #Lvar_Periodo#<br>
				<strong>Mes</strong> = #Lvar_Mes#<br>
				<strong>Moneda</strong> = #Lvar_Monloc#<br>
				<strong>Fecha de Auxiliares</strong> = #Lvar_fechaaux#<br>
				<strong>Fecha de Proceso</strong> = #Lvar_fecha#<br>
				<strong>Fecha String para INTARC</strong> = #Lvar_fechastr#<br>
				<strong>Fecha del Sistema</strong> = #Now()#<br>
				</p>
			</cfoutput>
		</cfif>
		<!--- Validaciones Iniciales, valida periodo, mes, moneda --->
		<cfif len(trim(Lvar_Periodo)) eq 0><cfthrow message="Error, No se ha definido el parámetro Periodo para los Sistemas Auxiliares! Proceso Cancelado!"></cfif>
		<cfif len(trim(Lvar_Mes)) eq 0><cfthrow message="Error, No se ha definido el parámetro Mes para los Sistemas Auxiliares! Proceso Cancelado!"></cfif>
		<cfif len(trim(Lvar_Monloc)) eq 0><cfthrow message="Error, No se ha definido el parámetro Moneda Local para la Empresa! Proceso Cancelado!"></cfif>
		<cfif debug>
			<style type="text/css">
				<!--
				.style1 {font-size:smaller}
				-->
			</style>
			<fieldset style="background-color:#CCCCCC; border: 1px solid #AAAAAA; height: 15;">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
				  <tr>
					<td class="style1">&nbsp;<strong>INICIO EJECUCIÓN MÉTODO FA_CIERREDIARIO</strong></td>
				  </tr>
				</table>
			</fieldset>
			<fieldset style="background-color:#F3F4F8; border-top: none; border-left: 1px solid #CCCCCC; border-right: 1px solid #CCCCCC; border-bottom: 1px solid #CCCCCC; ">
			<cfif showStruts>
				<cfdump var="#arguments#" label="arguments">
			</cfif>
		</cfif>
		<!--- *************************************************** VALIDACIONES PREVIAS ************************************************ --->
		<cfif debug>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
			  <tr>
				<td class="style1">&nbsp;<strong>VALIDACIONES PREVIAS</strong></td>
			  </tr>
			</table>
		</cfif>
		<!--- Valida que la caja existe --->
		<cfquery name="rsSelectFAM001" datasource="#session.dsn#">
			select Ecodigo, Ocodigo, FAM01COD, FAM01CODD, 
				FAM09MAQ, FAM01DES, FAM01RES, FAM01TIP, 
				FAM01COB, FAM01STS, FAM01STP, Ccuenta, 
				I02MOD, CCTcodigoAP, CCTcodigoDE, CCTcodigoFC, 
				CCTcodigoCR, CCTcodigoRC, FAM01NPR, FAM01NPA, 
				Aid, Mcodigo, FAM01TIF, FAPDES, 
				FAM01CTP, FAM32CON, FAM01AUT, BMUsucodigo, 
				fechaalta, ts_rversion, CtaSobrantes, CtaFaltantes
			from FAM001
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Caja#">
		</cfquery>
		<cfif rsSelectFAM001.recordcount>
			<cfif rsSelectFAM001.FAM01STS eq 0 or not ListContains('0,40,50',rsSelectFAM001.FAM01STP)>
				<cfthrow message="FA_CIERREDIARIO.FA_CIERREDIARIO.VALIDACIONES_PREVIAS. La caja se encuentra pendiente de cierre. Proceso Cancelado!"/>
			<cfelseif rsSelectFAM001.FAM01TIP EQ 6 OR rsSelectFAM001.FAM01TIP EQ 8>
				<cfthrow message="FA_CIERREDIARIO.FA_CIERREDIARIO.VALIDACIONES_PREVIAS. La caja es cotizadora, no se puede efectuar cierre a cajas cotizadoras. Proceso Cancelado!"/>
			<cfelseif len(rsSelectFAM001.Ocodigo) eq 0>
				<cfthrow message="FA_CIERREDIARIO.FA_CIERREDIARIO.VALIDACIONES_PREVIAS. La caja no tiene Oficina, no se puede efectuar cierre a cajas sin oficina. Proceso Cancelado!"/>
			<cfelseif len(rsSelectFAM001.CtaSobrantes) eq 0>
				<cfthrow message="FA_CIERREDIARIO.FA_CIERREDIARIO.VALIDACIONES_PREVIAS. La caja no tiene cuenta de Sobrantes, no se puede efectuar cierre a cajas sin cuenta de Sobrantes. Proceso Cancelado!"/>
			<cfelseif len(rsSelectFAM001.CtaFaltantes) eq 0>
				<cfthrow message="FA_CIERREDIARIO.FA_CIERREDIARIO.VALIDACIONES_PREVIAS. La caja no tiene cuenta de Faltantes, no se puede efectuar cierre a cajas sin cuenta de Faltantes. Proceso Cancelado!"/>
			<cfelseif len(rsSelectFAM001.Ccuenta) eq 0>
				<cfthrow message="FA_CIERREDIARIO.FA_CIERREDIARIO.VALIDACIONES_PREVIAS. La caja no tiene cuenta, no se puede efectuar cierre a cajas sin cuenta. Proceso Cancelado!"/>
			</cfif>
		<cfelse>
			<cfthrow message="FA_CIERREDIARIO.FA_CIERREDIARIO.VALIDACIONES_PREVIAS. La caja no existe en la empresa. Proceso Cancelado!"/>
		</cfif>
		<cfquery name="rsSelectFAX001P" datasource="#session.dsn#">
			select 1
			from FAX001
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Caja#">
			and FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="P">
		</cfquery>
		<cfif rsSelectFAX001P.recordcount>
			<cfthrow message="FA_CIERREDIARIO.FA_CIERREDIARIO.VALIDACIONES_PREVIAS. La caja tiene transacciones en proceso. Proceso Cancelado!"/>
		</cfif>
		<!--- *************************************************** ASIGNAR CUENTAS ***************************************************** --->
		<cfif debug>
			<hr>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
			  <tr>
				<td class="style1">&nbsp;<strong>ASIGNAR CUENTAS</strong></td>
			  </tr>
			</table>
		</cfif>
		<!--- Asigna Cuenta de Faltantes (FAM001.CtaFaltantes) --->
		<!--- Asigna Cuenta de Sobrantes (FAM001.CtaSobrantes) --->
		<!--- Asigna Cuenta de Caja (FAM001.Ccuenta) --->
		<!--- Asigna Cuenta de Tarjetas (FATarjetas.FATcuentacob) --->
		<!--- Asigna Cuenta de Comisiones de Tarjetas (FATarjetas.FATcuentacom) --->
		<!--- Asigna Cuenta de Depósitos (CuentasBancos.Ccuenta) --->
		<!--- Asigna Cuenta de Cartas Bancarias (FAM018.Ccuenta) --->
		<!--- Asigna Cuenta de Comisiones de Cartas Bancarias (FAM018.CtaComision) --->
		<!--- 	Asigna Cuenta de Ventas 	(
										Servicios: Asignar FAX004.CcuentaV numeric con FAX004.CtaVenF varchar (100)
										Artículos: IAContables.IACingventa
										)
				Y
				Asigna Cuenta de Descuentos por Ventas (
										Servicios: Asignar FAX004.CcuentaD numeric con FAX004.CtaDesF varchar (100)
										Artículos: IAContables.IACdescventa
										)
				Precondiciones: Asume que la Caja Existe.
		--->
		<cfquery datasource="#session.dsn#">
			Update FAX004
			set CcuentaV = ((select d.IACingventa from Existencias c, IAContables d where c.Aid = FAX004.Aid and c.Alm_Aid = FAX004.Alm_Aid and c.IACcodigo = d.IACcodigo and c.Ecodigo = d.Ecodigo))
			where FAX004.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			  and FAX004.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Caja#">
			  and exists(select 1 from FAX001 b
			    where b.Ecodigo = FAX004.Ecodigo
				  and b.FAX01NTR = FAX004.FAX01NTR
				  and b.FAM01COD = FAX004.FAM01COD
				  and b.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Caja#">
				  and b.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">)
			  and FAX004.FAX04TIP = <cfqueryparam cfsqltype="cf_sql_char" value="A">
			  and FAX004.CcuentaV is null
		</cfquery>
		<cfquery datasource="#session.dsn#">
			Update FAX004
			set CcuentaD = ((select d.IACdescventa from Existencias c, IAContables d where c.Aid = FAX004.Aid and c.Alm_Aid = FAX004.Alm_Aid and c.IACcodigo = d.IACcodigo and c.Ecodigo = d.Ecodigo))
			where FAX004.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			  and FAX004.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Caja#">
			  and exists(select 1 from FAX001 b
			    where b.Ecodigo = FAX004.Ecodigo
				  and b.FAX01NTR = FAX004.FAX01NTR
				  and b.FAM01COD = FAX004.FAM01COD
				  and b.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Caja#">
				  and b.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">)
			  and FAX004.FAX04TIP = <cfqueryparam cfsqltype="cf_sql_char" value="A">
			  and FAX004.CcuentaD is null
		</cfquery>
		<cfquery name="rsSelectFAX004" datasource="#session.dsn#">
			select distinct CtaVenF as Formato
			from FAX001 a, FAX004 b
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Caja#">
			and a.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
			and b.Ecodigo = a.Ecodigo
			and b.FAX01NTR = a.FAX01NTR
			and b.FAM01COD = a.FAM01COD
			and b.FAX04TIP = <cfqueryparam cfsqltype="cf_sql_char" value="S">
			and b.CcuentaV is null
			and b.CtaVenF is not null
			union
			select distinct CtaDesF as Formato
			from FAX001 a, FAX004 b
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Caja#">
			and a.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
			and b.Ecodigo = a.Ecodigo
			and b.FAX01NTR = a.FAX01NTR
			and b.FAM01COD = a.FAM01COD
			and b.FAX04TIP = <cfqueryparam cfsqltype="cf_sql_char" value="S">
			and b.CcuentaD is null
			and b.CtaDesF is not null
		</cfquery>
		<cfloop query="rsSelectFAX004">
			<cftransaction>
			<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
				<cfinvokeargument name="Lprm_Cmayor" value="#Left(Formato,4)#"/>							
				<cfinvokeargument name="Lprm_Cdetalle" value="#mid(Formato,6,100)#"/>
				<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
				<cfinvokeargument name="Lprm_DSN" value="#Session.Conexion#"/>
				<cfinvokeargument name="Lprm_Ecodigo" value="#Session.Ecodigo#"/>
			</cfinvoke>
			</cftransaction>
			<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
				<cfthrow message="FA_CIERREDIARIO.FA_CIERREDIARIO.VALIDACIONES_PREVIAS. #LvarError#. Proceso Cancelado!">
			<cfelse>
				<cfquery datasource="#session.dsn#">
					Update FAX004
						set CcuentaV = 
							(select min(Ccuenta)
							from CFinanciera 
							where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
							and CFformato = <cfqueryparam value="#Formato#" cfsqltype="cf_sql_varchar">)
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					and FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Caja#">
					and FAX04TIP = <cfqueryparam cfsqltype="cf_sql_char" value="S">
					and CtaVenF = <cfqueryparam value="#Formato#" cfsqltype="cf_sql_varchar">
					and CcuentaV is null
					and exists(select 1 from FAX001 b
							where b.Ecodigo = FAX004.Ecodigo
							and b.FAX01NTR = FAX004.FAX01NTR
							and b.FAM01COD = FAX004.FAM01COD
							and b.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">)
				</cfquery>
				<cfquery datasource="#session.dsn#">
					Update FAX004
						set CcuentaD = 
							(select min(Ccuenta)
							from CFinanciera 
							where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
							and CFformato = <cfqueryparam value="#Formato#" cfsqltype="cf_sql_varchar">)
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					and FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Caja#">
					and FAX04TIP = <cfqueryparam cfsqltype="cf_sql_char" value="S">
					and CtaDesF = <cfqueryparam value="#Formato#" cfsqltype="cf_sql_varchar">
					and CcuentaD is null
					and exists(select 1 from FAX001 b
							where b.Ecodigo = FAX004.Ecodigo
							and b.FAX01NTR = FAX004.FAX01NTR
							and b.FAM01COD = FAX004.FAM01COD
							and b.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">)
				</cfquery>
			</cfif>
		</cfloop>
		<cfquery name="rsSelectFAX004Count" datasource="#session.dsn#">
			select 1
			from FAX004 a
			inner join FAX001 b
				on b.Ecodigo = a.Ecodigo
				and b.FAM01COD = a.FAM01COD
				and b.FAX01NTR = a.FAX01NTR
				and b.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Caja#">
				and b.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
			where a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and a.FAX04TIP = <cfqueryparam cfsqltype="cf_sql_char" value="S">
			and a.CcuentaV is null
			union
			select 1
			from FAX004 a
			inner join FAX001 b
				on b.Ecodigo = a.Ecodigo
				and b.FAM01COD = a.FAM01COD
				and b.FAX01NTR = a.FAX01NTR
				and b.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Caja#">
				and b.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
			where a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and a.FAX04TIP = <cfqueryparam cfsqltype="cf_sql_char" value="S">
			and a.CcuentaD is null
		</cfquery>
		<cfif rsSelectFAX004Count.recordcount>
			<cfthrow message="FA_CIERREDIARIO.FA_CIERREDIARIO.VALIDACIONES_PREVIAS. No se logró definir las cuentas de ventas y/o descuentos por ventas. Proceso Cancelado!">
		</cfif>
		<!--- Asigna Cuenta de Costo de Ventas (Artículos: IAContables.IACcostoventa) --->
		<!--- Asigna Cuenta de Inventarios (Artículos: IAContables.IACinventario) --->
		<!--- Asigna Cuenta de Impuestos (Impuestos.Ccuenta) --->
		<!--- Asigna Cuenta de Recibos de Caja (Documentos.Ccuenta) --->
		<!--- Asigna Cuenta de Pagos de Facturas (Documentos.Ccuenta) --->
		<!--- Asigna Cuenta de Adelantos (
										Ya fué asignada FAX004.CcuentaV numeric con FAX004.CtaVenF varchar (100)
										)
		--->
		<!--- Asigna Cuenta de Facturas de Crédito (Documentos.Ccuenta) --->
		<!--- *************************************************** VERIFICAR CUENTAS *************************************************** --->
		<cfif debug>
			<hr>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
			  <tr>
				<td class="style1">&nbsp;<strong>VERIFICAR CUENTAS</strong></td>
			  </tr>
			</table>
		</cfif>
		<!--- *************************************************** TRANSACCIÓN ********************************************************* --->
		<cfif debug>
			<hr>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
			  <tr>
				<td class="style1">&nbsp;<strong>TRANSACCIÓN</strong></td>
			  </tr>
			</table>
		</cfif>
		<cftransaction>
		<!--- TRANSACCIÓN SECCION 0. CREA INTARC --->
		<cfif debug>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
			  <tr>
				<td class="style1">&nbsp;<strong>TRANSACCIÓN SECCION 0. CREA INTARC</strong></td>
			  </tr>
			</table>
		</cfif>
		<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="CreaIntarc" returnvariable="INTARC" conexion="#session.dsn#"/>
		<!--- TRANSACCIÓN SECCION 1. ANULAR TODAS LAS TRANSACCIONES GUARDADAS ---->
		<cfif debug>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
			  <tr>
				<td class="style1">&nbsp;<strong>TRANSACCIÓN SECCION 1. ANULAR TODAS LAS TRANSACCIONES GUARDADAS</strong></td>
			  </tr>
			</table>
		</cfif>
		<cfquery name="rsSelectFAX001P" datasource="#session.dsn#">
			select 1
			from FAX001
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Caja#">
			and FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="G">
		</cfquery>
		<cfif rsSelectFAX001P.recordcount>
			<cfquery datasource="#session.dsn#">
				update FAX004
				set FAX04DEL = 1
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				and FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Caja#">
				and exists ( select 1 from FAX001 
								where Ecodigo = FAX004.Ecodigo
								and FAX01NTR = FAX004.FAX01NTR 
								and FAX01COD = FAX004.FAX01COD 
								and FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="G">)
			</cfquery>
			<cfquery datasource="#session.dsn#">
				update FAX001
				set FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="A">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				and FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Caja#">
				and FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="G">
			</cfquery>
		</cfif>
		<!--- TRANSACCIÓN SECCION 2. CAMBIA ESTADO A CAJA A 50  ---->
		<cfif debug>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
			  <tr>
				<td class="style1">&nbsp;<strong>TRANSACCIÓN SECCION 2. CAMBIA ESTADO A CAJA A 50</strong></td>
			  </tr>
			</table>
		</cfif>
		<cfquery datasource="#session.dsn#">
			update FAM001
			set FAM01STP = 50
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Caja#">
		</cfquery>
		<!--- TRANSACCIÓN SECCION 3. INSERTA EN INTARC ***************************************************************************** ---->
		<cfif debug>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
			  <tr>
				<td class="style1">&nbsp;<strong>TRANSACCIÓN SECCION 3. INSERTA EN INTARC</strong></td>
			  </tr>
			</table>
		</cfif>
		<cfif debug and showPseudo>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
			  <tr><td class="style1"><table width="98%"  border="0" cellspacing="0" cellpadding="0">
				<tr><th scope="col" width="50%"><strong>D</strong></th><th scope="col" width="50%"><strong>C</strong></th></tr>
			  </table></td></tr>
			</table>
			<hr>
		</cfif>
		<!--- FALTANTE / SOBRANTE *************************************************************************************************** --->
		<cfif debug>
			<cfif showPseudo>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
				  <tr><td class="style1">&nbsp;<strong>FALTANTE / SOBRANTE</strong></td></tr>
				  <tr><td class="style1"><table width="98%"  border="0" cellspacing="0" cellpadding="0">
				  	<tr><th scope="col" width="50%">&nbsp;</th><th scope="col" width="50%">FAM001.Sobrantes</th></tr>
					<tr><th scope="col" width="50%">FAM001.Faltantes</th><th scope="col" width="50%">&nbsp;</th></tr>
				  </table></td></tr>
				</table>
				<hr>
			</cfif>			
		</cfif>
		<cfquery name="rs_FALTANTE_SOBRANTE" datasource="#session.dsn#">
			select coalesce(sum(FAX15MON),0.00) as FAX15MONsum
			from FAX015 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				and FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Caja#">
				and FAM30CTO = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
				and FAM30LIN = <cfqueryparam cfsqltype="cf_sql_integer" value="99">
				and FAX15SCO = <cfqueryparam cfsqltype="cf_sql_char" value="S">
		</cfquery> 
		<cfquery datasource="#session.dsn#">
			update FAX015
			set FAX15SCO = <cfqueryparam cfsqltype="cf_sql_char" value="C">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				and FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Caja#">
				and FAX15SCO = <cfqueryparam cfsqltype="cf_sql_char" value="S">
		</cfquery>
		<cfif rs_FALTANTE_SOBRANTE.recordcount and rs_FALTANTE_SOBRANTE.FAX15MONsum neq 0.00>
			<cfquery datasource="#session.dsn#">
				insert #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, 
									INTMON, INTTIP, INTDES, INTFEC, 
									INTCAM, Periodo, Mes, Ccuenta, 
									Mcodigo, Ocodigo, INTMOE)
				
				values (			'PV', 0, 'CD', 'Caja: #Arguments.Caja#', 
									<cfqueryparam cfsqltype="cf_sql_money" value="#abs(rs_FALTANTE_SOBRANTE.FAX15MONsum)#">, 
									<cfif rs_FALTANTE_SOBRANTE.FAX15MONsum GT 0.00>'C'<cfelse>'D'</cfif>,
									'Cierre Pos - Faltante/Sobrante', 
									<cfqueryparam cfsqltype="cf_sql_char" value="#Lvar_fechastr#">, 
									1.00, 
									<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Periodo#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Mes#">,
									<cfif rs_FALTANTE_SOBRANTE.FAX15MONsum GT 0.00>
										<cfqueryparam cfsqltype="cf_sql_numeric" value="rsSelectFAM001.CtaSobrantes">
									<cfelse>
										<cfqueryparam cfsqltype="cf_sql_numeric" value="rsSelectFAM001.CtaFaltantes">
									</cfif>,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Monloc#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSelectFAM001.Ocodigo#">,
									<cfqueryparam cfsqltype="cf_sql_money" value="#abs(rs_FALTANTE_SOBRANTE.FAX15MONsum)#">)
			</cfquery>
		</cfif>
		<cfif debug>
			<cfif showStruts>
				<cfquery name="rsdebug" datasource="#session.dsn#">
					select * from #INTARC#
				</cfquery>
				<cfdump var="#rsdebug#" label="#INTARC#">
			</cfif>
		</cfif>				
		<!--- EFECTIVO ************************************************************************************************************** --->
		<cfif debug>
			<cfif showPseudo>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
				  <tr><td class="style1">&nbsp;<strong>EFECTIVO</strong></td></tr>
				  <tr><td class="style1"><table width="98%"  border="0" cellspacing="0" cellpadding="0">
				  	<tr><th scope="col" width="50%">FAM001.Ccuenta</th><th scope="col" width="50%">&nbsp;</th></tr>
				  </table></td></tr>
				</table>
				<hr>
			</cfif>			
		</cfif>
		<cfquery datasource="#session.dsn#">
			insert #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, 
								INTMON, INTTIP, INTDES, INTFEC, 
								INTCAM, Periodo, Mes, Ccuenta, 
								Cgasto, Cformato, Mcodigo, Ocodigo, 
								INTMOE)

			select 				'PV', 
								0, 
								coalesce((
								select FAX11DOC
								from FAX011 c
								where c.Ecodigo = a.Ecodigo
								and c.FAM01COD = a.FAM01COD
								and c.FAX01NTR = a.FAX01NTR
								and c.FAX11LIN = (
										select max(d.FAX11LIN)
										from FAX011 d
										where c.FAM01COD = d.FAM01COD
										  and c.FAX01NTR = d.FAX01NTR
								)),'N/A'),
								substring(a.FAX01NTR,1,12), 
								(round(b.FAX12TOTMF * a.FAX01FCAM,2)), 
								'D', 
								'Cierre Pos - Efectivo', 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Lvar_fechastr#">, 
								a.FAX01FCAM, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Periodo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Mes#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSelectFAM001.Ccuenta#">, 
								null, 
								null, 
								a.Mcodigo, 
								a.Ocodigo, 
								b.FAX12TOTMF
			
			from FAX001 a 
				inner join  FAX012 b
				on b.Ecodigo = a.Ecodigo
				and b.FAM01COD = a.FAM01COD
				and b.FAX01NTR = a.FAX01NTR
				and b.FAX12TIP = 'EF'
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Caja#">
			and a.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
		</cfquery>
		<cfif debug>
			<cfif showStruts>
				<cfquery name="rsdebug" datasource="#session.dsn#">
					select * from #INTARC#
				</cfquery>
				<cfdump var="#rsdebug#" label="#INTARC#">
			</cfif>
		</cfif>
		<!--- CHEQUES *************************************************************************************************************** --->
		<cfif debug>
			<cfif showPseudo>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
				  <tr><td class="style1">&nbsp;<strong>CHEQUES</strong></td></tr>
				  <tr><td class="style1"><table width="98%"  border="0" cellspacing="0" cellpadding="0">
				  	<tr><th scope="col" width="50%">FAM001.Ccuenta</th><th scope="col" width="50%">&nbsp;</th></tr>
				  </table></td></tr>
				</table>
				<hr>
			</cfif>			
		</cfif>
		<cfquery datasource="#session.dsn#">
			insert #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, 
								INTMON, INTTIP, INTDES, INTFEC, 
								INTCAM, Periodo, Mes, Ccuenta, 
								Cgasto, Cformato, Mcodigo, Ocodigo, 
								INTMOE)

			select 				'PV', 
								0, 
								coalesce((
								select FAX11DOC
								from FAX011 c
								where c.Ecodigo = a.Ecodigo
								and c.FAM01COD = a.FAM01COD
								and c.FAX01NTR = a.FAX01NTR
								and c.FAX11LIN = (
										select max(d.FAX11LIN)
										from FAX011 d
										where c.FAM01COD = d.FAM01COD
										  and c.FAX01NTR = d.FAX01NTR
								)),'N/A'),
								substring(a.FAX01NTR,1,12), 
								(round(b.FAX12TOTMF * a.FAX01FCAM,2)), 
								'D', 
								'Cierre Pos - Cheque', 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Lvar_fechastr#">, 
								a.FAX01FCAM, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Periodo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Mes#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSelectFAM001.Ccuenta#">, 
								null, 
								null, 
								a.Mcodigo, 
								a.Ocodigo, 
								b.FAX12TOTMF
			
			from FAX001 a
				inner join FAX012 b
				on b.Ecodigo = a.Ecodigo
				and b.FAM01COD = a.FAM01COD
				and b.FAX01NTR = a.FAX01NTR
				and b.FAX12TIP = 'CK'
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Caja#">
			and a.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
		</cfquery>
		<cfif debug>
			<cfif showStruts>
				<cfquery name="rsdebug" datasource="#session.dsn#">
					select * from #INTARC#
				</cfquery>
				<cfdump var="#rsdebug#" label="#INTARC#">
			</cfif>
		</cfif>
		<!--- TARJETAS DE CRÉDITO - COMISION TARJETAS DE CRÉDITO ******************************************************************** --->
		<cfif debug>
			<cfif showPseudo>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
				  <tr><td class="style1">&nbsp;<strong>TARJETAS DE CRÉDITO - COMISION TARJETAS DE CRÉDITO</strong></td></tr>
				  <tr><td class="style1"><table width="98%"  border="0" cellspacing="0" cellpadding="0">
				  	<tr><th scope="col" width="50%">FATarjetas.FATcuentacob</th><th scope="col" width="50%">&nbsp;</th></tr>
				  </table></td></tr>
				</table>
				<hr>
			</cfif>			
		</cfif>
		<cfquery datasource="#session.dsn#">
			insert #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, 
								INTMON, INTTIP, INTDES, INTFEC, 
								INTCAM, Periodo, Mes, Ccuenta, 
								Cgasto, Cformato, Mcodigo, Ocodigo, 
								INTMOE)

			select 				'PV', 
								0, 
								coalesce((
								select FAX11DOC
								from FAX011 c
								where c.Ecodigo = a.Ecodigo
								and c.FAM01COD = a.FAM01COD
								and c.FAX01NTR = a.FAX01NTR
								and c.FAX11LIN = (
										select max(d.FAX11LIN)
										from FAX011 d
										where c.FAM01COD = d.FAM01COD
										  and c.FAX01NTR = d.FAX01NTR
								)),'N/A'),
								substring(a.FAX01NTR,1,12), 
								(round(b.FAX12TOTMF * a.FAX01FCAM,2)) 
								- 
								(
									(round(b.FAX12TOTMF * a.FAX01FCAM,2)) *
									(
										coalesce(e.FATporccom,0.00)
									) /
									100
								), 
								'D', 
								'Cierre Pos - Tarjeta Crédito', 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Lvar_fechastr#">, 
								a.FAX01FCAM, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Periodo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Mes#">,
								coalesce(e.FATcuentacob,<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSelectFAM001.Ccuenta#">), 
								null, 
								null, 
								a.Mcodigo, 
								a.Ocodigo, 
								b.FAX12TOTMF
								- 
								(
									b.FAX12TOTMF *
									(
										coalesce(e.FATporccom,0.00)
									) /
									100
								)
			
			from FAX001 a
				inner join FAX012 b
				on b.Ecodigo = a.Ecodigo
				and b.FAM01COD = a.FAM01COD
				and b.FAX01NTR = a.FAX01NTR
				and b.FAX12TIP = 'TC'
				left outer join FATarjetas e
				on e.FATid = b.FATid
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Caja#">
			and a.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
		</cfquery>
		<cfif debug>
			<cfif showStruts>
				<cfquery name="rsdebug" datasource="#session.dsn#">
					select * from #INTARC#
				</cfquery>
				<cfdump var="#rsdebug#" label="#INTARC#">
			</cfif>
		</cfif>
		<!--- COMISION TARJETAS DE CRÉDITO ****************************************************************************************** --->
		<cfif debug>
			<cfif showPseudo>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
				  <tr><td class="style1">&nbsp;<strong>COMISION TARJETAS DE CRÉDITO</strong></td></tr>
				  <tr><td class="style1"><table width="98%"  border="0" cellspacing="0" cellpadding="0">
				  	<tr><th scope="col" width="50%">FATarjetas.FATcuentacom</th><th scope="col" width="50%">&nbsp;</th></tr>
				  </table></td></tr>
				</table>
				<hr>
			</cfif>			
		</cfif>
		<cfquery datasource="#session.dsn#">
			insert #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, 
								INTMON, INTTIP, INTDES, INTFEC, 
								INTCAM, Periodo, Mes, Ccuenta, 
								Cgasto, Cformato, Mcodigo, Ocodigo, 
								INTMOE)

			select 				'PV', 
								0, 
								coalesce((
								select FAX11DOC
								from FAX011 c
								where c.Ecodigo = a.Ecodigo
								and c.FAM01COD = a.FAM01COD
								and c.FAX01NTR = a.FAX01NTR
								and c.FAX11LIN = (
										select max(d.FAX11LIN)
										from FAX011 d
										where c.FAM01COD = d.FAM01COD
										  and c.FAX01NTR = d.FAX01NTR
								)),'N/A'),
								substring(a.FAX01NTR,1,12), 
								(
									(round(b.FAX12TOTMF * a.FAX01FCAM,2)) *
									(
										coalesce(e.FATporccom,0.00)
									) /
									100
								), 
								'D', 
								'Cierre Pos - Comisión Tarjeta Crédito', 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Lvar_fechastr#">, 
								a.FAX01FCAM, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Periodo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Mes#">,
								coalesce(e.FATcuentacom,<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSelectFAM001.Ccuenta#">), 
								null, 
								null, 
								a.Mcodigo, 
								a.Ocodigo, 
								(
									b.FAX12TOTMF *
									(
										coalesce(e.FATporccom,0.00)
									) /
									100
								)
			
			from FAX001 a
				inner join FAX012 b
				on b.Ecodigo = a.Ecodigo
				and b.FAM01COD = a.FAM01COD
				and b.FAX01NTR = a.FAX01NTR
				and b.FAX12TIP = 'TC'
				left outer join FATarjetas e
				on e.FATid = b.FATid
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Caja#">
			and a.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
		</cfquery>
		<cfif debug>
			<cfif showStruts>
				<cfquery name="rsdebug" datasource="#session.dsn#">
					select * from #INTARC#
				</cfquery>
				<cfdump var="#rsdebug#" label="#INTARC#">
			</cfif>
		</cfif>
		<!--- DEPÓSITOS ************************************************************************************************************* --->
		<cfif debug>
			<cfif showPseudo>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
				  <tr><td class="style1">&nbsp;<strong>DEPÓSITOS</strong></td></tr>
				  <tr><td class="style1"><table width="98%"  border="0" cellspacing="0" cellpadding="0">
				  	<tr><th scope="col" width="50%">CuentasBancos.Ccuenta</th><th scope="col" width="50%">&nbsp;</th></tr>
				  </table></td></tr>
				</table>
				<hr>
			</cfif>			
		</cfif>
		<cfquery datasource="#session.dsn#">
			insert #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, 
								INTMON, INTTIP, INTDES, INTFEC, 
								INTCAM, Periodo, Mes, Ccuenta, 
								Cgasto, Cformato, Mcodigo, Ocodigo, 
								INTMOE)

			select 				'PV', 
								0, 
								coalesce((
								select FAX11DOC
								from FAX011 c
								where c.Ecodigo = a.Ecodigo
								and c.FAM01COD = a.FAM01COD
								and c.FAX01NTR = a.FAX01NTR
								and c.FAX11LIN = (
										select max(d.FAX11LIN)
										from FAX011 d
										where c.FAM01COD = d.FAM01COD
										  and c.FAX01NTR = d.FAX01NTR
								)),'N/A'),
								substring(a.FAX01NTR,1,12), 
								(round(b.FAX12TOTMF * a.FAX01FCAM,2)), 
								'D', 
								'Cierre Pos - Deposito', 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Lvar_fechastr#">, 
								a.FAX01FCAM, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Periodo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Mes#">,
								coalesce(
									(
									select min(e.Ccuenta)
									from CuentasBancos e
									where e.CBcodigo = b.FAX12CTA
									and e.Ecodigo = b.Ecodigo
									)
									,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSelectFAM001.Ccuenta#">
								), 
								null, 
								null, 
								a.Mcodigo, 
								a.Ocodigo, 
								b.FAX12TOTMF
			
			from FAX001 a 
				inner join FAX012 b
				on b.Ecodigo = a.Ecodigo
				and b.FAM01COD = a.FAM01COD
				and b.FAX01NTR = a.FAX01NTR
				and b.FAX12TIP = 'DB'
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Caja#">
			and a.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
		</cfquery>
		<cfif debug>
			<cfif showStruts>
				<cfquery name="rsdebug" datasource="#session.dsn#">
					select * from #INTARC#
				</cfquery>
				<cfdump var="#rsdebug#" label="#INTARC#">
			</cfif>
		</cfif>
		<!--- CARTAS BANCARIAS - COMISIÓN CARTAS BANCARIAS ************************************************************************** --->
		<cfif debug>
			<cfif showPseudo>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
				  <tr><td class="style1">&nbsp;<strong>CARTAS BANCARIAS - COMISIÓN CARTAS BANCARIAS</strong></td></tr>
				  <tr><td class="style1"><table width="98%"  border="0" cellspacing="0" cellpadding="0">
				  	<tr><th scope="col" width="50%">FAM018.Ccuenta</th><th scope="col" width="50%">&nbsp;</th></tr>
				  </table></td></tr>
				</table>
				<hr>
			</cfif>			
		</cfif>
		<cfquery datasource="#session.dsn#">
			insert #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, 
								INTMON, INTTIP, INTDES, INTFEC, 
								INTCAM, Periodo, Mes, Ccuenta, 
								Cgasto, Cformato, Mcodigo, Ocodigo, 
								INTMOE)

			select 				'PV', 
								0, 
								coalesce((
								select FAX11DOC
								from FAX011 c
								where c.Ecodigo = a.Ecodigo
								and c.FAM01COD = a.FAM01COD
								and c.FAX01NTR = a.FAX01NTR
								and c.FAX11LIN = (
										select max(d.FAX11LIN)
										from FAX011 d
										where c.FAM01COD = d.FAM01COD
										  and c.FAX01NTR = d.FAX01NTR
								)),'N/A'),
								substring(a.FAX01NTR,1,12), 
								(round(b.FAX12TOTMF * a.FAX01FCAM,2)) -
								((round(b.FAX12TOTMF * a.FAX01FCAM,2)) * 0 / 100)
								, 
								'D', 
								'Cierre Pos - Carta Bancaria', 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Lvar_fechastr#">, 
								a.FAX01FCAM, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Periodo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Mes#">,
								coalesce(e.Ccuenta,<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSelectFAM001.Ccuenta#">), 
								null, 
								null, 
								a.Mcodigo, 
								a.Ocodigo, 
								b.FAX12TOTMF -
								(b.FAX12TOTMF * 0 / 100)
			
			from FAX001 a 
				inner join FAX012 b
				on b.Ecodigo = a.Ecodigo
				and b.FAM01COD = a.FAM01COD
				and b.FAX01NTR = a.FAX01NTR
				and b.FAX12TIP = 'CP'
				left outer join FAM018 e
				on e.Bid = b.Bid
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Caja#">
			and a.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
		</cfquery>
		<cfif debug>
			<cfif showStruts>
				<cfquery name="rsdebug" datasource="#session.dsn#">
					select * from #INTARC#
				</cfquery>
				<cfdump var="#rsdebug#" label="#INTARC#">
			</cfif>
		</cfif>
		<!--- COMISIÓN CARTAS BANCARIAS ********************************************************************************************* --->
		<cfif debug>
			<cfif showPseudo>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
				  <tr><td class="style1">&nbsp;<strong>COMISIÓN CARTAS BANCARIAS</strong></td></tr>
				  <tr><td class="style1"><table width="98%"  border="0" cellspacing="0" cellpadding="0">
				  	<tr><th scope="col" width="50%">FAM018.Ccuentacom</th><th scope="col" width="50%">&nbsp;</th></tr>
				  </table></td></tr>
				</table>
				<hr>
			</cfif>			
		</cfif>
		<cfquery datasource="#session.dsn#">
			insert #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, 
								INTMON, INTTIP, INTDES, INTFEC, 
								INTCAM, Periodo, Mes, Ccuenta, 
								Cgasto, Cformato, Mcodigo, Ocodigo, 
								INTMOE)

			select 				'PV', 
								0, 
								coalesce((
								select FAX11DOC
								from FAX011 c
								where c.Ecodigo = a.Ecodigo
								and c.FAM01COD = a.FAM01COD
								and c.FAX01NTR = a.FAX01NTR
								and c.FAX11LIN = (
										select max(d.FAX11LIN)
										from FAX011 d
										where c.FAM01COD = d.FAM01COD
										  and c.FAX01NTR = d.FAX01NTR
								)),'N/A'),
								substring(a.FAX01NTR,1,12), 
								((round(b.FAX12TOTMF * a.FAX01FCAM,2)) * 0 / 100)
								, 
								'D', 
								'Cierre Pos - Comisión Carta Bancaria', 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Lvar_fechastr#">, 
								a.FAX01FCAM, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Periodo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Mes#">,
								coalesce(e.Ccuenta,<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSelectFAM001.Ccuenta#">), 
								null, 
								null, 
								a.Mcodigo, 
								a.Ocodigo, 
								(b.FAX12TOTMF * 0 / 100)
			
			from FAX001 a
				inner join FAX012 b
				on b.Ecodigo = a.Ecodigo
				and b.FAM01COD = a.FAM01COD
				and b.FAX01NTR = a.FAX01NTR
				and b.FAX12TIP = 'CP'
				left outer join FAM018 e
				on e.Bid = b.Bid
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Caja#">
			and a.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
		</cfquery>
		<cfif debug>
			<cfif showStruts>
				<cfquery name="rsdebug" datasource="#session.dsn#">
					select * from #INTARC#
				</cfquery>
				<cfdump var="#rsdebug#" label="#INTARC#">
			</cfif>
		</cfif>
		<!--- VENTAS SERVICIOS ****************************************************************************************************** --->
		<cfif debug>
			<cfif showPseudo>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
				  <tr><td class="style1">&nbsp;<strong>VENTAS SERVICIOS</strong></td></tr>
				  <tr><td class="style1"><table width="98%"  border="0" cellspacing="0" cellpadding="0">
				  	<tr><th scope="col" width="50%">&nbsp;</th><th scope="col" width="50%">FAX004.CcuentaV</th></tr>
				  </table></td></tr>
				</table>
				<hr>
			</cfif>			
		</cfif>
		<cfquery datasource="#session.dsn#">
			insert #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, 
								INTMON, INTTIP, INTDES, INTFEC, 
								INTCAM, Periodo, Mes, Ccuenta, 
								Cgasto, Cformato, Mcodigo, Ocodigo, 
								INTMOE)

			select 				'PV', 
								0, 
								coalesce((
								select FAX11DOC
								from FAX011 c
								where c.Ecodigo = a.Ecodigo
								and c.FAM01COD = a.FAM01COD
								and c.FAX01NTR = a.FAX01NTR
								and c.FAX11LIN = (
										select max(d.FAX11LIN)
										from FAX011 d
										where c.FAM01COD = d.FAM01COD
										  and c.FAX01NTR = d.FAX01NTR
								)),'N/A'),
								substring(a.FAX01NTR,1,12), 
								(round(b.FAX04TOT * a.FAX01FCAM,2)), 
								'C', 
								'Cierre Pos - Venta', 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Lvar_fechastr#">, 
								a.FAX01FCAM, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Periodo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Mes#">,
								b.CcuentaV, 
								null, 
								null, 
								a.Mcodigo, 
								a.Ocodigo, 
								b.FAX04TOT
			
			from FAX001 a 
				inner join  FAX004 b
				on b.Ecodigo = a.Ecodigo
				and b.FAM01COD = a.FAM01COD
				and b.FAX01NTR = a.FAX01NTR
				and b.FAX04TIP = 'S'
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Caja#">
			and a.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
		</cfquery>
		<cfif debug>
			<cfif showStruts>
				<cfquery name="rsdebug" datasource="#session.dsn#">
					select * from #INTARC#
				</cfquery>
				<cfdump var="#rsdebug#" label="#INTARC#">
			</cfif>
		</cfif>
		<!--- VENTAS ARTÍCULOS ****************************************************************************************************** --->
		<cfif debug>
			<cfif showPseudo>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
				  <tr><td class="style1">&nbsp;<strong>VENTAS ARTÍCULOS</strong></td></tr>
				  <tr><td class="style1"><table width="98%"  border="0" cellspacing="0" cellpadding="0">
				  	<tr><th scope="col" width="50%">&nbsp;</th><th scope="col" width="50%">IAContables.IACingventa</th></tr>
				  </table></td></tr>
				</table>
				<hr>
			</cfif>			
		</cfif>
		<cfquery datasource="#session.dsn#">
			insert #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, 
								INTMON, INTTIP, INTDES, INTFEC, 
								INTCAM, Periodo, Mes, Ccuenta, 
								Cgasto, Cformato, Mcodigo, Ocodigo, 
								INTMOE)

			select 				'PV', 
								0, 
								coalesce((
								select FAX11DOC
								from FAX011 c
								where c.Ecodigo = a.Ecodigo
								and c.FAM01COD = a.FAM01COD
								and c.FAX01NTR = a.FAX01NTR
								and c.FAX11LIN = (
										select max(d.FAX11LIN)
										from FAX011 d
										where c.FAM01COD = d.FAM01COD
										  and c.FAX01NTR = d.FAX01NTR
								)),'N/A'),
								substring(a.FAX01NTR,1,12), 
								(round(b.FAX04TOT * a.FAX01FCAM,2)), 
								'C', 
								'Cierre Pos - Venta', 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Lvar_fechastr#">, 
								a.FAX01FCAM, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Periodo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Mes#">,
								coalesce(f.IACingventa,b.CcuentaV), 
								null, 
								null, 
								a.Mcodigo, 
								a.Ocodigo, 
								b.FAX04TOT
			
			from FAX001 a 
				inner join  FAX004 b
				on b.Ecodigo = a.Ecodigo
				and b.FAM01COD = a.FAM01COD
				and b.FAX01NTR = a.FAX01NTR
				and b.FAX04TIP = 'A'
				left outer join Existencias e
				on e.Aid = b.Aid
				and e.Alm_Aid = b.Alm_Aid
				left outer join IAContables f
				on f.IACcodigo = e.IACcodigo
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Caja#">
			and a.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
		</cfquery>
		<cfif debug>
			<cfif showStruts>
				<cfquery name="rsdebug" datasource="#session.dsn#">
					select * from #INTARC#
				</cfquery>
				<cfdump var="#rsdebug#" label="#INTARC#">
			</cfif>
		</cfif>
		<!--- DESCUENTO VENTAS SERVICIOS ****************************************************************************************************** --->
		<cfif debug>
			<cfif showPseudo>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
				  <tr><td class="style1">&nbsp;<strong>DESCUENTO VENTAS SERVICIOS</strong></td></tr>
				  <tr><td class="style1"><table width="98%"  border="0" cellspacing="0" cellpadding="0">
				  	<tr><th scope="col" width="50%">FAX004.CcuentaD</th><th scope="col" width="50%">&nbsp;</th></tr>
				  </table></td></tr>
				</table>
				<hr>
			</cfif>			
		</cfif>
		<cfquery datasource="#session.dsn#">
			insert #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, 
								INTMON, INTTIP, INTDES, INTFEC, 
								INTCAM, Periodo, Mes, Ccuenta, 
								Cgasto, Cformato, Mcodigo, Ocodigo, 
								INTMOE)

			select 				'PV', 
								0, 
								coalesce((
								select FAX11DOC
								from FAX011 c
								where c.Ecodigo = a.Ecodigo
								and c.FAM01COD = a.FAM01COD
								and c.FAX01NTR = a.FAX01NTR
								and c.FAX11LIN = (
										select max(d.FAX11LIN)
										from FAX011 d
										where c.FAM01COD = d.FAM01COD
										  and c.FAX01NTR = d.FAX01NTR
								)),'N/A'),
								substring(a.FAX01NTR,1,12), 
								(round(b.FAX04DESC * a.FAX01FCAM,2)), 
								'D', 
								'Cierre Pos - Descuento Venta', 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Lvar_fechastr#">, 
								a.FAX01FCAM, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Periodo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Mes#">,
								b.CcuentaD, 
								null, 
								null, 
								a.Mcodigo, 
								a.Ocodigo, 
								b.FAX04DESC
			
			from FAX001 a 
				inner join  FAX004 b
				on b.Ecodigo = a.Ecodigo
				and b.FAM01COD = a.FAM01COD
				and b.FAX01NTR = a.FAX01NTR
				and b.FAX04TIP = 'S'
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Caja#">
			and a.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
		</cfquery>
		<cfif debug>
			<cfif showStruts>
				<cfquery name="rsdebug" datasource="#session.dsn#">
					select * from #INTARC#
				</cfquery>
				<cfdump var="#rsdebug#" label="#INTARC#">
			</cfif>
		</cfif>
		<!--- DESCUENTO VENTAS ARTÍCULOS ****************************************************************************************************** --->
		<cfif debug>
			<cfif showPseudo>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
				  <tr><td class="style1">&nbsp;<strong>DESCUENTO VENTAS ARTÍCULOS</strong></td></tr>
				  <tr><td class="style1"><table width="98%"  border="0" cellspacing="0" cellpadding="0">
				  	<tr><th scope="col" width="50%">IAContables.IACdescventa</th><th scope="col" width="50%">&nbsp;</th></tr>
				  </table></td></tr>
				</table>
				<hr>
			</cfif>			
		</cfif>
		<cfquery datasource="#session.dsn#">
			insert #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, 
								INTMON, INTTIP, INTDES, INTFEC, 
								INTCAM, Periodo, Mes, Ccuenta, 
								Cgasto, Cformato, Mcodigo, Ocodigo, 
								INTMOE)

			select 				'PV', 
								0, 
								coalesce((
								select FAX11DOC
								from FAX011 c
								where c.Ecodigo = a.Ecodigo
								and c.FAM01COD = a.FAM01COD
								and c.FAX01NTR = a.FAX01NTR
								and c.FAX11LIN = (
										select max(d.FAX11LIN)
										from FAX011 d
										where c.FAM01COD = d.FAM01COD
										  and c.FAX01NTR = d.FAX01NTR
								)),'N/A'),
								substring(a.FAX01NTR,1,12), 
								(round(b.FAX04DESC * a.FAX01FCAM,2)), 
								'D', 
								'Cierre Pos - Descuento Venta', 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Lvar_fechastr#">, 
								a.FAX01FCAM, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Periodo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Mes#">,
								coalesce(f.IACdescventa,b.CcuentaD), 
								null, 
								null, 
								a.Mcodigo, 
								a.Ocodigo, 
								b.FAX04DESC
			
			from FAX001 a 
				inner join  FAX004 b
				on b.Ecodigo = a.Ecodigo
				and b.FAM01COD = a.FAM01COD
				and b.FAX01NTR = a.FAX01NTR
				and b.FAX04TIP = 'A'
				left outer join Existencias e
				on e.Aid = b.Aid
				and e.Alm_Aid = b.Alm_Aid
				left outer join IAContables f
				on f.IACcodigo = e.IACcodigo
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Caja#">
			and a.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
		</cfquery>
		<cfif debug>
			<cfif showStruts>
				<cfquery name="rsdebug" datasource="#session.dsn#">
					select * from #INTARC#
				</cfquery>
				<cfdump var="#rsdebug#" label="#INTARC#">
			</cfif>
		</cfif>
		<!--- COSTO DE VENTAS ******************************************************************************************************* --->
		<cfif debug>
			<cfif showPseudo>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
				  <tr><td class="style1">&nbsp;<strong>COSTO DE VENTAS</strong></td></tr>
				  <tr><td class="style1"><table width="98%"  border="0" cellspacing="0" cellpadding="0">
				  	<tr><th scope="col" width="50%">IAContables.IACcostoventa</th><th scope="col" width="50%">&nbsp;</th></tr>
				  </table></td></tr>
				</table>
				<hr>
			</cfif>			
		</cfif>
		<cfquery datasource="#session.dsn#">
			insert #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, 
								INTMON, INTTIP, INTDES, INTFEC, 
								INTCAM, Periodo, Mes, Ccuenta, 
								Cgasto, Cformato, Mcodigo, Ocodigo, 
								INTMOE)

			select 				'PV', 
								0, 
								coalesce((
								select FAX11DOC
								from FAX011 c
								where c.Ecodigo = a.Ecodigo
								and c.FAM01COD = a.FAM01COD
								and c.FAX01NTR = a.FAX01NTR
								and c.FAX11LIN = (
										select max(d.FAX11LIN)
										from FAX011 d
										where c.FAM01COD = d.FAM01COD
										  and c.FAX01NTR = d.FAX01NTR
								)),'N/A'),
								substring(a.FAX01NTR,1,12), 
								round(k.Kcosto,2), 
								'D', 
								'Cierre Pos - Costo de Ventas', 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Lvar_fechastr#">, 
								1.00, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Periodo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Mes#">,
								coalesce(f.IACcostoventa,b.CcuentaV), 
								null, 
								null, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Monloc#">,
								a.Ocodigo, 
								round(k.Kcosto,2)
			
			from FAX001 a 
				inner join  FAX004 b
				on b.Ecodigo = a.Ecodigo
				and b.FAM01COD = a.FAM01COD
				and b.FAX01NTR = a.FAX01NTR
				inner join Kardex k
				on k.Kid = b.Kid
				left outer join Existencias e
				on e.Aid = b.Aid
				and e.Alm_Aid = b.Alm_Aid
				left outer join IAContables f
				on f.IACcodigo = e.IACcodigo
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Caja#">
			and a.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
		</cfquery>
		<cfif debug>
			<cfif showStruts>
				<cfquery name="rsdebug" datasource="#session.dsn#">
					select * from #INTARC#
				</cfquery>
				<cfdump var="#rsdebug#" label="#INTARC#">
			</cfif>
		</cfif>
		<!--- INVENTARIOS *********************************************************************************************************** --->
		<cfif debug>
			<cfif showPseudo>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
				  <tr><td class="style1">&nbsp;<strong>INVENTARIOS</strong></td></tr>
				  <tr><td class="style1"><table width="98%"  border="0" cellspacing="0" cellpadding="0">
				  	<tr><th scope="col" width="50%">&nbsp;</th><th scope="col" width="50%">IAContables.IACinventario</th></tr>
				  </table></td></tr>
				</table>
				<hr>
			</cfif>			
		</cfif>
				<cfquery datasource="#session.dsn#">
			insert #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, 
								INTMON, INTTIP, INTDES, INTFEC, 
								INTCAM, Periodo, Mes, Ccuenta, 
								Cgasto, Cformato, Mcodigo, Ocodigo, 
								INTMOE)

			select 				'PV', 
								0, 
								coalesce((
								select FAX11DOC
								from FAX011 c
								where c.Ecodigo = a.Ecodigo
								and c.FAM01COD = a.FAM01COD
								and c.FAX01NTR = a.FAX01NTR
								and c.FAX11LIN = (
										select max(d.FAX11LIN)
										from FAX011 d
										where c.FAM01COD = d.FAM01COD
										  and c.FAX01NTR = d.FAX01NTR
								)),'N/A'),
								substring(a.FAX01NTR,1,12), 
								round(k.Kcosto,2), 
								'C', 
								'Cierre Pos - Costo de Ventas', 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Lvar_fechastr#">, 
								1.00, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Periodo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Mes#">,
								coalesce(f.IACinventario,b.CcuentaV), 
								null, 
								null, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Monloc#">,
								a.Ocodigo, 
								round(k.Kcosto,2)
			
			from FAX001 a 
				inner join  FAX004 b
				on b.Ecodigo = a.Ecodigo
				and b.FAM01COD = a.FAM01COD
				and b.FAX01NTR = a.FAX01NTR
				inner join Kardex k
				on k.Kid = b.Kid
				left outer join Existencias e
				on e.Aid = b.Aid
				and e.Alm_Aid = b.Alm_Aid
				left outer join IAContables f
				on f.IACcodigo = e.IACcodigo
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Caja#">
			and a.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
		</cfquery>
		<cfif debug>
			<cfif showStruts>
				<cfquery name="rsdebug" datasource="#session.dsn#">
					select * from #INTARC#
				</cfquery>
				<cfdump var="#rsdebug#" label="#INTARC#">
			</cfif>
		</cfif>
		<!--- IMPUESTOS ************************************************************************************************************* --->
		<cfif debug>
			<cfif showPseudo>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
				  <tr><td class="style1">&nbsp;<strong>IMPUESTOS</strong></td></tr>
				  <tr><td class="style1"><table width="98%"  border="0" cellspacing="0" cellpadding="0">
				  	<tr><th scope="col" width="50%">&nbsp;</th><th scope="col" width="50%">Impuestos.Ccuenta</th></tr>
				  </table></td></tr>
				</table>
				<hr>
			</cfif>			
		</cfif>
		<cfquery datasource="#session.dsn#">
			insert #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, 
								INTMON, INTTIP, INTDES, INTFEC, 
								INTCAM, Periodo, Mes, Ccuenta, 
								Cgasto, Cformato, Mcodigo, Ocodigo, 
								INTMOE)

			select 				'PV', 
								0, 
								coalesce((
								select FAX11DOC
								from FAX011 c
								where c.Ecodigo = a.Ecodigo
								and c.FAM01COD = a.FAM01COD
								and c.FAX01NTR = a.FAX01NTR
								and c.FAX11LIN = (
										select max(d.FAX11LIN)
										from FAX011 d
										where c.FAM01COD = d.FAM01COD
										  and c.FAX01NTR = d.FAX01NTR
								)),'N/A'),
								substring(a.FAX01NTR,1,12), 
								(round(a.FAX01MIT* a.FAX01FCAM,2)), 
								'C', 
								'Cierre Pos - Impuestos', 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Lvar_fechastr#">, 
								a.FAX01FCAM, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Periodo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Mes#">,
								e.Ccuenta, 
								null, 
								null, 
								a.Mcodigo, 
								a.Ocodigo, 
								a.FAX01MIT
			
			from FAX001 a
			inner join Impuestos e
			on e.Ecodigo = a.Ecodigo
			and e.Icodigo = a.Icodigo
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Caja#">
			and a.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
		</cfquery>
		<cfif debug>
			<cfif showStruts>
				<cfquery name="rsdebug" datasource="#session.dsn#">
					select * from #INTARC#
				</cfquery>
				<cfdump var="#rsdebug#" label="#INTARC#">
			</cfif>
		</cfif>
		<!--- DESCUENTOS ************************************************************************************************************ --->
		<cfif debug>
			<cfif showPseudo>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
				  <tr><td class="style1">&nbsp;<strong>DESCUENTOS</strong></td></tr>
				  <tr><td class="style1"><table width="98%"  border="0" cellspacing="0" cellpadding="0">
				  	<tr><th scope="col" width="50%">FAX004.CcuentaD</th><th scope="col" width="50%">&nbsp;</th></tr>
				  </table></td></tr>
				</table>
				<hr>
			</cfif>			
		</cfif>
		<cfquery datasource="#session.dsn#">
			insert #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, 
								INTMON, INTTIP, INTDES, INTFEC, 
								INTCAM, Periodo, Mes, Ccuenta, 
								Cgasto, Cformato, Mcodigo, Ocodigo, 
								INTMOE)

			select 				'PV', 
								0, 
								coalesce((
								select FAX11DOC
								from FAX011 c
								where c.Ecodigo = a.Ecodigo
								and c.FAM01COD = a.FAM01COD
								and c.FAX01NTR = a.FAX01NTR
								and c.FAX11LIN = (
										select max(d.FAX11LIN)
										from FAX011 d
										where c.FAM01COD = d.FAM01COD
										  and c.FAX01NTR = d.FAX01NTR
								)),'N/A'),
								substring(a.FAX01NTR,1,12), 
								(round(coalesce(a.FAX01MDT, 0)* a.FAX01FCAM,2)), 
								'D', 
								'Cierre Pos - Descuentos', 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Lvar_fechastr#">, 
								a.FAX01FCAM, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Periodo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Mes#">,
								b.CcuentaD, 
								null, 
								null, 
								a.Mcodigo, 
								a.Ocodigo, 
								coalesce(a.FAX01MDT, 0)
			
			from FAX001 a
				inner join FAX004 b
				on b.Ecodigo = a.Ecodigo
				and b.FAM01COD = a.FAM01COD
				and b.FAX01NTR = a.FAX01NTR
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Caja#">
			and a.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
		</cfquery>
		<cfif debug>
			<cfif showStruts>
				<cfquery name="rsdebug" datasource="#session.dsn#">
					select * from #INTARC#
				</cfquery>
				<cfdump var="#rsdebug#" label="#INTARC#">
			</cfif>
		</cfif>
		<!--- DOCUMENTOS ************************************************************************************************************ --->
		<cfif debug>
			<cfif showPseudo>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" height="20">
				  <tr><td class="style1">&nbsp;<strong>DOCUMENTOS</strong></td></tr>
				  <tr><td class="style1"><table width="98%"  border="0" cellspacing="0" cellpadding="0">
				  	<tr><th scope="col" width="50%">Si CCTtipo es C entonces Documentos.Cuenta</th><th scope="col" width="50%">Si CCTtipo es C entonces Documentos.Cuenta</th></tr>
				  </table></td></tr>
				</table>
				<hr>
			</cfif>			
		</cfif>
		<cfquery datasource="#session.dsn#">
			insert #INTARC# ( 	INTORI, INTREL, INTDOC, INTREF, 
								INTMON, INTTIP, INTDES, INTFEC, 
								INTCAM, Periodo, Mes, Ccuenta, 
								Cgasto, Cformato, Mcodigo, Ocodigo, 
								INTMOE)

			select 				'PV', 
								0, 
								coalesce((
								select FAX11DOC
								from FAX011 c
								where c.Ecodigo = a.Ecodigo
								and c.FAM01COD = a.FAM01COD
								and c.FAX01NTR = a.FAX01NTR
								and c.FAX11LIN = (
										select max(d.FAX11LIN)
										from FAX011 d
										where c.FAM01COD = d.FAM01COD
										  and c.FAX01NTR = d.FAX01NTR
								)),'N/A'),
								substring(a.FAX01NTR,1,12), 
								(round(b.Dtotal * b.Dtipocambio,2)), 
								e.CCTtipo, 
								'Cierre Pos - Documentos', 
								<cfqueryparam cfsqltype="cf_sql_char" value="#Lvar_fechastr#">, 
								b.Dtipocambio, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Periodo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Mes#">,
								b.Ccuenta, 
								null, 
								null, 
								b.Mcodigo, 
								a.Ocodigo, 
								b.Dtotal
			
			from FAX001 a 
				inner join Documentos b
				on b.Ecodigo = a.Ecodigo
				and b.CCTcodigo = a.CCTcodigo
				and b.Ddocumento = a.FAX01NDOC
				inner join CCTransacciones e
				on e.Ecodigo = b.Ecodigo
				and e.CCTcodigo = b.CCTcodigo				
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and a.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Caja#">
			and a.FAX01STA = <cfqueryparam cfsqltype="cf_sql_char" value="T">
		</cfquery>
		<cfif debug>
			<cfif showStruts>
				<cfquery name="rsdebug" datasource="#session.dsn#">
					select * from #INTARC#
				</cfquery>
				<cfdump var="#rsdebug#" label="#INTARC#">
			</cfif>
		</cfif>
		<!--- DEBUG FINAL --->
		<cfif debug>
			<cfif showStruts>
			<cfquery name="rsdebug" datasource="#session.dsn#">
				select * from dual
			</cfquery>
			<cfdump var="#rsdebug#" label="rsdebug">
			</cfif>
			<cftransaction action="rollback"/>
			</fieldset>
		</cfif>
		</cftransaction>
		<cfset done=true>
		<!--- fin    --->
		<cfreturn done>
	</cffunction>
	<cffunction name="fnIsNull" access="private" returntype="boolean" output="false">
		<cfargument name="lValue" required="yes" type="any">
		<cfargument name="IValueIfNull" required="yes" type="any">
		<cfif len(trim(lValue))>
			<cfreturn lValue>
		<cfelse>
			<cfreturn lValueIfNull>
		</cfif>
	</cffunction>
	<cffunction name="AplicarMascara" access="public" output="true" returntype="string">
		<cfargument name="cuenta"   type="string" required="true">
		<cfargument name="objgasto" type="string" required="true">

		<cfset vCuenta = arguments.cuenta >
		<cfset vObjgasto = arguments.objgasto >

		<cfif len(trim(vCuenta))>
			<cfloop condition="Find('?',vCuenta,0) neq 0">
				<cfif len(trim(vObjgasto))>
					<cfset caracter = mid(vObjgasto, 1, 1) >
					<cfset vObjgasto = mid(vObjgasto, 2, len(vObjgasto)) >
					<cfset vCuenta = replace(vCuenta,'?',caracter) >
				<cfelse>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
		<cfreturn vCuenta >
	</cffunction>
</cfcomponent>