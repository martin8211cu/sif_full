<!---
	Textos  
		0-Moneda [OK]
		1-Nombre Empresa[OK]
		2-Nombre Oficina[OK]
		4-Unidad Expresion
		10-Mes: MM
		11-Nombre Mes
		12-Año: YYYY
		13-Año Mes: MM/YYYY
		14-Leyenda Fin Mes
		15-Mes: MMM
		16-Año Mes: MMM/YYYY
		17-Año Mes: YYYY-MM
		18-Inicio Per.Fin Mes
	Datos Predefinidos
		3-Variables
	Saldos Contables
		21-Saldo Inicial[OK]
		22-Débitos Mes
		23-Créditos Mes
		24-Movimientos Mes				
		20-Saldo Final[OK]
		32-Débitos Acum.
		33-Créditos Acum.
		34-Movimientos Acum.
	Movimientos Bancarios">
		25-Flujo de Efectivo en el Mes
	Saldos Contables de Cierres
		35-Saldo Inicial Cierre
		36-Débitos Cierre
		37-Créditos Cierre
		38-Movimientos Cierre
		39-Saldo Final Cierre
	Presupuesto Contable
		40-Presupuesto Contable Ini.
		41-Presupuesto Contable Mes
		42-Presupuesto Contable Fin.
	Saldos de Control de Presupuesto
		50-Control Presupuesto Mes
		51-Control Presupuesto Acum
		52-Control Presupuesto Per.
	Formulación de Presupuesto">
		60-Formulación Presup. Mes
		61-Formulación Presup. Acum
		62-Formulación Presup. Per.
		63-Operaciones Ariméticas ESTAS DEBEN DE EJECUTARSE AL FINAL DESPUE DE QUE LAS PRIMERAS SE HAN CALUCLADO PUES DEPENDEN DE LOS CALCULOS ANTERIORES
--->

<!---Crea la tabla temporal, en la que se Guardara el listado de todos los resultados de las variables que se usaran en los calculos de las formulas--->
        <cf_dbtemp name="Tmp_DRDFormalcion" returnvariable="ListVaribles" datasource="#session.dsn#">
            <cf_dbtempcol name="DRDNombre" 		type="varchar(120)"  mandatory="yes"> 
            <cf_dbtempcol name="Valor" 			type="numeric(18,4)" mandatory="no">
            <cf_dbtempcol name="Ecodigo" 		type="numeric" 		mandatory="yes">
        </cf_dbtemp>

<cf_navegacion name="ERDid">
<cf_templateheader title="Reportes Dinamicos de Contabilidad General ">
	<cfinclude template="/home/menu/pNavegacion.cfm">
	<cf_web_portlet_start border="true" skin="#session.preferences.skin#" tituloalign="center" titulo="Reportes Dinamicos de Contabilidad General">

	<cfquery name="rsReporte"  datasource="#session.dsn#">
      select  ER.ERDid, ER.ERDdesc, ER.ERDmodulo, ER.ERDcodigo, ER.ERDbody
            from EReportDinamic ER
         where ER.Ecodigo = #session.Ecodigo#
         and ER.ERDmodulo = 'CG'
         and ER.ERDid = #form.ERDid#
    </cfquery>
<!---Escojo los valores distintos de operacion arimetica --->
<cfquery name="rsdetalles" datasource="#session.dsn#">
	select ERDid,DRDNombre, AnexoCon, DRDNegativo, AVid,BMUsucodigo, fechaalta,ANHCid, DRDMeses 
      from DReportDinamic
    where ERDid = #form.ERDid#
    	and AnexoCon != 63
 </cfquery>
    <cfloop query="rsdetalles">
        <cfinvoke method="fnCalculaValor" returnvariable="Valor">
                <cfinvokeargument name="Ecodigo" value="#form.ANubicaEcodigo#">
                <cfinvokeargument name="concepto" value="#rsdetalles.AnexoCon#">
            <cfif ANubicaTipo EQ "O">
                <cfinvokeargument name="Ocodigo" value="#form.ANubicaOcodigo#">
            <cfelseif ANubicaTipo EQ "GO">
                <cfinvokeargument name="GOid" 	 value="#form.ANubicaGOid#">
            </cfif>
            <cfif isdefined('form.Mcodigo') and form.Mcodigo NEQ -1>
                <cfinvokeargument name="Mcodigo" value="#form.Mcodigo#">
            </cfif>
                <cfinvokeargument name="Variable" 	value="#rsdetalles.DRDNombre#">
            <cfif LEN(TRIM(rsdetalles.ANHCid))>
                <cfinvokeargument name="ANHCid" 	value="#rsdetalles.ANHCid#">
            </cfif>
            <cfif LEN(TRIM(rsdetalles.DRDMeses))>
                <cfinvokeargument name="DRDMeses" 	value="#rsdetalles.DRDMeses#">
            </cfif>
                <cfinvokeargument name="Periodo" 	value="#form.ACAno#">
                <cfinvokeargument name="Mes" 		value="#form.ACMes#">
                <cfinvokeargument name="Unidad" 	value="#form.ACUnidad#">
        </cfinvoke>
        <cfset rsReporte.ERDbody =  replace(rsReporte.ERDbody,"##"&#rsdetalles.DRDNombre#&"##",valor,"ALL")> 
			<cfif rsdetalles.AnexoCon gt 18>
                <cfquery datasource="#session.dsn#" name="rsInsertVariable">
                    insert into #ListVaribles# (DRDNombre,Valor,Ecodigo)
                        values(
                            <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="60"  	value="#rsdetalles.DRDNombre#">,
                            <cf_jdbcQuery_param cfsqltype="cf_sql_numeric"   			value="#Valor#">,
                            <cf_jdbcQuery_param cfsqltype="cf_sql_numeric"   			value="#session.ecodigo#">
                        )
                </cfquery>
            </cfif>
    </cfloop>

 <cfquery name="rsdetallesOA" datasource="#session.dsn#">
	select ERDid,DRDNombre, AnexoCon, DRDNegativo, AVid,BMUsucodigo, fechaalta,DRDValor
      from DReportDinamic
    where ERDid = #form.ERDid#
    	and AnexoCon = 63
 </cfquery>
 <cfloop query="rsdetallesOA">
	<cfinvoke method="fnCalculaValor" returnvariable="Valor">
			<cfinvokeargument name="Ecodigo" value="#form.ANubicaEcodigo#">
			<cfinvokeargument name="concepto" value="#rsdetallesOA.AnexoCon#">
		<cfif ANubicaTipo EQ "O">
			<cfinvokeargument name="Ocodigo" value="#form.ANubicaOcodigo#">
		<cfelseif ANubicaTipo EQ "GO">
			<cfinvokeargument name="GOid" 	 value="#form.ANubicaGOid#">
		</cfif>
		<cfif isdefined('form.Mcodigo') and form.Mcodigo NEQ -1>
			<cfinvokeargument name="Mcodigo" value="#form.Mcodigo#">
		</cfif>
			<cfinvokeargument name="Variable" 	value="#rsdetallesOA.DRDNombre#">
        <cfif LEN(TRIM(rsdetallesOA.DRDValor))>
			<cfinvokeargument name="DRDValor" 	value="#rsdetallesOA.DRDValor#">
        </cfif>
			<cfinvokeargument name="Periodo" 	value="#form.ACAno#">
			<cfinvokeargument name="Mes" 		value="#form.ACMes#">
			<cfinvokeargument name="Unidad" 	value="#form.ACUnidad#">
	</cfinvoke>
	<cfset rsReporte.ERDbody =  replace(rsReporte.ERDbody,"##"&#rsdetallesOA.DRDNombre#&"##",valor,"ALL")> 
</cfloop>

<cf_htmlreportsheaders
		title="Report" 
		filename="ReportDinamic_#rsReporte.ERDcodigo#.xls" 
		ira="ReportDinamic-sql.cfm?ERDid=#form.ERDid#"
        method="post"
		param="&ERDid=#form.ERDid#">
<input name="ERDid" value="<cfoutput>#form.ERDid#</cfoutput>"  type="hidden"/>
    <cfoutput>
    	#rsReporte.ERDbody#
    </cfoutput>	
	<cf_web_portlet_end>
<cf_templatefooter>
<!------------------------------->
<cffunction name="fnCalculaValor" returntype="any">
	<cfargument name="Ecodigo" 		 		required="no"	type="numeric" 					hint="Empresa">
	<cfargument name="Variable"   			required="yes"  type="string"					hint="variable a Procesar">
	<cfargument name="DataSource" 			required="no"   type="string"				   	hint="Nombre del Datasource">
	<cfargument name="Negativo"    			required="no" 	type="boolean" default="false" 	hint="Expresar los Montos en Negativo">
	<cfargument name="SaldosConvertidos"  	required="yes" 	type="boolean" default="false"  hint="Saldos Convertidos">
	<cfargument name="GOid" 				required="no" 	type="numeric" default="-1" 	hint="Grupo de Oficinas">
	<cfargument name="GEid" 				required="no" 	type="numeric" default="-1" 	hint="Grupo de Empresas">	
	<cfargument name="Ocodigo" 				required="no" 	type="numeric" default="-1" 	hint="Oficinas">
	<cfargument name="Mcodigo" 				required="no" 	type="numeric" default="-1" 	hint="Moneda">
	<cfargument name="ANHCid" 				required="no" 	type="numeric" 					hint="id de la Variable de Homologación">
	<cfargument name="Periodo" 				required="yes" 	type="numeric" 					hint="Periodo">
	<cfargument name="Mes" 					required="yes" 	type="numeric" 					hint="Mes">
	<cfargument name="concepto" 			required="yes" 	type="numeric" 					hint="Concepto a calcular">
	<cfargument name="Unidad" 				required="yes" 	type="numeric" default="1"		hint="Unidad de Expresion">
    <cfargument name="DRDValor"			 	required="no" 	type="string"  default=""		hint="variable de Formulacion">
	<cfargument name="DRDMeses" 			required="no" 	type="numeric" 					hint="Meses que se restaran">

	<cfif not isdefined('Arguments.DataSource')>
		<cfset Arguments.DataSource = session.dsn>
	</cfif>
    <cfif not isdefined('Arguments.Ecodigo')>
		<cfset Arguments.Ecodigo = session.Ecodigo>
	</cfif>
	<!---►►0-Moneda◄◄--->
	<cfif Arguments.concepto EQ 0>
		<cfif isdefined('Arguments.Mcodigo') and Arguments.Mcodigo neq -1>
			<cfquery name="Monedas" DataSource="#Arguments.DataSource#">
				select Mnombre
					from Monedas
				where Mcodigo = #Arguments.Mcodigo#
			</cfquery>
			<cfset valor = Monedas.Mnombre>
		<cfelse>
			<cfset valor = "Todas las monedas">
		</cfif>
	<!---►►1-Empresa◄◄--->
	<cfelseif Arguments.concepto EQ 1>			
		<cfquery name="Empresa" DataSource="#Arguments.DataSource#">
			<cfif Arguments.GEid NEQ -1>
				select GEnombre as Edescripcion 
				  from AnexoGEmpresa 
				 where GEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GEid#">
			<cfelse>
				select Edescripcion 
				  from Empresas 
				 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			</cfif>
		</cfquery>
		<cfset valor = Trim(Empresa.Edescripcion)>
	<cfelseif Arguments.concepto EQ 2>
		<cfif isdefined('Arguments.GOid')  and Arguments.GOid neq -1>
				<cfquery name="Oficinas" DataSource="#Arguments.DataSource#">
				select GOnombre as Odescripcion 
				  from AnexoGOficina
				 where GOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.GOid#">
				</cfquery>
				<cfset valor = "Grupo Oficinas: "&Oficinas.Odescripcion>
		<cfelseif isdefined('Arguments.Ocodigo') and Arguments.Ocodigo neq -1>
				<cfquery name="Oficinas" DataSource="#Arguments.DataSource#">
				select Odescripcion 
				  from Oficinas 
				 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				   and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ocodigo#">
				</cfquery>	
				<cfset valor = "Oficina: " & Oficinas.Odescripcion>
		<cfelse>
				<cfset valor = "Todas las Oficinas">
		</cfif>
	<!---►►Saldos Contables◄◄--->
	<cfelseif listfind("20,21,32",Arguments.concepto)>
	
		<cfif isdefined('Arguments.DRDMeses') and Arguments.DRDMeses NEQ 0>
            <cfset LvarFecha = dateadd('m',-Arguments.DRDMeses,CreateDate(form.ACano,form.ACmes,1))>
       		<cfset Arguments.Periodo = datepart('YYYY',LvarFecha)>
            <cfset Arguments.Mes = datepart('M',LvarFecha)>
        </cfif>

       	<cfset fnCrearTablasTemporales()> 
		<cfinvoke method="fnProcesarTablasTemporales">
			<cfinvokeargument name="tipocuenta" 		value="Totales">
			<cfinvokeargument name="Variable" 			value="#Arguments.Variable#">
            <cfif isdefined('Arguments.ANHCid')>
			<cfinvokeargument name="ANHCid" 			value="#Arguments.ANHCid#">
            </cfif>
			<cfinvokeargument name="Periodo" 			value="#Arguments.Periodo#">
			<cfinvokeargument name="mes" 				value="#Arguments.Mes#">
			<cfinvokeargument name="concepto" 			value="#Arguments.concepto#">
			<cfinvokeargument name="Negativo" 			value="#Arguments.Negativo#">
			<cfinvokeargument name="SaldosConvertidos" 	value="#Arguments.SaldosConvertidos#">
			<cfinvokeargument name="GOid" 				value="#Arguments.GOid#">
			<cfinvokeargument name="GEid" 				value="#Arguments.GEid#">
			<cfinvokeargument name="Ocodigo" 			value="#Arguments.Ocodigo#">
			<cfinvokeargument name="Mcodigo" 			value="#Arguments.Mcodigo#">
			<cfinvokeargument name="Ecodigo" 			value="#Arguments.Ecodigo#">			
		</cfinvoke>

		<cfinvoke method="fnCalcularContabilidad" returnvariable="Valor">
			<cfinvokeargument name="concepto" 			value="#Arguments.concepto#">
			<cfinvokeargument name="Variable" 			value="#Arguments.Variable#">
			<cfinvokeargument name="Unidad" 			value="#Arguments.Unidad#">
			<cfinvokeargument name="Negativo" 			value="#Arguments.Negativo#">
			<cfinvokeargument name="SaldosConvertidos" 	value="#Arguments.SaldosConvertidos#">
			<cfinvokeargument name="GOid" 				value="#Arguments.GOid#">
			<cfinvokeargument name="Ocodigo" 			value="#Arguments.Ocodigo#">
			<cfinvokeargument name="Mcodigo" 			value="#Arguments.Mcodigo#">
		</cfinvoke>
     <!---unidad de expresion--->
	<cfelseif Arguments.concepto EQ 4>
    	<cfif  form.ACunidad eq  1>
        	<cfset valor ="unidad" >
        <cfelseif  form.ACunidad eq 1000>
        	<cfset valor ="miles">
        <cfelseif form.ACunidad eq 1000000>
        	<cfset valor ="millones">
        </cfif>
      <!---Año--->
	<cfelseif Arguments.concepto EQ 12>
    	<cfif isdefined('Arguments.DRDMeses') and Arguments.DRDMeses NEQ 0>
            <cfset LvarFecha = dateadd('m',-Arguments.DRDMeses,CreateDate(form.ACano,form.ACmes,1))>
       		<cfset valor = datepart('YYYY',LvarFecha)>
        <cfelse>
    		<cfset valor = form.ACano>
        </cfif>
    <!---Operaciones Ariméticas--->
	<cfelseif Arguments.concepto EQ 63>
    	<cfif len(trim(Arguments.DRDValor)) lt 1 >
        	<cfset valor =0>
        <cfelse>
        	<cfset formula = Arguments.DRDValor>
            <cfset variblesNuevas = ArrayNew(1)>
            <cfset varOperacion = ArrayNew(1)>
            <cfset variable="">
            <cfset inicia =true>
        	<cfset contOP=1> <cfset cont =1>
            <!---Paso 1 obtener el nombre de las variables y el valor de ellas--->
        	<cfloop from="0" to="#LEN(formula)-1#" index="i">
            	<cfset ch = formula.charAt(i)>
                <cfif ch eq '+' or  ch eq '-' or ch eq '/' or  ch eq '*' >
                 	<cfquery datasource="#session.dsn#" name="rsVariabExistente">
                        select * from  #ListVaribles# 
                        where DRDNombre = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" 	value="#variable#">
                    </cfquery>

                    	<cfset variblesNuevas[cont] = rsVariabExistente.Valor>
                         <cfset cont = cont+1>
      
                 	<cfset variable="">
                    <cfset varOperacion[contOP] = ch &''>
                    <cfset contOP = contOP+1>
                <cfelseif inicia eq true>
                	<cfset variable = variable & ch >
                </cfif>
                <cfif LEN(formula)-1 eq i >
                	<cfquery datasource="#session.dsn#" name="rsVariabExistente">
                        select * from  #ListVaribles# 
                        where DRDNombre = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" 	value="#variable#">
                    </cfquery>
                	<cfset variblesNuevas[cont]= rsVariabExistente.Valor>
                </cfif>
           <!---<cfif ch eq '+' or  ch eq '-' or ch eq '/' or  ch eq '*' >
                 	<cfset formulaGato=formulaGato &'##'& ch  &'##'>
                    <cfset inicia = false>
                <cfelseif inicia eq true>
                	<cfset formulaGato=formulaGato &'##'& ch >
                    <cfset inicia = false>
                <cfelseif  i eq LEN(formula)-1>
                	<cfset formulaGato=formulaGato & ch & '##'>
                <cfelse>
                	<cfset formulaGato=formulaGato & ch >
                </cfif>--->
            </cfloop>
            <!---Paso 2  realizar los calulos --->
			<cfset resultadoFinal =0>
			<cfloop from="1" to="#cont-1#" index="i">  
              	<cfif trim(varOperacion[i]) eq '+'>
                	<cfset resultado = variblesNuevas[i] + variblesNuevas[i+1] >
                <cfelseif trim(varOperacion[i]) eq '-'>
                	<cfset resultado = variblesNuevas[i] - variblesNuevas[i+1] >
                <cfelseif trim(varOperacion[i]) eq '*'>
                	<cfset resultado = variblesNuevas[i] * variblesNuevas[i+1] >
                <cfelseif trim(varOperacion[i]) eq '/'>
                	<cfset resultado = variblesNuevas[i] / variblesNuevas[i+1] >
                </cfif>
                <cfset resultadoFinal = resultadoFinal + resultado>
             </cfloop>     
            <cfset valor =	resultado>
           
        </cfif>
	<cfelse>
		<cfthrow message="Tipo no implementado (#Arguments.concepto#)">
	</cfif>
	<cfreturn valor>
</cffunction>
<!------------------------------------->
<cffunction name="fnSaldoContabilidad" output="false" access="public" returntype="string">
	<cfargument name="Alias"   	required="yes">
	<cfargument name="Concepto" required="yes">
	<cfargument name="Mcodigo"  required="yes" default="-1" hint="Moneda">
	<cfargument name="ACmLocal" required="yes" default="0"  hint="Expresado en Moneda Local">
	<cfargument name="GEid" 	required="yes" default="-1" hint="">


	<cfif Arguments.concepto  EQ 40>
		<cfreturn "#Arguments.Alias#.SPinicial">
	<cfelseif Arguments.concepto  EQ 41>
		<cfreturn "#Arguments.Alias#.MLmonto">
	<cfelseif Arguments.concepto  EQ 42>
		<cfreturn "#Arguments.Alias#.SPfinal">
	<cfelseif Arguments.Mcodigo EQ -1 or Arguments.ACmLocal EQ "1">
		<cfif Arguments.concepto EQ 20>
			<cfif Arguments.GEid EQ -1>
				<cfreturn "#Arguments.Alias#.SLinicial + #Arguments.Alias#.DLdebitos - #Arguments.Alias#.CLcreditos">
			<cfelse>
				<cfreturn "#Arguments.Alias#.SLinicialGE + #Arguments.Alias#.DLdebitos - #Arguments.Alias#.CLcreditos">
			</cfif>
		<cfelseif (Arguments.concepto  EQ 21 OR Arguments.concepto EQ 35 OR Arguments.concepto EQ 39)>
			<cfif Arguments.GEid EQ -1>
				<cfreturn "#Arguments.Alias#.SLinicial">
			<cfelse>
				<cfreturn "#Arguments.Alias#.SLinicialGE">
			</cfif>
		<cfelseif (Arguments.concepto  EQ 22 or Arguments.concepto EQ 32 OR Arguments.concepto EQ 36)>
			<cfreturn "#Arguments.Alias#.DLdebitos">
		<cfelseif (Arguments.concepto  EQ 23 or Arguments.concepto EQ 33 OR Arguments.concepto EQ 37)>
			<cfreturn "#Arguments.Alias#.CLcreditos">
		<cfelseif (Arguments.concepto  EQ 24 or Arguments.concepto EQ 34 OR Arguments.concepto EQ 38)>
			<cfreturn "#Arguments.Alias#.DLdebitos - #Arguments.Alias#.CLcreditos">
		</cfif>
	<cfelse>
		<cfif Arguments.concepto EQ 20>
			<cfif Arguments.GEid EQ -1>
				<cfreturn "#Arguments.Alias#.SOinicial + #Arguments.Alias#.DOdebitos - #Arguments.Alias#.COcreditos">
			<cfelse>
				<cfreturn "#Arguments.Alias#.SOinicialGE + #Arguments.Alias#.DOdebitos - #Arguments.Alias#.COcreditos">
			</cfif>
		<cfelseif (Arguments.concepto  EQ 21 OR Arguments.concepto EQ 35 OR Arguments.concepto EQ 39)>
			<cfif Arguments.GEid EQ -1>
				<cfreturn "#Arguments.Alias#.SOinicial">
			<cfelse>
				<cfreturn "#Arguments.Alias#.SOinicialGE">
			</cfif>
		<cfelseif (Arguments.concepto  EQ 22 or Arguments.concepto EQ 32 OR Arguments.concepto EQ 36)>
			<cfreturn "#Arguments.Alias#.DOdebitos">
		<cfelseif (Arguments.concepto  EQ 23 or Arguments.concepto EQ 33 OR Arguments.concepto EQ 37)>
			<cfreturn "#Arguments.Alias#.COcreditos">
		<cfelseif (Arguments.concepto  EQ 24 or Arguments.concepto EQ 34 OR Arguments.concepto EQ 38)>
			<cfreturn "#Arguments.Alias#.DOdebitos - #Arguments.Alias#.COcreditos">
		</cfif>
	</cfif>
</cffunction>
<!---------------------------------------------------------------------->
<cffunction name="fnCalcularContabilidad" output="false" access="public">
	<cfargument name="Concepto" 			required="yes"  type="string" hint="concepto a Calcular">
	<cfargument name="DataSource" 			required="no" 	type="string" hint="Nombre del Data Source">
	<cfargument name="Negativo"    			required="no" 	type="boolean" default="false" hint="Expresar los Montos en Negativo">
	<cfargument name="SaldosConvertidos"  	required="yes" 	type="boolean" default="false">
	<cfargument name="GOid" 				required="no" 	type="numeric" default="-1" hint="Grupo de Oficinas">
	<cfargument name="Ocodigo" 				required="no" 	type="numeric" default="-1" hint="Oficinas">
	<cfargument name="Mcodigo" 				required="no" 	type="numeric" default="-1" hint="Moneda">
	<cfargument name="Variable"				required="yes" 	type="string"    hint="nombre de la variables a Calcular">
	<cfargument name="Unidad"				required="no" 	type="numeric" default="1"   hint="Unidad en que esta expresado el reporte">
	
	
	<cfif not isdefined('Arguments.DataSource') and isdefined('session.dsn')>
		<cfset Arguments.DataSource = session.dsn>
	</cfif>

	
	<cfset valor = 0 >
	
	<cfif Arguments.Negativo EQ 1>
		<cfset LvarSigno = "-">
	<cfelse>
		<cfset LvarSigno = "">
	</cfif>
	<cfquery name="rsDatos" DataSource="#Arguments.DataSource#">
		<cfif Arguments.SaldosConvertidos>
		select coalesce(#LvarSigno# sum( d.AnexoSigno * coalesce(#fnSaldoContabilidad("ss",Arguments.Concepto)#, #fnSaldoContabilidad("s",Arguments.Concepto)#) ) , 0.00) as total
		<cfelse>
		select coalesce(#LvarSigno# sum( d.AnexoSigno * (#fnSaldoContabilidad("s",Arguments.Concepto)#) ), 0.00) as total
		</cfif>
		from #tmpCuentasReport# d
		<cfif Arguments.concepto LT 35><!---menor 35--->
				inner join SaldosContables s
				<cfif Arguments.SaldosConvertidos>
					left join SaldosContablesConvertidos ss
					  on ss.Ccuenta		= s.Ccuenta
					 and ss.Speriodo	= s.Speriodo
					 and ss.Smes		= s.Smes
					 and ss.Ecodigo		= s.Ecodigo	
					 and ss.Ocodigo		= s.Ocodigo
					 and ss.McodigoOri	= s.Mcodigo	
					 and ss.B15			= #LvarB15#
				</cfif>
		<cfelseif concepto LT 40>
			<cfif Arguments.SaldosConvertidos>
				<cfthrow message="No se puede usar Saldos de Cierres en Anexos Convertidos, Rango: #AnexoRan#">
			</cfif>
			inner join SaldosContablesCierre s
		<cfelse>
			<cfif Arguments.SaldosConvertidos>
				<cfthrow message="No se puede usar Presupuesto Contable en Anexos Convertidos, Rango: #AnexoRan#">
			</cfif>
			inner join SaldosContablesP s
		</cfif>
			  on s.Ccuenta	= d.cuentaID
			 and s.Speriodo = d.Speriodo
			 and s.Smes     = d.Smes
			 and s.Ecodigo	= d.Ecodigo	
		<cfif Arguments.concepto GTE 35 AND Arguments.concepto LTE 39>
			<cfif Arguments.GEid EQ -1>
			 and s.ECtipo	= 1
			<cfelse>
			 and s.ECtipo	= 11
			</cfif>
		</cfif>
		<cfif Arguments.GOid neq "-1" OR Arguments.Ocodigo neq "-1">
			 and s.Ocodigo	= d.Ocodigo
		</cfif>
		<cfif Arguments.Mcodigo NEQ -1>
			<cfif Arguments.concepto LT 40>
				and s.Mcodigo = d.Mcodigo
			<cfelse>
				and s.Mcodigo = -1
			</cfif>
		</cfif>
		where d.Variable = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.Variable#">
	</cfquery>

	<cfif isdefined("rsDatos.total") and rsDatos.recordcount GT 0>
		<cfreturn fnExpresarValor (rsDatos.total,Arguments.Unidad)>
	<cfelse>
		<cfreturn "0.00">
	</cfif>
</cffunction>
<!--------------------------------------------------------->
<cffunction name="fnCrearTablasTemporales" output="false" access="private">
	<cfargument name="DataSource" 	required="no" 	type="string" hint="Nombre del Data Source">

	<cfif not isdefined('Arguments.DataSource') and isdefined('session.dsn')>
		<cfset Arguments.DataSource = session.dsn>
	</cfif>
	<cf_dbtemp name="tmpFormatosReport_V1" returnvariable="tmpFormatosReport" datasource="#Arguments.DataSource#">
		<cf_dbtempcol name="Variable" 		type="varchar(60)">
		<cf_dbtempcol name="Ecodigo" 		type="integer">
		<cf_dbtempcol name="Ocodigo"		type="integer">
		<cf_dbtempcol name="Mcodigo" 		type="numeric">
		<cf_dbtempcol name="Cmayor"			type="char(4)">
		<cf_dbtempcol name="AnexoCelFmt"	type="varchar(100)">
		<cf_dbtempcol name="AnexoSigno"		type="integer">
		<cf_dbtempcol name="Anexolk"		type="integer">
		<cf_dbtempcol name="AnexoCelMov"	type="char(1)">
		<cf_dbtempcol name="PCDcatid"		type="numeric">
		<cf_dbtempindex cols="Variable,Anexolk,AnexoCelMov">
	</cf_dbtemp>
	
	<cf_dbtemp name="tmpCuentasReport_V1" returnvariable="tmpCuentasReport" datasource="#Arguments.DataSource#">
		<cf_dbtempcol name="Variable" 		type="varchar(60)">
		<cf_dbtempcol name="Ecodigo" 	    type="integer">
		<cf_dbtempcol name="Ocodigo"		type="integer">
		<cf_dbtempcol name="Mcodigo" 		type="numeric">
		<cf_dbtempcol name="cuentaID" 		type="numeric">
		<cf_dbtempcol name="Speriodo" 		type="integer">
		<cf_dbtempcol name="Smes"		 	type="integer">
		<cf_dbtempcol name="AnexoSigno" 	type="integer">
		<cf_dbtempcol name="CVid" 			type="numeric" mandatory="no">
		<cf_dbtempindex cols="Variable">
	</cf_dbtemp>
	
	
</cffunction>
<cffunction name="fnProcesarTablasTemporales" output="false" access="private">
	<cfargument name="Variable"   			required="yes"  type="string"					hint="variable a Procesar">
	<cfargument name="tipocuenta" 			required="yes"  type="string">
	<cfargument name="DataSource" 			required="no"   type="string"				   	hint="Nombre del Datasource">
	<cfargument name="Negativo"    			required="no" 	type="boolean" default="false" 	hint="Expresar los Montos en Negativo">
	<cfargument name="SaldosConvertidos"  	required="yes" 	type="boolean" default="false">
	<cfargument name="GOid" 				required="no" 	type="numeric" default="-1" 	hint="Grupo de Oficinas">
	<cfargument name="GEid" 				required="no" 	type="numeric" default="-1" 	hint="Grupo de Empresas">	
	<cfargument name="Ocodigo" 				required="no" 	type="numeric" default="-1" 	hint="Oficinas">
	<cfargument name="Mcodigo" 				required="no" 	type="numeric" default="-1" 	hint="Moneda">
	<cfargument name="Ecodigo" 				required="no" 	type="numeric" hint="Empresa">	
	<cfargument name="ANHCid" 				required="no" 	type="numeric" default="-1"		hint="id de la Variable de Homologación">
	<cfargument name="Periodo" 				required="yes" 	type="numeric" hint="Periodo">
	<cfargument name="Mes" 					required="yes" 	type="numeric" hint="Mes">
	<cfargument name="concepto" 			required="yes" 	type="numeric" hint="Concepto a calcular">
	
	
	<!---►►Se busca el DataSource de session en caso de que no se envie◄◄--->
	<cfif not isdefined('Arguments.DataSource') and isdefined('session.dsn')>
		<cfset Arguments.DataSource = session.dsn>
	</cfif>
	<!---►►Se busca la empresa de session en caso de que no se envie◄◄--->
	<cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
		<cfset Arguments.Ecodigo = session.Ecodigo>
	</cfif>	
	<!---►►Se insertan cada una de las cuentas, que corresponden a la variables de homologacion◄◄--->
	<cfquery DataSource="#Arguments.DataSource#">
			insert into #tmpFormatosReport# 
				(Variable,Ecodigo, Ocodigo, Mcodigo,Cmayor, AnexoCelFmt,AnexoSigno, Anexolk, AnexoCelMov, PCDcatid)
			select 
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.Variable#">, 
				<cfif Arguments.GEid NEQ "-1">   <cfthrow message="Grupo de Empresa no implementado">
					ge.Ecodigo, <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null">,
						<cfif Arguments.Mcodigo NEQ -1 and Arguments.concepto LT 40>
							(select mm.Mcodigo 
								  from Monedas mm
								 where mm.Ecodigo	=  ge.Ecodigo 
								   and mm.Miso4217	= '#LvarGEmonedaCalculo#')
						<cfelse>
							-1
						</cfif>,
				<cfelseif Arguments.GOid NEQ "-1">
					go.Ecodigo, go.Ocodigo, #Arguments.Mcodigo#,
				<cfelse>
					#Arguments.Ecodigo#, #Arguments.Ocodigo#, #Arguments.Mcodigo#,
				</cfif>
					d.Cmayor, d.AnexoCelFmt, d.AnexoSigno, 
					1, 'S', <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
			  from ANhomologacionFmts d
				<cfif Arguments.GEid NEQ -1>
					inner join AnexoGEmpresaDet ge 
					   on ge.GEid = #Arguments.GEid#
				<cfelseif Arguments.GOid NEQ "-1">
					inner join AnexoGOficinaDet go 
					   on go.GOid = #Arguments.GOid#
				</cfif>
			 where d.ANHCid = #Arguments.ANHCid#
		</cfquery>
	
		<!---►►AJUSTA LA MASCARA FINANCIERA A CONTABLE O PRESUPUESTO◄◄--->
		<cfset LvarFormatoPresupuesto = (arguments.tipocuenta EQ "Presupuesto") OR (arguments.tipocuenta EQ "Formulacion")>
		<cfset LvarFormatoFinanciero  = (arguments.tipocuenta EQ "Financiero")>
		<cfif NOT LvarFormatoFinanciero>
			<cftry>
				<cfquery name="rsSQL" DataSource="#Arguments.DataSource#">
					select distinct c.Ecodigo, c.Cmayor, m.PCEMid, m.PCEMformato, m.PCEMformatoC, m.PCEMformatoP
					  from #tmpFormatosReport#  c
						left join CPVigencia v
							left join PCEMascaras m
								on m.PCEMid = v.PCEMid
						 on v.Ecodigo	= c.Ecodigo
						and v.Cmayor	= c.Cmayor
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CREATEDATE(Arguments.Periodo,Arguments.Mes,1)#"> between CPVdesde and CPVhasta
					where c.Variable = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.Variable#">
					<cfif LvarFormatoPresupuesto>
					  and m.PCEMformato <> m.PCEMformatoP
					<cfelse>
					  and m.PCEMformato <> m.PCEMformatoC
					</cfif>
				</cfquery>
			<cfcatch type="any">
				<cfthrow message="#Arguments.Variable#: #cfcatch.Message# #cfcatch.Detail#">
			</cfcatch>
			</cftry>
			<cfloop query="rsSQL">
				<cfset LvarEcodigo	= rsSQL.Ecodigo>
				<cfset LvarCmayor	= rsSQL.Cmayor>
				<cfquery name="rsNiv" DataSource="#Arguments.DataSource#">
					select PCNlongitud, PCNcontabilidad, PCNpresupuesto
					  from PCNivelMascara n
					where PCEMid = #rsSQL.PCEMid#
					order by PCNid
				</cfquery>
				<cf_dbfunction name="string_part" args="AnexoCelFmt;1;4" returnvariable="LvarSubstituir" delimiters=";">
				<cfset LvarPto=5>
				<cfloop query="rsNiv">
					<cf_dbfunction name="string_part" args="AnexoCelFmt;#LvarPto#;#rsNiv.PCNlongitud+1#" returnvariable="LvarSubstr" delimiters=";">
					<cfif LvarFormatoPresupuesto>
						<cfif rsNiv.PCNpresupuesto EQ 1>
							<cf_dbfunction name="concat" args="#LvarSubstituir#;#LvarSubstr#" returnvariable="LvarSubstituir" delimiters=";">
						</cfif>
					<cfelse>
						<cfif rsNiv.PCNcontabilidad EQ 1>
							<cf_dbfunction name="concat" args="#LvarSubstituir#;#LvarSubstr#" returnvariable="LvarSubstituir" delimiters=";">
						</cfif>
					</cfif>
					<cfset LvarPto=LvarPto+rsNiv.PCNlongitud+1>
				</cfloop>
				<cf_dbfunction name="string_find" args="AnexoCelFmt,'%'" returnvariable="LvarFind">
				<cfset LvarFind = "case when #LvarFind# > 0 then '%' else rtrim(' ') end">
				<cf_dbfunction name="concat" args="#LvarSubstituir#;#LvarFind#" returnvariable="LvarSubstituir" delimiters=";">			
				<cf_dbfunction name="sreplace" args="#LvarSubstituir#;'%%';'%'" returnvariable="LvarSubstituir" delimiters=";">
				
				<cfquery name="rsNiv" DataSource="#Arguments.DataSource#">
					update #tmpFormatosReport#
					   set AnexoCelFmt = #preservesinglequotes(LvarSubstituir)#
					 where Ecodigo	= #LvarEcodigo#
					   and Cmayor	= '#Cmayor#'
				</cfquery>
			</cfloop>
		</cfif>
		<!---►►Buscar Cuentas de UltimoNivel : c.formato like d.AnexoCelFmt + '%' AND c.movimiento = 'S'◄◄--->
		<cftransaction isolation="read_uncommitted">
			<cfquery DataSource="#Arguments.DataSource#">
				insert into #tmpCuentasReport# 
					(
						Variable, 
						Ecodigo, Ocodigo, Mcodigo,
						Speriodo, Smes,
						cuentaID,
						AnexoSigno
						<cfif arguments.tipocuenta EQ "Formulacion">
							,CVid
						</cfif>
					)
				select 	DISTINCT
						d.Variable, 
						d.Ecodigo, d.Ocodigo, d.Mcodigo,
						#Arguments.Periodo#,   #Arguments.Mes#,   
						<cfif Arguments.tipoCuenta EQ "Presupuesto">
							c.CPcuenta
						<cfelseif arguments.tipocuenta EQ "Formulacion">
							c.CVPcuenta
						<cfelseif arguments.tipocuenta EQ "Financiero">
							c.CFcuenta
						<cfelse>
							c.Ccuenta
						</cfif>, 
						d.AnexoSigno
						<cfif arguments.tipocuenta EQ "Formulacion">
							,c.CVid
						</cfif>
				  from #tmpFormatosReport# d
				<cfif arguments.tipocuenta EQ "Presupuesto">
					inner join CPresupuesto c
						inner join CPVigencia v
						 on v.Ecodigo	= c.Ecodigo
						and v.Cmayor	= c.Cmayor
						and v.CPVid		= c.CPVid
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CREATEDATE(Arguments.Periodo,Arguments.Mes,1)#"> between CPVdesde and CPVhasta
					 on c.Ecodigo  = d.Ecodigo
					and c.Cmayor   = d.Cmayor
					and c.CPmovimiento = 'S'
					and <cf_dbfunction name="like" args="c.CPformato , d.AnexoCelFmt">
				<cfelseif Arguments.tipocuenta EQ "Formulacion">
					inner join CVPresupuesto c
						inner join ANformulacionVersion f
							inner join CPresupuestoPeriodo p
							 on p.CPPid	= f.CPPid
							and #Arguments.Periodo *100+Arguments.Mes# between p.CPPanoMesDesde and p.CPPanoMesHasta
						and f.ANFid = #Arguments.ANFid#
						 on f.CVid 	= c.CVid
					 on c.Ecodigo   = d.Ecodigo
					and <cf_dbfunction name="like" args="c.CPformato , d.AnexoCelFmt">
					and c.CVid	= 
						(
							select max(CVid)
							  from CVPresupuesto
							 where Ecodigo		= c.Ecodigo
							   and CVid			= f.CVid
							   and Cmayor		= c.Cmayor
							   and CPformato	= c.CPformato
						)
				<cfelseif arguments.tipocuenta EQ "Financiero">
					inner join CFinanciera c
					 on <cf_dbfunction name="like" args="c.CFformato , d.AnexoCelFmt">
					and c.CFformato 	<> c.Cmayor
					and c.Ecodigo  		= d.Ecodigo
					and c.Cmayor		= d.Cmayor
					and c.CFmovimiento 	= 'S'
				<cfelse>
					inner join CContables c
					 on c.Cmayor 		= d.Cmayor
					and c.Cmovimiento 	= 'S'
					and c.Ecodigo  		= d.Ecodigo
					and <cf_dbfunction name="like" args="c.Cformato , d.AnexoCelFmt">
					and c.Cformato 		<> c.Cmayor
				</cfif>
				 where d.Variable  = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.Variable#">
				   and d.Anexolk     = 1
				   and d.AnexoCelMov <> 'N'
			</cfquery>
		</cftransaction>
		<!--- 
				Se tiene el control de que cuando son Conceptos de Control de Presupuesto o Formulación o flujo Efectivo
				solo procesen Cuentas de Ultimo Nivel
				siempre termina con %
				por tanto, siempre anexolk = 1
		 --->
		<cfif LvarFormatoPresupuesto OR LvarFormatoFinanciero>
			<cftransaction isolation="read_uncommitted">
				<cfquery name="rsSQL" DataSource="#Arguments.DataSource#">
					select count(1) as cantidad
					  from #tmpVariables# d
					 where d.Variable  = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.Variable#">
					   and (d.AnexoCelMov = 'N' or d.Anexolk <> 1)
				</cfquery>
			</cftransaction>
			<cfif LvarFormatoFinanciero AND rsSQL.cantidad GT 0>
				<cfthrow message="No se permite procesar Cuentas para Flujo de Efectivo que no sean a último nivel, Rango: #AnexoRan#">
			</cfif>
			<cfif rsSQL.cantidad GT 0>
				<cfthrow message="No se permite procesar Cuentas de Presupuesto que no sean a último nivel, Rango: #AnexoRan#">
			</cfif>
		<cfelse>
			<!--- Buscar Ccuentas para Anexolk = 0 : c.Cformato = d.AnexoCelFmt --->
			<cftransaction isolation="read_uncommitted">
				<cfquery DataSource="#Arguments.DataSource#">
					insert into #tmpCuentasReport# 
						(
							Variable, 
							Ecodigo, Ocodigo, Mcodigo,
							Speriodo, Smes,
							cuentaID,
							AnexoSigno
						)
					select 	DISTINCT
							d.Variable, 
							d.Ecodigo, d.Ocodigo, d.Mcodigo,
							#Arguments.Periodo#,   #Arguments.Mes#,   
							c.Ccuenta, 
							d.AnexoSigno
					  from #tmpFormatosReport# d
						inner join CContables c
						 on c.Ecodigo  = d.Ecodigo
						and c.Cformato = d.AnexoCelFmt
					 where d.Variable = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.Variable#">
					   and d.Anexolk    = 0
				</cfquery>
			</cftransaction>
	
			<!--- Buscar Ccuentas para Anexolk = 1 : c.Cformato like d.AnexoCelFmt --->
			<!--- AnexoCelMov = 'N' implica que es de contabilidad --->
			<cftransaction isolation="read_uncommitted">
				<cfquery DataSource="#Arguments.DataSource#">
					insert into #tmpCuentasReport# 
						(
							Variable, 
							Ecodigo, Ocodigo, Mcodigo,
							Speriodo, Smes,
							cuentaID,
							AnexoSigno
						)
					select 	DISTINCT
							d.Variable, 
							d.Ecodigo, d.Ocodigo, d.Mcodigo,
							#Arguments.Periodo#,   #Arguments.Mes#,   
							c.Ccuenta, 
							d.AnexoSigno
					  from #tmpFormatosReport# d
						inner join CContables c
						 on c.Ecodigo  = d.Ecodigo
						and <cf_dbfunction name="like" args="c.Cformato , d.AnexoCelFmt">
					 where d.Variable  = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.Variable#">
					   and d.Anexolk     = 1
					   and d.AnexoCelMov = 'N'
				</cfquery>
			</cftransaction>
	
	
			<!--- Buscar Ccuentas para Anexolk = 2 : c.Cformato like d.AnexoCelFmt por PCDcatid --->
			<!--- AnexoCelMov = 'N' implica que es de contabilidad --->
			<cftransaction isolation="read_uncommitted">
				<cfquery DataSource="#Arguments.DataSource#">
					insert into #tmpCuentasReport# 
						(
							Variable, 
							Ecodigo, Ocodigo, Mcodigo,
							Speriodo, Smes,
							cuentaID,
							AnexoSigno
						)
					select 	DISTINCT
							d.Variable, 
							d.Ecodigo, d.Ocodigo, d.Mcodigo,
							#Arguments.Periodo#,   #Arguments.Mes#,   
							c.Ccuenta, 
							d.AnexoSigno
					  from #tmpFormatosReport# d
						inner join CContables c
						 on c.PCDcatid 	= d.PCDcatid
						and c.Ecodigo  	= d.Ecodigo
						and <cf_dbfunction name="like" args="c.Cformato , d.AnexoCelFmt">
					 where d.Variable = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.Variable#">
					   and d.Anexolk    = 2
					   and d.AnexoCelMov = 'N'
				</cfquery>
			</cftransaction>
	
			<cftransaction isolation="read_uncommitted">
				<cfquery DataSource="#Arguments.DataSource#">
					insert into #tmpCuentasReport# 
						(
							Variable, 
							Ecodigo, Ocodigo, Mcodigo,
							Speriodo, Smes,
							cuentaID,
							AnexoSigno
						)
					select 	DISTINCT
							d.Variable, 
							d.Ecodigo, d.Ocodigo, d.Mcodigo,
							#Arguments.Periodo#,   #Arguments.Mes#,   
							c.Ccuenta, 
							d.AnexoSigno
					  from #tmpFormatosReport# d
						inner join CContables c
						 on c.PCDcatid 		= d.PCDcatid
						and c.Cmayor 		= d.Cmayor
						and c.Cmovimiento 	= 'S'
						and c.Ecodigo  		= d.Ecodigo
						and <cf_dbfunction name="like" args="c.Cformato , d.AnexoCelFmt">
						and c.Cformato 		<> c.Cmayor
					 where d.Variable  = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.Variable#">
					   and d.Anexolk     = 2
					   and d.AnexoCelMov <> 'N'
				</cfquery>
			</cftransaction>
		</cfif>

		<!--- 
			Conceptos Acumulados del periodo (Excepto Control Presupuesto): 
				debe cargar todos los meses del periodo hasta mes actual 
		--->
		<!---<cfif Arguments.concepto GTE 32 and Arguments.concepto LTE 34>
			<cfset sbCargarMesesPer(Arguments.DataSource)>
		</cfif>--->

		<!--- Cargar las cuentas que aceptan movimientos si se requiere procesar por Asientos ( Conceptos Contables ) en la funcion de obtener los valores --->
		<cfif Arguments.tipocuenta eq "Movimientos">
			<cfquery DataSource="#Arguments.DataSource#">
				insert into #tmpCuentasReport# 
				(
					Variable, 
					Ecodigo, Ocodigo, Mcodigo,
					Speriodo, Smes,
					cuentaID,
					AnexoSigno
				)
				select
					t.Variable, 
					t.Ecodigo, t.Ocodigo, t.Mcodigo,
					t.Speriodo, t.Smes,
					cu.Ccuenta,
					t.AnexoSigno
				from #tmpCuentasReport# t
					inner join PCDCatalogoCuenta cu
					 on cu.Ccuentaniv = t.cuentaID
				where cu.Ccuenta <> t.cuentaID 
			</cfquery>
		</cfif>

		<cfif Arguments.concepto GTE 35 AND Arguments.concepto LTE 39>
			<!--- Verificar que sólo se utilicen cuentas de Resultados o de Utilidad --->
			<cftransaction isolation="read_uncommitted">
			<cfquery name="rsCuentaUtilidad" datasource="#Arguments.DataSource#">
				select distinct Pvalor 
				  from Parametros 
				<cfif Arguments.GEid NEQ -1>
				 where exists 
						(
							select 1 
							  from AnexoGEmpresaDet ge 
							 where GEid		= #Arguments.GEid#
							   and Ecodigo	= Parametros.Ecodigo
						)
				<cfelse>
				 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEcodigo#">
				</cfif>
				   and Pcodigo = 300
			</cfquery>
			<cfif rsCuentaUtilidad.recordcount EQ 0 or len(rsCuentaUtilidad.Pvalor) EQ 0>
				<cfthrow message="No ha definido la Cuenta de Utilidad">
			</cfif>

			<cfquery name="rsSQL" DataSource="#Arguments.DataSource#">
				select distinct c.Cmayor
				  from #tmpCuentasReport# d
					inner join CContables c
					 on c.Ccuenta  = d.cuentaID
					inner join CtasMayor m
					 on m.Ecodigo = c.Ecodigo
					and m.Cmayor  = c.Cmayor
				 where d.Variable = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.Variable#">
				   and m.Ctipo NOT in ('I','G')
				   and c.Ccuenta not in (#valueList(rsCuentaUtilidad.Pvalor)#)
			</cfquery>
			<cfif rsSQL.recordCount GT 0>
				<cfthrow message="Solo se puede usar Saldos de Cierres con cuentas de Resultado o de Utilidad: Rango: #AnexoRan#, Ctas: #valueList(rsSQL.Cmayor)#">
			</cfif>
			</cftransaction>
		</cfif>
</cffunction>
<cffunction name="fnExpresarValor" returntype="string">
	<cfargument name="Valor"  required="yes">
	<cfargument name="Unidad" required="yes">
	
	<cfif Arguments.Valor EQ "" or Arguments.Valor EQ 0>
		<cfreturn "0.00">
	<cfelseif len(Arguments.Valor) LTE 12>
		<cfreturn Arguments.Valor/Arguments.Unidad>
	</cfif>
	<cfset LvarDecimal 	= createobject("java","java.math.BigDecimal")>
	<cfset LvarDecimal.init("#Arguments.Valor#"&"")>
	<cfset LvarUnidades = createobject("java","java.math.BigDecimal")>
	<cfset LvarUnidades.init("#Arguments.Unidad#"&"")>
	<cfset LvarValor 	= LvarDecimal.divide(LvarUnidades,10,4).toString()>

	<cfloop index="i" from="#len(LvarValor)#" to="1" step="-1">
		<cfif mid(LvarValor,i,1) EQ ".">
			<cfreturn mid(LvarValor,1,i) & "00">
		<cfelseif mid(LvarValor,i,1) NEQ "0">
			<cfreturn mid(LvarValor,1,i)>
		</cfif>
	</cfloop>
	<cfreturn LvarValor>
</cffunction>