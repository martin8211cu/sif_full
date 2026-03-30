<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfquery name="lista" datasource="#session.DSN#">
	select a.PVCajaCFid, c.FAM01CODD #_Cat# '-' #_Cat# c.FAM01DES as caja,b.CFcodigo #_Cat# '-' #_Cat# b.CFdescripcion as CentroFuncional
	  from CajaCentroFuncional a
	     inner join CFuncional b
			on a.CFid = b.CFid
		 inner join FAM001 c
		 	on a.FAM01COD = c.FAM01COD
	where a.Ecodigo = #session.Ecodigo#
</cfquery>

<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
	<cfinvokeargument name="query" 				value="#lista#"/>
	<cfinvokeargument name="desplegar" 			value="caja,CentroFuncional"/>
	<cfinvokeargument name="etiquetas" 			value="Caja, Centro Funcional"/>
	<cfinvokeargument name="formatos" 			value="V, V"/>
	<cfinvokeargument name="align" 				value="left, left"/>
	<cfinvokeargument name="ajustar" 			value="N"/>
	<cfinvokeargument name="irA" 				value="PV_CFporCaja.cfm"/>
	<cfinvokeargument name="keys" 				value="PVCajaCFid"/>
	<cfinvokeargument name="showemptylistmsg"	value="true"/>
</cfinvoke>
