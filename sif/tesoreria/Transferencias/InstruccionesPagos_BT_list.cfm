<cfquery datasource="#session.dsn#" name="lista">
	select 	'BT' as Tipo, 
			a.TESBeneficiarioId as Identificacion, 
			a.TESBeneficiario 		as Nombre, 
			a.TESBid 			as ID,
			case 
				when Ecodigo is not null then 'Empresa'
				when DEid is not null then 'Empleado'
				else 'Contado'
			end as TipoB
	  from TESbeneficiario a
	 where CEcodigo = #session.CEcodigo#
	<cfif isdefined("form.Fidentificacion") and len(trim(form.Fidentificacion))>
	   and upper(TESBeneficiarioId) like '%#ucase(form.Fidentificacion)#%'
	</cfif>
	<cfif isdefined("form.Fnombre") and len(trim(form.Fnombre))>
	   and upper(TESBeneficiario) like '%#ucase(form.Fnombre)#%'
	</cfif>

	<cfif form.TIPO_ESPECIAL EQ 1>
	   and Ecodigo	IS NOT NULL
	<cfelseif form.TIPO_ESPECIAL EQ 2>
	   and DEid		IS NOT NULL
	<cfelseif form.TIPO_ESPECIAL EQ 3>
	   and Bid 		IS NOT NULL
	<cfelseif form.TIPO_ESPECIAL EQ -1>
	   and Ecodigo	IS NULL
	   and DEid		IS NULL
	   and Bid 		IS NULL
	</cfif>
	order by Identificacion, Nombre
</cfquery>
<cf_web_portlet_start border="true" titulo="Lista de Clientes Detallistas" skin="#Session.Preferences.Skin#" width="100%">
	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
		query="#lista#"
		desplegar="Identificacion, Nombre, TipoB"
		etiquetas="Identificación, Nombre, Tipo"
		formatos="S,S,S"
		align="left,left,center"
		ajustar="yes"
		showEmptyListMsg="yes"
		ira="InstruccionesPagos.cfm"
		form_method="get"
		navegacion="#navegacion#"
		keys="ID"
	/>		

	<cf_web_portlet_end>