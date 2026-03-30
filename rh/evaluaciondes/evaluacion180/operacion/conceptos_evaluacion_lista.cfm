<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ConCompromiso"
	Default="Con Compromiso"
	returnvariable="LB_ConCompromiso"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Todos"
	Default="Todos"
	returnvariable="LB_Todos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_NoAplica"
	Default="No Aplica"
	returnvariable="LB_NoAplica"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Aplica"
	Default="Aplica"
	returnvariable="LB_Aplica"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Concepto"
	Default="Concepto"
	returnvariable="LB_Concepto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_PesoEmpleado"
	Default="Peso Empleado"
	returnvariable="LB_PesoEmpleado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_PesoJefe"
	Default="Peso Jefe"
	returnvariable="LB_PesoJefe"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_AplicSobre100"
	Default="Aplic. sobre 100%"
	returnvariable="LB_AplicSobre100"/>


<!--- FIN VARIABLES DE TRADUCCION --->
<!---QUERY PARA EL FILTRO DE LA LISTA, PARA EL CAMPO HABILITADO--->
<cfset rsIREsobrecien = queryNew("value,description","Integer,Varchar")>
<cfset queryAddRow(rsIREsobrecien,3)>
<cfset querySetCell(rsIREsobrecien,"value","",1)>
<cfset querySetCell(rsIREsobrecien,"description","#LB_Todos#",1)>
<cfset querySetCell(rsIREsobrecien,"value",0,2)>
<cfset querySetCell(rsIREsobrecien,"description","#LB_NoAplica#",2)>
<cfset querySetCell(rsIREsobrecien,"value",1,3)>
<cfset querySetCell(rsIREsobrecien,"description","#LB_Aplica#",3)>

<!--- <cfquery datasource="#session.dsn#" name="rsIREsobrecien">
	select '' as value, '-- #LB_Todos# --' as description, '0' as ord 
	union
	select '0' as value, '#LB_NoAplica#' as description, '1' as ord
	union
	select '1' as value, '#LB_Aplica#' as description, '2' as ord
	order by 3,2
</cfquery>	 --->

<cfset check1 = "<img src=''/cfmx/saci/images/w-check.gif'' border=''0'' title=''"&#LB_ConCompromiso#&"''>">
<!--- Lista --->
<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaRH">
	<cfinvokeargument name="tabla" value="RHIndicadoresRegistroE ir
											inner join RHIndicadoresAEvaluar ie
												on ie.Ecodigo=ir.Ecodigo
													and ie.IAEid=ir.IAEid"/>
	<cfinvokeargument name="columnas" value=" ir.IREid, 
											ir.REid, 
											ir.IREpesop,
											ir.IREpesojefe,
											case ir.IREsobrecien
												when 0 then ' '
												when 1 then '#check1#'
											end IREsobrecien, 
											ie.IAEdescripcion,
											3 as SEL,
											'#form.Estado#' as Estado"/>
	<cfinvokeargument name="desplegar" value="IAEdescripcion,IREpesop,IREpesojefe,IREsobrecien"/>
	<cfinvokeargument name="etiquetas" value="#LB_Concepto#,#LB_PesoEmpleado#,#LB_PesoJefe#,#LB_AplicSobre100#"/>
	<cfinvokeargument name="filtro" value=" ir.Ecodigo=#Session.Ecodigo#
											and REid = #form.REid#"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="formatos" value="S,I,I,U"/>
	<cfinvokeargument name="align" value="left,left,left,center"/>
	<cfinvokeargument name="ira" value="registro_evaluacion.cfm">
	<cfinvokeargument name="conexion" value="#session.DSN#"/>
	<cfinvokeargument name="keys" value="IREid"/>
	<cfinvokeargument name="MaxRows" value="20"/>
	<cfinvokeargument name="mostrar_filtro" value="true"/>
	<cfinvokeargument name="filtrar_automatico" value="true"/>
	<cfinvokeargument name="filtrar_por" value="IAEdescripcion,IREpesop,IREpesojefe,IREsobrecien"/>
	<cfinvokeargument name="rsIREsobrecien" value="#rsIREsobrecien#"/>	
</cfinvoke>

<script language="javascript" type="text/javascript">
	function funcFiltrar(){
		document.lista.REID.value = "<cfoutput>#form.REid#</cfoutput>";
		document.lista.SEL.value = 4;
		return true;
	}
</script>