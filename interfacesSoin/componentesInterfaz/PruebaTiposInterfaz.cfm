<cfif GvarMD EQ "T">
	<cfquery name="rsSQL" datasource="sifinterfaces">
		select tipoInvocacion, tipoResultado
		  from IE#GvarNI#
		 where ID = #GvarID#
	</cfquery>
	<cfset LvarTI = rsSQL.tipoInvocacion>
	<cfset LvarTR = rsSQL.tipoResultado>
<cfelse>
<!---
	<resultset>
		<row>
			<ID>-123456789012345678</ID>
			<tipoInvocacion>-123456789</tipoInvocacion>
			<tipoResultado>-123456789</tipoResultado>
		</row>
		<row>
			...
		</row>
	</resultset>
--->
	<cfif GvarXML_IE EQ "">
		<cfthrow message="No se enviaron datos XML_IE">
	</cfif>
	<cfset LvarXML = XmlParse(GvarXML_IE)>
	<cfset LvarXMLrow = LvarXML.resultset.row[1]>
	<cfset LvarXMLrowVals = LvarXMLrow.XmlChildren>
	<cfset LvarTI = LvarXMLrowVals[XmlChildPos(LvarXMLrow,"tipoInvocacion", 1)].XmlText>
	<cfset LvarTR = LvarXMLrowVals[XmlChildPos(LvarXMLrow,"tipoResultado", 1)].XmlText>
</cfif>
<cfif LvarTR NEQ -1>
	<cfif GvarMD EQ "T">
		<cfquery datasource="sifinterfaces">
			insert into OE#GvarNI#
				(ID, MSG)
			values (#GvarID#,'OK interfaz #GvarNI#')
		</cfquery>
	<cfelse>
		<cfset GvarXML_OE = "<resultset><row><ID>#GvarID#</ID><MSG>OK interfaz #GvarNI#</MSG></row></resultset>">
	</cfif>
<cfelseif LvarTR EQ 2>
	<cfthrow message="ERROR interfaz #GvarNI#">
<cfelseif LvarTR EQ 3>
	<cfset x = 1/0>
<cfelse>
	<cftry>
		<cfinvoke 	webservice="http://localhost:8300/cfmx/WS/pruebaXML.cfc?WSDL"
					method="fnLogString"
					XML = "#GvarXML_IE#"
					returnvariable="LvarXML_OE"
		>
		<cfset GvarXML_OE = LvarXML_OE>
		<cfcatch type="object">
			<cfset GvarXML_OE = "ERROR:#chr(13)#fnLogString: #cfcatch.Message# #cfcatch.Detail#">
			<cflog file="soinInterfazXML" text="fnLogString: #cfcatch.Message# #cfcatch.Detail#">
		</cfcatch>
	</cftry>
</cfif>
		