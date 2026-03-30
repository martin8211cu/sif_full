<cfif isdefined("url.Fdesde") and len(trim(url.Fdesde))>
	<cfparam name="form.Fdesde" default="#url.Fdesde#">
</cfif>
<cfif isdefined("url.Fhasta") and len(trim(url.Fhasta))>
	<cfparam name="form.Fhasta" default="#url.Fhasta#">
</cfif>
<cfparam name="form.Fdesde" default="">
<cfparam name="form.Fhasta" default="">
<cfparam name="navegafechas" default="">
<cfparam name="filtrafechas" default="">
<cf_dbfunction name="date_format" args="fechahoramarca,yyyymmdd" returnvariable="fechahoramarcayyyymmdd">
<cfif isdefined("form.Fdesde") and len(trim(form.Fdesde))>
	<cfset navegafechas = navegafechas & "&Fdesde=#form.Fdesde#">
	<cfset filtrafechas = filtrafechas & " and fechahoramarca >= #LSparseDateTime(form.Fdesde)#">
</cfif>
<cfif isdefined("form.Fhasta") and len(trim(form.Fhasta))>
	<cfset navegafechas = navegafechas & "&Fhasta=#form.Fhasta#">
	<cfset filtrafechas = filtrafechas & " and fechahoramarca <= #DateAdd('s',-1,DateAdd('d',1,LSparseDateTime(form.Fhasta)))#">
</cfif>
<form name="lista" action="delmarcas-sql.cfm" method="post" style="margin:0">
<table border="0" cellpadding="0" cellspacing="0" style="margin:0" width="100%">
<tr>
	<td class="tituloListas">Desde:<td class="tituloListas"><cf_sifcalendario name="Fdesde" value="#form.Fdesde#" form="lista">
	<td class="tituloListas">Hasta:<td class="tituloListas"><cf_sifcalendario name="Fhasta" value="#form.Fhasta#" form="lista">
	<td width="100%"class="tituloListas">&nbsp;</td>
</tr>
</table>
<cf_dbfunction name="date_part" args="hh,fechahoramarca" returnvariable="datepart_fechahoramarcahh">
<cf_dbfunction name="date_part" args="mi,fechahoramarca" returnvariable="datepart_fechahoramarcami">
<cf_dbfunction name="mod" args="(#datepart_fechahoramarcahh#)|12" returnvariable="mod_fechahoramarcahh" delimiters="|">
<cf_dbfunction name="to_char" args="(#mod_fechahoramarcahh#)" returnvariable="to_char_fechahoramarcahh">
<cf_dbfunction name="to_char" args="#datepart_fechahoramarcami#" returnvariable="to_char_fechahoramarcami">
<cfset rsES = QueryNew("value,description","Integer,Varchar")>
<cfset QueryAddRow(rsES,3)>
<cfset QuerySetCell(rsES,"value",-1,1)><cfset QuerySetCell(rsES,"description"," ",1)>
<cfset QuerySetCell(rsES,"value",0,2)><cfset QuerySetCell(rsES,"description","E",2)>
<cfset QuerySetCell(rsES,"value",1,3)><cfset QuerySetCell(rsES,"description","S",3)>
<cfinvoke component="sif.Componentes.Translate" method="Translate" default="ID" returnvariable="LB_ID" key="LB_ID"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" default="Nombre" returnvariable="LB_Nombre" key="LB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" default="Tipo Marca" returnvariable="LB_TipoMarca" key="LB_TipoMarca"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" default="Fecha" returnvariable="LB_Fecha" key="LB_Fecha"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" default="Hora" returnvariable="LB_Hora" key="LB_Hora"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" default="Eliminar" returnvariable="BTN_Eliminar" key="BTN_ELIMINAR"/>
<cfinvoke component="rh.Componentes.pListas" method="pListaRH"
		columnas="RHCMid,DEidentificacion,
				{ fn concat(DEnombre, { fn concat(' ', { fn concat(DEapellido1, { fn concat(' ', DEapellido2)})})})} as DEempleado,
				fechahoramarca,
				tipomarca,
				{ fn concat(right(	{ fn concat('0',rtrim(#PreserveSingleQuotes(to_char_fechahoramarcahh)#))},2) ,
				{ fn concat(':' ,
				{ fn concat(right(	{ fn concat('0',rtrim(#PreserveSingleQuotes(to_char_fechahoramarcami)#))},2) ,
				case when #PreserveSingleQuotes(datepart_fechahoramarcahh)# / 12 = 0 then ' AM' else ' PM' end
				)})})} as horamarca"
		tabla="RHControlMarcas a
				inner join DatosEmpleado b
				on b.DEid = a.DEid"
		filtro="a.Ecodigo = #session.Ecodigo#
				and numlote is null
				#filtrafechas#
				order by DEidentificacion, fechahoramarca"
		desplegar="DEidentificacion, DEempleado, tipomarca, fechahoramarca, horamarca"
		etiquetas="#LB_ID#, #LB_Nombre#, #LB_TipoMarca#, #LB_Fecha#, #LB_Hora#"
		formatos="S, S, S, D, US"
		align="left, left, left, left, left"
		ajustar="S"
		filtrar_por="DEidentificacion|
				{ fn concat(DEnombre, { fn concat(' ', { fn concat(DEapellido1, { fn concat(' ', DEapellido2)})})})}|
				case tipomarca when 'E' then 0 else 1 end|
				fechahoramarca|''"
		filtrar_por_delimiters="|"
		irA="delmarcas-sql.cfm"
		checkboxes="S"
		botones="#BTN_Eliminar#"
		keys="RHCMid"
		showLink="false"
		mostrar_filtro="true"
		filtrar_automatico="true"
		rstipomarca="#rsES#"
		navegacion="#navegafechas#"
		incluyeform="false"
	/>
</form>
<script language="javascript" type="text/javascript">
	function funcEliminar(){
		if (fnAlgunoMarcadolista()){
			if (confirm("Desea eliminar la(s) marca(s) seleccionada(s)?")){
				return true;
			}
		}else{
			alert("Debe marcar la(s) marcas(s) por eliminar!");
		}
		return false;
	}
</script>