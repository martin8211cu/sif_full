<cfquery datasource="sdc" name="datos">
	select Snombre, MSPGcodigo as PaginaInicio
	from Sitio
	where Scodigo = #Scodigo#
</cfquery>
<cfif Len(datos.PaginaInicio) EQ 0>
	<cfquery datasource="sdc" name="datos2">
		select max(MSPGcodigo) as PaginaInicio
		from MSPaginaGenerada
		where Scodigo = #Scodigo#
		  and MSPcodigo is not null
	</cfquery>
	<cfset PaginaInicio = datos2.PaginaInicio>
<cfelse>
	<cfset PaginaInicio = datos.PaginaInicio>
</cfif>
<cfif Len(PaginaInicio) NEQ 0>
	<cfset PaginaInicio = "p" & PaginaInicio & ".html">
</cfif>
<html> <!--- la palabra frame se procesa como krame para que Dreamweaver no falle --->
<cfsavecontent variable="krames"><cfoutput>
	<head>
        <title>#datos.Snombre#</title>
		<meta http-equiv="content-type" content="text/html;charset=iso-8859-1">
		<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
		<meta http-equiv="Pragma" content="no-cache">
	</head>
	<krameset rows="131,*" krameborder="no" border="0" kramespacing="8"> 
		<krame name="topkrame"  scrolling="no" noresize src="b#Scodigo#.html" >
		<krameset cols="130,*" rows="*">
            <krame name="leftkrame" scrolling="yes" resize src="m#Scodigo#.html">
			<krame name="mainkrame2" scrolling="yes" resize src="#PaginaInicio#">
		</krameset>
	</krameset>
	<nokrames>
		<body bgcolor="##e7e7e7" text="##000000">
		Su navegador no le permite visualizar los marcos ( frames ).<br>
		Por favor,
		actualice su navegador a una versi&oacute;n m&aacute;s reciente.
		</body>
	</nokrames>
</cfoutput></cfsavecontent>
<cfoutput># Replace(krames, "krame", "frame", "all") #</cfoutput>
</html>