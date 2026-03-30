<cfif isdefined ('form.MIGReid')>
	<cfquery datasource="#Session.DSN#" name="rsResponsable">
		select 
				MIGReid,
				MIGRcodigo,
				MIGRenombre,
				MIGRecorreo,
				MIGRecorreoadicional,
				case Dactivas
					when  0 then 'Inactivo'
					when  1 then 'Activo'
				else 'Dactiva desconocido'
				end as Dactiva
		from MIGResponsables
		where MIGReid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MIGReid#">
	</cfquery>
</cfif> 
<cfoutput>
<table width="50%" border="0" align="left">
		<tr>
			<td align="left">
				<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
				tabla="Departamentos a
						inner join MIGResponsablesDepto b
							on a.Dcodigo=b.Dcodigo
							and a.Ecodigo=b.Ecodigo"
				columnas="a.Dcodigo,a.Deptocodigo,a.Ddescripcion,b.MIGRDeptoid"
				desplegar="Deptocodigo, Ddescripcion"
				etiquetas="C&oacute;digo, Descripci&oacute;n"
				formatos="S,S"
				filtro="MIGReid=#form.MIGReid# and a.Ecodigo=#session.Ecodigo# Order By a.Deptocodigo"
				align="left,left,left"
				checkboxes="N"
				keys="MIGRDeptoid"
				filtrar_automatico="true"
				mostrar_filtro="true"
				MaxRows="15"
				pageindex="65"
				ira="Responsable.cfm?Tab=2&MIGReid=#form.MIGReid#"
				filtrar_por="Deptocodigo, Ddescripcion, &nbsp;, &nbsp;"
				showEmptyListMsg="true">
			</td>
		</tr>
</table>

<form name="form3" method="post" action="ResponsableSQL.cfm" onSubmit="return validaDet(this);">
<cfset LvarIniciales=false>
<cfset LvarDept="">

<cfif not isdefined ('form.MIGRDeptoid')>
	<cfset mododet='ALTA'>
<cfelse>
	<cfset mododet='CAMBIO'>
</cfif>
<cfif isdefined ('URL.MIGRDeptoid')>
	<cfset mododet='CAMBIO'>
	<cfset form.MIGRDeptoid=url.MIGRDeptoid>
</cfif>

<cfif mododet EQ "CAMBIO" >
	<cfquery datasource="#Session.DSN#" name="rsRespDept">
		select 
				MIGRDeptoid,
				Dcodigo,
				MIGReid,
				MIGRespDeptotipo,
				MIGRDeptoNivel,
				MIGResptipo				
		from MIGResponsablesDepto
		where MIGRDeptoid= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MIGRDeptoid#">
	</cfquery>
	<input type="hidden" name="MIGRDeptoid" id="MIGRDeptoid" value="#rsRespDept.MIGRDeptoid#">
	<cfset LvarDept=rsRespDept.Dcodigo>
	<cfset LvarIniciales=true>
</cfif>
<input type="hidden" name="MIGReid" id="MIGReid" value="#form.MIGReid#">
<input type="hidden" name="MIGRcodigo" id="MIGRcodigo" value="#rsResponsable.MIGRcodigo#" />
	<table  width="50%" border="0" align="right">
		<tr valign="baseline"> 
			<td align="right">Es el usuario principal:</td>
			 <td width="17%"> 
				 <select name="MIGRespDeptotipo" id="MIGRespDeptotipo">
				 	<option value="">-&nbsp;-&nbsp;-</option>
				 	<option value="S" <cfif mododet NEQ "ALTA" and rsRespDept.MIGRespDeptotipo EQ "S">selected</cfif> >Si</option>
					<option value="N" <cfif mododet NEQ "ALTA" and rsRespDept.MIGRespDeptotipo EQ "N">selected</cfif> >No</option>
				  </select>			  </td>
		</tr>
		<tr>
			<td align="right" nowrap="nowrap">Nivel Organizacional:</td>
			<td align="left" nowrap="nowrap" colspan="2">
				<select name="MIGRDeptoNivel" id="MIGRDeptoNivel">
					<option value="">-&nbsp;-&nbsp;-</option>
					<option value="E"<cfif mododet EQ 'CAMBIO'and rsRespDept.MIGRDeptoNivel EQ 'E'>selected="selected"</cfif>>Empresa</option>
					<option value="D"<cfif mododet EQ 'CAMBIO'and rsRespDept.MIGRDeptoNivel EQ 'D'>selected="selected"</cfif>>Direcci&oacute;n</option>
					<option value="S"<cfif mododet EQ 'CAMBIO'and rsRespDept.MIGRDeptoNivel EQ 'S'>selected="selected"</cfif>>Sub_Direcci&oacute;n</option>
					<option value="G"<cfif mododet EQ 'CAMBIO'and rsRespDept.MIGRDeptoNivel EQ 'G'>selected="selected"</cfif>>Gerencia</option>
					<option value="P"<cfif mododet EQ 'CAMBIO'and rsRespDept.MIGRDeptoNivel EQ 'P'>selected="selected"</cfif>>Departamento</option>
					<option value="O"<cfif mododet EQ 'CAMBIO'and rsRespDept.MIGRDeptoNivel EQ 'O'>selected="selected"</cfif>>Otro</option>
				</select>			
			</td>
		</tr>
		<tr>
			<td align="right">Tipo Persona:</td>
			 <td width="17%"><select name="MIGResptipo" id="MIGResptipo" >
               <option value="">-&nbsp;-&nbsp;-</option>
               <option value="S" <cfif mododet NEQ "ALTA" and rsRespDept.MIGResptipo EQ "S">selected</cfif> >Suministra Informaci&oacute;n</option>
               <option value="M" <cfif mododet NEQ "ALTA" and rsRespDept.MIGResptipo EQ "M">selected</cfif> >Fija Meta</option>
               <option value="N" <cfif mododet NEQ "ALTA" and rsRespDept.MIGResptipo EQ "N">selected</cfif> >No Aplica</option>
             </select></td> 			
		</tr>
		<tr>
			<td nowrap align="right">C&oacute;digo Departamento:</td>
			<td align="left" nowrap="nowrap" >
				<cf_conlis title="Lista Departamentos"
						campos = "Dcodigo,Deptocodigo,Ddescripcion" 
						desplegables = "N,S,S"
						modificables = "N,S,S"  
						tabla="Departamentos"
						columnas="Dcodigo,Deptocodigo,Ddescripcion"
						filtro="Ecodigo = #Session.Ecodigo#"
						desplegar="Deptocodigo, Ddescripcion"
						etiquetas="Codigo,Descripción"
						formatos="S,S"
						align="left,left"
						traerInicial="true"
						form="form3"
						traerFiltro="Dcodigo='#LvarDept#'"
						filtrar_por="Deptocodigo,Ddescripcion"
						tabindex="1"
						fparams="Dcodigo"
						/>			</td>
			<td width="6%"><img border='0' src='/cfmx/mig/imagenes/plus.gif' onClick='javascript:return funcOpen();'>	</td>
		</tr>
		<tr>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td align="center" ><cf_botones sufijo='Det' modo='#mododet#'  tabindex="2"></tr>
	</table>
</form>
</cfoutput>
<script language="JavaScript1.2" type="text/javascript">
	var nuevo=0;
	var validar = true;
	function funcOpen(id) {
			var width = 750;
			var height = 450;
			var top = (screen.height - height) / 2;
			var left = (screen.width - width) / 2;
			<cfoutput>
			nuevo = window.open('formDepartamentos.cfm?bandera=1&mododet=ALTA&MIGReid=#form.MIGReid#','Caracteristicas','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
			</cfoutput>
			nuevo.focus();
			window.onfocus = closePopUp;
			
			return false;	
		}
		

function closePopUp(){
	if(nuevo) {
		if(!nuevo.closed) nuevo.close();
		nuevo=null;
		document.form3.submit();
  	}
}
</script>
<script type="text/javascript">
var validar = true;
function deshabilitarValidacion()
{
	validar = false;
}
function validaDet(formulario)	{
		var error_input;
		var error_msg = '';

		if (!validar)
			return true;
			
		if (formulario.MIGRespDeptotipo.value == "") {
			error_msg += "\n - El usuario Principal no puede quedar en blanco.";
			error_input = formulario.MIGRespDeptotipo;
		}
		
		if (formulario.MIGResptipo.value == "") {
			error_msg += "\n - El Tipo persona no puede quedar en blanco.";
			error_input = formulario.MIGResptipo;
		}	
		if (formulario.MIGRDeptoNivel.value == "") {
			error_msg += "\n - El Nivel Organizacional no puede quedar en blanco.";
			error_input = formulario.MIGRDeptoNivel;
		}		
	
		if (formulario.Dcodigo.value == "") {
			error_msg += "\n - El departamento no puede quedar en blanco.";
			error_input = formulario.Dcodigo;
		}
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
		else{ 
			var CodigoRe=formulario.MIGRcodigo.value;
			var CodigoDep=formulario.Deptocodigo.value;
			if ( confirm('Desea Asociar el Departamento: '+ CodigoDep +'   al Responsable: ' + CodigoRe ) ){ 
				if (window.deshabilitarValidacion) deshabilitarValidacion(); 
				return true;
			}
			else{ 
				return false;
			}
		}		
}
</script>