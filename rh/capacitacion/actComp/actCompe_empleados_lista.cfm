<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion"
	Default="Debe seleccionar al menos un registro para relizar esta acción"
	returnvariable="MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaEliminarDeLaEvaluacionLosEmpleadosMarcados"
	Default="Desea eliminar de la evaluación, los empleados marcados"
	returnvariable="MSG_DeseaEliminarDeLaEvaluacionLosEmpleadosMarcados"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NOSEHANAGREGADOEMPLEADOSPARAESTARELACION"
	Default="NO SE HAN AGREGADO EMPLEADOS PARA ESTA RELACION"
	returnvariable="MSG_NOSEHANAGREGADOEMPLEADOSPARAESTARELACION"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Empleado"
	Default="Empleado"
	returnvariable="LB_Empleado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Nombre"
	Default="Nombre"
	returnvariable="LB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificaci&oacute;n"
	returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListaDeEmpleados"
	Default="Lista de Empleados"
	returnvariable="LB_ListaDeEmpleados"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_HayEmpleadosQueYaHanSidoEvaluadosDeseaContinuar"
	Default="Hay empleados que ya han sido evaluados. Desea continuar?"
	returnvariable="MSG_HayEmpleadosQueYaHanSidoEvaluadosDeseaContinuar"/>	
<!--- FIN VARIABLES DE TRADUCCION --->
﻿<cfparam name="form.RHRCid" type="numeric">
<link href="STYLE.CSS" rel="stylesheet" type="text/css">

<cfif isdefined('form.RHRCid') and form.RHRCid NEQ ''>
	<cfquery name="rsForm" datasource="#session.dsn#">
		select RHRCestado
		from RHRelacionCalificacion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHRCid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#"> 
	</cfquery>
</cfif>
<form action="actCompetencias.cfm" method="post" name="lista">
	<input type="hidden" name="SEL" value="5">
	<input type="hidden" name="RHRCid" value="<cfoutput>#form.RHRCid#</cfoutput>">
	<input type="hidden" name="BOTON" value="">
	<input type="hidden" name="Elimina" value="0">
	<table width="90%" align="center"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td colspan="4">
				<cf_dbfunction name="to_char" args="b.DEid" returnvariable="Lvar_to_char_DEid">
				<cfinvoke 
				component="rh.Componentes.pListas"
				method="pListaRH"
				returnvariable="pListaRel">
					<cfinvokeargument name="tabla" value="RHEmpleadosCF  a
															inner join DatosEmpleado b
																on b.DEid = a.DEid
															inner join DatosEmpleado b1
																on b1.DEid = a.DEidJefe
																and b1.Ecodigo = a.Ecodigo
															inner join CFuncional e
																on e.CFid = a.CFid
																and e.Ecodigo = a.Ecodigo
															inner join RHEvaluadoresCalificacion f
																on f.RHRCid = a.RHRCid
																and f.DEid =  a.DEidJefe"/>
					<cfinvokeargument name="columnas" value="a.DEid as DEidEmp
															,a.DEidJefe as Eval
															,b.DEidentificacion
															,{fn concat(b.DEnombre,{fn concat(' ',{fn concat(b.DEapellido1,{fn concat(' ',b.DEapellido2)})})})} as Empleado
															,{fn concat(b1.DEnombre,{fn concat(' ',{fn concat(b1.DEapellido1,{fn concat(' ',b1.DEapellido2)})})})} as Evaluador
															,a.CFid
															,{fn concat(e.CFcodigo,{fn concat(' - ',e.CFdescripcion)})} as CentroFuncional
															,RHECestado
															,case RHECestado when 10 then 
																'<img src=''/cfmx/rh/imagenes/Excl16.gif'' alt=''El empleado ya fue calificado'' />'
															 else 
															 	 ''
															 end  as Calif
										"/>
					<cfinvokeargument name="desplegar" value="DEidentificacion,Empleado,Calif"/>
					<cfinvokeargument name="etiquetas" value="#LB_Identificacion#,#LB_Empleado#, "/>
					<cfinvokeargument name="formatos" value="S,S,S"/>
					<cfinvokeargument name="filtro" value="a.Ecodigo=#session.Ecodigo#
															and a.RHRCid = #form.RHRCid#
															order by Eval,a.CFid"/>
					<cfinvokeargument name="align" value="left,left,right"/>
					<cfinvokeargument name="ajustar" value=""/>				
					<cfinvokeargument name="irA" value="actCompetencias.cfm"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="debug" value="N"/>
					<cfinvokeargument name="maxRows" value="30"/>
					<cfinvokeargument name="keys" value="DEidEmp,RHECestado"/>
					<cfinvokeargument name="cortes" value="Evaluador,CentroFuncional"/>
					<cfinvokeargument name="checkboxes" value="D">
					<cfinvokeargument name="mostrar_filtro" value="true"/>
					<cfinvokeargument name="filtrar_automatico" value="true"/>
					<cfinvokeargument name="filtrar_por" value="b.DEidentificacion|{fn concat(b.DEnombre,{fn concat(' ',{fn concat(b.DEapellido1,{fn concat(' ',b.DEapellido2)})})})}| "/>
					<cfinvokeargument name="filtrar_por_delimiters" value="|"/>
					<cfinvokeargument name="EmptyListMsg" value="#MSG_NOSEHANAGREGADOEMPLEADOSPARAESTARELACION#"/>
					<cfinvokeargument name="showlink" value="false"/>
					<cfinvokeargument name="botones" value="Anterior,Eliminar,Siguiente"/>
					<cfinvokeargument name="checkbox_function" value="funcValida(this)"/>
					
			</cfinvoke>	
			</td>
		</tr>
		<tr><td colspan="4">&nbsp;</td></tr>  
		<!--- <tr>
	  		<td colspan="4" align="center">
				<!--- Solo se pueden eliminar evaluadores si la relacion esta en Proceso --->		
				<cf_botones values="Anterior,Siguiente" names="Anterior,Siguiente" nbspbefore="4" nbspafter="4" tabindex="2" formname="lista">
			</td>
		</tr> --->
	</table>
</form>	
	<script language="javascript" type="text/javascript">
		function funcAnterior(){
			document.lista.SEL.value = "4";
			return true;
		}
		function funcSiguiente(){
			document.lista.SEL.value = "6";
			return true;
		}
		function hayMarcados(){
			var form = document.lista;
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
			if (!result) alert('¡<cfoutput>#MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion#</cfoutput>!');
			return result;
		}
		

		function funcSel(){
			document.lista.SEL.value = "5";
			document.lista.submit();
			return true;
		}
		
		function funcEliminar(){
			var form = document.lista;
			var msg = "¿<cfoutput>#MSG_DeseaEliminarDeLaEvaluacionLosEmpleadosMarcados#</cfoutput>?";
			var msgEval = "<cfoutput>#MSG_HayEmpleadosQueYaHanSidoEvaluadosDeseaContinuar#</cfoutput>"
			
			if (form.Elimina.value == 1) result = (hayMarcados()&&confirm(msg)&&confirm(msgEval));
			else result = (hayMarcados()&&confirm(msg));
			if (result) {
				form.action = "actCompe_empleados_listaSQL.cfm";
				form.BOTON.value = 'Eliminar';
				form.submit();				
			}
			return false;
		}
		function funcAgregar(){
			var empl = document.lista.LDEidentificacion.value;
			if (empl != ''){
				if (confirm("Desea agregar este Empleado?")) {
					document.lista.BOTON.value = 'Agregar';		
					document.lista.action = "actCompe_empleados_listaSQL.cfm";
					document.lista.RHRCid.value = "<cfoutput>#form.RHRCid#</cfoutput>";
					document.lista.submit();
				}
				return false;	
			}else{
				alert('Debe seleccionar un empleado.');
				return false;
			}
		}
		function funcValida(chk){
			var empleado = chk.value.split("|");
			if (empleado[1] == 10 && chk.checked) {
				alert('El empleado ya ha sido calificado.');
				document.lista.Elimina.value = 1;
			}
			return true;
		}
	</script>