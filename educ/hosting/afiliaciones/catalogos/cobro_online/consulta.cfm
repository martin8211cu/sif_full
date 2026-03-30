
<cf_template>
<cf_templatearea name="title">Cobros Realizados</cf_templatearea>

<cf_templatearea name="body">


<cfquery datasource="#session.dsn#" name="cobros">
	select
		c.id_cobro,
		p.Pnombre, p.Papellido1, p.Papellido2, p.Pid,
		r.nombre_programa,
		v.nombre_vigencia,
		c.fecha_cobro,
		c.importe, c.moneda,
		c.importe - c.pagado as saldo
	from sa_cobros c
		join sa_afiliaciones a
			on  a.id_persona = c.id_persona
			and a.id_programa = c.id_programa
			and a.id_vigencia = c.id_vigencia
		join sa_vigencia v
			on  v.id_programa = c.id_programa
			and v.id_vigencia = c.id_vigencia
		join sa_programas r
			on  r.id_programa = c.id_programa
		join sa_personas p
			on  p.id_persona = c.id_persona
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	  and pagado != 0
	<cfif IsDefined('url.filtro_Pnombre') and Len(url.filtro_Pnombre)>
	  and upper(p.Pnombre) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(url.filtro_Pnombre)#%">
	</cfif>
	<cfif IsDefined('url.filtro_Papellido1') and Len(url.filtro_Papellido1)>
	  and upper(p.Papellido1) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(url.filtro_Papellido1)#%">
	</cfif>
	<cfif IsDefined('url.filtro_Papellido2') and Len(url.filtro_Papellido2)>
	  and upper(p.Papellido2) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(url.filtro_Papellido2)#%">
	</cfif>
	<cfif IsDefined('url.filtro_Pid') and Len(url.filtro_Pid)>
	  and upper(p.Pid) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(url.filtro_Pid)#%">
	</cfif>
	<cfif IsDefined('url.filtro_nombre_programa') and Len(url.filtro_nombre_programa)>
	  and upper(r.nombre_programa) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(url.filtro_nombre_programa)#%">
	</cfif>
	<cfif IsDefined('url.filtro_nombre_vigencia') and Len(url.filtro_nombre_vigencia)>
	  and upper(v.nombre_vigencia) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(url.filtro_nombre_vigencia)#%">
	</cfif>
	<cfif IsDefined('url.filtro_fecha_cobro') and Len(url.filtro_fecha_cobro)>
	  and c.fecha_cobro >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.filtro_fecha_cobro)#">
	</cfif>
	order by c.id_cobro desc
</cfquery>

<cfinvoke component="sif.rh.Componentes.pListas" method="pListaQuery"
	query="#cobros#"
	desplegar="Pnombre,Papellido1,Papellido2,Pid,nombre_programa,nombre_vigencia,fecha_cobro,moneda,importe,saldo"
	etiquetas="Nombre,Apellidos, ,C&eacute;dula,Programa,Vigencia,Fecha, ,Importe,Saldo"
	align="left,left,left,left,left,left,left,right,right,right"
	formatos="S,S,S,S,S,S,D,S,M,M"
	mostrar_filtro="yes"
	irA="consulta2.cfm"
	form_method="get"
	showEmptyListMsg="true"
	totales="importe,saldo"
	EmptyListMsg="<h2>No se encontraron cobros</h2>" >
<script type="text/javascript">
<!--
	document.lista.filtro_Pnombre.focus();
//-->
</script>


</cf_templatearea>
</cf_template>
