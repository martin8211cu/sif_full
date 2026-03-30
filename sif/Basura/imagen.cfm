<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>

<cfquery name="rs_Imagen" datasource="minisif">
	select PRJarchivo, PRJcodigo from PRJproyecto where PRJid=2
</cfquery>

	<!--- Procesar el BLOB --->
	<cfset ts = "">
	<cfset Hex=ListtoArray("0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F")>
	<cfif isArray(#Evaluate("rs_Imagen.PRJarchivo")#)>
			<cfset miarreglo=ListtoArray(ArraytoList(#Evaluate("rs_Imagen.PRJarchivo")#,","),",")>
			<cfloop index="i" from="1" to="3">
				<cfif miarreglo[i] LT 0>
					<cfset miarreglo[i]=miarreglo[i]+256>
				</cfif>
			</cfloop>
			<cfloop index="i" from="1" to="3">
				<cfset ts = ts & "#chr(miarreglo[i])#">
			</cfloop>
	
	</cfif>
	<cfdump var="#rs_Imagen#">
	<cfabort>
	<cffile 
		action="write" 
		nameconflict="overwrite" 
		file="#gettempdirectory()##rs_Imagen.PRJcodigo#.mpp"
		output="#Evaluate('rs_Imagen.PRJarchivo')#">
<cfoutput>#gettempdirectory()#</cfoutput>

</body>
</html>
