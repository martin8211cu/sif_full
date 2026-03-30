<cfquery name="admince" datasource="asp">
	select datos_personales
	from Usuario
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	  and admin=1
  </cfquery>
  <cfset admince_mail = 'webmaster@soin.net'>
  <cfif Len(admince.datos_personales)>
	  <cf_datospersonales action="select" key="#admince.datos_personales#" name="admince_dp">
	  <cfif Len(Trim(admince_dp.email1))>
		<cfset admince_mail = admince_dp.email1>
	  </cfif>
  </cfif>
   <p align="justify">
   <cf_translate  key="PIEPAIGNA_EsteEsUnServicioBrindadoPorLaEmpresaSOIN">
  Este es un servicio brindado por la empresa SOIN, Soluciones Integrales.
  SOIN se reserva todos los derechos.  Información o preguntas relacionadas,
  favor comunicarse con: </cf_translate>
  <a href="mailto:<cfoutput>#admince_mail#</cfoutput>">
	<cfoutput>#admince_mail#</cfoutput>
  </a>.</p> 