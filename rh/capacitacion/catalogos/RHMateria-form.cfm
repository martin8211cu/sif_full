<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_CursosParaCapacitacion" Default="Cursos para Capacitaci&oacute;n" returnvariable="LB_CursosParaCapacitacion" component="sif.Componentes.Translate" method="Translate"/>
﻿<cfinvoke Key="LB_NombreDelCurso" Default="Nombre del Curso" returnvariable="LB_NombreDelCurso" component="sif.Componentes.Translate" method="Translate"/>
﻿<cfinvoke Key="LB_SiglasDelCurso" Default="Siglas del curso"returnvariable="LB_SiglasDelCurso" component="sif.Componentes.Translate" method="Translate"/>
﻿<cfinvoke Key="LB_CategoriaDeCapacitacion" Default="Categor&iacute;a de Capacitaci&oacute;n" returnvariable="LB_CategoriaDeCapacitacion" component="sif.Componentes.Translate" method="Translate"/>	
﻿<cfinvoke Key="LB_Descripcion" Default="Descripci&oacute;n" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_ElCursoPerteneceALosSiguientesGrupos" Default="El Curso pertenece a los siguientes grupos" returnvariable="LB_ElCursoPerteneceALosSiguientesGrupos" component="sif.Componentes.Translate" method="Translate"/>	

<!--- FIN VARIABLES DE TRADUCCION --->
<cfif isdefined('url.modo')>
	<cfset modo = url.modo>
</cfif>
<cfif isdefined('url.Mcodigo') and not isdefined('form.Mcodigo')>
	<cfset form.Mcodigo = url.Mcodigo>
</cfif>
<cfif isdefined('url.PageNum') and not isdefined('form.PageNum')>
	<cfset form.PageNum = url.PageNum>
</cfif>
<cfif isdefined("Form.Mcodigo") and Len(Trim(Form.Mcodigo))>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>


<cfif modo EQ "CAMBIO">
	<cfquery datasource="#session.dsn#" name="data">
		select *
		from RHMateria
		where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#" null="#Len(Form.Mcodigo) Is 0#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	
	<cfquery datasource="#session.dsn#" name="rsGruposMat">
		Select gm.RHGMid,Descripcion,mg.RHGMid as grupoMat
		from RHGrupoMaterias gm
		inner join RHMateriasGrupo mg
				on mg.Ecodigo=gm.Ecodigo
					and mg.RHGMid=gm.RHGMid
					<cfif modo EQ "CAMBIO" and isdefined('Form.Mcodigo') and Form.Mcodigo NEQ ''>
						and Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">				
					</cfif>
		where gm.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		order by Descripcion
	</cfquery>	
</cfif>
			
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

<cfquery datasource="#session.dsn#" name="rsAreasCapa">
	select a.RHACid,RHACcodigo,
    case when LEN(RHACdescripcion) > 45 
    	then <cf_dbfunction name="spart" args="RHACdescripcion,1,45">#_Cat# '...' 
        else RHACdescripcion end as RHACdescripcion
	from RHAreasCapacitacion a
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<script type="text/javascript" >
<!--
	function validar(formulario) {
		var error_input;
		var error_msg = '';
		// Validando tabla: RHMateria - RHMateria

		// Columna: Mnombre Nombre materia varchar(50)
		if (formulario.Mnombre.value == "") {
			error_msg += "\n - Nombre materia no puede quedar en blanco.";
			error_input = formulario.Mnombre;
		}

		// Columna: Msiglas Siglas del curso varchar(15)
		if (formulario.Msiglas.value == "") {
			error_msg += "\n - Siglas del curso no puede quedar en blanco.";
			error_input = formulario.Msiglas;
		}

		// Columna: Mactivo Esta activo bit
		if (formulario.Mactivo.value == "") {
			error_msg += "\n - Esta activo no puede quedar en blanco.";
			error_input = formulario.Mactivo;
		}

		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			error_input.focus();
			return false;
		}
		return true;
	}
//-->
</script> 
<cfoutput>
	<form action="RHMateria-apply.cfm" onsubmit="javascript: return validar(this);" method="post" name="form1" id="form1">
    	<input name="variable" type="hidden" value="0">
		<cfif isdefined("Form.PageNum") and Len(Trim(Form.PageNum))>
			<input type="hidden" name="PageNum" value="#Form.PageNum#">
		</cfif>
		<table summary="Tabla de entrada" cellpadding="0" cellspacing="0" width="100%">
			<tr><td colspan="2" class="subTitulo" align="center">#LB_CursosParaCapacitacion#</td></tr>
			<tr>
				<td align="right" class="fileLabel" nowrap="nowrap">#LB_NombreDelCurso#:</td>
				<td valign="top">
					<input name="Mnombre" type="text" id="Mnombre"
						onfocus="this.select()" value="<cfif modo EQ "CAMBIO">#HTMLEditFormat(data.Mnombre)#</cfif>" size="30" 
						maxlength="50"  >
				</td>
			</tr>
			<tr>
				<td align="right" class="fileLabel">#LB_SiglasDelCurso#:</td>
				<td valign="top">
					<input name="Msiglas" type="text" id="Msiglas"
						onfocus="this.select()" value="<cfif modo EQ "CAMBIO">#HTMLEditFormat(data.Msiglas)#</cfif>" size="15" 
						maxlength="15"  >
				</td>
			</tr>
			<tr>
				<td align="right" class="fileLabel" nowrap="nowrap">#LB_CategoriaDeCapacitacion#:</td>
				<td valign="top">				
					<select name="RHACid">
						<option value="-1"></option>
						<cfloop query="rsAreasCapa">
							<option value="#rsAreasCapa.RHACid#" 
									<cfif modo neq "ALTA" and data.RHACid NEQ '' and data.RHACid eq rsAreasCapa.RHACid> selected</cfif>>
								#rsAreasCapa.RHACcodigo# - #rsAreasCapa.RHACdescripcion#
							</option>
					  </cfloop>
					</select>				
				</td>
			</tr>			
			<tr>
				<td align="right" class="fileLabel">
					#LB_Activo#:
				</td>
				<td valign="top">
					<input name="Mactivo" id="Mactivo" type="checkbox" value="1" <cfif modo EQ "CAMBIO" and Len(data.Mactivo) And data.Mactivo>checked<cfelseif modo EQ "ALTA"> checked</cfif> >
				</td>
			</tr>
			<tr>
			  <td valign="top" align="right" class="fileLabel">#LB_Descripcion#:</td>
			  <td valign="top"><textarea name="Mdescripcion" rows="10" cols="70" style="font-family:Arial, Helvetica, sans-serif"><cfif modo NEQ 'ALTA'>#HTMLEditFormat(data.Mdescripcion)#</cfif></textarea></td>
		  </tr>
			<tr>
				<td align="right" class="fileLabel">&nbsp;</td>
				<td valign="top">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="2" class="formButtons">
					<cfif modo EQ "CAMBIO">
						<cf_botones modo='CAMBIO'>
					<cfelse>
						<cf_botones modo='ALTA'>
					</cfif>
				</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td colspan="2" align="center">
					<cfif modo NEQ 'ALTA'>
						<!--- Campos para la insercion y borrado de las materias para el grupo --->
						<input type="hidden" name="RHGMid" value="">
						<input type="hidden" name="RHGMcodigo" value="">
						<input type="hidden" name="Descripcion" value="">
						<input type="hidden" name="bandBorrar" value="0">
						<table width="80%" border="0" cellpadding="0" cellspacing="0" class="areaFiltro">
						  <tr>
							<td align="center">
								<strong>#LB_ElCursoPerteneceALosSiguientesGrupos#</strong>&nbsp;&nbsp;&nbsp;
							</td>
						  </tr>		
						  <tr>
							<td align="center">&nbsp;</td>
						  </tr>		  			
							<cfif isdefined('rsGruposMat') and rsGruposMat.recordCount GT 0>
								<cfloop query="rsGruposMat">
								  <tr>
									<td width="78%">#rsGruposMat.Descripcion#</td>
								  </tr>
								</cfloop>
							</cfif>
						  <tr>
							<td align="center">&nbsp;</td>
						  </tr>	
						</table>				
					</cfif>
				</td>
			</tr>						
	  </table>
		<input type="hidden" name="Mcodigo" value="<cfif modo EQ "CAMBIO">#HTMLEditFormat(data.Mcodigo)#</cfif>">
		<input type="hidden" name="Ecodigo" value="<cfif modo EQ "CAMBIO">#HTMLEditFormat(data.Ecodigo)#</cfif>">
		<input type="hidden" name="BMfecha" value="<cfif modo EQ "CAMBIO">#HTMLEditFormat(data.BMfecha)#</cfif>">
		<input type="hidden" name="BMUsucodigo" value="<cfif modo EQ "CAMBIO">#HTMLEditFormat(data.BMUsucodigo)#</cfif>">
		<cfif modo EQ "CAMBIO">
		<cfset ts = "">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
			artimestamp="#data.ts_rversion#" returnvariable="ts">
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
		</cfif>
	</form>
	
</cfoutput>

<script language="JavaScript" type="text/javascript">
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
	//Llama el conlis
	function doConlisGrupos() {
		var params ="";
		<cfif modo neq 'ALTA'>
			params = "<cfoutput>?form=form1&id=RHGMid&cod=RHGMcodigo&desc=Descripcion&conexion=#session.dsn#&quitar=#ValueList(rsGruposMat.RHGMid)#</cfoutput>";
			popUpWindow("/cfmx/rh/Utiles/ConlisGrupoMaterias.cfm"+params,250,200,650,400);
		</cfif>
	}	
	
	function borrarCurso(cod){
		if ( confirm('¿Desea borrar este grupo ?') ) {
			document.form1.RHGMid.value = cod;
			document.form1.bandBorrar.value = 1;
			document.form1.submit();
		}		
	}
	
	function funcRHGMcodigo(){
		//Cuando bandBorrar vale 2 significa que se va a hacer una insercion
		document.form1.bandBorrar.value = 2;
		document.form1.submit();
	}	
</script>