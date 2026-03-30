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
     <cfargument name="FijarVariable" 	 type="struct"  required="false" default="#StructNew()#">
     <cfargument name="TablaSalarial" 	 type="string"  required="false" default="A">
     <cfargument name="Escenario" 	 	 type="numeric" required="false" default="0">



		<!----================= TRADUCCION ================---->
		<cfinvoke key="MSG_El_parametro_de_Categoria_Puesto_es_requerido_para_el_calculo_del_componente" default="El parámetro de Categoría Puesto es requerido para el cálculo del componente"	 returnvariable="MSG_ParametroCategoriaPuesto" component="sif.Componentes.Translate" method="Translate"/>
		<cfinvoke key="MSG_El_salario_negociado_no_esta_dentro_del_rango_permitido_Puede_revisar_los_rangos_en_las_tablas_salariales_vigentes" default="El salario negociado no esta dentro del rango permitido.<br>Puede revisar los rangos en las tablas salariales vigentes."	 returnvariable="MSG_RangoSalarioNegociado" component="sif.Componentes.Translate" method="Translate"/>
		<cfinvoke key="MSG_Los_parametros_de_TablaComponentes_CampoLlaveTC_ValorLlaveTC_y_CampoMontoTC_son_requeridos" default="Los parámetros de TablaComponentes, CampoLlaveTC, ValorLlaveTC y CampoMontoTC son requeridos"	 returnvariable="MSG_ParametrosRequeridos" component="sif.Componentes.Translate" method="Translate"/>
		<cfinvoke key="MSG_No_se_pudo_obtener_un_monto_de_salario_Base_vigente_calculado_sobre_la_categoria_de_puesto_referenciado" default="No se pudo obtener un monto de salario base vigente calculado sobre la categoría de puesto referenciado en el método de cálculo del componente de"	 returnvariable="MSG_MontoSalarioVigente" component="sif.Componentes.Translate" method="Translate"/>


		<!--- Esta función calculará cada uno de los componentes que se le envíen,
			y que hayan sido agregados a una acción particular.
			Valores de Retorno de la Función, los siguientes valores se retornarán en un objeto query:
			* Unidades(numeric): Aunque devolverá el campo para unidades, cuando se use para anualidades
			o multiplicadores se debe de enviar la cantidad a multiplicar.
			* MontoBase(numeric): Devolverá el campo que se multiplicara por unidades para obtener Monto.
			* Monto(numeric): Devolverá el monto para el componente. --->

		<!---Funciones calculadora--->
		<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")>


		<cfset dataC = QueryNew("Unidades, MontoBase, Monto, Metodo")>
		<!--- Datos informacion --->

		<!--- Averiguar el RHCPlinea en caso de que venga la combinación de tres valores --->
		<cfif Arguments.RHTTid NEQ 0 and Arguments.RHCid NEQ 0 and Arguments.RHMPPid NEQ 0>
			<cfquery name="rsCatPaso" datasource="#Session.DSN#">
				select RHCPlinea,   coalesce(RHCPlinearef, RHCPlinea) as RHCPlinearef
				from RHCategoriasPuesto
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				and RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTTid#">
				and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHCid#">
				and RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHMPPid#">
			</cfquery>

			<cfif Len(Trim(rsCatPaso.RHCPlinea))>
				<cfset Arguments.RHCPlinea = rsCatPaso.RHCPlinea>
			</cfif>

			<!---  Modificación , para el caso en que el venga RHCPlinea como parámetro --->
		<cfelse>
		<!--- Carga el RHCPlinea en caso de que venga RHCPlinea como parámetro --->

			<cfquery name="rsCatPaso" datasource="#Session.DSN#">
				select RHCPlinea, coalesce(RHCPlinearef, RHCPlinea) as RHCPlinearef
				from RHCategoriasPuesto
				where RHCPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHCPlinea#">
			</cfquery>

			<cfif Len(Trim(rsCatPaso.RHCPlinea))>
				<cfset Arguments.RHCPlinea = rsCatPaso.RHCPlinea>
			</cfif>
		</cfif>
		<!---  FIn de Modificación , para el caso en que el venga RHCPlinea como parámetro --->


		<!--- Averiguar el codigo del componente de salario base --->
		<cfquery name="rsSalarioBase" datasource="#Session.DSN#">
			select CSid as CampoSalarioBase, CSusatabla as usatabla
			from ComponentesSalariales
			where CSsalariobase = 1
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		</cfquery>
		<cfset usaEstructuraSalarial = rsSalarioBase.usatabla>

		<!----=================================----->
		<!--- Averiguar y almacena el Monto de Salario base --->
        <cfif arguments.TablaSalarial EQ 'A'>
            <cfquery name="rsMontoSalarioBase" datasource="#Session.DSN#">
                select b.RHMCmonto as SB
                from RHCategoriasPuesto a
                inner join RHMontosCategoria b
                    on b.RHCid = a.RHCid
                inner join RHVigenciasTabla c
                    on c.Ecodigo = a.Ecodigo
                    and c.RHVTid = b.RHVTid
                    and c.RHTTid = a.RHTTid
                where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                  and RHVTestado = 'A'
                  and a.RHCPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHCPlinea#">
                      and <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.fecha#"> between  RHVTfecharige  and RHVTfechahasta
            </cfquery>
        <cfelse>
        	<cfquery name="rsMontoSalarioBase" datasource="#Session.DSN#">
            	Select coalesce(min(RHDTEmonto),0) as SB
                from RHDTablasEscenario a
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                  and RHEid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Escenario#">
                  and RHTTid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTTid#">
				  and RHCid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHCid#">
				  and RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHMPPid#">
                  and <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.fecha#">  between RHDTEfdesde and RHDTEfhasta
            </cfquery>
        </cfif>
		<cfif rsMontoSalarioBase.RecordCount EQ 0>
			<cf_throw message="No hay una tabla salarial para el periodo seleccionado. Proceso Cancelado." errorcode="9002">
		</cfif>

		<cfset SalarioBase = rsMontoSalarioBase.SB*(arguments.PorcSalario/100)>

        <!--- VERIRFICA SI HAY UNA CATEGORIA DE PAGO PROPUESTA ART. 40 --->
		<cfif isdefined('arguments.RHCPlineaP') and arguments.RHCPlineaP GT 0>
        	<cfquery name="rsMontoSalarioBaseProp" datasource="#Session.DSN#">
                select max(coalesce(b.RHMCmonto,0)) as SB
                from RHCategoriasPuesto a
                inner join RHMontosCategoria b
                    on b.RHCid = a.RHCid
                inner join RHVigenciasTabla c
                    on c.Ecodigo = a.Ecodigo
                    and c.RHVTid = b.RHVTid
                    and c.RHTTid = a.RHTTid
                where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                  and RHVTestado = 'A'
                  and a.RHCPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHCPlineaP#">
				  and <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.fecha#"> between  RHVTfecharige  and RHVTfechahasta
            </cfquery>
			<cfif rsMontoSalarioBaseProp.RecordCount EQ 0>
                <cf_throw message="No hay una tabla salarial para el periodo seleccionado de la Categoría Propuesta. Proceso Cancelado." errorcode="9002">
            </cfif>
            <cfset LvarMontoCatProp=rsMontoSalarioBase.SB+abs(((rsMontoSalarioBaseProp.SB-rsMontoSalarioBase.SB)/2))>
            <cfset SalarioBase = LvarMontoCatProp*(arguments.PorcSalario/100)>
        </cfif>
        <cfset Salario100P = rsMontoSalarioBase.SB>
        <!--- AGREGAR EL COMPONENTE NO INCIDENTE --->
        <cfquery name="rsCompNoInc" datasource="#session.DSN#">
        	select sum(#arguments.CampoMontoTC#) as Monto
            from #arguments.TablaComponentes# a
            inner join ComponentesSalariales b
            	on b.CSid = a.CSid
            where b.CIid is null
              and b.CSusatabla = 0
              and a.#arguments.CampoLlaveTC# = #arguments.ValorLlaveTC#
        </cfquery>
        <cfif rsCompNoInc.RecordCount GT 0 and rsCompNoInc.Monto GT 0>
            <cfset SalarioBase = SalarioBase + rsCompNoInc.Monto>
        </cfif>
		<!----=================================----->

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
                        <cfset vn_cantidad  = values.get('cantidad').toString()>
					<cfelse>
						<cf_throw message="No hay definido un concepto de pago tipo c&aacute;lculo para el componente #datosComp.CScodigo#-#datosComp.CSdescripcion#. Proceso Cancelado." errorcode="9003">
					</cfif>
					<!--- SI CANTIDAD ES 0 ENTONCES SE CALCULA SOBRE EL SALARIO BASE CORRESPONDIENTE SEGUN SU PORCENTAJE DE OCUPACION --->
                    <cfif vn_cantidad EQ 0>
						<cfset Lvar_Monto = vn_resultado*(SalarioBase+vn_importe) * (rsDRCdato.DRCvalor/100)>
						<cfset Lvar_MontoBase = SalarioBase+vn_importe>
                    <cfelse><!--- SE CALCULA SOBRE SALARIO AL 100% --->
                    	<cfset Lvar_Monto = vn_resultado*(Salario100P+vn_importe) * (rsDRCdato.DRCvalor/100)>
 						<cfset Lvar_MontoBase = Salario100P+vn_importe>
                   </cfif>
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
                        <cfset vn_cantidad= values.get('cantidad').toString()>
					<cfelse>

						<cf_throw message="No hay definido un concepto de pago tipo c&aacute;lculo para el componente #datosComp.CScodigo#-#datosComp.CSdescripcion#. Proceso Cancelado." errorcode="9003">
					</cfif>
					<!--- SI CANTIDAD ES 0 ENTONCES SE CALCULA SOBRE EL SALARIO BASE CORRESPONDIENTE SEGUN SU PORCENTAJE DE OCUPACION --->
                    <cfif vn_cantidad EQ 0>
						<cfset Lvar_Monto = vn_resultado*(SalarioBase+vn_importe) * (Lvar_Valor/100)>
                        <cfset Lvar_MontoBase = (SalarioBase+vn_importe)>
                    <cfelse><!--- SE CALCULA SOBRE SALARIO AL 100% --->
						<cfset Lvar_Monto = vn_resultado*(Salario100P+vn_importe) * (Lvar_Valor/100)>
                        <cfset Lvar_MontoBase = (Salario100P+vn_importe)>
                    </cfif>
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
					<cfset Lvar_Monto = SalarioBase * (rsDRCdato.DRCvalor/100)>
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
					<cfset Lvar_Monto = SalarioBase * (Lvar_Valor/100)>
					<cfset Lvar_MontoBase = SalarioBase>
				</cfif>
				<cfset Lvar_Metodo = arguments.metodo>
			</cfif>
			<cfset newRow = QueryAddRow(dataC, 1)>
			<cfset temp = QuerySetCell(dataC, "Unidades", Lvar_Valor, 1)>
			<cfset temp = QuerySetCell(dataC, "MontoBase", Lvar_MontoBase, 1)>
			<cfset temp = QuerySetCell(dataC, "Monto", Lvar_Monto, 1)>
			<cfset temp = QuerySetCell(dataC, "Metodo", Lvar_Metodo, 1)>
		<cfelseif datosComp.TipoComp EQ 2 and (arguments.DEid GT 0 or Arguments.DEid eq -1)><!--- COMPONENTE CALCULADO POR FORMULA --->
			<cfif len(trim(datosComp.CIid)) eq 0>
				<cfthrow message="El componente salarial seleccionado (<cfoutput>#datosComp.CScodigo#-#datosComp.CSdescripcion#</cfoutput>) no esta parametrizado
				para que se desglose por medio de una incidencia.
				Favor verificar dicha parametrización del componente salarial para poder continuar. ">
			</cfif>
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
				<cfset MontoCompo = SalarioBase * vn_resultado>
				<cfset newRow = QueryAddRow(dataC, 1)>
				<cfset temp = QuerySetCell(dataC, "Unidades",vn_cantidad, 1)>
				<cfset temp = QuerySetCell(dataC, "MontoBase", SalarioBase, 1)>
				<cfset temp = QuerySetCell(dataC, "Monto", MontoCompo, 1)>
				<cfset temp = QuerySetCell(dataC, "Metodo", 'P', 1)>
			<cfelse>

				<cf_throw message="No hay definido un concepto de pago tipo c&aacute;lculo para el componente #datosComp.CScodigo#-#datosComp.CSdescripcion#. Proceso Cancelado." errorcode="9003">
			</cfif>
		<cfelseif datosComp.TipoComp EQ 1><!--- COMPONENTE CALCULADO POR TABLA --->
        	<cfif rsSalarioBase.CampoSalarioBase NEQ datosComp.CSid>
				<!--- Obtener el monto del componente a partir de la tabla salarial --->
                <cfif arguments.TablaSalarial EQ 'A'>

                    <cfquery name="rsMontoTabla" datasource="#Session.DSN#">
                        select top 1 coalesce(b.RHMCmonto,0) as monto
                        from RHCategoriasPuesto a
                        inner join RHMontosCategoria b
                            on b.RHCid = a.RHCid
                        inner join RHVigenciasTabla c
                            on c.Ecodigo = a.Ecodigo
                            and c.RHVTid = b.RHVTid
                            and c.RHTTid = a.RHTTid
                        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                          and RHVTestado = 'A'
                          <cfif isdefined('arguments.RHCPlinea') and LEN(TRIM(arguments.RHCPlinea))>
                          and a.RHCPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHCPlinea#">
                          <cfelse>
                          and (RHVTfecharige between <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.fecha#">  and <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.fechah#">
                              or RHVTfechahasta between <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.fecha#">  and <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.fechah#">)
                        </cfif>
						order by RHVTfecharige desc
                    </cfquery>
                <cfelse>
                    <cfquery name="rsMontoTabla" datasource="#Session.DSN#">
                        Select coalesce(min(RHDTEmonto),0) as SB
                        from RHDTablasEscenario a
                        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                          and RHEid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Escenario#">
                          and RHTTid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTTid#">
                          and RHCid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHCid#">
                          and RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHMPPid#">
                          and <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.fecha#">  between RHDTEfdesde and RHDTEfhasta
                    </cfquery>
                </cfif>
				
				<cfif rsMontoTabla.recordCount EQ 0 or rsMontoTabla.Monto EQ 0>
                    <cfif GetFileFromPath(GetTemplatePath()) eq "ConlisCompSalarial.cfm">
                        <cfset Request.Error.Url = "#GetFileFromPath(GetTemplatePath())#?empresa=#form.empresa#&id=#form.id#&negociado=#form.negociado#&sql=#form.sql#">
                    </cfif>
                    <cfthrow message="No existe un monto vigente para el componente de #datosComp.CScodigo# - #datosComp.CSdescripcion# asociado a la categoría de puesto">
                </cfif>
            <cfelseif arguments.RHCPlineaP NEQ 0>
            	<cfset rsMontoTabla.Monto = LvarMontoCatProp>
            <cfelse>
            	<cfset rsMontoTabla.Monto = rsMontoSalarioBase.SB>
            </cfif>

			<cfset newRow = QueryAddRow(dataC, 1)>
			<!--- Unidades --->
				<cfset temp = QuerySetCell(dataC, "Unidades", Arguments.unidades, 1)>
			<!--- Monto Base --->
			<cfset temp = QuerySetCell(dataC, "MontoBase", rsMontoTabla.Monto, 1)>

			<cfset temp = QuerySetCell(dataC, "Monto", rsMontoTabla.Monto, 1)>
			<!----=================================----->
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

	<cffunction displayname="generarComponentesSB" output="no" name="generarComponentesSB" access="public" hint="genera los componentes de SB para cada relacion de Categoria Puesto en la tabla RHCPcomponentes">
        <cfargument name="RHTTid" 			 type="numeric" required="yes"            hint="Id de la tabla Tabla Salarial">
        <cfargument name="Conexion" type="string" required="yes" default="#session.dsn#">
        <cfargument name="Ecodigo" type="numeric" required="yes" default="#session.Ecodigo#">
        <cfargument name="debug" 		type="boolean" 	required="no" default="false">

        <cfquery datasource="#arguments.conexion#" name="SalarioBase" maxrows="1">
            select cs.CSid
            from ComponentesSalariales cs
            where cs.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#">
            and cs.CSusatabla = 1
            and cs.CSsalariobase = 1
        </cfquery>
        <cfquery datasource="#arguments.conexion#">
            insert into RHCPcomponentes (RHCPlinea,CSid)
            select rh.RHCPlinea, <cfqueryparam cfsqltype="cf_sql_numeric" value="#SalarioBase.CSid#"> as CSid
            from RHCategoriasPuesto rh
            where rh.RHTTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHTTid#">
            and (select count(1)
                 from RHCPcomponentes rhcp
                 where rhcp.RHCPlinea=rh.RHCPlinea
                 and rhcp.CSid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#SalarioBase.CSid#">) = 0<!--- valida que no ingrese un registro duplicado--->
        </cfquery>

		<cfquery name="rsComponentes" datasource="#session.dsn#">
			SELECT rc.RHCPlinea,rc.CSid,ra.RHCAmExcluyeSB from RHCPcomponentes rc
			inner join
			RHCategoriasPuesto cp
				on cp.RHCPlinea = rc.RHCPlinea
			inner join ComponentesSalariales cs
				on cs.CSid = rc.CSid
			inner join RHComponentesAgrupados ra
				on ra.RHCAid = cs.CAid
			where cp.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHTTid#">
		</cfquery>

		<!--- OPARRALES 2018-07-27 Validamos si existe un componente que pide que excluya al Componente de Salario Base --->
		<cfquery name="rsExiste" dbtype="query">
			select * from rsComponentes where RHCAmExcluyeSB = 1
		</cfquery>

		<!--- Eliminamos los componentes que sean de Salario Base --->
		<cfif rsExiste.RecordCount gt 0>
			<cfquery name="rsEsSB" dbtype="query">
				select RHCPlinea,CSid,RHCAmExcluyeSB
				from rsComponentes
				where RHCAmExcluyeSB = 0
			</cfquery>
			<cfloop query="rsEsSB">
				<cfquery datasource="#session.dsn#">
					delete from RHCPcomponentes
					where
						RHCPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEsSB.RHCPlinea#">
					and CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEsSB.CSid#">
				</cfquery>
			</cfloop>
		</cfif>

	</cffunction>


    <cffunction name="generarAumentoDesdeTablaSalarial"  output="no"access="public">
		<cfargument name="idTabla" 			type="numeric" 	required="no"            hint="Id de la tabla Tabla Salarial">
		<cfargument name="idVigenciaTabla" 	type="numeric" 	required="no"            hint="Id de la tabla Tabla Salarial">
		<cfargument name="Empleados" 			type="string" 	required="no">
		<cfargument name="Conexion" 			type="string" 	required="yes" default="#session.dsn#">
		<cfargument name="Ecodigo" 			type="numeric" 	required="yes" default="#session.Ecodigo#">
		<cfargument name="debug" 				type="boolean" 	required="no" default="false">


        <cfquery datasource="#arguments.Conexion#" name="rsLote">
        select coalesce(max(RHAlote),0) + 1 as lote
        from RHEAumentos
        where Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#">
        </cfquery>
        <!--- ENCABEZADO DE LA RELACION DE AUMENTO --->
        <cfquery name="InsertAumentoInfo" datasource="#arguments.Conexion#">
        	select x.RHVTfecharige
            from RHVigenciasTabla x
            where x.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.idTabla#">
            and  x.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.idVigenciaTabla#">
        </cfquery>

        <cfquery name="InsertAumento" datasource="#arguments.Conexion#">
            insert into RHEAumentos (Ecodigo, RHAlote, Usucodigo, RHAfecha, RHAfdesde, RHAestado,RHAtipo,RHTTid,RHVTid,RHAinactivos,BMUsucodigo)
           values (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#rsLote.lote#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#InsertAumentoInfo.RHVTfecharige#" null="#!len(trim(InsertAumentoInfo.RHVTfecharige))#">,
                0,
                'T',
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.idTabla#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.idVigenciaTabla#">,
                0,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			)
            <cf_dbidentity1 datasource="#session.DSN#">
        </cfquery>
        <cf_dbidentity2 datasource="#arguments.Conexion#" name="InsertAumento">
        <cfset idRelacionAumento = InsertAumento.identity>


        <!--- DETALLE DE LA RELACION DE AUMENTO, SELECCIONA LAS PERSONAS QUE TIENEN DERECHO AL AUMENTO--->
        <cfquery datasource="#arguments.Conexion#">
            insert into RHDAumentos(RHAid, LTid, RHDsalario, NTIcodigo, DEidentificacion, RHDvalor, DEid, RHCPlinea,BMUsucodigo)
            select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#idRelacionAumento#">,
                    lt.LTid,
                    lt.LTsalario,
                    de.NTIcodigo,
                    de.DEidentificacion,
                    0,
                    de.DEid,
                    lt.RHCPlinea,
                    #session.Usucodigo#
            from LineaTiempo lt
            inner join DatosEmpleado de
                on de.Ecodigo = lt.Ecodigo
                and de.DEid = lt.DEid
            inner join RHCategoriasPuesto rh
                on lt.RHCPlinea=rh.RHCPlinea
                and rh.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.idTabla#">

            where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">

              and LThasta >= (select x.RHVTfecharige
                                    from RHVigenciasTabla x
                                    where x.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.idTabla#">
                                    and  x.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.idVigenciaTabla#">)
              and not exists (select 1
                              from RHDAumentos
                              where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idRelacionAumento#">
                                and DEid = de.DEid )

              and  exists (select 1
                              from DLineaTiempo dlt
                               inner join RHMontosCategoria b
                                    on b.CSid=dlt.CSid
                              where b.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.idVigenciaTabla#">
                                and lt.LTid=dlt.LTid)

              and lt.RHCPlinea is not null


            <!---- se agrega el recargo---->
            union all
            select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#idRelacionAumento#">,
                    lt.LTRid,
                    lt.LTsalario,
                    de.NTIcodigo,
                    de.DEidentificacion,
                    0,
                    de.DEid,
                    lt.RHCPlinea,
                    #session.Usucodigo#
            from LineaTiempoR lt
            inner join DatosEmpleado de
                on de.Ecodigo = lt.Ecodigo
                and de.DEid = lt.DEid
            inner join RHCategoriasPuesto rh
                on lt.RHCPlinea=rh.RHCPlinea
                and rh.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.idTabla#">

            where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">

              and LThasta > (select x.RHVTfecharige
                                    from RHVigenciasTabla x
                                    where x.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.idTabla#">
                                    and  x.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.idVigenciaTabla#">)
              and not exists (select 1
                              from RHDAumentos
                              where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idRelacionAumento#">
                                and DEid = de.DEid )

              and  exists (select 1
                              from DLineaTiempoR dlt
                               inner join RHMontosCategoria b
                                    on b.CSid=dlt.CSid
                              where b.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.idVigenciaTabla#">
                                and lt.LTRid=dlt.LTRid)

              and lt.RHCPlinea is not null

        </cfquery>

		<!--- Inserta todos los componentes que posee el empleado desde la fecha rige y que se encuentra en la relacion
        los unicos componentes que se asocian son los que tienen monto en la vigencia y el empleado utiliza--->
        <cfquery datasource="#arguments.Conexion#">
            insert into RHDAumentosComponentes (RHDAlinea,CSid,RHDvalorAnt, RHDvalor,RHDMontoFijo, RHDporcentaje)
            select  rh.RHDAlinea,  dlt.CSid ,coalesce(b.RHMCmontoAnt,dlt.DLTmonto, 0.00) as montoAnterior, coalesce(b.RHMCmonto,dlt.DLTmonto, 0.00) as RHMCmonto, coalesce(b.RHMCmontoFijo,0.00) as RHMCmontoFijo, coalesce(b.RHMCmontoPorc,0) as RHMCmontoPorc
            from RHDAumentos rh
                inner join LineaTiempo lt
                    on rh.LTid=lt.LTid
                    and rh.DEid=lt.DEid
                    and rh.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idRelacionAumento#">
                inner join DLineaTiempo dlt
                    on lt.LTid = dlt.LTid
                inner join ComponentesSalariales cs
                    on dlt.CSid=cs.CSid
                      <!---and cs.CSusatabla in (1,0)--->
                inner join RHCategoriasPuesto a
                    on lt.RHCPlinea=a.RHCPlinea
                    and a.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.idTabla#">
                left join RHMontosCategoria b
                    on b.RHCid=a.RHCid
                    and b.CSid=dlt.CSid
                    and b.RHMCmonto > 0.00  <!---toma unicamente los componentes que tiene un monto mayor a cero de la vigencia a aplicar--->
                    and b.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.idVigenciaTabla#">
            <!--- procedimiento para recargos----->
            union
            select  rh.RHDAlinea,  dlt.CSid ,coalesce(b.RHMCmontoAnt,dlt.DLTmonto, 0.00), coalesce(b.RHMCmonto,dlt.DLTmonto, 0.00) as RHMCmonto, coalesce(b.RHMCmontoFijo,0.00) as RHMCmontoFijo, coalesce(b.RHMCmontoPorc,0) as RHMCmontoPorc
            from RHDAumentos rh
                inner join LineaTiempoR lt
                    on rh.LTRid=lt.LTRid
                    and rh.DEid=lt.DEid
                    and rh.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idRelacionAumento#">
                inner join DLineaTiempoR dlt
                    on lt.LTRid = dlt.LTRid
                inner join ComponentesSalariales cs
                    on dlt.CSid=cs.CSid
                      and cs.CSusatabla in (1,0)
                inner join RHCategoriasPuesto a
                    on lt.RHCPlinea=a.RHCPlinea
                    and a.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.idTabla#">
                left join RHMontosCategoria b
                    on b.RHCid=a.RHCid
                    and b.CSid=dlt.CSid
                    and b.RHMCmonto > 0.00  <!---toma unicamente los componentes que tiene un monto mayor a cero de la vigencia a aplicar--->
                    and b.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.idVigenciaTabla#">
        </cfquery>

		<!--- UNICAMENTE PARA SALARIOS NEGOCIADOS (BNVital) --->
        <!--- basicamente si el empleado tiene la plaza negociada, no tomará el monto de la tabla salarial, sino el monto negociado que esta en la linea de tiempo
        y basado en esto se le aplicará la formula:
        Calcular [RHDvalor]  =	MontoAnterior + ((MontoAnterior*MontoPorcentaje)+ MontoFijo)
        Nota: Siemple el salario anterior es el de la linea de tiempo, puesto que estamos realizan un aumento sobre el salario del empleado, no sobre la referencia en la categoria
        si las vigencias fueron bien aplicadas, no habrá diferencia entre los montos en la vigencias y los que estan en la linea de tiempo con respecto al monto anterior.
        Aparte que este monto de salario anterior es irrelevante, solo queda registrado en la accion como salario anterior, nunca produce variacion en el salario propuesto,
        a menos que sea una plaza con salario negociado, dado que en ese caso se realiza el siguien update, segun la formula explicada anteriormente
        --->

        <cfinvoke component="rh.Componentes.RH_EstructuraSalarial" method="tratarSalariosNegociados">
            <cfinvokeargument name="RHAid" value="#idRelacionAumento#">
        </cfinvoke>

        <!--- ACTUALIZA SALARIO CON EL SALARIO DE LA NUEVA TABLA SALARIAL --->
        <cfquery datasource="#arguments.Conexion#">
            update RHDAumentos
            set RHDsalario= coalesce((
                                 select sum(a.RHDvalorAnt)
                                 from RHDAumentosComponentes a
                                 where a.RHDAlinea=RHDAumentos.RHDAlinea
                                 )
                                ,0.00),
            RHDvalor = coalesce((select sum(a.RHDvalor)<!--- fcastro, es una sumatoria para que guarde el totalizado de todos los componenes--->
                            from RHDAumentosComponentes a
                            where a.RHDAlinea=RHDAumentos.RHDAlinea),0)
            where RHAid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#idRelacionAumento#">
        </cfquery>
	</cffunction>


	<cffunction name="tratarSalariosNegociados" output="no">
		<cfargument name="RHAid"   		type="numeric"  required="yes"  hint="id del encabezado del aumento">
            <!--- UNICAMENTE PARA SALARIOS NEGOCIADOS (BNVital) --->
			<!--- basicamente si el empleado tiene la plaza negociada, no tomará el monto de la tabla salarial, sino el monto negociado que esta en la linea de tiempo
			y basado en esto se le aplicará la formula:
			Calcular [RHDvalor]  =	MontoAnterior + ((MontoAnterior*MontoPorcentaje)+ MontoFijo)
			Nota: Siemple el salario anterior es el de la linea de tiempo, puesto que estamos realizan un aumento sobre el salario del empleado, no sobre la referencia en la categoria
			si las vigencias fueron bien aplicadas, no habrá diferencia entre los montos en la vigencias y los que estan en la linea de tiempo con respecto al monto anterior.
			Aparte que este monto de salario anterior es irrelevante, solo queda registrado en la accion como salario anterior, nunca produce variacion en el salario propuesto,
			a menos que sea una plaza con salario negociado, dado que en ese caso se realiza el siguien update, segun la formula explicada anteriormente
			--->
		<cfquery datasource="#session.DSN#" >
            update RHDAumentosComponentes
            set RHDvalorAnt=coalesce(	(  select dlt.DLTmonto
										from RHDAumentos rh
										inner join RHDAumentosComponentes rhd
											on rh.RHDAlinea=rhd.RHDAlinea
										inner join LineaTiempo lt
											on rh.LTid=lt.LTid
										inner join DLineaTiempo dlt
											on lt.LTid=dlt.LTid
										inner join ComponentesSalariales cs
											on dlt.CSid=cs.CSid
										inner join RHPlazas rhp
											on lt.RHPid=rhp.RHPid
										where rh.RHAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHAid#">
										and cs.CSsalariobase=1
										and cs.CSusatabla=1
										and rhd.RHDAlinea=RHDAumentosComponentes.RHDAlinea
										and rhd.CSid=RHDAumentosComponentes.CSid
										and rhp.RHPsalarionegociado=1 )
									,0.00)

			where (select count(1)
					from RHDAumentos rh
					inner join RHDAumentosComponentes rhd
						on rh.RHDAlinea=rhd.RHDAlinea
					inner join ComponentesSalariales cs
						on rhd.CSid=cs.CSid
					inner join LineaTiempo lt
						on rh.LTid=lt.LTid
					inner join RHPlazas rhp
						on lt.RHPid=rhp.RHPid
					where rh.RHAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHAid#">
					and cs.CSsalariobase=1
					and cs.CSusatabla=1
					and rhd.RHDAlinea=RHDAumentosComponentes.RHDAlinea
					and rhd.CSid=RHDAumentosComponentes.CSid
					and rhp.RHPsalarionegociado=1) > 0
		</cfquery>



		<cfquery datasource="#session.DSN#">
			update RHDAumentosComponentes
			set RHDvalor=coalesce(	(   RHDvalorAnt+((RHDvalorAnt*RHDporcentaje/100)+RHDMontoFijo)   )
									,0.00)

			where (select count(1)
					from RHDAumentos rh
					inner join RHDAumentosComponentes rhd
						on rh.RHDAlinea=rhd.RHDAlinea
					inner join ComponentesSalariales cs
						on rhd.CSid=cs.CSid
					inner join LineaTiempo lt
						on rh.LTid=lt.LTid
					inner join RHPlazas rhp
						on lt.RHPid=rhp.RHPid
					where rh.RHAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHAid#">
					and cs.CSsalariobase=1
					and cs.CSusatabla=1
					and rhd.RHDAlinea=RHDAumentosComponentes.RHDAlinea
					and rhd.CSid=RHDAumentosComponentes.CSid
					and rhp.RHPsalarionegociado=1) > 0
		</cfquery>
	</cffunction>

    <cffunction name="GetPuestoAlterno" output="no"  returntype="numeric">
        <cfargument name="RHPcodigoAlt" type="string"  	required="yes"  hint="codigo de puesto alterno">

        <cfquery name="rsCatPuestoAlt" datasource="#session.DSN#">
            select RHCPlinea
            from RHPuestos a
            inner join RHMaestroPuestoP b
                on b.RHMPPid = a.RHMPPid
                and b.Ecodigo = a.Ecodigo
            inner join RHCategoriasPuesto c
                on c.RHMPPid = b.RHMPPid
                and c.Ecodigo = b.Ecodigo
            where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.RHPcodigoAlt#">
              and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        </cfquery>

	   <cfif isdefined('rsCatPuestoAlt') and rsCatPuestoAlt.RecordCount>
            <cfset Lvar_CatAlt = rsCatPuestoAlt.RHCPlinea>
       <cfelse>
            <cfset Lvar_CatAlt = 0>
        </cfif>
        <cfreturn Lvar_CatAlt>
    </cffunction>


    <cffunction name="AgregarEmpleadosTablaSalarial" output="no">
        <cfargument name="datosRHDaumentos" type="query"  	required="yes"  hint="query con las linea de tiempo y el detalle de RHDAumentos">
        <cfargument name="RHAid"   			type="numeric"  required="yes"  hint="id del encabezado del aumento">

    	<cftry>
		<cfsetting requesttimeout="#(GetRequestTimeout() + 3)#"/>

        <cftransaction>
            <cfquery name="rsRAumento" datasource="#session.DSN#">
                select *
                from RHEAumentos
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                  and RHAestado = 0
                  and RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHAid#">
            </cfquery>

            <cfloop query="arguments.datosRHDaumentos">
            	<cfset LvarRHCPlinea = arguments.datosRHDaumentos.RHCPlinea>

                <cfset sufijo=''>
                <cfif datosRHDaumentos.TLinea NEQ 'N'>
                    <cfset sufijo='R'>
                </cfif>
                <!--- ljs 20121018 se veerifica si  usa el codigo Alterno--->
                <cfif len(ltrim(rtrim(arguments.datosRHDaumentos.RHPcodigoAlt))) GT 0>
                    <cfinvoke component="rh.Componentes.RH_EstructuraSalarial" method="GetPuestoAlterno" returnvariable="LvarRHCPlineaAlterno">
                        <cfinvokeargument name="RHPcodigoAlt" value="#arguments.datosRHDaumentos.RHPcodigoAlt#">
                    </cfinvoke>
                    <cfset LvarRHCPlinea = LvarRHCPlineaAlterno>
                </cfif>
                <!---------------------------------------------------------->

               <cfquery name="ABC_Aumento" datasource="#Session.DSN#">
                    insert into RHDAumentos (RHAid, NTIcodigo, DEid, DEidentificacion, RHDtipo,RHDvalor,
                        <cfif datosRHDaumentos.TLinea EQ 'N'>
                            LTid
                        <cfelse>
                            LTRid
                        </cfif>,RHCPlinea)
                    values (
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHAid#">,
                        <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.datosRHDaumentos.NTIcodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.datosRHDaumentos.DEid#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.datosRHDaumentos.DEidentificacion#">,
                        <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
                        0,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#datosRHDaumentos.LTid#">,
                         <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarRHCPlinea#">
                   )
                   <cf_dbidentity1 datasource="#session.DSN#">
                </cfquery>
                <cf_dbidentity2 datasource="#session.DSN#" name="ABC_Aumento">

                 <!----Inserta todos los componentes que posee el empleado desde la fecha rige y que se encuentra en la relacion
                los unicos componentes que se asocian son los que tienen monto en la vigencia y el empleado utiliza---->
                <cfquery datasource="#session.dsn#">
                    insert into RHDAumentosComponentes (RHDAlinea,CSid,RHDvalorAnt, RHDvalor,RHDMontoFijo, RHDporcentaje)
                    select  rh.RHDAlinea,  dlt.CSid ,coalesce(b.RHMCmontoAnt,dlt.DLTmonto, 0.00), coalesce(b.RHMCmonto,dlt.DLTmonto, 0.00) as RHMCmonto
                    	,coalesce(b.RHMCmontoFijo,0.00) as RHMCmontoFijo, coalesce(b.RHMCmontoPorc,0) as RHMCmontoPorc
                    from RHDAumentos rh
                        inner join LineaTiempo#sufijo# lt
                            on rh.LT#sufijo#id=lt.LT#sufijo#id
                            and rh.DEid=lt.DEid
                            and rh.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHAid#">
                            and rh.RHDAlinea = #ABC_Aumento.Identity#
                        inner join DLineaTiempo#sufijo# dlt
                            on lt.LT#sufijo#id = dlt.LT#sufijo#id
                            and lt.LT#sufijo#id= <cfqueryparam cfsqltype="cf_sql_numeric" value="#datosRHDaumentos.LTid#">
                        inner join ComponentesSalariales cs
                            on dlt.CSid=cs.CSid
                            <!---  and cs.CSusatabla in (1,0)	--->
                        inner join RHCategoriasPuesto a
                            on rh.RHCPlinea=a.RHCPlinea
                            and a.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRAumento.RHTTid#">
                        left join RHMontosCategoria b
                            on b.RHCid=a.RHCid
                            and b.CSid=dlt.CSid
                            and b.RHMCmonto > 0.00  <!---toma unicamente los componentes que tiene un monto mayor a cero de la vigencia a aplicar--->
                            and b.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRAumento.RHVTid#">
                </cfquery>
            </cfloop>


			 <!----se le cambia el monto anterior y propuesto del componente salario base, igualando al valor en la linea de tiempo del empleado al valor del salario
			y el monto propuesto es recalculado---->
			<cfinvoke method="tratarSalariosNegociados">
				<cfinvokeargument name="RHAid" value="#arguments.RHAid#">
			</cfinvoke>

			<cfquery datasource="#session.DSN#">
				Update RHDAumentos
				set RHDsalario= coalesce((
										 select sum(a.RHDvalorAnt)
										 from RHDAumentosComponentes a
										 where a.RHDAlinea=RHDAumentos.RHDAlinea
										 )
										,0.00),
				RHDvalor= coalesce((
										 select sum(a.RHDvalor)
										 from RHDAumentosComponentes a
										 where a.RHDAlinea=RHDAumentos.RHDAlinea
										 )
										,0.00)
				where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHAid#">
				and (select count(1)
					 from RHDAumentosComponentes a
					 where a.RHDAlinea=RHDAumentos.RHDAlinea) > 0
			</cfquery>

		</cftransaction>
        <cfcatch>
            <cfsetting requesttimeout="#(GetRequestTimeout() + 3)#">
        </cfcatch>
     </cftry>
	</cffunction>

    <!---funcion para recuperar el RequestTimeout--->
    <cffunction name="GetRequestTimeout"  access="public" returntype="numeric" output="no" hint="Returns the current request timeout for the current page page request.">
        <!--- Define the local scope. --->
        <cfset var LOCAL = StructNew() />

        <!--- Get the request monitor. --->
        <cfset LOCAL.RequestMonitor = CreateObject("java","coldfusion.runtime.RequestMonitor") />

        <!--- Return the current request timeout. --->
        <cfreturn LOCAL.RequestMonitor.GetRequestTimeout() />
    </cffunction>

</cfcomponent>
