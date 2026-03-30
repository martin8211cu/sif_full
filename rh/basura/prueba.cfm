<cfinvoke
method="RetornaXML"
returnvariable="xmlPartners"
webservice="ejemplo">
    <cfinvokeargument name="Ecodigo" value="1">
    <cfinvokeargument name="DEid"  value="4839">
    <cfinvokeargument name="Puesto" value="DIRP1">
</cfinvoke>
<!---<cfset xmlObj = XmlParse(xmlPartners)>  --->
<cfdump var="#xmlPartners#"> 