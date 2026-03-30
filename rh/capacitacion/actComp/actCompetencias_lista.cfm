<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Descripcion"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Desde"
	Default="Desde"
	returnvariable="LB_Desde"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Hasta"
	Default="Hasta"
	returnvariable="LB_Hasta"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Item"
	Default="Item"
	returnvariable="LB_Item"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Estado"
	Default="Estado"
	returnvariable="LB_Estado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Ambos"
	Default="Ambos"
	returnvariable="LB_Ambos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Conocimientos"
	Default="Conocimientos"
	returnvariable="LB_Conocimientos"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Habilidades"
	Default="Habilidades"
	returnvariable="LB_Habilidades"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_EnProceso"
	Default="En Proceso"
	returnvariable="LB_EnProceso"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Habilitada"
	Default="Habilitada"
	returnvariable="LB_Habilitada"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Terminada"
	Default="Terminada"
	returnvariable="LB_Terminada"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Cerrada"
	Default="Cerrada"
	returnvariable="LB_Cerrada"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Todos"
	Default="Todos"
	returnvariable="LB_Todos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NoSeEncontraronRegistros"
	Default="No se encontraron Registros"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_NoSeEncontraronRegistros"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion"
	Default="Debe seleccionar al menos un registro para relizar esta acción"
	returnvariable="MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_SeMarcaronRelacionesYaHabilitadasLasCualesNoSePermiteHabilitarDeNuevo"
	Default="Se marcaron relaciones ya habilitadas las cuales no se permite habilitar de nuevo"
	returnvariable="MSG_SeMarcaronRelacionesYaHabilitadasLasCualesNoSePermiteHabilitarDeNuevo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_SeMarcaronRelacionesQueNoSePermiteCerrar"
	Default="Se marcaron relaciones que no se permite cerrar"
	returnvariable="MSG_SeMarcaronRelacionesQueNoSePermiteCerrar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_SeMarcaronRelacionesQueNoEstanEnProcesoLasCualesNoSePermiteBorrar"
	Default="Se marcaron relaciones que no están en proceso, las cuales no se permite borrar "
	returnvariable="MSG_SeMarcaronRelacionesQueNoEstanEnProcesoLasCualesNoSePermiteBorrar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaHabilitarLasRelacionesMarcadas"
	Default="Desea habilitar las Relaciones marcadas"
	returnvariable="MSG_DeseaHabilitarLasRelacionesMarcadas"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaCerrarLasRelacionesMarcadas"
	Default="Desea cerrar las Relaciones marcadas "
	returnvariable="MSG_DeseaCerrarLasRelacionesMarcadas"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaEliminarLasRelacionesMarcadas"
	Default="Desea eliminar las Relaciones marcadas "
	returnvariable="MSG_DeseaEliminarLasRelacionesMarcadas"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NoSePuedeHabilitarLaRelacionPorqueNoHayEmpleadosParaEvaluar"
	Default="No se puede habilitar la relación porque no hay empleados para evaluar."
	returnvariable="MSG_NoSePuedeHabilitarLaRelacionPorqueNoHayEmpleadosParaEvaluar"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_NoSePuedeHabilitarLaRelacionPorqueHayEvaluadoresSinEmpleadosAsignados"
	Default="No se puede habilitar la relaci&oacute;n porque hay evaluadores sin empleados asignados."
	returnvariable="MSG_NoSePuedeHabilitarLaRelacionPorqueHayEvaluadoresSinEmpleadosAsignados"/>	

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ExistenEmpleadosConCompentenciasPendientesDeEvaluar"
	Default="Existen empleados con compentencias pendientes de evaluar"
	returnvariable="MSG_ExistenEmpleadosConCompentenciasPendientesDeEvaluar"/>		

<!--- FIN VARIABLES DE TRADUCCION --->


<script language="javascript" type="text/javascript">
	function hayMarcados(btn){
		// btn = 1 - Habilitar
		// btn = 2 - Cerrar
		// btn = 3 - Borrar
		var form = document.listaActCompetencias;
		var result = false;
		var relHabili = false;	
		var relCerrar = false;		
		var relBorrar = false;
		var datos = '';
		var d2 = '';
		
		if (form.chk!=null) {
			if (form.chk.length){
				for (var i=0; i<form.chk.length; i++){
					if (form.chk[i].checked){
						datos = form.chk[i].value.split('|');
						d2 = datos[1];	
						if(btn == 1 && d2 == 10){//Relacion ya habilitada, x lo cual no se puede habilitar de nuevo
							form.chk[i].checked = 0;
							relHabili = true;
						}else{	//Relacion en otro estado que no es el de Proceso, x lo cual no se permite borrar
							if(btn == 2 && (d2 < 10 || d2 > 20)){
								form.chk[i].checked = 0;
								relCerrar = true;
							}else{	//Relacion en otro estado que no es el de Proceso, x lo cual no se permite borrar
								if(btn == 3 && d2 != 0){
									form.chk[i].checked = 0;
									relBorrar = true;
								}
							}
						}
						result = true;
					}
				}
			}
			else{
				if (form.chk.checked){
					datos = form.chk.value.split('|');
					d2 = datos[1];	
					if(btn == 1 && d2 == 10){//Relacion ya habilitada, x lo cual no se puede habilitar de nuevo
						form.chk.checked = 0;
						relHabili = true;
					}else{	//Relacion en otro estado que no es el de Proceso, x lo cual no se permite borrar
						if(btn == 2 && (d2 < 10 || d2 > 20)){
							form.chk.checked = 0;
							relCerrar = true;
						}else{	//Relacion en otro estado que no es el de Proceso, x lo cual no se permite borrar
							if(btn == 3 && d2 != 0){
								form.chk.checked = 0;
								relBorrar = true;
							}
						}
					}
					result = true;
				}
			}
		}
		if (!result) {
			alert('<cfoutput>#MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion#</cfoutput>.');
		}else{
			if(btn == 1  && relHabili){	// Error Habilitando
				alert('<cfoutput>#MSG_SeMarcaronRelacionesYaHabilitadasLasCualesNoSePermiteHabilitarDeNuevo#</cfoutput>.');
				result = false;
			}else{
				if(btn == 2  && relCerrar){	// Error Cerrando
					alert('<cfoutput>#MSG_SeMarcaronRelacionesQueNoSePermiteCerrar#</cfoutput>.');			
					result = false;
				}else{
					if(btn == 3  && relBorrar){	// Error Borrando
						alert('<cfoutput>#MSG_SeMarcaronRelacionesQueNoEstanEnProcesoLasCualesNoSePermiteBorrar#</cfoutput>.');			
						result = false;
					}
				}
			}
		}
		
		return result;
	}	
	//VERIFICA SI DENTRO DE LA LISTA DE RELACIONES SELECCIONADAS HAY ALGUNA QUE NO TIENE EMPLEADOS PARA EVALUAR
	//Y LO INDICA
	function sinEmpleados(){
		var form = document.listaActCompetencias;
		var result = false;
		if (form.chk!=null) {
			if (form.chk.length){
				for (var i=0; i<form.chk.length; i++){
					var x=i+1;
					var dato = 'form.CANTEMPLEADOS_'+ x +'.value';
					if (eval(dato)>0 && form.chk[i].checked)
						result = true;
				}
			}
			else{
				if (eval(dato)>1 && form.chk.checked)
					result = true;
			}
		}
		if (!result) {
			result= false;
			alert('<cfoutput>#MSG_NoSePuedeHabilitarLaRelacionPorqueNoHayEmpleadosParaEvaluar#</cfoutput>');
		}else result = true;
		return result;
	}
	//VERIFICA 	QUE LOS EMPLEADOS ASIGNADOS COMO EVALUADORES TENGAN EMPLEADOS A SU CARGO EN LA RELACION.
	function VerifEvaluadores(){
		var form = document.listaActCompetencias;
		var result = false;
		if (form.chk!=null) {
			if (form.chk.length){
				for (var i=0; i<form.chk.length; i++){
					var x=i+1;
					var dato = 'form.HABILITA_'+ x +'.value';
					if (eval(dato)== 1 && form.chk[i].checked)
						result = true;
				}
			}
			else{
				var dato = 'form.HABILITA_1.value';
				if (eval(dato)== 1 && form.chk.checked)
					result = true;
			}
		}
		if (!result) {
			result= false;
			alert('<cfoutput>#MSG_NoSePuedeHabilitarLaRelacionPorqueHayEvaluadoresSinEmpleadosAsignados#</cfoutput>');
		}else result = true;
		return result;
	}
	
	function funcHabilitar(){
		var form = document.listaActCompetencias;
		var msg = "¿<cfoutput>#MSG_DeseaHabilitarLasRelacionesMarcadas#</cfoutput>?";
		result = (hayMarcados(1)&&sinEmpleados()&&VerifEvaluadores()&&confirm(msg));
		if (result) form.action = "actCompetencias_lista_sql.cfm";
		return result;
		
		if(hayMarcados())
			return true;
	}
	function hayCerrado(){
		var form = document.listaActCompetencias;
		var result = false;
		if (form.chk!=null) {
			if (form.chk.length){
				for (var i=0; i<form.chk.length; i++){
					var x=i+1;
					var dato = 'form.CERRADA_'+ x +'.value';
					if (eval(dato)==1 && form.chk[i].checked)
						result = true;
				}
			}
			else{
				if (eval('form.CERRADA_1.value')==1 && form.chk.checked)
					result = true;
			}
		}
		if (!result) {
			result= false;
			alert('<cfoutput>#MSG_ExistenEmpleadosConCompentenciasPendientesDeEvaluar#</cfoutput>');
		}else result = true;
		return result;
	}
	function funcCerrar(){
		var form = document.listaActCompetencias;
		var msg = "¿<cfoutput>#MSG_DeseaCerrarLasRelacionesMarcadas#</cfoutput>?";
		result = (hayMarcados()&&hayCerrado());
		if (result) 
			if (confirm(msg)) {
				form.action = "actCompetencias_lista_sql.cfm";
			}else return false;
		
		return result;
	}

	function funcBorrar(){
		var form = document.listaActCompetencias;
		var msg = "¿<cfoutput>#MSG_DeseaEliminarLasRelacionesMarcadas#</cfoutput> ?";
		result = (hayMarcados(3)&&confirm(msg));
		if (result) form.action = "actCompetencias_lista_sql.cfm";
		return result;
		
		if(hayMarcados())
			return true;
	}	

	function funcNuevo(){
		document.listaActCompetencias.RHRCID.value = '';
	}
</script>

<!---QUERY PARA EL FILTRO DE LA LISTA, PARA EL CAMPO ITEM --->
<cfquery datasource="#session.dsn#" name="rsItem">
	select 'A' as value, '#LB_Ambos#' as description, '0' as ord from dual
	union
	select 'C' as value, '#LB_Conocimientos#' as description, '1' as ord from dual 
	union
	select 'H' as value, '#LB_Habilidades#' as description, '2' as ord from dual
	order by 3,2
</cfquery>

<!---QUERY PARA EL FILTRO DE LA LISTA, PARA EL CAMPO ESTADO--->
<cfquery datasource="#session.dsn#" name="rsEstado">
	select '' as value, '#LB_Todos#' as description, '0' as ord from dual
	union
	select '0' as value, '#LB_EnProceso#' as description, '1' as ord from dual 
	union
	select '10' as value, '#LB_Habilitada#' as description, '2' as ord from dual
	union
	select '20' as value, '#LB_Terminada#' as description, '3' as ord from dual
	union
	select '30' as value, '#LB_Cerrada#' as description, '4' as ord from dual
	order by 3,2
</cfquery>


<table width="85%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr>
    	<td>
			<cfinvoke 
				component="rh.Componentes.pListas"
				method="pListaRH"
				returnvariable="pListaRel">
					<cfinvokeargument name="tabla" value="RHRelacionCalificacion a"/>
					<cfinvokeargument name="columnas" value="RHRCid,RHRCdesc,RHRCfdesde,RHRCfhasta,
															case RHRCitems
																when 'H' then '#LB_Habilidades#'
																when 'C' then '#LB_Conocimientos#'
																when 'A' then '#LB_Ambos#'
															end RHRCitems
															,case RHRCestado
																when 0 then '#LB_EnProceso#'
																when 10 then '#LB_Habilitada#'
																when 20 then '#LB_Terminada#'
																when 30 then '#LB_Cerrada#'
															end RHRCestado
															, RHRCestado as estado
															, RHRCitems as items
															, (select count(1) 
																from RHEmpleadosCF 
																where Ecodigo = #session.Ecodigo# 
																  and RHEmpleadosCF.RHRCid=a.RHRCid) as cantEmpleados
															,case (select count(1)
																	from RHEvaluadoresCalificacion
																	where Ecodigo = #session.Ecodigo# 
																	  and RHRCid = a.RHRCid
																	  and RHECestado = 10)
															when (select count(1)
																	from RHEvaluadoresCalificacion
																	where Ecodigo = #session.Ecodigo# 
																	  and RHRCid = a.RHRCid)
															then 1 
															else 0 end as Cerrada
															,case (select count(distinct DEidJefe)
																	from RHEmpleadosCF
																	where Ecodigo = #session.Ecodigo#
																	  and RHRCid = a.RHRCid)
															when (select count(1)	
																	from RHEvaluadoresCalificacion
																	where Ecodigo = #session.Ecodigo#
																	  and RHRCid = a.RHRCid)
															then 1
															else 0 end as habilita"/>
					<cfinvokeargument name="desplegar" value="RHRCdesc, RHRCfdesde, RHRCfhasta,RHRCitems,RHRCestado"/>
					<cfinvokeargument name="etiquetas" value="#LB_Descripcion#, #LB_Desde#, #LB_Hasta#,#LB_Item#,#LB_Estado#"/>
					<cfinvokeargument name="formatos" value="S, D, D,S,S"/>
					<cfinvokeargument name="filtro" value="Ecodigo = #session.ecodigo#
														   and RHRCestado not in (30)"/>
					<cfinvokeargument name="align" value="left, left, left, left,left"/>
					<cfinvokeargument name="ajustar" value=""/>				
					<cfinvokeargument name="irA" value="actCompetencias.cfm"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="debug" value="N"/>
					<cfinvokeargument name="maxRows" value="30"/>
					<cfinvokeargument name="keys" value="RHRCid,estado,items"/>
					<cfinvokeargument name="checkboxes" value="S">
					<cfinvokeargument name="botones" value="Nuevo, Habilitar,Borrar,Cerrar"/>
					<cfinvokeargument name="mostrar_filtro" value="true"/>
					<cfinvokeargument name="filtrar_automatico" value="true"/>
					<cfinvokeargument name="filtrar_por" value="RHRCdesc, RHRCfdesde, 
															RHRCfhasta,RHRCitems, RHRCestado"/>
					<cfinvokeargument name="EmptyListMsg" value="#MSG_NoSeEncontraronRegistros#"/>
					<cfinvokeargument name="rsRHRCitems" value="#rsItem#"/>
					<cfinvokeargument name="rsRHRCestado" value="#rsEstado#"/>
					<cfinvokeargument name="formName" value="listaActCompetencias"/>
				</cfinvoke>	

			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>	
		<tr><td>&nbsp;</td></tr>		
</table>
