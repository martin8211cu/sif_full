<!---Queda pendiente la concatenacion del nodo y parametro--->

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_SIFAdministracionDelSistema"
	Default="SIF - Administraci&oacute;n del Sistema"
	XmlFile="/sif/generales.xml"
	returnvariable="LB_SIFAdministracionDelSistema"/>
<cf_templateheader title="#LB_SIFAdministracionDelSistema#">
	<cfparam name="form.ADDID" default="">
	<cfparam Name="varXML" default="">
	<cfif isdefined("url.ADDID") and Len(Trim("url.ADDID")) gt 0 >
		<cfset form.ADDID = url.ADDID >
	</cfif>
	<cfif isdefined("form.ADDID") and len(trim("form.ADDID")) gt 0 and form.ADDID NEQ "">
		<cfset session.ADDID = form.ADDID>
	</cfif>
	<cfquery datasource="#session.dsn#" name="Addenda_Query">
		select XML_, ADDcodigo, ADDNombre
		from Addendas a
		where (a.Ecodigo is null or a.Ecodigo=#session.Ecodigo# )
		<cfif len(trim(form.ADDID)) gt 0 >
			 and ADDID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ADDID#">
		<cfelseif len(trim(session.ADDID)) gt 0>
			and ADDID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ADDID#">
		</cfif>
		order by ADDID, ADDDESC
	</cfquery>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Valores de la Addenda #Addenda_Query.ADDNombre# con c&oacute;digo #Addenda_Query.ADDcodigo#'>
		<cfparam name="URL.path" type="regex" pattern="^\d+(,\d+)*$" default="1" />
		<!--- Converts comma delimeted to XPath --->
		<cfset strXPath = ("/*[" & Replace(URL.path, ",", "]/*[", "all") & "]") />
		<!--- APPLICATION.Data = xmlobject name --->
		<!--- initialize xml --->
		<cfset varXML = #Addenda_Query.XML_#>
		<!--- Get the selected noded based on the XPath. --->
		<cfset arrNodes = XmlSearch(varXML, strXPath) />
		<!--- pointer to xml --->
		<cfset xmlNode = arrNodes[ 1 ] />
		<cfif StructKeyExists( URL, "xml_text" )>
			<!--- Update xml text (automatically cached). --->
			<cfset xmlNode.XmlText = #URL.xml_text# />
		</cfif>
		<cfoutput>
			<p>
				<!---Check for children to find the parent node.--->
				<cfif (ListLen( URL.path ) GT 1)>
					<!---<cfdump var=#ListDeleteAt( URL.path, ListLen( URL.path ) )#>--->
					<a href="#CGI.script_name#?ADDid=#session.ADDid#&path=#ListDeleteAt(URL.path, ListLen(URL.path ))#&temp=#ListLen(URL.path )#">Regresar al Anterior</a>
				<cfelse>
					<!--- <em>No Parent</em> --->
				</cfif>
			</p>
			<!--- form --->
			<form action="#CGI.script_name#" method="get">
				<input type="hidden" name="path" value="#URL.path#" />
				<table border = "0" align="center">
					<cfloop index="intIndex" from="1" to="#ArrayLen( xmlNode.XmlChildren )#" step="2">
						<tr>
							<td>
								<fieldset>
									<!---<legend><a href="#CGI.script_name#?ADDid=#session.ADDid#&path=#ListAppend( URL.path, intIndex )#&temp=#ListLen(URL.path )#">#xmlNode.XmlChildren[ intIndex ].XmlName#</a></legend>--->
									<legend>#xmlNode.XmlChildren[ intIndex ].XmlName#</legend>
									<!--- ATRIBUTES --->
									<table border ="0">
										<cfloop collection = #xmlNode.XmlChildren[ intIndex ].XmlAttributes# item = "varAttrib">
											<cfparam name="url.varAttrib" default="">
												<cftry>
													<cfset Evaluate("var1=url.#varAttrib#")>
													<cfcatch>
														<cfset var1="">
													</cfcatch>
												</cftry>

												<cfif len(trim(#var1#))>
													<cfset #xmlNode.XmlChildren[ intIndex ].XmlAttributes[varAttrib]# = XmlFormat( var1 ) />
												</cfif>
												<tr>
													<td>#varAttrib#</td>
													<td>
														<input type="text" name="#varAttrib#" value="#xmlNode.XmlChildren[ intIndex ].XmlAttributes[ varAttrib ]#" size="40" />
														<input type="submit" value="Update" />
													</td>
												</tr>
										</cfloop>
									</table>
									<!--- xml text --->
									<p>
										<cfif len(trim(#xmlNode.XmlChildren[ intIndex ].XmlText#))>
											Text:<input type="text" name="xml_text" value="#xmlNode.XmlChildren[ intIndex ].XmlText#" size="40" />
											<input type="submit" value="Update" />
										</cfif>
									</p>
								</fieldset>
							</td>
							<cfset intIndex  = intIndex + 1>
							<cfif intIndex LTE #ArrayLen( xmlNode.XmlChildren )#>
								<td>
									<fieldset>
										<!---<legend><a href="#CGI.script_name#?ADDid=#form.ADDid#&path=#ListAppend( URL.path, intIndex )#">#xmlNode.XmlChildren[ intIndex ].XmlName#</a></legend>--->
										<legend>#xmlNode.XmlChildren[ intIndex ].XmlName#</legend>
										<!--- ATRIBUTES --->
										<table border ="0">
											<cfloop collection = #xmlNode.XmlChildren[ intIndex ].XmlAttributes# item = "varAttrib">
												<cfparam name="url.varAttrib" default="">
												<cftry>
													<cfset Evaluate("var1=url.#varAttrib#")>
													<cfcatch>
														<cfset var1="">
													</cfcatch>
												</cftry>
												<cfif len(trim(#var1#))>
													<cfset #xmlNode.XmlChildren[ intIndex ].XmlAttributes[varAttrib]# = XmlFormat( var1 ) />
												</cfif>
												<tr>
													<td>#varAttrib#</td>
													<td>
														<input type="text" name="#varAttrib#" value="#xmlNode.XmlChildren[ intIndex ].XmlAttributes[ varAttrib ]#" size="40" />
														<input type="submit" value="Update" />
													</td>
												</tr>
											</cfloop>
										</table>
										<!--- xml text --->
										<p>
											<cfif len(trim(#xmlNode.XmlChildren[ intIndex ].XmlText#))>
												Text:<input type="text" name="xml_text" value="#xmlNode.XmlChildren[ intIndex ].XmlText#" size="40" />
												<input type="submit" value="Update" />
											</cfif>
										</p>
									</fieldset>
								</td>
							</cfif>
						</tr>
					</cfloop>
					<tr>
						<td colspan="2" align="center"><input type="button" onclick="Regresar()" value="Regresar"></td>
					</tr>
				</table>
			</form>
		</cfoutput>
		<cfif isdefined("xmlnode") and len(trim("xmlnode")) gt 0><cfset VarAux="#xmlnode#"><cfelse><cfset VarAux="#Addenda_Query.XML_#"></cfif>
		<cfquery datasource="#session.dsn#" name="Update_Addenda">
			update Addendas
			set XML_ = <cfqueryparam cfsqltype="cf_sql_varchar" value="#xmlnode#">
			where (Ecodigo is null or Ecodigo=#session.Ecodigo# )
				<cfif len(trim(form.ADDID)) gt 0 >
					and ADDID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ADDID#">
				<cfelseif len(trim(session.ADDID)) gt 0>
					and ADDID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ADDID#">
				</cfif>
		</cfquery>
	<cf_web_portlet_end>
<cf_templatefooter>
<script language="JavaScript1.2" type="text/javascript">
	function Regresar(){
		location.href='listaAddendas.cfm';
	}
</script>