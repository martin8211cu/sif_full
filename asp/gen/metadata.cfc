<cfcomponent>

	<cffunction name="load_pdm">
		<cfargument name="pdm" type="string">

		<cfif IsDefined ('session.pdm.xml_parsed_file') and session.pdm.xml_parsed_file is Arguments.pdm>
			<cfset xml_parsed = session.pdm.xml_parsed>
		<cfelse>
			<!--- UTF-8 hace que las tildes salgan bonitas --->
			<cffile action="read" charset="utf-8" variable="xml" file="#ExpandPath('/asp/gen/pdm/' & Arguments.pdm)#">
			<cfset xml_parsed = XMLParse(xml)>
			<cfset session.pdm.xml_parsed = xml_parsed>
			<cfset session.pdm.xml_parsed_file = Arguments.pdm>
		</cfif>
		<cfreturn xml_parsed>
	</cffunction>


	<cffunction name="tabla_xml">
		<cfargument name="pdm" type="string" required="yes">
		<cfargument name="tabla" type="string" required="yes">
		
		<cfset metadata = StructNew()>
		<cfset xml = load_pdm(Arguments.pdm)>
		<!---
		<cffile action="read" variable="xml" file="#ExpandPath('/asp/gen/pdm/#Arguments.pdm#')#">
		--->
		<cfset url.code = Arguments.tabla>
		
		<cfsavecontent variable="xsl"><cfinclude template="tablamd.xsl.cfm"></cfsavecontent>
		
		<cfset ret = XMLTransform(xml,xsl) >
		<cfreturn ret>
	</cffunction>
	
	<cffunction name="xml2struct" returntype="any" access="package">
		<cfargument name="xml">
		
		<cfif ArrayLen(Arguments.xml.XmlChildren) Or not StructIsEmpty(Arguments.xml.XmlAttributes)>
			<cfset ret = StructNew()>
			<cfif ArrayLen(Arguments.xml.XmlChildren)>
				<cfloop from="1" to="#ArrayLen(Arguments.xml.XmlChildren)#" index="i">
					<cfset this_child = Arguments.xml.XmlChildren[i]>
					<cfinvoke component="metadata" method="xml2struct" returnvariable="this_child_struct"
						xml="#this_child#">

					<cfif Not StructKeyExists(ret, this_child.XmlName)>
						<cfif ListFind('keys,cols', this_child.XmlName)>
							<cfset ar = ArrayNew(1)>
							<cfset ar[1] = this_child_struct>
							<cfset ret[this_child.XmlName] = ar>
						<cfelse>
							<cfset ret[this_child.XmlName] = this_child_struct>
						</cfif>
					<cfelseif IsArray(ret[this_child.XmlName])>
						<cfset ArrayAppend(ret[this_child.XmlName], this_child_struct)>
					<cfelse>
						<cfset ar = ArrayNew(1)>
						<cfset ar[1] = ret[this_child.XmlName]>
						<cfset ar[2] = this_child_struct>
						<cfset ret[this_child.XmlName] = ar>
					</cfif>
				</cfloop>
			</cfif>
			<cfset StructAppend(ret, Arguments.xml.XmlAttributes, false)>
			<cfreturn ret>
		<cfelse>
			<cfreturn xml.XmlText>
		</cfif>
		
	</cffunction>
	
	<cffunction name="tabla_struct" output="false">
		<cfargument name="pdm" type="string" required="yes">
		<cfargument name="tabla" type="string" required="yes">
		
		<cfset xml = XMLParse(tabla_xml(pdm,tabla))>

		<cfreturn xml2struct(xml.XmlRoot)>
	</cffunction>

</cfcomponent>