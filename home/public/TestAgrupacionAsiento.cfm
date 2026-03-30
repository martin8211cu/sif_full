<!---INICIO PROGRAMACION EXTRA QUE HAY QUE COLOCA EN LA TAREA PROGRAMADA QUE GENERA ASIENTO--->
<cfset Request.Oorigen   = 'AFAQ'>
<cfset Request.IDproceso = 123456>
<cfset Request.Edescripcion = 'Cierre de Caja Numero 24'>
<!---FIN PROGRAMACION EXTRA QUE HAY QUE COLOCA EN LA TAREA PROGRAMADA QUE GENERA ASIENTO--->

<cfset LobjCONTA	= createObject( "component","sif.Componentes.CG_GeneraAsiento")>
<cfset INTARC 		= LobjCONTA.CreaIntarc(session.dsn)>
<cfset Ecodigo      =  1>

<cfquery datasource="#session.dsn#">
	insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, Ocodigo,	Mcodigo, INTMOE, INTCAM, INTMON	)
	select 
		'CCFC',1,'JMA','JMA','D','JMA',
		<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
		(select convert(numeric, Pvalor) from Parametros where Pcodigo = 30 and Ecodigo = #Ecodigo#),
		(select convert(numeric, Pvalor) from Parametros where Pcodigo = 40 and Ecodigo = #Ecodigo#),
		(select MIN(Ccuenta) from CContables where Cmovimiento = 'S' and Ecodigo = #Ecodigo#),
		(select MAX(Ocodigo) from Oficinas where Ecodigo = #Ecodigo#),
		(select MAX(Mcodigo) from Monedas where Miso4217 = 'CRC' and Ecodigo = #Ecodigo#),
		 100,1,100
	from dual
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #INTARC# ( 	
		INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, Ocodigo,	Mcodigo, INTMOE, INTCAM, INTMON)
	select INTORI, INTREL, INTDOC, INTREF, 'C', INTDES, INTFEC, Periodo, Mes, Ccuenta, Ocodigo,Mcodigo, INTMOE, INTCAM, INTMON from #INTARC#
</cfquery>

<cfquery datasource="#session.dsn#" name="rsSql">
	select INTORI, INTREL, INTDOC, INTREF, INTTIP, INTDES, INTFEC, Periodo, Mes, Ccuenta, Ocodigo,	Mcodigo, INTMOE, INTCAM, INTMON from #INTARC#
</cfquery>

<cfinvoke component= "sif.Componentes.CG_GeneraAsiento" method= "GeneraAsiento" returnvariable= "LvarIDcontable">
	<cfinvokeargument name="Ecodigo"		value="#Ecodigo#"/>
	<cfinvokeargument name="Eperiodo"		value="#rsSql.Periodo#"/>
	<cfinvokeargument name="Emes"			value="#rsSql.Mes#"/>
	<cfinvokeargument name="Efecha"			value="#NOW()#"/>
	<cfinvokeargument name="Oorigen"		value="#rsSql.INTORI#"/>
	<cfinvokeargument name="Edocbase"		value="#rsSql.INTDOC#"/>
	<cfinvokeargument name="Ereferencia"	value="#rsSql.INTREF#"/>						
	<cfinvokeargument name="Edescripcion"	value="JMA"/>
	<cfinvokeargument name="Ocodigo"		value="#rsSql.Ocodigo#"/>
</cfinvoke>
<cfdump var="Proceso Generado: #LvarIDcontable#">
