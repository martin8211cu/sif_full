<!---*******************************--->
<!---  inicialización de variables  --->
<!---*******************************--->
<cfset form.TIENE = "S">
<!---*******************************--->
<!---  área de consultas            --->
<!---*******************************--->
<cfquery name="rsPuesto" datasource="#session.DSN#">
		select coalesce(a.RHPcodigoext,a.RHPcodigo) as RHPcodigoext,a.RHPcodigo,RHPdescpuesto , b.PSporcreq
			from RHPuestos  a
			left outer join RHPlanSucesion b   
					on a.Ecodigo = b.Ecodigo
					and a.RHPcodigo = b.RHPcodigo
		where a.Ecodigo  =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.RHPcodigo  =  <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
</cfquery>

<cf_dbfunction name="to_char" args="a.DEid" returnvariable="vDEid">
<cf_dbfunction name="concat"  args="'<img border=''0'' onClick=''eliminar('|#vDEid#|');'' src=''/cfmx/rh/imagenes/Borrar01_S.gif''>'" returnvariable="vInstruccion" delimiters = "|">

<!---
 <cf_dump var="#vInstruccion#">
	cf b.DEnombre || ' ' || b.DEapellido1 || ' ' || b.DEapellido2  as NombreEmp,
		'<img border=''0'' onClick=''eliminar('||<cf_dbfunction name="to_char" args="a.DEid">||');'' src=''/cfmx/rh/imagenes/Borrar01_S.gif''>' as borrar
--->


<cfquery name="rsLista" datasource="#session.DSN#">							
	select a.RHPcodigo,a.DEid,
	DEidentificacion  as identificacion,
	<cf_dbfunction name="concat" args="b.DEnombre,' ',b.DEapellido1,'  ',b.DEapellido2"> as NombreEmp,
	#PreserveSingleQuotes(vInstruccion)# as borrar
	from RHEmpleadosPlan a , DatosEmpleado b
	where  a.DEid  = b.DEid 
	and    RHPcodigo  = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo#">
	and    a.Ecodigo    =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
</cfquery>

<!---*******************************--->
<!--- Información del Concurso      --->
<!---*******************************--->
	<table  width="75%"  align="center"border="0">
		<tr>
			<td width="20%" align="left" >C&oacute;d. Puesto:</td>
			<td width="80%"><strong><cfoutput>#rsPuesto.RHPcodigoext#</cfoutput></strong>&nbsp;<a  href="javascript: informacion('<cfoutput>#trim(rsPuesto.RHPcodigo)#</cfoutput>');" ><img border="0" src="/cfmx/rh/imagenes/findsmall.gif" ></a></td>
		</tr>
		<tr>
			<td align="left">Descripci&oacute;n:</td>
			<td><strong><cfoutput>#rsPuesto.RHPdescpuesto#</cfoutput></strong></td>
		</tr>
		<tr>
			<td align="left">Porcentaje Requerido:</td>
			<td><strong><cfoutput>#rsPuesto.PSporcreq#</cfoutput>&nbsp;%</strong></td>
		</tr>		
	</table>
<!---*******************************--->
<!--- aréa de pintado               --->
<!---*******************************--->
<form action="<cfoutput>#CurrentPage#</cfoutput>" method="post" name="form1" >
 	<input type="hidden" name="paso" value="<cfoutput>#Gpaso#</cfoutput>">
	<input type="hidden" name="RHPcodigo"  	
	value="<cfif isdefined("rsPuesto.RHPcodigo")and (rsPuesto.RHPcodigo GT 0)><cfoutput>#rsPuesto.RHPcodigo#</cfoutput></cfif>">
	<table width="100%" border="0">
		<tr>
			<td width="4%">&nbsp;</td>
			<td width="62%" nowrap><strong>Candidato</strong><br />
			<cf_rhempleado size="60"></td>
			<td width="20%" nowrap><br />
				<input type="submit" name="Alta" value="+" tabindex="0"
				onClick="javascript: this.form.botonSel.value = this.name; if (window.funcAlta) return funcAlta();if (window.habilitarValidacion) habilitarValidacion();if (1==2)alert('No haga nada');" >			</td>
		</tr>
	</table>
<!---*******************************--->
<!--- Información del botones       --->
<!---*******************************--->

<table border="0" cellspacing="0" cellpadding="0" width="100%">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center">
				<input type="hidden" name="botonSel" value="">
				<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb" tabindex="-1">
				<input type="submit" name="Anterior" 
				value="<< Anterior" 
				onClick="javascript: this.form.botonSel.value = this.name; if (window.funcAnterior) return funcAnterior();" tabindex="0">
				<input type="reset" name="Limpiar" value="Limpiar" 
				onClick="javascript: this.form.botonSel.value = this.name; if (window.funcLimpiar) return funcLimpiar();" tabindex="0">
				<!--- <cfif rsLista.recordcount gt 0> --->
					<input type="submit" name="Siguiente" value="Siguiente >>" 
					onClick="javascript: this.form.botonSel.value = this.name; if (window.funcSiguiente) return funcSiguiente();" tabindex="0">
				<!--- </cfif> --->
			</td>
		</tr>
  </table>

<!---*******************************--->
<!--- Lista de Concursante          --->
<!---*******************************--->
	<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
		<tr><td colspan="2" align="center">&nbsp;</td></tr>
		<td colspan="2"  align="center"   bgcolor="#CCCCCC" valign="top"><strong>Lista de Candidatos al puesto</strong></td>
		<tr>
			<td colspan="2">
    			<cfinvoke
						component="rh.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet"> 
					<cfinvokeargument name="query" 		value="#rsLista#"/> 
					<cfinvokeargument name="desplegar" 	value="identificacion,NombreEmp,borrar"/> 
					<cfinvokeargument name="etiquetas" 	value="Identificación,Nombre,&nbsp;"/> 
					<cfinvokeargument name="formatos" 	value="S,S,S"/> 
					<cfinvokeargument name="align" 		value="left,left,right"/> 
					<cfinvokeargument name="ajustar" 	value="N"/> 
					<cfinvokeargument name="checkboxes" value="N"/> 
					<cfinvokeargument name="irA" 		value="#CurrentPage#"/>
					<cfinvokeargument name="keys" 		value="DEid"/> 
					<cfinvokeargument name="showEmptyListMsg" value="true"/>						
					<cfinvokeargument name="maxrows" 	value="10"/>
					<cfinvokeargument name="showlink" 	value="false"/>
				</cfinvoke>
			</td>
		</tr>
	</table>
</form>
<!---*******************************--->
<!--- Lista de script               --->
<!---*******************************--->
<cf_qforms>
<script language="javascript" type="text/javascript">
	function deshabilitar(){
			objForm.DEidentificacion.required = false;
	}
	objForm.DEidentificacion.required = true;
	objForm.DEidentificacion.description="Candidato";	

	function eliminar(llave){
		if (confirm('¿Desea eliminar el Candidato?')){
			document.form1.DEid.value = llave;
			document.form1.BORRAR.value = 'BORRAR';
			document.form1.submit();
		}else{
			return false;
		}
	}
	function Expendiente(llave){
		alert('Aqui muestra información del empleado')
		//var PARAM  = "Expediente_concursante.cfm?DEid="+ llave
		//open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=800,height=400')
	}
	function informacion(llave){
		var PARAM  = "../consultas/PlanSucesion-ConsultaPlan.cfm?RHPcodigo="+ llave
		open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=800,height=400')
	}
	
	function Submit(){
		document.form1.submit();
	}
</script>
