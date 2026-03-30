<cfparam name="FORM.RHEEID" type="numeric">
<cfparam name="FORM.DEID" type="numeric" default="-1">

<cfif (FORM.DEID gt 0)>
	<link href="STYLE.CSS" rel="stylesheet" type="text/css">
	<!--- Consultas --->
	<cfquery name="rsEvaluado" datasource="#session.dsn#">
		Select b.DEid, b.DEidentificacion, {fn concat(b.DEapellido1,{fn concat(' ',{fn concat( b.DEapellido2,{fn concat(' ',b.DEnombre)})})})}  as NombreEmp
		from DatosEmpleado b
		where b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.DEID#"> 
	</cfquery>	
	<cfquery name="rsEvaluadoresLista" datasource="#session.dsn#">
		select 	a.Estado, 
				b.DEid, 
				b.DEidentificacion, 
				{fn concat(b.DEapellido1,{fn concat(' ',{fn concat( b.DEapellido2,{fn concat(' ',b.DEnombre)})})})}  as NombreEmp, 
				a.RHEDtipo, 
				RHEDtipodesc = case a.RHEDtipo 	when 'A' then 'Autoevaluación' 
												when 'J' then 'Jefe' 
												when 'S' then 'Colaborador' 
												when 'C' then 'Compañero' 
								end
		from RHEvaluadoresDes a, DatosEmpleado b
		where a.RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.RHEEID#">
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.DEID#">
		and a.DEideval = b.DEid
		order by RHEDtipo
	</cfquery>
	<cfquery dbtype="query" name="rsJefe">
		select * from rsEvaluadoresLista
		where RHEDtipo = 'J'
	</cfquery>
	<!--- Javascript --->
	<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
	<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
	<script language="JavaScript1.2" type="text/javascript">
	
		<!--//
		
		//**************************************QForms**************************************************
		
		// specify the path where the "/qforms/" subfolder is located
		qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
		// loads all default libraries
		qFormAPI.include("*");

		function funcAnterior(){
			document.form1.SEL.value = "3";
			document.form1.action = "registro_evaluacion.cfm";
			deshabilitarValidacion();
			return true;
		}
		function funcSiguiente(){
			document.form1.SEL.value = "5";
			document.form1.action = "registro_evaluacion.cfm";
			deshabilitarValidacion();
			return true;
		}
		function funcAgregar(){
			//habilitarValidacion();
		}
		function funcEliminar(id){
			if (confirm('¿Desea eliminar el evaluador de la lista de evaluadores de este empleado?')) {
				<cfoutput>
				window.location.href = "registro_criterios_evaluadores_sql.cfm?ELIMINAR&RHEEID=#FORM.RHEEID#&DEID=#FORM.DEID#&DEID1="+id;
				</cfoutput>
				return false;
			}
			return false;
		}
		
		//-->
	
	</script>
	<cfoutput>
	<form action="registro_criterios_evaluadores_sql.cfm" method="post" name="form1">
		<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="Eliminar habilidad requerida para este puesto." style="display:none;">
		<table width="95%" align="center"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td rowspan="7">&nbsp;</td>
			<td colspan="4" height="23"><div align="center"><em>Lista de Evaluadores de #rsEvaluado.NombreEmp#</em></div></td>
			<td rowspan="7">&nbsp;</td>
		  </tr>
		   <tr>
			<td colspan="4">
				<table width="75%" align="center"  border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td><strong>Evaluador:</strong>&nbsp;</td>
                    <td><cf_rhempleado index="1" tabindex="1"></td>
                    <td><strong>Tipo:</strong>&nbsp;</td>
                    <td>
                      <select name="RHEDtipo" tabindex="1">
                        <!--- <option value="A|Autoevaluación">Autoevaluación</option> --->
                        <cfif rsJefe.RecordCount eq 0>
                          <option value="J|Jefe">Jefe</option>
                        </cfif>
                        <option value="S|Subordinado">Colaborador</option>
                        <option value="C|Compañero">Compañero</option>
                      </select>
                    </td>
                    <td><input type="submit" name="AgregarEval" value="Agregar" onClick="javascript:funcAgregar();" tabindex="1"></td>
                  </tr>
                  <tr>
                    <td>&nbsp;</td>
                  </tr>
                </table>
				<table id="tbldynamic" width="75%" align="center"  border="0" cellspacing="0" cellpadding="0">
				  <thead>
				  <td></td>
					<td><strong>Identificaci&oacute;n/Nombre:&nbsp;</strong></td>
					<td><strong>Tipo de Evaluador:&nbsp;</strong></td>
					<td></td>
					<td></td>
				  </thead>
				  <tbody>
				  <cfloop query="rsEvaluadoresLista">
					  <tr <cfif CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
						<td></td>
						<td>#DEidentificacion# #NombreEmp#</td>
						<td>#RHEDtipodesc#</td>
						<td>
							<cfif Estado EQ 1>
								<img src="/cfmx/rh/imagenes/checked.gif">
							<cfelse>
								<img src="/cfmx/rh/imagenes/unchecked.gif">
							</cfif>
						</td>
						<td>
							<cfif RHEDtipo neq 'A' and Estado NEQ 1>
								<input  name="btnEliminar" type="image" alt="Eliminar elemento" 
								onClick="javascript: return funcEliminar(#DEid#);" src="/cfmx/rh/imagenes/Borrar01_S.gif" tabindex="2">
							</cfif>
						</td>
					  </tr>
				  </cfloop>
				  </tbody>
			 </table>			</td>
		  </tr>
		  <tr>
			<td colspan="4">&nbsp;</td>
		  </tr>
		  <tr>
			<td colspan="4" align="center">
				<input type="hidden" name="SEL" value="">
				<input type="hidden" name="RHEEid" value="#form.RHEEid#">
				<input type="hidden" name="DEid" value="#form.DEid#">
				<input type="hidden" name="LastOne" id="LastOne" value="ListaNon">
				<cf_botones values="<< Anterior,Siguiente >>" names="Anterior,Siguiente" nbspbefore="4" nbspafter="4" tabindex="3">
			</td>
		  </tr>
		</table>
	</form>
	</cfoutput>
	
	<script language="javascript" type="text/javascript">
		<!--//

		qFormAPI.errorColor = "#FFFFCC";
		objForm = new qForm("form1");

		function _validarCodigo(){
			<cfoutput query="rsEvaluadoresLista">
			if (this.getValue()=='#DEID#') this.error = "Este evaluador ya está agregado a la lista de evaluadores de este empleado, no puede agregarlo mas de una vez..";
			</cfoutput>
		}
		_addValidator("isCodigo", _validarCodigo);
		
		objForm.DEid1.required = true;
		objForm.DEid1.description = "Evaluador";
		objForm.DEid1.validateCodigo();
		objForm.RHEDtipo.description = "Tipo de Evaluador";
		objForm.RHEDtipo.required = true;
		
		function deshabilitarValidacion(){
			objForm.DEid1.required = false;
			objForm.RHEDtipo.required = false;
		}
		function habilitarValidacion(){
			objForm.DEid1.required = true;
			objForm.RHEDtipo.required = true;
		}
		
		objForm.NTIcodigo1.obj.focus();
		
		//-->
		
	</script>
<cfelse>
	<h4>Seleccione un empleado al que desea agregar evaluadores:</h4>
	<cfinclude template="frame-Empleados.cfm">
	<table width="95%" align="center"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td colspan="4" align="center">
		<script language="javascript" type="text/javascript">
			function funcAnterior(){
				document.form0.SEL.value = "3";
				document.form0.action = "registro_evaluacion.cfm";
				return true;
			}
			function funcSiguiente(){
				document.form0.SEL.value = "5";
				document.form0.action = "registro_evaluacion.cfm";
				return true;
			}
		</script>
		<form action="registro_evaluacion.cfm" method="post" name="form0">
			<cfoutput>
				<input type="hidden" name="SEL" value="">
				<input type="hidden" name="RHEEid" value="#form.RHEEid#">
			</cfoutput>
			<cf_botones values="<< Anterior,Siguiente >>" names="Anterior,Siguiente" functions="return false;,return false;" nbspbefore="4" nbspafter="4" tabindex="2">
		</form>
		</td>
	  </tr>
	</table>
</cfif>