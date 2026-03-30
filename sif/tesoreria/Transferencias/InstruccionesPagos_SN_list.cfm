<cfquery datasource="#session.dsn#" name="rsEmpresaCorporativa">
	select count(1) as cantidad
	  from TESempresas
	 where TESid 	= #session.tesoreria.TESid#
	   and Ecodigo 	= #session.EcodigoCorp#
</cfquery>
<cfquery datasource="#session.dsn#" name="lista">
	select 	'SN' as Tipo, 
			a.SNidentificacion as Identificacion, 
			a.SNnombre as Nombre, 
			coalesce(a.SNidCorporativo,a.SNid) as ID
			,(select count(1) from TEStransferenciaP where SNidP = a.SNid and TESTPestado<>2) as ctas
            ,Edescripcion 
	  from SNegocios a
		inner join TESempresas b
			 on b.TESid = #session.tesoreria.TESid#
			and b.Ecodigo = a.Ecodigo
        left join Empresas c
			on c.Ecodigo= b.Ecodigo    
	 where 1 = 1
	<cfif isdefined("form.Fidentificacion") and len(trim(form.Fidentificacion))>
	   and upper(SNidentificacion) like '%#ucase(form.Fidentificacion)#%'
	</cfif>
	<cfif isdefined("form.Fnombre") and len(trim(form.Fnombre))>
	   and upper(SNnombre) like '%#ucase(form.Fnombre)#%'
	</cfif>
<!---
	 where a.SNidCorporativo is null
	<cfif isdefined("form.Fidentificacion") and len(trim(form.Fidentificacion))>
	   and upper(SNidentificacion) like '%#ucase(form.Fidentificacion)#%'
	</cfif>
	<cfif isdefined("form.Fnombre") and len(trim(form.Fnombre))>
	   and upper(SNnombre) like '%#ucase(form.Fnombre)#%'
	</cfif>
<cfif rsEmpresaCorporativa.Cantidad EQ 0>
  UNION
	select 'SNC', a.SNidentificacion, a.SNnombre, a.SNid
			,(select count(1) from TEStransferenciaP where SNidP = a.SNid and TESTPestado<>2) as ctas
	from SNegocios a
		inner join SNegocios e
			inner join TESempresas b
				 on b.TESid = #session.tesoreria.TESid#
				and b.Ecodigo = e.Ecodigo
			 on e.SNidCorporativo = a.SNid
	 where a.SNidCorporativo is null
	<cfif isdefined("form.Fidentificacion") and len(trim(form.Fidentificacion))>
	   and upper(a.SNidentificacion) like '%#ucase(form.Fidentificacion)#%'
	</cfif>
	<cfif isdefined("form.Fnombre") and len(trim(form.Fnombre))>
	   and upper(a.SNnombre) like '%#ucase(form.Fnombre)#%'
	</cfif>
</cfif>
--->
	order by Identificacion, Nombre
</cfquery>
<cf_web_portlet_start border="true" titulo="Lista de Socios de Negocio" skin="#Session.Preferences.Skin#" width="100%">
	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
		query="#lista#"
		desplegar="Identificacion, Nombre, Edescripcion, ctas"
		etiquetas="Identificación, Nombre, Empresa, Ctas"
		formatos="S,S,S,S"
		align="left,left,left,center"
		ajustar="yes"
		showEmptyListMsg="yes"
		ira="InstruccionesPagos.cfm"
		form_method="get"
		navegacion="#navegacion#"
		keys="ID"
	/>		

	<cf_web_portlet_end>