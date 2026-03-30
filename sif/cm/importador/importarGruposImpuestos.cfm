<!---
	Importador Grupos de impuestos
	Este archivo asume la existencia de la tabla temporal #table_name# "Datos de Entrada"
 --->

<!---mcz--->
<!---======== Tabla temporal de errores  ========--->
<cf_dbtemp name="errores" returnvariable="errores" datasource="#session.DSN#">
	<cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp> 

<cfquery name="rsGrupos" datasource="#session.dsn#">
	select * from #table_name#
</cfquery>

<!--- Validacion del la existencia del codigo --->
	<cfquery name="rsCheck2" datasource="#session.dsn#">
		select 1 as check2
		from #table_name# a			
		where Icodigo is null
	</cfquery>
	<cfif rsCheck2.check2 gt 0>	
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error!El codigo del impuesto no puede ir nulo!')
		</cfquery>
	</cfif>
	<cfif len(trim(rsGrupos.DIdescripcion)) eq 0>
	<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error!Para crear un nuevo grupo la descripción no puede estar vacía!')
		</cfquery>
	</cfif>

	
<cfloop query="rsGrupos">
	<!--- Validacion de la cuenta  --->
		<cfquery name="rsCheck2" datasource="#session.dsn#">
			select 1 as check2,DIformato
			from #table_name# a
			where not exists(
								select 1
								from CFinanciera c
								where a.DIformato = ltrim(rtrim(c.CFformato)
							)
			and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
			and a.Icodigo='#rsGrupos.Icodigo#'
		</cfquery>	
		<cfif rsCheck2.check2 gt 0>			
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error!El formato de la cuenta es invalido(#rsCheck2.DIformato#)!')
			</cfquery>
		</cfif>
	<!--- Validacion del codigo de impuesto///ESTO EVITA QUE SE INSERTEN ENCABEZADOS DE IMPUESTOS
	SI SE COMENTA SE PUENDEN INSERTAR ESTO ULTIMOS/// --->
		<cfquery name="rsCheck2" datasource="#session.dsn#">
			select 1 as check2,Icodigo
			from #table_name# a
			where not exists(
								select 1
								from Impuestos d
								where a.Icodigo = ltrim(rtrim(d.Icodigo))
								and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and a.Icodigo='#rsGrupos.Icodigo#'
							)
			and a.Icodigo='#rsGrupos.Icodigo#'
		</cfquery>
		<cfif rsCheck2.check2 gt 0>	
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error!El codigo del impuesto no existe en el sistema(#rsCheck2.Icodigo#)!')
			</cfquery>
		</cfif>
</cfloop>


<!---  --->
<cfquery name="rsERR" datasource="#session.dsn#">
	select count(1) as cantidad from #errores#
</cfquery>

<cfif rsERR.cantidad eq 0>
	<cftransaction>
		<cfoutput query="rsGrupos" group="Icodigo">
		<!---Validar que no exista ya el codigo de impuesto (padre)--->
			<cfquery name="existeImpuesto" datasource="#session.DSN#"> 
				select Iporcentaje
				from Impuestos
				where Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsGrupos.Icodigo#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>

		<!--- Traer el Ccuenta de la cuenta contable al que pertence el DIformato ingresado --->
			<cfquery name="rsCuentaC" datasource="#session.dsn#">
				select Ccuenta
				from CFinanciera
				where CFformato = <cfqueryparam cfsqltype="cf_sql_char" value="#rsGrupos.DIformato#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
		<!---No 1. Si no existe ya ese codigo de impuesto---->	
			<cfif existeImpuesto.RecordCount EQ 0>			
				<!---Para c/grupo insertar el encabezado tabla Impuestos----->				
				<cfquery name="rsImpuesto" datasource="#session.DSN#">
					insert into Impuestos
					 (Ecodigo,Icodigo,Idescripcion,Iporcentaje,Ccuenta,Icompuesto,Icreditofiscal,Usucodigo,Ifecha,BMUsucodigo)
					values (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#rsGrupos.Icodigo#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#rsGrupos.DIdescripcion#">,
							0,
							<cfif isdefined("rsCuentaC") and rsCuentaC.RecordCount gt 0 and len(trim(rsCuentaC.Ccuenta))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaC.Ccuenta#"><cfelse>null</cfif>,
							1,
							<cfqueryparam cfsqltype="cf_sql_integer" value="0">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 				
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> 
							)
				</cfquery>				
				<cfset vn_totalPorcentajes = 0> <!----Actualizar la varible con la sumatoria de los porcentajes ----->
			<cfelse>
				<cfset vn_totalPorcentajes = existeImpuesto.Iporcentaje> <!----Actualizar la varible con la sumatoria de los porcentajes ----->
			</cfif> <!---Fin del if No.1--->

			<!----Insertar el detalle del encabezado---->
			<cfoutput>
		
				<!---Validar que no exista ya esa cambinacion de grupo de impuestos---->
				<cfquery name="rsValida" datasource="#session.DSN#">
					select DIporcentaje
					from DImpuestos 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsGrupos.Icodigo#">
						and DIcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsGrupos.Dicodigo#">
				</cfquery>

				<cfif rsValida.RecordCount EQ 0> <!---No2.Si no existe ya esa combinacion ---->
					
					<!----Traer la descripcion del impuesto componente---->
					<cfquery name="rsDescImpuesto" datasource="#session.dsn#">
						select Idescripcion  
						from Impuestos
						where Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsGrupos.Icodigo#">
							and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					</cfquery>

					<cfif rsDescImpuesto.RecordCount gt 0> <!---No3.Si hay datos correspondientes--->
					
						<!----Inserta en la tabla de Grupos de Impuestos (DImpuestos)----->							
						<cfquery datasource="#session.dsn#">
							insert into DImpuestos
							(Ecodigo,Icodigo,DIcodigo,DIporcentaje,DIdescripcion,DIcreditofiscal,Ccuenta,Usucodigo,DIfecha,BMUsucodigo)
							values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
									<cfqueryparam cfsqltype="cf_sql_char" value="#rsGrupos.Icodigo#">, 
									<cfqueryparam cfsqltype="cf_sql_char" value="#rsGrupos.Dicodigo#">, 
									<cfqueryparam cfsqltype="cf_sql_float" value="#rsGrupos.Diporcentaje#">,
									<cfqueryparam cfsqltype="cf_sql_char" value="#rsDescImpuesto.Idescripcion#">, 
									<cfqueryparam cfsqltype="cf_sql_integer" value="#rsGrupos.Dicreditofiscal#">, 
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaC.Ccuenta#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 				
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
								  )
						</cfquery>

						<cfset vn_totalPorcentajes = vn_totalPorcentajes + rsGrupos.Diporcentaje>
					<cfelse>
						<cf_errorCode	code = "50280"
										msg  = "El código @errorDat_1@ no existe"
										errorDat_1="#rsGrupos.Dicodigo#"
						>
					</cfif> <!---- Fin No3.	---->
				<cfelse>
					<cfquery datasource="#session.dsn#">
						update DImpuestos
						set DIporcentaje = <cfqueryparam cfsqltype="cf_sql_float" value="#rsGrupos.Diporcentaje#">,
							<cfif isdefined("rsCuentaC") and rsCuentaC.RecordCount gt 0 and len(trim(rsCuentaC.Ccuenta))>
								Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaC.Ccuenta#">,
							<cfelse>
								Ccuenta = null,
							</cfif>
							DIcreditofiscal = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsGrupos.Dicreditofiscal#">
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsGrupos.Icodigo#">
							and DIcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsGrupos.Dicodigo#">
					</cfquery>

					<cfset vn_totalPorcentajes = vn_totalPorcentajes - rsValida.DIporcentaje + rsGrupos.Diporcentaje>
				</cfif>	<!---Fin No2. ---->
			</cfoutput>
			<cftry>
			<cfquery name="rsActualiza" datasource="#session.DSN#">
				update Impuestos
				set Iporcentaje = <cfqueryparam cfsqltype="cf_sql_float" value="#vn_totalPorcentajes#">
				where Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsGrupos.Icodigo#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			<cfcatch type="any"><cf_errorCode	code = "50281"
			                    				msg  = "No se puede realizar porque el Iporcentaje=@errorDat_1@"
			                    				errorDat_1="#vn_totalPorcentajes#"
			                    ></cfcatch>
			</cftry>
		</cfoutput>
	</cftransaction>

	<!--- * * * F I N * * * --->
<cfelse>
		<cfquery name="ERR" datasource="#session.DSN#">
			select Error as MSG
			from #errores#
			order by Error
		</cfquery>
		<cfreturn>		
</cfif>	



