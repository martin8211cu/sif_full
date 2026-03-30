<cfinclude template="FnScripts.cfm">

<cfquery  name="rsImportador" datasource="#session.dsn#">
  select * from #table_name# 
  order by id
</cfquery>

<cftransaction>
	<cfif trim(rsImportador.PCEMdesc) EQ "">
		<cfset sbError ("FATAL", "El primer valor del archivo viene en blanco")>
	<cfelse>
		<cfset LvarAnterior = "">
		<cfloop query="rsImportador">
			<cfscript>
				LvarActual = trim(rsImportador.PCEMdesc);
					
				if (LvarActual NEQ "" AND LvarAnterior NEQ LvarActual)
				{
					if (LvarAnterior NEQ "" and LvarNivel GT 0)
					{
						sbFormatos (LvarPCEMidAnt);
					}
					
					LvarAnterior = LvarActual;
					
					rsQRY = fnQuery("select count(1) as cantidad from PCEMascaras where CEcodigo=#session.CEcodigo# and PCEMdesc='#LvarActual#'");
					If (rsQRY.cantidad EQ 0)
					{
						LvarNivel = 1;

						sbExecute ("
										insert into PCEMascaras (
											CEcodigo, PCEMdesc, 
											PCEMformato, PCEMformatoC, PCEMformatoP, 
											Usucodigo, Ulocalizacion
											)
										values (
											#session.CEcodigo#, '#LvarActual#',
											' ',' ',' ',
											#session.usucodigo#, '00'
											)
								   ");

						rsQRY = fnQuery ("select PCEMid from PCEMascaras where CEcodigo=#session.CEcodigo# and PCEMdesc='#LvarActual#'");
						LvarPCEMid = rsQRY.PCEMid;
						LvarPCEMidAnt = rsQRY.PCEMid;
					}
					Else
					{
						LvarNivel = -1;
						sbError ("INFO", "La Mascara '#LvarActual#' ya existe por lo que no se incluyó");
					}
				}

				if (LvarNivel GT 0)
				{
					if (rsImportador.PCNid NEQ LvarNivel)
					{
						sbError ("INFO", "Orden de los niveles incorrecto en Mascara '#LvarActual#' nivel '#rsImportador.PCNid#'");
					}
					else if (rsImportador.PCNcontabilidad NEQ "1" AND rsImportador.PCNpresupuesto NEQ "1")
					{
						sbError ("FATAL", "Es Obligatorio indicar por lo menos UNO de los siguientes datos: Nivel es de para Contabilidad, Nivel para Presupuesto. Mascara '#LvarActual#' nivel '#rsImportador.PCNid#'");
						LvarNivel = -1;
						continue;
					}
					else if (rsImportador.PCEcodigo NEQ "")
					{
						rsQRY = fnQuery("select PCEcatid, PCElongitud from PCECatalogo where CEcodigo=#session.CEcodigo# and PCEcodigo='#rsImportador.PCEcodigo#'");
						if (rsQRY.PCEcatid EQ "")
						{
							sbError ("FATAL", "No existe Catálogo '#rsImportador.PCEcodigo#' utilizado en Mascara '#LvarActual#' nivel '#rsImportador.PCNid#'");
							LvarNivel = -1;
							continue;
						}
						LvarPCEcatid = rsQRY.PCEcatid;
						LvarLongitud = rsQRY.PCElongitud;
						LvarPCNdep   = "null";
					}
					else 
					{
						if (rsImportador.PCNdep EQ "")
						{
							sbError ("FATAL", "Es Obligatorio indicar uno de los siguientes datos: Codigo de Catálogo o Nivel Padre. Mascara '#LvarActual#' nivel '#rsImportador.PCNid#'");
							LvarNivel = -1;
							continue;
						}
						else if (rsImportador.PCNdep GTE LvarNivel)
						{
							sbError ("FATAL", "El Nivel Padre debe ser menor al Nivel actual. Mascara '#LvarActual#' nivel '#rsImportador.PCNid#'");
							LvarNivel = -1;
							continue;
						}
						else if (rsImportador.PCNlongitud EQ "")
						{
							sbError ("FATAL", "Es Obligatorio indicar la Longitud del Nivel si se indica Nivel Padre. Mascara '#LvarActual#' nivel '#rsImportador.PCNid#'");
							LvarNivel = -1;
							continue;
						}
						else
						{
							LvarLongitud = rsImportador.PCNlongitud;
							LvarPCEcatid = "null";
							LvarPCNdep   = rsImportador.PCNdep;

							rsQRY = fnQuery("
												select PCNid, PCNcontabilidad, PCNpresupuesto 
												  from PCNivelMascara 
												 where PCEMid=#LvarPCEMid# 
												   and PCNid=#LvarPCNdep#
											");
							if (rsQRY.PCNid EQ "")
							{
								sbError ("FATAL", "No existe el Nivel Padre '#LvarPCNdep#' y esta siendo referenciado. Mascara '#LvarActual#' nivel '#rsImportador.PCNid#'");
								LvarNivel = -1;
								continue;
							}
							else if (rsImportador.PCNcontabilidad EQ "1" AND rsQRY.PCNcontabilidad NEQ "1")
							{
								sbError ("FATAL", "El Nivel Padre '#LvarPCNdep#' no es para Contabilidad y esta siendo referenciado por un nivel de Contabilidad. Mascara '#LvarActual#' nivel '#rsImportador.PCNid#'");
								LvarNivel = -1;
								continue;
							}
							else if (rsImportador.PCNpresupuesto EQ "1" AND rsQRY.PCNpresupuesto NEQ "1")
							{
								sbError ("FATAL", "El Nivel Padre '#LvarPCNdep#' no es para Presupuesto y esta siendo referenciado por un nivel de Presupuesto. Mascara '#LvarActual#' nivel '#rsImportador.PCNid#'");
								LvarNivel = -1;
								continue;
							}
						}
					}
					
					if (rsImportador.PCNcontabilidad EQ "")
						rsImportador.PCNcontabilidad = "0";
					if (rsImportador.PCNpresupuesto EQ "")
						rsImportador.PCNpresupuesto = "0";
						
					sbExecute (	
								"insert into PCNivelMascara (
								   PCEMid, PCNid,
								   PCNlongitud, 
								   PCEcatid, PCNdep,
								   PCNcontabilidad, PCNpresupuesto,
								   Usucodigo, Ulocalizacion)
								 values( 
									#LvarPCEMid#, #rsImportador.PCNid#,
									#LvarLongitud#,
									#LvarPCEcatid#, #LvarPCNdep#, 
									#rsImportador.PCNcontabilidad#, #rsImportador.PCNpresupuesto#,
									#session.usucodigo#, '00')"
								);
					LvarNivel = LvarNivel + 1;
				}
			</cfscript>
		</cfloop>
		<cfif LvarAnterior NEQ "" and LvarNivel GT 0>
			<cfset sbFormatos (LvarPCEMidAnt)>
		</cfif>
	</cfif>

	<cfset ERR = fnVerificaErrores()>
</cftransaction>

<cffunction name="sbFormatos" returntype="string" access="private">
	<cfargument name="LprmPCEMid" type="numeric" required="yes">
	
	<cfquery name="rsQRY" datasource="#session.dsn#">
		select PCNlongitud, PCNcontabilidad, PCNpresupuesto 
		  from PCNivelMascara 
		 where PCEMid=#LprmPCEMid#
	</cfquery>

	<cfset LvarFormato  = "XXXX">
	<cfset LvarFormatoC = "XXXX">
	<cfset LvarFormatoP = "XXXX">
	<cfloop query="rsQRY">
		<cfscript>
			LvarXs = repeatString("X",rsQRY.PCNlongitud);
			LvarFormato = LvarFormato & "-" & LvarXs;
			if (rsQRY.PCNcontabilidad EQ "1")
				LvarFormatoC = LvarFormatoC & "-" & LvarXs;
			if (rsQRY.PCNpresupuesto EQ "1")
				LvarFormatoP = LvarFormatoP & "-" & LvarXs;
		</cfscript>
	</cfloop>
	<cfquery datasource="#session.dsn#">
		update PCEMascaras
		   set PCEMformato = '#LvarFormato#'
		   	 , PCEMformatoC = '#LvarFormatoC#'
		   <cfif LvarFormatoP EQ "XXXX">
		   	 , PCEMformatoP = null
		   <cfelse>
		   	 , PCEMformatoP = '#LvarFormatoP#'
		   </cfif>
		 where PCEMid=#LprmPCEMid#
	</cfquery>
</cffunction>
