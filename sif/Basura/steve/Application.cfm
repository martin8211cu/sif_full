<cfapplication name="appSteve2" sessionmanagement="yes" sessiontimeout="#CreateTimeSpan(7,1,1,1)#">

<!--- PAISES ---> 
<cfscript>
	session.qNacionalidad = QueryNew("codigo,nombre");
	pais = QueryAddRow(session.qNacionalidad,1);
		dato = QuerySetCell(session.qNacionalidad,"codigo","GUA");
		dato = QuerySetCell(session.qNacionalidad,"nombre","Guatemala");	
	pais = QueryAddRow(session.qNacionalidad,1);
		dato = QuerySetCell(session.qNacionalidad,"codigo","HON");
		dato = QuerySetCell(session.qNacionalidad,"nombre","Honduras");	
	pais = QueryAddRow(session.qNacionalidad,1);
		dato = QuerySetCell(session.qNacionalidad,"codigo","ESA");
		dato = QuerySetCell(session.qNacionalidad,"nombre","El Salvador");	
	pais = QueryAddRow(session.qNacionalidad,1);
		dato = QuerySetCell(session.qNacionalidad,"codigo","NIC");
		dato = QuerySetCell(session.qNacionalidad,"nombre","Nicaragua");			
	pais = QueryAddRow(session.qNacionalidad,1);
		dato = QuerySetCell(session.qNacionalidad,"codigo","CRC");
		dato = QuerySetCell(session.qNacionalidad,"nombre","Costa Rica");	
	pais = QueryAddRow(session.qNacionalidad,1);
		dato = QuerySetCell(session.qNacionalidad,"codigo","PAN");
		dato = QuerySetCell(session.qNacionalidad,"nombre","Panamá");
</cfscript>