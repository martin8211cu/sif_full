<cfcomponent>

   <cffunction name="DrawBarcode128" returnType="numeric">
		<cfargument name="code" required=true type="string">
		<cfargument name="fileName" default="barcode-code128"  type="string">
		<cfargument name="filePath" default="../wwwroot/crc/images/"  type="string">
		<cfargument name="SizeY" default=55 type="numeric">
		
		<cfobject action="create" type="java" class="com.onbarcode.barcode.Code128" name="Barcode">
		<cfscript>
			Barcode.setResolution(500);
			Barcode.setY(#arguments.SizeY#);
			Barcode.setData("#arguments.code#"); 
			Barcode.setData("#arguments.code#"); 
			Barcode.drawBarcode("#arguments.filePath##arguments.fileName#.jpg"); 
		</cfscript>
		<cfreturn 0>
	</cffunction>
	
	
   <cffunction name="CreateBarcodeOxxoD" returnType="numeric">
		<cfargument name="NumCuenta" required=true type="string">
		<cfargument name="FechaLimite" required=true type="date">
		
		<cfif Len(arguments.NumCuenta) gt 10>
			<cfthrow message="Numero de Cuenta (#arguments.NumCuenta#) tiene mas de 10 digitos. No se puede generar codigo segun estandar Oxxo">
		</cfif>
		
		<cfset OxxoCode = "12">
		<cfset RefNumber = "#arguments.NumCuenta#">
		<cfset LimitDate = "#DateFormat(FechaLimite,"yyyymmdd")#">
		<cfset EndingDigit = "">
		
		<cfset RefNumber = right("0000000#RefNumber#",7)>
		
		<cfset PreBarcode = "#OxxoCode##RefNumber##LimitDate#">
		<cfset EndingDigit = OxxoDigitoVerificadorBase10(PreBarcode)>

		<cfset Barcode="#OxxoCode##RefNumber##LimitDate##EndingDigit#">
		
		<cfset result = DrawBarcode128(code="#Barcode#", fileName="#arguments.NumCuenta#")>
		
		<cfreturn 0>
		
	</cffunction>
   	
   <cffunction name="OxxoDigitoVerificadorBase10" returnType="numeric">
		<cfargument name="preCode" required=true type="string">
		
		<cfset multiplier = 1>
		<cfset factor = 1>
		<cfset sum = 0>
		<cfloop to="1" from="#Len(arguments.preCode)#" index="i" step=-1>
			<cfset CurrentDigit = Mid(arguments.preCode,i,1)>
			<cfset factor = factor + multiplier>
			<cfset val = CurrentDigit * factor>
			<cfif Len("#val#") ge 2>
				<cfset sum = sum + Mid("#val#",1,1)>
				<cfset sum = sum + Mid("#val#",2,1)>
			<cfelse>
				<cfset sum= sum + val>
			</cfif>
			<cfset multiplier = multiplier * -1>
		</cfloop>
		
		<cfset residuo = sum % 10>
		<cfif residuo eq 0>
			<cfreturn 0>
		<cfelse>
			<cfreturn (10-residuo)>
		</cfif>
	
   </cffunction>


    <cffunction name="CreateBarcodeBBVAD" returnType="numeric">
		<cfargument name="NumCuenta" required=true type="string">
		<cfargument name="FechaLimite" required=true type="date">
		
		<cfif Len(arguments.NumCuenta) gt 9>
			<cfthrow message="Numero de Cuenta (#arguments.NumCuenta#) tiene mas de 9 digitos. No se puede generar codigo segun estandar BBVA">
		</cfif>
		
		<cfset BBVACode = "12">
		<cfset RefNumber = right("0000000#arguments.NumCuenta#",7)>
		<cfset LimitDate = "#DateFormat(FechaLimite,"yyyymmdd")#">
		<cfset EndingDigit = "">
		
		<cfset PreBarcode = "#BBVACode##RefNumber##LimitDate#">
		<cfset EndingDigit = BBVADigitoVerificadorBase10(PreBarcode)>

		<cfset Barcode="#BBVACode##RefNumber##LimitDate##EndingDigit#">
		
		<cfset result = DrawBarcode128(code="#Barcode#", fileName="BBVA_#arguments.NumCuenta#")>
		
		<cfreturn 0>
		
	</cffunction>

    <cffunction name="CreateRefBBVAD" returnType="numeric">
		<cfargument name="NumCuenta" required=true type="string">
		<cfargument name="FechaLimite" required=true type="date">
		
		<cfif Len(arguments.NumCuenta) gt 9>
			<cfthrow message="Numero de Cuenta (#arguments.NumCuenta#) tiene mas de 9 digitos. No se puede generar codigo segun estandar BBVA">
		</cfif>
		
		<cfset BBVACode = "12">
		<cfset RefNumber = right("0000000#arguments.NumCuenta#",7)>
		<cfset LimitDate = "#DateFormat(FechaLimite,"yyyymmdd")#">
		<cfset EndingDigit = "">
		
		<cfset PreBarcode = "#BBVACode##RefNumber##LimitDate#">
		<cfset EndingDigit = BBVADigitoVerificadorBase10(PreBarcode)>

		<cfset Barcode="#BBVACode##RefNumber##LimitDate##EndingDigit#">
		
		<!--- <cfset result = DrawBarcode128(code="#Barcode#", fileName="BBVA_#arguments.NumCuenta#")> --->
		
		<cfreturn Barcode>
		
	</cffunction>

	<cffunction name="BBVADigitoVerificadorBase10" returnType="numeric">
		<cfargument name="preCode" required=true type="string">
		
		<cfset multiplier = 1>
		<cfset factor = 1>
		<cfset sum = 0>
		<cfloop to="1" from="#Len(arguments.preCode)#" index="i" step=-1>
			<cfset CurrentDigit = Mid(arguments.preCode,i,1)>
			<cfset factor = factor + multiplier>
			<cfset val = CurrentDigit * factor>
			<cfif Len("#val#") ge 2>
				<cfset sum = sum + Mid("#val#",1,1)>
				<cfset sum = sum + Mid("#val#",2,1)>
			<cfelse>
				<cfset sum= sum + val>
			</cfif>
			<cfset multiplier = multiplier * -1>
		</cfloop>
		
		<cfset residuo = sum % 10>
		<cfif residuo eq 0>
			<cfreturn 0>
		<cfelse>
			<cfreturn (10-residuo)>
		</cfif>
	
   	</cffunction>
   
	<cffunction name="HTMLBarcodeTag" returnType="string">
		<cfargument name="code" required=true type="string">
		<cfargument name="fileName" required=true type="string">
		<cfargument name="filePathGen" required=true type="string">
		<cfargument name="filePathRead" required=true type="string">
		<cfargument name="sizeY" default=20 type="numeric">
		
		<cfset result = DrawBarcode128(
			code=arguments.code
			,fileName=arguments.fileName
			,filePath=arguments.filePathGen
			,SizeY=arguments.sizeY)>

		<cfset return = "<img src='#arguments.filePathRead##arguments.fileName#.jpg'>">

		<cfreturn return>
	</cffunction>
	
</cfcomponent>