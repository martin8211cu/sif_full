<cfsilent>
<!---

	Funciones de Hileras
		en los argumentos:
				Hilera =  Hilera significa un campo tipo hilera o una constante tipo hilera delimitada por apostrofes
					CAMPO_HILERA ó 'CONSTANTE HILERA'
	<cf_dbfunction name="OP_concat"	args=""  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="fn_replace"	args=""  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="fn_len"	args=""  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="concat"	args="hilera1,hilera2,'hilera3','hilera4'"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="to_char"	args="hilera"  len="tamaño" [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="length"	args="hilera"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="sPart"		args="hilera_principal,inicio,tamaño"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="sReplace"	args="hilera_principal,hilera_a_buscar,hilera_a_cambiar"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="sRepeat"	args="hilera_a_repetir,cantidad"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="sFind"		args="hilera_principal,hilera_a_buscar [,posicion_inicial=1]"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="chr"		args="int"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="isNumber"	args="hilera"  [datasource="<dsn>"] [returnvariable="<variable>"] >
				"sPart,sReplace,sRepeat,sFind" = "string_Part,string_Replace,string_Repeat,string_Find"

	Funciones de Números
		en los argumentos: 
				HileraConNumeros_o_Numero = HileraConNumeros significa un campo tipo hilera o una constante tipo hilera delimitada por apostrofes cuyo contenido sean dígitos numéricos
					CAMPO_HILERA ó '12345' ó CAMPO_NUMERICO ó 12345

	<cf_dbfunction name="to_integer"	args="HileraConNumeros_o_Numero"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="to_number"		args="HileraConNumeros_o_Numero" [isInteger="true_sqlserver"] [dec="decimales_a_truncar=0"]  [datasource="<dsn>"] [returnvariable="<variable>"] >
		OJO: to_number: cuando el numero tiene decimales, se debe indicar attribute "dec=decimales_a_Truncar" o bien "isInteger=false".  Si no se hace esto, en "sqlserver" en lugar de truncar a 0 decimales, se redondea a 0 decimales.
	<cf_dbfunction name="to_float"		args="HileraConNumeros_o_Numero" [dec="decimales_a_redondear=12"]  [datasource="<dsn>"] [returnvariable="<variable>"] >

	<cf_dbfunction name="to_char_integer"	args="HileraConNumeros_o_Numero"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="to_char_float"		args="HileraConNumeros_o_Numero"  [dec="decimales_a_truncar=12"]  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="to_char_money"		args="HileraConNumeros_o_Numero"  [datasource="<dsn>"] [returnvariable="<variable>"] >

	<cf_dbfunction name="mod"				args="Divisor,Dividiendo"  [datasource="<dsn>"] [returnvariable="<variable>"] >
		Divisor y Dividiendo son CAMPOS o CONSTANTES numéricas.
	
	<cf_dbfunction name="ceiling"			args=""  [datasource="<dsn>"] [returnvariable="<variable>"] >
		Devuelve el entero más pequeño que es mayor o igual a un numero dado
		
		
	Funciones especiales para condiciones: where, when, having

	<cf_dbfunction name="findOneOf"			args="Hilera_principal,Caracteres_a_buscar_sin_apostrofes"  [datasource="<dsn>"] [returnvariable="<variable>"] >
		Caracteres_a_buscar_sin_apostrofes es una Constante tipo LIKE [...ini-fin...] o LIKE [^...ini-fin...] pero no se le debe colocar ni apóstrofes ni corchetes
		
	<cf_dbfunction name="withData"			args="CAMPO"      [isString="true"] [datasource="<dsn>"] [returnvariable="<variable>"] > = 1 ó 0
	<cf_dbfunction name="isNumeric"			args="HILERA"     [datasource="<dsn>"] [returnvariable="<variable>"] > = 1 ó 0
	<cf_dbfunction name="LOBisNull"			args="CAMPO_LOB"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="LOBisNotNull"		args="CAMPO_LOB"  [datasource="<dsn>"] [returnvariable="<variable>"] >

	Funciones de Fechas
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
		
	De hilera_DD/MM/YYYY_o_DD-MM-YYYY_o_YYYYMMDD a Fecha (Ojo, si se indica YMD=true, no se puede usar guiones o slash)
	<cf_dbfunction name="to_date"		args="FechaDMY" YMD="true/[false]" [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="to_datetime"	args="FechaDMY" YMD="true/[false]" [datasource="<dsn>"] [returnvariable="<variable>"] >

	De Fecha a Hilera
	<cf_dbfunction name="date_format"	args="Fecha,formato_sin_apostrofes"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="to_sdate"		args="Fecha"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="to_sdateDMY"	args="Fecha"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="to_chartime"	args="Fecha"  [datasource="<dsn>"] [returnvariable="<variable>"] >

	Sumas a fecha
	<cf_dbfunction name="dateadd"		args="cantidad, Fecha [, parte_Fecha_sin_apostrofes_deCantidad=DD]"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="dateaddx"		args="parte_Fecha_sin_apostrofes, cantidad, Fecha"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="dateaddm"		args="cantidad_meses, Fecha"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="timeadd"		args="cantidad_segundos, Fecha"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="dateaddString"	args="cantidad_dias, Hilera_FechaDMY_sin_apostrofes"  [datasource="<dsn>"] [returnvariable="<variable>"] >

	Diferencia de fechas
	<cf_dbfunction name="datediff"			args="FechaInicial, FechaFinal [,parte_Fecha_sin_apostrofes_deResultado=DD]"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="datediffstring"	args="Hilera_FechaDMY_sin_apostrofes_INICIAL, Hilera_FechaDMY_sin_apostrofes_FINAL"  [datasource="<dsn>"] [returnvariable="<variable>"] >
	<cf_dbfunction name="timediff"			args="FechaInicial, FechaFinal"  [datasource="<dsn>"] [returnvariable="<variable>"] >

	
	Con ReturnVariable devuelve el string en la variable
	Sin ReturnVariable pinta el string en el <cfoutput>
	Todas las funciones con fechas se maneja en DIAS a menos que se indique lo contrario

--->

<cfparam name="Attributes.name">
<cfparam name="Attributes.datasource" default="asp">
<cfparam name="Attributes.args" default="">
<cfparam name="Attributes.returnvariable" type="string" default="">
<cfparam name="Attributes.delimiters" type="string" default=",">

<cfset Attributes.name = LCase(trim(Attributes.name))>
<cfset Attributes.args = trim(Attributes.args)>

<!--- Asegurarse de que la informacion sobre las conexiones este disponible --->
<cfif not isdefined("Application.dsinfo.#Attributes.datasource#")>
	<cfhttp url="http://#cgi.SERVER_NAME#:#cgi.SERVER_PORT#/cfmx/sif/tasks/datasources.cfm"
			timeout="30"
	>
	<cfif not StructKeyExists(Application.dsinfo, Attributes.datasource)>
		<cf_errorCode	code = "50599"
						msg  = "Datasource no definido: @errorDat_1@"
						errorDat_1="#HTMLEditFormat(Attributes.datasource)#"
		>
	</cfif>
</cfif>

<cfset LvarDBtype		= Application.dsinfo[Attributes.datasource].type>
<cfset LvarDbFunction	= fnDbFunction()>
</cfsilent><cfif Attributes.returnvariable EQ ""><cfoutput>#LvarDbFunction#</cfoutput><cfelse><cfset Caller[Attributes.returnvariable] = LvarDbFunction></cfif>
<cffunction name="fnDbFunction" returntype="string" output="false">
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
	<cfset valid_functions = valid_functions & "op_concat,fn_len,fn_replace,">
	<cfset valid_functions = valid_functions & "chr,concat,to_char,length,">
	<cfset valid_functions = valid_functions & "spart,sreplace,srepeat,sfind,">
	<cfset valid_functions = valid_functions & "like,">
	<cfset valid_functions = valid_functions & "string_part,string_replace,string_repeat,string_find,">
	<!--- Funciones de Números --->
	<cfset valid_functions = valid_functions & "to_number,to_integer,to_float,to_char_integer,to_char_float,to_char_currency,mod,ceiling,">
	<!--- Funciones especiales para condiciones: where, when, having --->
	<cfset valid_functions = valid_functions & "findoneof,">
	<!--- Funciones para LOB --->
	<cfset valid_functions = valid_functions & "islobnull,islobnotnull,lobisnull,lobisnotnull,withdata,isnumeric,">

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
			<cfparam name="Attributes.len" 		type="numeric" default="255">
			<cfif Attributes.len EQ 0>
				<cfreturn "convert (varchar,#Attributes.args#)">
			<cfelseif LvarDBtype EQ 'sybase' AND (Attributes.len GT 16000 OR Attributes.len LT 0)>
				<cfset Attributes.len = 16000>
			<cfelseif LvarDBtype EQ  'sqlserver' AND (Attributes.len GT 8000 OR Attributes.len LT 0)>
				<cfset Attributes.len = 8000>
			</cfif>
			<cfreturn "rtrim(convert (varchar(#Attributes.len#), #Attributes.args#))">
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
			<cfreturn "coalesce(datalength (#Attributes.args#),0)">
		<cfelseif Attributes.name is 'string_part' OR Attributes.name is 'spart'>
			<cfreturn "substring (#fnGetArgI(1)#, #fnGetArgI(2)#, #fnGetArgI(3)#)"> 
		<cfelseif Attributes.name is 'fn_replace'>
			<cfif LvarDBtype EQ "sqlserver">
				<cfreturn "replace">
			<cfelse>
				<cfreturn "str_replace">
			</cfif>
		<cfelseif Attributes.name is 'string_replace' OR Attributes.name is 'sreplace'>
			<cfif LvarDBtype EQ "sqlserver">
				<cfreturn "replace(#fnGetArgI(1)#,#fnGetArgI(2)#,#fnGetArgI(3)#)">
			<cfelse>
				<cfreturn "str_replace(#fnGetArgI(1)#,#fnGetArgI(2)#,#fnGetArgI(3)#)">
			</cfif>
		<cfelseif Attributes.name is 'string_repeat' OR Attributes.name is 'srepeat'>
			<cfreturn "replicate(#fnGetArgI(1)#,#fnGetArgI(2)#)">
		<cfelseif Attributes.name is 'string_find' OR Attributes.name is 'sfind'>
			<cfif ListLen(Attributes.args, Attributes.delimiters) EQ 3>
				<cfset LvarFind = "charindex(#fnGetArgI(2)#,substring(#fnGetArgI(1)#,#fnGetArgI(3)#,255))">
				<cfreturn "case when #LvarFind# = 0 then 0 else #LvarFind# + #fnGetArgI(3)# -1 end">
			<cfelse>
				<cfreturn "charindex(#fnGetArgI(2)#,#fnGetArgI(1)#)">
			</cfif>

		<cfelseif Attributes.name is 'to_integer'>
			<cfif LvarDBtype EQ 'sybase'>
				<cfreturn "convert(numeric, #Attributes.args#)">
			<cfelse>
				<cfreturn "round(convert(numeric(30,12),#Attributes.args#),0,1)">
			</cfif>
		<cfelseif Attributes.name is 'to_number'>
			<cfif isdefined("Attributes.dec") AND len(Attributes.dec)>
				<cfif LvarDBtype EQ 'sybase'>
					<cfreturn "convert(numeric(30,#Attributes.dec#), #Attributes.args#)">
				<cfelse>
					<cfreturn "convert(numeric(30,#Attributes.dec#), round(convert(numeric(30,12),#Attributes.args#),#Attributes.dec#,1))">
				</cfif>
			<cfelse>
				<cfparam name="Attributes.isInteger" type="boolean" default="true">
				<<cfif LvarDBtype EQ 'sqlserver'>
					<cfreturn "convert(int,#Attributes.args#)">
				<cfelseif LvarDBtype EQ 'sybase' OR Attributes.isInteger>
					<cfreturn "convert(numeric,#Attributes.args#)">
				<cfelse>
					<cfreturn "round(convert(numeric(30,12),#Attributes.args#),0,1)">
				</cfif>
			</cfif>
		<cfelseif Attributes.name is 'to_float'>
			<cfif isdefined("Attributes.dec") AND len(Attributes.dec)>
				<cfreturn "round(convert(numeric(30,12),#Attributes.args#),#Attributes.dec#)">
			<cfelse>
				<cfreturn "convert(numeric(30,12),#Attributes.args#)">
			</cfif>

		<cfelseif Attributes.name is 'to_char_integer'>
			<cfif LvarDBtype EQ 'sybase'>
				<cfreturn "convert(varchar(31), convert(numeric, #Attributes.args#))">
			<cfelse>
				<cfreturn "convert(varchar(31), convert(bigint, convert(float, #Attributes.args#)))">
			</cfif>
		<cfelseif Attributes.name is 'to_char_float'>
			<cfif isdefined("Attributes.dec") AND len(Attributes.dec) AND Attributes.dec GT 0 AND Attributes.dec LTE 12>
				<cfreturn "convert(varchar(31), convert(numeric(30,#Attributes.dec#),#Attributes.args#))">
			<cfelse>
				<cfreturn "convert(varchar(31), convert(numeric(30,12),#Attributes.args#))">
			</cfif>
		<cfelseif Attributes.name is 'to_char_currency'>
			<cfreturn "convert(varchar(31), convert(money,#Attributes.args#), 1)">

		<cfelseif Attributes.name is 'mod'>
			<cfif ListLen(Attributes.args, Attributes.delimiters) NEQ 2>
				<cf_errorCode	code = "50607" msg = "Argumentos incorrectos: se requieren dos argumentos">
			<cfelse>
				<cfreturn "#fnGetArgI(1)#%#fnGetArgI(2)#">
			</cfif>
		<cfelseif Attributes.name is 'ceiling'>
			<cfreturn "#fnCeiling()#">
		<cfelseif Attributes.name is 'findoneof'>
			<cfif ListLen(Attributes.args, Attributes.delimiters) NEQ 2>
				<cf_errorCode	code = "50600" msg = "Argumentos incorrectos">
			<cfelse>
				<cfset Lvar_findOneOf = "'%[" & fnGetArgI(2) & "]%'">
				<cfreturn "#fnGetArgI(1)# like #Lvar_findOneOf#">
			</cfif>
		<cfelseif Attributes.name is 'like'>
			<cfset Attributes.args = replaceNoCase(Attributes.args," LIKE ",Attributes.delimiters)>
			<cfif ListLen(Attributes.args, Attributes.delimiters) NEQ 2>
				<cf_errorCode	code = "50600" msg = "Argumentos incorrectos: #Attributes.args# ">
			<cfelse>
				<cfreturn "#fnGetArgI(1)# LIKE #fnGetArgI(2)#">
			</cfif>
		<cfelseif Attributes.name is 'withdata'>
			<cfparam name="Attributes.isString" default="true">
			<cfset LvarCondicion =  "coalesce(datalength(#Attributes.args#),0)<>0">
			<cfif Attributes.isString>
				<cfset LvarCondicion =  LvarCondicion & " AND coalesce(ltrim(convert(varchar(255),#Attributes.args#)), ' ')<>' '">
			</cfif>
			<cfreturn "case when #LvarCondicion# then 1 else 0 end">
		<cfelseif Attributes.name is 'isnumeric'>
			<cfreturn "(LTRIM(RTRIM(#Attributes.args#)) NOT LIKE '[^-0123456789.]%' AND LTRIM(RTRIM(#Attributes.args#)) NOT LIKE '_%[^0123456789.]%' AND LTRIM(RTRIM(#Attributes.args#)) NOT LIKE '%.%.%')">
		<cfelseif Attributes.name is 'lobisnull' OR Attributes.name is 'islobnull'>
			<cfif LvarDBtype EQ 'sybase'>
				<cfreturn "coalesce(datalength(#Attributes.args#),0) = 0">
			<cfelse>
				<cfreturn "#Attributes.args# is null">
			</cfif>
		<cfelseif Attributes.name is 'lobisnotnull' or Attributes.name is 'islobnotnull'>
			<cfif LvarDBtype EQ 'sybase'>
				<cfreturn "coalesce(datalength(#Attributes.args#),0) <> 0">
			<cfelse>
				<cfreturn "#Attributes.args# is not null">
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
			<cfparam name="Attributes.len" 		type="numeric" default="255">
			<cfif Attributes.len EQ 0>
				<cfreturn "TO_CHAR(#Attributes.args#)">
			<cfelseif Attributes.len GT 4000 OR Attributes.len LT 0>
				<cfset Attributes.len = 4000>
			</cfif>
			<!--- SUBSTR convierte implicitamente a String --->
			<cfreturn "RTRIM(SUBSTR(#Attributes.args#,1,#Attributes.len#))">
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
			<cfreturn "coalesce(LENGTH(#Attributes.args#),0)">
		<cfelseif Attributes.name is 'string_part' OR Attributes.name is 'spart'>
			<cfreturn "SUBSTR (#fnGetArgI(1)#, #fnGetArgI(2)#, #fnGetArgI(3)#)">
		<cfelseif Attributes.name is 'fn_replace'>
			<cfreturn "REPLACE">
		<cfelseif Attributes.name is 'string_replace' OR Attributes.name is 'sreplace'>
			<cfreturn "REPLACE(#fnGetArgI(1)#,#fnGetArgI(2)#,#fnGetArgI(3)#)">
		<cfelseif Attributes.name is 'string_repeat' OR Attributes.name is 'srepeat'>
			<cfreturn "SUBSTR(RPAD(' ',#fnGetArgI(2)#*LENGTH(#fnGetArgI(1)#)+1,#fnGetArgI(1)#),2)">
		<cfelseif Attributes.name is 'string_find' OR Attributes.name is 'sfind'>
			<cfif ListLen(Attributes.args, Attributes.delimiters) EQ 3>
				<cfreturn "INSTR(#fnGetArgI(1)#, #fnGetArgI(2)#, #fnGetArgI(3)#)">
			<cfelse>
				<cfreturn "INSTR(#fnGetArgI(1)#, #fnGetArgI(2)#)">
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
				<cfreturn "ROUND(#Attributes.args#,12)">
			</cfif>

		<cfelseif Attributes.name is 'to_char_integer'>
			<cfreturn "trim(to_char(TRUNC(#Attributes.args#)))">
		<cfelseif Attributes.name is 'to_char_float'>
			<cfif isdefined("Attributes.dec") AND len(Attributes.dec) AND Attributes.dec GT 0 AND Attributes.dec LTE 12>
				<cfset LvarFMT = "99999999999999999990." & repeatstring('9', #Attributes.dec#)>
			<cfelse>
				<cfset Attributes.dec = 12>
				<cfset LvarFMT = "99999999999999999990." & repeatstring('9', #Attributes.dec#)>
			</cfif>
			<cfreturn "trim(to_char(TRUNC(#Attributes.args#,#Attributes.dec#), '#LvarFMT#'))">
		<cfelseif Attributes.name is 'to_char_currency'>
			<cfreturn "trim(to_char(#Attributes.args#, '9,999,999,999,999,990.99'))">

		<cfelseif Attributes.name is 'mod'>
			<cfreturn "mod(#fnGetArgI(1)#,#fnGetArgI(2)#)">
		<cfelseif Attributes.name is 'ceiling'>
			<cfreturn "#fnCeiling()#">
		<cfelseif Attributes.name is 'findoneof'>
			<cfif ListLen(Attributes.args, Attributes.delimiters) NEQ 2>
				<cf_errorCode	code = "50600" msg = "Argumentos incorrectos">
			<cfelse>
				<cfset Lvar_findOneOf = "'[" & fnGetArgI(2) & "]'">
				<cfreturn "regexp_instr(rtrim(#fnGetArgI(1)#), #Lvar_findOneOf#)>0">
			</cfif>
		<cfelseif Attributes.name is 'like'>
			<cfset Attributes.args = replaceNoCase(Attributes.args," LIKE ",Attributes.delimiters)>
			<cfif ListLen(Attributes.args, Attributes.delimiters) NEQ 2>
				<cf_errorCode	code = "50600" msg = "Argumentos incorrectos">
			<cfelse>
				<cfreturn "#fnGetArgI(1)# LIKE #fnGetArgI(2)#">
			</cfif>
		<cfelseif Attributes.name is 'withdata'>
			<cfparam name="Attributes.isString" default="true">
			<cfset LvarCondicion =  "coalesce(LENGTH(#Attributes.args#),0)<>0">
			<cfif Attributes.isString>
				<cfset LvarCondicion =  LvarCondicion & " AND coalesce(LTRIM(SUBSTR(#Attributes.args#,1,255)), ' ')<>' '">
			</cfif>
			<cfreturn "case when #LvarCondicion# then 1 else 0 end">
		<cfelseif Attributes.name is 'isnumeric'>
			<cfreturn "regexp_instr(TRIM(#Attributes.args#),'[^-0123456789.].*')+regexp_instr(TRIM(#Attributes.args#),'..*[^0123456789.].*')+regexp_instr(TRIM(#Attributes.args#),'.*\..*\..*')=0">
		<cfelseif Attributes.name is 'lobisnull' OR Attributes.name is 'islobnull'>
			<cfreturn "#Attributes.args# is null">
		<cfelseif Attributes.name is 'lobisnotnull' or Attributes.name is 'islobnotnull'>
			<cfreturn "#Attributes.args# is not null">
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
			<cfparam name="Attributes.len" 		type="numeric" default="255">
			<cfparam name="Attributes.isNumber" type="boolean" default="true">
			<cfif Attributes.len GT 32000 OR Attributes.len LT 0>
				<cfset Attributes.len = 32000>
			</cfif>
			<cfif Attributes.isNumber>
				<cfif Attributes.len EQ 0>
					<cfreturn "fnTO_CHAR(#Attributes.args#,'*')">
				</cfif>
				<cfreturn "RTRIM(SUBSTRING(#Attributes.args# || ' ',1,#Attributes.len#,OCTETS))">
			<cfelse>
				<cfif Attributes.len EQ 0>
					<cfreturn "VARCHAR(#Attributes.args#)">
				</cfif>
				<cfreturn "RTRIM(SUBSTRING(VARCHAR(#Attributes.args#),1,#Attributes.len#,OCTETS))">
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
			<cfreturn "coalesce(LENGTH(#Attributes.args#),0)">
		<cfelseif Attributes.name is 'string_part' OR Attributes.name is 'spart'>
			<cfset LvarStr = #fnGetArgI(1)#>
			<cfset LvarIni = #fnGetArgI(2)#>
			<cfif not isnumeric(LvarIni)>
				<cfset LvarIni = "INTEGER(#LvarIni#)">
			</cfif>
			<cfset LvarLon = #fnGetArgI(3)#>
			<cfif not isnumeric(LvarLon)>
				<cfset LvarLon = "INTEGER(#LvarLon#)">
			</cfif>
			<cfreturn "SUBSTRING(#LvarSTR#,#LvarINI#,#LvarLon#,OCTETS)">
		<cfelseif Attributes.name is 'fn_replace'>
			<cfreturn "REPLACE">
		<cfelseif Attributes.name is 'string_replace' OR Attributes.name is 'sreplace'>
			<cfset LvarStr		= #fnGetArgI(1)#>
			<cfset LvarFndStr	= #fnGetArgI(2)#>
			<cfset LvarNewStr	= #fnGetArgI(3)#>
			<cfreturn "REPLACE(#LvarStr#,#LvarFndStr#,#LvarNewStr#)">
		<cfelseif Attributes.name is 'string_repeat' OR Attributes.name is 'srepeat'>
			<cfset LvarStr = #fnGetArgI(1)#>
			<cfset LvarNum = #fnGetArgI(2)#>
			<cfif not isnumeric(LvarNum)>
				<cfset LvarNum = "INTEGER(#LvarNum#)">
			</cfif>
			<cfreturn "REPEAT(#LvarStr#,#LvarNum#)">
		<cfelseif Attributes.name is 'string_find' OR Attributes.name is 'sfind'>
			<cfset LvarStr		= #fnGetArgI(1)#>
			<cfset LvarFndStr	= #fnGetArgI(2)#>
			<cfif ListLen(Attributes.args, Attributes.delimiters) EQ 3>
				<cfset LvarIni	= #fnGetArgI(3)#>
				<cfif not isnumeric(LvarIni)>
					<cfset LvarIni = "INTEGER(#LvarIni#)">
				</cfif>
				<cfreturn "LOCATE(#LvarFndStr#,#LvarStr#,#LvarIni#)">
			<cfelse>
				<cfreturn "LOCATE(#LvarFndStr#,#LvarStr#)">
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
				<cfreturn "ROUND(DECIMAL(#Attributes.args#,30,12),#Attributes.dec#)">
			<cfelse>
				<cfreturn "DECIMAL(#Attributes.args#,30,12)">
			</cfif>

		<cfelseif Attributes.name is 'to_char_integer'>
			<cfreturn "fnTO_CHAR(DECIMAL(#Attributes.args#),'999999999999999990')">
		<cfelseif Attributes.name is 'to_char_float'>
			<cfif isdefined("Attributes.dec") AND len(Attributes.dec) AND Attributes.dec GT 0 AND Attributes.dec LTE 10>
				<cfset LvarFMT = "99999999999999999990." & repeatstring('9', Attributes.dec)>
			<cfelse>
				<cfset LvarFMT = "99999999999999999990.9999999999">
			</cfif>
			<cfreturn "fnTO_CHAR(#Attributes.args#, '#LvarFMT#')">
		<cfelseif Attributes.name is 'to_char_currency'>
			<cfreturn "fnTO_CHAR(ROUND(#Attributes.args#,2), '9,999,999,999,999,990.99')">

		<cfelseif Attributes.name is 'mod'>
			<cfreturn "mod(#fnGetArgI(1)#,#fnGetArgI(2)#)">
		<cfelseif Attributes.name is 'ceiling'>
			<cfreturn "#fnCeiling()#">
		<cfelseif Attributes.name is 'findoneof'>
			<cfif ListLen(Attributes.args, Attributes.delimiters) NEQ 2>
				<cf_errorCode	code = "50600" msg = "Argumentos incorrectos">
			<cfelse>
				<cfset Lvar_findOneOf = "'%[" & fnGetArgI(2) & "]%'">
				<cfreturn "fnLIKE(rtrim(#fnGetArgI(1)#), #Lvar_findOneOf#)>0">
			</cfif>
		<cfelseif Attributes.name is 'like'>
			<cfset Attributes.args = replaceNoCase(Attributes.args," LIKE ",Attributes.delimiters)>
			<cfif ListLen(Attributes.args, Attributes.delimiters) NEQ 2>
				<cf_errorCode	code = "50600" msg = "Argumentos incorrectos">
			<cfelse>
				<cfreturn "fnLIKE(rtrim(#fnGetArgI(1)#), rtrim(#fnGetArgI(2)#))=1">
			</cfif>
		<cfelseif Attributes.name is 'withdata'>
			<cfparam name="Attributes.isString" default="true">
			<cfset LvarCondicion =  "coalesce(LENGTH(#Attributes.args#),0)<>0">
			<cfif Attributes.isString>
				<cfset LvarCondicion =  LvarCondicion & " AND coalesce(LTRIM(CAST(#Attributes.args# AS VARCHAR(255))), ' ')<>' '">
			</cfif>
			<cfreturn "case when #LvarCondicion# then 1 else 0 end">
		<cfelseif Attributes.name is 'isnumeric'>
			<cfreturn "fnLike(LTRIM(RTRIM(#Attributes.args#)),'[^-0123456789.]%')+fnLike(LTRIM(RTRIM(#Attributes.args#)),'_%[^0123456789.]%')+fnLike(LTRIM(RTRIM(#Attributes.args#)),'%.%.%')=0">
		<cfelseif Attributes.name is 'lobisnull' OR Attributes.name is 'islobnull'>
			<cfreturn "#Attributes.args# is null">
		<cfelseif Attributes.name is 'lobisnotnull' or Attributes.name is 'islobnotnull'>
			<cfreturn "#Attributes.args# is not null">
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
		<cfset LvarDPart	= fnGetArgI(1)>
		<cfset LvarFecha	= fnGetDate(fnGetArgI(2))>
		<cfreturn fnDatePartNUM(LvarFecha, LvarDPart)>
	<cfelseif Attributes.name is 'to_datechar' OR Attributes.name is 'to_date00'>
		<!--- De Fecha a Fecha sin hora --->
		<cfreturn fnFechaSinHora(Attributes.args)>

	<!--- De hilera_a_DD/MM/YYYY a Fecha --->
	<cfelseif Attributes.name is 'to_date'>
		<cfparam name="Attributes.YMD" default="false">
		<cfif Attributes.YMD>
			<cfreturn fnYMDtoDate(#Attributes.args#, true)>
		<cfelse>
			<cfreturn fnDMYtoDate(#Attributes.args#, true)>
		</cfif>
	<cfelseif Attributes.name is 'to_datetime'>
		<cfparam name="Attributes.YMD" default="false">
		<cfif Attributes.YMD>
			<cfreturn fnYMDtoDate(#Attributes.args#)>
		<cfelse>
			<cfreturn fnDMYtoDate(#Attributes.args#)>
		</cfif>


 	<!--- De Fecha a Hilera --->
	<cfelseif Attributes.name is 'date_format'>
		<cfreturn fnDateFormat(fnGetDate(fnGetArgI(1)), fnGetArgI(2))>
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
			<cfset LvarNumero	= fnGetArgI(1)>
			<cfset LvarFecha	= fnGetDate(fnGetArgI(2))>
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
			<cfset LvarDPart 	= lcase(fnGetArgI(3))>
			<cfset LvarNumero	= fnGetArgI(1)>
			<cfset LvarFecha	= fnGetDate(fnGetArgI(2))>
			<cfreturn fnDateadd(#LvarDPart#, #LvarNumero#, #LvarFecha#)>
		<cfelse>
			<cf_errorCode	code = "50630" msg = "Argumentos incorrectos: args='numero, fecha [, datePart]'">
		</cfif>
	 <cfelseif Attributes.name is 'dateaddm'>
		<cfif ListLen(Attributes.args, Attributes.delimiters) NEQ 2>
			<cf_errorCode	code = "50631" msg = "Argumentos incorrectos: args='meses, fecha'">
		<cfelse>
			<cfset LvarDPart	= "mm">
			<cfset LvarNumero	= fnGetArgI(1)>
			<cfset LvarFecha	= fnGetDate(fnGetArgI(2))>
			<cfreturn fnDateadd(#LvarDPart#, #LvarNumero#, #LvarFecha#)>
		</cfif>	
	<cfelseif Attributes.name is 'dateaddx'>
		<cfif ListLen(Attributes.args, Attributes.delimiters) NEQ 3>
			<cf_errorCode	code = "50632" msg = "Argumentos incorrectos: args='tipo, numero_de_tipo, fecha'">
		<cfelse>
			<cfset LvarDPart	= fnGetArgI(1)>
			<cfset LvarNumero	= fnGetArgI(2)>
			<cfset LvarFecha	= fnGetDate(fnGetArgI(3))>
			<cfreturn fnDateadd(#LvarDPart#, #LvarNumero#, #LvarFecha#)>
		</cfif>	
	<cfelseif Attributes.name is 'timeadd'>
		<cfif ListLen(Attributes.args, Attributes.delimiters) NEQ 2>
			<cf_errorCode	code = "50633" msg = "Argumentos incorrectos: args='segundos, fecha'">
		<cfelse>
			<cfset LvarDPart	= "ss">
			<cfset LvarNumero	= fnGetArgI(1)>
			<cfset LvarFecha	= fnGetDate(fnGetArgI(2))>
			<cfreturn fnDateadd(#LvarDPart#, #LvarNumero#, #LvarFecha#)>
		</cfif>
	<cfelseif Attributes.name is 'dateaddstring'>
		<cfif ListLen(Attributes.args, Attributes.delimiters) NEQ 2>
			<cf_errorCode	code = "50634" msg = "Argumentos incorrectos: args='dias, hileraFechaSinApostrofes'">
		<cfelse>
			<cfset LvarDPart	= "dd">
			<cfset LvarNumero	= fnGetArgI(1)>
			<cfset LvarFecha	= fnGetDate("'#fnGetArgI(2)#'")>
			<cfreturn fnDateadd(#LvarDPart#, #LvarNumero#, #LvarFecha#)>
		</cfif>

	<!--- Diferencia de fechas --->
	<cfelseif Attributes.name is 'datedifftot' >
		<cfif ListLen(Attributes.args, Attributes.delimiters) NEQ 3>
			<cf_errorCode	code = "50635" msg = "Argumentos incorrectos: args='dateIni, dateFin , datePart'">
		</cfif>
		<cfset LvarDPart 	= lcase(fnGetArgI(3))>
		<cfset LvarFechaIni	= fnGetDate(fnGetArgI(1))>
		<cfset LvarFechaFin	= fnGetDate(fnGetArgI(2))>

		<cfreturn fnDateDiffTot (LvarDPart, LvarFechaIni, LvarFechaFin)>
	<cfelseif Attributes.name is 'datediff' >
		<cfif ListLen(Attributes.args, Attributes.delimiters) EQ 2>
			<!--- DatePart Default: dd --->
			<cfset LvarDPart	= "dd">
			<cfset LvarSinHora 	= (LvarDBtype EQ 'oracle')>
			<cfset LvarFechaIni	= fnGetDate(fnGetArgI(1))>
			<cfset LvarFechaFin	= fnGetDate(fnGetArgI(2))>
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

			<cfset LvarDPart = lcase(fnGetArgI(3))>
			<cfset LvarSinHora = (LvarDBtype EQ 'oracle' AND NOT listfind(LvarDPart,"hh,mi,ss,ms"))>
			<cfset LvarFechaIni	= fnGetDate(fnGetArgI(1))>
			<cfset LvarFechaFin	= fnGetDate(fnGetArgI(2))>

			<cfreturn fnDatediff (LvarDPart, LvarFechaIni, LvarFechaFin)>
		<cfelse>
			<cf_errorCode	code = "50603" msg = "Argumentos incorrectos: args='dateIni, dateFin [, datePart=dd [, oracleTimestamp=false]]'">
		</cfif>
	<cfelseif Attributes.name is 'datediffstring'>
		<cfif ListLen(Attributes.args, Attributes.delimiters) EQ 2 OR ListLen(Attributes.args, Attributes.delimiters) EQ 3>
			<cfif ListLen(Attributes.args, Attributes.delimiters) EQ 3>
				<cfset LvarTS	 = fnGetArgI(3)>
				<cfif NOT isboolean(LvarTS)>
					<cf_errorCode	code = "50604" msg = "Argumento oracleTimestamp debe ser true o false: args='dateIni, dateFin, oracleTimestamp'">
				</cfif>
			</cfif>
			<cfset LvarDPart	= "dd">
			<cfset LvarSinHora 	= (LvarDBtype EQ 'oracle')>
			<cfset LvarFechaIni	= fnGetDate("'#fnGetArgI(1)#'")>
			<cfset LvarFechaFin	= fnGetDate("'#fnGetArgI(2)#'")>
			<cfreturn fnDatediff (LvarDPart, LvarFechaIni, LvarFechaFin)>
		<cfelse>
			<cf_errorCode	code = "50605" msg = "Argumentos incorrectos: args='dateIni, dateFin [, oracleTimestamp=false]'">
		</cfif>
	<cfelseif Attributes.name is 'timediff'>
		<cfif ListLen(Attributes.args, Attributes.delimiters) EQ 2 OR ListLen(Attributes.args, Attributes.delimiters) EQ 3>
			<cfif ListLen(Attributes.args, Attributes.delimiters) EQ 3>
				<cfset LvarTS	 = fnGetArgI(3)>
				<cfif NOT isboolean(LvarTS)>
					<cf_errorCode	code = "50604" msg = "Argumento oracleTimestamp debe ser true o false: args='dateIni, dateFin, oracleTimestamp'">
				</cfif>
			</cfif>

			<cfset LvarDPart	= "ss">
			<cfset LvarSinHora 	= false>
			<cfset LvarFechaIni	= fnGetDate(fnGetArgI(1),LvarSinHora)>
			<cfset LvarFechaFin	= fnGetDate(fnGetArgI(2),LvarSinHora)>
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
			<cfreturn "TIMESTAMP(DATE(#LvarFecha#),'00:00:00')">
			<cfreturn "(#LvarFecha# - MIDNIGHT_SECONDS(#LvarFecha#) SECONDS - microsecond(#LvarFecha#) MICROSECONDS)">
		
			<cfreturn "(#LvarFecha# - hour(#LvarFecha#) HOURS - minute(#LvarFecha#) MINUTES - second(#LvarFecha#) SECONDS - microsecond(#LvarFecha#) MICROSECONDS)">
		</cfif>
	</cfif>
</cffunction>

<cffunction name="fnDateAdd" returntype="string">
	<cfargument name="DPart"	type="string" required="yes">
	<cfargument name="Numero"	type="string" required="yes">
	<cfargument name="Fecha"	type="string" required="yes">

	<!--- 
		Importante:			Se decidió seguir la lógica de Oracle de que:
							- siempre se mantienen las fracciones a nivel de segundos.
							- si la fecha es último día de mes, el resultado debe quedar ultimo día de mes
								(Se requiere ajuste en sybase, sqlserver y db2 a nivel de yyyy y mmm:
									cuando fecha es ultimo dia de mes y es 28,29 o 30 y el mes resultado tiene mayor número de días)
	--->
	<cfset Arguments.DPart = trim(Lcase(Arguments.DPart))>
	<cfif Arguments.DPart EQ "yyyy">
		<cfset Arguments.DPart = "yy">
	</cfif>
	<cfif ListFind('sybase,sqlserver', LvarDBtype)>
		<cfif NOT listFind("yy,mm,wk,dd,hh,mi,ss,ms",Arguments.DPart)>
			<cfthrow message="Argumento datepart='#Arguments.DPart#' incorrecto, solo se permite: yy,mm,wk,dd,hh,mi,ss,ms">
		</cfif>

		<cfset LvarFunc	= "dateadd(#Arguments.DPart#, #Arguments.Numero#, #Arguments.Fecha#)">
		<cfif Arguments.DPart EQ "yy">
			<cfset LvarDiaSig	= "dateadd(dd,1,#Arguments.Fecha#)">
			<cfset LvarFunc1	= "dateadd(#Arguments.DPart#, #Arguments.Numero#, #LvarDiaSig#)">
			<cfset LvarFunc1	= "dateadd(dd, -1, #LvarFunc1#)">
			<cfreturn "CASE WHEN #fnDatePartNum("#LvarDiaSig#","dd")# = 1 THEN #LvarFunc1# ELSE #LvarFunc# END">
		<cfelseif Arguments.DPart EQ "mm">
			<cfset LvarDiaSig	= "dateadd(dd,1,#Arguments.Fecha#)">
			<cfset LvarFunc1	= "dateadd(#Arguments.DPart#, #Arguments.Numero#, #LvarDiaSig#)">
			<cfset LvarFunc1	= "dateadd(dd, -1, #LvarFunc1#)">
			<cfreturn "CASE WHEN #fnDatePartNum("#LvarDiaSig#","dd")# = 1 THEN #LvarFunc1# ELSE #LvarFunc# END">
		</cfif>
		<cfreturn LvarFunc>
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
			<cfthrow message="Argumento datepart='#Arguments.DPart#' incorrecto, solo se permite: yy,mm,wk,dd,hh,mi,ss,ms">
		</cfif>
	<cfelseif LvarDBtype EQ "db2">
		<cfif Arguments.DPart EQ "yy">
			<cfset LvarFunc = "#Arguments.Fecha# + (#Arguments.Numero#) YEARS">
			<cfset LvarDiaSig = "#Arguments.Fecha# + 1 DAYS">
			<cfset LvarFunc1 = "(#LvarDiaSig#) + (#Arguments.Numero#) YEARS">
			<cfset LvarFunc1 = "(#LvarFunc1#) - 1 DAYS">
			<cfreturn "CASE WHEN #fnDatePartNum("#LvarDiaSig#","dd")# = 1 THEN #LvarFunc1# ELSE #LvarFunc# END">
		<cfelseif Arguments.DPart EQ "mm">
			<cfset LvarFunc = "#Arguments.Fecha# + (#Arguments.Numero#) MONTHS">
			<cfset LvarDiaSig = "#Arguments.Fecha# + 1 DAYS">
			<cfset LvarFunc1 = "(#LvarDiaSig#) + (#Arguments.Numero#) MONTHS">
			<cfset LvarFunc1 = "(#LvarFunc1#) - 1 DAYS">
			<cfreturn "CASE WHEN #fnDatePartNum("#LvarDiaSig#","dd")# = 1 THEN #LvarFunc1# ELSE #LvarFunc# END">
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
			<cfthrow message="Argumento datepart='#Arguments.DPart#' incorrecto, solo se permite: yy,mm,wk,dd,hh,mi,ss,ms">
		</cfif>

		<cfreturn '#Arguments.Fecha# + (#Arguments.Numero##LvarDPart#'>
	</cfif>
</cffunction>

<!---
	Date different Parts:	Calcula diferentes partes que han pasado entre 2 fechas (número de partes diferentes -1):
	
		Numero de Partes tomando en cuenta las fracciones = FechaFin-FechaIni
				 5.0 ->  5,		 5.1 ->  6, 	 5.9 ->  6		positivos ceil
				-5.0 -> -5,		-5.1 -> -6, 	-5.9 -> -6		negativos floor

		Importante: la lógica se tomó tal y como originalmente lo realizaba sybase

		Sybase: 			datediff -> CAMBIO SU LOGICA ORIGINAL
			dd,wk,mm,yyyy:	funcion datediff: mantiene su logica original, no toma en cuenta fracciones
			ss, ms:			funcion datediff: Aunque si cambia su lógica, lo que se pierde es una fracción de segundo a lo más
			hh, mi:			no se puede utilizar la función datediff porque si toma en cuenta sus fracciones: utiliza la lógica de restar las partes individuales a partir de diferencia en dias
							hh: diferencia en dias * 24 
								+ horas(FechaFin) 
								- horas(FechaIni)
							mi: diferencia en dias * 24*60 
								+ horas(FechaFin)*60 + minutos(FechaFin) 
								- horas(FechaIni)*60 - minutos(FechaIni)

		sqlserver: 			datediff -> MANTIENE SU LOGICA ORIGINAL

		Oracle y DB2:		La aritmética de fechas toma en cuenta las fracciones por lo que no se puede utilizar, 
							utiliza la lógica de restar las partes individuales
			mm, qq, yyyy:	Restar las partes individuales cada una por separado:
							yyyy:	  años(FechaFin)
									- años(FechaIni)
							qq:		  años(FechaFin)*4 + Trimestres(FechaFin)
									- años(FechaIni)*4 - Trimestres(FechaIni)
							mm:		  años(FechaFin)*12 + meses(FechaFin)
									- años(FechaIni)*12 - meses(FechaIni)

			wk,dd,hh,mi,ss:	Restar las partes individuales a partir de la diferencia de días (en oracle tiene decimales, en db2 toma en cuenta la fracción pero da resultado entero)
							wk: 
								si FechaIni>FechaFin
									FLOOR (diferencia en dias / 7)
								sino 
									CEIL (diferencia en dias / 7)
							dd: diferencia en dias
							hh: diferencia en dias * 24 
								+ horas(FechaFin) 
								- horas(FechaIni)
							mi: diferencia en dias * 24*60 
								+ horas(FechaFin)*60 + minutos(FechaFin) 
								- horas(FechaIni)*60 - minutos(FechaIni)
							ss:	diferencia en dias * 24*60*60
								+ horas(FechaFin)*60*60 + minutos(FechaFin)*60 + segundos(FechaFin)
								- horas(FechaIni)*60*60 - minutos(FechaIni)*60 - segundos(FechaIni)

		sybase:
			datediff(FECHA_INICIAL,FECHA_FINAL,	yyyy)	= datediff(yy, FECHA_INICIAL, FECHA_FINAL)
			datediff(FECHA_INICIAL,FECHA_FINAL,	mm)		= datediff(mm, FECHA_INICIAL, FECHA_FINAL)
			datediff(FECHA_INICIAL,FECHA_FINAL,	wk)		= datediff(wk, FECHA_INICIAL, FECHA_FINAL)
			datediff(FECHA_INICIAL,FECHA_FINAL,	dd)		= datediff(dd, FECHA_INICIAL, FECHA_FINAL)
			datediff(FECHA_INICIAL,FECHA_FINAL,	hh)		= (datediff(dd,FECHA_INICIAL,FECHA_FINAL)*24+datepart(hh, FECHA_FINAL)-datepart(hh, FECHA_INICIAL))
			datediff(FECHA_INICIAL,FECHA_FINAL,	mi)		= (datediff(dd,FECHA_INICIAL,FECHA_FINAL)*1440+datepart(hh, FECHA_FINAL)*60+datepart(mi, FECHA_FINAL)-datepart(hh, FECHA_INICIAL)*60-datepart(mi, FECHA_INICIAL))
			datediff(FECHA_INICIAL,FECHA_FINAL,	ss)		= datediff(ss, FECHA_INICIAL, FECHA_FINAL)
			
		sqlserver:
			datediff(FECHA_INICIAL,FECHA_FINAL,	yyyy)	= datediff(yy, FECHA_INICIAL, FECHA_FINAL)
			datediff(FECHA_INICIAL,FECHA_FINAL,	mm)		= datediff(mm, FECHA_INICIAL, FECHA_FINAL)
			datediff(FECHA_INICIAL,FECHA_FINAL,	wk)		= datediff(wk, FECHA_INICIAL, FECHA_FINAL)
			datediff(FECHA_INICIAL,FECHA_FINAL,	dd)		= datediff(dd, FECHA_INICIAL, FECHA_FINAL)
			datediff(FECHA_INICIAL,FECHA_FINAL,	hh)		= datediff(hh, FECHA_INICIAL, FECHA_FINAL)
			datediff(FECHA_INICIAL,FECHA_FINAL,	mi)		= datediff(mi, FECHA_INICIAL, FECHA_FINAL)
			datediff(FECHA_INICIAL,FECHA_FINAL,	ss)		= datediff(ss, FECHA_INICIAL, FECHA_FINAL)
			
		oracle:
			datediff(FECHA_INICIAL,FECHA_FINAL,	yyyy)	= to_number(to_char(FECHA_FINAL, 'YYYY'))-to_number(to_char(FECHA_INICIAL, 'YYYY'))
			datediff(FECHA_INICIAL,FECHA_FINAL,	mm)		= (to_number(to_char(FECHA_FINAL, 'YYYY'))*12+to_number(to_char(FECHA_FINAL, 'MM')))-(to_number(to_char(FECHA_INICIAL, 'YYYY'))*12+to_number(to_char(FECHA_INICIAL, 'MM')))
			datediff(FECHA_INICIAL,FECHA_FINAL,	wk)		= CASE WHEN FECHA_INICIAL < FECHA_FINAL THEN TRUNC((to_number(to_char(FECHA_FINAL, 'J'))-to_number(to_char(FECHA_FINAL, 'D'))-to_number(to_char(FECHA_INICIAL, 'J'))+to_number(to_char(FECHA_INICIAL, 'D')))/7.0) ELSE FLOOR((to_number(to_char(FECHA_FINAL, 'J'))-to_number(to_char(FECHA_FINAL, 'D'))-to_number(to_char(FECHA_INICIAL, 'J'))+to_number(to_char(FECHA_INICIAL, 'D')))/7.0) END
			datediff(FECHA_INICIAL,FECHA_FINAL,	dd)		= (to_number(to_char(FECHA_FINAL, 'J'))-to_number(to_char(FECHA_INICIAL, 'J')))
			datediff(FECHA_INICIAL,FECHA_FINAL,	hh)		= ((to_number(to_char(FECHA_FINAL, 'J'))-to_number(to_char(FECHA_INICIAL, 'J')))*24+to_number(to_char(FECHA_FINAL, 'HH24'))-to_number(to_char(FECHA_INICIAL, 'HH24')))
			datediff(FECHA_INICIAL,FECHA_FINAL,	mi)		= ((to_number(to_char(FECHA_FINAL, 'J'))-to_number(to_char(FECHA_INICIAL, 'J')))*1440+to_number(to_char(FECHA_FINAL, 'HH24'))*60+to_number(to_char(FECHA_FINAL, 'MI'))-to_number(to_char(FECHA_INICIAL, 'HH24'))*60-to_number(to_char(FECHA_INICIAL, 'MI')))
			datediff(FECHA_INICIAL,FECHA_FINAL,	ss)		= ((to_number(to_char(FECHA_FINAL, 'J'))-to_number(to_char(FECHA_INICIAL, 'J')))*86400+to_number(to_char(FECHA_FINAL, 'SSSSS'))-to_number(to_char(FECHA_INICIAL, 'SSSSS')))
	
		db2:
			datediff(FECHA_INICIAL,FECHA_FINAL,	yyyy)	= YEAR(FECHA_FINAL)-YEAR(FECHA_INICIAL)
			datediff(FECHA_INICIAL,FECHA_FINAL,	mm)		= (YEAR(FECHA_FINAL)*12+MONTH(FECHA_FINAL))-(YEAR(FECHA_INICIAL)*12+MONTH(FECHA_INICIAL))
			datediff(FECHA_INICIAL,FECHA_FINAL,	wk)		= CASE WHEN FECHA_INICIAL < FECHA_FINAL THEN INT((DAYS(FECHA_FINAL)-DAYOFWEEK(FECHA_FINAL)-DAYS(FECHA_INICIAL)+DAYOFWEEK(FECHA_INICIAL))/7.0) ELSE FLOOR((DAYS(FECHA_FINAL)-DAYOFWEEK(FECHA_FINAL)-DAYS(FECHA_INICIAL)+DAYOFWEEK(FECHA_INICIAL))/7.0) END
			datediff(FECHA_INICIAL,FECHA_FINAL,	dd)		= (DAYS(FECHA_FINAL)-DAYS(FECHA_INICIAL))
			datediff(FECHA_INICIAL,FECHA_FINAL,	hh)		= ((DAYS(FECHA_FINAL)-DAYS(FECHA_INICIAL))*24+HOUR(FECHA_FINAL)-HOUR(FECHA_INICIAL))
			datediff(FECHA_INICIAL,FECHA_FINAL,	mi)		= ((DAYS(FECHA_FINAL)-DAYS(FECHA_INICIAL))*1440+HOUR(FECHA_FINAL)*60+MINUTE(FECHA_FINAL)-HOUR(FECHA_INICIAL)*60-MINUTE(FECHA_INICIAL))
			datediff(FECHA_INICIAL,FECHA_FINAL,	ss)		= ((DAYS(FECHA_FINAL)-DAYS(FECHA_INICIAL))*86400+MIDNIGHT_SECONDS(FECHA_FINAL)-MIDNIGHT_SECONDS(FECHA_INICIAL))
--->				
<cffunction name="fnDateDiff" returntype="string">
	<cfargument name="DPart"	type="string" required="yes">
	<cfargument name="FechaIni"	type="string" required="yes">
	<cfargument name="FechaFin"	type="string" required="yes">

	<cfset Arguments.DPart = trim(Lcase(Arguments.DPart))>
	<cfif Arguments.DPart EQ "yyyy">
		<cfset Arguments.DPart = "yy">
	</cfif>
	<cfif ListFind('sybase,sqlserver', LvarDBtype)>
		<cfif NOT listFind("yy,mm,wk,dd,hh,mi,ss,ms",Arguments.DPart)>
			<cfthrow message="Argumento datepart='#Arguments.DPart#' incorrecto, solo se permite: yy,mm,wk,dd,hh,mi,ss,ms">
		</cfif>

		<cfif DPart EQ 'hh' AND LvarDBtype EQ "sybase">
			<cfset LvarFunc = "(datediff(dd,#Arguments.FechaIni#,#Arguments.FechaFin#)*24+#fnDatePartNum(FechaFin,"hh")#-#fnDatePartNum(FechaIni,"hh")#)">
			<cfreturn LvarFunc>
		<cfelseif DPart EQ 'mi' AND LvarDBtype EQ "sybase">
			<cfset LvarFunc = "(datediff(dd,#Arguments.FechaIni#,#Arguments.FechaFin#)*1440+#fnDatePartNum(FechaFin,"hh")#*60+#fnDatePartNum(FechaFin,"mi")#-#fnDatePartNum(FechaIni,"hh")#*60-#fnDatePartNum(FechaIni,"mi")#)">
			<cfreturn LvarFunc>
		<cfelse>
			<cfreturn 'datediff(#DPart#, #FechaIni#, #FechaFin#)'>
		</cfif>
	<cfelseif ListFind('oracle,db2', LvarDBtype)>
		<cfif DPart EQ "yy" OR DPart EQ "yyyy" >
			<cfset LvarFunc = "#fnDatePartNum(FechaFin,"yyyy")#-#fnDatePartNum(FechaIni,"yyyy")#">
			<cfreturn LvarFunc>
		<cfelseif DPart EQ "qq">
			<cfset LvarFunc = "(#fnDatePartNum(FechaFin,"yyyy")#*4+#fnDatePartNum(FechaFin,"qq")#)-(#fnDatePartNum(FechaIni,"yyyy")#*4+#fnDatePartNum(FechaIni,"qq")#)">
			<cfreturn LvarFunc>
		<cfelseif DPart EQ "mm">
			<cfset LvarFunc = "(#fnDatePartNum(FechaFin,"yyyy")#*12+#fnDatePartNum(FechaFin,"mm")#)-(#fnDatePartNum(FechaIni,"yyyy")#*12+#fnDatePartNum(FechaIni,"mm")#)">
			<cfreturn LvarFunc>
		<cfelseif DPart EQ "wk">
			<cfset LvarFunc2 = "(#fnDatePartNum(FechaFin,"jj")#-#fnDatePartNum(FechaIni,"jj")#+#fnDatePartNum(FechaIni,"dw")#-1)">
			<cfif LvarDBtype EQ 'oracle'>
				<cfset LvarFunc1 = "(#fnDatePartNum(FechaFin,"jj")#-#fnDatePartNum(FechaFin,"dw")#-#fnDatePartNum(FechaIni,"jj")#+#fnDatePartNum(FechaIni,"dw")#)">
				<cfset LvarFunc = "TRUNC(#LvarFunc1#/7.0)">
				<cfset LvarFunc = "CASE WHEN #FechaIni# < #FechaFIN# THEN TRUNC(#LvarFunc1#/7.0) ELSE FLOOR(#LvarFunc1#/7.0) END">
			<cfelse>
				<cfset LvarFunc1 = "(#fnDatePartNum(FechaFin,"jj")#-#fnDatePartNum(FechaFin,"dw")#+#fnDatePartNum(FechaFin,"sssss")#/86400.0-#fnDatePartNum(FechaIni,"jj")#+#fnDatePartNum(FechaIni,"dw")#-#fnDatePartNum(FechaIni,"sssss")#/86400.0)">
				<cfset LvarFunc1 = "(#fnDatePartNum(FechaFin,"jj")#-#fnDatePartNum(FechaFin,"dw")#-#fnDatePartNum(FechaIni,"jj")#+#fnDatePartNum(FechaIni,"dw")#)">
				<cfset LvarFunc = "INT(#LvarFunc1#/7.0)">
				<cfset LvarFunc = "CASE WHEN #FechaIni# < #FechaFIN# THEN INT(#LvarFunc1#/7.0) ELSE FLOOR(#LvarFunc1#/7.0) END">
			</cfif>
			<cfreturn LvarFunc>
		<cfelseif DPart EQ "dd">
			<cfset LvarFunc = "(#fnDatePartNum(FechaFin,"jj")#-#fnDatePartNum(FechaIni,"jj")#)">
			<cfreturn LvarFunc>
		<cfelseif DPart EQ "hh">
			<cfset LvarFunc = "((#fnDatePartNum(FechaFin,"jj")#-#fnDatePartNum(FechaIni,"jj")#)*24+#fnDatePartNum(FechaFin,"hh")#-#fnDatePartNum(FechaIni,"hh")#)">
			<cfreturn LvarFunc>
		<cfelseif DPart EQ "mi">
			<cfset LvarFunc = "((#fnDatePartNum(FechaFin,"jj")#-#fnDatePartNum(FechaIni,"jj")#)*1440+#fnDatePartNum(FechaFin,"hh")#*60+#fnDatePartNum(FechaFin,"mi")#-#fnDatePartNum(FechaIni,"hh")#*60-#fnDatePartNum(FechaIni,"mi")#)">
			<cfreturn LvarFunc>
		<cfelseif DPart EQ "ss">
			<cfset LvarFunc = "((#fnDatePartNum(FechaFin,"jj")#-#fnDatePartNum(FechaIni,"jj")#)*86400+#fnDatePartNum(FechaFin,"SSSSS")#-#fnDatePartNum(FechaIni,"SSSSS")#)">
			<cfreturn LvarFunc>
		<cfelseif DPart EQ "ms">
			<cfset LvarFunc = "1000*(#fnDatePartNum(FechaFin,"jj")#-#fnDatePartNum(FechaIni,"jj")#)*86400+#fnDatePartNum(FechaFin,"SSSSS")#-#fnDatePartNum(FechaIni,"SSSSS")#">
		<cfelse>
			<cfthrow message="Argumento datepart='#Arguments.DPart#' incorrecto, solo se permite: yy,mm,wk,dd,hh,mi,ss,ms">
		</cfif>
	</cfif>
</cffunction>

<!---
	Date difference of Total Parts:	Calcula las partes completas que han pasado entre 2 fechas (resta aritmética de 2 fechas):
		Numero de Partes = TRUNC(FechaFin-FechaIni)
				 5.0 ->  5,		 5.1 ->  5, 	 5.9 ->  5
				-5.0 -> -5,		-5.1 -> -5, 	-5.9 -> -5

		Importante:			Se decidió seguir la lógica de Oracle de que:
							- a nivel de años y meses no se toman en cuenta las fracciones de horas. Se completa a nivel de día.
							- a nivel de dias, horas, minutos y segundos sí se toman en cuenta las fracciones de horas. Se completa a nivel de segundo.
							- Hay que controlar la completitud entre 2 últimos días de mes (31/ENE contra 28/FEB):
							   se le suma un día a cada hora, de modo que
							  si se da el caso, quedan ambos el primer dia de cada mes, y como es 1 - 1 se matan entre sí.
							  
							SOLO HAY UN CASO QUE NO SE SIGUE DE ORACLE: 
								sólo cuando fechaFin es ultimo día de febrero y el dia de fechaIni es mayor o igual al dia de FechaFin, pero no es fin de mes
								numero de meses entre 30/oct y 28/Feb quita un mes
								30/oct no es final de mes
								28/feb es final de mes, considera que es mes completo solo cuando ambas son final de mes

		Sybase: 			datediff -> CAMBIO SU LOGICA ORIGINAL
			hh, mi,ss, ms:	En Sybase funcion datediff: cambió su lógica tomando en cuentas las fracciones, lo que permite utilizarla
			ss, ms:			En SQLserver funcion datediff: aunque no se toman en cuenta las fracciones, lo que se pierde es una fracción de segundo a lo sumo
			mm, yyyy:		datediff + ajuste cuando se pasa o no es completo. Se determina la completitud a nivel de dias (no toma en cuenta horas). No es necesario sumar 1 dia a cada fecha.
							datediff +
								si se se pasa     y Resultado < 0:	+1
								si no es completo y Resultado > 0:	-1
								(si es exacto no hay ajuste)
			dd, hh, mm:		datediff + ajuste cuando se pasa o no es completo. Se determina la completitud a nivel de segundos (se toman en cuenta las horas).
							datediff +
								si se se pasa     y Resultado < 0:	+1
								si no es completo y Resultado > 0:	-1
								(si es exacto no hay ajuste)

		sqlserver: 			datediff -> Mantiene su lógica original por lo que no se puede utilizar
			ss, ms:			datediff: aunque no se toman en cuenta las fracciones, lo que se pierde es una fracción de segundo a lo sumo
			mm, yyyy:		datediff + ajuste cuando se pasa o no es completo. Se determina la completitud a nivel de dias (no toma en cuenta horas). No es necesario sumar 1 dia a cada fecha.
							datediff +
								si se se pasa     y Resultado < 0:	+1
								si no es completo y Resultado > 0:	-1
								(si es exacto no hay ajuste)
			wk, dd, hh, mi:	datediff + ajuste cuando se pasa o no es completo. Se determina la completitud a nivel de segundos (se toman en cuenta las horas). 
							datediff +
								si se se pasa     y Resultado < 0:	+1
								si no es completo y Resultado > 0:	-1
								(si es exacto no hay ajuste)

		Oracle:				Tiene aritmética entre fechas: 
							- el control de partes completas a nivel de dia con MONTHS_BETWEEN es automático
							- el control de partes completas a nivel de segundo es automático con la resta de fechas
							- el control de último día de mes es automático
			mm, qq, yyyy:	Meses Completos = MONTHS_BETWEEN (FechaFin, FechaIni) 
												(tiene el problema que calcula con dias sin fracción)
							Numero de Parte Completa = TRUNC(Meses Completos / numeroMesesEnParte)
			dd, wk:			Dias Completos  = TRUNC(FechaFin - FechaIni)
							Numero de Parte Completa = TRUNC(Dias Completos / numeroDiasEnParte)
			hh, mm, ss:		Dias con Fracción  = (FechaFin - FechaIni)
							Numero de Parte Completa = TRUNC(ROUND(Dias con Fracción * numeroPartesEnDia,6)
													(El Round es necesario porque a veces los enteros los deja x.99999999999)

		DB2:				Tiene aritmética entre fechas: 
							- para realizar los cálculos se utiliza aritmética de fechas con partes individuales
							- el control de partes completas a nivel de segundo con la aritmética de fechas es automático, el resultado ya viene truncado
							- para los cálculos de meses y años es necesario quitarle las horas para que no se tomen en cuenta
							- para el control de último día de mes se añade un día a cada fecha
							- es necesario redondear a 6 decimales porque a veces los enteros los deja como X.9999999999999
			yyyy			Años Completos		= YEAR(FechaFin - FechaIni)
			mm, qq			Meses Completos		= YEAR(FechaFin - FechaIni)*12 + MONTH(FechaFin - FechaIni)
							Numero de Parte Completa = INT(Meses Completos / numeroMesesEnParte)

			dd, wk			Dias Completos			 = (DAYS(#FechaFin#) - DAYS(#FechaIni#))
							Numero de Parte Completa = INT(Dias Completos / numeroDiasEnParte)

			hh, mm, ss:		Dias con Fracción		 = ((DAYS(#FechaFin#) + (MIDNIGHT_SECONDS(#FechaFin#)/86400.0) - (DAYS(#FechaIni#) + (MIDNIGHT_SECONDS(#FechaFin#)/86400.0),10)
							Numero de Parte Completa = INT(ROUND(Dias con Fracción * numeroPartesEnDia,6)
													(El Round es necesario porque a veces los enteros los deja x.99999999999)

		sybase:
			datedifftot(FECHA_INICIAL,FECHA_FINAL,	yyyy)	= datediff(yy,dateadd(dd,1,FECHA_INICIAL),dateadd(dd,1,FECHA_FINAL)) + case sign(datediff(dd, dateadd(yy,datediff(yy,dateadd(dd,1,FECHA_INICIAL),dateadd(dd,1,FECHA_FINAL)),dateadd(dd,1,FECHA_INICIAL)), dateadd(dd,1,FECHA_FINAL))) when 1 then case when FECHA_INICIAL<=FECHA_FINAL then 0 else 1 end when -1 then case when FECHA_INICIAL<=FECHA_FINAL then -1 else 0 end else 0 end
			datedifftot(FECHA_INICIAL,FECHA_FINAL,	mm)		= datediff(mm,FECHA_INICIAL,FECHA_FINAL) + CASE sign(datediff(mm,FECHA_INICIAL,FECHA_FINAL)) WHEN 1 THEN CASE WHEN datepart(dd,FECHA_INICIAL)>datepart(dd,FECHA_FINAL) AND datepart(dd,dateadd (dd, 1,FECHA_FINAL))<>1 THEN -1 ELSE 0 END WHEN -1 THEN CASE WHEN datepart(dd,FECHA_FINAL)>datepart(dd,FECHA_INICIAL) AND datepart(dd,dateadd (dd, 1,FECHA_INICIAL))<>1 THEN 1 ELSE 0 END ELSE 0 END
			datedifftot(FECHA_INICIAL,FECHA_FINAL,	wk)		= datediff(wk,FECHA_INICIAL,FECHA_FINAL) + case sign(datediff(ss, dateadd(wk,datediff(wk,FECHA_INICIAL,FECHA_FINAL),FECHA_INICIAL), FECHA_FINAL)) when 1 then case when FECHA_INICIAL<=FECHA_FINAL then 0 else 1 end when -1 then case when FECHA_INICIAL<=FECHA_FINAL then -1 else 0 end else 0 end
			datedifftot(FECHA_INICIAL,FECHA_FINAL,	dd)		= datediff(dd,FECHA_INICIAL,FECHA_FINAL) + case sign(datediff(ss, dateadd(dd,datediff(dd,FECHA_INICIAL,FECHA_FINAL),FECHA_INICIAL), FECHA_FINAL)) when 1 then case when FECHA_INICIAL<=FECHA_FINAL then 0 else 1 end when -1 then case when FECHA_INICIAL<=FECHA_FINAL then -1 else 0 end else 0 end
			datedifftot(FECHA_INICIAL,FECHA_FINAL,	hh)		= datediff(hh, FECHA_INICIAL, FECHA_FINAL)
			datedifftot(FECHA_INICIAL,FECHA_FINAL,	mi)		= datediff(mi, FECHA_INICIAL, FECHA_FINAL)
			datedifftot(FECHA_INICIAL,FECHA_FINAL,	ss)		= datediff(ss, FECHA_INICIAL, FECHA_FINAL)
		
		sqlserver:
			datedifftot(FECHA_INICIAL,FECHA_FINAL,	yyyy)	= datediff(yy,dateadd(dd,1,FECHA_INICIAL),dateadd(dd,1,FECHA_FINAL)) + case sign(datediff(dd, dateadd(yy,datediff(yy,dateadd(dd,1,FECHA_INICIAL),dateadd(dd,1,FECHA_FINAL)),dateadd(dd,1,FECHA_INICIAL)), dateadd(dd,1,FECHA_FINAL))) when 1 then case when FECHA_INICIAL<=FECHA_FINAL then 0 else 1 end when -1 then case when FECHA_INICIAL<=FECHA_FINAL then -1 else 0 end else 0 end
			datedifftot(FECHA_INICIAL,FECHA_FINAL,	mm)		= datediff(mm,FECHA_INICIAL,FECHA_FINAL) + CASE sign(datediff(mm,FECHA_INICIAL,FECHA_FINAL)) WHEN 1 THEN CASE WHEN datepart(dd,FECHA_INICIAL)>datepart(dd,FECHA_FINAL) AND datepart(dd,dateadd (dd, 1,FECHA_FINAL))<>1 THEN -1 ELSE 0 END WHEN -1 THEN CASE WHEN datepart(dd,FECHA_FINAL)>datepart(dd,FECHA_INICIAL) AND datepart(dd,dateadd (dd, 1,FECHA_INICIAL))<>1 THEN 1 ELSE 0 END ELSE 0 END
			datedifftot(FECHA_INICIAL,FECHA_FINAL,	wk)		= datediff(wk,FECHA_INICIAL,FECHA_FINAL) + case sign(datediff(ss, dateadd(wk,datediff(wk,FECHA_INICIAL,FECHA_FINAL),FECHA_INICIAL), FECHA_FINAL)) when 1 then case when FECHA_INICIAL<=FECHA_FINAL then 0 else 1 end when -1 then case when FECHA_INICIAL<=FECHA_FINAL then -1 else 0 end else 0 end
			datedifftot(FECHA_INICIAL,FECHA_FINAL,	dd)		= datediff(dd,FECHA_INICIAL,FECHA_FINAL) + case sign(datediff(ss, dateadd(dd,datediff(dd,FECHA_INICIAL,FECHA_FINAL),FECHA_INICIAL), FECHA_FINAL)) when 1 then case when FECHA_INICIAL<=FECHA_FINAL then 0 else 1 end when -1 then case when FECHA_INICIAL<=FECHA_FINAL then -1 else 0 end else 0 end
			datedifftot(FECHA_INICIAL,FECHA_FINAL,	hh)		= datediff(hh,FECHA_INICIAL,FECHA_FINAL) + case sign(datediff(ss, dateadd(hh,datediff(hh,FECHA_INICIAL,FECHA_FINAL),FECHA_INICIAL), FECHA_FINAL)) when 1 then case when FECHA_INICIAL<=FECHA_FINAL then 0 else 1 end when -1 then case when FECHA_INICIAL<=FECHA_FINAL then -1 else 0 end else 0 end
			datedifftot(FECHA_INICIAL,FECHA_FINAL,	mi)		= datediff(mi,FECHA_INICIAL,FECHA_FINAL) + case sign(datediff(ss, dateadd(mi,datediff(mi,FECHA_INICIAL,FECHA_FINAL),FECHA_INICIAL), FECHA_FINAL)) when 1 then case when FECHA_INICIAL<=FECHA_FINAL then 0 else 1 end when -1 then case when FECHA_INICIAL<=FECHA_FINAL then -1 else 0 end else 0 end
			datedifftot(FECHA_INICIAL,FECHA_FINAL,	ss)		= datediff(ss, FECHA_INICIAL, FECHA_FINAL)
		
		oracle:
			datedifftot(FECHA_INICIAL,FECHA_FINAL,	yyyy)	= TRUNC(MONTHS_BETWEEN(FECHA_FINAL+1, FECHA_INICIAL+1)/12.0)
			datedifftot(FECHA_INICIAL,FECHA_FINAL,	mm)		= TRUNC(MONTHS_BETWEEN(FECHA_FINAL, FECHA_INICIAL) + CASE WHEN FECHA_INICIAL<=FECHA_FINAL AND to_number(to_char(FECHA_INICIAL, 'DD'))>to_number(to_char(FECHA_FINAL, 'DD')) AND to_number(to_char(FECHA_FINAL + 1, 'DD'))=1 AND to_number(to_char(FECHA_INICIAL + 1, 'DD'))<>1 THEN +1 WHEN FECHA_INICIAL>FECHA_FINAL AND to_number(to_char(FECHA_FINAL, 'DD'))>to_number(to_char(FECHA_INICIAL, 'DD')) AND to_number(to_char(FECHA_INICIAL + 1, 'DD'))=1 AND to_number(to_char(FECHA_FINAL + 1, 'DD'))<>1 THEN -1 ELSE 0 END)
			datedifftot(FECHA_INICIAL,FECHA_FINAL,	wk)		= TRUNC(ROUND((FECHA_FINAL - FECHA_INICIAL)/7.0,6))
			datedifftot(FECHA_INICIAL,FECHA_FINAL,	dd)		= TRUNC(ROUND((FECHA_FINAL - FECHA_INICIAL),6))
			datedifftot(FECHA_INICIAL,FECHA_FINAL,	hh)		= TRUNC(ROUND((FECHA_FINAL - FECHA_INICIAL)*24,6))
			datedifftot(FECHA_INICIAL,FECHA_FINAL,	mi)		= TRUNC(ROUND((FECHA_FINAL - FECHA_INICIAL)*1440,6))
			datedifftot(FECHA_INICIAL,FECHA_FINAL,	ss)		= TRUNC(ROUND((FECHA_FINAL - FECHA_INICIAL)*86400,6))
		
		db2:
			datedifftot(FECHA_INICIAL,FECHA_FINAL,	yyyy)	= YEAR((TIMESTAMP(DATE(FECHA_FINAL),'00:00:00') + 1 DAYS) - (TIMESTAMP(DATE(FECHA_INICIAL),'00:00:00') + 1 DAYS))
			datedifftot(FECHA_INICIAL,FECHA_FINAL,	mm)		= CASE WHEN TIMESTAMP(DATE(FECHA_INICIAL),'00:00:00') < TIMESTAMP(DATE(FECHA_FINAL),'00:00:00') AND DAY(FECHA_INICIAL) <= DAY(FECHA_FINAL) OR TIMESTAMP(DATE(FECHA_INICIAL),'00:00:00') > TIMESTAMP(DATE(FECHA_FINAL),'00:00:00') AND DAY(FECHA_INICIAL) >= DAY(FECHA_FINAL) THEN YEAR(TIMESTAMP(DATE(FECHA_FINAL),'00:00:00') - TIMESTAMP(DATE(FECHA_INICIAL),'00:00:00'))*12 + MONTH(TIMESTAMP(DATE(FECHA_FINAL),'00:00:00') - TIMESTAMP(DATE(FECHA_INICIAL),'00:00:00')) ELSE YEAR((TIMESTAMP(DATE(FECHA_FINAL),'00:00:00') + 1 DAYS) - (TIMESTAMP(DATE(FECHA_INICIAL),'00:00:00') + 1 DAYS))*12 + MONTH((TIMESTAMP(DATE(FECHA_FINAL),'00:00:00') + 1 DAYS) - (TIMESTAMP(DATE(FECHA_INICIAL),'00:00:00') + 1 DAYS)) END
			datedifftot(FECHA_INICIAL,FECHA_FINAL,	wk)		= INT((DAYS(FECHA_FINAL)+MIDNIGHT_SECONDS(FECHA_FINAL)/86400.0-DAYS(FECHA_INICIAL)-MIDNIGHT_SECONDS(FECHA_INICIAL)/86400.0) / 7)
			datedifftot(FECHA_INICIAL,FECHA_FINAL,	dd)		= INT(ROUND(((DAYS(FECHA_FINAL) + (MIDNIGHT_SECONDS(FECHA_FINAL)/86400.0))-(DAYS(FECHA_INICIAL) + (MIDNIGHT_SECONDS(FECHA_INICIAL)/86400.0))),6))
			datedifftot(FECHA_INICIAL,FECHA_FINAL,	hh)		= INT(ROUND(((DAYS(FECHA_FINAL) + (MIDNIGHT_SECONDS(FECHA_FINAL)/86400.0))-(DAYS(FECHA_INICIAL) + (MIDNIGHT_SECONDS(FECHA_INICIAL)/86400.0)))*24.0,6))
			datedifftot(FECHA_INICIAL,FECHA_FINAL,	mi)		= INT(ROUND(((DAYS(FECHA_FINAL) + (MIDNIGHT_SECONDS(FECHA_FINAL)/86400.0))-(DAYS(FECHA_INICIAL) + (MIDNIGHT_SECONDS(FECHA_INICIAL)/86400.0)))*1440.0,6))
			datedifftot(FECHA_INICIAL,FECHA_FINAL,	ss)		= INT(ROUND(((DAYS(FECHA_FINAL) + (MIDNIGHT_SECONDS(FECHA_FINAL)/86400.0))-(DAYS(FECHA_INICIAL) + (MIDNIGHT_SECONDS(FECHA_INICIAL)/86400.0)))*86400.0,6))
--->				
<cffunction name="fnDateDiffTot" returntype="string">
	<cfargument name="DPart"	type="string" required="yes">
	<cfargument name="FechaIni"	type="string" required="yes">
	<cfargument name="FechaFin"	type="string" required="yes">

	<cfset Arguments.DPart = trim(Lcase(Arguments.DPart))>
	<cfif Arguments.DPart EQ "yyyy">
		<cfset Arguments.DPart = "yy">
	</cfif>
	<cfif ListFind('sybase,sqlserver', LvarDBtype)>
		<cfif NOT listFind("yy,mm,wk,dd,hh,mi,ss,ms",Arguments.DPart)>
			<cfthrow message="Argumento datepart='#Arguments.DPart#' incorrecto, solo se permite: yy,mm,wk,dd,hh,mi,ss,ms">
		</cfif>
				   
		<cfif ListFind('hh,mi', DPart) AND LvarDBtype EQ "sybase">
			<cfreturn 'datediff(#Arguments.DPart#, #Arguments.FechaIni#, #Arguments.FechaFin#)'>
		<cfelseif ListFind('ss,ms', DPart)>
			<cfreturn 'datediff(#Arguments.DPart#, #Arguments.FechaIni#, #Arguments.FechaFin#)'>
		<cfelseif ListFind('yy,yyyy', DPart)>
			<!---		
				El ajuste de fin de mes sólo es necesario para 28/2 contra 29/2
			--->	
			<!--- Minima fracción = dia --->
			<cfset LvarFechaIni = "dateadd(dd,1,#Arguments.FechaIni#)">
			<cfset LvarFechaFin = "dateadd(dd,1,#Arguments.FechaFin#)">
			<cfset LvarAjuste = "case sign(datediff(dd, dateadd(#Arguments.DPart#,datediff(#Arguments.DPart#,#LvarFechaIni#,#LvarFechaFin#),#LvarFechaIni#), #LvarFechaFin#))">
			<cfset LvarFunc = "datediff(#Arguments.DPart#,#LvarFechaIni#,#LvarFechaFin#) + #LvarAjuste# when 1 then case when #Arguments.FechaIni#<=#Arguments.FechaFin# then 0 else 1 end when -1 then case when #Arguments.FechaIni#<=#Arguments.FechaFin# then -1 else 0 end else 0 end">
			<cfreturn LvarFunc>
		<cfelseif ListFind('mm', DPart)>
			<!---		
				El ajuste de fin de mes sólo es necesario cuando:
					Positivos: DIA(FechaIni)>DIA(FechaFin) Y DIA(FechaFin) NO es ultimo dia de mes
					Negativos: DIA(FechaFin)>DIA(FechaIni) Y DIA(FechaIni) NO es ultimo dia de mes
			--->	
			<cfset LvarFechaIni = Arguments.FechaIni>
			<cfset LvarFechaFin = Arguments.FechaFin>
			<cfset LvarFechas = "datediff(#Arguments.DPart#,#LvarFechaIni#,#LvarFechaFin#)">
			<cfset LvarAjustePos = "CASE WHEN datepart(dd,#Arguments.FechaIni#)>datepart(dd,#Arguments.FechaFin#) AND datepart(dd,dateadd (dd, 1,#Arguments.FechaFin#))<>1 THEN -1 ELSE 0 END">
			<cfset LvarAjusteNeg = "CASE WHEN datepart(dd,#Arguments.FechaFin#)>datepart(dd,#Arguments.FechaIni#) AND datepart(dd,dateadd (dd, 1,#Arguments.FechaIni#))<>1 THEN  1 ELSE 0 END">
			<cfset LvarFunc = "#LvarFechas# + CASE sign(#LvarFechas#) WHEN 1 THEN #LvarAjustePos# WHEN -1 THEN #LvarAjusteNeg# ELSE 0 END">
			<cfreturn LvarFunc>
		<cfelse>
			<!--- Minima fracción = segundo --->
			<cfreturn 'datediff(#Arguments.DPart#,#Arguments.FechaIni#,#Arguments.FechaFin#) + case sign(datediff(ss, dateadd(#Arguments.DPart#,datediff(#Arguments.DPart#,#Arguments.FechaIni#,#Arguments.FechaFin#),#Arguments.FechaIni#), #Arguments.FechaFin#)) when 1 then case when #Arguments.FechaIni#<=#Arguments.FechaFin# then 0 else 1 end when -1 then case when #Arguments.FechaIni#<=#Arguments.FechaFin# then -1 else 0 end else 0 end'>
		</cfif>
	<cfelseif LvarDBtype EQ "oracle">
		<cfif DPart EQ "yy" OR DPart EQ "yyyy" >
			<cfset LvarFunc = "MONTHS_BETWEEN(#FechaFin#+1, #FechaIni#+1)">
			<cfset LvarFunc = "TRUNC(#LvarFunc#/12.0)">
			<cfreturn LvarFunc>
		<cfelseif DPart EQ "qq">
			<cfset LvarAjustePos = "#FechaIni#<=#FechaFin# AND #fnDatePartNum(FechaIni,"dd")#>#fnDatePartNum(FechaFin,"dd")# AND #fnDatePartNum("#FechaFin# + 1","dd")#=1 AND #fnDatePartNum("#FechaIni# + 1","dd")#<>1">
			<cfset LvarAjusteNeg =  "#FechaIni#>#FechaFin# AND #fnDatePartNum(FechaFin,"dd")#>#fnDatePartNum(FechaIni,"dd")# AND #fnDatePartNum("#FechaIni# + 1","dd")#=1 AND #fnDatePartNum("#FechaFin# + 1","dd")#<>1">
			<cfset LvarAjusteMM = "CASE WHEN #LvarAjustePos# THEN +1 WHEN #LvarAjusteNeg# THEN -1 ELSE 0 END">
			<cfset LvarFunc = "MONTHS_BETWEEN(#FechaFin#, #FechaIni#)">
			<cfset LvarFunc = "TRUNC(#LvarFunc#/3 + #LvarAjusteMM#)">
			<cfreturn LvarFunc>
		<cfelseif DPart EQ "mm">
			<cfset LvarAjustePos = "#FechaIni#<=#FechaFin# AND #fnDatePartNum(FechaIni,"dd")#>#fnDatePartNum(FechaFin,"dd")# AND #fnDatePartNum("#FechaFin# + 1","dd")#=1 AND #fnDatePartNum("#FechaIni# + 1","dd")#<>1">
			<cfset LvarAjusteNeg =  "#FechaIni#>#FechaFin# AND #fnDatePartNum(FechaFin,"dd")#>#fnDatePartNum(FechaIni,"dd")# AND #fnDatePartNum("#FechaIni# + 1","dd")#=1 AND #fnDatePartNum("#FechaFin# + 1","dd")#<>1">
			<cfset LvarAjusteMM = "CASE WHEN #LvarAjustePos# THEN +1 WHEN #LvarAjusteNeg# THEN -1 ELSE 0 END">
			<cfset LvarFunc = "MONTHS_BETWEEN(#FechaFin#, #FechaIni#)">
			<cfset LvarFunc = "TRUNC(#LvarFunc# + #LvarAjusteMM#)">
			<cfreturn LvarFunc>
		<cfelseif LvarDPart EQ "wk">
			<cfset LvarFunc = "(#FechaFin# - #FechaIni#)">
			<cfset LvarFunc = "TRUNC(ROUND(#LvarFunc#/7.0,6))">
			<cfreturn LvarFunc>
		<cfelseif LvarDPart EQ "dd">
			<cfset LvarFunc = "(#FechaFin# - #FechaIni#)">
			<cfset LvarFunc = "TRUNC(ROUND(#LvarFunc#,6))">
			<cfreturn LvarFunc>
		<cfelseif LvarDPart EQ "hh">
			<cfset LvarFunc = "(#FechaFin# - #FechaIni#)">
			<cfset LvarFunc = "TRUNC(ROUND(#LvarFunc#*24,6))">
			<cfreturn LvarFunc>
		<cfelseif LvarDPart EQ "mi">
			<cfset LvarFunc = "(#FechaFin# - #FechaIni#)">
			<cfset LvarFunc = "TRUNC(ROUND(#LvarFunc#*1440,6))">
			<cfreturn LvarFunc>
		<cfelseif LvarDPart EQ "ss">
			<cfset LvarFunc = "(#FechaFin# - #FechaIni#)">
			<cfset LvarFunc = "TRUNC(ROUND(#LvarFunc#*86400,6))">
			<cfreturn LvarFunc>
		<cfelseif LvarDPart EQ "ms">
			<cfset LvarFunc = "(#FechaFin# - #FechaIni#)">
			<cfset LvarFunc = "TRUNC(ROUND(#LvarFunc#*86400000,6))">
			<cfreturn LvarFunc>
		<cfelse>
			<cfthrow message="Argumento datepart='#Arguments.DPart#' incorrecto, solo se permite: yy,mm,wk,dd,hh,mi,ss,ms">
		</cfif>
	<cfelseif LvarDBtype EQ "db2">
		<!---	
			Ajuste de fin de mes: cuando el dia de fechaIni es mayor o igual al dia de fechaFin, ya hay un mes completo, y el ajuste es incorrecto para el caso de que FechaIni sea ultimo y FechaFin no lo sea. 30/nov contra 30/dic (se come un mes por ajuste a 1/dic contra 31/dic)
		--->	
		<cfset LvarAjusteMM = "#fnFechaSinHora(FechaIni)# < #fnFechaSinHora(FechaFin)# AND #fnDatePartNum(FechaIni,"dd")# <= #fnDatePartNum(FechaFin,"dd")# OR #fnFechaSinHora(FechaIni)# > #fnFechaSinHora(FechaFin)# AND #fnDatePartNum(FechaIni,"dd")# >= #fnDatePartNum(FechaFin,"dd")#">
		<cfset LvarFunc = "((DAYS(#FechaFin#) + (MIDNIGHT_SECONDS(#FechaFin#)/86400.0))-(DAYS(#FechaIni#) + (MIDNIGHT_SECONDS(#FechaIni#)/86400.0)))">
		<cfset LvarFechasNN = "#fnFechaSinHora(FechaFin)# - #fnFechaSinHora(FechaIni)#">
		<cfset LvarFechasAA = "(#fnFechaSinHora(FechaFin)# + 1 DAYS) - (#fnFechaSinHora(FechaIni)# + 1 DAYS)">
		<cfif DPart EQ "yy" OR DPart EQ "yyyy" >
			<!---	
				Ajuste de fin de mes para año sólo es necesario para 28/2 contra 29/2
			--->	
			<cfset LvarFunc = "YEAR(#LvarFechasAA#) ">
			<cfreturn LvarFunc>
		<cfelseif DPart EQ "qq">
			<cfset LvarFunc = "CASE WHEN #LvarAjusteMM# THEN YEAR(#LvarFechasNN#)*12 + MONTH(#LvarFechasNN#) ELSE YEAR(#LvarFechasAA#)*12 + MONTH(#LvarFechasAA#) END">
			<cfset LvarFunc = "INT(#LvarFunc#/3.0)">
			<cfreturn LvarFunc>
		<cfelseif DPart EQ "mm">
			<cfset LvarFunc = "CASE WHEN #LvarAjusteMM# THEN YEAR(#LvarFechasNN#)*12 + MONTH(#LvarFechasNN#) ELSE YEAR(#LvarFechasAA#)*12 + MONTH(#LvarFechasAA#) END">
			<cfreturn LvarFunc>
		<cfelseif LvarDPart EQ "wk">
			<cfset LvarFunc = "(#fnDatePartNum(FechaFin,"jj")#+#fnDatePartNum(FechaFin,"sssss")#/86400.0-#fnDatePartNum(FechaIni,"jj")#-#fnDatePartNum(FechaIni,"sssss")#/86400.0)">
			<cfset LvarFunc = "INT(#LvarFunc# / 7)">
			<cfreturn LvarFunc>
		<cfelseif LvarDPart EQ "dd">
			<cfset LvarFunc = "INT(ROUND(#LvarFunc#,6))">
			<cfreturn LvarFunc>
		<cfelseif LvarDPart EQ "hh">
			<cfset LvarFunc = "INT(ROUND(#LvarFunc#*24.0,6))">
			<cfreturn LvarFunc>
		<cfelseif LvarDPart EQ "mi">
			<cfset LvarFunc = "INT(ROUND(#LvarFunc#*1440.0,6))">
			<cfreturn LvarFunc>
		<cfelseif LvarDPart EQ "ss">
			<cfset LvarFunc = "INT(ROUND(#LvarFunc#*86400.0,6))">
			<cfreturn LvarFunc>
		<cfelseif LvarDPart EQ "ms">
			<cfset LvarFunc = "INT(ROUND(#LvarFunc#*86400000.0,6))">
			<cfreturn LvarFunc>
		<cfelse>
			<cfthrow message="Argumento datepart='#Arguments.DPart#' incorrecto, solo se permite: yy,mm,wk,dd,hh,mi,ss,ms">
		</cfif>
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

<!--- Convertir 'DD/MM/YYYY' a date --->
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
			<cfreturn "convert(datetime,substring('#LvarFecha#',1,10),103)">
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

<!--- Convertir 'YYYYMMDD' a date --->
<cffunction name="fnYMDtoDate" returntype="string">
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
		<cfset LvarFecha = ParseDateTime(mid(LvarFecha,1,4) & "-" & mid(LvarFecha,5,2) & "-" & mid(LvarFecha,7,2) & mid(LvarFecha,9,200))>
		<cfif Arguments.sinHora>
			<cfset LvarFecha = "#dateFormat(LvarFecha, "YYYY-MM-DD")#">
		<cfelse>
			<cfset LvarFecha = "#dateFormat(LvarFecha, "YYYY-MM-DD")# #timeFormat(LvarFecha, "HH:MM:SS")#">
		</cfif>
		<cfreturn fnSTRtoDate("#LvarFecha#", Arguments.sinHora)>
	<cfelseif mid(LvarFecha,1,1) EQ "{">
			<cfthrow message="Con formato YMD no se permite enviar constante fecha JDBC">
	<cfelseif LvarDBtype EQ 'sybase'>
		<cfif Arguments.sinHora>
			<cfreturn "convert(date,#LvarFecha#)">
		<cfelse>
			<cfreturn "convert(datetime,#LvarFecha#)">
		</cfif>
	<cfelseif LvarDBtype EQ 'sqlserver'>
		<cfif Arguments.sinHora>
			<!--- Convierte la hilera a Datetime, luego a string sin hora, y luego otra vez a Datetime pero sin hora --->
			<cfreturn "convert(datetime,substring(#LvarFecha#,1,8))">
		<cfelse>
			<cfreturn "convert(datetime,#LvarFecha#)">
		</cfif>
	<cfelseif LvarDBtype EQ 'oracle'>
		<cfif Arguments.sinHora>
			<cfreturn "to_date(SUBSTR(#LvarFecha#,1,8), 'YYYYMMDD')">
		<cfelse>
			<cfreturn "to_date(#LvarFecha#, 'YYYYMMDD HH24:MI:SS')">
		</cfif>
	<cfelseif LvarDBtype EQ 'db2'>
		<cfif Arguments.sinHora>
			<cfset LvarFecha = "SUBSTR(#LvarFecha#, 1, 4) #OP_CONCAT# '-' #OP_CONCAT# SUBSTR(#LvarFecha#, 5, 2) #OP_CONCAT# '-' #OP_CONCAT# SUBSTR(#LvarFecha#, 7, 2) #OP_CONCAT# ' 00:00:00'">
			<cfreturn "to_date(#LvarFecha#, 'YYYY-MM-DD HH24:MI:SS')">
		<cfelse>
			<cfset LvarFecha = "SUBSTR(#LvarFecha#, 1, 4) #OP_CONCAT# '-' #OP_CONCAT# SUBSTR(#LvarFecha#, 5, 2) #OP_CONCAT# '-' #OP_CONCAT# SUBSTR(#LvarFecha#, 7, 2) #OP_CONCAT# SUBSTR(RTRIM(#LvarFecha#) #OP_CONCAT# ' 00:00:00', 9, 9)">
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
			<cfcase value="JJ">
				<cfset LvarReturn = "datediff(dd,#LvarFecha#,'1953-01-01')">
			</cfcase>
			<cfcase value="SSSSS">
				<cfset LvarReturn = "(datepart(hh, #LvarFecha#)*3600+datepart(mi, #LvarFecha#)*60+datepart(ss, #LvarFecha#))">
			</cfcase>
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
			<cfcase value="SSSSS">
				<cfset LvarReturn = "to_char(#LvarFecha#, 'SSSSS')">
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
			<cfcase value="SSSSS">
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


<cffunction name="fnCeiling" access="public" output="no">
	<cfif LvarDBtype EQ 'sybase'>
		<cfreturn "ceiling">
	<cfelseif LvarDBtype EQ 'sqlserver'>
		<cfreturn "ceiling">
	<cfelseif LvarDBtype EQ "oracle">
		<cfreturn "ceil">
	<cfelseif LvarDBtype EQ "db2">
		<cfreturn "ceiling">
	</cfif>
</cffunction>

<cffunction name="fnGetArgI" access="private" output="no">
	<cfargument name="i" required="yes" type="numeric">
	<cfreturn rtrim(listGetAt(Attributes.args, Arguments.i, Attributes.delimiters))>
</cffunction>
