<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
	<cfset form.Pagina = url.Pagina>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
	<cfset form.Pagina = url.PageNum_Lista>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
	<cfset form.Pagina = form.PageNum>
</cfif>		

<cfif isdefined('url.filtro_TJlogin') and not isdefined('form.filtro_TJlogin')>
	<cfset form.filtro_TJlogin = url.filtro_TJlogin>
</cfif>
<cfif isdefined('url.filtro_TJestado') and not isdefined('form.filtro_TJestado')>
	<cfset form.filtro_TJestado = url.filtro_TJestado>
</cfif>
<cfif isdefined('url.filtro_TJuso') and not isdefined('form.filtro_TJuso')>
	<cfset form.filtro_TJuso = url.filtro_TJuso>
</cfif>
<cfif isdefined('url.filtro_TJvigencia') and not isdefined('form.filtro_TJvigencia')>
	<cfset form.filtro_TJvigencia = url.filtro_TJvigencia>
</cfif>
<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">


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

<cfquery name="rsAgente" datasource="#session.DSN#">
	Select AGid
		, (p.Pnombre || ' ' || p.Papellido || ' ' || p.Papellido2) as NombreAgente
	from ISBagente a
		inner join ISBpersona p
			on p.Pquien=a.Pquien
				and p.Ecodigo=p.Ecodigo
	where a.Pquien =#session.saci.persona.id#
		and a.Ecodigo=#session.Ecodigo#
</cfquery>

<cfif isdefined('rsAgente') and rsAgente.recordCount GT 0>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td width="6%" align="right" class="menuhead" nowrap><label>Agente : </label></td>
		<td width="94%" class="menuhead">&nbsp;&nbsp;<cfoutput>#rsAgente.NombreAgente#</cfoutput></td>
	  </tr>
	  <tr>
		<td colspan="2"><hr></td>
	  </tr>
	</table>
</cfif>


<cfinvoke component="sif.Componentes.pListas" method="pLista"
	tabla="ISBprepago pre
			inner join ISBagente a
				on a.AGid=pre.AGid
					and a.Pquien = #session.saci.persona.id#"
	columnas="	TJid
				, pre.TJlogin 
				, pre.TJuso
				, pre.TJvigencia
				, case pre.TJestado
					when '0' then 'Generada'
					when '1' then 'Activa'
					when '2' then 'En Uso'
					when '3' then 'Consumida'
					when '4' then 'Vencida'
					when '5' then 'Bloqueada'
					when '6' then 'Anulada'
				end TJestado
				, '' as espacio
				#preservesinglequotes(campos_extra)#"
	filtro=" 1=1
			order by pre.TJlogin"
	desplegar="TJlogin, TJestado, TJuso, TJvigencia, espacio"
	etiquetas="Log&iacute;n, Estado, Primer Uso, Vigencia, "
	formatos="V,V,D,I,U"
	align="left,center,center,Right,center"
	rsTJestado="#rsTJestado#"
	ira="ventaPrepagos.cfm"
	form_method="post"
	showLink="true"
	keys="TJid"
	maxRows="5"
	maxRowsQuery="250"		
	mostrar_filtro="yes"
	filtrar_por="pre.TJlogin,pre.TJestado,pre.TJuso,pre.TJvigencia,espacio"
	filtrar_automatico="yes"
/>