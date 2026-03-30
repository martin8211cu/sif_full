<!--- *********************  I m p o r t a d o r     d e     M a r c a s     de     H e n k e l ********************* --->
<!--- LA SINTAXIS DE ESTE FUENTE ESTÁ OPTIMIZADA PARA *ORACLE*, LA MISMA NO ES ANSI, POR LO QUE NO CORRE EN OTRO DBMS --->
<!--- Este  importador  está desarrollado con una funcionalidad limitada, para solventar una necesisdad específica, de una 
cliente.  HENKEL,  el  mismo  puede  pero  no debe ser utilzado en otro cliente, debido a que debe realizarse una análisis
profundo  de la funcionalidad completa que debe tener el importador de este proceso para cumplir con toda la funcionalidad
permitida en el proceso. --->
<cfset Debug = False>
<!--- Tabla Temporal de Errores: El propósito de utilizar esta tabla es devolver todos los errores del archivo en una sola 
salida, dando así al usuario la facilidad de corregir todos los errores de una sola vez en lugar de hacerlo tipo por tipo --->
<cf_dbtemp name="ERRIMPORTADORMARCASHENKEL" returnvariable="ERRORES" datasource="#session.dsn#">
	<cf_dbtempcol name="ERRORNUM" 	type="integer" 		mandatory="yes">
	<cf_dbtempcol name="MESSAGE" 	type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="DATA" 		type="varchar(65)" 	mandatory="no">	
</cf_dbtemp>
<!---======== Tabla temporal de marcas  ========--->
<cf_dbtemp name="IMPORTADORMARCASHENKEL" returnvariable="MARCAS" datasource="#session.DSN#">
	 <cf_dbtempcol name="ID"  				type="numeric"		identity="yes">
	 <cf_dbtempcol name="DEIDENTIFICACION"  type="varchar(8)"	mandatory="yes">
	 <cf_dbtempcol name="FECHAHORAMARCA"  	type="datetime" 	mandatory="yes">
	 <cf_dbtempcol name="TIPOMARCA"   		type="varchar(1)" 	mandatory="yes">
	 <cf_dbtempcol name="PAGOALMUERZO"   	type="int" 			mandatory="yes">
	 <cf_dbtempcol name="GRUPOMARCAS"   	type="int" 			mandatory="yes">
</cf_dbtemp>
<!--- VARIABLES PARA IDENTIFICAR LAS SECCIONES DE LA FILA DE DATOS DEL ARCHIVO --->
<cfset vIDE = 01><!--- CARACTER DONDE INICIA LA IDENTIFICACION DEL EMPLEADO (DEidentificacion) --->
<cfset vLDE = 08><!--- LONGITUD LA IDENTIFICACION DEL EMPLEADO (DEidentificacion) --->
<cfset vFEC = 09><!--- CARACTER DONDE INICIA LA FECHA (LONGITUD SE ASUME QUE ES 8) --->
<cfset vHEM = 17><!--- CARACTER DONDE INICIA LA HORA ENTRADA MAÑANA (LONGITUD SE ASUME QUE ES 8) --->
<cfset vHSM = 25><!--- CARACTER DONDE INICIA LA HORA SALIDA MAÑANA (LONGITUD SE ASUME QUE ES 8) --->
<cfset vHET = 33><!--- CARACTER DONDE INICIA LA HORA ENTRADA TARDE (LONGITUD SE ASUME QUE ES 8) --->
<cfset vHST = 41><!--- CARACTER DONDE INICIA LA HORA SALIDA TARDE (LONGITUD SE ASUME QUE ES 8) --->
<cfset vHEN = 49><!--- CARACTER DONDE INICIA LA HORA ENTRADA NOCHE (LONGITUD SE ASUME QUE ES 8) --->
<cfset vHSN = 57><!--- CARACTER DONDE INICIA LA HORA SALIDA NOCHE (LONGITUD SE ASUME QUE ES 8) --->
<cfset vHPA = 65><!--- CARACTER INDICADOR DEL PAGO DE LA HORA DE ALMUERZO --->
<!---- ************************************* V A L I D A C I O N E S ************************************ --->
<!--- 100. Tamaño de la Fila: Validar que el tamaño de la fila sea 65 --->
<cfquery datasource="#session.dsn#">
	INSERT 	INTO #ERRORES# (ERRORNUM, MESSAGE, DATA)
	SELECT 	distinct 100, 'Fila con menos de 65 caracteres.', Fila
	FROM 	#table_name#
	WHERE 	len(Fila) < #vHSN#
</cfquery>
<!--- 200. Datos del Empleado: Validar que el empleado exista --->
<cfquery datasource="#session.dsn#">
	INSERT 	INTO #ERRORES# (ERRORNUM, MESSAGE, DATA)
	SELECT 	distinct 200, 'Empleado No Encontrado.', to_char(substring(#table_name#.FILA,#vIDE#,#vLDE#))
	FROM 	#table_name#
	WHERE not exists(
		SELECT 1 FROM DatosEmpleado
		WHERE Ecodigo = #Session.Ecodigo#
		  AND trim(DEidentificacion) = trim(substring(#table_name#.FILA,#vIDE#,#vLDE#))
	)
</cfquery>
<!--- 300. Fecha de la Marca: Validar Formato de la Fecha de la marca --->
<cfquery datasource="#session.dsn#">
	INSERT 	INTO #ERRORES# (ERRORNUM, MESSAGE, DATA)
	SELECT 	300, 'Formato de Fecha Incorrecto.', substring(FILA,#vFEC#,8)
	FROM 	#table_name#
	WHERE NOT (
	      substring(FILA,#vFEC+0#,1) = '2'
	  AND substring(FILA,#vFEC+1#,1) = '0'
	  AND substring(FILA,#vFEC+2#,1) between '0' and '9'
	  AND substring(FILA,#vFEC+3#,1) between '0' and '9'
	  AND substring(FILA,#vFEC+4#,1) between '0' and '1'
	  AND substring(FILA,#vFEC+5#,1) 
	  	between 
	  		case substring(FILA,#vFEC+4#,1) 
	  			when '0' then '1' 
	  			else  '0' 
	  		end 
	  	and 
	  		case substring(FILA,#vFEC+4#,1) 
	  			when '0' then '9' 
	  			else  '2' 
	  		end
	  AND substring(FILA,#vFEC+6#,1) between '0' and case substring(FILA,#vFEC+4#,2) when '02' then '2' else '3' end
	  AND substring(FILA,#vFEC+7#,1) 
	  	between 
	  		case substring(FILA,#vFEC+6#,1) 
	  			when '0' then '1' 
	  			else  '0' 
	  		end 
	  	and 
	  		case substring(FILA,#vFEC+6#,1) 
	  			when '0' then '9'
	  			when '1' then '9' 
	  			when '2' then 
	  				case substring(FILA,#vFEC+4#,2) 
	  					when '02' then 
	  						case mod((substring(FILA,#vFEC+0#,4)),4)
	  							when 0 then '9' 
	  							else '8' 
	  						end 
	  					else '9' 
	  				end
				when '3' then 
	  				case substring(FILA,#vFEC+4#,2) 
	  					when '01' then '1'
	  					when '03' then '1'
	  					when '05' then '1'
						when '07' then '1'
						when '08' then '1'
						when '10' then '1'
						when '12' then '1'
	  					else '0' 
	  				end
	  		end
	)
</cfquery>
<!--- 400. Hora de la Marca: Validar Formato de la Hora de la Marca de E de la Mañana --->
<cfquery datasource="#session.dsn#">
	INSERT 	INTO #ERRORES# (ERRORNUM, MESSAGE, DATA)
	SELECT 	400, 'Hora de la Marca de Entrada de la Ma&ntilde;ana Incorrecta.', substring(FILA,#vHEM+0#,8)
	FROM 	#table_name#
	WHERE len(trim(replace(substring(FILA,#vHEM+0#,8),':',''))) > 0
	AND NOT (
	      substring(FILA,#vHEM+0#,1) between '0' and '9'
	  AND substring(FILA,#vHEM+1#,1) between '0' and '9'
	  AND substring(FILA,#vHEM+2#,1) = ':'
	  AND substring(FILA,#vHEM+3#,1) between '0' and '9'
	  AND substring(FILA,#vHEM+4#,1) between '0' and '9'
	  AND substring(FILA,#vHEM+5#,1) = ':'
	  AND substring(FILA,#vHEM+6#,1) between '0' and '9'
	  AND substring(FILA,#vHEM+7#,1) between '0' and '9'
	)
</cfquery>
<!--- 500. Hora de la Marca: Validar Formato de la Hora de la Marca de S de la Mañana --->
<cfquery datasource="#session.dsn#">
	INSERT 	INTO #ERRORES# (ERRORNUM, MESSAGE, DATA)
	SELECT 	500, 'Hora de la Marca de Salida de la Ma&ntilde;ana Incorrecta.', substring(FILA,#vHSM+0#,8)
	FROM 	#table_name#
	WHERE len(trim(replace(substring(FILA,#vHSM+0#,8),':',''))) > 0
	AND NOT (
	      substring(FILA,#vHSM+0#,1) between '0' and '9'
	  AND substring(FILA,#vHSM+1#,1) between '0' and '9'
	  AND substring(FILA,#vHSM+2#,1) = ':'
	  AND substring(FILA,#vHSM+3#,1) between '0' and '9'
	  AND substring(FILA,#vHSM+4#,1) between '0' and '9'
	  AND substring(FILA,#vHSM+5#,1) = ':'
	  AND substring(FILA,#vHSM+6#,1) between '0' and '9'
	  AND substring(FILA,#vHSM+7#,1) between '0' and '9'
	)
</cfquery>
<!--- 600. Hora de la Marca: Validar Formato de la Hora de la Marca de E de la Tarde --->
<cfquery datasource="#session.dsn#">
	INSERT 	INTO #ERRORES# (ERRORNUM, MESSAGE, DATA)
	SELECT 	600, 'Hora de la Marca de Entrada de la Tarde Incorrecta.', substring(FILA,#vHET+0#,8)
	FROM 	#table_name#
	WHERE len(trim(replace(substring(FILA,#vHET+0#,8),':',''))) > 0
	AND NOT (
	      substring(FILA,#vHET+0#,1) between '0' and '9'
	  AND substring(FILA,#vHET+1#,1) between '0' and '9'
	  AND substring(FILA,#vHET+2#,1) = ':'
	  AND substring(FILA,#vHET+3#,1) between '0' and '9'
	  AND substring(FILA,#vHET+4#,1) between '0' and '9'
	  AND substring(FILA,#vHET+5#,1) = ':'
	  AND substring(FILA,#vHET+6#,1) between '0' and '9'
	  AND substring(FILA,#vHET+7#,1) between '0' and '9'
	)
</cfquery>
<!--- 700. Hora de la Marca: Validar Formato de la Hora de la Marca de S de la Tarde --->
<cfquery datasource="#session.dsn#">
	INSERT 	INTO #ERRORES# (ERRORNUM, MESSAGE, DATA)
	SELECT 	700, 'Hora de la Marca de Salida de la Tarde Incorrecta.', substring(FILA,#vHST+0#,8)
	FROM 	#table_name#
	WHERE len(trim(replace(substring(FILA,#vHST+0#,8),':',''))) > 0
	AND NOT (
	      substring(FILA,#vHST+0#,1) between '0' and '9'
	  AND substring(FILA,#vHST+1#,1) between '0' and '9'
	  AND substring(FILA,#vHST+2#,1) = ':'
	  AND substring(FILA,#vHST+3#,1) between '0' and '9'
	  AND substring(FILA,#vHST+4#,1) between '0' and '9'
	  AND substring(FILA,#vHST+5#,1) = ':'
	  AND substring(FILA,#vHST+6#,1) between '0' and '9'
	  AND substring(FILA,#vHST+7#,1) between '0' and '9'
	)
</cfquery>
<!--- 800. Hora de la Marca: Validar Formato de la Hora de la Marca de E de la Noche --->
<cfquery datasource="#session.dsn#">
	INSERT 	INTO #ERRORES# (ERRORNUM, MESSAGE, DATA)
	SELECT 	800, 'Hora de la Marca de Entrada de la Noche Incorrecta.', substring(FILA,#vHEN+0#,8)
	FROM 	#table_name#
	WHERE len(trim(replace(substring(FILA,#vHEN+0#,8),':',''))) > 0
	AND NOT (
	      substring(FILA,#vHEN+0#,1) between '0' and '9'
	  AND substring(FILA,#vHEN+1#,1) between '0' and '9'
	  AND substring(FILA,#vHEN+2#,1) = ':'
	  AND substring(FILA,#vHEN+3#,1) between '0' and '9'
	  AND substring(FILA,#vHEN+4#,1) between '0' and '9'
	  AND substring(FILA,#vHEN+5#,1) = ':'
	  AND substring(FILA,#vHEN+6#,1) between '0' and '9'
	  AND substring(FILA,#vHEN+7#,1) between '0' and '9'
	)
</cfquery>
<!--- 900. Hora de la Marca: Validar Formato de la Hora de la Marca de S de la Noche --->
<cfquery datasource="#session.dsn#">
	INSERT 	INTO #ERRORES# (ERRORNUM, MESSAGE, DATA)
	SELECT 	900, 'Hora de la Marca de Salida de la Noche Incorrecta.', substring(FILA,#vHSN+0#,8)
	FROM 	#table_name#
	WHERE len(trim(replace(substring(FILA,#vHSN+0#,8),':',''))) > 0
	AND NOT (
	      substring(FILA,#vHSN+0#,1) between '0' and '9'
	  AND substring(FILA,#vHSN+1#,1) between '0' and '9'
	  AND substring(FILA,#vHSN+2#,1) = ':'
	  AND substring(FILA,#vHSN+3#,1) between '0' and '9'
	  AND substring(FILA,#vHSN+4#,1) between '0' and '9'
	  AND substring(FILA,#vHSN+5#,1) = ':'
	  AND substring(FILA,#vHSN+6#,1) between '0' and '9'
	  AND substring(FILA,#vHSN+7#,1) between '0' and '9'
	)
</cfquery>
<!--- 910. Horas Nulas: Validar que todas las horas no vengan en blanco --->
<cfquery datasource="#session.dsn#">
	INSERT 	INTO #ERRORES# (ERRORNUM, MESSAGE, DATA)
	SELECT 	910, 'Hora de todas las Marcas Nulas.',
		{fn concat('C&oacute;digo Empleado: ',
            {fn concat(to_char(substring(#table_name#.FILA,#vIDE#,#vLDE#)),
                {fn concat(' del d&iacute;a  ',substring(FILA,#vFEC#,8))} 
            )}
        )}
	FROM 	#table_name#
	WHERE 
	coalesce(len(trim(replace(substring(FILA,#vHEM+0#,8),':',''))),0) = 0 and 
	coalesce(len(trim(replace(substring(FILA,#vHSM+0#,8),':',''))),0) = 0 and
	coalesce(len(trim(replace(substring(FILA,#vHET+0#,8),':',''))),0) = 0 and
	coalesce(len(trim(replace(substring(FILA,#vHST+0#,8),':',''))),0) = 0 and
	coalesce(len(trim(replace(substring(FILA,#vHEN+0#,8),':',''))),0) = 0 and
	coalesce(len(trim(replace(substring(FILA,#vHSN+0#,8),':',''))),0) = 0
</cfquery>
<!--- 1000. Indicador de Pago de Hora de Almuezo: Validar valores (0,1) --->
<cfquery datasource="#session.dsn#">
	INSERT 	INTO #ERRORES# (ERRORNUM, MESSAGE, DATA)
	SELECT 	1000, 'Indicador de Pago de Hora de Almuezo Incorrecto (0=No,1=S&iacute;).', substring(FILA,#vHPA#,1)
	FROM 	#table_name#
	WHERE NOT substring(FILA,#vHPA#,1) between '0' and '1'
</cfquery>
<!--- CONSULTA LA TABLA DE ERRORES SI TIENE ERRORES LOS PRESENTARA EL GENERICO, Y NO SE REALIZA EL PROCESO --->
<cfquery name="err" datasource="#session.dsn#">
	SELECT	 ERRORNUM, MESSAGE, DATA
	FROM 	 #ERRORES#
	ORDER BY ERRORNUM
</cfquery><!---- **************************** C R E A R   T A B L A  D E   M A R C A S **************************** --->
<cfif err.recordcount EQ 0>
	<!--- MARCAS DE ENTRADA SALIDA DE LA MAÑANA --->
	<cftry>
		<cfquery datasource="#session.dsn#">
			insert into #MARCAS# (DEIDENTIFICACION,FECHAHORAMARCA,TIPOMARCA,PAGOALMUERZO,GRUPOMARCAS)
			SELECT substring(FILA,#vIDE#,#vLDE#), TO_DATE({fn concat(substring(FILA,#vFEC#,8),{fn concat(' ',substring(FILA,#vHEM#,8))})},'YYYYMMDD HH24:MI:SS'), 'E', substring(FILA,#vHPA#,1),ID
			FROM #TABLE_NAME#
			WHERE substring(FILA,#vHEM+0#,1) between '0' and '9'
			  AND substring(FILA,#vHEM+1#,1) between '0' and '9'
			  AND substring(FILA,#vHEM+2#,1) = ':'
			  AND substring(FILA,#vHEM+3#,1) between '0' and '9'
			  AND substring(FILA,#vHEM+4#,1) between '0' and '9'
			  AND substring(FILA,#vHEM+5#,1) = ':'
			  AND substring(FILA,#vHEM+6#,1) between '0' and '9'
			  AND substring(FILA,#vHEM+7#,1) between '0' and '9'
		</cfquery>
		<cfquery datasource="#session.dsn#">
			insert into #MARCAS# (DEIDENTIFICACION,FECHAHORAMARCA,TIPOMARCA,PAGOALMUERZO,GRUPOMARCAS)
			SELECT substring(FILA,#vIDE#,#vLDE#), 
				to_date(<cf_dbfunction name="concat" args="case  when to_number(substring(FILA,#vHSM#,2)) < 24 then substring(FILA,#vFEC#,8) else to_char(dateadd('d',1,to_date(substring(FILA,#vFEC#,8),'YYYYMMDD')),'YYYYMMDD') end|' '|case  when to_number(substring(FILA,#vHSM#,2)) < 24 then substring(FILA,#vHSM#,2) else to_char(to_number(substring(FILA,#vHSM#,2))-24) end|':'|substring(FILA,#vHSM+3#,2)|':'|substring(FILA,#vHSM+6#,2)" delimiters="|">,'YYYYMMDD HH24:MI:SS'),
				<!--- TO_DATE(
					{fn concat(
						case  when to_number(substring(FILA,#vHSM#,2)) < 24 then substring(FILA,#vFEC#,8) else to_char(dateadd('d',1,to_date(substring(FILA,#vFEC#,8),'YYYYMMDD')),'YYYYMMDD') end,
						{fn concat(' ',
							{fn concat(
								case  when to_number(substring(FILA,#vHSM#,2)) < 24 then substring(FILA,#vHSM#,2) else to_char(to_number(substring(FILA,#vHSM#,2))-24) end,
								{fn concat(
									':',
									{fn concat(
										substring(FILA,#vHSM+3#,2),
										{fn concat(
											':',
											substring(FILA,#vHSM+6#,2)
										)}	
									)}
								)}
							)}
						)}
					)}
					,'YYYYMMDD HH24:MI:SS'
				), --->
				'S', substring(FILA,#vHPA#,1),ID
			FROM #TABLE_NAME#
			WHERE substring(FILA,#vHSM+0#,1) between '0' and '9'
			  AND substring(FILA,#vHSM+1#,1) between '0' and '9'
			  AND substring(FILA,#vHSM+2#,1) = ':'
			  AND substring(FILA,#vHSM+3#,1) between '0' and '9'
			  AND substring(FILA,#vHSM+4#,1) between '0' and '9'
			  AND substring(FILA,#vHSM+5#,1) = ':'
			  AND substring(FILA,#vHSM+6#,1) between '0' and '9'
			  AND substring(FILA,#vHSM+7#,1) between '0' and '9'
		</cfquery>
		<cfcatch>
			<cfthrow  message="Error en Importador de Marcas Henkel. Error Insertando Marcas de Entrada / Salida de la Mañana. Proceso Cancelado!">
		</cfcatch>
	</cftry>
	<!--- MARCAS DE ENTRADA SALIDA DE LA TARDE --->
	<cftry>
		<cfquery datasource="#session.dsn#">
			insert into #MARCAS# (DEIDENTIFICACION,FECHAHORAMARCA,TIPOMARCA,PAGOALMUERZO,GRUPOMARCAS)
			SELECT substring(FILA,#vIDE#,#vLDE#), TO_DATE({fn concat(substring(FILA,#vFEC#,8),{fn concat(' ',substring(FILA,#vHET#,8))})},'YYYYMMDD HH24:MI:SS'), 'E', substring(FILA,#vHPA#,1),ID
			FROM #TABLE_NAME#
			WHERE substring(FILA,#vHET+0#,1) between '0' and '9'
			  AND substring(FILA,#vHET+1#,1) between '0' and '9'
			  AND substring(FILA,#vHET+2#,1) = ':'
			  AND substring(FILA,#vHET+3#,1) between '0' and '9'
			  AND substring(FILA,#vHET+4#,1) between '0' and '9'
			  AND substring(FILA,#vHET+5#,1) = ':'
			  AND substring(FILA,#vHET+6#,1) between '0' and '9'
			  AND substring(FILA,#vHET+7#,1) between '0' and '9'
		</cfquery>
		<cfquery datasource="#session.dsn#">
			insert into #MARCAS# (DEIDENTIFICACION,FECHAHORAMARCA,TIPOMARCA,PAGOALMUERZO,GRUPOMARCAS)
			SELECT substring(FILA,#vIDE#,#vLDE#),  
				to_date(<cf_dbfunction name="concat" args="case  when to_number(substring(FILA,#vHST#,2)) < 24 then substring(FILA,#vFEC#,8) else to_char(dateadd('d',1,to_date(substring(FILA,#vFEC#,8),'YYYYMMDD')),'YYYYMMDD') end|' '|case  when to_number(substring(FILA,#vHST#,2)) < 24 then substring(FILA,#vHST#,2) else to_char(to_number(substring(FILA,#vHST#,2))-24) end|':'|substring(FILA,#vHST+3#,2)|':'|substring(FILA,#vHST+6#,2)" delimiters="|">,'YYYYMMDD HH24:MI:SS'),
				<!--- TO_DATE(
					{fn concat(
						case  when to_number(substring(FILA,#vHST#,2)) < 24 then substring(FILA,#vFEC#,8) else to_char(dateadd('d',1,to_date(substring(FILA,#vFEC#,8),'YYYYMMDD')),'YYYYMMDD') end,
						{fn concat(' ',
							{fn concat(
								case  when to_number(substring(FILA,#vHST#,2)) < 24 then substring(FILA,#vHST#,2) else to_char(to_number(substring(FILA,#vHST#,2))-24) end,
								{fn concat(
									':',
									{fn concat(
										substring(FILA,#vHST+3#,2),
										{fn concat(
											':',
											substring(FILA,#vHST+6#,2)
										)}	
									)}
								)}
							)}
						)}
					)}
					,'YYYYMMDD HH24:MI:SS'
				), --->
				'S', substring(FILA,#vHPA#,1),ID
			FROM #TABLE_NAME#
			WHERE substring(FILA,#vHST+0#,1) between '0' and '9'
			  AND substring(FILA,#vHST+1#,1) between '0' and '9'
			  AND substring(FILA,#vHST+2#,1) = ':'
			  AND substring(FILA,#vHST+3#,1) between '0' and '9'
			  AND substring(FILA,#vHST+4#,1) between '0' and '9'
			  AND substring(FILA,#vHST+5#,1) = ':'
			  AND substring(FILA,#vHST+6#,1) between '0' and '9'
			  AND substring(FILA,#vHST+7#,1) between '0' and '9'
		</cfquery>
		<cfcatch>
			<cfthrow  message="Error en Importador de Marcas Henkel. Error Insertando Marcas de Entrada / Salida de la Tarde. Proceso Cancelado!">
		</cfcatch>
	</cftry>
	<!--- MARCAS DE ENTRADA SALIDA DE LA NOCHE --->
	<cftry>
		<cfquery datasource="#session.dsn#">
			insert into #MARCAS# (DEIDENTIFICACION,FECHAHORAMARCA,TIPOMARCA,PAGOALMUERZO,GRUPOMARCAS)
			SELECT substring(FILA,#vIDE#,#vLDE#), TO_DATE({fn concat(substring(FILA,#vFEC#,8),{fn concat(' ',substring(FILA,#vHEN#,8))})},'YYYYMMDD HH24:MI:SS'), 'E', substring(FILA,#vHPA#,1),ID
			FROM #TABLE_NAME#
			WHERE substring(FILA,#vHEN+0#,1) between '0' and '9'
			  AND substring(FILA,#vHEN+1#,1) between '0' and '9'
			  AND substring(FILA,#vHEN+2#,1) = ':'
			  AND substring(FILA,#vHEN+3#,1) between '0' and '9'
			  AND substring(FILA,#vHEN+4#,1) between '0' and '9'
			  AND substring(FILA,#vHEN+5#,1) = ':'
			  AND substring(FILA,#vHEN+6#,1) between '0' and '9'
			  AND substring(FILA,#vHEN+7#,1) between '0' and '9'
		</cfquery>
		<cfquery datasource="#session.dsn#">
			insert into #MARCAS# (DEIDENTIFICACION,FECHAHORAMARCA,TIPOMARCA,PAGOALMUERZO,GRUPOMARCAS)
			SELECT substring(FILA,#vIDE#,#vLDE#), 
				to_date(<cf_dbfunction name="concat" args="case  when to_number(substring(FILA,#vHSN#,2)) < 24 then substring(FILA,#vFEC#,8) else to_char(dateadd('d',1,to_date(substring(FILA,#vFEC#,8),'YYYYMMDD')),'YYYYMMDD') end|' '|case  when to_number(substring(FILA,#vHSN#,2)) < 24 then substring(FILA,#vHSN#,2) else to_char(to_number(substring(FILA,#vHSN#,2))-24) end|':'|substring(FILA,#vHSN+3#,2)|':'|substring(FILA,#vHSN+6#,2)" delimiters="|">,'YYYYMMDD HH24:MI:SS'),
				<!--- TO_DATE(
					{fn concat(
						case  when to_number(substring(FILA,#vHSN#,2)) < 24 then substring(FILA,#vFEC#,8) else to_char(dateadd('d',1,to_date(substring(FILA,#vFEC#,8),'YYYYMMDD')),'YYYYMMDD') end,
						{fn concat(' ',
							{fn concat(
								case  when to_number(substring(FILA,#vHSN#,2)) < 24 then substring(FILA,#vHSN#,2) else to_char(to_number(substring(FILA,#vHSN#,2))-24) end,
								{fn concat(
									':',
									{fn concat(
										substring(FILA,#vHSN+3#,2),
										{fn concat(
											':',
											substring(FILA,#vHSN+6#,2)
										)}	
									)}
								)}
							)}
						)}
					)}
					,'YYYYMMDD HH24:MI:SS'
				), --->
				 'S', substring(FILA,#vHPA#,1),ID
			FROM #TABLE_NAME#
			WHERE substring(FILA,#vHSN+0#,1) between '0' and '9'
			  AND substring(FILA,#vHSN+1#,1) between '0' and '9'
			  AND substring(FILA,#vHSN+2#,1) = ':'
			  AND substring(FILA,#vHSN+3#,1) between '0' and '9'
			  AND substring(FILA,#vHSN+4#,1) between '0' and '9'
			  AND substring(FILA,#vHSN+5#,1) = ':'
			  AND substring(FILA,#vHSN+6#,1) between '0' and '9'
			  AND substring(FILA,#vHSN+7#,1) between '0' and '9'
		</cfquery>
		<cfcatch>
			<cfthrow  message="Error en Importador de Marcas Henkel. Error Insertando Marcas de Entrada / Salida de la Noche. Proceso Cancelado!">
		</cfcatch>
	</cftry>
	<!--- 1100. Validar que las Marcas que se están subiendo no existan previamente en RHControlMarcas --->
    <cfquery datasource="#session.dsn#">
        INSERT     INTO #ERRORES# (ERRORNUM, MESSAGE, DATA)
        SELECT     distinct 1100, 'El registro que se intenta cargar, ya fue cargado anteriormente', 
        {fn concat('C&oacute;digo Empleado: ',
            {fn concat(a.DEidentificacion,
                {fn concat(' del d&iacute;a  ',<cf_dbfunction name="to_datechar" args="a.fechahoramarca">)} 
            )}
        )}
        FROM     #MARCAS# a, 
                DatosEmpleado b,
                RHControlMarcas c
        WHERE b.DEidentificacion = a.DEIDENTIFICACION
        and   b.DEid=c.DEid
        and   a.FechaHoraMarca=c.FechaHoraMarca
        and   b.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    </cfquery>
	<!--- 1200. Validar que el empleado este nombrado en la fecha indicada --->
	
    <cfquery datasource="#session.dsn#">
        INSERT     INTO #ERRORES# (ERRORNUM, MESSAGE, DATA)
        SELECT     distinct 1200, 'Empleado No Nombrado en Fecha', 
        {fn concat('C&oacute;digo Empleado: ',
            {fn concat(DEidentificacion,
                {fn concat(' del d&iacute;a  ',<cf_dbfunction name="to_datechar" args="fechahoramarca">)} 
            )}
        )}
        FROM     #MARCAS# a 
        WHERE NOT EXISTS(
			SELECT 1
			FROM DatosEmpleado b, LineaTiempo c
			WHERE b.Ecodigo = #Session.Ecodigo#
			  AND trim(b.DEidentificacion) = trim(a.DEIDENTIFICACION)
			  AND c.DEid = b.DEid
			  --AND a.FECHAHORAMARCA between c.LTdesde and c.LThasta
			  and <cf_dbfunction name="to_datechar" args="a.FECHAHORAMARCA"> between c.LTdesde and c.LThasta
		)
    </cfquery>
	<!--- 1300. Validar que el empleado tenga detalle de jornada para una fecha --->
    <cfquery name="consulta" datasource="#session.dsn#">
        <!--- INSERT     INTO #ERRORES# (ERRORNUM, MESSAGE, DATA) --->
        SELECT     distinct 1300, 'Empleado no tiene detalle de jornada en fecha' msg, 
        {fn concat('C&oacute;digo Empleado: ',
            {fn concat(DEidentificacion,
                {fn concat(' del d&iacute;a  ',<cf_dbfunction name="to_datechar" args="fechahoramarca">)} 
            )}
        )} empleado
        FROM     #MARCAS#
        WHERE NOT EXISTS(
			SELECT 1
			FROM #MARCAS# a 
			INNER JOIN DatosEmpleado b
			  ON b.Ecodigo = #Session.Ecodigo#
			  AND trim(b.DEidentificacion) = trim(a.DEIDENTIFICACION)
			INNER JOIN LineaTiempo c
			  ON c.DEid = b.DEid
			  and <cf_dbfunction name="to_datechar" args="a.FECHAHORAMARCA"> between c.LTdesde and c.LThasta
			LEFT OUTER JOIN RHPlanificador d
			  ON d.DEid = b.DEid
			  AND to_char(d.RHPJfinicio, 'yyyymmdd') = to_char(a.FECHAHORAMARCA, 'yyyymmdd')
			INNER JOIN RHJornadas e
			  ON e.RHJid = coalesce(d.RHJid,c.RHJid)
			INNER JOIN RHDJornadas f
			  ON f.RHJid = e.RHJid
			  AND f.RHDJdia = to_char(a.FECHAHORAMARCA, 'd')
			WHERE a.ID = #MARCAS#.ID
		)
    </cfquery>
	<!--- 1400. Validar que el empleado est en un Grupo de Marcas--->
    <cfquery datasource="#session.dsn#">
        INSERT     INTO #ERRORES# (ERRORNUM, MESSAGE, DATA)
        SELECT     distinct 1400, 'El Empleado no pertenece a un Grupo de Marcas', 
        {fn concat('C&oacute;digo Empleado: ',
            {fn concat(DEidentificacion,
                {fn concat(' del d&iacute;a  ',<cf_dbfunction name="to_datechar" args="fechahoramarca">)} 
            )}
        )}
        FROM     #MARCAS#
        WHERE NOT EXISTS(
			SELECT 1
			FROM
				 DATOSEMPLEADO a,
				 RHCMEmpleadosGrupo b
			WHERE A.DEIDENTIFICACION=#MARCAS#.DEIDENTIFICACION
			AND A.DEID=B.DEID
		)
    </cfquery>    
	<!--- 1500. Validar que el Empleado tenga Planificada su Jornada--->
    <cfquery datasource="#session.dsn#">
        INSERT     INTO #ERRORES# (ERRORNUM, MESSAGE, DATA)
        SELECT     distinct 1500, 'El Empleado no tiene realizada su planificacin', 
        {fn concat('C&oacute;digo Empleado: ',
            {fn concat(DEidentificacion,
                {fn concat(' del d&iacute;a  ',<cf_dbfunction name="to_datechar" args="fechahoramarca">)} 
            )}
        )}
        FROM     #MARCAS#
        WHERE NOT EXISTS(
			SELECT 1
			FROM
				 DATOSEMPLEADO a,
				 RHPLANIFICADOR b
			WHERE A.DEIDENTIFICACION=#MARCAS#.DEIDENTIFICACION
			AND A.DEID=B.DEID
			AND <cf_dbfunction name="to_datechar" args="#MARCAS#.FECHAHORAMARCA"> BETWEEN
			<cf_dbfunction name="to_datechar" args="b.RHPJFINICIO"> AND
			<cf_dbfunction name="to_datechar" args="b.RHPJFFINAL">
		)
    </cfquery>
	<!--- 1600. Valida que las Marcas que se van a subir no hayan sido subidas anteriormente y aplicadas--->    
    <cfquery datasource="#session.dsn#">
        INSERT     INTO #ERRORES# (ERRORNUM, MESSAGE, DATA)
        SELECT     distinct 1600, 'Esta Marca ya pertenece a un Grupo de Marcas Aplicado e Incluido en la Nmina', 
        {fn concat('C&oacute;digo Empleado: ',
            {fn concat(a.DEidentificacion,
                {fn concat(' del d&iacute;a  ',<cf_dbfunction name="to_datechar" args="a.fechahoramarca">)} 
            )}
        )}
        FROM     #MARCAS# a, 
                DatosEmpleado b,
                RHHControlMarcas c
        WHERE b.DEidentificacion = a.DEIDENTIFICACION
        and   b.DEid=c.DEid
        and   a.FechaHoraMarca=c.FechaHoraMarca
        and   b.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    </cfquery>
    <!--- CONSULTA LA TABLA DE ERRORES SI TIENE ERRORES LOS PRESENTARA EL GENERICO, Y NO SE REALIZA EL PROCESO ---> 
    <cfquery name="err" datasource="#session.dsn#">
        SELECT 		ERRORNUM, MESSAGE, DATA
        FROM   		#ERRORES#
        ORDER BY 	ERRORNUM
    </cfquery><!---- **************************** C R E A R   T A B L A  D E   M A R C A S **************************** ---> 
    
    <cfif err.recordcount EQ 0>    
		<!---- *****************************************  P R O C E S O  **************************************** --->
		<cftransaction>
		<cfquery datasource="#session.DSN#">
			INSERT INTO RHControlMarcas
				( DEid, fechahorareloj, fechahoramarca, tipomarca, pagohoraalmuerzo, 
				RHJid, RHPJid, RHCMhoraplan, ttoleranciaantes, ttoleranciadesp, 
				registroaut, regprocesado, Ecodigo, BMUsucodigo, BMfecha, grupomarcasimp)
			SELECT	
				b.DEid,
				a.FECHAHORAMARCA,
				a.FECHAHORAMARCA,
				a.TIPOMARCA,
				a.PAGOALMUERZO,
				
				e.RHJid,
				d.RHPJid,
				case a.TIPOMARCA when 'E' 
					then coalesce(d.RHPJfinicio,f.RHJhoraini)
					else coalesce(d.RHPJffinal,f.RHJhorafin)
				end,
				case a.TIPOMARCA when 'E' 
					then (select RHCJperiodot
							from RHComportamientoJornada x
							where x.RHJid = e.RHJid
								and x.RHCJcomportamiento = 'H'
								and x.RHCJmomento = 'A')
					else (select RHCJperiodot
							from RHComportamientoJornada x
							where x.RHJid = e.RHJid
								and x.RHCJcomportamiento = 'R'
								and x.RHCJmomento = 'A')
				end,
				case a.TIPOMARCA when 'E' 
					then (select RHCJperiodot
							from RHComportamientoJornada x
							where x.RHJid = e.RHJid
								and x.RHCJcomportamiento = 'R'
								and x.RHCJmomento = 'D')
					else (select RHCJperiodot
							from RHComportamientoJornada x
							where x.RHJid = e.RHJid
								and x.RHCJcomportamiento = 'H'
								and x.RHCJmomento = 'D')
				end,
				
				<cfqueryparam cfsqltype="cf_sql_integer" value="1">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="0">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
				
				a.GRUPOMARCAS
				
			FROM #MARCAS# a
			INNER JOIN DatosEmpleado b
			  ON b.Ecodigo = #Session.Ecodigo#
			  AND trim(b.DEidentificacion) = trim(a.DEIDENTIFICACION)
			INNER JOIN LineaTiempo c
			  ON c.DEid = b.DEid
			  and <cf_dbfunction name="to_datechar" args="a.FECHAHORAMARCA"> between c.LTdesde and c.LThasta
			LEFT OUTER JOIN RHPlanificador d
			  ON d.DEid = b.DEid
			  AND to_char(d.RHPJfinicio, 'yyyymmdd') = to_char(a.FECHAHORAMARCA, 'yyyymmdd')
			INNER JOIN RHJornadas e
			  ON e.RHJid = coalesce(d.RHJid,c.RHJid)
			INNER JOIN RHDJornadas f
			  ON f.RHJid = e.RHJid
			  AND f.RHDJdia = to_char(a.FECHAHORAMARCA, 'd')
		</cfquery>
		
		<cfquery datasource="#session.DSN#">
			update RHControlMarcas
			   set grupomarcas = (select min(RHCMid) from RHControlMarcas subqt where subqt.grupomarcasimp = RHControlMarcas.grupomarcasimp)
			where grupomarcasimp is not null
		</cfquery>
		
		<cfif Debug>
		<cfquery name="rsdebugids" datasource="#session.DSN#">
			select RHCMid as id from RHControlMarcas
			where grupomarcasimp is not null
		</cfquery>
		</cfif>
		
		<cfquery datasource="#session.DSN#">
			update RHControlMarcas
			   set grupomarcasimp = grupomarcas
			where grupomarcasimp is not null
		</cfquery>
		
		<cfif Debug>
		<cfquery name="rsdebug" datasource="#session.DSN#">
			select RHCMid, grupomarcas, grupomarcasimp, DEid, fechahoramarca from RHControlMarcas
			where RHCMid in (#ValueList(rsdebugids.id)#)
			order by grupomarcas
		</cfquery>
		<cf_dump var="#rsdebug#">
		</cfif>
		
		</cftransaction>
	</cfif>
</cfif>
