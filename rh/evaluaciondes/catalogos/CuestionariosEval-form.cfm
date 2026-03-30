<cfset modo = "ALTA">

<cfif isdefined("form.PCid") and len(trim(form.PCid))>
	<cfset modo = "CAMBIO">
</cfif>


<cfquery name="data" datasource="sifcontrol">
	select PCid, PCcodigo, PCnombre, PCdescripcion, ts_rversion
	from PortalCuestionario
	<cfif modo neq 'ALTA'>
		where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
	</cfif>
</cfquery>


<script language="JavaScript1.2" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<cfoutput>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Codigo"
Default="C&oacute;digo"
xmlfile="/rh/generales.xml"
returnvariable="vCodigo"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Descripcion"
Default="Descripci&oacute;n"
xmlfile="/rh/generales.xml"
returnvariable="vDescripcion"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Nombre"
Default="Nombre"
xmlfile="/rh/generales.xml"
returnvariable="vNombre"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Cuestionario"
Default="Cuestionario"
xmlfile="/rh/generales.xml"
returnvariable="vCuestionario"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Listado_de_Cuestionarios"
Default="Listado de Cuestionarios"
returnvariable="vListado"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_No_se_encontraron_registros"
Default="No se encontraron registros"
xmlfile="/rh/generales.xml"
returnvariable="vNoRegistros"/>


<form style="margin:0;" name="form1" action="CuestionariosEval-sql.cfm" method="post">
	<table align="center" width="100%" cellpadding="2" cellspacing="0" border="0" >
		<tr>
			<td nowrap align="right"><strong>#vCuestionario#: &nbsp;</strong></td>
			<td nowrap>
				<cfset valuesArrayC = ArrayNew(1)>
				<cfif modo neq 'ALTA'>
					<cfset valuesArrayC[1] = data.PCid >
					<cfset valuesArrayC[2] = data.PCcodigo >
					<cfset valuesArrayC[3] = data.PCnombre >
					<cfset valuesArrayC[4] = data.PCdescripcion >
					<cfset modificar = 'N,N,N,N'>
				<cfelse>
					<cfset valuesArrayC[1] = '' >
					<cfset valuesArrayC[2] = '' >
					<cfset valuesArrayC[3] = '' >
					<cfset valuesArrayC[4] = '' >
					<cfset modificar = 'N,S,S,N'>
				</cfif>	

				<cf_conlis
					campos="PCid, PCcodigo, PCnombre, PCdescripcion"
					desplegables="N,S,S,N"
					modificables="#modificar#"
					size="0,10,35,0"
					title="#vListado#"
					tabla="PortalCuestionario"
					columnas="PCid, PCcodigo, PCnombre, PCdescripcion"
					filtro="1=1 order by PCcodigo"
					desplegar="PCcodigo, PCnombre, PCdescripcion"
					filtrar_por="PCcodigo, PCnombre, PCdescripcion"
					etiquetas="#vCodigo#, #vNombre#, #vDescripcion#"
					formatos="S,S,S"
					align="left,left,left"
					asignar="PCid, PCcodigo, PCnombre"
					asignarformatos="S, S, S"
					showEmptyListMsg="true"
					EmptyListMsg="-- #vNoRegistros# --"
					tabindex="1"
					valuesArray="#valuesArrayC#">

				<!---
				<select id="PCid" name="PCid" >
					
					<cfloop query="data">
						<option value="#data.PCid#" <cfif isdefined("form.PCid") and form.PCid EQ data.PCid>selected</cfif>>#data.PCcodigo# - #data.PCdescripcion#</option>
					</cfloop>
					<cfif data.RecordCount EQ 0>
						<option value=" "><cf_translate key="LB_NoFaltanCuestionariosPorAsociar">No Faltan Cuestionarios por Asociar</cf_translate></option>
					</cfif>
				</select>
				--->
			</td>
		</tr>
		<!--- Portles de Botones --->
		<tr>
			<td nowrap colspan="2" align="center">
				<cf_botones modo=#modo# exclude= "Cambio,Limpiar">	
			</td>
		</tr>
	</table>
</form>

<script language="JavaScript1.2" type="text/javascript">	
	qFormAPI.errorColor = "##FFFFCC";
	objForm = new qForm("form1");
	
	<cfif modo EQ 'ALTA'>
		objForm.PCid.required = true;
		objForm.PCid.description="#vCodigo#";
	</cfif>

	

	function deshabilitarValidacion(){
		objForm.PCid.required = false;
	}

</script>
</cfoutput>