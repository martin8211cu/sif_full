<cfcomponent>
	<cffunction name="fnMontoEnLetras" output="false" returntype="string" access="public">
		<cfargument name="Monto" 	type="numeric" required="yes">
		<cfargument name="Ingles" 	type="numeric" required="no" default="0">
		<cfargument name="Idioma" 	type="string" required="no" default="#session.Idioma#">
			<!--- 
					Ingles = 
						0 Español
						1 USA
						2 Inglaterra
			--->
			
		<cfset var LvarGrupoEnLetras = "">
		<cfset var LvarGrupoAnterior = "">
		<cfset var LvarMonto		= numberFormat(abs(Arguments.Monto),",0.00")>
		<cfset var LvarDecimales	= mid(LvarMonto,find(".",LvarMonto)+1,2)>
		<cfset var LvarGrupos		= arrayNew(1)>
		<cfset var LvarGruposN		= 0>
		<cfset var LvarEnLetras = "">
		<cfset LvarLetras		= arrayNew(2)>
		<cfif findnocase('en',arguments.idioma) gt 0>
			<cfset arguments.Ingles = 1 >
		</cfif>

		<cfset LvarMonto 	= mid(LvarMonto,1,find(".",LvarMonto)-1)>
		<cfset LvarGrupos	= listToArray(LvarMonto)>
		<cfset LvarGruposN	= arrayLen(LvarGrupos)>
		<cfif abs(Arguments.Monto) LT 1>
			<cfif Arguments.Ingles EQ 0>
				<cfset LvarEnLetras = "Cero">
			<cfelse>
				<cfset LvarEnLetras = "Zero">
			</cfif>
		<cfelse>
			<cfset sbCargarLetras(Arguments.Ingles)>
			<cfloop index="LvarGrupoI" from="1" to="#LvarGruposN#">
				<cfset LvarGrupoJ 	= LvarGruposN-LvarGrupoI+1>
				<cfset LvarMiles 	= (LvarGrupoI mod 2 EQ 0)>
				<cfset LvarGrupoEnLetras = fnProcesaGrupo (LvarGrupos[LvarGrupoJ], Arguments.Ingles)>
				<cfif LvarGrupoJ EQ 1>
					<cfset LvarGrupoAnterior = "">
				<cfelseif LvarGrupos[LvarGrupoJ - 1] EQ "000">
					<cfset LvarGrupoAnterior = "">
				<cfelse>
					<cfset LvarGrupoAnterior = "1">
				</cfif>
				<cfif Arguments.Ingles EQ 0>
					<cfif LvarMiles and LvarGrupoEnLetras NEQ "" and LvarGrupoEnLetras NEQ "mil">
						<cfset LvarGrupoEnLetras = LvarGrupoEnLetras & "mil">
					<cfelseif LvarGrupoEnLetras NEQ "" Or LvarGrupoAnterior NEQ "">
						<cfif LvarGrupos[LvarGrupoJ] EQ "001" And LvarGrupoAnterior EQ "">
							<cfset LvarPlural = "ón">
						<cfelse>
							<cfset LvarPlural = "ones">
						</cfif>
						<cfif LvarGrupoI EQ 3>
							<cfset LvarGrupoEnLetras = LvarGrupoEnLetras & "mill#LvarPlural#">
						<cfelseif LvarGrupoI EQ 5>
							<cfset LvarGrupoEnLetras = LvarGrupoEnLetras & "bill#LvarPlural#">
						<cfelseif LvarGrupoI EQ 7>
							<cfset LvarGrupoEnLetras = LvarGrupoEnLetras & "trill#LvarPlural#">
						<cfelseif LvarGrupoI EQ 9>
							<cfset LvarGrupoEnLetras = LvarGrupoEnLetras & "cuatrill#LvarPlural#">
						</cfif>
					</cfif>
				<cfelseif Arguments.Ingles EQ 1>
					<cfif LvarGrupoEnLetras NEQ "">
						<cfif LvarGrupos[LvarGrupoJ] EQ "001">
							<cfset LvarPlural = "">
						<cfelse>
							<cfset LvarPlural = "s">
						</cfif>
						<cfif LvarGrupoI EQ 2>
							<cfset LvarGrupoEnLetras = LvarGrupoEnLetras & "thousand">
						<cfelseif LvarGrupoI EQ 3>
							<cfset LvarGrupoEnLetras = LvarGrupoEnLetras & "million#LvarPlural#">
						<cfelseif LvarGrupoI EQ 4>
							<cfset LvarGrupoEnLetras = LvarGrupoEnLetras & "billion#LvarPlural#">
						<cfelseif LvarGrupoI EQ 5>
							<cfset LvarGrupoEnLetras = LvarGrupoEnLetras & "trillion#LvarPlural#">
						<cfelseif LvarGrupoI EQ 6>
							<cfset LvarGrupoEnLetras = LvarGrupoEnLetras & "quadrillion#LvarPlural#">
						<cfelseif LvarGrupoI EQ 7>
							<cfset LvarGrupoEnLetras = LvarGrupoEnLetras & "quintillion#LvarPlural#">
						<cfelseif LvarGrupoI EQ 8>
							<cfset LvarGrupoEnLetras = LvarGrupoEnLetras & "sextillion#LvarPlural#">
						<cfelseif LvarGrupoI EQ 9>
							<cfset LvarGrupoEnLetras = LvarGrupoEnLetras & "septillion#LvarPlural#">
						</cfif>
					</cfif>
				<cfelse>
					<cfif LvarGrupos[LvarGrupoJ] EQ "001" And (LvarGrupoAnterior EQ "" OR LvarMiles)>
						<cfset LvarPlural = "">
					<cfelse>
						<cfset LvarPlural = "s">
					</cfif>
					<cfif LvarMiles and LvarGrupoEnLetras NEQ "">
						<cfset LvarGrupoEnLetras = LvarGrupoEnLetras & "thousand#LvarPlural#">
					<cfelseif LvarGrupoEnLetras NEQ "" Or LvarGrupoAnterior NEQ "">
						<cfif LvarGrupoI EQ 3>
							<cfset LvarGrupoEnLetras = LvarGrupoEnLetras & "million#LvarPlural#">
						<cfelseif LvarGrupoI EQ 5>
							<cfset LvarGrupoEnLetras = LvarGrupoEnLetras & "billion#LvarPlural#">
						<cfelseif LvarGrupoI EQ 7>
							<cfset LvarGrupoEnLetras = LvarGrupoEnLetras & "trillion#LvarPlural#">
						<cfelseif LvarGrupoI EQ 9>
							<cfset LvarGrupoEnLetras = LvarGrupoEnLetras & "quadrillion#LvarPlural#">
						</cfif>
					</cfif>
				</cfif>
				<cfset LvarEnLetras = LvarGrupoEnLetras & " " & trim(LvarEnLetras)>
			</cfloop>
		</cfif>

		<cfif Arguments.Ingles EQ 0>
			<cfset LvarEnLetras = "#trim(LvarEnLetras)# con #LvarDecimales#/100">
		<cfelse>
			<cfset LvarEnLetras = "#trim(LvarEnLetras)# and #LvarDecimales#/100">
		</cfif>

		<cfset LvarEnLetras = ucase(mid(LvarEnLetras,1,1)) & mid(LvarEnLetras,2,len(LvarEnLetras))>
		<cfreturn LvarEnLetras>
	</cffunction>
		
	<cffunction name="fnProcesaGrupo" output="false" returntype="string" access="private">
		<cfargument name="Grupo" type="string" 	required="yes">
		<cfargument name="Ingles" type="boolean" required="yes">
		
		<cfset var LvarGrupoEnLetras = "">

		<cfset Arguments.Grupo = right("000" & Arguments.Grupo,3)>
		<cfif Arguments.Grupo EQ "000">
			<cfreturn "">
		<cfelseif Arguments.Grupo EQ "001" and Arguments.Ingles EQ 0>
			<cfif LvarMiles>
				<cfreturn "mil">   <!--- Eliminar si se quiere '... un mil' --->
			</cfif>
		<cfelseif Arguments.Grupo EQ "100" and Arguments.Ingles EQ 0>
			<cfreturn "cien ">
		</cfif>
		<cfscript>
			LvarGrupoEnLetras = "";
			LvarIndex1 = val(mid(Arguments.Grupo,1,1));
			if (LvarIndex1 GT 0)
			{
				LvarGrupoEnLetras = trim(LvarLetras[1][LvarIndex1]) & " ";
			}

			LvarIndex1  = val(mid(Arguments.Grupo,2,2));
			LvarIndex2 = val(mid(Arguments.Grupo,2,1));
			LvarIndex3 = val(mid(Arguments.Grupo,3,1));
			if (LvarIndex1 GT 0 AND LvarIndex1 LT 30 and Arguments.Ingles EQ 0)
			{
				LvarGrupoEnLetras = LvarGrupoEnLetras & LvarLetras[3][LvarIndex1];
			}
			else if (LvarIndex1 GT 0 AND LvarIndex1 LT 20 and Arguments.Ingles NEQ 0)
			{
				LvarGrupoEnLetras = LvarGrupoEnLetras & LvarLetras[3][LvarIndex1];
			}
			else
			{
				if (LvarIndex2 GT 0)
				{
					LvarGrupoEnLetras = LvarGrupoEnLetras & LvarLetras[2][LvarIndex2];
				}
				if (LvarIndex3 GT 0)
				{
					if (LvarIndex2 GT 0)
					{
						if (Arguments.Ingles EQ 0)
							LvarGrupoEnLetras = trim(LvarGrupoEnLetras) & " y ";
						else
							LvarGrupoEnLetras = trim(LvarGrupoEnLetras) & " ";
					}
					LvarGrupoEnLetras = LvarGrupoEnLetras & LvarLetras[3][LvarIndex3];
				}
			}

			// Convierte el valor '1' en las unidades de 'un' a 'uno' (excepto en '11')
			if (LvarGrupoI EQ 1 and LvarIndex3 EQ 1 and LvarIndex1 NEQ 11 and Arguments.Ingles EQ 0)
			{
				LvarGrupoEnLetras = LvarGrupoEnLetras & "o";
			}

			LvarGrupoEnLetras = trim(LvarGrupoEnLetras) & " ";
		</cfscript>
		<cfreturn LvarGrupoEnLetras>
	</cffunction>

	<cffunction name="sbCargarLetras" output="false" access="private">
		<cfargument name="Ingles" type="boolean" required="yes">

		<cfif Arguments.Ingles EQ 0>
			<cfscript>
				LvarLetras[1][1] = "ciento";
				LvarLetras[1][2] = "doscientos";
				LvarLetras[1][3] = "trescientos";
				LvarLetras[1][4] = "cuatrocientos";
				LvarLetras[1][5] = "quinientos";
				LvarLetras[1][6] = "seiscientos";
				LvarLetras[1][7] = "setecientos";
				LvarLetras[1][8] = "ochocientos";
				LvarLetras[1][9] = "novecientos";
	
				LvarLetras[2][1] = "diez";
				LvarLetras[2][2] = "veinte";
				LvarLetras[2][3] = "treinta";
				LvarLetras[2][4] = "cuarenta";
				LvarLetras[2][5] = "cincuenta";
				LvarLetras[2][6] = "sesenta";
				LvarLetras[2][7] = "setenta";
				LvarLetras[2][8] = "ochenta";
				LvarLetras[2][9] = "noventa";
				
				LvarLetras[3][1] = "un";
				LvarLetras[3][2] = "dos";
				LvarLetras[3][3] = "tres";
				LvarLetras[3][4] = "cuatro";
				LvarLetras[3][5] = "cinco";
				LvarLetras[3][6] = "seis";
				LvarLetras[3][7] = "siete";
				LvarLetras[3][8] = "ocho";
				LvarLetras[3][9] = "nueve";
				LvarLetras[3][10] = "diez";
				LvarLetras[3][11] = "once";
				LvarLetras[3][12] = "doce";
				LvarLetras[3][13] = "trece";
				LvarLetras[3][14] = "catorce";
				LvarLetras[3][15] = "quince";
				LvarLetras[3][16] = "dieciseis";
				LvarLetras[3][17] = "diecisiete";
				LvarLetras[3][18] = "dieciocho";
				LvarLetras[3][19] = "diecinueve";
				LvarLetras[3][20] = "veinte";
				LvarLetras[3][21] = "veintiun";
				LvarLetras[3][22] = "veintidos";
				LvarLetras[3][23] = "veintitres";
				LvarLetras[3][24] = "veinticuatro";
				LvarLetras[3][25] = "veinticinco";
				LvarLetras[3][26] = "veintiseis";
				LvarLetras[3][27] = "veintisiete";
				LvarLetras[3][28] = "veintiocho";
				LvarLetras[3][29] = "veintinueve";
			</cfscript>
		<cfelse>
			<cfscript>
				LvarLetras[1][1] = "one hundred";
				LvarLetras[1][2] = "two hundred";
				LvarLetras[1][3] = "three hundred";
				LvarLetras[1][4] = "four hundred";
				LvarLetras[1][5] = "five hundred";
				LvarLetras[1][6] = "six hundred";
				LvarLetras[1][7] = "seven hundred";
				LvarLetras[1][8] = "eight hundred";
				LvarLetras[1][9] = "nine hundred";
	
				LvarLetras[2][1] = "ten";
				LvarLetras[2][2] = "twenty";
				LvarLetras[2][3] = "thirty";
				LvarLetras[2][4] = "forty";
				LvarLetras[2][5] = "fifty";
				LvarLetras[2][6] = "sixty";
				LvarLetras[2][7] = "seventy";
				LvarLetras[2][8] = "eighty";
				LvarLetras[2][9] = "ninety";
				
				LvarLetras[3][1] = "one";
				LvarLetras[3][2] = "two";
				LvarLetras[3][3] = "three";
				LvarLetras[3][4] = "four";
				LvarLetras[3][5] = "five";
				LvarLetras[3][6] = "six";
				LvarLetras[3][7] = "seven";
				LvarLetras[3][8] = "eight";
				LvarLetras[3][9] = "nine";
				LvarLetras[3][10] = "ten";
				LvarLetras[3][11] = "eleven";
				LvarLetras[3][12] = "twelve";
				LvarLetras[3][13] = "thirteen";
				LvarLetras[3][14] = "fourteen";
				LvarLetras[3][15] = "fifteen";
				LvarLetras[3][16] = "sixteen";
				LvarLetras[3][17] = "seventeen";
				LvarLetras[3][18] = "eighteen";
				LvarLetras[3][19] = "nineteen";
				LvarLetras[3][20] = "twenty";
			</cfscript>
		</cfif>
	</cffunction>
</cfcomponent>
