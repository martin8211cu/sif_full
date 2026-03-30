<cfquery name="rsDirEscuela" datasource="#session.DSN#">
	Select 
		case 
			when DIEactivo=1 then 'Activo'
			when DIEactivo=0 then 'Inactivo'
		end DIEactivoDescr
		, DIEactivo
		, de.EScodigo
		, ESnombre
		, Fnombre
		, e.Fcodigo
	from DirectorEscuela de
		, Escuela e
		, Facultad f
	where DIpersona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.llavePersona#">
		and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and de.EScodigo=e.EScodigo
		and e.Fcodigo=f.Fcodigo
		and e.Ecodigo=f.Ecodigo
	order by Fnombre,ESnombre
</cfquery>

<form name="formDirEscuela" method="post" action="directorEscuela_SQL.cfm">
 	<cfoutput>
		<cfif isdefined('form.modo') and form.modo NEQ ''>
			<input name="modo" type="hidden" value="#form.modo#">  
		</cfif>
	 
		<input type="hidden" name="DIpersona" value="<cfif isdefined("rsForm.llavePersona")>#rsForm.llavePersona#</cfif>">
		<input type="hidden" name="EScodigoEscuela" id="EScodigoEscuela" value="">	
		<input type="hidden" name="btnAgregarDirEscuela" id="btnAgregarDirEscuela" value="0">
		<input type="hidden" name="TipoPersona" id="TipoPersona" value="#TipoPersona#">
	</cfoutput>		

	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td colspan="3" align="center" class="tituloMantenimiento">
			<cfoutput>#session.parametros.Escuela#</cfoutput>s Asignadas al Director
		</td>
	  </tr>
	  <tr>
		<td colspan="3" align="center"><br>
			<input name="btnAgregaEscuela" type="button" id="btnAgregaEscuela" value="Agregar" onClick="javascript: doConlisDirEscuela();"
				title="Agregar una <cfoutput>#session.parametros.Escuela#</cfoutput> al director actualmente seleccionado">		
		</td>
	  </tr>	
	  <tr>
		<td colspan="3"><hr></td>
	  </tr> 	

	  <cfif isdefined('rsDirEscuela') and rsDirEscuela.recordCount GT 0>
			<cfset varFacultad = "">

			<cfoutput query="rsDirEscuela">
				<cfif varFacultad NEQ rsDirEscuela.Fcodigo>
					<cfset varFacultad = rsDirEscuela.Fcodigo>
					<tr bgcolor="##CCCCCC">
						<td>&nbsp;</td>
						<td colspan="2">
							<strong>#Fnombre#</strong>
						</td>
					</tr>			
				</cfif>
				  
				  <tr>
					<td align="center">&nbsp;</td>
					<td align="center">
						<a href="##">
							<cfif DIEactivo EQ 1>
								<img border="0" alt="Desactivar esta #session.parametros.Escuela#" onClick="javascript: DesactivarEscuela(#EScodigo#);" src="/cfmx/educ/imagenes/iconos/check_del.gif">
							<cfelse>
								<img border="0" alt="Activar esta #session.parametros.Escuela#" onClick="javascript: ActivarEscuela(#EScodigo#);" src="/cfmx/educ/imagenes/iconos/check_off.gif">
							</cfif>
							
						</a>
					</td>
					<td>#ESnombre#</td>
				  </tr>
			</cfoutput>
			<input type="hidden" name="btnActrEscuela" id="btnActrEscuela" value="0">					
			<input type="hidden" name="IdEscuelaAct" id="IdEscuelaAct" value="">		
			<input type="hidden" name="btnDesactrEscuela" id="btnDesactrEscuela" value="0">					
			<input type="hidden" name="IdEscuelaDesact" id="IdEscuelaDesact" value="">		
	  <cfelse>
		  <tr>
			<td width="4%">&nbsp;</td>
			<td width="14%">&nbsp;</td>
			<td width="82%">&nbsp;</td>
		  </tr> 	  
		  <tr>
			<td width="4%" colspan="3" align="center">
				<strong>!! El director no posee <cfoutput>#session.parametros.Escuela#</cfoutput>s asociadas !!</strong>
			</td>
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
	function DesactivarEscuela(cod){
		var f = document.formDirEscuela;
		
		if(confirm('Desea desactivar esta <cfoutput>#session.parametros.Escuela#</cfoutput> ?')){
			f.btnDesactrEscuela.value = 1;
			f.btnActrEscuela.value = 0;
			f.btnAgregarDirEscuela.value = 0;
			f.IdEscuelaDesact.value = cod;			

			f.submit()
		}
	}	
//-------------------------------------------------------------------------------------------		
	function ActivarEscuela(cod){
		var f = document.formDirEscuela;
		
		if(confirm('Desea activar esta Escuela ?')){
			f.btnActrEscuela.value = 1;
			f.btnDesactrEscuela.value = 0;
			f.btnAgregarDirEscuela.value = 0;
			f.IdEscuelaAct.value = cod;			

			f.submit()
		}
	}		
//---------------------------------------------------------------------------------------	
	//Llama el conlis
	function doConlisDirEscuela() {
		var params ="";
		var codsQuitar = "<cfoutput>#ValueList(rsDirEscuela.EScodigo,',')#</cfoutput>"		
		
		document.formDirEscuela.btnAgregarDirEscuela.value = 1;
		params = "?form=formDirEscuela&quitar=" + codsQuitar + "&cod=EScodigoEscuela&btn=btnAgregarDirEscuela&conexion=<cfoutput>#session.DSN#</cfoutput>";
		popUpWindow("/cfmx/educ/administrativo/personas/conlisEscuela.cfm"+params,250,200,650,400);

	}	
//---------------------------------------------------------------------------------------	
</script>