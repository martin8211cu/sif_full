<!---
	Modificado por: Steve Vado
	Fecha : 26/Dic/2005
	Marca : SVR20050522-03
	Motivo:	Actualiza en GATransacciones cada uno de los documentos que	han sido aplicados,
			utilizando la referencias de las tablas EContablesImportacion y DContablesImportacion.

	Modificado por Mauricio Esquivel.  22 Febrero 2006
	Ajustes:
		Utilizacion de Tablas Temporales para mejorar rendimiento y evitar bloqueos

		Soporte de Tabla Temporal de Interfaz masiva #IE16 para utilizar solamente un componente en la validación de cuentas!.

		Pasar primero la validación de balance de asiento antes de validar que las cuentas se hayan validado.

	Modificado por Gustavo Fonseca H.
		Fecha: 22-2-2006.
		Motivo: Se graba en EContables el campo ECreversible.
		Colocar correctamente el campo ECtipo para soporte de asientos retroactivos.
		Averiguar el periodo actual de la conta para determinar si es retroactivo o no.

	Modificacion por Gustavo Fonseca H. M. Esquivel
		Fecha: 2-3-2006
		Motivo:  Actualizar correctamente el tipo de asiento al importar -ECtipo -
			(Normal, Retroactivo, Intercompany)

	Modificacion por Mauricio Esquivel
		Fecha:  2/Agosto/2007
		Motivo:  Disminuir los asientos contables muy grandes, resumiendo las cuentas / oficinas
		Funcion: CG_AplicaImportacionAsiento, que recibe un parametro de resumir.

--->

<cfcomponent>

	<cffunction name="CG_VerficaImportacionAsiento" access="public" output="no">
		<cfargument name="ECIid"           		type="numeric" required="yes">
		<cfargument name="Ecodigo"         		type="numeric" default="#Session.Ecodigo#" required="no">
		<cfargument name="Conexion"        		type="string"  default="#Session.DSN#" 	   required="no">
		<cfargument name="ValidacionInterfaz16" type="boolean" default="false" 			   required="no">

		<cfset LvarConexion = Arguments.Conexion>

		<cfif not Arguments.ValidacionInterfaz16>

			<cfset LvarTabla = "DContablesImportacion">

			<!--- Obtener la fecha del asiento a verificar --->
			<cfquery name="rsObtieneFecha" datasource="#LvarConexion#">
				select Efecha
				from EContablesImportacion
				where ECIid = #Arguments.ECIid#
			</cfquery>

			<cfif isdefined("rsObtieneFecha") and len(rsObtieneFecha.Efecha)>
				<cfset LvarFecha = rsObtieneFecha.Efecha>
			<cfelse>
				<cfset LvarFecha = createdate (year(now()), month(now()), day(now()))>
			</cfif>

		<cfelse>
				<!------ Crear la tabla temporal de trabajo de IE16 ------>
				<cf_dbtemp name="OE16_V06" returnvariable="OE16" datasource="#LvarConexion#">
					<cf_dbtempcol name="ID"					type="numeric"		mandatory="yes">
					<cf_dbtempcol name="NumeroLinea"		type="integer"		mandatory="yes">
					<cf_dbtempcol name="CFformato"			type="char(100)"	mandatory="yes">
					<cf_dbtempcol name="CFcuenta"			type="numeric"		mandatory="no">
					<cf_dbtempcol name="Fecha"				type="datetime"		mandatory="yes">
					<cf_dbtempcol name="Oficodigo"			type="char(10)"		mandatory="yes">
					<cf_dbtempcol name="Resultado"			type="int"  		mandatory="yes">
					<cf_dbtempcol name="MSG"				type="varchar(255)"	mandatory="no">

					<cf_dbtempcol name="ECIid"				type="numeric"		mandatory="yes">
					<cf_dbtempcol name="Ccuenta"			type="numeric"		mandatory="no">
					<cf_dbtempcol name="DCIlinea"			type="numeric"		mandatory="no">
					<cf_dbtempcol name="Ecodigo"			type="integer"		mandatory="yes">
					<cf_dbtempcol name="EcodigoRef"			type="integer"		mandatory="yes">
					<cf_dbtempcol name="Ocodigo"			type="integer"		mandatory="no">
					<cf_dbtempcol name="Eperiodo"			type="integer"		mandatory="no">
					<cf_dbtempcol name="Emes"				type="integer"		mandatory="no">
					<cf_dbtempcol name="CFid"				type="numeric"		mandatory="no">
					<cf_dbtempcol name="CFcodigo"			type="varchar(20)"	mandatory="no">
				</cf_dbtemp>

				<!--- Importar desde la Vista de IE16 de sif_interfaces a la tabla temporal --->

				<cfquery datasource="#LvarConexion#">
					insert into #OE16# (ID, NumeroLinea, CFformato, CFcuenta, Fecha, Oficodigo, Resultado, MSG, ECIid, Ccuenta, DCIlinea, Ecodigo, Ocodigo, EcodigoRef, Eperiodo, Emes)
					select i.ID, i.NumeroLinea, i.CuentaFinanciera, null, i.Fecha, i.Oficodigo, 0, null, i.ID, null, i.NumeroLinea, #Arguments.Ecodigo#, null, #Arguments.Ecodigo#, #year(now())#, #month(now())#
					from v_IE16 i
					where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ECIid#">
				</cfquery>

				<cfquery datasource="#LvarConexion#">
					update #OE16#
					set CFcuenta = ((select min(CFcuenta) from CFinanciera cf where cf.CFformato = #OE16#.CFformato and cf.Ecodigo = #OE16#.Ecodigo))
				</cfquery>

				<cfquery datasource="#LvarConexion#">
					update #OE16#
					set Ccuenta = ((select min(Ccuenta) from CFinanciera cf where cf.CFcuenta = #OE16#.CFcuenta and cf.Ecodigo = #OE16#.Ecodigo))
					where CFcuenta is not null
				</cfquery>

				<cfquery datasource="#LvarConexion#">
					update #OE16#
					set Ocodigo = ((select min(Ocodigo) from Oficinas o where o.Oficodigo = #OE16#.Oficodigo and o.Ecodigo = #OE16#.Ecodigo))
				</cfquery>

				<cfquery name="rsObtieneFecha" datasource="#LvarConexion#">
					select min(Fecha) as Fecha
					from #OE16#
				</cfquery>

				<cfif isdefined('rsObtieneFecha') and rsObtieneFecha.recordcount GT 0>
					<cfset LvarFecha = rsObtieneFecha.Fecha>
				<cfelse>
					<cfset LvarFecha = dateformat(Now(),"yyyymmdd")>
				</cfif>
				<cfset LvarTabla = #OE16#>
		</cfif>

		<cfset LvarVerificacionOK = CG_VerificaImportacionAsiento_local (Arguments.ECIid,  Arguments.Ecodigo, LvarConexion, LvarTabla, LvarFecha)>

		<cfif Arguments.ValidacionInterfaz16>

			<cfquery datasource="#LvarConexion#">
				insert into v_OE16 (ID, NumeroLinea, CuentaFinanciera, CFcuenta, Oficodigo, Resultado, MSG)
				select
					ID,
					NumeroLinea,
					CFformato,
					CFcuenta,
					Oficodigo,
					case when Resultado <> 1 then 3 else 1 end,
					case when Resultado = 1 then 'OK' else coalesce(MSG, 'NO') end
				from #OE16#
			</cfquery>

		</cfif>

		<cfreturn LvarVerificacionOK>

	</cffunction>

	<cffunction name="CG_VerificaImportacionAsiento_local" access="private" output="no">
		<cfargument name="ECIid"           		type="numeric" 	required="yes">
		<cfargument name="Ecodigo"         		type="numeric" 	required="yes">
		<cfargument name="Conexion"        		type="string" 	required="yes">
		<cfargument name="LvarTabla" 			type="string"  	required="yes">
		<cfargument name="LvarFecha"			type="date"    	required="yes">


		<cfset LvarTablaValidacion = Arguments.LvarTabla>
		<cfset LvarFecha = Arguments.LvarFecha>
		<cfset LvarConexion = Arguments.Conexion>

		<!---
			Creacion de tablas temporales de trabajo
				mayvalidas  son las cuentas de mayor que tienen Reglas Validas a verificar
				maynvalidas son las cuentas de mayor que tienen Reglas NO Validas a verificar
				Iincorrectas son las lineas que tienen cuentas incorrectas (para evitar bloqueo)

		--->
		<cf_dbtemp name="mayvalidas" returnvariable="Lvar_MAYvalidas">
			<cf_dbtempcol name="Ecodigo" type="int">
			<cf_dbtempcol name="Cmayor"  type="char(4)">
		</cf_dbtemp>

		<cf_dbtemp name="maynvalidas" returnvariable="lvar_MAYNvalidas">
			<cf_dbtempcol name="Ecodigo" type="int">
			<cf_dbtempcol name="Cmayor"  type="char(4)">
		</cf_dbtemp>

		<cf_dbtemp name="Iincorrectas" returnvariable="Lvar_Iincorrectas">
			<cf_dbtempcol name="DCIlinea"  type="numeric">
			<cf_dbtempcol name="Resultado" type="integer">
		</cf_dbtemp>

			<!---
				El campo Resultado establece el tipo de error
						0.  Por validar
						1.  Es correcta la cuenta
						2.  No pasó por Reglas de Inclusión
						3.  No pasó por Reglas de Exclusion
						4.  Valor de Catalogo está inactivo
						5.  Catalogo está inactivo
						6.  Cuenta Financiera Inactiva
						7.  Cuenta Contable Inactiva
						8.  No hay cuenta de Presupuesto
						9.  Valor de Pertencia de Catalogos es Incorrecto
						10. Oficina no Existe en la Empresa
						11. Error generado por el PC_GeneraCuentaFinanciera
						12. El campo CFcodigo digitado es incorrecto
			--->

			<!---
				1.
				Verificar las Empresas del asiento importado:
					Si EcodigoRef es null se debe actualizar con Ecodigo
					Si EcodigoRef es cero o -1 se debe actualizar con Ecodigo
				Una vez actualizado, se simplifican los procesos de validacion
			--->

			<cfset LvarECIid     = Arguments.ECIid>
			<cfset LvarEcodigo   = Arguments.Ecodigo>
			<cfset LvarConexion  = Arguments.Conexion>

			<cfset LvarVerificacionOK = "OK">

			<cfquery datasource="#LvarConexion#">
				update #LvarTablaValidacion#
				set EcodigoRef = Ecodigo,
					Resultado  = 0,
					MSG   = null
				where ECIid = #LvarECIid#
				  and EcodigoRef is null
			</cfquery>

			<cfquery datasource="#LvarConexion#">
				update #LvarTablaValidacion#
				set EcodigoRef = Ecodigo,
					Resultado  = 0,
					MSG   = null
				where ECIid = #LvarECIid#
				  and (EcodigoRef = 0 or EcodigoRef = -1)
			</cfquery>


			<!--- Se ponen como por validar todas los registro sque aparezcan con errores en la valicion --->
			<cfquery datasource="#LvarConexion#">
				update #LvarTablaValidacion#
				set Resultado = 0,
					MSG = null
				where ECIid = #LvarECIid#
				  and (Resultado > 1 or Resultado is null)
			</cfquery>

			<!--- Se ponen como NO VALIDAS las oficinas que no existan.... Esto por seguridad --->
			<cfquery datasource="#LvarConexion#">
				update #LvarTablaValidacion#
				set Resultado = 10,
					Ocodigo = null,
					MSG = 'Oficina NO Encontrada'
				where ECIid = #LvarECIid#
				  and not exists(
				  		select 1
						from Oficinas o
						where o.Ecodigo = #LvarTablaValidacion#.EcodigoRef
						  and o.Ocodigo = #LvarTablaValidacion#.Ocodigo)
			</cfquery>

			<!---
				2. Actualizar la cuenta cuando ya exista el formato en CFinanciera para no hacerlo individualmente
			--->

			<cfquery datasource="#LvarConexion#">
				update #LvarTablaValidacion#
					set
						CFcuenta = coalesce((
								select min(CFcuenta)
								from CFinanciera cf
								where cf.CFformato = #LvarTablaValidacion#.CFformato
								  and cf.Ecodigo   = #LvarTablaValidacion#.EcodigoRef
								), 0),
						Ccuenta = coalesce((
								select min(cf.Ccuenta)
								from CFinanciera cf
								where cf.CFformato = #LvarTablaValidacion#.CFformato
								  and cf.Ecodigo   = #LvarTablaValidacion#.EcodigoRef
								), 0),
						Resultado = 0
				where ECIid     = #LvarECIid#
				  and (CFcuenta is null or Ccuenta is null)
			</cfquery>

			<!---
				2.1 Indicar si la cuenta que se está indicando NO es de último nivel - Acepta Movimientos
			--->
			<cfquery datasource="#LvarConexion#">
				update #LvarTablaValidacion#
				set Resultado = 12, MSG = 'La Cuenta EXISTE pero no es de Ultimo Nivel o NO Acepta Movimientos'
				where ECIid = #LvarECIid#
				  and Resultado = 0
				  and CFcuenta is not null
				  and CFcuenta > 0
				  and exists(
				  		select 1
						from CFinanciera cf
						where cf.CFcuenta = #LvarTablaValidacion#.CFcuenta
						  and cf.CFmovimiento <> 'S'
						)
			</cfquery>

			<!---
				3. Validar Reglas tomando en cuenta la oficina
			--->
			<cfquery datasource="#LvarConexion#">
				insert into #Lvar_MAYvalidas# (Ecodigo, Cmayor)
				select Ecodigo, Cmayor
				from CtasMayor m
				where Ecodigo = #Arguments.Ecodigo#
				  and exists(
					select 1
					from PCReglas r
					where r.Cmayor = m.Cmayor
					  and r.Ecodigo = m.Ecodigo
					  and r.PCRvalida = 1
					  and r.PCRref is null
					  and <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#"> between r.PCRdesde and r.PCRhasta
					)
			</cfquery>

			<cfquery datasource="#LvarConexion#">
				insert into #lvar_MAYNvalidas# (Ecodigo, Cmayor)
				select Ecodigo, Cmayor
				from CtasMayor m
				where Ecodigo = #Arguments.Ecodigo#
				  and exists(
					select 1
					from PCReglas r
					where r.Cmayor = m.Cmayor
					  and r.Ecodigo = m.Ecodigo
					  and r.PCRvalida = 0
					  and r.PCRref is null
					  and <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#"> between r.PCRdesde and r.PCRhasta
					)
			</cfquery>

			<cfquery datasource="#LvarConexion#">
				insert into #Lvar_Iincorrectas# (DCIlinea, Resultado)
				select DCIlinea, 2
				from #LvarTablaValidacion# i
					inner join Oficinas o
						on o.Ecodigo = i.EcodigoRef
						and o.Ocodigo = i.Ocodigo
					inner join #Lvar_MAYvalidas# v
						on v.Ecodigo = i.EcodigoRef
						and v.Cmayor = <cf_dbfunction name="sPart" args="i.CFformato, 1, 4">
				where ECIid     = #LvarECIid#
				  and Resultado < 1
				  and not exists(
						select 1
						from PCReglas  r2
						where r2.Cmayor    = v.Cmayor
						  and r2.Ecodigo   = v.Ecodigo
						  and r2.PCRvalida = 1
						  and r2.PCRref    is null
						  and <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#"> between r2.PCRdesde and r2.PCRhasta
						  and <cf_dbfunction name="like"	args="i.CFformato ; r2.PCRregla" delimiters=";">
						  and <cf_dbfunction name="like"	args="o.Oficodigo ; coalesce(r2.OficodigoM, '%')" delimiters=";">
						  and not exists (
								select 1
								from PCReglas r3
								where r3.PCRref = r2.PCRid
								  and r3.PCRvalida = 0
								  and <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#"> between r3.PCRdesde and r3.PCRhasta
								  and <cf_dbfunction name="like"	args="i.CFformato ; r3.PCRregla" delimiters=";">
								  and <cf_dbfunction name="like"	args="o.Oficodigo ; coalesce(r3.OficodigoM, '%')" delimiters=";">
							)
						)
			</cfquery>


			<cfquery datasource="#LvarConexion#">
				update #LvarTablaValidacion#
				set Resultado = 2, MSG = 'La cuenta NO CUMPLE con las Reglas de INCLUSION definidas'
				where ECIid = #LvarECIid#
				   and Resultado < 1
				   and exists(
					select 1
					from #Lvar_Iincorrectas# i
					where i.Resultado = 2
					  and i.DCIlinea = #LvarTablaValidacion#.DCIlinea
					)
			</cfquery>

			<cfquery datasource="#LvarConexion#">
				insert into #Lvar_Iincorrectas# (DCIlinea, Resultado)
				select DCIlinea, 3
				from #LvarTablaValidacion# i
					inner join Oficinas o
						on o.Ecodigo = i.EcodigoRef
						and o.Ocodigo = i.Ocodigo
					inner join #lvar_MAYNvalidas# v
						on v.Ecodigo = i.EcodigoRef
						and v.Cmayor = <cf_dbfunction name="sPart" args="i.CFformato, 1, 4">
				where ECIid     = #LvarECIid#
				  and Resultado < 1
				  and exists(
						select 1
						from PCReglas  r4
						where r4.Cmayor    = v.Cmayor
						  and r4.Ecodigo   = v.Ecodigo
						  and r4.PCRvalida = 0
						  and r4.PCRref    is null
						  and <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#"> between r4.PCRdesde and r4.PCRhasta
						  and <cf_dbfunction name="like"	args="i.CFformato ; r4.PCRregla" delimiters=";">
						  and <cf_dbfunction name="like"	args="o.Oficodigo ; coalesce(r4.OficodigoM, '%')" delimiters=";">
						  and not exists (
								select 1
								from PCReglas r5
								where r5.PCRref = r4.PCRid
								  and r5.PCRvalida = 1
								  and <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#"> between r5.PCRdesde and r5.PCRhasta
								  and <cf_dbfunction name="like"	args="i.CFformato ; r5.PCRregla" delimiters=";">
								  and <cf_dbfunction name="like"	args="o.Oficodigo ; coalesce(r5.OficodigoM, '%')" delimiters=";">
							)
						)
			</cfquery>


			<cfquery datasource="#LvarConexion#">
				update #LvarTablaValidacion#
				set Resultado = 3, MSG = 'La cuenta CUMPLE con al menos UNA de las Reglas de EXCLUSION definidas'
				where ECIid = #LvarECIid#
				   and Resultado < 1
				   and exists(
					select 1
					from #Lvar_Iincorrectas# i
					where i.Resultado = 3
					  and i.DCIlinea = #LvarTablaValidacion#.DCIlinea
					)
			</cfquery>


			<cfquery datasource="#LvarConexion#">
				delete from #Lvar_Iincorrectas#
			</cfquery>


			<!----  Valor de Catalogo Inactivo --->
			<cfquery datasource="#LvarConexion#">
				insert into #Lvar_Iincorrectas# (DCIlinea, Resultado)
				select i.DCIlinea, 4
				from #LvarTablaValidacion# i
				where i.ECIid      = #LvarECIid#
				  and i.CFcuenta  is not null
				  and i.Resultado = 0
				  and exists (
						select 1
						from PCDCatalogoCuentaF cf
							inner join PCDCatalogo dc
								 on dc.PCDcatid = cf.PCDcatid
								and dc.PCDactivo = 0
						where cf.CFcuenta = i.CFcuenta
					)
			</cfquery>

			<cfquery datasource="#LvarConexion#">
				update #LvarTablaValidacion#
				set Resultado = 4, MSG = 'La cuenta tiene un Valor de Catálogo Inactivo'
				where ECIid = #LvarECIid#
				   and Resultado < 1
				   and exists(
					select 1
					from #Lvar_Iincorrectas# i
					where i.Resultado = 4
					  and i.DCIlinea = #LvarTablaValidacion#.DCIlinea
					)
			</cfquery>

			<cfquery datasource="#LvarConexion#">
				delete from #Lvar_Iincorrectas#
			</cfquery>

			<!----  Catalogo Inactivo --->
			<cfquery datasource="#LvarConexion#">
				insert into #Lvar_Iincorrectas# (DCIlinea, Resultado)
				select DCIlinea, 5
				from #LvarTablaValidacion# i
				where i.ECIid      = #LvarECIid#
				  and i.CFcuenta  is not null
				  and i.Resultado = 0
				  and exists (
						select 1
						from PCDCatalogoCuentaF cf
							inner join PCECatalogo ec
								 on ec.PCEcatid = cf.PCEcatid
								and ec.PCEactivo = 0
						where cf.CFcuenta = i.CFcuenta
					)
			</cfquery>

			<cfquery datasource="#LvarConexion#">
				update #LvarTablaValidacion#
				set Resultado = 5, MSG = 'La cuenta tiene un Catálogo Inactivo'
				where ECIid = #LvarECIid#
				   and Resultado < 1
				   and exists(
					select 1
					from #Lvar_Iincorrectas# i
					where i.Resultado = 5
					  and i.DCIlinea = #LvarTablaValidacion#.DCIlinea
					)
			</cfquery>

			<cfquery datasource="#LvarConexion#">
				delete from #Lvar_Iincorrectas#
			</cfquery>

			<!--- Resultado=10: CONTROL DE OBRAS --->
			<cfquery datasource="#LvarConexion#">
				insert into #Lvar_Iincorrectas# (DCIlinea, Resultado)
				  select DCIlinea, 10
				     from #LvarTablaValidacion# i
					    inner join OBctasMayor om
					      on om.Ecodigo		= i.EcodigoRef
					     and om.Cmayor		= <cf_dbfunction name="string_part"   args="i.CFformato, 1, 4">
					     and om.OBCcontrolCuentas	= 1
				   where ECIid     = #LvarECIid#
				     and Resultado < 1
				     and (select count(1)
						    from OBetapaCuentas ec
							  inner join OBetapa e
								   on e.OBEid	 = ec.OBEid
								  and e.Ecodigo = ec.Ecodigo
							  inner join OBobra o
								   on o.OBOid   = e.OBOid
								  and o.Ecodigo = e.Ecodigo

						 where ec.Ecodigo	    = i.EcodigoRef
						   and ec.CFformato	    = i.CFformato
						   and e.Ocodigo		= i.Ocodigo
						   and ec.OBECestado	= '1'
						   and o.OBOestado      = '1'
							and e.OBEestado	    = '1'
							) > 0
			   </cfquery>

			<cfquery datasource="#LvarConexion#">
				update #LvarTablaValidacion#
				set Resultado = 10, MSG = 'La cuenta no esta registrada o esta inactiva en Control de Obras'
				where ECIid = #LvarECIid#
				   and Resultado < 1
				   and exists(
					select 1
					from #Lvar_Iincorrectas# i
					where i.Resultado = 10
					  and i.DCIlinea = #LvarTablaValidacion#.DCIlinea
					)
			</cfquery>

			<cfquery datasource="#LvarConexion#">
				delete from #Lvar_Iincorrectas#
			</cfquery>
			<!--- Fin CONTROL DE OBRAS --->

			<!--- Cuenta Financiera Inactiva --->
			<cfquery datasource="#LvarConexion#">
				insert into #Lvar_Iincorrectas# (DCIlinea, Resultado)
				select DCIlinea, 6
				from #LvarTablaValidacion# i
				where i.ECIid      = #LvarECIid#
				  and i.CFcuenta  is not null
				  and i.Resultado = 0
				  and exists (
						select 1
						from PCDCatalogoCuentaF cf
							inner join CFInactivas ci
									 on ci.CFcuenta = cf.CFcuentaniv
									and <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#"> between ci.CFIdesde and ci.CFIhasta
						where cf.CFcuenta = i.CFcuenta
					)

			</cfquery>

			<cfquery datasource="#LvarConexion#">
				update #LvarTablaValidacion#
				set Resultado = 6, MSG = 'La cuenta Financiera o una de sus cuentas MADRE está INACTIVA'
				where ECIid = #LvarECIid#
				   and Resultado < 1
				   and exists(
					select 1
					from #Lvar_Iincorrectas# i
					where i.Resultado = 6
					  and i.DCIlinea = #LvarTablaValidacion#.DCIlinea
					)
			</cfquery>

			<cfquery datasource="#LvarConexion#">
				delete from #Lvar_Iincorrectas#
			</cfquery>

			<!--- Cuenta Contable Inactiva --->
			<cfquery datasource="#LvarConexion#">
				insert into #Lvar_Iincorrectas# (DCIlinea, Resultado)
				select DCIlinea, 7
				from #LvarTablaValidacion# i
				where i.ECIid      = #LvarECIid#
				  and i.Ccuenta  is not null
				  and i.Resultado = 0
				  and exists (
						select 1
						from PCDCatalogoCuenta cc
							inner join CCInactivas ci
									 on ci.Ccuenta = cc.Ccuentaniv
									and <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#"> between ci.CCIdesde and ci.CCIhasta
						where cc.Ccuenta = i.Ccuenta
					)

			</cfquery>

			<cfquery datasource="#LvarConexion#">
				update #LvarTablaValidacion#
				set Resultado = 7, MSG = 'La cuenta Contable o una de sus cuentas MADRE está INACTIVA'
				where ECIid = #LvarECIid#
				   and Resultado < 1
				   and exists(
					select 1
					from #Lvar_Iincorrectas# i
					where i.Resultado = 7
					  and i.DCIlinea = #LvarTablaValidacion#.DCIlinea
					)
			</cfquery>

			<cfquery datasource="#LvarConexion#">
				delete from #Lvar_Iincorrectas#
			</cfquery>

			<!--- La cuenta tiene Cuenta Presupuestaria y esta no existe en el catálogo de cuentas de presupuesto --->
			<cfquery datasource="#LvarConexion#">
				insert into #Lvar_Iincorrectas# (DCIlinea, Resultado)
				select DCIlinea, 8
				from #LvarTablaValidacion# i
					inner join CPresupuestoPeriodo pp
						 on pp.Ecodigo	= i.EcodigoRef			<!--- Que exista un periodo de presupuesto --->
						and i.Eperiodo*100+i.Emes between pp.CPPanoMesDesde and pp.CPPanoMesHasta
						and pp.CPPestado 			in (1,2) 	<!--- Que ya haya sido abierto --->
						and pp.CPPcrearFrmCalculo 	= 0 		<!--- Que no haya generación dinámica de formulación --->
				where i.ECIid      = #LvarECIid#
				  and i.CFcuenta  is not null
				  and i.Resultado = 0
				  and exists (
				  		select 1
						from CFinanciera cf, CPresupuesto cp <!---SML 12/06/2014. Modificacion para que se consideren las cuentas que estan excluidas para el presupuesto--->
						where cf.CFcuenta = i.CFcuenta
                          and cp.CPcuenta = cf.CPcuenta <!---SML 12/06/2014. Modificacion para que se consideren las cuentas que estan excluidas para el presupuesto--->
						  and cf.CPcuenta is not null
						  and not exists(
						  		select 1
								  from CPresupuestoControl pc
								 where pc.Ecodigo	= i.EcodigoRef
								   and pc.CPPid		= pp.CPPid
								   and pc.CPCano	= i.Eperiodo
								   and pc.CPCmes	= i.Emes
								   and pc.CPcuenta	= cf.CPcuenta
								   and pc.Ocodigo 	= i.Ocodigo
							)
                         <!---SML 12/06/2014. Modificacion para que se consideren las cuentas que estan excluidas para el presupuesto--->
                    	  and (SELECT count(1) FROM CPtipoCtas
				   		 	   WHERE CPPid = pp.CPPid AND Ecodigo = cp.Ecodigo AND Cmayor = cp.Cmayor
						       AND <cf_dbfunction name="LIKE" args="cp.CPformato,CPTCmascara"> AND CPTCtipo = 'X') = 0
						)
			</cfquery>

			<cfquery datasource="#LvarConexion#">
				update #LvarTablaValidacion#
				set Resultado = 8, MSG = 'NO se ha formulado la Cuenta de Presupuesto para la Cuenta Financiera y la Oficina en el Año/Mes - Seleccionado'
				where ECIid = #LvarECIid#
				   and Resultado < 1
				   and exists(
					select 1
					from #Lvar_Iincorrectas# i
					where i.Resultado = 8
					  and i.DCIlinea = #LvarTablaValidacion#.DCIlinea
					)
			</cfquery>

			<cfquery datasource="#LvarConexion#">
				delete from #Lvar_Iincorrectas#
			</cfquery>

			<!--- Validar que los catalogos se permitan en la oficina. Si no cumplen, envia un error de que la cuenta no se permite para la oficina --->
			<cfquery datasource="#LvarConexion#">
				insert into #Lvar_Iincorrectas# (DCIlinea, Resultado)
				select DCIlinea, 9
				from #LvarTablaValidacion# i
				where i.ECIid      = #LvarECIid#
				  and i.CFcuenta  is not null
				  and i.Resultado = 0
				  and exists(
				  	select 1
					from CFinanciera cf
						 inner join PCDCatalogoCuentaF cc
							inner join PCDCatalogo dc
								inner join PCECatalogo ec
									 on ec.PCEcatid = dc.PCEcatid
									and ec.PCEempresa = 1
									and ec.PCEoficina = 1
								on dc.PCDcatid = cc.PCDcatid
							on cc.CFcuenta = cf.CFcuenta
					where cf.CFcuenta = i.CFcuenta
					  and not exists(
					  		select 1
							from PCDCatalogoValOficina vo
							where vo.PCDcatid = cc.PCDcatid
							  and vo.Ecodigo  = i.EcodigoRef
							  and vo.Ocodigo  = i.Ocodigo
							)
					)
			</cfquery>
			<cf_dbfunction name="to_char" args=" min(cc.PCDCniv)" returnvariable="PCDCniv">
			<cfquery datasource="#LvarConexion#">
				update #LvarTablaValidacion#
				set Resultado = 9,
				MSG = <cf_dbfunction name="concat" args="'Existe un Catalogo de la Cuenta que NO se permite en la Oficina, en el Nivel  '
					+ coalesce((
							select #PreserveSingleQuotes(PCDCniv)#
							from CFinanciera cf
							inner join PCDCatalogoCuentaF cc
								inner join PCDCatalogo dc
									inner join PCECatalogo ec
										on ec.PCEcatid = dc.PCEcatid
									   and ec.PCEempresa = 1
									   and ec.PCEoficina = 1
									on dc.PCDcatid = cc.PCDcatid
								on cc.CFcuenta = cf.CFcuenta
							where cf.CFcuenta = #LvarTablaValidacion#.CFcuenta
							  and (select Count(1)
									from Oficinas o
										inner join PCDCatalogoValOficina vo
												on vo.Ecodigo  = o.Ecodigo
												and vo.Ocodigo  = o.Ocodigo
									where vo.PCDcatid = dc.PCDcatid
								   ) > 0
						), 'N/A')
						+ ' de la Cuenta '" delimiters="+">
				where ECIid = #LvarECIid#
				   and Resultado < 1
				   and exists(
					select 1
					from #Lvar_Iincorrectas# i
					where i.Resultado = 9
					  and i.DCIlinea = #LvarTablaValidacion#.DCIlinea
					)
			</cfquery>

			<cfquery datasource="#LvarConexion#">
				delete from #Lvar_Iincorrectas#
			</cfquery>

			<!--- Actualizar las cuentas que no tienen problemas y que ya existen como válidas --->
			<cfquery datasource="#LvarConexion#">
				update #LvarTablaValidacion#
				set Resultado = 1, MSG = null
				where ECIid = #LvarECIid#
				  and Resultado = 0
				  and CFcuenta is not null
				  and Ccuenta is not null
				  and CFcuenta > 0
				  and Ccuenta > 0
			</cfquery>

			<!--- Validar las cuentas que no existan y que no tengan problemas con las validaciones anteriores --->

			<cfquery name="rsDocs" datasource="#LvarConexion#">
				select distinct
					   a.EcodigoRef as EcodigoRef,
					   a.CFformato,
					   a.Ocodigo
				from #LvarTablaValidacion# a
				where a.ECIid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarECIid#">
				  and a.Ecodigo = #LvarEcodigo#
				  and Resultado = 0
			</cfquery>

			<cfloop query="rsDocs">

				<cfinvoke
				 component="sif.Componentes.PC_GeneraCuentaFinanciera"
				 method="fnGeneraCuentaFinanciera"
				 returnvariable="LvarMSG">
					<cfinvokeargument name="Lprm_CFformato" 		value="#rsDocs.CFformato#"/>
					<cfinvokeargument name="Lprm_Ocodigo" 			value="#rsDocs.Ocodigo#"/>
					<cfinvokeargument name="Lprm_fecha" 			value="#LvarFecha#"/>
					<cfinvokeargument name="Lprm_Ecodigo" 			value="#rsDocs.EcodigoRef#"/>
					<cfinvokeargument name="Lprm_TransaccionActiva" value="no"/>
				</cfinvoke>

				<cfif LvarMSG EQ "NEW" or LvarMSG EQ "OLD">
						<!--- Cuenta ya existe o se creo
							  Actualizar CFcuenta y Ccuenta en el detalle del asiento
						--->
						<cfquery name="updCuenta" datasource="#LvarConexion#">
							update #LvarTablaValidacion# set
								CFcuenta = (
									select min(CFcuenta)
									from CFinanciera
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDocs.EcodigoRef#">
									and CFformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDocs.CFformato#">
								),
								Ccuenta = (
									select min(Ccuenta)
									from CFinanciera
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDocs.EcodigoRef#">
									and CFformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDocs.CFformato#">
								),
								Resultado = 1,
								MSG  = null
							where ECIid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarECIid#">
							  and Resultado  = 0
							  and Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEcodigo#">
							  and EcodigoRef = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDocs.EcodigoRef#">
							  and CFformato  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDocs.CFformato#">
							  and Ocodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDocs.Ocodigo#">
						</cfquery>

				<cfelse>
						<cfquery name="updCuenta" datasource="#LvarConexion#">
							update #LvarTablaValidacion# set
								Resultado = 11,
								MSG  = '#LvarMSG#'
							where ECIid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarECIid#">
							  and Resultado  = 0
							  and Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEcodigo#">
							  and EcodigoRef = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDocs.EcodigoRef#">
							  and CFformato  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDocs.CFformato#">
							  and Ocodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDocs.Ocodigo#">
						</cfquery>

				</cfif>
			</cfloop>

			<cfif LvarTablaValidacion EQ "DContablesImportacion">
				<cfquery datasource="#LvarConexion#">
					update DContablesImportacion
					set CFid = null
					where ECIid = #LvarECIid#
					  and Resultado = 1
				</cfquery>

				<cfquery datasource="#LvarConexion#">
					update DContablesImportacion
					set CFid = (
							select min(cf.CFid)
							from CFuncional cf
							where cf.Ecodigo =  DContablesImportacion.EcodigoRef
							  and cf.CFcodigo = DContablesImportacion.CFcodigo
							  )
					where ECIid = #LvarECIid#
					  and CFcodigo is not null
					  and Resultado = 1
				</cfquery>

				<cfquery datasource="#LvarConexion#">
					update DContablesImportacion
					set
						Resultado = 12,
					 	MSG  = 'Centro Funcional no Encontrado'
					where ECIid = #LvarECIid#
					  and CFcodigo is not null
					  and CFid is null
					  and Resultado = 1
				</cfquery>
			</cfif>

			<!--- Una vez verificado el asiento, si hay cuentas con error entonces no se regresa un mensaje de error --->
			<cfquery name="rsVerificaCuentasValidas" datasource="#LvarConexion#">
				select count(1) as CantidadIncorrectas
				from #LvarTablaValidacion#
				where ECIid = #Arguments.ECIid#
				  and (
				  		Resultado <> 1
					or 	CFcuenta is null
					or 	CFcuenta = 0
					or 	Ccuenta is null
					or 	Ccuenta = 0
					)
			</cfquery>

			<cfif rsVerificaCuentasValidas.CantidadIncorrectas NEQ 0>
				<cfset LvarVerificacionOK = "NO. Existen Registros con Inconsistencias o Erroneas en la Importacion">
			</cfif>

			<cfreturn LvarVerificacionOK>

	</cffunction>

	<cffunction name="CG_AplicaImportacionAsiento" access="public" output="no">

		<cfargument name="ECIid" 				type="numeric">
		<cfargument name="CtlTransaccion" 		type="boolean" 	default="true">
		<cfargument name="Conexion" 			type="string" 	default="#Session.DSN#" required="false">
		<cfargument name="Resumir"  			type="boolean" 	default="false" required="no">
		<cfargument name="TransaccionActiva" 	type="boolean" 	default="false">

		<!--- Validar el periodo del asiento.  Maximo es el siguiente periodo para importarlo --->
		<cfquery name="rsEncabezado" datasource="#Arguments.Conexion#">
			select ECIid, Ecodigo, Cconcepto, Eperiodo, Emes, Efecha, Edescripcion, Edocbase, Ereferencia, BMfalta, BMUsucodigo, ECIreversible
			from EContablesImportacion
			where ECIid = #Arguments.ECIid#
		</cfquery>
		<!--- Obtener periodo y Mes de Parametros --->
		<cfquery name="rsPeriodo" datasource="#Arguments.Conexion#">
			select Pvalor as Pvalor
			from Parametros
			where Ecodigo = #Session.Ecodigo#
			  and  Pcodigo = 30
		</cfquery>

		<cfquery name="rsMes" datasource="#Arguments.Conexion#">
			select Pvalor as Pvalor
			from Parametros
			where Ecodigo = #Session.Ecodigo#
			  and  Pcodigo = 40
		</cfquery>

		<cfset LvarPeriodoActual = rsPeriodo.Pvalor * 12 + rsMes.Pvalor>
		<cfset LvarPeriodoAsiento = rsEncabezado.Eperiodo * 12 + rsEncabezado.Emes>

		<cfif (LvarPeriodoAsiento) GT (LvarPeriodoActual + 1)>
			<cf_errorCode	code = "51024"
							msg  = "El Asiento corresponde al periodo @errorDat_1@-@errorDat_2@. El periodo actual es @errorDat_3@-@errorDat_4@. Proceso Cancelado!"
							errorDat_1="#rsEncabezado.Emes#"
							errorDat_2="#rsEncabezado.Eperiodo#"
							errorDat_3="#rsMes.Pvalor#"
							errorDat_4="#rsPeriodo.Pvalor#"
			>
		</cfif>
		<!--- Ajustar EcodigoRef si es nulo, 0 o -1 --->
		<cfquery datasource="#Arguments.Conexion#">
			update DContablesImportacion set EcodigoRef = Ecodigo
			where ECIid = #Arguments.ECIid#
			  and (EcodigoRef is null or EcodigoRef = 0 or EcodigoRef = -1)
		</cfquery>


		<!--- Validar que las oficinas no se encuentren nulas --->
		<cfquery name="oficinas_invalidas" datasource="#Arguments.Conexion#">
			select count(1) as cantidad
			from DContablesImportacion
			where ECIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ECIid#">
			  and Ocodigo is null
		</cfquery>
		<cfif oficinas_invalidas.cantidad GT 0>
			<cf_errorCode	code = "51025" msg = "Existen oficinas no definidas en el documento contable a importar.">
		</cfif>


		<!--- Averiguar si el asiento es Intercompany --->
		<cfquery name="rsDImportacion" datasource="#Arguments.Conexion#">
			select count(1) as cantidad
			from DContablesImportacion
			where ECIid = #Arguments.ECIid#
			  and Ecodigo <> EcodigoRef
		</cfquery>
		<cfset Intercompany = (rsDImportacion.cantidad GT 0)>

		<cfif Intercompany>
			<!--- Validar que el documento contable esté balanceado tanto en moneda local como moneda origen --->
			<cfquery name="rsbalanceo" datasource="#Arguments.Conexion#">
				select m2.Miso4217,
					   sum(case when d.Dmovimiento = 'D' then d.Doriginal else 0 end) as DEB,
					   sum(case when d.Dmovimiento = 'C' then d.Doriginal else 0 end) as CRE
				from DContablesImportacion d
					inner join Monedas m
						on m.Ecodigo = d.Ecodigo
						and m.Mcodigo = d.Mcodigo
                    inner join Monedas m2
                         on m2.Ecodigo = d.EcodigoRef
                        and m2.Miso4217 = m.Miso4217
				where d.ECIid = #Arguments.ECIid#
				group by m2.Miso4217
				having
				sum(case when d.Dmovimiento = 'D' then d.Doriginal else 0 end) != sum(case when d.Dmovimiento = 'C' then d.Doriginal else 0 end)
			</cfquery>
			<cfif rsbalanceo.recordCount GT 0>
				<cf_errorCode	code = "51026" msg = "El monto en Moneda Origen no está balanceado para alguna de las Monedas o la Moneda NO esta definida en la Empresa destino!">
			</cfif>

			<cfquery name="rsbalanceo" datasource="#Arguments.Conexion#">
				select m2.Miso4217,
					   sum(case when d.Dmovimiento = 'D' then d.Dlocal else 0.00 end) as DEB,
					   sum(case when d.Dmovimiento = 'C' then d.Dlocal else 0.00 end) as CRE
				from DContablesImportacion d
					inner join Monedas m
						on m.Ecodigo = d.Ecodigo
						and m.Mcodigo = d.Mcodigo
                    inner join Monedas m2
                         on m2.Ecodigo = d.EcodigoRef
                        and m2.Miso4217 = m.Miso4217
				where d.ECIid = #Arguments.ECIid#
				group by m2.Miso4217
				having
				sum(case when d.Dmovimiento = 'D' then d.Dlocal else 0.00 end) != sum(case when d.Dmovimiento = 'C' then d.Dlocal else 0.00 end)
			</cfquery>
			<cfif rsbalanceo.recordCount GT 0>
				<cf_errorCode	code = "51027" msg = "El monto en Moneda Local no está balanceado para alguna de las monedas o la Moneda NO esta definida en la Empresa destino!">
			</cfif>

		<cfelse>

			<!--- NO INTERCOMPANY --->
			<!--- Validar que el documento contable esté balanceado tanto en moneda local como moneda origen --->
			<cfquery name="balanceo_origen" datasource="#Arguments.Conexion#">
				select d.Ocodigo, o.Odescripcion, d.Mcodigo, m.Miso4217,
					   sum(case when d.Dmovimiento = 'D' then d.Doriginal else 0 end) as DEB,
					   sum(case when d.Dmovimiento = 'C' then d.Doriginal else 0 end) as CRE
				from DContablesImportacion d
					inner join Monedas m
						on m.Ecodigo = d.Ecodigo
						and m.Mcodigo = d.Mcodigo
					inner join Oficinas o
						on o.Ecodigo = d.Ecodigo
						and o.Ocodigo = d.Ocodigo
				where d.ECIid = #Arguments.ECIid#
				group by d.Ocodigo, o.Odescripcion, d.Mcodigo, m.Miso4217
				having
				sum(case when d.Dmovimiento = 'D' then d.Doriginal else 0 end) != sum(case when d.Dmovimiento = 'C' then d.Doriginal else 0 end)
			</cfquery>
			<cfif balanceo_origen.recordCount GT 0>
				<cf_errorCode	code = "51028" msg = "El monto en moneda origen por oficina no está balanceado para alguna de las monedas">
			</cfif>

			<cfquery datasource="#Arguments.Conexion#">
				  update DContablesImportacion
					 set Dlocal = round(Dlocal,2)
				   where ECIid = #Arguments.ECIid#
			</cfquery>

			<cfquery name="rsbalanceo" datasource="#Arguments.Conexion#">
				select
						Ocodigo,
						Mcodigo,
						case when sum(case when d.Dmovimiento = 'D' then d.Dlocal else -d.Dlocal end)>=0 then 'C' else 'D' end as TipoMovimiento,
						abs(sum(case when d.Dmovimiento = 'D' then d.Dlocal else -d.Dlocal end)) as MontoLocal
				   from DContablesImportacion d
				  where d.ECIid = #Arguments.ECIid#
				  group by d.Ocodigo, d.Mcodigo
				 having abs(sum(case when d.Dmovimiento = 'D' then d.Dlocal else -d.Dlocal end)) between 0.001 and sum(0.005)
			</cfquery>

			<cfif rsbalanceo.recordcount GT 0>

				<!--- Incluye Ajuste por Balance de Monedas cuando la sum(DebitosLocal-CreditosLocal) sea >0 pero <=count(1)*0.005 --->
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					 select max(DCIconsecutivo) as ultimo
					   from DContablesImportacion
					  where ECIid = #Arguments.ECIid#
				</cfquery>
				<cfset LvarUltimo = rsSQL.ultimo>

				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					 select Ccuenta, CFcuenta, CFformato
					   from CFinanciera
					  where Ecodigo = #Session.Ecodigo#
						and Ccuenta =
							 (
									 select <cf_dbfunction name="to_number" args="Pvalor">
									   from Parametros
									  where Ecodigo = #rsEncabezado.Ecodigo#
										and Pcodigo = 200
							 )
					 order by CFcuenta
				</cfquery>

				<cfloop query="rsbalanceo">
					<cfquery datasource="#Arguments.Conexion#">
						 insert into DContablesImportacion (
								ECIid                          ,
								DCIconsecutivo                 ,
								Ecodigo                        ,
								DCIEfecha                      ,
								Eperiodo                       ,
								Emes                           ,
								Ddescripcion                   ,
								Ddocumento                     ,
								Dreferencia                    ,
								Dmovimiento                    ,
								Ccuenta                        ,
								CFcuenta                       ,
								CFformato                      ,
								Ocodigo                        ,
								Mcodigo                        ,
								Doriginal                      ,
								Dlocal                         ,
								Dtipocambio                    ,
								Cconcepto                      ,
								BMfalta                        ,
								BMUsucodigo
							 )
						values (
								#rsEncabezado.ECIid#,
								#LvarUltimo + rsbalanceo.CurrentRow#,
								#rsEncabezado.Ecodigo#,
								<cfqueryparam cfsqltype="cf_sql_date" value="#rsEncabezado.Efecha#">,
								#rsEncabezado.Eperiodo#,
								#rsEncabezado.Emes#,
								'Balance entre monedas',
								'#rsEncabezado.Edocbase#', '#rsEncabezado.Ereferencia#',
								'#rsbalanceo.TipoMovimiento#',
								#rsSQL.Ccuenta#,
								#rsSQL.CFcuenta#,
								'#rsSQL.CFformato#',
								#rsbalanceo.Ocodigo#,
								#rsbalanceo.Mcodigo#,
								0,
								#rsbalanceo.MontoLocal#,
								1,
								#rsEncabezado.Cconcepto#,
								<cf_dbfunction name="today">,
								#session.usucodigo#
							)
					</cfquery>
				</cfloop>
			</cfif>

			<cfquery name="balanceo_local" datasource="#Arguments.Conexion#">
				select d.Ocodigo, o.Odescripcion, d.Mcodigo, m.Miso4217,
					   sum(case when d.Dmovimiento = 'D' then d.Dlocal else 0 end) as DEB,
					   sum(case when d.Dmovimiento = 'C' then d.Dlocal else 0 end) as CRE
				from DContablesImportacion d
					inner join Monedas m
						on m.Ecodigo = d.Ecodigo
						and m.Mcodigo = d.Mcodigo
					inner join Oficinas o
						on o.Ecodigo = d.Ecodigo
						and o.Ocodigo = d.Ocodigo
				where d.ECIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ECIid#">
				group by d.Ocodigo, o.Odescripcion, d.Mcodigo, m.Miso4217
				having
				sum(case when d.Dmovimiento = 'D' then d.Dlocal else 0 end) != sum(case when d.Dmovimiento = 'C' then d.Dlocal else 0 end)
			</cfquery>
			<cfif balanceo_local.recordCount GT 0>
				<cf_errorCode	code = "51029" msg = "El monto en moneda local por oficina no está balanceado para alguna de las monedas">
			</cfif>
		</cfif>

		<!--- Verificar que los registros ya se hayan validado.  Si no están validados, hacer la validación --->
		<cfquery name="rsVerificaCuentasValidas" datasource="#Arguments.Conexion#">
			select count(1) as CantidadIncorrectas
			from DContablesImportacion
			where ECIid = #Arguments.ECIid#
			  and (Resultado <> 1 or CFcuenta is null or CFcuenta = 0 or Ccuenta is null or Ccuenta = 0)
		</cfquery>

		<cfif rsVerificaCuentasValidas.CantidadIncorrectas NEQ 0>

			<cfset LvarTabla = "DContablesImportacion">

			<!--- Obtener la fecha del asiento a verificar --->
			<cfquery name="rsObtieneFecha" datasource="#Arguments.Conexion#">
				select Efecha
				from EContablesImportacion
				where ECIid = #Arguments.ECIid#
			</cfquery>

			<cfif isdefined("rsObtieneFecha") and len(rsObtieneFecha.Efecha)>
				<cfset LvarFecha = rsObtieneFecha.Efecha>
			<cfelse>
				<cfset LvarFecha = createdate (year(now()), month(now()), day(now()))>
			</cfif>

			<cfset LvarVerificacionOK = CG_VerificaImportacionAsiento_local (Arguments.ECIid,  #session.Ecodigo#, Arguments.Conexion, LvarTabla, LvarFecha)>


			<cfif LvarVerificacionOK NEQ "OK">
				<cf_errorCode	code = "51030" msg = "No se han Validado las cuentas o Existen Cuentas NO Válidas. Por Favor Verifique las cuentas">
			</cfif>
		</cfif>

		<!---
			Verificar la cantidad de registros.
			Si son más de 200000 registros, se obliga a resumir.
		--->
		<cfquery name="rsVerificaCuentasValidas" datasource="#Arguments.Conexion#">
			select count(1) as Cantidad
			from DContablesImportacion
			where ECIid = #Arguments.ECIid#
		</cfquery>
		<cfif rsVerificaCuentasValidas.Cantidad GT 200000>
			<cfset Arguments.Resumir = true>
		</cfif>

		<cfif not Arguments.TransaccionActiva>
			<cftransaction>
				<cfset LvarResultado = fnAplicaImportacionAsiento(Arguments.ECIid, Arguments.Conexion, Arguments.Resumir)>
			</cftransaction>
		<cfelse>
			    <cfset LvarResultado = fnAplicaImportacionAsiento(Arguments.ECIid, Arguments.Conexion, Arguments.Resumir)>
		</cfif>


		<cfif isnumeric(LvarResultado) and LvarResultado GT 0>
			<!--- Invocacion de la interfaz de salida --->
			<cfquery name="rsEContablesInterfaz18" datasource="#Arguments.Conexion#">
				select ID
				from EContablesInterfaz18
				where ECIid = #Arguments.ECIid#
			</cfquery>

			<cfif isdefined("rsEContablesInterfaz18") and rsEContablesInterfaz18.ID gt 0>
				<cflog file="AplicaImportacionAsiento" text="Asiento: #Arguments.ECIid# Fecha: #now()# Afectando Bitacora Interfaz #rsEContablesInterfaz18.ID#">

				<cfset LvarID = rsEContablesInterfaz18.ID>

				<cflog file="AplicaImportacionAsiento" text="Asiento: #Arguments.ECIid# Fecha: #now()# ID Motor Interfaces: #LvarID#">
				<!--- Obtiene los datos del asiento generado para la interfaz --->
				<cfquery name="rsDatosAsientoGenerado" datasource="#Arguments.Conexion#">
					select
						e.Eperiodo as PeriodoAsiento,
						e.Emes as MesAsiento,
						e.Cconcepto as Concepto,
						e.Edocumento as Edocumento,
						e.ECusuario as Usuario,
						e.ECfechacreacion as FechaAplic,
						coalesce(( select sum(d.Dlocal) from DContables d where d.IDcontable = e.IDcontable and d.Dmovimiento = 'D' ), 0) as Debitos,
						coalesce(( select sum(d.Dlocal) from DContables d where d.IDcontable = e.IDcontable and d.Dmovimiento = 'C' ), 0) as Creditos,
						coalesce(( select count(1) from DContables d where d.IDcontable = e.IDcontable),0) as NumeroLineas
					from EContables e
					where e.IDcontable = #LvarResultado#
				</cfquery>

				<cfif len(trim(rsDatosAsientoGenerado.PeriodoAsiento)) GT 0>
					<cflog file="AplicaImportacionAsiento" text="Asiento: #Arguments.ECIid# Fecha: #now()# ID Motor Interfaces: #LvarID# Datos: Documento: #rsDatosAsientoGenerado.Concepto# - #rsDatosAsientoGenerado.Edocumento# : #rsDatosAsientoGenerado.NumeroLineas#">
					<cfquery datasource="sifinterfaces">
						Update ControlInterfaz18
						set	Eperiodo   = #rsDatosAsientoGenerado.PeriodoAsiento#,
							Emes       = #rsDatosAsientoGenerado.MesAsiento#,
							Cconcepto  = #rsDatosAsientoGenerado.Concepto#,
							Edocumento = #rsDatosAsientoGenerado.Edocumento#,
							Debitos    = #rsDatosAsientoGenerado.Debitos#,
							Creditos   = #rsDatosAsientoGenerado.Creditos#,
							NumLineas  = #rsDatosAsientoGenerado.NumeroLineas#,
							Usuario    = '#rsDatosAsientoGenerado.Usuario#',
							FechaApl   = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						  where ID = #LvarID#
					</cfquery>
					<cflog file="AplicaImportacionAsiento" text="Asiento: #Arguments.ECIid# Fecha: #now()# ID Motor Interfaces: #LvarID#  Afectado al Final del Proceso">
				</cfif>

				<!--- JMRV. Transferencia de Polizas entre Empresas. 17/12/2014. Inicio. --->
				<cfquery name="rsPolizaOrigen" datasource="sifinterfaces">
					select * from IE18 where ID = #LvarID#
				</cfquery>
				<cfif isDefined("rsPolizaOrigen.IDcontableOri") and #rsPolizaOrigen.IDcontableOri# neq "">
					<cfinvoke component="sif.cg.consultas.TransferenciaContaElectronica" method="TraeContaElectronica">
					 	<cfinvokeargument name="Conexion"  			value="#Session.DSN#"/>
						<cfinvokeargument name="IDcontable" 		value="#LvarResultado#"/>
						<cfinvokeargument name="Ecodigo" 				value="#session.Ecodigo#"/>
						<cfinvokeargument name="IDcontableOri" 	value="#rsPolizaOrigen.IDcontableOri#"/>
					</cfinvoke>
				</cfif>
				<!--- JMRV. Transferencia de Polizas entre Empresas. 17/12/2014. Fin. --->

			</cfif>
		</cfif>
	</cffunction>

	<!--- Aplica la importacion del asiento --->
	<cffunction name="fnAplicaImportacionAsiento" access="private" returntype="numeric">
		<cfargument name="ECIid" type="numeric" required="yes">
		<cfargument name="Conexion" type="string" required="yes">
		<cfargument name="Resumir" type="boolean" required="yes">

		<!--- LvarResultado devuelve el identity del asiento generado --->
		<cflog file="AplicaImportacionAsiento" text="Asiento: #Arguments.ECIid# Fecha: #now()# Enviado a Importar por #Session.Usucodigo#">

		<!--- se valida la referencia del encabezado --->
		<cfquery name="rsEncabezado" datasource="#Arguments.Conexion#">
			select ECIid, Ecodigo, Cconcepto, Eperiodo, Emes, Efecha, Edescripcion, Edocbase, Ereferencia, BMfalta, BMUsucodigo, ECIreversible, Oorigen
			from EContablesImportacion
			where ECIid = #Arguments.ECIid#
		</cfquery>

		<!--- El codigo CGFE (Contabilidad General Flujo de Efectivo ) en el encabezado indica que solo se modificara el presupuesto y no la contabilidad. --->
		<cfif rsEncabezado.Ereferencia eq 'CGFE'>
		    <cfset LvarResultado=cambiaPresupuesto(Arguments.ECIid, Arguments.Conexion, rsEncabezado.Ereferencia)>
		<cfelse>
			<cfset LvarResultado=importarRegistros(Arguments.ECIid, Arguments.Conexion, Arguments.Resumir)>
		</cfif>

		<cfif LvarResultado GT 0>
			<cflog file="AplicaImportacionAsiento" text="Asiento: #Arguments.ECIid# Fecha: #now()# Terminado.  Asiento: #LvarResultado#">
			<cftransaction action="commit" />
		<cfelse>
			<cflog file="AplicaImportacionAsiento" text="Asiento: #Arguments.ECIid# Fecha: #now()# No Insertado">
			<cftransaction action="rollback" />
		</cfif>

		<cfreturn LvarResultado>
	</cffunction>

<!--- FUNCION PARA MODIFICAR EL PRESUPUESTO --------------------------------------------------------------------------------------------------->
<cffunction name="cambiaPresupuesto" access="private" output="no" returntype="numeric">
		<cfargument name="ECIid" type="numeric" required="yes">
		<cfargument name="Conexion" type="string" required="yes">
		<cfargument name="OrigenC" type="string" required="yes">

<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
<cfset LobjControl.CreaTablaIntPresupuesto(#Conexion#,true)>

<!--- Obtenemos valores del detalle de la importacion --->
<cfquery name="DetalleImp" datasource="#Conexion#">
	select Eperiodo,Emes  from DContablesImportacion
	where ECIid=#ECIid#
	group by Eperiodo,Emes
</cfquery>

<!--- Cuentas presupuestales --->
<cfquery name="CuentasP" datasource="#Conexion#">
	select b.CPcuenta,a.Doriginal,a.Dlocal,CPCCmascara,CPCPtipoControl,CPCPcalculoControl,Dmovimiento
	from DContablesImportacion a
		 inner join CFinanciera b
		 	on a.CFcuenta = b.CFcuenta
		 inner join CPresupuesto cp
		 	on b.CPcuenta = cp.CPcuenta
		 inner join CPresupuestoComprAut cpa
		 	on cpa.CPcuenta = cp.CPcuenta
		 left JOIN CPCuentaPeriodo cpp
            on cpp.Ecodigo = cpa.Ecodigo
			and cpp.CPPid = cpa.CPPid
			and cpp.CPcuenta = cpa.CPcuenta
	  	where a.Ecodigo = #session.Ecodigo#
	 	and ECIid =#ECIid#
</cfquery>

<cfloop query ="CuentasP" >

<!--- Se obtiene el numero de Documento --->
<cfquery name="rsSQLNAP" datasource="#Conexion#">
    select count(*) as ultimo
      from CPNAP
     where Ecodigo 				= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
       and EcodigoOri		 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
       and CPNAPmoduloOri 		= 'CGFE'
       and left(CPNAPdocumentoOri,2)	= 'EJ'
</cfquery>

<cfif rsSQLNAP.ultimo EQ "">
	<cfset NoDoc=1>
<cfelse>
	<cfset NoDoc=rsSQLNAP.ultimo + 1>
</cfif>
<cfset LvarDocumentoAprobo = "EJ-"&#NoDoc#>
<cfset LvarDocumentoAprobo2 = "P-"&#NoDoc#>

<!--- Parametro año y mes --->
<cfset vs_aniomesLinea = #DetalleImp.Eperiodo# * 100 + #DetalleImp.Emes#>
<!--- tipo de moneda --->
<cfquery name="qry_monedaEmpresa" datasource="#Conexion#">
    select Mcodigo
      from Empresas
     where Ecodigo = #session.Ecodigo#
</cfquery>

<!--- Se obtiene el valor de CPPid --->
<cfquery name="CodigoPPid" datasource="#Conexion#">
	select top 1 CPPid from CPresupuestoPeriodo
	where #vs_aniomesLinea# between CPPanoMesDesde and CPPanoMesHasta
</cfquery>

<!--- Valores de la oficina --->
<cfquery name="rsOficina" datasource="#Conexion#">
    select Ocodigo,Odescripcion,Oficodigo from Oficinas a
    where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>


<cfquery name="rsInsertintPresupuesto" datasource="#Conexion#">
	                            insert into #request.intPresupuesto#
	                                (
	                                    ModuloOrigen,
	                                    DocumentoPagado,
	                                    NumeroDocumento,
	                                    NumeroReferencia,
	                                    FechaDocumento,
	                                    AnoDocumento,
	                                    MesDocumento,
										NumeroLinea,
	                                    CPPid,
	                                    CPCano, CPCmes, CPCanoMes,
	                                    CPcuenta, Ocodigo,
	                                    CuentaPresupuesto, CodigoOficina,
	                                    TipoControl, CalculoControl, SignoMovimiento,
	                                    TipoMovimiento,
	                                    Mcodigo, TipoCambio,
	                                    MontoOrigen, Monto, NAPreferencia,LINreferencia
	                                )
	                            values ('#OrigenC#',
	                            		'#OrigenC# #DetalleImp.Eperiodo#',
										'#LvarDocumentoAprobo#',
										'IMPORTACION',
	                                    <cf_dbfunction name="now">,
	                                    <cfqueryparam  cfsqltype="cf_sql_numeric" value="#DetalleImp.Eperiodo#">,
	                                    <cfqueryparam  cfsqltype="cf_sql_numeric" value="#DetalleImp.Emes#">,
										abs(coalesce((select max(NumeroLinea) from #request.intPresupuesto#),0)+1),
	                                    <cfqueryparam  cfsqltype="cf_sql_numeric" value="#CodigoPPid.CPPid#">,
	                                    #DetalleImp.Eperiodo#, #DetalleImp.Emes#, #vs_aniomesLinea#,
	                                    <cfqueryparam  cfsqltype="cf_sql_numeric" value="#CuentasP.CPcuenta#">,
	                                    <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsOficina.Ocodigo#">,
	                                    '#CuentasP.CPCCmascara#', '#rsOficina.Oficodigo#',
	                                    #CuentasP.CPCPtipoControl#, #CuentasP.CPCPcalculoControl#,
	                                    <cfif #CuentasP.Dmovimiento# eq 'D'>+1<cfelseif #CuentasP.Dmovimiento# eq 'C'>-1</cfif>,
	                                    'EJ',
	                                    #qry_monedaEmpresa.Mcodigo#,
	                                    1,
	                                    #CuentasP.Doriginal#, #CuentasP.Dlocal#,
										NULL,NULL
	                                    )
	                        </cfquery>

<!--- Ejecucion con funcion pagada --->

<cfquery name="rsInsertintPresupuesto" datasource="#Conexion#">
	                            insert into #request.intPresupuesto#
	                                (
	                                    ModuloOrigen,
	                                    DocumentoPagado,
	                                    NumeroDocumento,
	                                    NumeroReferencia,
	                                    FechaDocumento,
	                                    AnoDocumento,
	                                    MesDocumento,
										NumeroLinea,
	                                    CPPid,
	                                    CPCano, CPCmes, CPCanoMes,
	                                    CPcuenta, Ocodigo,
	                                    CuentaPresupuesto, CodigoOficina,
	                                    TipoControl, CalculoControl, SignoMovimiento,
	                                    TipoMovimiento,
	                                    Mcodigo, TipoCambio,
	                                    MontoOrigen, Monto, NAPreferencia,LINreferencia
	                                )
	                            values ('#OrigenC#',
	                            		'#OrigenC# #DetalleImp.Eperiodo#',
										'#LvarDocumentoAprobo2#',
										'IMPORTACION',
	                                    <cf_dbfunction name="now">,
	                                    <cfqueryparam  cfsqltype="cf_sql_numeric" value="#DetalleImp.Eperiodo#">,
	                                    <cfqueryparam  cfsqltype="cf_sql_numeric" value="#DetalleImp.Emes#">,
										abs(coalesce((select max(NumeroLinea) from #request.intPresupuesto#),0)+1),
	                                    <cfqueryparam  cfsqltype="cf_sql_numeric" value="#CodigoPPid.CPPid#">,
	                                    #DetalleImp.Eperiodo#, #DetalleImp.Emes#, #vs_aniomesLinea#,
	                                    <cfqueryparam  cfsqltype="cf_sql_numeric" value="#CuentasP.CPcuenta#">,
	                                    <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsOficina.Ocodigo#">,
	                                    '#CuentasP.CPCCmascara#', '#rsOficina.Oficodigo#',
	                                    #CuentasP.CPCPtipoControl#, #CuentasP.CPCPcalculoControl#,
	                                    <cfif #CuentasP.Dmovimiento# eq 'D'>+1<cfelseif #CuentasP.Dmovimiento# eq 'C'>-1</cfif>,
	                                    'P',
	                                    #qry_monedaEmpresa.Mcodigo#,
	                                    1,
	                                    #CuentasP.Doriginal#, #CuentasP.Dlocal#,
										NULL,NULL
	                                    )
	                        </cfquery>

</cfloop>

<!--- Ejecucion de la funcion --->
	<cfquery name="rs_regporCompr" datasource="#Conexion#">
			select top 1 * from #request.intPresupuesto#
	</cfquery>
	<!--- <cf_dump var = "#rs_regporCompr#"> --->
    <cfif rs_regporCompr.recordCount NEQ 0>
    	<cfset LvarNAP = LobjControl.ControlPresupuestario("CGFE", NoDoc, "IMPORTACION", now(), #DetalleImp.Eperiodo#, #DetalleImp.Emes#) />
     <cfelse>
    	<cfset LvarNAP = -1 />
    </cfif>


<!--- Eliminar Registros en tablas de importacion --->
		<cfquery name="rsDelContables" datasource="#Arguments.Conexion#">
			delete from DContablesImportacion
			where ECIid = #Arguments.ECIid#
		</cfquery>

		<cfquery name="rsDelContables" datasource="#Arguments.Conexion#">
			delete from EContablesImportacion
			where ECIid = #Arguments.ECIid#
		</cfquery>

<cfreturn 1>
</cffunction>
<!--- **************************************************************************** --->


	<cffunction name="importarRegistros" access="private" output="no" returntype="numeric" hint="Regresa el número del Asiento Contable generado ( IDcontable )">
		<cfargument name="ECIid" type="numeric" required="yes">
		<cfargument name="Conexion" type="string" required="yes">
		<cfargument name="Resumir" type="boolean" required="yes">

		<cfset LvarIDContableGenerado = -2>
	    <cf_dbfunction name="OP_concat" returnvariable="_Cat">

		<!--- Update para que se bloquee el proceso del asiento para que no se pueda procesar dos veces! --->
		<cfquery datasource="#Arguments.Conexion#">
			update EContablesImportacion
			set BMUsucodigo = #Session.Usucodigo#
			where ECIid = #Arguments.ECIid#
		</cfquery>

		<cfquery name="rsEncabezado" datasource="#Arguments.Conexion#">
			select ECIid, Ecodigo, Cconcepto, Eperiodo, Emes, Efecha, Edescripcion, Edocbase, Ereferencia, BMfalta, BMUsucodigo, ECIreversible, Oorigen
			from EContablesImportacion
			where ECIid = #Arguments.ECIid#
		</cfquery>

		<cfif rsEncabezado.recordcount EQ 0>
			<!--- Ya se había aplicado, se regresa la funcion --->
			<cfreturn -2>
		</cfif>
        <cfquery name="rsNA1" datasource="#Arguments.Conexion#">
            select Cconcepto
             from ConceptoContable
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
              and Oorigen = <cfqueryparam cfsqltype="cf_sql_char" value="#rsEncabezado.Oorigen#">
        </cfquery>
        <cfif rsNA1.RecordCount>
            <cfset LvarCconcepto = rsNA1.Cconcepto>
        <cfelse>
       		<cfset LvarCconcepto = rsEncabezado.Cconcepto>
        </cfif>

		<cfinvoke component="sif.Componentes.Contabilidad" method="Nuevo_Asiento" returnvariable="Nuevo_AsientoRet">
		 	<cfinvokeargument name="Cconcepto"  value="#LvarCconcepto#"/>
			<cfinvokeargument name="Oorigen" 	value="#rsEncabezado.Oorigen#"/>
			<cfinvokeargument name="Eperiodo" 	value="#rsEncabezado.Eperiodo#"/>
			<cfinvokeargument name="Emes" 		value="#rsEncabezado.Emes#"/>
			<cfinvokeargument name="Edocumento" value="0"/>
		</cfinvoke>

		<cfset LvarECtipo = 0>   <!--- Asiento Normal --->
		<cfif Intercompany>
			<cfset LvarECtipo = 20>  <!--- Asiento Intercompany --->
		</cfif>

		<cfif LvarPeriodoAsiento LT LvarPeriodoActual>
			<cfif Intercompany>
				<cfset LvarECtipo = 21>  <!--- Retroactivo Intercompany --->
			<cfelse>
				<cfset LvarECtipo = 2>   <!--- Retroactivo Normal --->
			</cfif>
		</cfif>

		<cfquery name="rsEContables" datasource="#Arguments.Conexion#">
       		select IDcontable
            	from EContables
             where Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Session.Ecodigo#">
               and Cconcepto  = <cfqueryparam cfsqltype="cf_sql_integer"	value="#LvarCconcepto#">
               and Eperiodo   = <cfqueryparam cfsqltype="cf_sql_smallint" 	value="#rsEncabezado.Eperiodo#">
               and Emes       = <cfqueryparam cfsqltype="cf_sql_smallint" 	value="#rsEncabezado.Emes#">
               and Edocumento = #Nuevo_AsientoRet#
       </cfquery>
       <cfif rsEContables.RecordCount>
       		<cfset LvarIDContableGenerado = rsEContables.IDcontable>
       <cfelse>
			<!--- Agregar encabezado del documento contable --->
            <cfquery name="rsEContables" datasource="#Arguments.Conexion#">
                insert into EContables (
                        Ecodigo, Cconcepto, Eperiodo, Emes, Edocumento,
                        Efecha, Edescripcion, Edocbase, Ereferencia, ECauxiliar,
                        ECusuario, ECusucodigo, ECfechacreacion, ECipcrea, ECestado, BMUsucodigo, ECtipo, ECreversible, Oorigen)
                values (
                    <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Session.Ecodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_integer"	value="#LvarCconcepto#">,
                    <cfqueryparam cfsqltype="cf_sql_smallint" 	value="#rsEncabezado.Eperiodo#">,
                    <cfqueryparam cfsqltype="cf_sql_smallint" 	value="#rsEncabezado.Emes#">,
                    #Nuevo_AsientoRet#,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#rsEncabezado.Efecha#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEncabezado.Edescripcion#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEncabezado.Edocbase#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEncabezado.Ereferencia#">,
                    <cfqueryparam cfsqltype="cf_sql_char" value="S">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.usuario#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.sitio.ip#">,
                    0,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarECtipo#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEncabezado.ECIreversible#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEncabezado.Oorigen#">
                )
                <cf_dbidentity1 datasource="#Arguments.Conexion#" verificar_transaccion="false">
            </cfquery>
            	<cf_dbidentity2 datasource="#Arguments.Conexion#" name="rsEContables" verificar_transaccion="false">

            	<cfset LvarIDContableGenerado = rsEContables.identity>
			<!--- ********************************************************** --->
			<!---       Inserta ID contable en el Repositorio CERepoTEMP     --->
			<!--- ********************************************************** --->
	<!--- 		<cftry> --->
        
				<!----- Obtener al menos un uuid de los detalles, para el caso de importacion ----->
				<cfquery name="rsUUIDDet" datasource="#Arguments.Conexion#">
				  select ECIid,uuid
					from DContablesImportacion
					where ECIid = #Arguments.ECIid# and 
					uuid is not null and datalength(uuid) > 0
				</cfquery>
				<cfset arrayUUID = false>
				<cfif isdefined('rsUUIDDet') and  rsUUIDDet.RecordCount GT 1 > 
        			<cfset arrayUUID = true>
        		</cfif>
				<cfinvoke component="sif.ce.Componentes.RepositorioCFDIs"  method="RepositorioCFDIs" >
					<cfinvokeargument name="idDocumento" 	 value="#rsEncabezado.ECIid#">
					<cfinvokeargument name="idContable" 	 value="#rsEContables.identity#">
					<cfinvokeargument name="Origen" 		 value="LDIV">
					<cfinvokeargument name="idLineaP"        Value="1">
					<cfinvokeargument name="MultiCFDIxLinea" Value=true>
					<cfinvokeargument name="uuidArray" Value="#arrayUUID#">
					<cfinvokeargument name="ECIid" Value="#Arguments.ECIid#">
				</cfinvoke>
<!--- 			<cfcatch>
			</cfcatch>
			</cftry> --->
		</cfif>

	<!--- Control Evento Inicia --->

	<cfset varOorigen    = #rsEncabezado.Oorigen#>
    <cfset varDocumento  = #rsEncabezado.Edocbase#>
    <cfif len(trim(rsEncabezado.Ereferencia))>
    	<cfif varOorigen EQ "TEPN">
        	<cfset varNOMtran = "CN">
            <cfset varNOMtranRef = "NM">
        <cfelse>
        	<cfset varNOMtran = left(rsEncabezado.Ereferencia,20)>
            <cfset varNOMtranRef = "">
        </cfif>
	<cfelse>
    	<cfif varOorigen EQ "TEPN">
        	<cfset varNOMtran = "NM">
            <cfset varNOMtranRef = "">
        <cfelse>
        	<cfset varNOMtran = "">
            <cfset varNOMtranRef = "">
        </cfif>
    </cfif>
    <cfif len(trim(varOorigen)) GT 0 and varOorigen NEQ "">
		<!--- Valido el evento --->
        <cfinvoke
            component		= "sif.Componentes.CG_ControlEvento"
            method			= "ValidaEvento"
            Origen			= "#varOorigen#"
            Transaccion		= "#varNOMtran#"
            Conexion		= "#Arguments.Conexion#"
            Ecodigo			= "#Session.Ecodigo#"
            returnvariable	= "varValidaEvento"
        />
    <cfelse>
    	<cfset varValidaEvento = 0>
	</cfif>

	<cfset varNumeroEvento=''>
	<cfif varValidaEvento GT 0>
        <cfinvoke
            component		= "sif.Componentes.CG_ControlEvento"
            method			= "CG_GeneraEvento"
            Origen			= "#varOorigen#"
            Transaccion		= "#varNOMtran#"
            Documento 		= "#varDocumento#"
            Conexion		= "#Arguments.Conexion#"
            Ecodigo			= "#Session.Ecodigo#"
            returnvariable	= "arNumeroEvento"
            />
        <cfif arNumeroEvento[3] EQ "">
            <cfthrow message="ERROR CONTROL EVENTO: No se obtuvo un control de evento valido para la operación">
        </cfif>
        <cfset varNumeroEvento = arNumeroEvento[3]>
        <cfset varIDEvento     = arNumeroEvento[4]>

		<cfif len(trim(rsEncabezado.Ereferencia)) and varOorigen EQ "TEPN">
            <cfinvoke
                component		= "sif.Componentes.CG_ControlEvento"
                method			= "CG_RelacionaEvento"
                IDNEvento       = "#varIDEvento#"
                Ecodigo			= "#Session.Ecodigo#"
                Origen			= "#varOorigen#"
                Transaccion		= "#varNOMtranRef#"
                Documento 		= "#rsEncabezado.Ereferencia#"
                Conexion		= "#Arguments.Conexion#"
                returnvariable	= "arRelacionEvento"
                />

			<cfif isdefined("arRelacionEvento") and arRelacionEvento[1]>
                <cfset varNumeroEvento = arRelacionEvento[4]>
            </cfif>
        </cfif>
    </cfif>

	<!--- Control Evento Fin  --->

		<cfif Arguments.Resumir>
			<cfquery name="rsDContablesRes" datasource="#Arguments.Conexion#">
				select
					Ocodigo,
					Dmovimiento,
					Ccuenta,
					CFcuenta,
					Mcodigo,
					sum(round(Doriginal, 2)) as Doriginal,
					sum(round(Dlocal, 2)) as Dlocal,
					avg(Dtipocambio) as Dtipocambio,
                    CFid
				from DContablesImportacion
				where ECIid = #Arguments.ECIid#
				group by Ocodigo, Dmovimiento, Ccuenta, CFcuenta, Mcodigo, CFid
				order by Ocodigo, Dmovimiento, Ccuenta, CFcuenta, Mcodigo, CFid
			</cfquery>
			<cfloop query="rsDContablesRes">

				<!--- Agregar detalles del documento contable --->
				<cfquery datasource="#Arguments.Conexion#">
					insert into DContables (IDcontable, Dlinea, Ecodigo, Cconcepto, Eperiodo, Emes, Edocumento, Ocodigo, Ddescripcion, Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Doriginal, Dlocal, Mcodigo, Dtipocambio, BMUsucodigo, CFid, NumeroEvento)
					values(
						#LvarIDContableGenerado#,
						#rsDContablesRes.currentrow#,
						#Session.Ecodigo#,
						#rsEncabezado.Cconcepto#,
						#rsEncabezado.Eperiodo#,
						#rsEncabezado.Emes#,
						#Nuevo_AsientoRet#,
						#rsDContablesRes.Ocodigo#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEncabezado.Edescripcion#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEncabezado.Edocbase#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEncabezado.Ereferencia#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#rsDContablesRes.Dmovimiento#">,
						#rsDContablesRes.Ccuenta#,
						#rsDContablesRes.CFcuenta#,
						#rsDContablesRes.Doriginal#,
						#rsDContablesRes.Dlocal#,
						#rsDContablesRes.Mcodigo#,
						#rsDContablesRes.Dtipocambio#,
						#Session.Usucodigo#,
                        #rsDContablesRes.CFid#,
                        <cfqueryparam cfsqltype="cf_sql_char" value="#varNumeroEvento#">
                      )
				</cfquery>
			</cfloop>
		<cfelse>
			<!--- Agregar detalles del documento contable --->
			<cfquery name="rsDContables" datasource="#Arguments.Conexion#">
				insert into DContables (IDcontable, Dlinea, Ecodigo, Cconcepto, Eperiodo, Emes, Edocumento, Ocodigo, Ddescripcion, Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Doriginal, Dlocal, Mcodigo, Dtipocambio, BMUsucodigo, CFid, NumeroEvento)
				select
					#LvarIDContableGenerado#,
					Coalesce((select max(Dlinea)
                                from DContables
                                where Ecodigo    = di.Ecodigo
                                  and Cconcepto  = #LvarCconcepto#
                                  and Eperiodo   = #rsEncabezado.Eperiodo#
                                  and Emes 		 = #rsEncabezado.Emes#
                                  and Edocumento = #Nuevo_AsientoRet#
                      		  ),0) + di.DCIconsecutivo,
					di.Ecodigo,
					#LvarCconcepto#,
					#rsEncabezado.Eperiodo#,
					#rsEncabezado.Emes#,
					#Nuevo_AsientoRet#,
					di.Ocodigo,
					di.Ddescripcion,
					di.Ddocumento,
					di.Dreferencia,
					di.Dmovimiento,
					di.Ccuenta,
					di.CFcuenta,
					round(di.Doriginal,2),
					round(di.Dlocal,2),
					di.Mcodigo,
					di.Dtipocambio,
					#Session.Usucodigo#,
                    di.CFid,
                    <cfqueryparam cfsqltype="cf_sql_char" value="#varNumeroEvento#">
				from DContablesImportacion di
				where di.ECIid = #Arguments.ECIid#
			</cfquery>
		</cfif>


		<!--- Se procesan cuentas de Activos Fijos y se insertan o actualizan datos en sistema de Gestion de Activos, tabla GATransacciones --->
		<!--- Actualiza Concepto y Documento para las cuentas con Referencia --->
		<cfquery datasource="#Arguments.Conexion#">
			update GATransacciones
			set Cconcepto  	  	= #rsEncabezado.Cconcepto#,
				Edocumento    	= #Nuevo_AsientoRet#,
				IDcontable      = #LvarIDContableGenerado#
			where exists(
				select 1
				from DContablesImportacion
				where DContablesImportacion.ECIid = #Arguments.ECIid#
				  and DContablesImportacion.Referencia1 = GATransacciones.Referencia1
				  and DContablesImportacion.Referencia2 = GATransacciones.Referencia2
				  and DContablesImportacion.Referencia3 = GATransacciones.Referencia3
				  and DContablesImportacion.Ecodigo     = GATransacciones.Ecodigo
				  and DContablesImportacion.Eperiodo    = GATransacciones.GATperiodo
				  and DContablesImportacion.Emes        = GATransacciones.GATmes
				  )

		</cfquery>

		<cfquery name="ExistenReg" datasource="#Arguments.Conexion#">
			select count(1) as TransaccionesGAT
			from GATransacciones
			where IDcontable = #LvarIDContableGenerado#
			  and Ecodigo = #Session.Ecodigo#
			  and Cconcepto = #rsEncabezado.Cconcepto#
			  and GATperiodo = #rsEncabezado.Eperiodo#
			  and GATmes = #rsEncabezado.Emes#
			  and Edocumento = #Nuevo_AsientoRet#
		</cfquery>

		<cfif ExistenReg.TransaccionesGAT EQ 0>
				<cfquery datasource="#Arguments.Conexion#">
						insert into GATransacciones (
								Ecodigo, 			Cconcepto, 				GATperiodo, 		GATmes,			GATmonto,
								Edocumento,
								GATfecha,
								GATdescripcion,		Ocodigo,
								fechaalta,
								BMUsucodigo,
								Referencia1, 		Referencia2, 			Referencia3,
								CFcuenta, 			GATestado, 				IDcontable, 		CFid
						)
						select 	a.Ecodigo, 		a.Cconcepto,				a.Eperiodo, 		a.Emes,
								round(a.Dlocal * case when a.Dmovimiento = 'D' then 1.00 else -1.00 end,2),
								#Nuevo_AsientoRet#,
								<cf_jdbcquery_param cfsqltype="cf_sql_date" value="#rsEncabezado.Efecha#">,
								a.Ddescripcion, 			a.Ocodigo,
								<cf_dbfunction name="now">,
								#Session.Usucodigo#,
								a.Referencia1, 		a.Referencia2, 			a.Referencia3,
								a.CFcuenta,			0,
								#LvarIDContableGenerado#,
                                a.CFid
						from DContablesImportacion a
							inner join CFinanciera b
							   on b.CFcuenta = a.CFcuenta
						where a.ECIid = #Arguments.ECIid#
						and exists(
							select 1
							from GACMayor c
								where c.Ecodigo = b.Ecodigo
								and c.Cmayor  = b.Cmayor
								and <cf_dbfunction name="like" args="b.CFformato ; c.Cmascara #_Cat# '%'" delimiters=";">
						)
				</cfquery>
		</cfif>

		<!--- Eliminar Registros en tablas de importacion --->
		<cfquery name="rsDelContables" datasource="#Arguments.Conexion#">
			delete from DContablesImportacion
			where ECIid = #Arguments.ECIid#
		</cfquery>

		<cfquery name="rsDelContables" datasource="#Arguments.Conexion#">
			delete from EContablesImportacion
			where ECIid = #Arguments.ECIid#
		</cfquery>


		<!--- Invocacion de la interfaz de salida --->
		<!--- Se hace la verificacion en la tabla de interfaz para ver si es necesario hacer el Invoke --->
		<cfquery name="rsVerificacion" datasource="#Arguments.Conexion#">
			Select count(1) as cantidad
			from EContablesInterfaz18 A
			Where A.ECIid = #Arguments.ECIid#
		</cfquery>

		<cfif rsVerificacion.cantidad gt 0>
			<cfquery datasource="#Arguments.Conexion#">
					Update EContablesInterfaz18
					set IDcontable		= #LvarIDContableGenerado#,
						PeriodoAsiento	= #rsEncabezado.Eperiodo#,
						MesAsiento		= #rsEncabezado.Emes#,
						Concepto		= #rsEncabezado.Cconcepto#,
						Edocumento		= #Nuevo_AsientoRet#,
						UsrAplico		= #session.Usucodigo#,
						FechaApl 		= #Now()#,
						FechaAsiento	= <cfqueryparam cfsqltype="cf_sql_date" value="#rsEncabezado.Efecha#">,
						ASTBorrado 		= 0
					Where ECIid			= #Arguments.ECIid#
			</cfquery>
		</cfif>
		<cfreturn LvarIDContableGenerado>
	</cffunction>
</cfcomponent>


