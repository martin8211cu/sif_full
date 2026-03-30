<cfcomponent displayname="RH_EstructuraSalarial">
 <cffunction displayname="calculaComponente" output="true" name="calculaComponente" access="public" returntype="query" 
              hint="Proceso de cálculo con base en componentes y tabla salarial preestablecidos.">
     <cfargument name="CSid" 			 type="numeric" required="yes" hint="Identificador de Componente a Calcular">
     <cfargument name="fecha" 			 type="date" 	required="yes" hint="Fecha del Movimiento">								
     <cfargument name="fechah" 			 type="date" 	required="no" default="6100-01-01" hint="Fecha del Movimiento ">
     <cfargument name="RHCPlinea" 		 type="numeric" required="no" default="0" hint="Identificador de categoría puesto">		
     <cfargument name="DEid" 			 type="numeric" required="no" default="0" hint="Identificador del empleado">			
     <cfargument name="RHTTid" 			 type="numeric" required="no" default="0" hint="Tabla Salarial">					
     <cfargument name="RHCid" 			 type="numeric" required="no" default="0" hint="Categoria">			
     <cfargument name="RHMPPid" 		 type="numeric" required="no" default="0" hint="Puesto de Maestro Puesto">
     <cfargument name="Unidades" 		 type="numeric" required="no" default="1" hint="En anualidades/multiplicadores se debe de enviar la cantidad a multiplicar">					
     <cfargument name="MontoBase" 		 type="numeric" required="no" default="0" hint="campo que se multiplicara por unidades para obtener Monto">	
     <cfargument name="Monto" 			 type="numeric" required="no" default="0" hint="monto para el componente">		
     <cfargument name="Metodo" 			 type="string" 	required="no" default=""  hint="metodo para el componente">
     <cfargument name="BaseMontoCalculo" type="numeric" required="no" default="0" hint="monto del salario base">
     <cfargument name="TablaComponentes" type="string" 	required="no" default=""  hint="Tabla de los montos de los componentes a ser tomados en cuenta">				
     <cfargument name="CampoLlaveTC" 	 type="string" 	required="no" default=""  hint="Llave-tabla de los montos de los Comp. a ser tomados en cuenta">					
     <cfargument name="ValorLlaveTC" 	 type="numeric" required="no" default="0" hint="Valor-llave-tabla de montos de los Comp. a ser tomados en cuenta">	
     <cfargument name="CampoMontoTC" 	 type="string" 	required="no" default=""  hint="Llave-tabla donde se encuentran los montos de los comp. ser tomados en cta">					
     <cfargument name="negociado" 		 type="boolean" required="no" default="false" 			  hint="Indica si el monto es negociado">			
     <cfargument name="Ecodigo" 		 type="numeric" required="no" default="#Session.Ecodigo#" hint="Codigo de empresa ">
     <cfargument name="PorcSalario" 	 type="numeric" required="no" default="100"	 hint="Porcentaje de salario">				
     <cfargument name="RHCPlineaP" 		 type="numeric" required="no" default="0"    hint="Categoria Parcial">
     <cfargument name="alertException"   type="boolean" required="no" default="false" hint="Por defecto lanza una excepcion,si esta opcion esta en true,envia un alert">
     <cfargument name="validarNegociado" type="boolean" required="no" default="true" hint="Defecto:Se validan los montos negociados,inabilita cuando se esta agregando un componente por primera vez">
     <cfargument name="FijarVariable" 	 type="struct"   required="false" default="#StructNew()#">
   	 <cfargument name="RHAlinea" 		 type="numeric" required="no" default="0" hint="Identificador de la accion de personal">	
   
		<!--- Esta función calculará cada uno de los componentes que se le envíen, 
			y que hayan sido agregados a una acción particular. Para el caso de los componentes de tipo calculo 
			y otros cuyo salario base no utiliza estructurasalarial. 
			Valores de Retorno de la Función, los siguientes valores se retornarán en un objeto query:
			* Unidades(numeric): Aunque devolverá el campo para unidades, cuando se use para anualidades 
			o multiplicadores se debe de enviar la cantidad a multiplicar.
			* MontoBase(numeric): Devolverá el campo que se multiplicara por unidades para obtener Monto.
			* Monto(numeric): Devolverá el monto para el componente. --->

		<!---Funciones calculadora--->
		<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")>	
		
		<!--- Datos informacion --->
		<cfset dataC = QueryNew("Unidades, MontoBase, Monto, Metodo")>
		
		<!--- Averiguar el codigo del componente de salario base --->
		<cfquery name="rsSalarioBase" datasource="#Session.DSN#">
			select CSid as CampoSalarioBase
			from ComponentesSalariales
			where CSsalariobase = 1
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		</cfquery>
		
		<!---No se usa estructura salarial--->
		<cfset usaEstructuraSalarial = 0>
		
		<!--- Averiguar y almacena el Monto de Salario base --->				
		<cfquery name="rsMontoSalarioBase" datasource="#Session.DSN#">
			select c.DEid,a.RHDAlinea, a.CSid, a.RHDAunidad, coalesce(a.RHDAmontobase,0) as SB, a.RHDAmontores,
					   c.DLfvigencia,coalesce(c.DLffin,'61000101') as DLffin, c.RHCPlinea, c.Indicador_de_Negociado as negociado,RHAporcsal,c.RHPcodigoAlt,coalesce(RHCPlineaP,0) as RHCPlineaP
			from RHDAcciones a
				inner join ComponentesSalariales b
					on b.CSid = a.CSid
					and CSsalariobase = 1
				inner join RHAcciones c
					on c.RHAlinea = a.RHAlinea
			where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
			order by b.CSorden, b.CScodigo, b.CSdescripcion
		</cfquery>
        
        <cfif isdefined('rsMontoSalarioBase') and rsMontoSalarioBase.RecordCount GT 0>
			<cfset SalarioBase = rsMontoSalarioBase.SB * (arguments.PorcSalario/100)>
			<cfset Salario100P = rsMontoSalarioBase.SB>
        <cfelse>
        	<cfset SalarioBase = arguments.Monto * (arguments.PorcSalario/100)>
			<cfset Salario100P = arguments.Monto>
        </cfif>
    	
		<cfquery name="datosComp" datasource="#session.DSN#">
			select a.CSid,a.CSusatabla as TipoComp,a.CScodigo,a.CSdescripcion,a.CIid
			from ComponentesSalariales a
			where a.CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CSid#">
			  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		</cfquery>
	
		<cfif datosComp.TipoComp EQ 4><!--- COMPONENTE CALCULADO POR REGLA y METODO DE CALCULO--->
			<cfif isdefined('form.ERCid') and isdefined('form.DRCid')>
				<cfquery name="rsDRCdato" datasource="#session.DSN#">
					select DRCvalor,DRCmetodo
					from DReglaComponente
					where ERCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERCid#">
					  and DRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DRCid#">
				</cfquery>
				<cfset Lvar_Valor = rsDRCdato.DRCvalor>
				<!--- SI ES UN MONTO FIJO --->
				<cfif rsDRCdato.DRCmetodo EQ 'M'>
					<cfset Lvar_Monto = Lvar_Valor>
					<cfset Lvar_MontoBase = Lvar_Valor>
				<!--- SI ES UN PORCENTAJE SOBRE EL SALARIO BASE --->
				<cfelse>
					<cfquery name="rsConcepto" datasource="#session.DSN#">
						select a.CIid, a.CIdescripcion, coalesce(b.CIcantidad,12) as CIcantidad, b.CIrango, b.CItipo, b.CIdia, b.CImes, b.CIcalculo
						from CIncidentes a
							inner join CIncidentesD b
								on a.CIid = b.CIid
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datosComp.CIid#">
						  and a.CItipo = 3
					</cfquery>
					
					<cfif isdefined('rsConcepto') and rsConcepto.RecordCount>
						<!--- SE LLAMA A LA CALCULADORA PARA VERIFICAL CUAL ES EL VALOR QUE SE UTILIZA PARA EL CALCULO DEL COMPONENTES --->
						<cfset FVigencia = LSDateFormat(arguments.fecha, 'DD/MM/YYYY')>
						<cfset FFin = LSDateFormat(arguments.fechah, 'DD/MM/YYYY')>
						<cfset current_formulas = rsConcepto.CIcalculo>
						<cfset RH_Calculadorapresets_text = RH_Calculadora.get_presets(CreateDate(ListGetAt(FVigencia,3,'/'), ListGetAt(FVigencia,2,'/'), ListGetAt(FVigencia,1,'/')),
												   CreateDate(ListGetAt(FFin,3,'/'), ListGetAt(FFin,2,'/'), ListGetAt(FFin,1,'/')),
														   rsConcepto.CIcantidad,
													   rsConcepto.CIrango,
													   rsConcepto.CItipo,
													   arguments.DEid,
													   0,
													   session.Ecodigo,
													   0,
													   arguments.ValorLlaveTC,
													   rsConcepto.CIdia,
													   rsConcepto.CImes,
													   0,
													   FindNoCase('SalarioPromedio', current_formulas), <!--- optimizacion - SalarioPromedio es el calculo mÃ¡s pesado--->
													   'false',
													   '',
													   FindNoCase('DiasRealesCalculoNomina', current_formulas) <!--- optimizacion - DiasRealesCalculoNomina es el segundo calculo mas pesado--->
													   )>
						<cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>
						<cfset calc_error = RH_Calculadora.getCalc_error()>
						<cfif Not IsDefined("values")>
							<cfif isdefined("presets_text")>
								<cfthrow detail="#presets_text & '----' & current_formulas & '-----' & calc_error#">
							<cfelse>
								<cfthrow detail="#calc_error#" >
							</cfif>
						</cfif>
						<cfset vn_importe = values.get('importe').toString()>
						<cfset vn_resultado = values.get('resultado').toString()>
					<cfelse>
						<cf_throw message="No hay definido un concepto de pago tipo c&aacute;lculo para el componente #datosComp.CScodigo#-#datosComp.CSdescripcion#. Proceso Cancelado." errorcode="9003">
					</cfif>
					<!---<cfset Lvar_Monto = vn_resultado * (rsDRCdato.DRCvalor/100)>--->
					<cfset Lvar_Monto = vn_resultado>
					<cfset Lvar_MontoBase = vn_importe>
				</cfif>
				<cfset Lvar_Metodo = rsDRCdato.DRCmetodo>

			<cfelse>
				<cfset Lvar_Valor = arguments.unidades>
				<!--- SI ES UN MONTO FIJO --->
				<cfif arguments.metodo EQ 'M'>
					<cfset Lvar_Monto = Lvar_Valor>
					<cfset Lvar_MontoBase = Lvar_Valor>
				<!--- SI ES UN PORCENTAJE SOBRE EL SALARIO BASE --->
				<cfelse>
					<cfquery name="rsConcepto" datasource="#session.DSN#">
						select a.CIid, a.CIdescripcion, coalesce(b.CIcantidad,12) as CIcantidad, b.CIrango, b.CItipo, b.CIdia, b.CImes, b.CIcalculo
						from CIncidentes a
							inner join CIncidentesD b
								on a.CIid = b.CIid
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datosComp.CIid#">
						  and a.CItipo = 3
					</cfquery>
					<cfif isdefined('rsConcepto') and rsConcepto.RecordCount>
						<!--- SE LLAMA A LA CALCULADORA PARA VERIFICAL CUAL ES EL VALOR QUE SE UTILIZA PARA EL CALCULO DEL COMPONENTES --->
						<cfset FVigencia = LSDateFormat(arguments.fecha, 'DD/MM/YYYY')>
						<cfset FFin = LSDateFormat(arguments.fechah, 'DD/MM/YYYY')>
						<cfset current_formulas = rsConcepto.CIcalculo>
						<cfset presets_text = RH_Calculadora.get_presets(CreateDate(ListGetAt(FVigencia,3,'/'), ListGetAt(FVigencia,2,'/'), ListGetAt(FVigencia,1,'/')),
												   CreateDate(ListGetAt(FFin,3,'/'), ListGetAt(FFin,2,'/'), ListGetAt(FFin,1,'/')),
														   rsConcepto.CIcantidad,
													   rsConcepto.CIrango,
													   rsConcepto.CItipo,
													   arguments.DEid,
													   0,
													   session.Ecodigo,
													   0,
													    arguments.ValorLlaveTC,
													   rsConcepto.CIdia,
													   rsConcepto.CImes,
													   0,
													   FindNoCase('SalarioPromedio', current_formulas), <!--- optimizacion - SalarioPromedio es el calculo mÃ¡s pesado--->
													   'false',
													   '',
													   FindNoCase('DiasRealesCalculoNomina', current_formulas) <!--- optimizacion - DiasRealesCalculoNomina es el segundo calculo mas pesado--->
													   )>
						<cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>
						<cfset calc_error = RH_Calculadora.getCalc_error()>
						<cfif Not IsDefined("values")>
							<cfif isdefined("presets_text")>
								<cfthrow detail="#presets_text & '----' & current_formulas & '-----' & calc_error#">
							<cfelse>
								<cfthrow detail="#calc_error#" >
							</cfif>
						</cfif>
						<cfset vn_importe = values.get('importe').toString()>
						<cfset vn_resultado = values.get('resultado').toString()>
					<cfelse>
				
						<cf_throw message="No hay definido un concepto de pago tipo c&aacute;lculo para el componente #datosComp.CScodigo#-#datosComp.CSdescripcion#. Proceso Cancelado." errorcode="9003">
					</cfif>
                    <!---<cfset Lvar_Monto = vn_resultado*(Salario100P+vn_importe) * (Lvar_Valor/100)>--->
					<cfset Lvar_Monto = vn_resultado>
                    <cfset Lvar_MontoBase = (SalarioBase+vn_importe)>
                  
				</cfif>
				<cfset Lvar_Metodo = arguments.metodo>
			</cfif>
		
			
			<cfset newRow = QueryAddRow(dataC, 1)>
			<cfset temp = QuerySetCell(dataC, "Unidades", Lvar_Valor, 1)>
			<cfset temp = QuerySetCell(dataC, "MontoBase", Lvar_MontoBase, 1)>
			<cfset temp = QuerySetCell(dataC, "Monto", Lvar_Monto, 1)>	
			<cfset temp = QuerySetCell(dataC, "Metodo", Lvar_Metodo, 1)>
		<cfelseif datosComp.TipoComp EQ 3><!--- COMPONENTE CALCULADO POR REGLA --->
			<cfif isdefined('form.ERCid') and isdefined('form.DRCid')>
				<cfquery name="rsDRCdato" datasource="#session.DSN#">
					select DRCvalor,DRCmetodo
					from DReglaComponente
					where ERCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERCid#">
					  and DRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DRCid#">
				</cfquery>
				<cfset Lvar_Valor = rsDRCdato.DRCvalor>
				<!--- SI ES UN MONTO FIJO --->
				<cfif rsDRCdato.DRCmetodo EQ 'M'>
					<cfset Lvar_Monto = Lvar_Valor>
					<cfset Lvar_MontoBase = Lvar_Valor>
				<!--- SI ES UN PORCENTAJE SOBRE EL SALARIO BASE --->
				<cfelse>
					<!---<cfset Lvar_Monto = SalarioBase * (rsDRCdato.DRCvalor/100)>--->
					<cfset Lvar_Monto = SalarioBase>
					<cfset Lvar_MontoBase = SalarioBase>
				</cfif>
				<cfset Lvar_Metodo = rsDRCdato.DRCmetodo>
			<cfelse>
				<cfset Lvar_Valor = arguments.unidades>
				<!--- SI ES UN MONTO FIJO --->
				<cfif arguments.metodo EQ 'M'>
					<cfset Lvar_Monto = Lvar_Valor>
					<cfset Lvar_MontoBase = Lvar_Valor>
				<!--- SI ES UN PORCENTAJE SOBRE EL SALARIO BASE --->
				<cfelse>
					<!---<cfset Lvar_Monto = SalarioBase * (Lvar_Valor/100)>--->
					<cfset Lvar_Monto = SalarioBase >
					<cfset Lvar_MontoBase = SalarioBase >
				</cfif>
				<cfset Lvar_Metodo = arguments.metodo>
			</cfif>
			<cfset newRow = QueryAddRow(dataC, 1)>
			<cfset temp = QuerySetCell(dataC, "Unidades", Lvar_Valor, 1)>
			<cfset temp = QuerySetCell(dataC, "MontoBase", Lvar_MontoBase, 1)>
			<cfset temp = QuerySetCell(dataC, "Monto", Lvar_Monto, 1)>	
			<cfset temp = QuerySetCell(dataC, "Metodo", Lvar_Metodo, 1)>
		<cfelseif datosComp.TipoComp EQ 2 and (arguments.DEid GT 0 or Arguments.DEid eq -1)><!--- COMPONENTE CALCULADO POR FORMULA --->
			
			<cfquery name="rsConcepto" datasource="#session.DSN#">
				select a.CIid, a.CIdescripcion, coalesce(b.CIcantidad,12) as CIcantidad, b.CIrango, b.CItipo, b.CIdia, b.CImes, b.CIcalculo
				from CIncidentes a
					inner join CIncidentesD b
						on a.CIid = b.CIid
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datosComp.CIid#">
				  and a.CItipo = 3
			</cfquery>
			
			<cfif isdefined('rsConcepto') and rsConcepto.RecordCount>
				<!--- SE LLAMA A LA CALCULADORA PARA VERIFICAL CUAL ES EL VALOR QUE SE UTILIZA PARA EL CALCULO DEL COMPONENTES --->
			 	<cfset FVigencia = LSDateFormat(arguments.fecha, 'DD/MM/YYYY')>
				<cfset FFin = LSDateFormat(arguments.fechah, 'DD/MM/YYYY')>
				<cfset current_formulas = rsConcepto.CIcalculo>
				<cfset presets_text = RH_Calculadora.get_presets(CreateDate(ListGetAt(FVigencia,3,'/'), ListGetAt(FVigencia,2,'/'), ListGetAt(FVigencia,1,'/')),
										   CreateDate(ListGetAt(FFin,3,'/'), ListGetAt(FFin,2,'/'), ListGetAt(FFin,1,'/')),
												   rsConcepto.CIcantidad,
											   rsConcepto.CIrango,
											   rsConcepto.CItipo,
											   arguments.DEid,
											   0,
											   session.Ecodigo,
											   0,
											    arguments.ValorLlaveTC,
											   rsConcepto.CIdia,
											   rsConcepto.CImes,
											   0,
											   FindNoCase('SalarioPromedio', current_formulas), <!--- optimizacion - SalarioPromedio es el calculo mÃ¡s pesado--->
											   'false',
											   '',
											   FindNoCase('DiasRealesCalculoNomina', current_formulas) <!--- optimizacion - DiasRealesCalculoNomina es el segundo calculo mas pesado--->
											   ,0,"RHAcciones","",0,0,0,Arguments.FijarVariable)>
				<cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>
				<cfset calc_error = RH_Calculadora.getCalc_error()>
				<cfif Not IsDefined("values")>
					<cfif isdefined("presets_text")>
						<cfthrow detail="#presets_text & '----' & current_formulas & '-----' & calc_error#">
					<cfelse>
						<cfthrow detail="#calc_error#" >
					</cfif>
				</cfif>
                <cfset vn_cantidad = values.get('cantidad').toString()>
				<cfset vn_importe = values.get('importe').toString()>
				<cfset vn_resultado = values.get('resultado').toString()>
				<!---<cfset MontoCompo = SalarioBase * vn_resultado>--->
			
				<cfset newRow = QueryAddRow(dataC, 1)>
				<cfset temp = QuerySetCell(dataC, "Unidades",vn_cantidad, 1)>
				<cfset temp = QuerySetCell(dataC, "MontoBase", vn_importe, 1)>
				<cfset temp = QuerySetCell(dataC, "Monto", vn_resultado, 1)>
				<!---<cfset temp = QuerySetCell(dataC, "MontoBase", SalarioBase, 1)>
				<cfset temp = QuerySetCell(dataC, "Monto", MontoCompo, 1)>	--->	
				<cfset temp = QuerySetCell(dataC, "Metodo", 'M', 1)> 		
			<cfelse>
				<cf_throw message="No hay definido un concepto de pago tipo c&aacute;lculo para el componente #datosComp.CScodigo#-#datosComp.CSdescripcion#. Proceso Cancelado." errorcode="9003">
			</cfif>
		
		<!---<cfelseif datosComp.TipoComp EQ 1>--->	<!--- NO SE TOMA EN CUENTA EL COMPONENTE CALCULADO POR TABLA --->
        
		<cfelseif datosComp.TipoComp EQ 0><!--- COMPONENTE MONTO FIJO --->
			<cfset vUnidad = Arguments.Unidades >
			<cfset vMonto = Arguments.Monto >
			<cfset newRow = QueryAddRow(dataC, 1)>
			<cfset temp = QuerySetCell(dataC, "Unidades", Arguments.Unidades, 1)>
			<cfset temp = QuerySetCell(dataC, "MontoBase", vMonto, 1)>
			<cfset temp = QuerySetCell(dataC, "Monto", vMonto, 1)>		
		</cfif>
		
		<cfreturn dataC>
	</cffunction>
</cfcomponent>
