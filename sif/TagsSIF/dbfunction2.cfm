<!---

	<!--- Funciones de Hileras --->
		en los argumentos:
				Hilera =  Hilera significa un campo tipo hilera o una constante tipo hilera delimitada por apostrofes
					CAMPO_HILERA ó 'CONSTANTE HILERA'
	<cf_dbfunction name="OP_concat"	args=""  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="fn_substr"	args=""  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="fn_replace"	args=""  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="fn_len"	args=""  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="concat"	args="hilera1,hilera2,'hilera3','hilera4'"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="to_char"	args="hilera"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="length"	args="hilera"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="sPart"		args="hilera_principal,inicio,tamaño"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="sReplace"	args="hilera_principal,hilera_a_buscar,hilera_a_cambiar"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="sRepeat"	args="hilera_a_repetir,cantidad"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="sFind"		args="hilera_principal,hilera_a_buscar [,posicion_inicial=1]"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="chr"		args="int"  [datasource="<dsn>"] [returnvariable="<variable>"] >
				"sPart,sReplace,sRepeat,sFind" = "string_Part,string_Replace,string_Repeat,string_Find"

	<!--- Funciones de Números --->
		en los argumentos: 
				HileraConNumeros_o_Numero = HileraConNumeros significa un campo tipo hilera o una constante tipo hilera delimitada por apostrofes cuyo contenido sean dígitos numéricos
					CAMPO_HILERA ó '12345' ó CAMPO_NUMERICO ó 12345

	<cf_dbfunction name="to_integer"	args="HileraConNumeros_o_Numero"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="to_number"		args="HileraConNumeros_o_Numero [,decimales_a_truncar=0]"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="to_float"		args="HileraConNumeros_o_Numero [,decimales_a_redondear=10]"  [datasource="<dsn>"] [returnvariable="<variable>"] >

	<cf_dbfunction name="to_char_integer"	args="HileraConNumeros_o_Numero"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="to_char_float"		args="HileraConNumeros_o_Numero [,decimales_a_truncar=0]"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="to_char_money"		args="HileraConNumeros_o_Numero"  [datasource="<dsn>"] [returnvariable="<variable>"] >

	<cf_dbfunction name="mod"				args="Divisor,Dividiendo"  [datasource="<dsn>"] [returnvariable="<variable>"] >
		Divisor y Dividiendo son CAMPOS o CONSTANTES numéricas.
		
	<!--- Funciones especiales para condiciones: where, when, having --->

	<cf_dbfunction name="findoneof"			args="Hilera_principal,Caracteres_a_buscar_sin_apostrofes"  [datasource="<dsn>"] [returnvariable="<variable>"] >
		Caracteres_a_buscar_sin_apostrofes es una Constante tipo hilera pero no se le debe colocar apóstrofes.
		
	<!--- Funciones de Fechas --->
		en los argumentos:
				Fecha = Fecha significa un campo tipo date o datetime o una constante tipo hilera delimitada por {d ...} o {ts ...}
					CAMPO_DATE ó CAMPO_DATETIME ó {d YYYY-MM-DD} ó {ts YYYY-MM-DD HH:MI:SS}
				parte_Fecha_sin_apostrofes = constante tipo hilera SIN APOSTROFES alguno de los siguientes valores:
					YY = Año
					MM = Meses
					WK = Semanas
					DD = Dias
					HH = Horas
					MI = Minutos
					SS = Segundos
					MS = Milesimas de segundo

					(sólo en datepart y dateformat)
						YYYY = Año	
						DY = Dia del año (1=1/ENE)
						DW = Dia de la semana (1=Domingo)
						QQ = Trimestre del Año (1=ENE-MAR)
				
				formato_sin_apostrofes = constante tipo hilera SIN APOSTROFES con una combinación
					de las parte_Fechas anteriores más los caracteres:	/ - : y espacio en blanco
						DD/MM/YYYY HH:MI:SS
					
				FechaDMY = Constante o campo tipo HILERA con formato 'DD/MM/YYYY' ó 'DD/MM/YYYY HH:MI:SS' ó {d YYYY-MM-DD} ó {ts YYYY-MM-DD HH:MI:SS}
				
				Cantidad = Constante o campo tipo numerico con la cantidad de parte_Fecha correspondiente a la operación.
				
	<cf_dbfunction name="now"		args=""  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="today"		args=""  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="date_part"	args="parte_Fecha_sin_apostrofes, Fecha"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="to_date00"	args="Fecha"  [datasource="<dsn>"] [returnvariable="<variable>"] >
		to_date00 = to_datechar = elimina la hora de un dato fecha
		
	<!--- De hilera_a_DD/MM/YYYY a Fecha --->
	<cf_dbfunction name="to_date"		args="FechaDMY"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="to_datetime"	args="FechaDMY"  [datasource="<dsn>"] [returnvariable="<variable>"] >

	<!--- De Fecha a Hilera --->
	<cf_dbfunction name="date_format"	args="Fecha,formato_sin_apostrofes"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="to_sdate"		args="Fecha"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="to_sdateDMY"	args="Fecha"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="to_chartime"	args="Fecha"  [datasource="<dsn>"] [returnvariable="<variable>"] >

	<!--- Sumas a fecha --->
	<cf_dbfunction name="dateadd"		args="cantidad, Fecha [, parte_Fecha_sin_apostrofes_deCantidad=DD]"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="dateaddx"		args="parte_Fecha_sin_apostrofes, cantidad, Fecha"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="dateaddm"		args="cantidad_meses, Fecha"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="timeadd"		args="cantidad_segundos, Fecha"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="dateaddString"	args="cantidad_dias, Hilera_FechaDMY_sin_apostrofes"  [datasource="<dsn>"] [returnvariable="<variable>"] >

	<!--- Diferencia de fechas --->
	<cf_dbfunction name="datediff"			args="FechaInicial, FechaFinal [,parte_Fecha_sin_apostrofes_deResultado=DD]"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="datediffstring"	args="Hilera_FechaDMY_sin_apostrofes_INICIAL, Hilera_FechaDMY_sin_apostrofes_FINAL"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="timediff"			args="FechaInicial, FechaFinal"  [datasource="<dsn>"] [returnvariable="<variable>"] >

	
	Con ReturnVariable devuelve el string en la variable
	Sin ReturnVariable pinta el string en el <cfoutput>
	Todas las funciones con fechas se maneja en DIAS a menos que se indique lo contrario
	
	
---> 

<cfsetting enablecfoutputonly="yes">
<cfparam name="Attributes.name">
<cfparam name="Attributes.datasource" default="asp">
<cfparam name="Attributes.args" default="">
<cfparam name="Attributes.returnvariable" type="string" default="">
<cfparam name="Attributes.delimiters" type="string" default=",">

<cfset Attributes.name = LCase(Attributes.name)>

<!--- Asegurarse de que la informacion sobre las conexiones este disponible --->
<cfif not isdefined("Application.dsinfo.#Attributes.datasource#.charType")>
	<cfhttp url="http://#cgi.SERVER_NAME#:#cgi.SERVER_PORT#/cfmx/sif/tasks/datasources.cfm"
			timeout="30"
	>
</cfif>
<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo"
	refresh="no"
	datasource="#Attributes.datasource#" />
<cfif not StructKeyExists(Application.dsinfo, Attributes.datasource)>
	<cf_errorCode	code = "50599"
					msg  = "Datasource no definido: @errorDat_1@"
					errorDat_1="#HTMLEditFormat(Attributes.datasource)#"
	>
</cfif>

<cfset LvarDBtype		= Application.dsinfo[Attributes.datasource].type>
<cfset LvarDbFunction	= fnDbFunction()>
<cfif Attributes.returnvariable EQ "">
	<cfoutput>#LvarDbFunction#</cfoutput>
<cfelse>
	<cfset Caller[Attributes.returnvariable] = LvarDbFunction>
</cfif>
<cfsetting enablecfoutputonly="no">

<cffunction name="fnDbFunction" returntype="string">
	<cfset date_functions = "">
	<!--- Funciones de Fechas --->
	<cfset date_functions = date_functions & "now,today,date_part,to_datechar,to_date00,">
	<!--- De hilera_a_DD/MM/YYYY a Fecha --->
	<cfset date_functions = date_functions & "to_date,to_datetime,">
 	<!--- De Fecha a Hilera --->
	<cfset date_functions = date_functions & "date_format,to_sdate,to_sdatedmy,to_chartime,to_stime,">
	<!--- Sumas a fecha --->
	<cfset date_functions = date_functions & "dateadd,dateaddm,dateaddx,timeadd,dateaddstring,">
	<!--- Diferencia de fechas --->
	<cfset date_functions = date_functions & "datediff,timediff,datediffstring,datedifftot,">
	<cfset valid_functions = date_functions>
	<!--- Funciones de Hileras --->
	<cfset valid_functions = valid_functions & "op_concat,fn_substr,fn_len,fn_replace,">
	<cfset valid_functions = valid_functions & "chr,concat,to_char,length,">
	<cfset valid_functions = valid_functions & "spart,sreplace,srepeat,sfind,">
	<cfset valid_functions = valid_functions & "like,">
	<cfset valid_functions = valid_functions & "string_part,string_replace,string_repeat,string_find,">
	<!--- Funciones de Números --->
	<cfset valid_functions = valid_functions & "to_number,to_integer,to_float,to_char_integer,to_char_float,to_char_currency,mod,">
	<!--- Funciones especiales para condiciones: where, when, having --->
	<cfset valid_functions = valid_functions & "findoneof,">
	<!--- Funciones para LOB --->
	<cfset valid_functions = valid_functions & "islobnull,islobnotnull,">

	<cfif ListFind(valid_functions, Attributes.name) Is 0>
		<cf_errorCode	code = "50598"
						msg  = "cf_dbfunction: funcion '@errorDat_1@' inválida. Las funciones válidas son: @errorDat_2@"
						errorDat_1="#Attributes.name#"
						errorDat_2="#valid_functions#"
		>
	</cfif>

	<!---*************************--->
	<!---***** sybase / MSSQL ****--->	
	<!---*************************--->
	
	<cfif ListFind('sybase,sqlserver', LvarDBtype)>
		<cfset OP_CONCAT = " + ">
		<cfif ListFind(date_functions, Attributes.name)>
			<cfreturn fnDateFunctions()>
		<cfelseif Attributes.name is 'to_char'>
			<cfreturn "convert (varchar(255), #Attributes.args#)">
		<cfelseif Attributes.name is 'op_concat'>
			<cfreturn OP_CONCAT>
		<cfelseif Attributes.name is 'concat' >
			<cfif ListLen(Attributes.args, Attributes.delimiters) LT 2>
				<cf_errorCode	code = "50606" msg = "Argumentos incorrectos: por lo menos 2 hileras">
			<cfelse>
				<cfreturn replace(Attributes.args, Attributes.delimiters, OP_CONCAT, "ALL")>
			</cfif>
		<cfelseif Attributes.name is 'fn_len'>
			<cfreturn "datalength"> 
		<cfelseif Attributes.name is 'chr'>
			<cfreturn "char (#Attributes.args#)">
		<cfelseif Attributes.name is 'length'>
			<cfreturn "datalength (#Attributes.args#)">
		<cfelseif Attributes.name is 'fn_substr'>
			<cfreturn "substring"> 
		<cfelseif Attributes.name is 'string_part' OR Attributes.name is 'spart'>
			<cfreturn "substring (#ListGetAt(Attributes.args, 1, Attributes.delimiters)#, #ListGetAt(Attributes.args, 2, Attributes.delimiters)#, #ListGetAt(Attributes.args, 3, Attributes.delimiters)#)"> 
		<cfelseif Attributes.name is 'fn_replace'>
			<cfif LvarDBtype EQ "sqlserver">
				<cfreturn "replace">
			<cfelse>
				<cfreturn "str_replace">
			</cfif>
		<cfelseif Attributes.name is 'string_replace' OR Attributes.name is 'sreplace'>
			<cfif LvarDBtype EQ "sqlserver">
				<cfreturn "replace(#ListGetAt(Attributes.args, 1, Attributes.delimiters)#,#ListGetAt(Attributes.args, 2, Attributes.delimiters)#,#ListGetAt(Attributes.args, 3, Attributes.delimiters)#)">
			<cfelse>
				<cfreturn "str_replace(#ListGetAt(Attributes.args, 1, Attributes.delimiters)#,#ListGetAt(Attributes.args, 2, Attributes.delimiters)#,#ListGetAt(Attributes.args, 3, Attributes.delimiters)#)">
			</cfif>
		<cfelseif Attributes.name is 'string_repeat' OR Attributes.name is 'srepeat'>
			<cfreturn "replicate(#ListGetAt(Attributes.args, 1, Attributes.delimiters)#,#ListGetAt(Attributes.args, 2, Attributes.delimiters)#)">
		<cfelseif Attributes.name is 'string_find' OR Attributes.name is 'sfind'>
			<cfif ListLen(Attributes.args, Attributes.delimiters) EQ 3>
				<cfset LvarFind = "charindex(#ListGetAt(Attributes.args, 2, Attributes.delimiters)#,substring(#ListGetAt(Attributes.args, 1, Attributes.delimiters)#,#ListGetAt(Attributes.args, 3, Attributes.delimiters)#,255))">
				<cfreturn "case when #LvarFind# = 0 then 0 else #LvarFind# + #ListGetAt(Attributes.args, 3, Attributes.delimiters)# -1 end">
			<cfelse>
				<cfreturn "charindex(#ListGetAt(Attributes.args, 2, Attributes.delimiters)#,#ListGetAt(Attributes.args, 1, Attributes.delimiters)#)">
			</cfif>

		<cfelseif Attributes.name is 'to_integer'>
			<cfif LvarDBtype EQ 'sybase'>
				<cfreturn "convert(numeric, #Attributes.args#)">
			<cfelse>
				<cfreturn "convert(bigint, convert(float, #Attributes.args#))">
			</cfif>
		<cfelseif Attributes.name is 'to_number'>
			<cfif isdefined("Attributes.dec") AND len(Attributes.dec)>
				<cfif LvarDBtype EQ 'sybase'>
					<cfreturn "convert(numeric(18,#Attributes.dec#), #Attributes.args#)">
				<cfelse>
					<cfset LvarValor = "convert(float,#Attributes.args#)">
					<cfreturn "floor(abs(#LvarValor#*POWER(10,#Attributes.dec#)))*sign(#LvarValor#)/POWER(10,#Attributes.dec#)">
				</cfif>
			<cfelse>
				<cfif LvarDBtype EQ 'sybase'>
					<cfreturn "convert(numeric, #Attributes.args#)">
				<cfelse>
					<cfreturn "convert(bigint, convert(float, #Attributes.args#))">
				</cfif>
			</cfif>
		<cfelseif Attributes.name is 'to_float'>
			<cfif isdefined("Attributes.dec") AND len(Attributes.dec)>
				<cfreturn "round(convert(float,#Attributes.args#),#Attributes.dec#)">
			<cfelse>
				<cfreturn "convert(numeric(30,10),#Attributes.args#)">
			</cfif>

		<cfelseif Attributes.name is 'to_char_integer'>
			<cfif LvarDBtype EQ 'sybase'>
				<cfreturn "convert(varchar(31), convert(numeric, #Attributes.args#))">
			<cfelse>
				<cfreturn "convert(varchar(31), convert(bigint, convert(float, #Attributes.args#)))">
			</cfif>
		<cfelseif Attributes.name is 'to_char_float'>
			<cfif isdefined("Attributes.dec") AND len(Attributes.dec) AND Attributes.dec GT 0 AND Attributes.dec LTE 10>
				<cfreturn "convert(varchar(31), convert(numeric(30,#Attributes.dec#),#Attributes.args#))">
			<cfelse>
				<cfreturn "convert(varchar(31), convert(numeric(30,10),#Attributes.args#))">
			</cfif>
		<cfelseif Attributes.name is 'to_char_currency'>
			<cfreturn "convert(varchar(31), convert(money,#Attributes.args#), 1)">

		<cfelseif Attributes.name is 'mod'>
			<cfif ListLen(Attributes.args, Attributes.delimiters) NEQ 2>
				<cf_errorCode	code = "50607" msg = "Argumentos incorrectos: se requieren dos argumentos">
			<cfelse>
				<cfreturn "#trim(ListGetAt(Attributes.args, 1, Attributes.delimiters))#%#trim(ListGetAt(Attributes.args, 2, Attributes.delimiters))#">
			</cfif>
		<cfelseif Attributes.name is 'findOneOf'>
			<cfif ListLen(Attributes.args, Attributes.delimiters) NEQ 2>
				<cf_errorCode	code = "50600" msg = "Argumentos incorrectos">
			<cfelse>
				<cfset Lvar_findOneOf = "'%[" & trim(ListGetAt(Attributes.args, 2, Attributes.delimiters)) & "]%'">
				<cfreturn "#trim(ListGetAt(Attributes.args, 1, Attributes.delimiters))# like #Lvar_findOneOf#">
			</cfif>
		<cfelseif Attributes.name is 'like'>
			<cfset Attributes.args = replaceNoCase(Attributes.args," LIKE ",Attributes.delimiters)>
			<cfif ListLen(Attributes.args, Attributes.delimiters) NEQ 2>
				<cf_errorCode	code = "50600" msg = "Argumentos incorrectos: #Attributes.args# ">
			<cfelse>
				<cfreturn "#trim(ListGetAt(Attributes.args, 1, Attributes.delimiters))# LIKE #trim(ListGetAt(Attributes.args, 2, Attributes.delimiters))#">
			</cfif>
		<cfelseif Attributes.name is 'islobnull'>
			<cfif LvarDBtype EQ 'sybase'>
				<cfreturn "datalength(#trim(ListGetAt(Attributes.args, 1, Attributes.delimiters))#) = 0">
			<cfelse>
				<cfreturn "#trim(ListGetAt(Attributes.args, 1, Attributes.delimiters))# is null">
			</cfif>
		<cfelseif Attributes.name is 'islobnotnull'>
			<cfif LvarDBtype EQ 'sybase'>
				<cfreturn "datalength(#trim(ListGetAt(Attributes.args, 1, Attributes.delimiters))#) > 0">
			<cfelse>
				<cfreturn "#trim(ListGetAt(Attributes.args, 1, Attributes.delimiters))# is not null">
			</cfif>
		<cfelse>
			<cf_errorCode	code = "50608"
							msg  = "Nombre de dbfunction invalido: @errorDat_1@"
							errorDat_1="#Attributes.name#"
			>
		</cfif>
<!---*****************--->
<!---***** ORACLE ****--->	
<!---*****************--->
		
	<cfelseif LvarDBtype is 'oracle'>
		<cfset OP_CONCAT = " || ">
		<cfif ListFind(date_functions, Attributes.name)>
			<cfreturn fnDateFunctions()>
		<cfelseif Attributes.name is 'to_char'>
			<cfreturn "to_char(#Attributes.args#)">
		<cfelseif Attributes.name is 'op_concat'>
			<cfreturn OP_CONCAT>
		<cfelseif Attributes.name is 'concat' >
			<cfif ListLen(Attributes.args, Attributes.delimiters) LT 2>
				<cf_errorCode	code = "50606" msg = "Argumentos incorrectos: por lo menos 2 hileras">
			<cfelse>
				<cfreturn replace(Attributes.args, Attributes.delimiters, OP_CONCAT,"ALL")>
			</cfif>
		<cfelseif Attributes.name is 'fn_len'>
			<cfreturn "length"> 
		<cfelseif Attributes.name is 'chr'>
			<cfreturn "chr (#Attributes.args#)">
		<cfelseif Attributes.name is 'length'>
			<cfreturn "coalesce(length (#Attributes.args#),0)">
		<cfelseif Attributes.name is 'fn_substr'>
			<cfreturn "substr"> 
		<cfelseif Attributes.name is 'string_part' OR Attributes.name is 'spart'>
			<cfreturn "substr (#ListGetAt(Attributes.args, 1, Attributes.delimiters)#, #ListGetAt(Attributes.args, 2, Attributes.delimiters)#, #ListGetAt(Attributes.args, 3, Attributes.delimiters)#)">
		<cfelseif Attributes.name is 'fn_replace'>
			<cfreturn "REPLACE">
		<cfelseif Attributes.name is 'string_replace' OR Attributes.name is 'sreplace'>
			<cfreturn "REPLACE(#ListGetAt(Attributes.args, 1, Attributes.delimiters)#,#ListGetAt(Attributes.args, 2, Attributes.delimiters)#,#ListGetAt(Attributes.args, 3, Attributes.delimiters)#)">
		<cfelseif Attributes.name is 'string_repeat' OR Attributes.name is 'srepeat'>
			<cfreturn "SUBSTR(RPAD(' ',#ListGetAt(Attributes.args, 2, Attributes.delimiters)#*LENGTH(#ListGetAt(Attributes.args, 1, Attributes.delimiters)#)+1,#ListGetAt(Attributes.args, 1, Attributes.delimiters)#),2)">
		<cfelseif Attributes.name is 'string_find' OR Attributes.name is 'sfind'>
			<cfif ListLen(Attributes.args, Attributes.delimiters) EQ 3>
				<cfreturn "INSTR(#ListGetAt(Attributes.args, 1, Attributes.delimiters)#, #ListGetAt(Attributes.args, 2, Attributes.delimiters)#, #ListGetAt(Attributes.args, 3, Attributes.delimiters)#)">
			<cfelse>
				<cfreturn "INSTR(#ListGetAt(Attributes.args, 1, Attributes.delimiters)#, #ListGetAt(Attributes.args, 2, Attributes.delimiters)#)">
			</cfif>
		<cfelseif Attributes.name is 'to_integer'>
			<cfreturn "TRUNC(#Attributes.args#)">
		<cfelseif Attributes.name is 'to_number'>
			<cfif isdefined("Attributes.dec") AND len(Attributes.dec)>
				<cfreturn "TRUNC(#Attributes.args#,#Attributes.dec#)">
			<cfelse>
				<cfreturn "TRUNC(#Attributes.args#)">
			</cfif>
		<cfelseif Attributes.name is 'to_float'>
			<cfif isdefined("Attributes.dec") AND len(Attributes.dec)>
				<cfreturn "ROUND(#Attributes.args#,#Attributes.dec#)">
			<cfelse>
				<cfreturn "ROUND(#Attributes.args#,10)">
			</cfif>

		<cfelseif Attributes.name is 'to_char_integer'>
			<cfreturn "trim(to_char(TRUNC(#Attributes.args#)))">
		<cfelseif Attributes.name is 'to_char_float'>
			<cfif isdefined("Attributes.dec") AND len(Attributes.dec) AND Attributes.dec GT 0 AND Attributes.dec LTE 10>
				<cfset LvarFMT = "99999999999999999990." & repeatstring('9', #Attributes.dec#)>
			<cfelse>
				<cfset Attributes.dec = 10>
				<cfset LvarFMT = "99999999999999999990.9999999999">
			</cfif>
			<cfreturn "trim(to_char(TRUNC(#Attributes.args#,#Attributes.dec#), '#LvarFMT#'))">
		<cfelseif Attributes.name is 'to_char_currency'>
			<cfreturn "trim(to_char(#Attributes.args#, '9,999,999,999,999,990.99'))">

		<cfelseif Attributes.name is 'mod'>
			<cfreturn "mod(#trim(ListGetAt(Attributes.args, 1, Attributes.delimiters))#,#trim(ListGetAt(Attributes.args, 2, Attributes.delimiters))#)">
		<cfelseif Attributes.name is 'findOneOf'>
			<cfif ListLen(Attributes.args, Attributes.delimiters) NEQ 2>
				<cf_errorCode	code = "50600" msg = "Argumentos incorrectos">
			<cfelse>
				<cfset LvarCaracteres = trim(ListGetAt(Attributes.args, 2, Attributes.delimiters))>
				<cfset Lvar_findOneOf = "(INSTR(#trim(ListGetAt(Attributes.args, 1, Attributes.delimiters))#,'#mid(LvarCaracteres,1,1)#')">
                <cfloop index="i" from="2" to="#len(LvarCaracteres)#">
					<cfset Lvar_findOneOf = Lvar_findOneOf & " + INSTR(#trim(ListGetAt(Attributes.args, 1, Attributes.delimiters))#,'#mid(LvarCaracteres,i,1)#')">
                </cfloop>
				<cfreturn Lvar_findOneOf & ") > 0">
			</cfif>
		<cfelseif Attributes.name is 'like'>
			<cfset Attributes.args = replaceNoCase(Attributes.args," LIKE ",Attributes.delimiters)>
			<cfif ListLen(Attributes.args, Attributes.delimiters) NEQ 2>
				<cf_errorCode	code = "50600" msg = "Argumentos incorrectos">
			<cfelse>
				<cfreturn "#trim(ListGetAt(Attributes.args, 1, Attributes.delimiters))# LIKE #trim(ListGetAt(Attributes.args, 2, Attributes.delimiters))#">
			</cfif>
		<cfelseif Attributes.name is 'islobnull'>
			<cfreturn "#trim(ListGetAt(Attributes.args, 1, Attributes.delimiters))# is null">
		<cfelseif Attributes.name is 'islobnotnull'>
			<cfreturn "#trim(ListGetAt(Attributes.args, 1, Attributes.delimiters))# is not null">
		<cfelse>
			<cf_errorCode	code = "50608"
							msg  = "Nombre de dbfunction invalido: @errorDat_1@"
							errorDat_1="#Attributes.name#"
			>
		</cfif>
	<!---**************--->
	<!---***** DB2 ****--->	
	<!---**************--->
	<cfelseif LvarDBtype is 'db2'>
		<cfset OP_CONCAT = " || ">
		<cfif ListFind(date_functions, Attributes.name)>
			<cfreturn fnDateFunctions()>
		<cfelseif Attributes.name is 'to_char'>
			<cfparam name="Attributes.isNumber" type="boolean" default="true">
			<cfif Attributes.isNumber>
				<cfreturn "CASE WHEN decimal(#Attributes.args#,30,10) < 0 then '-' else '' end || CASE WHEN abs(decimal(#Attributes.args#,30,10)) >= 0 and abs(decimal(#Attributes.args#,30,10)) < 1 then '0' else '' end || TRIM(L '0' FROM TRIM(T '.' FROM TRIM(T '0' FROM RTRIM(CHAR(abs(decimal(#Attributes.args#,30,10)))))))">
			<cfelse>
				<cfreturn "CHAR(#Attributes.args#)">
			</cfif>
		<cfelseif Attributes.name is 'op_concat'>
			<cfreturn OP_CONCAT>
		<cfelseif Attributes.name is 'concat' >
			<cfif ListLen(Attributes.args, Attributes.delimiters) LT 2>
				<cf_errorCode	code = "50606" msg = "Argumentos incorrectos: por lo menos 2 hileras">
			<cfelse>
				<cfreturn replace(Attributes.args, Attributes.delimiters, OP_CONCAT, "ALL")>
			</cfif>
		<cfelseif Attributes.name is 'fn_len'>
			<cfreturn "length"> 
		<cfelseif Attributes.name is 'chr'>
			<cfreturn "chr (#Attributes.args#)">
		<cfelseif Attributes.name is 'length'>
			<cfreturn "coalesce(length (#Attributes.args#),0)">
		<cfelseif Attributes.name is 'fn_substr'>
			<cfreturn "substr"> 
		<cfelseif Attributes.name is 'string_part' OR Attributes.name is 'spart'>
			<cfset LvarStr = #ListGetAt(Attributes.args, 1, Attributes.delimiters)#>
			<cfset LvarIni = #ListGetAt(Attributes.args, 2, Attributes.delimiters)#>
			<cfset LvarLon = #ListGetAt(Attributes.args, 3, Attributes.delimiters)#>
			<cfreturn "substr(#LvarSTR#,#LvarINI#,case when length(#LvarSTR#)<=#LvarLon# then length(#LvarSTR#) else #LvarLON# end)">
		<cfelseif Attributes.name is 'fn_replace'>
			<cfreturn "REPLACE">
		<cfelseif Attributes.name is 'string_replace' OR Attributes.name is 'sreplace'>
			<cfreturn "REPLACE(#ListGetAt(Attributes.args, 1, Attributes.delimiters)#,#ListGetAt(Attributes.args, 2, Attributes.delimiters)#,#ListGetAt(Attributes.args, 3, Attributes.delimiters)#)">
		<cfelseif Attributes.name is 'string_repeat' OR Attributes.name is 'srepeat'>
			<cfreturn "REPEAT(#ListGetAt(Attributes.args, 1, Attributes.delimiters)#,#ListGetAt(Attributes.args, 2, Attributes.delimiters)#)">
		<cfelseif Attributes.name is 'string_find' OR Attributes.name is 'sfind'>
			<cfif ListLen(Attributes.args, Attributes.delimiters) EQ 3>
				<cfreturn "locate(#ListGetAt(Attributes.args, 2, Attributes.delimiters)#,#ListGetAt(Attributes.args, 1, Attributes.delimiters)#,#ListGetAt(Attributes.args, 3, Attributes.delimiters)#)">
			<cfelse>
				<cfreturn "locate(#ListGetAt(Attributes.args, 2, Attributes.delimiters)#,#ListGetAt(Attributes.args, 1, Attributes.delimiters)#)">
			</cfif>

		<cfelseif Attributes.name is 'to_integer'>
			<cfreturn "DECIMAL(#Attributes.args#,18)">
		<cfelseif Attributes.name is 'to_number'>
			<cfif isdefined("Attributes.dec") AND len(Attributes.dec)>
				<cfreturn "DECIMAL(#Attributes.args#,18,#Attributes.dec#)">
			<cfelse>
				<cfreturn "DECIMAL(#Attributes.args#,18)">
			</cfif>
		<cfelseif Attributes.name is 'to_float'>
			<cfif isdefined("Attributes.dec") AND len(Attributes.dec)>
				<cfreturn "ROUND(DECIMAL(#Attributes.args#,30,10),#Attributes.dec#)">
			<cfelse>
				<cfreturn "DECIMAL(#Attributes.args#,30,10)">
			</cfif>

		<cfelseif Attributes.name is 'to_char_integer'>
			<cfreturn "fnTO_CHAR(#Attributes.args#,'999999999999999990')">
		<cfelseif Attributes.name is 'to_char_float'>
			<cfif isdefined("Attributes.dec") AND len(Attributes.dec) AND Attributes.dec GT 0 AND Attributes.dec LTE 10>
				<cfset LvarFMT = "99999999999999999990." & repeatstring('9', Attributes.dec)>
			<cfelse>
				<cfset LvarFMT = "99999999999999999990.9999999999">
			</cfif>
			<cfreturn "fnTO_CHAR(#Attributes.args#, '#LvarFMT#')">
		<cfelseif Attributes.name is 'to_char_currency'>
			<cfreturn "fnTO_CHAR(#Attributes.args#, '9,999,999,999,999,990.99')">

		<cfelseif Attributes.name is 'mod'>
			<cfreturn "mod(#trim(ListGetAt(Attributes.args, 1, Attributes.delimiters))#,#trim(ListGetAt(Attributes.args, 2, Attributes.delimiters))#)">
		<cfelseif Attributes.name is 'findOneOf'>
			<cfif ListLen(Attributes.args, Attributes.delimiters) NEQ 2>
				<cf_errorCode	code = "50600" msg = "Argumentos incorrectos">
			<cfelse>
				<cfset LvarCaracteres = trim(ListGetAt(Attributes.args, 2, Attributes.delimiters))>
				<cfset Lvar_findOneOf = "(POSSTR(#trim(ListGetAt(Attributes.args, 1, Attributes.delimiters))#,'#mid(LvarCaracteres,1,1)#')">
                <cfloop index="i" from="2" to="#len(LvarCaracteres)#">
					<cfset Lvar_findOneOf = Lvar_findOneOf & " + POSSTR(#trim(ListGetAt(Attributes.args, 1, Attributes.delimiters))#,'#mid(LvarCaracteres,i,1)#')">
                </cfloop>
				<cfreturn Lvar_findOneOf & ") > 0">
			</cfif>
		<cfelseif Attributes.name is 'like'>
			<cfset Attributes.args = replaceNoCase(Attributes.args," LIKE ",Attributes.delimiters)>
			<cfif ListLen(Attributes.args, Attributes.delimiters) NEQ 2>
				<cf_errorCode	code = "50600" msg = "Argumentos incorrectos">
			<cfelse>
				<cfreturn "fnLIKE(#trim(ListGetAt(Attributes.args, 1, Attributes.delimiters))#, #trim(ListGetAt(Attributes.args, 2, Attributes.delimiters))#)=1">
			</cfif>
		<cfelseif Attributes.name is 'islobnull'>
			<cfreturn "#trim(ListGetAt(Attributes.args, 1, Attributes.delimiters))# is null">
		<cfelseif Attributes.name is 'islobnotnull'>
			<cfreturn "#trim(ListGetAt(Attributes.args, 1, Attributes.delimiters))# is not null">
		<cfelse>
			<cf_errorCode	code = "50608"
							msg  = "Nombre de dbfunction invalido: @errorDat_1@"
							errorDat_1="#Attributes.name#"
			>
		</cfif>
	<cfelse>
		<cf_errorCode	code = "50611"
						msg  = "Tipo de base de datos desconocido para cf_dbfunction: @errorDat_1@"
						errorDat_1="#LvarDBtype#"
		>
	</cfif>
</cffunction>

<cffunction name="fnDateFunctions" returntype="string">
	<!--- Funciones de Fechas con validaciones comunes para cualquier base de datos --->
	<cfif Attributes.name is 'now'>
		<cfreturn fnNow()>
	<cfelseif Attributes.name is 'today'>
		<cfreturn fnToday()>
	<cfelseif Attributes.name is 'date_part'>
		<cfset LvarDPart	= trim(ListGetAt(Attributes.args, 1, Attributes.delimiters))>
		<cfset LvarFecha	= fnGetDate(ListGetAt(Attributes.args, 2, Attributes.delimiters))>
		<cfreturn fnDatePartNUM(LvarFecha, LvarDPart)>
	<cfelseif Attributes.name is 'to_datechar' OR Attributes.name is 'to_date00'>
		<!--- De Fecha a Fecha sin hora --->
		<cfreturn fnFechaSinHora(Attributes.args)>

	<!--- De hilera_a_DD/MM/YYYY a Fecha --->
	<cfelseif Attributes.name is 'to_date'>
		<cfreturn fnDMYtoDate(#Attributes.args#, true)>
	<cfelseif Attributes.name is 'to_datetime'>
		<cfreturn fnDMYtoDate(#Attributes.args#)>


 	<!--- De Fecha a Hilera --->
	<cfelseif Attributes.name is 'date_format'>
		<cfreturn fnDateFormat(fnGetDate(ListGetAt(Attributes.args, 1, Attributes.delimiters)), ListGetAt(Attributes.args, 2, Attributes.delimiters))>
	<cfelseif Attributes.name is 'to_sdate'>
		<cfreturn fnDateFormat(fnGetDate(Attributes.args),"YYYYMMDD")>
	<cfelseif Attributes.name is 'to_sdatedmy'>
		<cfreturn fnDateFormat(fnGetDate(Attributes.args),"DD/MM/YYYY")>
	<cfelseif Attributes.name is 'to_chartime' OR Attributes.name is 'to_stime'>
		<cfreturn fnDateFormat(fnGetDate(Attributes.args),"HH:MI:SS")>

	<!--- Sumas a fecha --->
	<cfelseif Attributes.name is 'dateadd'>
		<cfif ListLen(Attributes.args, Attributes.delimiters) EQ 2>
			<!--- DatePart Default: dd --->
			<cfset LvarDPart	= "dd">
			<cfset LvarNumero	= trim(ListGetAt(Attributes.args, 1, Attributes.delimiters))>
			<cfset LvarFecha	= fnGetDate(ListGetAt(Attributes.args, 2, Attributes.delimiters))>
			<cfreturn fnDateadd(#LvarDPart#, #LvarNumero#, #LvarFecha#)>
		<cfelseif ListLen(Attributes.args, Attributes.delimiters) EQ 3 OR ListLen(Attributes.args, Attributes.delimiters) EQ 4>
			<!---
				yy	year
				mm	month
				wk	week
				dd	day
				hh	hour
				mi	minute
				ss	second
				ms	millisecond
			--->
			<cfset LvarDPart = trim(lcase(ListGetAt(Attributes.args,3,Attributes.delimiters)))>
			<cfset LvarNumero	= trim(ListGetAt(Attributes.args, 1, Attributes.delimiters))>
			<cfset LvarFecha	= fnGetDate(ListGetAt(Attributes.args, 2, Attributes.delimiters))>
			<cfreturn fnDateadd(#LvarDPart#, #LvarNumero#, #LvarFecha#)>
		<cfelse>
			<cf_errorCode	code = "50630" msg = "Argumentos incorrectos: args='numero, fecha [, datePart]'">
		</cfif>
	 <cfelseif Attributes.name is 'dateaddm'>
		<cfif ListLen(Attributes.args, Attributes.delimiters) NEQ 2>
			<cf_errorCode	code = "50631" msg = "Argumentos incorrectos: args='meses, fecha'">
		<cfelse>
			<cfset LvarDPart	= "mm">
			<cfset LvarNumero	= trim(ListGetAt(Attributes.args, 1, Attributes.delimiters))>
			<cfset LvarFecha	= fnGetDate(ListGetAt(Attributes.args, 2, Attributes.delimiters))>
			<cfreturn fnDateadd(#LvarDPart#, #LvarNumero#, #LvarFecha#)>
		</cfif>	
	<cfelseif Attributes.name is 'dateaddx'>
		<cfif ListLen(Attributes.args, Attributes.delimiters) NEQ 3>
			<cf_errorCode	code = "50632" msg = "Argumentos incorrectos: args='tipo, numero_de_tipo, fecha'">
		<cfelse>
			<cfset LvarDPart	= trim(ListGetAt(Attributes.args, 1, Attributes.delimiters))>
			<cfset LvarNumero	= trim(ListGetAt(Attributes.args, 2, Attributes.delimiters))>
			<cfset LvarFecha	= fnGetDate(ListGetAt(Attributes.args, 3, Attributes.delimiters))>
			<cfreturn fnDateadd(#LvarDPart#, #LvarNumero#, #LvarFecha#)>
		</cfif>	
	<cfelseif Attributes.name is 'timeadd'>
		<cfif ListLen(Attributes.args, Attributes.delimiters) NEQ 2>
			<cf_errorCode	code = "50633" msg = "Argumentos incorrectos: args='segundos, fecha'">
		<cfelse>
			<cfset LvarDPart	= "ss">
			<cfset LvarNumero	= trim(ListGetAt(Attributes.args, 1, Attributes.delimiters))>
			<cfset LvarFecha	= fnGetDate(ListGetAt(Attributes.args, 2, Attributes.delimiters))>
			<cfreturn fnDateadd(#LvarDPart#, #LvarNumero#, #LvarFecha#)>
		</cfif>
	<cfelseif Attributes.name is 'dateaddstring'>
		<cfif ListLen(Attributes.args, Attributes.delimiters) NEQ 2>
			<cf_errorCode	code = "50634" msg = "Argumentos incorrectos: args='dias, hileraFechaSinApostrofes'">
		<cfelse>
			<cfset LvarDPart	= "dd">
			<cfset LvarNumero	= trim(ListGetAt(Attributes.args, 1, Attributes.delimiters))>
			<cfset LvarFecha	= fnGetDate("'#ListGetAt(Attributes.args, 2, Attributes.delimiters)#'")>
			<cfreturn fnDateadd(#LvarDPart#, #LvarNumero#, #LvarFecha#)>
		</cfif>

	<!--- Diferencia de fechas --->
	<cfelseif Attributes.name is 'datedifftot' >
		<cfif ListLen(Attributes.args, Attributes.delimiters) NEQ 3>
			<cf_errorCode	code = "50635" msg = "Argumentos incorrectos: args='dateIni, dateFin , datePart'">
		</cfif>
		<cfset LvarDPart = trim(lcase(ListGetAt(Attributes.args,3,Attributes.delimiters)))>
		<cfset LvarFechaIni	= fnGetDate(ListGetAt(Attributes.args, 1, Attributes.delimiters))>
		<cfset LvarFechaFin	= fnGetDate(ListGetAt(Attributes.args, 2, Attributes.delimiters))>

		<cfreturn fnDateDiffTot (LvarDPart, LvarFechaIni, LvarFechaFin)>
	<cfelseif Attributes.name is 'datediff' >
		<cfif ListLen(Attributes.args, Attributes.delimiters) EQ 2>
			<!--- DatePart Default: dd --->
			<cfset LvarDPart	= "dd">
			<cfset LvarSinHora = (LvarDBtype EQ 'oracle')>
			<cfset LvarFechaIni	= fnGetDate(ListGetAt(Attributes.args, 1, Attributes.delimiters))>
			<cfset LvarFechaFin	= fnGetDate(ListGetAt(Attributes.args, 2, Attributes.delimiters))>
			<cfreturn fnDatediff (LvarDPart, LvarFechaIni, LvarFechaFin)>
		<cfelseif ListLen(Attributes.args, Attributes.delimiters) EQ 3 OR ListLen(Attributes.args, Attributes.delimiters) EQ 4>
			<!---
				yy	year
				mm	month
				wk	week
				dd	day
				hh	hour
				mi	minute
				ss	second
				ms	millisecond
			--->
			<cfif ListLen(Attributes.args, Attributes.delimiters) EQ 4>
				<cfset LvarTS	 = ListGetAt(Attributes.args,4,Attributes.delimiters)>
				<cfif NOT isboolean(LvarTS)>
					<cf_errorCode	code = "50636" msg = "Argumento oracleTimestamp debe ser true o false: args='dateIni, dateFin [, datePart]'">
				</cfif>
			</cfif>

			<cfset LvarDPart = trim(lcase(ListGetAt(Attributes.args,3,Attributes.delimiters)))>
			<cfset LvarSinHora = (LvarDBtype EQ 'oracle' AND NOT listfind(LvarDPart,"hh,mi,ss,ms"))>
			<cfset LvarFechaIni	= fnGetDate(ListGetAt(Attributes.args, 1, Attributes.delimiters))>
			<cfset LvarFechaFin	= fnGetDate(ListGetAt(Attributes.args, 2, Attributes.delimiters))>

			<cfreturn fnDatediff (LvarDPart, LvarFechaIni, LvarFechaFin)>
		<cfelse>
			<cf_errorCode	code = "50603" msg = "Argumentos incorrectos: args='dateIni, dateFin [, datePart=dd [, oracleTimestamp=false]]'">
		</cfif>
	<cfelseif Attributes.name is 'datediffstring'>
		<cfif ListLen(Attributes.args, Attributes.delimiters) EQ 2 OR ListLen(Attributes.args, Attributes.delimiters) EQ 3>
			<cfif ListLen(Attributes.args, Attributes.delimiters) EQ 3>
				<cfset LvarTS	 = ListGetAt(Attributes.args,3,Attributes.delimiters)>
				<cfif NOT isboolean(LvarTS)>
					<cf_errorCode	code = "50604" msg = "Argumento oracleTimestamp debe ser true o false: args='dateIni, dateFin, oracleTimestamp'">
				</cfif>
			</cfif>
			<cfset LvarDPart	= "dd">
			<cfset LvarSinHora = (LvarDBtype EQ 'oracle')>
			<cfset LvarFechaIni	= fnGetDate("'#ListGetAt(Attributes.args, 1, Attributes.delimiters)#'")>
			<cfset LvarFechaFin	= fnGetDate("'#ListGetAt(Attributes.args, 2, Attributes.delimiters)#'")>
			<cfreturn fnDatediff (LvarDPart, LvarFechaIni, LvarFechaFin)>
		<cfelse>
			<cf_errorCode	code = "50605" msg = "Argumentos incorrectos: args='dateIni, dateFin [, oracleTimestamp=false]'">
		</cfif>
	<cfelseif Attributes.name is 'timediff'>
		<cfif ListLen(Attributes.args, Attributes.delimiters) EQ 2 OR ListLen(Attributes.args, Attributes.delimiters) EQ 3>
			<cfif ListLen(Attributes.args, Attributes.delimiters) EQ 3>
				<cfset LvarTS	 = ListGetAt(Attributes.args,3,Attributes.delimiters)>
				<cfif NOT isboolean(LvarTS)>
					<cf_errorCode	code = "50604" msg = "Argumento oracleTimestamp debe ser true o false: args='dateIni, dateFin, oracleTimestamp'">
				</cfif>
			</cfif>

			<cfset LvarDPart	= "ss">
			<cfset LvarSinHora = false>
			<cfset LvarFechaIni	= fnGetDate(ListGetAt(Attributes.args, 1, Attributes.delimiters),LvarSinHora)>
			<cfset LvarFechaFin	= fnGetDate(ListGetAt(Attributes.args, 2, Attributes.delimiters),LvarSinHora)>
			<cfreturn fnDatediff (LvarDPart, LvarFechaIni, LvarFechaFin)>
		<cfelse>
			<cf_errorCode	code = "50605" msg = "Argumentos incorrectos: args='dateIni, dateFin [, oracleTimestamp=false]'">
		</cfif>
	</cfif>
</cffunction>

<cffunction name="fnFechaSinHora" returntype="string" access="private">
	<cfargument name="Fecha" required="yes">
	
	<cfif mid(Arguments.Fecha,1,1) EQ "'" or mid(Arguments.Fecha,1,1) EQ "{">
		<cfreturn "#fnDMYtoDate(Arguments.Fecha, true)#">
	<cfelse>
		<cfset LvarFecha = Arguments.Fecha>
		<cfif LvarDBtype EQ 'sybase'>
			<cfreturn "convert(date,#LvarFecha#)">
		<cfelseif LvarDBtype EQ 'sqlserver'>
			<cfreturn "convert (datetime, convert(varchar, #LvarFecha#, 103), 103)">
		<cfelseif LvarDBtype EQ 'oracle'>
			<cfreturn "TO_DATE(TO_CHAR(#LvarFecha#,'dd/mm/yyyy'),'dd/mm/yyyy')">
		<cfelseif LvarDBtype EQ 'db2'>
			<cfreturn "(#LvarFecha# - hour(#LvarFecha#) HOURS - minute(#LvarFecha#) MINUTES - second(#LvarFecha#) SECONDS - microsecond(#LvarFecha#) MICROSECONDS)">
		</cfif>
	</cfif>
</cffunction>

<cffunction name="fnDateAdd" returntype="string">
	<cfargument name="DPart"	type="string" required="yes">
	<cfargument name="Numero"	type="string" required="yes">
	<cfargument name="Fecha"	type="string" required="yes">

	<cfset Arguments.DPart = Lcase(Arguments.DPart)>
	<cfif Arguments.DPart EQ "yyyy">
		<cfset Arguments.DPart = "yy">
	</cfif>
	<cfif ListFind('sybase,sqlserver', LvarDBtype)>
		<cfif NOT listFind("yy,mm,wk,dd,hh,mi,ss,ms",Arguments.DPart)>
			<cf_errorCode	code = "50602" msg = "Argumentos incorrectos: solo se permite en datepart: yy,mm,wk,dd,hh,mi,ss,ms">
		</cfif>

		<cfreturn 'dateadd(#Arguments.DPart#, #Arguments.Numero#, #Arguments.Fecha#)'>
	<cfelseif LvarDBtype EQ "oracle">
		<cfif Arguments.DPart EQ "mm">
			<cfreturn "ADD_MONTHS(#Arguments.Fecha#, #Arguments.Numero#)">
		<cfelseif Arguments.DPart EQ "yy">
			<cfreturn "ADD_MONTHS(#Arguments.Fecha#, (#Arguments.Numero#)*12)">

		<cfelseif Arguments.DPart EQ "dd">
			<cfreturn "#Arguments.Fecha# + (#Arguments.Numero#)">
		<cfelseif Arguments.DPart EQ "wk">
			<cfreturn "#Arguments.Fecha# + (#Arguments.Numero#)*7">
		<cfelseif Arguments.DPart EQ "hh">
			<cfreturn "#Arguments.Fecha# + (#Arguments.Numero#)/24">
		<cfelseif Arguments.DPart EQ "mi">
			<cfreturn "#Arguments.Fecha# + (#Arguments.Numero#)/1440">
		<cfelseif Arguments.DPart EQ "ss">
			<cfreturn "#Arguments.Fecha# + (#Arguments.Numero#)/86400">
		<cfelseif Arguments.DPart EQ "ms">
			<cfreturn "#Arguments.Fecha# + (#Arguments.Numero#)/86400000">
		<cfelse>
			<cf_errorCode	code = "50602" msg = "Argumentos incorrectos: solo se permite en datepart: yy,mm,wk,dd,hh,mi,ss,ms">
		</cfif>
	<cfelseif LvarDBtype EQ "db2">
		<cfif Arguments.DPart EQ "yy">
			<cfset LvarDPart = ") YEARS">
		<cfelseif Arguments.DPart EQ "mm">
			<cfset LvarDPart = ") MONTHS">
		<cfelseif Arguments.DPart EQ "wk">
			<cfset LvarDPart = "*7) DAYS">
		<cfelseif Arguments.DPart EQ "dd">
			<cfset LvarDPart = ") DAYS">
		<cfelseif Arguments.DPart EQ "hh">
			<cfset LvarDPart = ") HOURS">
		<cfelseif Arguments.DPart EQ "mi">
			<cfset LvarDPart = ") MINUTES">
		<cfelseif Arguments.DPart EQ "ss">
			<cfset LvarDPart = ") SECONDS">
		<cfelseif Arguments.DPart EQ "ms">
			<cfset LvarDPart = "/1000) SECONDS">
		<cfelse>
			<cf_errorCode	code = "50602" msg = "Argumentos incorrectos: solo se permite en datepart: yy,mm,wk,dd,hh,mi,ss,ms">
		</cfif>
		<cfreturn '#Arguments.Fecha# + (#Arguments.Numero##LvarDPart#'>
	</cfif>
</cffunction>

<cffunction name="fnDateDiff" returntype="string">
	<cfargument name="DPart"	type="string" required="yes">
	<cfargument name="FechaIni"	type="string" required="yes">
	<cfargument name="FechaFin"	type="string" required="yes">

	<cfset Arguments.DPart = Lcase(Arguments.DPart)>
	<cfif Arguments.DPart EQ "yyyy">
		<cfset Arguments.DPart = "yy">
	</cfif>
	<cfif ListFind('sybase,sqlserver', LvarDBtype)>
		<cfif NOT listFind("yy,mm,wk,dd,hh,mi,ss,ms",Arguments.DPart)>
			<cf_errorCode	code = "50602" msg = "Argumentos incorrectos: solo se permite en datepart: yy,mm,wk,dd,hh,mi,ss,ms">
		</cfif>

		<cfreturn 'datediff(#DPart#, #FechaIni#, #FechaFin#)'>
	<cfelseif ListFind('oracle,db2', LvarDBtype)>
		<cfset LvarFunc = "#FechaFin# - #FechaIni#">
		<cfif DPart EQ "yy" OR DPart EQ "yyyy" >
			<cfreturn "#fnDatePartNum(FechaFin,"yyyy")#-#fnDatePartNum(FechaIni,"yyyy")#">
		<cfelseif DPart EQ "qq">
			<cfreturn "(#fnDatePartNum(FechaFin,"yyyy")#*4+#fnDatePartNum(FechaFin,"qq")#)-(#fnDatePartNum(FechaIni,"yyyy")#*4+#fnDatePartNum(FechaIni,"qq")#)">
		<cfelseif DPart EQ "mm">
			<cfreturn "(#fnDatePartNum(FechaFin,"yyyy")#*12+#fnDatePartNum(FechaFin,"mm")#)-(#fnDatePartNum(FechaIni,"yyyy")#*12+#fnDatePartNum(FechaIni,"mm")#)">
		<cfelseif DPart EQ "wk">
			<cfif LvarDBtype EQ 'oracle'>
				<cfreturn "TRUNC((#fnDatePartNum(FechaFin,"jj")#-#fnDatePartNum(FechaIni,"jj")#)/7)">
			<cfelse>
				<cfreturn "((#fnDatePartNum(FechaFin,"jj")#-#fnDatePartNum(FechaIni,"jj")#)/7)">
			</cfif>
		<cfelseif DPart EQ "dd">
			<cfreturn "#fnDatePartNum(FechaFin,"jj")#-#fnDatePartNum(FechaIni,"jj")#">
		<cfelseif DPart EQ "hh">
			<cfif LvarDBtype EQ 'oracle'>
				<cfreturn "TRUNC((#FechaFin#-#FechaIni#)*24)">
			<cfelse>
				<cfreturn "(#fnDatePartNum(FechaFin,"jj")#*24+#fnDatePartNum(FechaFin,"hh")#)-(#fnDatePartNum(FechaIni,"jj")#*24+#fnDatePartNum(FechaIni,"hh")#)">
			</cfif>
		<cfelseif DPart EQ "mi">
			<cfreturn "(#fnDatePartNum(FechaFin,"jj")#*24*60+#fnDatePartNum(FechaFin,"hh")#*60+#fnDatePartNum(FechaFin,"mm")#)-(#fnDatePartNum(FechaIni,"jj")#*24*60+#fnDatePartNum(FechaIni,"hh")#*60+#fnDatePartNum(FechaIni,"mm")#)">
		<cfelseif DPart EQ "ss">
			<cfif LvarDBtype EQ 'oracle'>
				<cfreturn "(#FechaFin#-#FechaIni#)*86400">
			<cfelse>
				<cfreturn "(#fnDatePartNum(FechaFin,"jj")#-#fnDatePartNum(FechaIni,"jj")#)*86400+#fnDatePartNum(FechaFin,"ssss")#-#fnDatePartNum(FechaIni,"ssss")#">
			</cfif>
		<cfelseif DPart EQ "ms">
			<cfreturn "TRUNC(ROUND((#LvarFunc#)*86400000,6))">
		<cfelse>
			<cf_errorCode	code = "50602" msg = "Argumentos incorrectos: solo se permite en datepart: yy,mm,wk,dd,hh,mi,ss,ms">
		</cfif>
		<!---
			<cfset LvarTS = Arguments.OracleTS>
			<cfif LvarTS>
				<cfif DPart EQ "dd">
					<cfreturn "EXTRACT(DAY FROM #LvarFunc#)">
				<cfelseif DPart EQ "wk">
					<cfreturn "TRUNC(EXTRACT(DAY FROM #LvarFunc#)/7)">
				<cfelseif DPart EQ "hh">
					<cfreturn "(EXTRACT(DAY FROM #LvarFunc#)*24 + EXTRACT(HOUR FROM #LvarFunc#))">
				<cfelseif DPart EQ "mi">
					<cfreturn "(EXTRACT(DAY FROM #LvarFunc#)*1440 + EXTRACT(HOUR FROM #LvarFunc#)*60 + EXTRACT(MINUTE FROM #LvarFunc#))">
				<cfelseif DPart EQ "ss">
					<cfreturn "TRUNC(EXTRACT(DAY FROM #LvarFunc#)*86400 + EXTRACT(HOUR FROM #LvarFunc#)*3600 + EXTRACT(MINUTE FROM #LvarFunc#)*60 + EXTRACT(SECOND FROM #LvarFunc#))">
				<cfelseif DPart EQ "ms">
					<cfreturn "TRUNC( (EXTRACT(DAY FROM #LvarFunc#)*86400 + EXTRACT(HOUR FROM #LvarFunc#)*3600 + EXTRACT(MINUTE FROM #LvarFunc#)*60 + EXTRACT(SECOND FROM #LvarFunc#)) *1000)">
				</cfif>
		--->
	<cfelseif LvarDBtype EQ "db2">
		<cfif mid(LvarFechaIni,1,7) EQ "TO_DATE">
			<cfset LvarFechaIni = replace(LvarFechaIni, "TO_DATE", "DATE", "ALL")>
			<cfset LvarFechaIni = replace(LvarFechaIni, ", 'YYYY-MM-DD HH24:MI:SS'", "", "ALL")>
		<cfelse>
			<cfset LvarFechaIni = "DATE (#LvarFechaIni#)">
		</cfif>
		<cfif mid(LvarFechaFin,1,7) EQ "TO_DATE">
			<cfset LvarFechaFin = replace(LvarFechaFin, "TO_DATE", "DATE", "ALL")>
			<cfset LvarFechaFin = replace(LvarFechaFin, ", 'YYYY-MM-DD HH24:MI:SS'", "", "ALL")>
		<cfelse>
			<cfset LvarFechaFin = "DATE (#LvarFechaFin#)">
		</cfif>
		<cfset LvarFunc = "#LvarFechaFin# - #LvarFechaIni#">
		<cfif DPart EQ "yy">
			<cfset LvarDPart = 256>
		<cfelseif DPart EQ "mm">
			<cfset LvarDPart = 64>
		<cfelseif DPart EQ "wk">
			<cfset LvarDPart = 32>
		<cfelseif DPart EQ "dd">
			<cfset LvarDPart = 16>
		<cfelseif DPart EQ "hh">
			<cfset LvarDPart = 8>
		<cfelseif DPart EQ "mi">
			<cfset LvarDPart = 4>
		<cfelseif DPart EQ "ss">
			<cfset LvarDPart = 2>
		<cfelseif DPart EQ "ms">
			<cfset LvarDPart = 1>
		<cfelse>
			<cf_errorCode	code = "50602" msg = "Argumentos incorrectos: solo se permite en datepart: yy,mm,wk,dd,hh,mi,ss,ms">
		</cfif>
		<cfreturn "timestampdiff(#LvarDPart#,char(#LvarFunc#))">
	</cfif>
</cffunction>

<cffunction name="fnDateDiffTot" returntype="string">
	<cfargument name="DPart"	type="string" required="yes">
	<cfargument name="FechaIni"	type="string" required="yes">
	<cfargument name="FechaFin"	type="string" required="yes">

	<cfset Arguments.DPart = Lcase(Arguments.DPart)>
	<cfif Arguments.DPart EQ "yyyy">
		<cfset Arguments.DPart = "yy">
	</cfif>
	<cfif ListFind('sybase,sqlserver', LvarDBtype)>
		<cfif NOT listFind("yy,mm,wk,dd,hh,mi,ss,ms",Arguments.DPart)>
			<cf_errorCode	code = "50602" msg = "Argumentos incorrectos: solo se permite en datepart: yy,mm,wk,dd,hh,mi,ss,ms">
		</cfif>
				   
		<cfreturn 'case when dateadd(#Arguments.DPart#,datediff(#Arguments.DPart#,#Arguments.FechaIni#,#Arguments.FechaFin#),#Arguments.FechaIni#)<=#Arguments.FechaFin# then datediff(#Arguments.DPart#,#Arguments.FechaIni#,#Arguments.FechaFin#) else datediff(#Arguments.DPart#,#Arguments.FechaIni#,#Arguments.FechaFin#)-1 end'>
	<cfelseif LvarDBtype EQ "oracle">
		<cfset LvarFunc = "ROUND(#FechaFin# - #FechaIni#,10)">
		<cfif DPart EQ "yy" OR DPart EQ "yyyy" >
			<cfset LvarFunc = "#FechaFin#, #FechaIni#">
			<cfset LvarFunc = "MONTHS_BETWEEN(#LvarFunc#)">
			<cfreturn "FLOOR(#LvarFunc#/12)">
		<cfelseif DPart EQ "qq">
			<cfset LvarFunc = "#FechaFin#, #FechaIni#">
			<cfset LvarFunc = "MONTHS_BETWEEN(#LvarFunc#)">
			<cfreturn "FLOOR(#LvarFunc#/3)">
		<cfelseif DPart EQ "mm">
			<cfset LvarFunc = "#FechaFin#, #FechaIni#">
			<cfset LvarFunc = "MONTHS_BETWEEN(#LvarFunc#)">
			<cfreturn "FLOOR(#LvarFunc#)">
		<cfelseif LvarDPart EQ "wk">
			<cfreturn "FLOOR((#LvarFunc#)/7)">
		<cfelseif LvarDPart EQ "dd">
			<cfreturn "FLOOR(#LvarFunc#)">
		<cfelseif LvarDPart EQ "hh">
			<cfreturn "FLOOR((#LvarFunc#)*24)">
		<cfelseif LvarDPart EQ "mi">
			<cfreturn "FLOOR((#LvarFunc#)*1440)">	
		<cfelseif LvarDPart EQ "ss">
			<cfreturn "FLOOR((#LvarFunc#)*86400)">
		<cfelseif LvarDPart EQ "ms">
			<cfreturn "FLOOR((#LvarFunc#)*86400000)">
		<cfelse>
			<cf_errorCode	code = "50602" msg = "Argumentos incorrectos: solo se permite en datepart: yy,mm,wk,dd,hh,mi,ss,ms">
		</cfif>
	<cfelseif LvarDBtype EQ "db2">
		<cfset LvarFunc = "DAYS(#FechaFin#)+MIDNIGHT_SECONDS(#FechaFin#)/86400.0 - (DAYS(#FechaIni#)+MIDNIGHT_SECONDS(#FechaIni#)/86400.0)">
		<cfif DPart EQ "yy" OR DPart EQ "yyyy" >
			<cfset LvarFunc = "#FechaFin# - #FechaIni#">
			<cfset LvarFunc = "YEAR(#LvarFunc#) ">
			<cfreturn LvarFunc>
		<cfelseif DPart EQ "qq">
			<cfset LvarFunc = "#FechaFin# - #FechaIni#">
			<cfset LvarFunc = "(YEAR(#LvarFunc#)*12 + MONTH(#LvarFunc#))">
			<cfreturn "DECIMAL(#LvarFunc#/3,18)">
		<cfelseif DPart EQ "mm">
			<cfset LvarFunc = "#FechaFin# - #FechaIni#">
			<cfset LvarFunc = "(YEAR(#LvarFunc#)*12 + MONTH(#LvarFunc#))">
			<cfreturn LvarFunc>
		<cfelseif LvarDPart EQ "wk">
			<cfreturn "FLOOR((#LvarFunc#)/7)">
		<cfelseif LvarDPart EQ "dd">
			<cfset LvarFunc = "FLOOR(#LvarFunc#) ">
			<cfreturn LvarFunc>

			<cfreturn "#LvarFunc#">
		<cfelseif LvarDPart EQ "hh">
			<cfreturn "FLOOR((#LvarFunc#)*24)">
		<cfelseif LvarDPart EQ "mi">
			<cfreturn "FLOOR((#LvarFunc#)*1440)">	
		<cfelseif LvarDPart EQ "ss">
			<cfreturn "FLOOR((#LvarFunc#)*86400)">
		<cfelseif LvarDPart EQ "ms">
			<cfreturn "FLOOR((#LvarFunc#)*86400000)">
		<cfelse>
			<cf_errorCode	code = "50602" msg = "Argumentos incorrectos: solo se permite en datepart: yy,mm,wk,dd,hh,mi,ss,ms">
		</cfif>
	<cfelseif LvarDBtype EQ "db2">
		<cfif mid(LvarFechaIni,1,7) EQ "TO_DATE">
			<cfset LvarFechaIni = replace(LvarFechaIni, "TO_DATE", "DATE", "ALL")>
			<cfset LvarFechaIni = replace(LvarFechaIni, ", 'YYYY-MM-DD HH24:MI:SS'", "", "ALL")>
		<cfelse>
			<cfset LvarFechaIni = "DATE (#LvarFechaIni#)">
		</cfif>
		<cfif mid(LvarFechaFin,1,7) EQ "TO_DATE">
			<cfset LvarFechaFin = replace(LvarFechaFin, "TO_DATE", "DATE", "ALL")>
			<cfset LvarFechaFin = replace(LvarFechaFin, ", 'YYYY-MM-DD HH24:MI:SS'", "", "ALL")>

		<cfelse>
			<cfset LvarFechaFin = "DATE (#LvarFechaFin#)">
		</cfif>
		<cfset LvarFunc = "#LvarFechaFin# - #LvarFechaIni#">
		<cfif DPart EQ "yy">
			<cfset LvarDPart = 256>
		<cfelseif DPart EQ "mm">
			<cfset LvarDPart = 64>
		<cfelseif DPart EQ "wk">
			<cfset LvarDPart = 32>
		<cfelseif DPart EQ "dd">
			<cfset LvarDPart = 16>
		<cfelseif DPart EQ "hh">
			<cfset LvarDPart = 8>
		<cfelseif DPart EQ "mi">
			<cfset LvarDPart = 4>
		<cfelseif DPart EQ "ss">
			<cfset LvarDPart = 2>
		<cfelseif DPart EQ "ms">
			<cfset LvarDPart = 1>
		<cfelse>
			<cf_errorCode	code = "50602" msg = "Argumentos incorrectos: solo se permite en datepart: yy,mm,wk,dd,hh,mi,ss,ms">
		</cfif>
		<cfreturn "timestampdiff(#LvarDPart#,char(#LvarFunc#))">
	</cfif>
</cffunction>

<cffunction name="fnGetDate" returntype="string">
	<cfargument name="fecha"	type="string" required="yes">
	<cfargument name="sinHora"	type="boolean" required="no" default="false">
	
	<cfset LvarFecha = trim(Arguments.fecha)>
	<cfif mid(LvarFecha,1,1) EQ "'" or mid(LvarFecha,1,1) EQ "{">
		<cfreturn fnDMYtoDate(LvarFecha, Arguments.sinHora)>
	<cfelseif Arguments.sinHora>
		<cfreturn fnFechaSinHora(LvarFecha)>
	<cfelse>
		<cfreturn LvarFecha>
	</cfif>
</cffunction>

<cffunction name="fnDMYtoDate" returntype="string">
	<cfargument name="fecha"		type="string"	required="yes">
	<cfargument name="sinHora"		type="boolean"	required="no" default="no">
	
	<cfset var LvarFecha = trim(Arguments.fecha)>
	<cfset LvarFecha = replace(Arguments.fecha,"  "," ","ALL")>
	<cfif mid(LvarFecha,1,1) EQ "'">
		<cfif right(LvarFecha,1) NEQ "'">
			<cf_errorCode	code = "50637"
							msg  = "La constante fecha no está delimitada por apóstrofes: @errorDat_1@"
							errorDat_1="#LvarFecha#"
			>
		</cfif>
		<cfset LvarFecha = mid(LvarFecha,2,len(LvarFecha)-2)>
		<cfset LvarFecha = LSParseDateTime(replace(LvarFecha,"-","/","ALL"))>
		<cfif Arguments.sinHora>
			<cfset LvarFecha = "#dateFormat(LvarFecha, "YYYY-MM-DD")#">
		<cfelse>
			<cfset LvarFecha = "#dateFormat(LvarFecha, "YYYY-MM-DD")# #timeFormat(LvarFecha, "HH:MM:SS")#">
		</cfif>
		<cfreturn fnSTRtoDate("#LvarFecha#", Arguments.sinHora)>
	<cfelseif mid(LvarFecha,1,1) EQ "{">
		<cfif right(LvarFecha,1) NEQ "}">
			<cf_errorCode	code = "50638"
							msg  = "La constante fecha JDBC no está delimitada por llaves: @errorDat_1@"
							errorDat_1="#LvarFecha#"
			>
		</cfif>
		<cfif left(LvarFecha,4) NEQ "{d '" and left(LvarFecha,5) NEQ "{ts '">
			<cf_errorCode	code = "50639"
							msg  = "La constante fecha JDBC solo se puede definir como {d } o {ts }: @errorDat_1@"
							errorDat_1="#LvarFecha#"
			>
		</cfif>

		<cfif left(LvarFecha,3) EQ "{d ">
			<cfreturn fnSTRtoDate("#mid(LvarFecha,5,10)#", true)>
		<cfelseif Arguments.sinHora>
			<cfreturn fnSTRtoDate("#mid(LvarFecha,6,10)#", true)>
		<cfelse>
			<cfreturn fnSTRtoDate("#mid(LvarFecha,6,19)#", false)>
		</cfif>
	<cfelseif LvarDBtype EQ 'sybase'>
		<cfif Arguments.sinHora>
			<cfreturn "convert(date,#LvarFecha#,103)">
		<cfelse>
			<cfreturn "convert(datetime,#LvarFecha#,103)">
		</cfif>
	<cfelseif LvarDBtype EQ 'sqlserver'>
		<cfif Arguments.sinHora>
			<!--- Convierte la hilera a Datetime, luego a string sin hora, y luego otra vez a Datetime pero sin hora --->
			<cfreturn "convert(datetime,substring(#LvarFecha#,1,10),103)">
		<cfelse>
			<cfreturn "convert(datetime,#LvarFecha#,103)">
		</cfif>
	<cfelseif LvarDBtype EQ 'oracle'>
		<cfif Arguments.sinHora>
			<cfreturn "to_date(SUBSTR(#LvarFecha#,1,10), 'DD-MM-YYYY')">
		<cfelse>
			<cfreturn "to_date(#LvarFecha#, 'DD-MM-YYYY HH24:MI:SS')">
		</cfif>
	<cfelseif LvarDBtype EQ 'db2'>
		<cfif Arguments.sinHora>
			<cfset LvarFecha = "SUBSTR(#LvarFecha#, 7, 4) #OP_CONCAT# '-' #OP_CONCAT# SUBSTR(#LvarFecha#, 4, 2) #OP_CONCAT# '-' #OP_CONCAT# SUBSTR(#LvarFecha#, 1, 2) #OP_CONCAT# ' 00:00:00'">
			<cfreturn "to_date(#LvarFecha#, 'YYYY-MM-DD HH24:MI:SS')">
		<cfelse>
			<cfset LvarFecha = "SUBSTR(#LvarFecha#, 7, 4) #OP_CONCAT# '-' #OP_CONCAT# SUBSTR(#LvarFecha#, 4, 2) #OP_CONCAT# '-' #OP_CONCAT# SUBSTR(#LvarFecha#, 1, 2) #OP_CONCAT# SUBSTR(RTRIM(#LvarFecha#) #OP_CONCAT# ' 00:00:00', 11, 9)">
			<cfreturn "to_date(#LvarFecha#, 'YYYY-MM-DD HH24:MI:SS')">
		</cfif>
	</cfif>
</cffunction>

<cffunction name="fnSTRtoDate" returntype="string">
	<cfargument name="fecha"		type="string"	required="yes">
	<cfargument name="sinHora"		type="boolean"	required="no" default="no">

	<cfset var LvarFecha = Arguments.Fecha>
	<cfif LvarDBtype is 'sybase'>
		<cfif Arguments.sinHora>
			<cfreturn "convert(date,'#LvarFecha#', 111)">
		<cfelse>
			<cfreturn "convert(datetime,'#LvarFecha#', 111)">
		</cfif>
	<cfelseif LvarDBtype is 'sqlserver'>
		<cfreturn "convert(datetime,'#LvarFecha#', 111)">
	<cfelseif LvarDBtype is 'oracle'>
		<cfif Arguments.sinHora>
			<cfreturn "TO_DATE ('#LvarFecha#', 'YYYY-MM-DD')">
		<cfelse>
			<cfreturn "TO_DATE ('#LvarFecha#', 'YYYY-MM-DD HH24:MI:SS')">
		</cfif>
	<cfelseif LvarDBtype is 'db2'>
		<cfif Arguments.sinHora>
			<cfreturn "TO_DATE ('#LvarFecha# 00:00:00', 'YYYY-MM-DD HH24:MI:SS')">
		<cfelse>
			<cfreturn "TO_DATE ('#LvarFecha#', 'YYYY-MM-DD HH24:MI:SS')">
		</cfif>
	</cfif>
</cffunction>

<cffunction name="fnDateFormat" returntype="string" output="false">
	<cfargument name="fecha" type="string" required="yes">
	<cfargument name="formato" type="string" required="yes">
	<cfset var LvarPto=1>
	<cfset var LvarReturn = "">
	<cfset var LvarReturnConcat = "">
	
	<cfset Arguments.formato=ucase(Arguments.formato)>

	<cfif ListFind('sybase,sqlserver', LvarDBtype)>
		<cfif formato EQ "YYYYMMDD">
			<cfreturn "convert(varchar,#fecha#, 112)">
		<cfelseif formato EQ "DD/MM/YYYY">
			<cfreturn "convert(varchar,#fecha#, 103)">
		<cfelseif formato EQ "HH:MI:SS">
			<cfreturn "convert(varchar, #fecha#, 108)">
		</cfif>
	<cfelseif LvarDBtype EQ "oracle">
		<cfif find("WK", formato) + find("QQ",formato) EQ 0>
			<cfset LvarFormato = trim(formato)>
			<cfset LvarFormato = replace(LvarFormato,"HH","HH24","ALL")>
			<cfset LvarFormato = replace(LvarFormato,"DY","DDD","ALL")>
			<cfset LvarFormato = replace(LvarFormato,"DW","D","ALL")>
			<cfset LvarFormato = replace(LvarFormato,"WK","IW","ALL")>
			<cfset LvarFormato = replace(LvarFormato,"QQ","Q","ALL")>
			<cfreturn "to_char(#fecha#, '#LvarFormato#')">
		</cfif>
	<cfelseif LvarDBtype EQ "db2">
		<cfif formato EQ "HH:MI:SS">
			<cfreturn "REPLACE(CHAR(TIME(#fnGetDate(Arguments.fecha)#)),'.',':')">
		</cfif>
	</cfif>
	<cfloop condition="LvarPto LTE len(formato)">
		<cfif LvarPto GT 1>
			<cfset LvarReturn = LvarReturn & OP_CONCAT>
		</cfif>
        
		<cfif mid(Arguments.formato,LvarPto,4) EQ "YYYY">
			<cfset LvarReturn = LvarReturn & fnDatePartSTR(fecha,"YYYY")>
			<cfset LvarPto=LvarPto + 4>
		<cfelseif mid(Arguments.formato,LvarPto,2) EQ "YY">
			<cfset LvarReturn = LvarReturn & fnDatePartSTR(fecha,"YY")>
			<cfset LvarPto=LvarPto + 2>
		<cfelseif mid(Arguments.formato,LvarPto,2) EQ "MM">
			<cfset LvarReturn = LvarReturn & fnDatePartSTR(fecha,"MM")>
			<cfset LvarPto=LvarPto + 2>
		<cfelseif mid(Arguments.formato,LvarPto,2) EQ "DY">
			<cfset LvarReturn = LvarReturn & fnDatePartSTR(fecha,"DY")>
			<cfset LvarPto=LvarPto + 2>
		<cfelseif mid(Arguments.formato,LvarPto,2) EQ "DD">
			<cfset LvarReturn = LvarReturn & fnDatePartSTR(fecha,"DD")>
			<cfset LvarPto=LvarPto + 2>
		<cfelseif mid(Arguments.formato,LvarPto,2) EQ "HH">
			<cfset LvarReturn = LvarReturn & fnDatePartSTR(fecha,"HH")>
			<cfset LvarPto=LvarPto + 2>
		<cfelseif mid(Arguments.formato,LvarPto,2) EQ "MI">
			<cfset LvarReturn = LvarReturn & fnDatePartSTR(fecha,"MI")>
			<cfset LvarPto=LvarPto + 2>
		<cfelseif mid(Arguments.formato,LvarPto,2) EQ "SS">
			<cfset LvarReturn = LvarReturn & fnDatePartSTR(fecha,"SS")>
			<cfset LvarPto=LvarPto + 2>
		<cfelseif mid(Arguments.formato,LvarPto,2) EQ "DW">
			<cfset LvarReturn = LvarReturn & fnDatePartSTR(fecha,"DW")>
			<cfset LvarPto=LvarPto + 2>
		<cfelseif mid(Arguments.formato,LvarPto,2) EQ "WK">
			<cfset LvarReturn = LvarReturn & fnDatePartSTR(fecha,"WK")>
			<cfset LvarPto=LvarPto + 2>
		<cfelseif mid(Arguments.formato,LvarPto,2) EQ "QQ">
			<cfset LvarReturn = LvarReturn & fnDatePartSTR(fecha,"QQ")>
			<cfset LvarPto=LvarPto + 2>
		<cfelseif mid(Arguments.formato,LvarPto,1) EQ "Q">
			<cfset LvarReturn = LvarReturn & fnDatePartSTR(fecha,"Q")>
			<cfset LvarPto=LvarPto + 1>
		<cfelseif mid(Arguments.formato,LvarPto,1) EQ "/">
			<cfset LvarReturn = LvarReturn & "'/'">
			<cfset LvarPto=LvarPto + 1>
		<cfelseif mid(Arguments.formato,LvarPto,1) EQ "-">
			<cfset LvarReturn = LvarReturn & "'-'">
			<cfset LvarPto=LvarPto + 1>
		<cfelseif mid(Arguments.formato,LvarPto,1) EQ ":">
			<cfset LvarReturn = LvarReturn & "':'">
			<cfset LvarPto=LvarPto + 1>
		<cfelseif mid(Arguments.formato,LvarPto,1) EQ " ">
			<cfset LvarReturn = LvarReturn & "' '">
			<cfset LvarPto=LvarPto + 1>
		<cfelse>
			<cf_errorCode	code = "50612"
							msg  = "Formato de fecha incorrecto: '@errorDat_1@'"
							errorDat_1="#mid(Arguments.formato,LvarPto,2)#"
			>
		</cfif>
	</cfloop>

	<cfreturn LvarReturn>
</cffunction>

<cffunction name="fnDatePartNUM" returntype="string">
	<cfargument name="fecha" type="string" required="yes">
	<cfargument name="part" type="string" required="yes">

	<cfset var LvarReturn = fnDatePart(Arguments.Fecha, Arguments.part)>
	<cfif ListFind('sybase,sqlserver,DB2', LvarDBtype)>
    	<!--- Ya viene Number --->
	<cfelseif LvarDBtype is 'oracle'>
		<cfset LvarReturn = "to_number(#LvarReturn#)">
	</cfif>
	<cfreturn LvarReturn>
</cffunction>

<cffunction name="fnDatePartSTR" returntype="string">
	<cfargument name="fecha" type="string" required="yes">
	<cfargument name="part" type="string" required="yes">

	<cfset var LvarFecha = Trim(Arguments.fecha)>
	<cfset var LvarReturn = fnDatePart(Arguments.fecha, Arguments.part)>
	<cfif ListFind('sybase,sqlserver', LvarDBtype)>
		<cfif ListFind('YYYY,Q,DW,DY', UCase(Arguments.part))>
			<cfset LvarReturn = "convert(varchar,#LvarReturn#)">
		<cfelseif UCase(Arguments.part) EQ "YY">
			<cfset LvarReturn = fnDatePart(Arguments.fecha, "YYYY")>
			<cfset LvarReturn = "substring(convert(varchar,#LvarReturn#),3,2)">
		<cfelse>
			<cfset LvarReturn = "right('00' + convert(varchar,#LvarReturn#), 2)">
		</cfif>
	<cfelseif LvarDBtype is 'oracle'>
		<!--- Ya viene STRING --->
		<cfif NOT ListFind('YYYY,Q,DW,DY', UCase(Arguments.part))>
			<cfset LvarReturn = "RIGHT('00' #OP_CONCAT# #LvarReturn#, 2)">
		</cfif>
	<cfelseif LvarDBtype is 'db2'>
		<cfif ListFind('YYYY,Q,DW,DY', UCase(Arguments.part))>
			<cfset LvarReturn = "RTRIM(CHAR(#LvarReturn#))">
		<cfelseif UCase(Arguments.part) EQ "YY">
			<cfset LvarReturn = fnDatePart(Arguments.fecha, "YY")>
			<cfset LvarReturn = "right('00' #OP_CONCAT# RTRIM(CHAR(#LvarReturn#)), 2)">
		<cfelse>
			<cfset LvarReturn = "right('00' #OP_CONCAT# RTRIM(CHAR(#LvarReturn#)), 2)">
		</cfif>
	</cfif>
	<cfreturn LvarReturn>
</cffunction>

<cffunction name="fnDatePart" returntype="string">
	<cfargument name="fecha" type="string" required="yes">
	<cfargument name="part" type="string" required="yes">

	<cfset var LvarFecha = Trim(Arguments.fecha)>
	<cfset var LvarReturn = "">
	<cfif ListFind('sybase,sqlserver', LvarDBtype)>
		<cfswitch expression="#UCase(Arguments.part)#">
			<cfcase value="YYYY">
				<cfset LvarReturn = "datepart(yy, #LvarFecha#)">
			</cfcase>
			<cfcase value="YY">
				<cfset LvarReturn = "datepart(yy, #LvarFecha#)">
				<cfset LvarReturn = "#LvarReturn#-(floor(#LvarReturn#/100)*100)">
			</cfcase>
			<cfcase value="MM">
				<cfset LvarReturn = "datepart(mm, #LvarFecha#)">
			</cfcase>
			<cfcase value="DD">
				<cfset LvarReturn = "datepart(dd, #LvarFecha#)">
			</cfcase>
			<cfcase value="HH">
				<cfset LvarReturn = "datepart(hh, #LvarFecha#)">
			</cfcase>
			<cfcase value="MI">
				<cfset LvarReturn = "datepart(mi, #LvarFecha#)">
			</cfcase>
			<cfcase value="SS">
				<cfset LvarReturn = "datepart(ss, #LvarFecha#)">
			</cfcase>
			<cfcase value="DY">
				<cfset LvarReturn = "datepart(dy, #LvarFecha#)">
			</cfcase>
			<cfcase value="DW">
				<cfset LvarReturn = "datepart(dw, #LvarFecha#)">
			</cfcase>
			<cfcase value="WK">
				<cfset LvarReturn = "datepart(wk, #LvarFecha#)">
			</cfcase>
			<cfcase value="QQ">
				<cfset LvarReturn = "datepart(qq, #LvarFecha#)">
			</cfcase>
			<cfcase value="Q">
				<cfset LvarReturn = "datepart(qq, #LvarFecha#)">
			</cfcase>
			<cfdefaultcase>
				<cf_errorCode	code = "50613"
								msg  = "datepart inválida para dbfunction: '@errorDat_1@'"
								errorDat_1="#Arguments.part#"
				>
			</cfdefaultcase>
		</cfswitch>
	<cfelseif LvarDBtype is 'oracle'>
		<cfswitch expression="#UCase(Arguments.part)#">
			<cfcase value="SSSS">
				<cfset LvarReturn = "to_char(#LvarFecha#, 'SSSS')">
			</cfcase>
			<cfcase value="JJ">
				<cfset LvarReturn = "to_char(#LvarFecha#, 'J')">
			</cfcase>
			<cfcase value="YYYY">
				<cfset LvarReturn = "to_char(#LvarFecha#, 'YYYY')">
			</cfcase>
			<cfcase value="YY">
				<cfset LvarReturn = "to_char(#LvarFecha#, 'YY')">
			</cfcase>
			<cfcase value="MM">
				<cfset LvarReturn = "to_char(#LvarFecha#, 'MM')">
			</cfcase>
			<cfcase value="DD">
				<cfset LvarReturn = "to_char(#LvarFecha#, 'DD')">
			</cfcase>
			<cfcase value="HH">
				<cfset LvarReturn = "to_char(#LvarFecha#, 'HH24')">
			</cfcase>
			<cfcase value="MI">
				<cfset LvarReturn = "to_char(#LvarFecha#, 'MI')">
			</cfcase>
			<cfcase value="SS">
				<cfset LvarReturn = "to_char(#LvarFecha#, 'SS')">
			</cfcase>
			<cfcase value="DY">
				<cfset LvarReturn = "to_char(#LvarFecha#, 'DDD')">
			</cfcase>
			<cfcase value="DW">
				<cfset LvarReturn = "to_char(#LvarFecha#, 'D')">
			</cfcase>
			<cfcase value="WK">
				<cfset LvarReturn = "(to_char(#LvarFecha#,'ww')+case when to_char(#LvarFecha#,'d')<to_char(to_date(to_char(#LvarFecha#,'YYYY') #OP_CONCAT# '-01-01','yyyy-mm-dd'),'d') then 1 else 0 end)">
			</cfcase>
			<cfcase value="QQ">
				<cfset LvarReturn = "to_char(#LvarFecha#, 'Q')">
			</cfcase>
			<cfcase value="Q">
				<cfset LvarReturn = "to_char(#LvarFecha#, 'Q')">
			</cfcase>
			<cfdefaultcase>
				<cf_errorCode	code = "50613"
								msg  = "datepart inválida para dbfunction: '@errorDat_1@'"
								errorDat_1="#Arguments.part#"
				>
			</cfdefaultcase>
		</cfswitch>
	<cfelseif LvarDBtype is 'db2'>
		<cfswitch expression="#UCase(Arguments.part)#">
			<cfcase value="JJ">
				<cfset LvarReturn = "DAYS(#LvarFecha#)">
			</cfcase>
			<cfcase value="SSSS">
				<cfset LvarReturn = "MIDNIGHT_SECONDS(#LvarFecha#)">
			</cfcase>
			<cfcase value="YYYY">
				<cfset LvarReturn = "YEAR(#LvarFecha#)">
			</cfcase>
			<cfcase value="YY">
				<cfset LvarReturn = "YEAR(#LvarFecha#)">
				<cfset LvarReturn = "#LvarReturn#-(floor(#LvarReturn#/100)*100)">
			</cfcase>
			<cfcase value="MM">
				<cfset LvarReturn = "MONTH(#LvarFecha#)">
			</cfcase>
			<cfcase value="DD">
				<cfset LvarReturn = "DAY(#LvarFecha#)">
			</cfcase>
			<cfcase value="HH">
				<cfset LvarReturn = "HOUR(#LvarFecha#)">
			</cfcase>
			<cfcase value="MI">
				<cfset LvarReturn = "MINUTE(#LvarFecha#)">
			</cfcase>
			<cfcase value="SS">
				<cfset LvarReturn = "SECOND(#LvarFecha#)">
			</cfcase>
			<cfcase value="DY">
				<cfset LvarReturn = "DAYOFYEAR(#LvarFecha#)">
			</cfcase>
			<cfcase value="DW">
				<cfset LvarReturn = "DAYOFWEEK(#LvarFecha#)">
			</cfcase>
			<cfcase value="WK">
				<cfset LvarReturn = "WEEK(#LvarFecha#)">
			</cfcase>
			<cfcase value="QQ">
				<cfset LvarReturn = "QUARTER(#LvarFecha#)">
			</cfcase>
			<cfcase value="Q">
				<cfset LvarReturn = "QUARTER(#LvarFecha#)">
			</cfcase>
			<cfdefaultcase>
				<cf_errorCode	code = "50613"
								msg  = "datepart inválida para dbfunction: '@errorDat_1@'"
								errorDat_1="#Arguments.part#"
				>
			</cfdefaultcase>
		</cfswitch>
	</cfif>

	<cfreturn LvarReturn>
</cffunction>

<cffunction name="fnNow" access="public" output="no">
	<cfif ListFind('sybase,sqlserver', LvarDBtype)>
		<cfreturn "getdate()">
	<cfelseif LvarDBtype EQ "oracle">
		<cfreturn "SYSDATE">
	<cfelseif LvarDBtype EQ "db2">
		<cfreturn "CURRENT TIMESTAMP">
	</cfif>
</cffunction>

<cffunction name="fnToday" access="public" output="no">
	<cfif LvarDBtype EQ 'sybase'>
		<cfreturn "convert(date,getdate())">
	<cfelseif LvarDBtype EQ 'sqlserver'>
		<cfreturn "convert (datetime, convert(varchar, getdate(), 103), 103)">
	<cfelseif LvarDBtype EQ "oracle">
		<cfreturn "TO_DATE(SYSDATE)">
	<cfelseif LvarDBtype EQ "db2">
		<cfreturn fnFechaSinHora("CURRENT TIMESTAMP")>
	</cfif>
</cffunction>



