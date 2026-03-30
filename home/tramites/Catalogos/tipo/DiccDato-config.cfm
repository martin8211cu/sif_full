<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>
<cfset modo = "ALTA">

<cfparam name="Url.tab" default="0">
<cfif isdefined("Url.tab") and Len(Trim(Url.tab)) and not isdefined("Form.tab")>
	<cfset Form.tab = Url.tab>
</cfif>

<cfif isdefined("Url.id_tipo") and Len(Trim(Url.id_tipo)) and not isdefined("Form.id_tipo")>
	<cfset Form.id_tipo = Url.id_tipo>
</cfif>

<cfif isdefined("Form.id_tipo") and Len(Trim(Form.id_tipo))>
	<cfset modo = "CAMBIO">
</cfif>

<cfif modo EQ "CAMBIO">
	<cfquery name="rsTipoDato" datasource="#session.tramites.dsn#">
		select 	id_tipo,
				nombre_tipo, 
				descripcion_tipo,
				case when clase_tipo = 'S' then 'Simple'
					 when clase_tipo = 'L' then 'Lista Valores'
					 when clase_tipo = 'T' then 'Concepto Interno'
					 when clase_tipo = 'C' then 'Complejo'
					 else ''
				end as clase,
				case when clase_tipo = 'S' and tipo_dato = 'F' then 'Fecha'
					 when clase_tipo = 'S' and tipo_dato = 'N' then 'N&uacute;mero'
					 when clase_tipo = 'S' and tipo_dato = 'B' then 'S&iacute;/No'
					 when clase_tipo = 'S' and tipo_dato = 'S' then 'Alfanum&eacute;rico'
					 when clase_tipo = 'L' then 'Lista Valores'
					 when clase_tipo = 'C' then 'Complejo'
					 when clase_tipo = 'T' then 'Concepto Interno: ' || nombre_tabla
					 else null
				end 
				||
				case when clase_tipo = 'S' and tipo_dato = 'N' and longitud is not null then '(' || <cf_dbfunction name="to_char" args="longitud">
					 when clase_tipo = 'S' and tipo_dato = 'S' and longitud is not null then '(' || <cf_dbfunction name="to_char" args="longitud">
					 else null
				end 
				||
				case when clase_tipo = 'S' and tipo_dato = 'N' and escala is not null then ',' || <cf_dbfunction name="to_char" args="escala">
					 when clase_tipo = 'S' and tipo_dato = 'S' and escala is not null then ',' || <cf_dbfunction name="to_char" args="escala">
					 else null
				end 
				||
				case when clase_tipo = 'S' and tipo_dato = 'N' and longitud is not null then ')'
					 when clase_tipo = 'S' and tipo_dato = 'S' and longitud is not null then ')'
					 else null
				end as tipo,
				clase_tipo,
				tipo_dato,
				longitud,
				escala,
				mascara, 
				formato,
				valor_minimo,
				valor_maximo,
				nombre_tabla
		from DDTipo
		where id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tipo#">
		and es_documento = 0
	</cfquery>
	<cfset titulo = "Tipo Dato: " & rsTipoDato.nombre_tipo & Iif(Len(Trim(rsTipoDato.tipo)), DE(" - "), DE("")) & rsTipoDato.tipo>
</cfif>
