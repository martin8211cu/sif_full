<strong>Asignar al departamento:</strong><br>

<cfquery name="rsTipo" datasource="#session.DSN#">
	select MIGMtipodetalle
	from MIGMetricas
	where MIGMid = #form.MIGMID#
</cfquery>

<cfquery name="rsMod" datasource="#session.DSN#">
	select count(1) as si
	from F_Resumen
	where MIGMid = #form.MIGMID#
</cfquery>

<cfif isdefined('form.MIGMID') and len(trim(form.MIGMID))>
	<cfquery datasource="#session.DSN#" name="rsDatosSelect">
		select a.MIGMdetalleid as id, b.Deptocodigo as codigo,b.Ddescripcion as descripcion
		from MIGFiltrosmetricas a
			inner join Departamentos b
			on b.Dcodigo = a.MIGMdetalleid
			and a.Ecodigo = b.Ecodigo
		where MIGMid = #form.MIGMID#
	</cfquery>
</cfif>
<cfset LvarIniciales = 'false'>
<cfset LvarIDR = ''>
<cfif isdefined('rsDatosSelect.id') and rsDatosSelect.id gt 0>
	<cfset LvarIDR = "Dcodigo=#rsDatosSelect.id#">
	<cfset LvarIniciales = 'true'>
</cfif>

<cfoutput>
 <form enctype="multipart/form-data" name="FORMFILTROS" id="FORMFILTROS" method="post" action="MetricasSQL.cfm">
 <input type="hidden" name="pagenum1" id="pagenum1" value="#pagenum#">
 <input name="MIGMID" value="#form.MIGMID#" id="MIGMID"  type="hidden">
 <input name="modificable" value="true" id="modificable"  type="hidden">
 <input name="rfiltro" value="D" id="rfiltro"  type="hidden">

 <input name="valsIn" value="" id="valsIn"  type="hidden">
 <input name="valsOut" value="" id="valsOut"  type="hidden">
 <cfparam name="tabChoice" default="1">
 <input name="tab" value="#tabChoice#" id="tab"  type="hidden">

	<cfif rsMod.si eq 0>
		<cf_conlis title="Lista de Departamentos"
		tabla="Departamentos"
		columnas="Dcodigo, Deptocodigo,Ddescripcion"
		campos = "Dcodigo, Deptocodigo,Ddescripcion"
		desplegables = "N,S,S"
		modificables = "N,S,S"
		filtro="Ecodigo=#session.Ecodigo#"
		desplegar="Deptocodigo,Ddescripcion"
		etiquetas="Codigo,Nombre"
		formatos="S,S"
		align="left,left"
		traerInicial="#LvarIniciales#"
		traerFiltro="#LvarIDR#"
		filtrar_por="Deptocodigo,Ddescripcion"
		tabindex="1"
		size="0,20,60"
		form="FORMFILTROS"
		fparams="Dcodigo"
		/>
		<center><input name="BTNSubmit" type="button" value="Guardar" onclick="javascript: funcBTNSubmitIndicador()"/></center>
	<cfelse>
	<cf_conlis title="Lista de Departamentos"
		tabla="Departamentos"
		columnas="Dcodigo, Deptocodigo,Ddescripcion"
		campos = "Dcodigo, Deptocodigo,Ddescripcion"
		desplegables = "N,S,S"
		modificables = "N,S,S"
		filtro="Ecodigo=#session.Ecodigo#"
		desplegar="Deptocodigo,Ddescripcion"
		etiquetas="Codigo,Nombre"
		formatos="S,S"
		align="left,left"
		traerInicial="#LvarIniciales#"
		traerFiltro="#LvarIDR#"
		filtrar_por="Deptocodigo,Ddescripcion"
		tabindex="1"
		size="0,20,60"
		form="FORMFILTROS"
		fparams="Dcodigo"
		readonly="true"
		/>
	</cfif>

 </form>


<script>
	function funcBTNSubmitIndicador(){
		var f = document.FORMFILTROS;
		var dvalsIn = "";
		if( f.Dcodigo.value == ''){
			alert('Elija el departamento.')
		}else
			{
			f.valsIn.value = f.Dcodigo.value;
			f.submit()
		}
	}
</script>

</cfoutput>