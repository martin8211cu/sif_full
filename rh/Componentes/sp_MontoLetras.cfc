<cfcomponent>
	<cffunction name="MontoLetras" access="public" output="true"  returntype="any">
		<cfargument name="conexion"		type="string" 	required="no" default="#Session.DSN#">
		<cfargument name="Ecodigo" 		type="numeric" 	required="no" default="#session.Ecodigo#">
		<cfargument name="debug" 		type="boolean"  default="no">
		<cfargument name="Monto"   		type="numeric" 	required="yes">
		<cfargument name="Mcodigo"   	type="numeric" 	required="no">
		<cfargument name="Centimos"   	type="string" 	required="no" default="yes">
		<cfargument name="idioma"   	type="numeric" 	required="no" default="0">

		<!--- @Letras varchar(255) output, --->
		<cfset Letras ="">
		<cfset  centavos = "ctmos">
		<cfif arguments.idioma eq 1>
			<cfset  centavos = "ctmos">
		</cfif>
		<cfif arguments.Centimos EQ 'no'>
			<cfset  centavos = "">
		</cfif>
		<cfset  num = Fix(arguments.Monto)>
		<cfset  decimal = arguments.Monto - num >

		<cfif num Gte 1000000>
			<cfif num lt 2000000>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras = "un millón ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras = "one million ">
					</cfcase>
				</cfswitch>
			<cfelse>
				<cfset  num1 = Fix(num/1000000)>
				<cfset Letras1 = sp_MontoLetras1(num1,arguments.idioma)> 
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras = Letras & Letras1 & "millones ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras = Letras & Letras1 & "million ">
					</cfcase>
				</cfswitch>
			</cfif>	
			<cfset  num = num mod 1000000>
		</cfif>
		<cfif num Gte 1000>
			<cfset  num1 = Fix(num/1000)>
			<cfset  Letras1 = "">
			<cfset Letras1 = sp_MontoLetras1(num1,arguments.idioma)> 
			<cfif arguments.idioma eq 0>
				<cfif trim(Letras1) eq 'uno'>
					<cfif arguments.Monto gte 1000 >
						<cfset  Letras = Letras  & "mil ">
					<cfelse>
						<cfset  Letras = Letras  & "un ">					
					</cfif>
				<cfelse>
					<cfset  Letras = Letras & Letras1 & "mil ">
				</cfif>
			<cfelse>
				<cfif trim(Letras1) eq 'uno'>
					<cfset  Letras = Letras  & "one ">
				<cfelse>
					<cfset  Letras = Letras & Letras1 & "thousand ">
				</cfif>			
			</cfif>
			<cfset  num = num mod 1000>
		</cfif>
		<cfif num Gt 99.99 and  num lt 200>
			<cfif num eq 100>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras =  Letras  & "cien ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras = "one hundred ">
					</cfcase>
				</cfswitch>			
			<cfelse>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras =  Letras  & "ciento ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras = "one hundred ">
					</cfcase>
				</cfswitch>				
			</cfif>
		</cfif>
		
		<cfif num Gt 199.99 and  num lt 300>
			<cfswitch expression = "#arguments.idioma#">
				<cfcase value = "0">
					<cfset  Letras =  Letras  & "doscientos ">
				</cfcase>
				<cfcase value = "1">
					<cfset  Letras = "two hundred ">
				</cfcase>
			</cfswitch>		
		</cfif>
		<cfif num Gt 299.99 and  num lt 400>
			<cfswitch expression = "#arguments.idioma#">
				<cfcase value = "0">
					<cfset  Letras =  Letras  & "trescientos ">
				</cfcase>
				<cfcase value = "1">
					<cfset  Letras = "three hundred ">
				</cfcase>
			</cfswitch>		
		</cfif>
		<cfif num Gt 399.99 and  num lt 500>
			<cfswitch expression = "#arguments.idioma#">
				<cfcase value = "0">
					<cfset  Letras =  Letras  & "cuatrocientos ">
				</cfcase>
				<cfcase value = "1">
					<cfset  Letras = "four hundred ">
				</cfcase>
			</cfswitch>		
		</cfif>	
		<cfif num Gt 499.99 and  num lt 600>
			<cfswitch expression = "#arguments.idioma#">
				<cfcase value = "0">
					<cfset  Letras =  Letras  & "quinientos ">
				</cfcase>
				<cfcase value = "1">
					<cfset  Letras = "five hundred ">
				</cfcase>
			</cfswitch>		
		</cfif>
		<cfif num Gt 599.99 and  num lt 700>
			<cfswitch expression = "#arguments.idioma#">
				<cfcase value = "0">
					<cfset  Letras =  Letras  & "seiscientos ">
				</cfcase>
				<cfcase value = "1">
					<cfset  Letras = "six hundred ">
				</cfcase>
			</cfswitch>		
		</cfif>		
		<cfif num Gt 699.99 and  num lt 800>
			<cfswitch expression = "#arguments.idioma#">
				<cfcase value = "0">
					<cfset  Letras =  Letras  & "setecientos ">
				</cfcase>
				<cfcase value = "1">
					<cfset  Letras = "seven hundred ">
				</cfcase>
			</cfswitch>		
		</cfif>	
		<cfif num Gt 799.99 and  num lt 900>
			<cfswitch expression = "#arguments.idioma#">
				<cfcase value = "0">
					<cfset  Letras =  Letras  & "ochocientos ">
				</cfcase>
				<cfcase value = "1">
					<cfset  Letras = "eight hundred ">
				</cfcase>
			</cfswitch>		
		</cfif>
		<cfif num Gt 899.99 and  num lt 1000>
			<cfswitch expression = "#arguments.idioma#">
				<cfcase value = "0">
					<cfset  Letras =  Letras  & "novecientos ">
				</cfcase>
				<cfcase value = "1">
					<cfset  Letras = "nine hundred ">
				</cfcase>
			</cfswitch>		
		</cfif>						
		<cfset  num = num mod 100>
		<cfif num Gt 29.99 and  num lt 100>
			<cfif num Gt 29.99 and  num lt 40>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras =  Letras  & "treinta ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras = "thirty ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num Gt 39.99 and  num lt 50>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras =  Letras  & "cuarenta ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras = "forty ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num Gt 49.99 and  num lt 60>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras =  Letras  & "cincuenta ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras = "fifty ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num Gt 59.99 and  num lt 70>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras =  Letras  & "sesenta ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras = "sixty ">
					</cfcase>
				</cfswitch>		
			</cfif>		
			<cfif num Gt 69.99 and  num lt 80>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras =  Letras  & "setenta ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras = "seventy ">
					</cfcase>
				</cfswitch>		
			</cfif>		
			<cfif num Gt 79.99 and  num lt 90>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras =  Letras  & "ochenta ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras = "eighty ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num Gt 89.99 and  num lt 100>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras =  Letras  & "noventa ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras = "ninety ">
					</cfcase>
				</cfswitch>		
			</cfif>				
			<cfset  num = num mod 10>
			<cfif arguments.idioma eq 0>
				<cfif Fix(num) gt 0>
					<cfset  Letras =  Letras  & "y ">
				</cfif>
			</cfif>
		</cfif>
		<cfif num Gt 20 and  num lt 30>
			<cfswitch expression = "#arguments.idioma#">
				<cfcase value = "0">
					<cfset  Letras =  Letras  & "veinti">
				</cfcase>
				<cfcase value = "1">
					<cfset  Letras = "twenty ">
				</cfcase>
			</cfswitch>		
			<cfset  num = num mod 10>
		</cfif>
		<cfif num Gt 0.99 and  num lte 20>
			<cfif num eq 1>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras =  Letras  & "uno ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras = "one ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num eq 2>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras =  Letras  & "dos ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras = "two ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num eq 3>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras =  Letras  & "tres ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras = "three ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num eq 4>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras =  Letras  & "cuatro ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras = "four ">
					</cfcase>
				</cfswitch>		
			</cfif>		
			<cfif num eq 5>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras =  Letras  & "cinco ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras = "five ">
					</cfcase>
				</cfswitch>		
			</cfif>													
			<cfif num eq 6>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras =  Letras  & "seis ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras = "six ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num eq 7>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras =  Letras  & "siete ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras = "seven ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num eq 8>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras =  Letras  & "ocho ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras = "eight ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num eq 9>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras =  Letras  & "nueve ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras = "nine ">
					</cfcase>
				</cfswitch>		
			</cfif>		
			<cfif num eq 10>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras =  Letras  & "diez ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras = "ten ">
					</cfcase>
				</cfswitch>		
			</cfif>
			<cfif num eq 11>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras =  Letras  & "once ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras = "eleven ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num eq 12>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras =  Letras  & "doce ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras = "twelve ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num eq 13>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras =  Letras  & "trece ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras = "thirteen ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num eq 14>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras =  Letras  & "catorce ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras = "fourteen ">
					</cfcase>
				</cfswitch>		
			</cfif>		
			<cfif num eq 15>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras =  Letras  & "quince ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras = "fifteen ">
					</cfcase>
				</cfswitch>		
			</cfif>						
			<cfif num eq 16>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras =  Letras  & "dieciseis ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras = "sixteen ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num eq 17>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras =  Letras  & "diecisiete ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras = "seventeen ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num eq 18>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras =  Letras  & "dieciocho ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras = "eighteen ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num eq 19>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras =  Letras  & "diecinueve ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras = "nineteen ">
					</cfcase>
				</cfswitch>		
			</cfif>		
			<cfif num eq 20>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras =  Letras  & "veinte ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras = "twenty ">
					</cfcase>
				</cfswitch>		
			</cfif>
		</cfif>
		<cfif isdefined("arguments.Mcodigo")  and len(trim(arguments.Mcodigo))>
			<cfquery name="rsMoneda" datasource="#arguments.conexion#">
				select Mnombre 
				from Monedas
				where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigo#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			</cfquery>
			<cfset  Letras =  Letras  & rsMoneda.Mnombre>
		</cfif>
		<cfif decimal lte 0.99>
			<cfswitch expression = "#arguments.idioma#">
				<cfcase value = "0">
					<cfset  Letras =  Letras  & " con " & round(decimal*100) & "/100 " & centavos & ".">
				</cfcase>
				<cfcase value = "1">
					<cfset  Letras = " and " & round(decimal*100) & "/100 " & centavos & ".">
				</cfcase>
			</cfswitch>		
		</cfif>
		<cfreturn Letras>
	</cffunction>
	<!--- ***********************************************************************************************************************************  --->
	<cffunction name="sp_MontoLetras1" access="public" output="true"  returntype="any">
		<cfargument name="Monto1"   	type="numeric" 	required="yes">
		<cfargument name="idioma"   	type="numeric" 	required="no" default="0">	
		<cfargument name="conexion"		type="string" 	required="no" default="#Session.DSN#">
		<cfargument name="Ecodigo" 		type="numeric" 	required="no" default="#session.Ecodigo#">
		<cfargument name="debug" 		type="boolean"  default="no">
		<cfset Letras1 ="">
		<cfset  num1 = Fix(arguments.Monto1)>
		<cfset  dec = (arguments.Monto1-num) >
		<cfif num1 gte 1000>
			<cfset  num11 = Fix(num1/1000)>
			<cfset  Letras11 = "">
			<cfset Letras11 = sp_MontoLetras2(num11,arguments.idioma)> 

			<cfswitch expression = "#arguments.idioma#">
				<cfcase value = "0">
					<cfset  Letras1 =  Letras1 & Letras11 & "mil " >
				</cfcase>
				<cfcase value = "1">
					<cfset  Letras1 =  Letras1 & Letras11 & "thousand " >
				</cfcase>
			</cfswitch>		
			<cfset  num1 = num1 mod 1000>
		</cfif>
		<cfif num1 gt 99.99 and num1 lt 200>
			<cfif num1 eq 100>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras1 =  Letras1  & "cien ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras1 = "one hundred ">
					</cfcase>
				</cfswitch>	
			<cfelse>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras1 =  Letras1  & "ciento ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras1 = "one hundred ">
					</cfcase>
				</cfswitch>	
			</cfif>
		</cfif>
		<cfif num1 Gt 199.99 and  num1 lt 300>
			<cfswitch expression = "#arguments.idioma#">
				<cfcase value = "0">
					<cfset  Letras1 =  Letras1  & "doscientos ">
				</cfcase>
				<cfcase value = "1">
					<cfset  Letras1 = "two hundred ">
				</cfcase>
			</cfswitch>		
		</cfif>
		<cfif num1 Gt 299.99 and  num1 lt 400>
			<cfswitch expression = "#arguments.idioma#">
				<cfcase value = "0">
					<cfset  Letras1 =  Letras1  & "trescientos ">
				</cfcase>
				<cfcase value = "1">
					<cfset  Letras1 = "three hundred ">
				</cfcase>
			</cfswitch>		
		</cfif>
		<cfif num1 Gt 399.99 and  num1 lt 500>
			<cfswitch expression = "#arguments.idioma#">
				<cfcase value = "0">
					<cfset  Letras1 =  Letras1  & "cuatrocientos ">
				</cfcase>
				<cfcase value = "1">
					<cfset  Letras1 = "four hundred ">
				</cfcase>
			</cfswitch>		
		</cfif>	
		<cfif num1 Gt 499.99 and  num1 lt 600>
			<cfswitch expression = "#arguments.idioma#">
				<cfcase value = "0">
					<cfset  Letras1 =  Letras1  & "quinientos ">
				</cfcase>
				<cfcase value = "1">
					<cfset  Letras1 = "five hundred ">
				</cfcase>
			</cfswitch>		
		</cfif>
		<cfif num1 Gt 599.99 and  num1 lt 700>
			<cfswitch expression = "#arguments.idioma#">
				<cfcase value = "0">
					<cfset  Letras1 =  Letras1  & "seiscientos ">
				</cfcase>
				<cfcase value = "1">
					<cfset  Letras1 = "six hundred ">
				</cfcase>
			</cfswitch>		
		</cfif>		
		<cfif num1 Gt 699.99 and  num1 lt 800>
			<cfswitch expression = "#arguments.idioma#">
				<cfcase value = "0">
					<cfset  Letras1 =  Letras1  & "setecientos ">
				</cfcase>
				<cfcase value = "1">
					<cfset  Letras1 = "seven hundred ">
				</cfcase>
			</cfswitch>		
		</cfif>	
		<cfif num1 Gt 799.99 and  num1 lt 900>
			<cfswitch expression = "#arguments.idioma#">
				<cfcase value = "0">
					<cfset  Letras1 =  Letras1  & "ochocientos ">
				</cfcase>
				<cfcase value = "1">
					<cfset  Letras1 = "eight hundred ">
				</cfcase>
			</cfswitch>		
		</cfif>
		<cfif num1 Gt 899.99 and  num1 lt 1000>
			<cfswitch expression = "#arguments.idioma#">
				<cfcase value = "0">
					<cfset  Letras1 =  Letras1  & "novecientos ">
				</cfcase>
				<cfcase value = "1">
					<cfset  Letras1 = "nine hundred ">
				</cfcase>
			</cfswitch>		
		</cfif>			
		<cfset  num1 = num1 mod 100>
		
		
		<cfif num1 Gt 29.99 and  num1 lt 100>
			<cfif num1 Gt 29.99 and  num1 lt 40>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras1 =  Letras1  & "treinta ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras1 = "thirty ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num1 Gt 39.99 and  num1 lt 50>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras1 =  Letras1  & "cuarenta ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras1 = "forty ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num1 Gt 49.99 and  num1 lt 60>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras1 =  Letras1  & "cincuenta ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras1 = "fifty ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num1 Gt 59.99 and  num1 lt 70>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras1 =  Letras1  & "sesenta ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras1 = "sixty ">
					</cfcase>
				</cfswitch>		
			</cfif>		
			<cfif num1 Gt 69.99 and  num1 lt 80>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras1 =  Letras1  & "setenta ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras1 = "seventy ">
					</cfcase>
				</cfswitch>		
			</cfif>		
			<cfif num1 Gt 79.99 and  num1 lt 90>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras1 =  Letras1  & "ochenta ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras1 = "eighty ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num1 Gt 89.99 and  num1 lt 100>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras1 =  Letras1  & "noventa ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras1 = "ninety ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfset  num1 = num1 mod 10>			
			<cfif arguments.idioma eq 0>
				<cfif Fix(num1) gt 0>
					<cfset  Letras1 =  Letras1  & "y ">
				</cfif>
			</cfif>
		</cfif>
		<cfif num1 Gt 20 and  num1 lt 30>
			<cfswitch expression = "#arguments.idioma#">
				<cfcase value = "0">
					<cfset  Letras1 =  Letras1  & "veinti">
				</cfcase>
				<cfcase value = "1">
					<cfset  Letras1 = "twenty ">
				</cfcase>
			</cfswitch>		
			<cfset  num1 = num1 mod 10>
		</cfif>
		<cfif num1 Gt 0.99 and  num1 lte 20>
			<cfif num1 eq 1>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras1 =  Letras1  & "uno ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras1 = "one ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num1 eq 2>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras1 =  Letras1  & "dos ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras1 = "two ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num1 eq 3>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras1 =  Letras1  & "tres ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras1 = "three ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num1 eq 4>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras1 =  Letras1  & "cuatro ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras1 = "four ">
					</cfcase>
				</cfswitch>		
			</cfif>		
			<cfif num1 eq 5>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras1 =  Letras1  & "cinco ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras1 = "five ">
					</cfcase>
				</cfswitch>		
			</cfif>													
			<cfif num1 eq 6>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras1 =  Letras1  & "seis ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras1 = "six ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num1 eq 7>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras1 =  Letras1  & "siete ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras1 = "seven ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num1 eq 8>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras1 =  Letras1  & "ocho ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras1 = "eight ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num1 eq 9>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras1 =  Letras1  & "nueve ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras1 = "nine ">
					</cfcase>
				</cfswitch>		
			</cfif>		
			<cfif num1 eq 10>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras1 =  Letras1  & "diez ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras1 = "ten ">
					</cfcase>
				</cfswitch>		
			</cfif>
			<cfif num1 eq 11>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras1 =  Letras1  & "once ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras1 = "eleven ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num1 eq 12>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras1 =  Letras1  & "doce ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras1 = "twelve ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num1 eq 13>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras1 =  Letras1  & "trece ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras1 = "thirteen ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num1 eq 14>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras1 =  Letras1  & "catorce ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras1 = "fourteen ">
					</cfcase>
				</cfswitch>		
			</cfif>		
			<cfif num1 eq 15>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras1 =  Letras1  & "quince ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras1 = "fifteen ">
					</cfcase>
				</cfswitch>		
			</cfif>						
			<cfif num1 eq 16>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras1 =  Letras1  & "dieciseis ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras1 = "sixteen ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num1 eq 17>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras1 =  Letras1  & "diecisiete ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras1 = "seventeen ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num1 eq 18>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras1 =  Letras1  & "dieciocho ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras1 = "eighteen ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num1 eq 19>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras1 =  Letras1  & "diecinueve ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras1 = "nineteen ">
					</cfcase>
				</cfswitch>		
			</cfif>		
			<cfif num1 eq 20>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras1 =  Letras1  & "veinte ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras1 = "twenty ">
					</cfcase>
				</cfswitch>		
			</cfif>
		</cfif>
		<cfreturn Letras1> 			
	</cffunction>	
	<!--- ***********************************************************************************************************************************  --->
	<cffunction name="sp_MontoLetras2" access="public" output="true"  returntype="any">
		<cfargument name="Monto2"   	type="numeric" 	required="yes">
		<cfargument name="idioma"   	type="numeric" 	required="no" default="0">	
		<cfargument name="conexion"		type="string" 	required="no" default="#Session.DSN#">
		<cfargument name="Ecodigo" 		type="numeric" 	required="no" default="#session.Ecodigo#">
		<cfargument name="debug" 		type="boolean"  default="no">
		<cfset Letras2 ="">
		<cfset  num2 = Fix(arguments.Monto2)>
		<cfset  dec = (arguments.Monto2-num) >
		<cfif num2 gt 99.99 and num2 lt 200>
			<cfif num2 eq 100>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras2 =  Letras2  & "cien ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras2 = "one hundred ">
					</cfcase>
				</cfswitch>	
			<cfelse>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras2 =  Letras2  & "ciento ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras2 = "one hundred ">
					</cfcase>
				</cfswitch>	
			</cfif>
		</cfif>
		<cfif num2 Gt 199.99 and  num2 lt 300>
			<cfswitch expression = "#arguments.idioma#">
				<cfcase value = "0">
					<cfset  Letras2 =  Letras2  & "doscientos ">
				</cfcase>
				<cfcase value = "1">
					<cfset  Letras2 = "two hundred ">
				</cfcase>
			</cfswitch>		
		</cfif>
		<cfif num2 Gt 299.99 and  num2 lt 400>
			<cfswitch expression = "#arguments.idioma#">
				<cfcase value = "0">
					<cfset  Letras2 =  Letras2  & "trescientos ">
				</cfcase>
				<cfcase value = "1">
					<cfset  Letras2 = "three hundred ">
				</cfcase>
			</cfswitch>		
		</cfif>
		<cfif num2 Gt 399.99 and  num2 lt 500>
			<cfswitch expression = "#arguments.idioma#">
				<cfcase value = "0">
					<cfset  Letras2 =  Letras2  & "cuatrocientos ">
				</cfcase>
				<cfcase value = "1">
					<cfset  Letras2 = "four hundred ">
				</cfcase>
			</cfswitch>		
		</cfif>	
		<cfif num2 Gt 499.99 and  num2 lt 600>
			<cfswitch expression = "#arguments.idioma#">
				<cfcase value = "0">
					<cfset  Letras2 =  Letras2  & "quinientos ">
				</cfcase>
				<cfcase value = "1">
					<cfset  Letras2 = "five hundred ">
				</cfcase>
			</cfswitch>		
		</cfif>
		<cfif num2 Gt 599.99 and  num2 lt 700>
			<cfswitch expression = "#arguments.idioma#">
				<cfcase value = "0">
					<cfset  Letras2 =  Letras2  & "seiscientos ">
				</cfcase>
				<cfcase value = "1">
					<cfset  Letras2 = "six hundred ">
				</cfcase>
			</cfswitch>		
		</cfif>		
		<cfif num2 Gt 699.99 and  num2 lt 800>
			<cfswitch expression = "#arguments.idioma#">
				<cfcase value = "0">
					<cfset  Letras2 =  Letras2  & "setecientos ">
				</cfcase>
				<cfcase value = "1">
					<cfset  Letras2 = "seven hundred ">
				</cfcase>
			</cfswitch>		
		</cfif>	
		<cfif num2 Gt 799.99 and  num2 lt 900>
			<cfswitch expression = "#arguments.idioma#">
				<cfcase value = "0">
					<cfset  Letras2 =  Letras2  & "ochocientos ">
				</cfcase>
				<cfcase value = "1">
					<cfset  Letras2 = "eight hundred ">
				</cfcase>
			</cfswitch>		
		</cfif>
		<cfif num2 Gt 899.99 and  num2 lt 1000>
			<cfswitch expression = "#arguments.idioma#">
				<cfcase value = "0">
					<cfset  Letras2 =  Letras2  & "novecientos ">
				</cfcase>
				<cfcase value = "1">
					<cfset  Letras2 = "nine hundred ">
				</cfcase>
			</cfswitch>		
		</cfif>			
		<cfset  num2 = num2 mod 100>
		<cfif num2 Gt 29.99 and  num2 lt 100>
			<cfif num2 Gt 29.99 and  num2 lt 40>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras2 =  Letras2  & "treinta ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras2 = "thirty ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num2 Gt 39.99 and  num2 lt 50>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras2 =  Letras2  & "cuarenta ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras2 = "forty ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num2 Gt 49.99 and  num2 lt 60>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras2 =  Letras2  & "cincuenta ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras2 = "fifty ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num2 Gt 59.99 and  num2 lt 70>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras2 =  Letras2  & "sesenta ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras2 = "sixty ">
					</cfcase>
				</cfswitch>		
			</cfif>		
			<cfif num2 Gt 69.99 and  num2 lt 80>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras2 =  Letras2  & "setenta ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras2 = "seventy ">
					</cfcase>
				</cfswitch>		
			</cfif>		
			<cfif num2 Gt 79.99 and  num2 lt 90>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras2 =  Letras2  & "ochenta ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras2 = "eighty ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num2 Gt 89.99 and  num2 lt 100>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras2 =  Letras2  & "noventa ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras2 = "ninety ">
					</cfcase>
				</cfswitch>		
			</cfif>
			<cfset  num2 = num2 mod 10>
			<cfif arguments.idioma eq 0>
				<cfif Fix(num2) gt 0>
					<cfset  Letras2 =  Letras2  & "y ">
				</cfif>
			</cfif>
		</cfif>
		<cfif num2 Gt 20 and  num2 lt 30>
			<cfswitch expression = "#arguments.idioma#">
				<cfcase value = "0">
					<cfset  Letras2 =  Letras2  & "veinti">
				</cfcase>
				<cfcase value = "1">
					<cfset  Letras2 = "twenty ">
				</cfcase>
			</cfswitch>		
			<cfset  num2 = num2 mod 10>
		</cfif>
		<cfif num2 Gt 0.99 and  num2 lte 20>
			<cfif num2 eq 1>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras2 =  Letras2  & "uno ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras2 = "one ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num2 eq 2>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras2 =  Letras2  & "dos ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras2 = "two ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num2 eq 3>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras2 =  Letras2  & "tres ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras2 = "three ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num2 eq 4>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras2 =  Letras2  & "cuatro ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras2 = "four ">
					</cfcase>
				</cfswitch>		
			</cfif>		
			<cfif num2 eq 5>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras2 =  Letras2  & "cinco ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras2 = "five ">
					</cfcase>
				</cfswitch>		
			</cfif>													
			<cfif num2 eq 6>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras2 =  Letras2  & "seis ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras2 = "six ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num2 eq 7>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras2 =  Letras2  & "siete ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras2 = "seven ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num2 eq 8>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras2 =  Letras2  & "ocho ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras2 = "eight ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num2 eq 9>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras2 =  Letras2  & "nueve ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras2 = "nine ">
					</cfcase>
				</cfswitch>		
			</cfif>		
			<cfif num2 eq 10>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras2 =  Letras2  & "diez ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras2 = "ten ">
					</cfcase>
				</cfswitch>		
			</cfif>
			<cfif num2 eq 11>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras2 =  Letras2  & "once ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras2 = "eleven ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num2 eq 12>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras2 =  Letras2  & "doce ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras2 = "twelve ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num2 eq 13>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras2 =  Letras2  & "trece ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras2 = "thirteen ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num2 eq 14>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras2 =  Letras2  & "catorce ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras2 = "fourteen ">
					</cfcase>
				</cfswitch>		
			</cfif>		
			<cfif num2 eq 15>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras2 =  Letras2  & "quince ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras2 = "fifteen ">
					</cfcase>
				</cfswitch>		
			</cfif>						
			<cfif num2 eq 16>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras2 =  Letras2  & "dieciseis ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras2 = "sixteen ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num2 eq 17>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras2 =  Letras2  & "diecisiete ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras2 = "seventeen ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num2 eq 18>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras2 =  Letras2  & "dieciocho ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras2 = "eighteen ">
					</cfcase>
				</cfswitch>		
			</cfif>	
			<cfif num2 eq 19>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras2 =  Letras2  & "diecinueve ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras2 = "nineteen ">
					</cfcase>
				</cfswitch>		
			</cfif>		
			<cfif num2 eq 20>
				<cfswitch expression = "#arguments.idioma#">
					<cfcase value = "0">
						<cfset  Letras2 =  Letras2  & "veinte ">
					</cfcase>
					<cfcase value = "1">
						<cfset  Letras2 = "twenty ">
					</cfcase>
				</cfswitch>		
			</cfif>
		</cfif>
		<cfreturn Letras2> 			
	</cffunction>		
		
</cfcomponent>