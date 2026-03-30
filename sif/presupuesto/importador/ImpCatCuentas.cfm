<cfinclude template="FnScripts.cfm">

<cfquery  name="rsImportador" datasource="#session.dsn#">
  select * from #table_name# 
  order by id
</cfquery>

<cftransaction>
<!---    Validación del Archivo    --->
	<cfloop query="rsImportador">
    	<cfscript>
		/*---------------------------------------------------------------------------------------*/
		/*validacion del código de cuenta PCEcodigo*/
		/*---------------------------------------------------------------------------------------*/
		if (trim(rsImportador.PCEcodigo) EQ "")
        {
            sbError ("ERROR", "El valor del código de cuenta viene en blanco");
            LvarError = true;
        }
		/*---------------------------------------------------------------------------------------*/
		/*validacion de que se haya definido valores validos para la columna PCDactivo*/
		/*---------------------------------------------------------------------------------------*/
		if(rsImportador.PCDactivo neq "1" and rsImportador.PCDactivo neq "0")
		{
			sbError ("ERROR", "El archivo importado  en la linea  "& rsImportador.currentRow &" contiene el valor '#rsImportador.PCDactivo#' en la columna PCDactivo y solo se permiten 0 y 1");
			LvarError = true;
		}
		/*------------------------------------------------------------*/
		/*validacion de que PCEdescripcion no este en blanco*/
		/*------------------------------------------------------------*/
		if (trim(rsImportador.PCEdescripcion) EQ "")
		{
			sbError ("ERROR", "El archivo importado en la linea " & rsImportador.currentRow &"  para la columna PCEdescripcion tiene valores vacios");
			LvarError = true;		
		}
		/*------------------------------------------------------------*/
		/*validacion de que PCDdescripcion no este en blanco*/
		/*------------------------------------------------------------*/
		if (trim(rsImportador.PCDdescripcion) EQ "")
		{
			sbError ("ERROR", "El archivo importado en la linea " & rsImportador.currentRow &"  para la columna PCDdescripcion tiene valores vacios");
			LvarError = true;		
		}
		/*------------------------------------------------------------*/
		/*validacion de que el PCDvalor no este en blanco*/
		/*------------------------------------------------------------*/
		if (trim(rsImportador.PCDvalor)EQ "")
		{
			sbError ("ERROR", "El archivo importado en la linea " & rsImportador.currentRow &"  para la columna PCDvalor tiene valores vacios");
			LvarError = true;		
		}
		/*------------------------------------------------------------*/
		/*validacion de longitud*/
		/*------------------------------------------------------------*/
		If (rsImportador.PCElongitud EQ "" OR rsImportador.PCElongitud EQ "0" OR Not IsNumeric(rsImportador.PCElongitud))
		{
			sbError ("ERROR", "No indico la longitud del catálogo '#rsImportador.PCElongitud#' en la linea " & rsImportador.currentRow );
			LvarErr = true;
			continue;
		}
		/*---------------------------------------------------------------------------------------*/
		/*validacion de que se haya definido valores validos para la columna PCEactivo*/
		/*---------------------------------------------------------------------------------------*/
		if(rsImportador.PCEactivo neq "1" and rsImportador.PCEactivo neq "0")
		{
			sbError ("ERROR", "El archivo importado  en la linea  "& rsImportador.currentRow &" contiene el valor '#rsImportador.PCEactivo#' en la columna PCEactivo y solo se permiten 0 y 1");
			LvarError = true;
		}
		/*---------------------------------------------------------------------------------------*/
		/*validacion de que se haya definido valores validos para la columna PCEoficina*/
		/*---------------------------------------------------------------------------------------*/
		if(rsImportador.PCEoficina neq "1" and rsImportador.PCEoficina neq "0")
		{
			sbError ("ERROR", "El archivo importado  en la linea  "& rsImportador.currentRow &" contiene el valor '#rsImportador.PCEoficina#' en la columna PCEoficina y solo se permiten 0 y 1");
			LvarError = true;
		}
		/*---------------------------------------------------------------------------------------*/
		/*validacion de que se haya definido valores validos para la columna PCErefernciarMayor*/
		/*---------------------------------------------------------------------------------------*/
		if(rsImportador.PCEreferenciarMayor neq "1" and rsImportador.PCEreferenciarMayor neq "0")
		{
			sbError ("ERROR", "El archivo importado  en la linea  "& rsImportador.currentRow &" contiene el valor '#rsImportador.PCEreferenciarMayor#' en la columna PCEreferenciarMayor y solo se permiten 0 y 1");
			LvarError = true;
		}
		/*---------------------------------------------------------------------------------------*/
		/*validacion de que se haya definido valores validos para la columna PCEvaloresxmayor*/
		/*---------------------------------------------------------------------------------------*/
		if(rsImportador.PCEvaloresxmayor neq "1" and rsImportador.PCEvaloresxmayor neq "0")
		{
			sbError ("ERROR", "El archivo importado  en la linea  "& rsImportador.currentRow &" contiene el valor '#rsImportador.PCEvaloresxmayor#' en la columna PCEvaloresxmayor y solo se permiten 0 y 1");
			LvarError = true;
		}
		/*---------------------------------------------------------------------------------------*/
		/*validacion de que se haya definido valores validos para la columna PCEempresa*/
		/*---------------------------------------------------------------------------------------*/
		if(rsImportador.PCEempresa neq "1" and rsImportador.PCEempresa neq "0")
		{
			sbError ("ERROR", "El archivo importado  en la linea  "& rsImportador.currentRow &" contiene el valor '#rsImportador.PCEempresa#' en la columna PCEempresa y solo se permiten 0 y 1");
			LvarError = true;
		}
		/*---------------------------------------------------------------------------------------*/
		/*validacion de que se haya definido valores validos para la columna PCEref*/
		/*---------------------------------------------------------------------------------------*/
		if(rsImportador.PCEref neq "1" and rsImportador.PCEref neq "0")
		{
			sbError ("ERROR", "El archivo importado  en la linea  "& rsImportador.currentRow &" contiene el valor '#rsImportador.PCEref#' en la columna PCEref y solo se permiten 0 y 1");
			LvarError = true;
		}
		/*---------------------------------------------------------------------------------------*/
		/*validacion de que se haya definido valores validos para la columna PCEreferenciar*/
		/*---------------------------------------------------------------------------------------*/
		if(rsImportador.PCEreferenciar neq "1" and rsImportador.PCEreferenciar neq "0")
		{
			sbError ("ERROR", "El archivo importado  en la linea  "& rsImportador.currentRow &" contiene el valor '#rsImportador.PCEreferenciar#' en la columna PCEreferenciar y solo se permiten 0 y 1");
			LvarError = true;
		}
		
		</cfscript>
	</cfloop>
<!---    Importación del Archivo    --->
	<cfif NOT isdefined("LvarError")>
		<cfset LvarAnterior = "">
        
		<cfset LvarAnteriorErr = false>
        
		<cfloop query="rsImportador">
			<cfscript>
			
				LvarActual = #rsImportador.PCEcodigo#;
				
				if (LvarAnterior NEQ LvarActual)
				{
					LvarAnterior = LvarActual;
					LvarAnteriorErr = false;
					
					if (isdefined("rsImportador.PCEempresa") AND rsImportador.PCEempresa EQ "0")
					{
						LvarPCEempresa	= "0";
						LvarEcodigo		= "null";
						rsQRY = fnQuery ("select count(1) as cantidad from PCECatalogo e inner join PCDCatalogo d on d.PCEcatid=e.PCEcatid where e.CEcodigo=#session.CEcodigo# and e.PCEcodigo='" & LvarActual & "' AND d.Ecodigo IS NOT NULL");
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
						rsQRY = fnQuery ("select count(1) as cantidad from PCECatalogo e inner join PCDCatalogo d on d.PCEcatid=e.PCEcatid where e.CEcodigo=#session.CEcodigo# and e.PCEcodigo='" & LvarActual & "' AND d.Ecodigo IS NULL");
						If (rsQRY.cantidad GT 0)
						{
							sbError ("ERROR", "Catálogo '#LvarActual#' se está definiendo con Valores por Empresa, pero ya existen Valores Corporativos");
							LvarAnteriorErr = true;
							continue;
						}
					}
					
					LvarPCDcatReferenciar = rsImportador.PCEreferenciar;
					If (LvarPCDcatReferenciar EQ "")
					{
						LvarAnteriorErr = true;
						continue;
					}
					LvarchkPCDcatRef = rsImportador.PCEcatidref;
					If (LvarPCDcatReferenciar EQ "1")
					{
						if (LvarchkPCDcatRef EQ "")
							sbError ("ERROR", "Se especificó el catalogo '#LvarActual#' como catálogo Padre pero no se especifico el Catálogo de Referencia");
							LvarPadre = 1;
					}
					Else
					{
						if (LvarchkPCDcatRef NEQ "")
							sbError ("ERROR", "No se especificó el catalogo '#LvarActual#' como catálogo Padre pero se especifico un Catálogo de Referencia");
							LvarPadre = 0;
					}
					
					LvarLon = rsImportador.PCElongitud;
					
					rsQRY = fnQuery("select count(1) as cantidad from PCECatalogo where CEcodigo=#session.CEcodigo# and PCEcodigo='#LvarActual#'");
					If (rsQRY.cantidad EQ 0)
						sbExecute ("insert into PCECatalogo ( " &
								   "   CEcodigo, PCEcodigo, PCEdescripcion, " &
								   "   PCElongitud, PCEempresa, PCEref, PCEreferenciar, PCEactivo, Usucodigo, Ulocalizacion,PCEoficina," &
								   "   PCEreferenciarMayor,PCEvaloresxmayor) " &
								   " values( " &
								   "   #session.CEcodigo#, '" & LvarActual & "','" & rsImportador.PCEdescripcion & "'," &
									   LvarLon & ", #LvarPCEempresa#, 0, " & LvarPadre & ", 1 , #session.usucodigo#, '00','" &
								       rsImportador.PCEoficina & "','" & rsImportador.PCEreferenciarMayor & "','" &rsImportador.PCEvaloresxmayor &                                   "')"
								   );
					Else
						sbExecute ("update PCECatalogo " &
								   "   set PCEdescripcion	= '" & rsImportador.PCEdescripcion & "', " &
								   "       PCEactivo		=1," &
								   "       PCElongitud		=" & LvarLon & "," &
								   "       PCEempresa		=" & LvarPCEempresa & "," &
								   "       PCEreferenciar	=" & LvarPadre & "," &
								   "       PCEoficina	    = '" & rsImportador.PCEoficina & "', " &
								   "       PCEreferenciarMayor = '" & rsImportador.PCEreferenciarMayor & "', " &
								   "       PCEvaloresxmayor = '" & rsImportador.PCEvaloresxmayor & "'" &
								   " where CEcodigo=#session.CEcodigo# and PCEcodigo='" & LvarActual & "'"
								   );
	
					rsQRY = fnQuery ("select PCEcatid from PCECatalogo where CEcodigo=#session.CEcodigo# and PCEcodigo='" & LvarActual& "'");
					LvarPCEcatid = rsQRY.PCEcatid;
				}
				else If (LvarAnteriorErr)
					continue;

				LvarPCDcatRef = fnCatalogo(rsImportador.PCEcatidref);
				If (LvarPCDcatRef EQ "")
					continue;
					

				If (LvarPCDcatRef EQ "null" OR LvarPCDcatRef EQ "")
					LvarPCEcatidref = "null";
				else
				{
					rsQRY = fnQuery("select count(1) as cantidad from PCECatalogo where CEcodigo=#session.CEcodigo# and PCEcodigo=" & LvarPCDcatRef);
					If (rsQRY.cantidad EQ 0)
					{
						sbExecute (	"insert into PCECatalogo ( " &
									"   CEcodigo, PCEcodigo, PCEdescripcion, " &
									"   PCElongitud, PCEempresa, PCEref, PCEreferenciar, PCEactivo, " &
									"   Usucodigo, Ulocalizacion,PCEoficina,PCEreferenciarMayor,PCEvaloresxmayor) " &
									" values( " &
									"   #session.CEcodigo#, " & LvarPCDcatRef & ",'Catalogo por definir'," &
										0 & ", #LvarPCEempresa#, 1, 0, 0, #session.usucodigo#, '00','" &
								       rsImportador.PCEoficina & "','" & rsImportador.PCEreferenciarMayor & "','" &rsImportador.PCEvaloresxmayor &                                   "')"
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
								"   Usucodigo, Ulocalizacion,PCDdescripcionA) " &
								" values( " &
									LvarPCEcatid & "," & LvarPCEcatidref & "," &
									#LvarEcodigo# & "," & "1," &
									"'" & LvarVal & "','" & rsImportador.PCDdescripcion & "'," &
									"#session.usucodigo#, '00','" & rsImportador.PCDdescripcionA & "')"
								);
				}
				else
				{
					sbExecute (	"update PCDCatalogo " &
				   "   set PCEcatid=" & LvarPCEcatid &
				   "   ,PCEcatidref=" & LvarPCEcatidref &
				   "   ,PCDactivo=" & rsImportador.PCDactivo &
				   "   ,PCDvalor='" & LvarVal &
				   "'   ,PCDdescripcion='" & rsImportador.PCDdescripcion &
				   "'   ,PCDdescripcionA='" & rsImportador.PCDdescripcionA & "'" &
				   " where PCEcatid=" & LvarPCEcatid & 
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
	<cfelse>
		<cfreturn "'" & LprmCat & "'">
	</cfif>
</cffunction>
