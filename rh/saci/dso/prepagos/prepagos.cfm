
<cf_templateheader title="Administraci&oacute;n de Prepagos">
	
<cf_web_portlet_start titulo="Administraci&oacute;n de Prepagos">
	<cfinclude template="prepagos-params.cfm">

	<cfset campos_extra = '' >
	<cfif isdefined("form.Pagina")>
		<cfset campos_extra = ",'#form.Pagina#' as Pagina" >
	</cfif>		

	<cfquery name="rsTJestado" datasource="#session.DSN#">
			select '-1' as value
				, '--Todos--' as description
		union 		
			select '0' as value
				, 'Generada' as description
		union 		
			select '1' as value
				, 'Activa' as description
		union 		
			select '2' as value
				, 'En Uso' as description
		union 		
			select '3' as value
				, 'Consumida' as description
		union 		
			select '4' as value
				, 'Vencida' as description
		union 		
			select '5' as value
				, 'Bloqueada' as description
		union 		
			select '6' as value
				, 'Anulada' as description
		union 		
			select '7' as value
				, 'Bloqueada por Spam' as description
		order by value
	</cfquery>							
	<cfinvoke component="sif.Componentes.pListas" method="pLista"
		tabla="ISBprepago a
				left outer join ISBagente ag
					on ag.AGid=a.AGid
						and ag.Ecodigo=#session.Ecodigo#
				left outer join ISBpersona p
					on p.Pquien=ag.Pquien"
		columnas="	a.TJid,
					a.TJlogin, 
					a.TJuso,
					coalesce(a.TJvigencia,0) as TJvigencia,
					case a.TJestado
								when '0' then 'Generada'
								when '1' then 'Activa'
								when '2' then 'En Uso'
								when '3' then 'Consumida'
								when '4' then 'Vencida'
								when '5' then 'Bloqueada'
								when '6' then 'Anulada'
								when '7' then 'Bloqueada por Spam'
					end descTJestado,
					a.TJestado,
					(p.Pnombre || ' ' || Papellido || ' ' || Papellido2) as nombreAgente,
					'' as espacio
					#preservesinglequotes(campos_extra)#"
		filtro=" 1=1
				order by TJlogin"
		desplegar="TJlogin,nombreAgente,descTJestado,TJuso,TJvigencia,espacio"
		etiquetas="Login,Agente,Estado,Primer Uso,Vigencia, "
		formatos="S,S,S,D,I,U"
		align="left,left,left,left,Right,Right"
		rsdescTJestado="#rsTJestado#"
		ira="prepagos-edit.cfm"
		form_method="post"
		showLink="true"
		keys="TJid"
		botones="Administración_Masiva"
		maxRows="14"
		debug="N"
		maxRowsQuery="250"		
		mostrar_filtro="yes"
		filtrar_por_array="#ListToArray('a.TJlogin~p.Pnombre||Papellido||Papellido2~a.TJestado~TJuso~coalesce(a.TJvigencia,0)~espacio','~')#"
		filtrar_automatico="yes"
	/>
	
<cf_web_portlet_end>
<cf_templatefooter>

<cfoutput>
	<script language="javascript" type="text/javascript">
		function funcAdministración_Masiva(){
			var params = "";
			<cfif isdefined("form.Pagina") and len(trim(form.Pagina))>
				params = params + "&Pagina=#form.Pagina#";
			</cfif>			
			<cfif isdefined("form.filtro_TJlogin") and len(trim(form.filtro_TJlogin))>
				params = params + "&filtro_TJlogin=#form.filtro_TJlogin#";		
			</cfif>
			<cfif isdefined("form.filtro_descTJestado") and len(trim(form.filtro_descTJestado))>
				params = params + "&filtro_descTJestado=#form.filtro_descTJestado#";				
			</cfif>
			<cfif isdefined("form.filtro_nombreAgente") and len(trim(form.filtro_nombreAgente))>
				params = params + "&filtro_nombreAgente=#form.filtro_nombreAgente#";
			</cfif>

			location.href='prepagosMasivo.cfm?1=1' + params;
			return false;
		}
	</script>
</cfoutput>