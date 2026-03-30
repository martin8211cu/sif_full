<cfcomponent>
	<!--- USO:
		Primera línea del fuente para un precio unitario:
			Cuando el Precio es de Contrato: se coloca init(true) y si esta parametrizado MultiplesContratos el PrecioU es un monto total con 2 decimales
				Para un Precio que es de Contrato (puede ser unitario o único dependiendo del parámetro 730 MúltiplesContratos:
					<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init(true)>
				Para cualquier otro precio unitario:
					<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
				Para indicar los decimales en metodo init(true/false, n deciamales) 	
		
		En un SELECT o UPDATE con campos de la base de datos:
			(.enSQL_AS() se usa entre el SELECT y el FROM, para cualquier otro lado se usa .enSQL()) 
			SELECT ... #LvarOBJ_PrecioU.enSQL_AS("CAMPO")# ...FROM						SELECT ... round(CAMPO,n) 			as CAMPO ...FROM
			SELECT ... #LvarOBJ_PrecioU.enSQL_AS("TABLA.CAMPO")# ...FROM				SELECT ... round(TABLA.CAMPO,n) 	as CAMPO ...FROM
			SELECT ... #LvarOBJ_PrecioU.enSQL_AS("CAMPO/FORMULA", "ALIAS")# ...FROM		SELECT ... round(CAMPO/FORMULA,n) 	as ALIAS ...FROM
			WHERE  ... #LvarOBJ_PrecioU.enSQL("CAMPO/FORMULA")# ...						WHERE  ... round(CAMPO/FORMULA,n)
			UPDATE ... #LvarOBJ_PrecioU.enSQL("CAMPO/FORMULA")# ...						UDATE  ... round(CAMPO/FORMULA,n)

		En un CFQUERY: (en lugar del <cfqueryparam... >
			#LvarOBJ_PrecioU.enCF(form.CAMPO)#										#NumberFormat(form.CAMPO,",0.9999")#
		En un CF redondeado:
			#LvarOBJ_PrecioU.enCF(form.CAMPO)#										#NumberFormat(form.CAMPO,",0.9999")#
		En un CF para reportes:
			#LvarOBJ_PrecioU.enCF_RPT(form.CAMPO)#									#NumberFormat(form.CAMPO,",0.9999")#

		En el form de entrada de datos:
			#LvarOBJ_PrecioU.inputNumber("CAMPO", VALOR, "tabIndex", readOnly, "class", "style", "onBlur();", "onChange();")#

		Para obtener la mascara usada en CF:
			#LvarOBJ_PrecioU.maskCF()#												",0.9999"
		Para obtener la mascara usada en Reportes:
			#LvarOBJ_PrecioU.maskRPT()#												",0.9999"
	--->
	<cffunction name="init" access="public" output="false" returntype="CM_PrecioU">
		<cfargument name="esPrecioDeContrato" type="boolean" required="false" default="no">
		<cfargument name="decimal" 			  type="numeric" required="false" default="4">

		<cfset GvarEsContratosMultiples = -1>
		<cfif Arguments.esPrecioDeContrato AND EsContratosMultiples()>
			<!--- DCpreciou = Precio Unico (PrecioUnitario*Cantidad), o Monto del Contrato sin Impuesto, con 2 decimales --->
			<cfset GvarPrecioU_dec = #Arguments.decimal#>
			<cfset GvarPrecioU_CFmask = "9.#repeatstring("0",GvarPrecioU_dec)#">
			<cfset GvarPrecioU_dec_RPT = 4>
			<cfset GvarPrecioU_CFmask_RPT = ",9.#repeatstring("0",GvarPrecioU_dec_RPT)#">
		<cfelse>
			<!--- DCpreciou = Precio Unitario, con n número de decimales según Parametro 545 y m número de dec para reportes según Parámetro 546 --->
			<!--- Parámetro 545: --->
			<cfquery name="rsSQL" datasource="#session.DSN#">
				select Pvalor 
				from Parametros 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
					and Pcodigo = 545
			</cfquery>
			<cfif rsSQL.recordCount GT 0 and Arguments.decimal eq 4>
				<cfset GvarPrecioU_dec = rsSQL.Pvalor>
			<cfelse>
				<cfset GvarPrecioU_dec = #Arguments.decimal#>
			</cfif>
			<cfset GvarPrecioU_CFmask = "9." & repeatstring("0",GvarPrecioU_dec)>

			<!--- Parámetro 546: --->
			<cfquery name="rsSQL" datasource="#session.DSN#">
				select Pvalor 
				from Parametros 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
					and Pcodigo = 546
			</cfquery>
			<cfif rsSQL.recordCount GT 0>
				<cfset GvarPrecioU_dec_RPT = rsSQL.Pvalor>
			<cfelse>
				<cfset GvarPrecioU_dec_RPT = 2>
			</cfif>
			<cfset GvarPrecioU_CFmask_RPT = ",9." & repeatstring("0",GvarPrecioU_dec_RPT)>
		</cfif>
		<cfreturn this>
	</cffunction>
		
	<cffunction name="EsPrecioContrato" access="public" output="false" returntype="boolean">
		<cfreturn GvarEsContratosMultiples>
	</cffunction>
	
	<cffunction name="getDecimales" access="public" output="false" returntype="numeric">
		<cfreturn GvarPrecioU_dec>
	</cffunction>
	
	<cffunction name="EsContratosMultiples" access="public" output="false" returntype="boolean">
		<cfif GvarEsContratosMultiples EQ -1>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select 1 from Parametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Pcodigo = 730
				and Pvalor = '1'
			</cfquery>
			<cfset GvarEsContratosMultiples = (rsSQL.recordcount GT 0)>
		</cfif>
		<cfreturn GvarEsContratosMultiples>
	</cffunction>
	
	<cffunction name="enSQL" access="public" output="true" returntype="void">
		<cfargument name="name" type="string" required="true">
		<cfargument name="alias" type="string" required="false" default="">
		<cfif Arguments.alias NEQ "">
			<cf_errorCode	code = "51116" msg = "CM_PrecioU.enSQL no debe llevar atributo ALIAS">
		</cfif>
		<cfset enSQL_AS(Arguments.name, "")>
	</cffunction>
	
	<cffunction name="enSQL_AS" access="public" output="true" returntype="void">
		<cfargument name="name" type="string" required="true">
		<cfargument name="alias" type="string" required="false" >
		<cfparam name="Arguments.alias" default="#Arguments.name#">
		<cfif find(" ",Arguments.alias) or find("+",Arguments.alias) or find("-",Arguments.alias) or find("*",Arguments.alias) or find("/",Arguments.alias) or find("(",Arguments.alias) or find(",",Arguments.alias) or find("||",Arguments.alias)>
			<cf_errorCode	code = "51117"
							msg  = "El alias no puede contener espacios en blanco o caracteres especiales: '@errorDat_1@'"
							errorDat_1="#Arguments.alias#"
			>
		<cfelseif find(".",Arguments.alias)>
			<cfset Arguments.alias = mid(Arguments.alias, find(".",Arguments.alias)+1, 100)>
		</cfif>
		<cfoutput>
			round(#Arguments.name#,#GvarPrecioU_dec#)
			<cfif Arguments.alias NEQ "">
				as #Arguments.alias#
			</cfif>
		</cfoutput>
	</cffunction>

	<cffunction name="enCF" access="public" output="false" returntype="numeric">
		<cfargument name="value" type="numeric" required="true">
		<cfargument name="commas" type="boolean" required="no" default="no">
		<!--- Formatea el valor numérico al número de decimales del parametro 545, y a la vez lo redondea para cálculos --->
		<cfreturn numberFormat(Arguments.value,GvarPrecioU_CFmask)>
	</cffunction>

	<cffunction name="enCF_COMAS" access="public" output="false" returntype="string">
		<cfargument name="value" type="numeric" required="true">
		<!--- Formatea el valor numérico al número de decimales del parametro 545, y a la vez lo redondea para cálculos --->
		<cfreturn numberFormat(Arguments.value,",#GvarPrecioU_CFmask#")>
	</cffunction>

	<cffunction name="enCF_RPT" access="public" output="false" returntype="string">
		<cfargument name="value" type="numeric" required="true">
		<!--- Formatea el valor numérico al número de decimales del parametro 546, y a la vez lo redondea para cálculos --->
		<cfreturn numberFormat(Arguments.value,GvarPrecioU_CFmask_RPT)>
	</cffunction>

	<cffunction name="inputNumber" access="public" output="true" returntype="void">
		<cfargument name="name"		type="string"	required="true">
		<cfargument name="value" 	type="string"	required="no" default="">
		<cfargument name="tabIndex" type="string"	required="no" default="">
		<cfargument name="readOnly"	type="boolean"	required="no" default="no"> 
		<cfargument name="class" 	type="string"	required="no" default="">
		<cfargument name="style" 	type="string"	required="no" default="">
		<cfargument name="onBlur" 	type="string"	required="no" default="">
		<cfargument name="onChange" type="string"	required="no" default="">
		<cfargument name="decimal"  type="numeric"	required="no" default="#GvarPrecioU_dec#">

		<cfif Arguments.value EQ "">
			<cfset Arguments.value = 0>
		</cfif>
		<cfparam name="Arguments.value" type="numeric">
		
		<cf_inputNumber	
						name	 = "#Arguments.name#" 
						value	 = "#enCF(Arguments.value)#"
						tabIndex = "#Arguments.tabIndex#"
						readOnly = "#Arguments.readOnly#"
						class	 = "#Arguments.class#"
						style	 = "#Arguments.style#"
						onBlur	 = "#Arguments.onBlur#"
						onChange = "#Arguments.onChange#"

						enteros	 = "#17-GvarPrecioU_dec#" decimales="#Arguments.decimal#" comas="yes"
		>
	</cffunction>

	<cffunction name="maskCF" access="public" output="false" returntype="string">
		<cfreturn GvarPrecioU_CFmask>
	</cffunction>
	<cffunction name="maskRPT" access="public" output="false" returntype="string">
		<cfreturn GvarPrecioU_CFmask_RPT>
	</cffunction>
</cfcomponent>

