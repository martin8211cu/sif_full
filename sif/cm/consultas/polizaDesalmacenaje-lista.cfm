<!--- 

		***	LISTA DE PÓLIZAS DE DESALMACENAJE	***
		Principalmente una póliza de desalmacenaje consta de una Orden de compra de la que partió, un 
		Número de Póliza, un socio de negocions (el exportador), una agencia aduanal y una aduana, tiene muchos campos más pero con estos basta
		para el filtro.

--->
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="rsLEPD" datasource="#session.dsn#">
	select poliza.EPDid, poliza.CMAAid, poliza.Ecodigo, poliza.EPDnumero
		, poliza.SNcodigo, poliza.EPDfecha, poliza.EPDdescripcion, poliza.EPDpaisori
		, poliza.EPDpaisproc, poliza.EPDtotbultos, poliza.EPDpesobruto, poliza.EPDpesoneto
		, poliza.EPDobservaciones, poliza.Usucodigo, poliza.fechaalta 
		, aduanas.CMAid, aduanas.CMAcodigo, aduanas.CMAdescripcion
		, agencia.CMAAid, agencia.CMAAcodigo, agencia.CMAAdescripcion
		, socio.SNcodigo, socio.SNidentificacion, socio.SNtiposocio, socio.SNnombre, socio.SNnumero#_Cat#' - '#_Cat#socio.SNnombre as SNcorte
		, (select count(1) from CMImpuestosPoliza impuestos 
			where impuestos.EPDid = poliza.EPDid and impuestos.Ecodigo = poliza.Ecodigo) as count_impuestos
		, (select count(1) from DPolizaDesalmacenaje detalles 
			where detalles.EPDid = poliza.EPDid and detalles.Ecodigo = poliza.Ecodigo) as count_detalles
	from EPolizaDesalmacenaje poliza
	left outer join CMAduanas aduanas
		on poliza.CMAid = aduanas.CMAid
		and poliza.Ecodigo = aduanas.Ecodigo
	left outer join CMAgenciaAduanal agencia 
		on poliza.CMAAid = agencia.CMAAid
		and poliza.Ecodigo = agencia.Ecodigo
	left outer join SNegocios socio
		on poliza.Ecodigo = socio.Ecodigo 
		and  poliza.SNcodigo = socio.SNcodigo
	where poliza.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and poliza.EPDestado = 10
<cfif len(trim(form.fepdnumero)) gt 0>
		and poliza.EPDnumero like <cfqueryparam cfsqltype="cf_sql_char" value="%#form.fepdnumero#%">
</cfif>
<cfif form.fsncodigo>
		and poliza.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fsncodigo#">
</cfif>
<cfif form.fcmaaid>
		and poliza.CMAAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fcmaaid#">
</cfif>
<cfif form.fcmaid>
		and poliza.CMAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fcmaid#">
</cfif>
</cfquery>
<cfset Aplicar=""><cfif rsLEPD.RecordCount><cfset Aplicar=",Aplicar"></cfif>
<cfinvoke component="sif.Componentes.pListas"	method="pListaQuery" returnvariable="pListaRet">
	<cfinvokeargument name="query" value="#rsLEPD#"/>
	<cfinvokeargument name="cortes" value="SNcorte"/>
	<cfinvokeargument name="desplegar" value="EPDnumero, EPDdescripcion, CMAAdescripcion, CMAdescripcion, EPDtotbultos, EPDpesobruto, EPDpesoneto"/>
	<cfinvokeargument name="etiquetas" value="Número, Descripcion, Agencia Aduanal, Aduana, Bultos, Peso Bruto, Peso Neto"/>
	<cfinvokeargument name="formatos" value="V, S, S, S, V, M, M"/>
	<cfinvokeargument name="align" value="left, left, left, left, right, right, right"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="irA" value="polizaDesalmacenaje.cfm"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="maxRows" value="15"/>
	<cfinvokeargument name="pageindex" value="1"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>