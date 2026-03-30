<cfquery datasource="#session.dsn#" name="rsForm_OBPR">
	select opr.Ecodigo
	     , opr.OBPid
	     , opr.OBPRid
	     , opr.CFformatoRegla
	     , opr.Ocodigo,	o.Oficodigo, o.Odescripcion
	     , opr.BMUsucodigo
	     , opr.ts_rversion

	  from OBproyectoReglas opr
	  	left join Oficinas o
			on o.Ecodigo = opr.Ecodigo
		   and o.Ocodigo = opr.Ocodigo
	 where opr.OBPRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OBPRid#" null="#Len(form.OBPRid) Is 0#">

</cfquery>

<cfoutput>
<form name="form_OBPR" id="form_OBPR" method="post" action="OBproyectoReglas_sql.cfm">
	<table summary="Tabla de entrada">
		<tr>
			<td colspan="2" class="subTitulo">
				Reglas Financieras que deben cumplirse para un proyecto
			</td>
		</tr>

		<cfquery datasource="#session.dsn#" name="rsOBP">
			select p.OBPid, p.OBPcodigo, p.OBPdescripcion, p.PCEcatidObr, p.CFformatoPry
			     , m.PCEMformato
				 , tp.OBTPnivelProyecto, tp.OBTPnivelObra
			  from OBproyecto p
				inner join OBtipoProyecto tp
					inner join PCEMascaras m
					   on m.PCEMid	= tp.PCEMid
					inner join PCECatalogo ec
					   on ec.PCEcatid = tp.PCEcatidPry
					on tp.OBTPid = p.OBTPid
			  where OBPid = #session.obras.OBPid#
		</cfquery>

		<cfif rsForm_OBPR.CFformatoRegla EQ "" or len(rsForm_OBPR.CFformatoRegla) NEQ len(rsOBP.PCEMformato)>
			<cfset LvarRegla_Formato = rsOBP.CFformatoPry & mid(rsOBP.PCEMformato,len(rsOBP.CFformatoPry)+1,100)>
		<cfelse>
			<cfset LvarRegla_Formato = rsOBP.CFformatoPry & mid(rsForm_OBPR.CFformatoRegla,len(rsOBP.CFformatoPry)+1,100)>
		</cfif>
		<cfset LvarRegla_Formato = replace(LvarRegla_Formato,"X","_","ALL")>
		<cfset LvarRegla_Niveles = listToArray(LvarRegla_Formato,"-")>

		<tr>
			<td valign="top">
				<strong>Proyecto</strong>
			</td>
			<td valign="top">
				<strong>#rsOBP.OBPcodigo# - #rsOBP.OBPdescripcion#</strong>
			</td>
		</tr>

		<tr>
			<td valign="top">
				<strong>Regla</strong>
			</td>
			<td valign="top" nowrap="nowrap">
				<cfloop index="LvarIdx" from="1" to="#arrayLen(LvarRegla_Niveles)#"><cfif LvarIdx GT 1>-</cfif><input 
						type="text" name="CFformatoRegla" id="CFformatoRegla" 
						value="#HTMLEditFormat(LvarRegla_Niveles[LvarIdx])#" 
						size="#len(LvarRegla_Niveles[LvarIdx])#"
						maxlength="#len(LvarRegla_Niveles[LvarIdx])#"
					<cfset LvarNiv = LvarIdx - 1>
					<cfif LvarNiv EQ rsOBP.OBTPnivelObra OR (LvarNiv LTE rsOBP.OBTPnivelProyecto AND replace(LvarRegla_Niveles[LvarIdx],"_","","ALL") NEQ "")>
						readonly="yes" style="border:solid 1px ##CCCCCC" tabindex="-1"
					<cfelse>
						onfocus="this.select()"
						onblur="this.value = fnConSubrayado(this.value,#len(LvarRegla_Niveles[LvarIdx])#);"
					</cfif>
				></cfloop>

			</td>
		</tr>

		<tr>
			<td valign="top" nowrap>
				<strong>OficinaPry</strong>
			</td>
			<td valign="top">

				<cf_conlis
					Campos="Ocodigo, Oficodigo, Odescripcion"
					Desplegables="N,S,S"
					Modificables="N,S,N"
					Size="0,10,40"

					traerInicial="#rsForm_OBPR.Ocodigo NEQ ""#" 
					traerFiltro="o.Ocodigo = #rsForm_OBPR.Ocodigo#" 

					Title="Lista de Oficinas del Proyecto"
					Tabla="Oficinas o 
							inner join OBproyectoOficinas po
							   on po.Ecodigo = o.Ecodigo
							  and po.Ocodigo = o.Ocodigo
							  and po.OBPid = #session.obras.OBPid#"
					Columnas="o.Ocodigo, o.Oficodigo, o.Odescripcion"
					Filtro="o.Ecodigo = #session.Ecodigo#"
					Desplegar="Oficodigo, Odescripcion"
					Etiquetas="Codigo,Descripción"
					filtrar_por="Oficodigo, Odescripcion"
					Formatos="S,S"
					Align="left,left"

					Asignar="Ocodigo, Oficodigo, Odescripcion"
					Asignarformatos="S,S,S"
					MaxRowsQuery="200"
					form="form_OBPR"
					index="2"
				/>										
			</td>
		</tr>

		<tr>
			<td colspan="2" class="formButtons">
			<cfif rsForm_OBPR.RecordCount>
				<cf_botones  regresar='OBproyecto.cfm?_' modo='CAMBIO' form="form_OBPR">
			<cfelse>
				<cf_botones  regresar='OBproyecto.cfm?_' modo='ALTA' form="form_OBPR">
			</cfif>
			</td>
		</tr>
	</table>
	<input type="hidden" name="Ecodigo" value="#HTMLEditFormat(rsForm_OBPR.Ecodigo)#">
	<input type="hidden" name="OBPRid" value="#HTMLEditFormat(rsForm_OBPR.OBPRid)#">
	<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(rsForm_OBPR.BMUsucodigo)#">

	<cfset ts = "">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
		artimestamp="#rsForm_OBPR.ts_rversion#" returnvariable="ts">
	</cfinvoke>
	<input type="hidden" name="ts_rversion" value="#ts#">

</form>
</cfoutput>

<script>
	function fnConCeros(LprmHilera, LprmLong)
	{
		if (fnTrim(LprmHilera).length > 0)
		{
			var s = "";
			for (var i=0;i<LprmLong;i++) s=s+"0";
			return fnRight(s + LprmHilera, LprmLong);
		}
		else
			return "";
	}		 
	function fnConSubrayado(LprmHilera, LprmLong)
	{
		LprmHilera = fnTrim(LprmHilera);
		var s = "";
		for (var i=0;i<LprmLong;i++) s=s+"_";
		return (LprmHilera + s).substring(0, LprmLong);
	}		 
	function fnRight(LprmHilera, LprmLong)
	{
		var LvarTot = LprmHilera.length;
		return LprmHilera.substring(LvarTot-LprmLong,LvarTot);
	}		 
	function fnLTrim(LvarHilera)
	{
		return LvarHilera.replace(/^\s+/,'');
	}
	function fnRTrim(LvarHilera)
	{
		return LvarHilera.replace(/\s+$/,'');
	}
	function fnTrim(LvarHilera)
	{
	   return fnRTrim(fnLTrim(LvarHilera));
	}
</script>