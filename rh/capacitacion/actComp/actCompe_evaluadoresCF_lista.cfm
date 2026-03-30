
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DebeSeleccionarAlMenosUnRegistroParaRealizarEstaAccion"
	Default="¡Debe seleccionar al menos un registro para realizar esta acci&oacute;n!"
	returnvariable="MSG_DebeSeleccionarAlMenosUnRegistroParaRealizarEstaAccion"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaEliminarLosCentrosFuncionalesMarcadosDelEvaluador"
	Default="Desea eliminar los Centros Funcionales marcados del Evaluador"
	returnvariable="MSG_DeseaEliminarLosCentrosFuncionalesMarcadosDelEvaluador"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="C&oacute;digo"
	xmlfile="/rh/generales.xml"
	returnvariable="LB_Codigo"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	xmlfile="/rh/generales.xml"
	returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NOSEHANAGREGADOCENTROSFUNCIONALESPARAESTEEVALUADOR"
	Default="NO SE HAN AGREGADO CENTROS FUNCIONALES PARA ESTE EVALUADOR"
	returnvariable="MSG_NOSEHANAGREGADOCENTROSFUNCIONALESPARAESTEEVALUADOR"/>	
<!--- FIN VARIABLES DE TRADUCCION --->
<cfif isdefined("Url.CFcodigo_f") and not isdefined("Form.CFcodigo_f")>
	<cfparam name="Form.CFcodigo_f" default="#Url.CFcodigo_f#">
</cfif>
<cfif isdefined("Url.CFdescripcion_f") and not isdefined("Form.CFdescripcion_f")>
	<cfparam name="Form.CFdescripcion_f" default="#Url.CFdescripcion_f#">
</cfif>


<table width="95%" align="center"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td rowspan="7">&nbsp;</td>
		<td colspan="4">&nbsp;</td>
		<td rowspan="7">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="4">
			<cfif isdefined('form.DEid')>
				
				<cfset navegacion = "">
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SEL=4">
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHRCid=" & Form.RHRCid>
				<cfinvoke 
					component="rh.Componentes.pListas"
					method="pListaRH"
					returnvariable="pListaRel">
						<cfinvokeargument name="tabla" 		value="RHEvaluadoresCF ecf
																inner join RHRelacionCalificacion rc
																	on rc.Ecodigo=ecf.Ecodigo
																		and rc.RHRCid=ecf.RHRCid
															
																inner join CFuncional cf
																	on cf.Ecodigo=ecf.Ecodigo
																		and cf.CFid=ecf.CFid"/>
						<cfinvokeargument name="columnas" 	value="'0' as btnEliminar,
																 ecf.DEid, 
																 ecf.RHRCid, 
																 ecf.CFid, 
																 CFcodigo, 
																 CFdescripcion"/>
						<cfinvokeargument name="desplegar" 	value="CFcodigo,CFdescripcion"/>
						<cfinvokeargument name="etiquetas" 	value="#LB_Codigo#, #LB_Descripcion#"/>
						<cfinvokeargument name="formatos" 	value="S,S"/>
						<cfinvokeargument name="filtro" 	value="ecf.Ecodigo=#session.Ecodigo#
																and ecf.RHRCid=#form.RHRCid#
																and ecf.DEid =#form.DEid#"/>
						<cfinvokeargument name="align" 		value="left, left"/>
						<cfinvokeargument name="ajustar" 	value=""/>				
						<cfinvokeargument name="irA"		value="actCompetencias.cfm"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="debug" 		value="N"/>
						<cfinvokeargument name="maxRows" 	value="30"/>
						<cfinvokeargument name="keys" 		value="RHRCid,CFid,DEid"/>
						<cfinvokeargument name="checkboxes" value="D">
						<cfinvokeargument name="mostrar_filtro" 	value="true"/>
						<cfinvokeargument name="filtrar_automatico" value="true"/>
						<cfinvokeargument name="filtrar_por" 	value="CFcodigo,CFdescripcion"/>
						<cfinvokeargument name="EmptyListMsg" 	value="#MSG_NOSEHANAGREGADOCENTROSFUNCIONALESPARAESTEEVALUADOR#"/>
						<cfinvokeargument name="showLink" 		value="false"/>
						<cfinvokeargument name="navegacion" 	value="#navegacion#"/>
						<cfinvokeargument name="botones" 		value="Anterior,Eliminar,Siguiente"/>
					</cfinvoke>	
			</cfif>
		</td>
	</tr>
	<tr><td colspan="4">&nbsp;</td></tr>  
</table>
<script language="javascript" type="text/javascript">
	function hayMarcados(){
		var form = document.form1;
		var result = false;
		if (form.chk!=null) {
			if (form.chk.length){
				for (var i=0; i<form.chk.length; i++){
					if (form.chk[i].checked)
						result = true;
				}
			}
			else{
				if (form.chk.checked)
					result = true;
			}
		}
		if (!result) alert('<cfoutput>#MSG_DebeSeleccionarAlMenosUnRegistroParaRealizarEstaAccion#</cfoutput>');
		return result;
	}
	
	function funcEliminar(){
		var form = document.form1;
		var msg = "¿<cfoutput>#MSG_DeseaEliminarLosCentrosFuncionalesMarcadosDelEvaluador#</cfoutput>?";
		
		result = (hayMarcados()&&confirm(msg));
		if (result) {
			form.action = "actCompe_evaluadoresCF_lista_sql.cfm";
			//form.RHRCID.value = <cfoutput>#FORM.RHRCid#</cfoutput>;
			form.BTNELIMINAR.value = 1;
			form.submit();				
		}
		return false;
	}
</script>