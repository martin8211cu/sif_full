
<!--- =============================================================== --->
<!--- Autor:  Rodrigo Rivera                                          --->
<!--- Nombre: Arrendamiento                                           --->
<!--- Fecha:  12/03/2015                                              --->
<!--- Última Modificación: 13/03/2015                                 --->
<!--- =============================================================== --->
<cfprocessingdirective pageEncoding="utf-8">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<title>Adenda</title>
	</head>
	<body>
		<!--- CSS --->
		<link type="text/css" rel="stylesheet" href="/cfmx/plantillas/soinasp01/css/soinasp01_azul.css">
		<style type="text/css">
			html, body { height: 100% }
		</style>
		<!--- INICIALIZACIÓN DE VARIABLES --->
		<cfparam name="url.ADDcodigo" default="">
		<cfparam name="URL.path" type="regex" pattern="^\d+(,\d+)*$" default="1" />
		
		<!--- Converts comma delimeted to XPath --->
		<cfset strXPath = ("/*[" &Replace(URL.path,",","]/*[","all") &"]") />
		
		<!--- INITIALIZE XML --->
		<cfif isDefined('url.ADDcodigo') AND len(trim(url.ADDcodigo)) AND url.ADDcodigo NEQ -1>
			<cfquery name="rsXML" datasource="#session.dsn#">
				SELECT * FROM Addendas
				WHERE 	Ecodigo = #Session.Ecodigo# 
				AND 	ADDcodigo = '#url.ADDcodigo#'
			</cfquery>
			<cfset varXML = #rsXML.xml_#>
		<cfelse>
			<!--- in case no ADDcodigo is passed --->
			<p style="word-spacing: 0; color:Red; font-weight:bold;">No se ha seleccionado ninguna adenda</p>
			<cfabort>
		</cfif>
		<!--- if variable is not an xml then it abort the operation --->
		<cfif NOT isxml(varXML)>
			<p style="word-spacing: 0; color:Red; font-weight:bold;">Error al parsear XML, Verificar que el archivo guardado está bien generado</p>
			<cfabort>
		</cfif>

		<!--- Get the selected node based on the XPath. --->
		<cfset arrNodes = XmlSearch(varXML,strXPath) />

		<!--- pointer to xml --->
		<cfset xmlNode = arrNodes[ 1 ] />

		<cfif StructKeyExists( URL, "xml_text" )>
			<!--- Update xml text (automatically cached). --->
			<cfset xmlNode.XmlText = #URL.xml_text# />
		</cfif>

		<p>
			<!--- Find the parent node. --->
			<cfif (ListLen( URL.path ) GT 1)>
				<a href="#CGI.script_name#?path=#ListDeleteAt( URL.path, ListLen( URL.path ) )#">Parent Node</a>
			<cfelse>
				<!--- <em>No Parent</em> --->
			</cfif>
		</p>

		<cfoutput>
		<!--- form --->
		<form action="#CGI.script_name#" method="get">
			<input type="hidden" name="path" value="#URL.path#" />
			<input type="hidden" name="ADDcodigo" value="#url.ADDcodigo#" />
			<table border ="0">
			<cfset counter = 0>
			<cfloop index="intIndex" from="1" to="#ArrayLen( xmlNode.XmlChildren )#" step="1">
				<td>
				<fieldset>
					<legend>#xmlNode.XmlChildren[ intIndex ].XmlName#</legend>
					<!--- ATRIBUTES --->
					<table border ="0">
						<cfloop collection = #xmlNode.XmlChildren[ intIndex ].XmlAttributes# item = "varAttrib">
							<cfparam name="url.varAttrib" default="">
							
							<cftry>
								<cfset Evaluate("var1=url.#xmlNode.XmlChildren[ intIndex ].XmlName#.#varAttrib#")>
							<cfcatch>
								<cfset var1="">
							</cfcatch>
							</cftry>
							<cfif len(trim(#var1#))>
								<cfset xmlNode.XmlChildren[ intIndex ].XmlAttributes[varAttrib] = xmlformat(var1)  />
							</cfif>
					
								<td>#varAttrib#</td>
								<td nowrap="nowrap">
									<input type="text" onchange="submitForm(this);" id="#xmlNode.XmlChildren[ intIndex ].XmlName#.#varAttrib#" value="#xmlNode.XmlChildren[ intIndex ].XmlAttributes[ varAttrib ]#" size="35" />
									<input type="submit" value="Update" />

								</td>
							</tr>
						</cfloop>
						
					</table>
					<!--- xml text --->
					<p>
						<cfif len(trim(#xmlNode.XmlChildren[ intIndex ].XmlText#))>
							Text:
							<input type="text" name="xml_text" value="#xmlNode.XmlChildren[ intIndex ].XmlText#" size="40" />
							<input type="submit" value="Update" />
						</cfif>
					</p>
				</fieldset>
				<cfset counter = counter + 1>
				<cfif counter EQ 2>
					</tr>
					<tr>
					<cfset counter = 0>
				</cfif>
				</td>
			</cfloop>
			</table>
		</form>
		</cfoutput>
		<cfif isDefined('xmlnode') AND isXml(xmlnode)>
			<cfset  sqlXml = xmlparse(xmlnode)>
			<br>
			<cfquery datasource="#session.DSN#">
				UPDATE 	Addendas 
				SET 	XML_ =  <cfqueryparam value="#replace(tostring(xmlnode),'<?xml version="1.0" encoding="UTF-8"?>','')#" cfsqltype="cf_sql_longvarchar" />
				WHERE  	Ecodigo = #session.Ecodigo#
					AND ADDcodigo = '#url.ADDcodigo#'
			</cfquery>
		</cfif>
		<script type="text/javascript">
		
			function submitForm(t) {
			    var element = t;
			   	var name = t.id;
			        element.name = name;
			}
		</script>
	</body>
</html>