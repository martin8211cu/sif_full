<cfquery datasource="#session.dsn#" name="lista" maxrows="300">
	select 
		AFTRid,
		Ecodigo,
		AFTRdescripcion,
		AFTRdocumento,
		AFTRfecha,
		case 
		when AFTRtipo = 1 then 'Cambio Valor de Rescate'
		when AFTRtipo = 2 then 'Cambio Descripción'
		when AFTRtipo = 4 then 'Cambio Fecha'
		when AFTRtipo = 3 then 'Cambio Todos'
	end
	 as AFTRtipo
		
	from AFTRelacionCambio ant
	where ant.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and ant.AFTRaplicado = 0

	<cfif isdefined('form.desc') and len(trim(form.desc))>
		and upper(AFTRdescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(form.desc)#%">
	</cfif>

	<cfif isdefined('form.AFTRfecha_F') and len(trim(form.AFTRfecha_F))>
		and ant.AFTRfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.AFTRfecha_F)#">
	</cfif>	

	<cfif isdefined('form.AFTRfecha_I') and len(trim(form.AFTRfecha_I))>
		and ant.AFTRfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.AFTRfecha_I)#">
	</cfif>	

</cfquery>
<cfset form.Nuevo = 1> 
<form name="formx" method="post" action="ValorRescate.cfm" style="margin: '0' ">
</form>
</br>
<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
		query="#lista#"
		desplegar="AFTRdocumento,AFTRdescripcion,AFTRfecha,AFTRtipo"
		etiquetas="N°.Doc,Descripci&oacute;n,Fecha,Tipo"
		formatos="S,S,D,S"
		align="left,left,left,left"
		ira="ValorRescate.cfm" 
		showEmptyListMsg="yes"
		keys="AFTRid"	
		MaxRows="15"
		showLink="yes"
		incluyeForm="yes"
		formName="formx"
		form_method="post"	
		PageIndex="1"
		navegacion="#navegacion#"
	/>		
