<cfobject name="LvarWS" webservice="http://desarrollo/cfmx/sif/Basura/webservice/wsCheck.cfc?wsdl">
<cfset x=LvarWS.prueba()>
<cfdump var="#x#">
