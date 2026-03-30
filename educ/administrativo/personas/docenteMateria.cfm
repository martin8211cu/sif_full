<cfquery name="rsDocenteMateria" datasource="#session.DSN#">
	select convert(varchar,dm.Mcodigo) as Mcodigo
		, Mcodificacion
		, Mnombre
		, DOMactivo
		, case 	when DOMtipo='1' then 'Profesor'
				when DOMtipo='3' then 'Asistente'
		end DOMtipo
	from DocenteMateria dm
		, Materia m
	where DOpersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.llavePersona#">
		and dm.Mcodigo=m.Mcodigo
	order by Mnombre
</cfquery>

<form name="formDocMateria" method="post" action="docenteMateria_SQL.cfm">
 	<cfoutput>
		<cfif isdefined('form.modo') and form.modo NEQ ''>
			<input name="modo" type="hidden" value="#form.modo#">  
		</cfif>
	 
		<input type="hidden" name="DOpersona" value="<cfif isdefined("rsForm.llavePersona")>#rsForm.llavePersona#</cfif>">
		<input type="hidden" name="McodigoDocMateria" id="McodigoDocMateria" value="">	
		<input type="hidden" name="btnAgregarDocMateria" id="btnAgregarDocMateria" value="0">
		<input type="hidden" name="TipoPersona" id="TipoPersona" value="#TipoPersona#">
	</cfoutput>		

	
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td colspan="4" align="center" class="tituloMantenimiento"> Materias Asignadas 
        al Docente </td>
    </tr>
    <tr> 
      <td colspan="4">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="3" align="right"><input name="btnAgregaMateria" type="button" id="btnAgregaMateria" value="Agregar" onClick="javascript: doConlisDocMateria();"
				title="Agregar una Materia al Docente actualmente seleccionado">
        &nbsp;&nbsp; </td>
      <td align="center"><select name="DOMtipo">
          <option value="1">Como Profesor y/o Asistente</option>
          <option value="3">Unicamente como Asistente</option>
        </select></td>
    </tr>
    <tr> 
      <td colspan="4"><hr></td>
    </tr>
    <cfif isdefined('rsDocenteMateria') and rsDocenteMateria.recordCount GT 0>
      <cfoutput query="rsDocenteMateria"> 
        <tr> 
          <td align="center">&nbsp;</td>
          <td align="center"> 
            <a href="##"> 
				<cfif DOMactivo EQ 1>
					<img border="0" alt="Desactivar esta Materia" onClick="javascript: desactivarDocMateria(#Mcodigo#);" src="/cfmx/educ/imagenes/iconos/check_del.gif">
				<cfelse>
					<img border="0" alt="Activar esta Materia" onClick="javascript: activarDocMateria(#Mcodigo#);" src="/cfmx/educ/imagenes/iconos/check_off.gif">
				</cfif>			
            </a> </td>
          <td>#Mnombre# (#Mcodificacion#)</td>
          <td>#DOMtipo#</td>
        </tr>
      </cfoutput> 
      <input type="hidden" name="btnActDocMateria" id="btnActDocMateria" value="0">
      <input type="hidden" name="IdDocMateriaAct" id="IdDocMateriaAct" value="">	  
      <input type="hidden" name="btnDesactDocMateria" id="btnDesactDocMateria" value="0">
      <input type="hidden" name="IdDocMateriaDesact" id="IdDocMateriaDesact" value="">
      <cfelse>
      <tr> 
        <td width="4%">&nbsp;</td>
        <td width="14%">&nbsp;</td>
        <td width="82%">&nbsp;</td>
        <td width="82%">&nbsp;</td>
      </tr>
      <tr> 
        <td width="4%" colspan="4" align="center"> <strong>!! El Docente no posee 
          Materias Asociadas !!</strong> </td>
      </tr>
    </cfif>
  </table>
</form>
<script language="JavaScript" type="text/javascript">
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
//-------------------------------------------------------------------------------------------		
	function desactivarDocMateria(cod){
		var f = document.formDocMateria;
		
		if(confirm('Desea desactivar esta Materia ?')){
			f.btnDesactDocMateria.value = 1;
			f.btnActDocMateria.value = 0;			
			f.btnAgregarDocMateria.value = 0;
			f.IdDocMateriaDesact.value = cod;			

			f.submit()
		}
	}	
//-------------------------------------------------------------------------------------------		
	function activarDocMateria(cod){
		var f = document.formDocMateria;
		
		if(confirm('Desea activar esta Materia ?')){
			f.btnActDocMateria.value = 1;
			f.btnDesactDocMateria.value = 0;			
			f.btnAgregarDocMateria.value = 0;
			f.IdDocMateriaAct.value = cod;			

			f.submit();
		}
	}		
//---------------------------------------------------------------------------------------	
	//Llama el conlis
	function doConlisDocMateria() {
		var params ="";
		var codsQuitar = "<cfoutput>#ValueList(rsDocenteMateria.Mcodigo,',')#</cfoutput>"		
		
		document.formDocMateria.btnAgregarDocMateria.value = 1;
		params = "?form=formDocMateria&tipo=M&quitar=" + codsQuitar + "&cod=McodigoDocMateria&btn=btnAgregarDocMateria&conexion=<cfoutput>#session.DSN#</cfoutput>";
		popUpWindow("conlisMaterias.cfm"+params,250,200,650,400);

	}	
//---------------------------------------------------------------------------------------	
</script>