<!----
Componente para convertir array, Lists, query y Struct en XML


Documentación de prueba:

<cfset toXML = createObject("commons.Componentes.toXML")>

<!--- List to XML --->
<cfset list = "apple,orange,pear,banana">
<cfset xmlList = toXML.listToXML(list,"fruits", "fruit")>

<cfdump var="#xmlParse(xmlList)#">

<!--- Array to XML --->
<cfset array = arrayNew(1)>
<cfset array[1] = "apple">
<cfset array[2] = "orange">
<cfset array[3] = "pear">
<cfset array[4] = "banana">
<cfset xmlArray = toXML.arrayToXML(array, "fruits", "fruit")>

<cfdump var="#xmlParse(xmlArray)#">

<!--- Query to XML --->
<cfset q = queryNew("id,fruit,calories,color")>

<cfset queryAddRow(q)>
<cfset querySetCell(q, "id", 1)>
<cfset querySetCell(q, "fruit", "apple")>
<cfset querySetCell(q, "calories", "200")>
<cfset querySetCell(q, "color", "red")>

<cfset queryAddRow(q)>
<cfset querySetCell(q, "id", 2)>
<cfset querySetCell(q, "fruit", "orange")>
<cfset querySetCell(q, "calories", "220")>
<cfset querySetCell(q, "color", "orange")>

<cfset queryAddRow(q)>
<cfset querySetCell(q, "id", 3)>
<cfset querySetCell(q, "fruit", "pear")>
<cfset querySetCell(q, "calories", "500")>
<cfset querySetCell(q, "color", "yellowish")>

<cfset queryAddRow(q)>
<cfset querySetCell(q, "id", 4)>
<cfset querySetCell(q, "fruit", "banana")>
<cfset querySetCell(q, "calories", "90")>
<cfset querySetCell(q, "color", "yellow")>

<cfset xmlQuery = toXML.queryToXML(q, "fruits", "fruit")>

<cfdump var="#xmlParse(xmlQuery)#">

<cfset s = structNew()>
<cfset s.id = 9>
<cfset s.name = "Raymond Camden">
<cfset s.age = 33>

<cfset xmlStruct = toXML.structToXML(s, "people", "person")>
<cfdump var="#xmlParse(xmlStruct)#">


---->

<cfcomponent displayName="To XML" hint="Set of utility functions to generate XML" output="false">

<cffunction name="arrayToXML" returnType="string" access="public" output="false" hint="Converts an array into XML">
	<cfargument name="data" type="array" required="true">
	<cfargument name="rootelement" type="string" required="true"><!
	<cfargument name="itemelement" type="string" required="true">
	<cfset var s = "<?xml version=""1.0"" encoding=""UTF-8""?>">
	<cfset var x = "">
	
	<cfset s = s & "<" & arguments.rootelement & ">">
	<cfloop index="x" from="1" to="#arrayLen(arguments.data)#">
		<cfset s = s & "<" & arguments.itemelement & ">" & xmlFormat(arguments.data[x]) & "</" & arguments.itemelement & ">">
	</cfloop>
	
	<cfset s = s & "</" & arguments.rootelement & ">">
	
	<cfreturn s>
</cffunction>

<cffunction name="listToXML" returnType="string" access="public" output="false" hint="Converts a list into XML.">
	<cfargument name="data" type="string" required="true">
	<cfargument name="rootelement" type="string" required="true">
	<cfargument name="itemelement" type="string" required="true">
	<cfargument name="delimiter" type="string" required="false" default=",">
	
	<cfreturn arrayToXML( listToArray(arguments.data, arguments.delimiter), arguments.rootelement, arguments.itemelement)>
</cffunction>

<cffunction name="queryToXML" returnType="string" access="public" output="false" hint="Converts a query to XML">
	<cfargument name="data" type="query" required="true">
	<cfargument name="rootelement" type="string" required="true">
	<cfargument name="itemelement" type="string" required="true">
	<cfargument name="cDataCols" type="string" required="false" default="">
	
	<cfset var s = "<?xml version=""1.0"" encoding=""UTF-8""?>">
	<cfset var col = "">
	<cfset var columns = arguments.data.columnlist>
	<cfset var txt = "">
	
	<cfset s = s & "<" & arguments.rootelement & ">">
	<cfloop query="arguments.data">
		<cfset s = s & "<" & arguments.itemelement & ">">

		<cfloop index="col" list="#columns#">
			<cfset txt = arguments.data[col][currentRow]>
			<cfif isSimpleValue(txt)>
				<cfif listFindNoCase(arguments.cDataCols, col)>
					<cfset txt = "<![CDATA[" & txt & "]]" & ">">
				<cfelse>
					<cfset txt = xmlFormat(txt)>
				</cfif>
			<cfelse>
				<cfset txt = "">
			</cfif>

			<cfset s = s & "<" & col & ">" & txt & "</" & col & ">">

		</cfloop>
		
		<cfset s = s & "</" & arguments.itemelement & ">">
	</cfloop>
	
	<cfset s = s & "</" & arguments.rootelement & ">">
	
	<cfreturn s>
</cffunction>

<cffunction name="structToXML" returnType="string" access="public" output="false" hint="Converts a struct into XML.">
	<cfargument name="data" type="struct" required="true">
	<cfargument name="rootelement" type="string" required="true">
	<cfargument name="itemelement" type="string" required="true">

	<cfset var s = "<?xml version=""1.0"" encoding=""UTF-8""?>">
	<cfset var keys = structKeyList(arguments.data)>
	<cfset var key = "">
	
	
	<cfset s = s & "<" & arguments.rootelement & ">">
	<cfset s = s & "<" & arguments.itemelement & ">">
	
	<cfloop index="key" list="#keys#">
		<cftry>
		<cfset s = s & "<#key#>#xmlFormat(arguments.data[key])#</#key#>">
		<cfcatch>
			<!---<cf_dumptoFile var="#key#">--->
		</cfcatch>
		</cftry>
	</cfloop>
	
	<cfset s = s & "</" & arguments.itemelement & ">">
	<cfset s = s & "</" & arguments.rootelement & ">">
	
	<cfreturn s>		
</cffunction>

<cffunction name="structItemToXML" returnType="string" access="public" output="false" hint="Converts a struct into XML.">
	<cfargument name="data" type="struct" required="true" hint="structura con los datos">
	<cfargument name="ItemName" 	type="string" required="true" hint="Nombre de la etiqueta que contendra las otras etiquetas">
	<cfargument name="subItemXml" 	type="any" required="no" default="" hint="texto xml que se desea incluir dentro del ItemName">
	<cfargument name="subItemExcl" 	type="string" required="no" default="Nombres de los item de tipos compuestos se deben excluir">

	<cfset var s = "">
	<cfset var keys = structKeyList(arguments.data)>
	<cfset var key = "">
	
	<cfset s = s & "<" & arguments.ItemName & ">">
	<cfloop index="key" list="#keys#">
		<cfif not ListContainsNoCase(subItemExcl,key)>
			<cfset s = s & "<#key#>#xmlFormat(arguments.data[key])#</#key#>">
		</cfif>
	</cfloop>
	
	<cfif isdefined("Arguments.subItemXml") and len(trim(Arguments.subItemXml))>
		<cfset s = s & Arguments.subItemXml>
	</cfif>
	
	<cfset s = s & "</" & arguments.ItemName & ">">
	
	<cfreturn s>		
</cffunction>

</cfcomponent>