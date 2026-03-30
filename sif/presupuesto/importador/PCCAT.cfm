<cfinclude template="FnScripts.cfm">

<cfquery  name="rsImportador" datasource="#session.dsn#">
  select * from #table_name# 
  order by id
</cfquery>

<cftransaction>
	<cfset varCon=0>
	<cfloop query="rsImportador">
    <cfset varCon=varCon+1>
		<cfscript>
			if (rsImportador.currentRow EQ 1)
			{
				if (trim(rsImportador.PCEcodigo) EQ "*")
				{
					GvarPrefijo = "*";
					continue;
				}
				else if (trim(rsImportador.PCEcodigo) EQ "")
				{
					sbError ("ERROR", "El primer valor del archivo viene en blanco");
					LvarError = true;
				}
			}
			else if (isdefined("GvarPrefijo"))
			{
				GvarPrefijo = trim(rsImportador.PCEcodigo);
				if (len(GvarPrefijo) GT 5)
				{
					sbError ("ERROR", "El Prefijo para Código de Catálogo '#GvarPrefijo#' tiene más de 5 digitos");
					LvarError = true;
				}
				
			}
		</cfscript>
		<cfif rsImportador.currentRow GTE 2>
			<cfbreak>
		</cfif>
	</cfloop>
	
	<cfif NOT isdefined("LvarError")>
		<cfset LvarAnterior = "">
		<cfset LvarAnteriorErr = false>
		<cfloop query="rsImportador">
			<cfscript>
				if (rsImportador.currentRow EQ 1 and isdefined("GvarPrefijo"))				
					continue;
					
				LvarActual = fnCatalogo(rsImportador.PCEcodigo);
				if (LvarActual EQ "")
					continue;
				
				/*---------------------------------------------------------------------------------------*/
				/*validacion de que se haya definido valores validos para la columna PCDactivo*/
				/*---------------------------------------------------------------------------------------*/
				LvarPCDactivo = rsImportador.PCDactivo;
				if (LvarPCDactivo EQ "")
				{
					sbError ("ERROR", "El archivo importado en la linea  "& rsImportador.currentRow &" para la columna PCDactivo tiene valores vacios");
					LvarError = true;		
					continue;
				}	
				
				if (LvarPCDactivo NEQ "")
				{
					if(LvarPCDactivo neq "1" and LvarPCDactivo neq "0")
					{
						sbError ("ERROR", "El archivo importado  en la linea  "& rsImportador.currentRow &" contiene el valor '#LvarPCDactivo#' en la columna PCDactivo y solo se permiten 0 y 1");
						LvarError = true;
					}
				}
				
				/*------------------------------------------------------------*/
				/*validacion de que PCEdescripcion no este en blanco*/
				/*------------------------------------------------------------*/
				LvarPCEdescripcion = trim(rsImportador.PCEdescripcion);
				if (LvarPCEdescripcion EQ "")
				{
					sbError ("ERROR", "El archivo importado en la linea " & rsImportador.currentRow &"  para la columna PCEdescripcion tiene valores vacios");
					LvarError = true;		
				}
				/*------------------------------------------------------------*/
				/*validacion de que PCDdescripcion no este en blanco*/
				/*------------------------------------------------------------*/
				LvarPCDdescripcion = trim(rsImportador.PCDdescripcion);
				if (LvarPCDdescripcion EQ "")
				{
					sbError ("ERROR", "El archivo importado en la linea " & rsImportador.currentRow &"  para la columna PCDdescripcion tiene valores vacios");
					LvarError = true;		
				}
				/*------------------------------------------------------------*/
				/*validacion de que el PCEcodigo no este en blanco*/
				/*------------------------------------------------------------*/
				LvarPCEcodigo = trim(rsImportador.PCEcodigo);
				if (LvarPCEcodigo EQ "")
				{
					sbError ("ERROR", "El archivo importado en la linea " & rsImportador.currentRow &"  para la columna PCEcodigo tiene valores vacios");
					LvarError = true;		
				}
				
				/*------------------------------------------------------------*/
				/*validacion de que el PCDvalor no este en blanco*/
				/*------------------------------------------------------------*/
				LvarPCDvalor = trim(rsImportador.PCDvalor);
				if (LvarPCDvalor EQ "")
				{
					sbError ("ERROR", "El archivo importado en la linea " & rsImportador.currentRow &"  para la columna PCDvalor tiene valores vacios");
					LvarError = true;		
				}
				
				
				
				
				if (LvarActual NEQ "null" AND LvarAnterior NEQ LvarActual)
				{
					LvarAnterior = LvarActual;
					LvarAnteriorErr = false;
					
					if (isdefined("rsImportador.EsCorporativo") AND rsImportador.EsCorporativo EQ "1")
					{
						LvarPCEempresa	= "0";
						LvarEcodigo		= "null";
						rsQRY = fnQuery ("select count(1) as cantidad from PCECatalogo e inner join PCDCatalogo d on d.PCEcatid=e.PCEcatid where e.CEcodigo=#session.CEcodigo# and e.PCEcodigo=" & LvarActual & " AND d.Ecodigo IS NOT NULL");
						If (rsQRY.cantidad GT 0)
						{
							sbError ("ERROR", "Catálogo '#LvarActual#' se está definiendo con Valores Corporativos, pero ya existen Valores por Empresa");
							LvarAnteriorErr = true;
							continue;
						}
					}
					else
					{
						LvarPCEempresa = "1";
						LvarEcodigo		= session.Ecodigo;
						rsQRY = fnQuery ("select count(1) as cantidad from PCECatalogo e inner join PCDCatalogo d on d.PCEcatid=e.PCEcatid where e.CEcodigo=#session.CEcodigo# and e.PCEcodigo=" & LvarActual & " AND d.Ecodigo IS NULL");
						If (rsQRY.cantidad GT 0)
						{
							sbError ("ERROR", "Catálogo '#LvarActual#' se está definiendo con Valores por Empresa, pero ya existen Valores Corporativos");
							LvarAnteriorErr = true;
							continue;
						}
					}
					
					LvarPCDcatRef = fnCatalogo(rsImportador.PCDcatRef);
					If (LvarPCDcatRef EQ "")
					{
						LvarAnteriorErr = true;
						continue;
					}
					If (LvarPCDcatRef NEQ "null")
						LvarPadre = 1;
					Else
						LvarPadre = 0;
					
					LvarLon = rsImportador.PCElongitud;
					If (LvarLon EQ "" OR LvarLon EQ "0" OR Not IsNumeric(LvarLon))
					{
						sbError ("ERROR", "No indico la longitud del catálogo '#LvarActual#' en la linea " & rsImportador.currentRow );
						LvarAnteriorErr = true;
						continue;
					}

					rsQRY = fnQuery("select count(1) as cantidad from PCECatalogo where CEcodigo=#session.CEcodigo# and PCEcodigo=#LvarActual#");
					If (rsQRY.cantidad EQ 0)
						sbExecute ("insert into PCECatalogo ( " &
								   "   CEcodigo, PCEcodigo, PCEdescripcion, " &
								   "   PCElongitud, PCEempresa, PCEref, PCEreferenciar, PCEactivo, Usucodigo, Ulocalizacion) " &
								   " values( " &
								   "   #session.CEcodigo#, " & LvarActual & ",'" & rsImportador.PCEdescripcion & "'," &
									   LvarLon & ", #LvarPCEempresa#, 0, " & LvarPadre & ", 1, #session.usucodigo#, '00')"
								   );
					Else
						sbExecute ("update PCECatalogo " &
								   "   set PCEdescripcion	= '" & rsImportador.PCEdescripcion & "', " &
								   "       PCEactivo		=1," &
								   "       PCElongitud		=" & LvarLon & "," &
								   "       PCEempresa		=" & LvarPCEempresa & "," &
								   "       PCEreferenciar	=" & LvarPadre &
								   " where CEcodigo=#session.CEcodigo# and PCEcodigo=" & LvarActual
								   );
	
					rsQRY = fnQuery ("select PCEcatid from PCECatalogo where CEcodigo=#session.CEcodigo# and PCEcodigo=" & LvarActual);
					LvarPCEcatid = rsQRY.PCEcatid;
				}
				else If (LvarAnteriorErr)
					continue;

				LvarPCDcatRef = fnCatalogo(rsImportador.PCDcatRef);
				If (LvarPCDcatRef EQ "")
					continue;
					

				If (LvarPCDcatRef EQ "null")
					LvarPCEcatidref = "null";
				else
				{
					rsQRY = fnQuery("select count(1) as cantidad from PCECatalogo where CEcodigo=#session.CEcodigo# and PCEcodigo=" & LvarPCDcatRef);
					If (rsQRY.cantidad EQ 0)
					{
						sbExecute (	"insert into PCECatalogo ( " &
									"   CEcodigo, PCEcodigo, PCEdescripcion, " &
									"   PCElongitud, PCEempresa, PCEref, PCEreferenciar, PCEactivo, " &
									"   Usucodigo, Ulocalizacion) " &
									" values( " &
									"   #session.CEcodigo#, " & LvarPCDcatRef & ",'Catalogo por definir'," &
										0 & ", #LvarPCEempresa#, 1, 0, 0, #session.usucodigo#, '00')"
									);
					}
					Else
					{
						sbExecute ("update PCECatalogo " &
								   "   set PCEref=1" &
								   " where CEcodigo=#session.CEcodigo# and PCEcodigo=" & LvarPCDcatRef
								   );
					}

					rsQRY = fnQuery("select PCEcatid from PCECatalogo where CEcodigo=#session.CEcodigo# and PCEcodigo=" & LvarPCDcatRef);
					LvarPCEcatidref = rsQRY.PCEcatid;
				}

				LvarVal = right(repeatString("0",LvarLon) & rsImportador.PCDvalor, LvarLon);
				rsQRY = fnQuery("select count(1) as cantidad from PCDCatalogo where PCEcatid=" & LvarPCEcatid & " AND PCDvalor='" & LvarVal & "' AND coalesce(Ecodigo,#session.Ecodigo#)=#session.Ecodigo#");

								
				If (rsQRY.cantidad EQ 0)
				{
					sbExecute (	"insert into PCDCatalogo ( " &
								"   PCEcatid, PCEcatidref, " &
								"   Ecodigo, PCDactivo, " &
								"   PCDvalor, PCDdescripcion, " &
								"   Usucodigo, Ulocalizacion) " &
								" values( " &
									LvarPCEcatid & "," & LvarPCEcatidref & "," &
									#LvarEcodigo# & "," & "1," &
									"'" & LvarVal & "','" & rsImportador.PCDdescripcion & "'," &
									"#session.usucodigo#, '00')"
								);
				}
				else
				{
					sbExecute (	"update PCDCatalogo " &
				   "   set PCEcatid=" & LvarPCEcatid &
				   "   ,PCEcatidref=" & LvarPCEcatidref &
				   "   ,PCDactivo=" & rsImportador.PCDactivo &
				   "   ,PCDvalor='" & LvarVal &
				   "'   ,PCDdescripcion='" & rsImportador.PCDdescripcion & "'
					 where PCEcatid=" & LvarPCEcatid & 
					 	"  AND PCDvalor='" & LvarVal & 
						"' AND coalesce(Ecodigo,#session.Ecodigo#)=#session.Ecodigo#"
				   );
				}
				</cfscript>
		</cfloop>
	</cfif>

	<cfset ERR = fnVerificaErrores()>
</cftransaction>

<cffunction name="fnCatalogo" returntype="string" access="private">
	<cfargument name="LprmCat" type="string" required="yes">
	
	<cfset LprmCat = trim(LprmCat)>
	<cfif LprmCat EQ "">
		<cfreturn "null">
	<cfelseif isNumeric(LprmCat) AND isdefined("GvarPrefijo")>
		<cfset LprmCat = val(LprmCat)>
		<cfif len(LprmCat) GT 5>
			<cfset sbError ("ERROR", "El código de Catálogo '#LprmCat#' tiene más de 5 digitos")>
			<cfreturn "">
		</cfif>
	    <cfreturn "'" & GvarPrefijo & right("00000" & LprmCat, 5) & "'">
	<cfelse>
		<cfreturn "'" & LprmCat & "'">
	</cfif>
</cffunction>
