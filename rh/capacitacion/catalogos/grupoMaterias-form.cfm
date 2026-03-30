<cfset modo = "ALTA">
<cfset modoDetalle = "ALTA">
<cfif isdefined("form.RHGMid") and len(trim(form.RHGMid))>
	<cfset modo = "CAMBIO">
</cfif>
<cfif modo EQ "CAMBIO">
	<cfset modoDetalle = "ALTA">
</cfif>


<cfquery datasource="#session.dsn#" name="areas">
		select RHAGMid, RHAGMnombre
		from RHAreaGrupoMat
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		order by RHAGMnombre
	</cfquery>
			
<cfif modo neq 'ALTA'>
	<cfquery name="data" datasource="#session.DSN#">
		select RHGMid, RHGMcodigo, Descripcion, RHAGMid , RHGMperiodo, ts_rversion
		from RHGrupoMaterias
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHGMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHGMid#">
	</cfquery>
	
	<cfquery name="rsMat" datasource="#session.DSN#">
		Select mg.Mcodigo, Mnombre , m.Msiglas , mg.RHMGperiodo , mg.RHMGimportancia , mg.RHMGsecuencia
		from RHMateriasGrupo mg
			inner join RHMateria m
				on m.Mcodigo=mg.Mcodigo
					and m.Ecodigo=mg.Ecodigo
		where mg.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHGMid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHGMid#">
	</cfquery>
	<cfquery name="nextseq" dbtype="query">
		select max(RHMGsecuencia)+10 as nextseq
		from rsMat
	</cfquery>
</cfif>


<cfoutput>
<script language="javascript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
<form name="form1" action="grupoMaterias-sql.cfm" method="post">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td align="right"><strong>C&oacute;digo:&nbsp;</strong></td>
			<td><input type="text" name="RHGMcodigo" size="10" maxlength="15" value="<cfif modo neq 'ALTA'>#trim(data.RHGMcodigo)#</cfif>" onfocus="this.select();" ></td><!----<cfif modo neq 'ALTA'>readonly</cfif>---->
		</tr>
		<tr>
			<td align="right"><strong>Descripci&oacute;n:&nbsp;</strong></td>
			<td><input type="text" name="Descripcion" size="60" maxlength="80" value="<cfif modo neq 'ALTA'>#trim(data.Descripcion)#</cfif>" onfocus="this.select();"></td>
		</tr>
		<tr>
			<td align="right"><strong>&Aacute;rea de Programas:&nbsp;</strong></td>
			<td><select name="RHAGMid" id="RHAGMid">
				<option value="">-seleccione-</option>
				<cfloop query="areas">
					<option value="#areas.RHAGMid#" <cfif modo neq 'ALTA' and areas.RHAGMid eq data.RHAGMid>selected</cfif>>#HTMLEditFormat(areas.RHAGMnombre)#</option>
				</cfloop>
			</select>
			</td>
		</tr>
		<tr>
			<td align="right"><strong>Periodicidad (meses) :&nbsp;</strong></td>
			<td><input type="text" name="RHGMperiodo" size="5" maxlength="3" value="<cfif modo neq 'ALTA'>#trim(data.RHGMperiodo)#</cfif>" style="text-align: right;" onBlur="javascript:fm(this,0); "  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"></td>
		</tr>

		<!--- Botones --->
		<tr>
		  <td>&nbsp;</td>
		  <td>&nbsp;</td>
	  </tr>
		<tr><td>&nbsp;</td><td>&nbsp;</td></tr>
		<tr><td colspan="2" align="center">
		<cfif modo eq 'ALTA'>
			<input type="submit" name="Alta" value="Agregar" onClick="javascript: habilitarValidacion();">
			<input type="reset" name="Limpiar" value="Limpiar">
		<cfelse>
			<input type="submit" name="Cambio" value="Modificar" onClick="habilitarValidacion();">
			<input type="submit" name="Baja" value="Eliminar" onClick="if ( confirm('Desea eliminar el registro?') ){deshabilitarValidacion(); return true;} return false;">
			<input type="submit" name="Nuevo" value="Nuevo" onClick="deshabilitarValidacion();">
		</cfif>
		</td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr align="center">
			<td colspan="2">
				<cfif modo NEQ 'ALTA'>
					<!--- Campos para la insercion y borrado de las materias para el grupo --->
					<input type="hidden" name="bandBorrar" value="0">
					<table border="0" cellpadding="0" cellspacing="0" class="areaFiltro">
					  <tr>
						<td colspan="5" align="center">
							<strong><cf_translate key="LB_ListaCursosComponenPrograma">Lista de cursos que componen este Programa</cf_translate> </strong>&nbsp;&nbsp;&nbsp;
						</td>
					  </tr>		
					  <tr>
					    <td colspan="5" align="center">&nbsp;</td>
				      </tr>
					  <tr>
					    <td align="center">Curso</td>
				        <td colspan="4" align="left">
						<input type="hidden" name="Mcodigo" value="">
						<input type="hidden" name="Msigla" value="">
						<input name="Mnombre" type="text" readonly  id="Mnombre" onfocus="this.select();" value="" size="40" maxlength="60">
			            <a href="##" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="Agregar un nuevo curso a este grupo" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisCursos();'></a></td>
					  </tr>
					  <tr>
					    <td align="center">Periodicidad (meses): </td>
				        <td colspan="4" align="left"><input type="text" name="RHMGperiodo" size="20" maxlength="3" value="" style="text-align: right;" onBlur="javascript:fm(this,0); "  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"></td>
					  </tr>
					  <tr>
					    <td align="center">Importancia:</td>
					    <td colspan="4" align="left"><select  name="RHMGimportancia">
					      <option value="10">Opcional</option>
					      <option value="20">Complementario</option>
					      <option value="30">Deseable</option>
					      <option value="40">Obligatorio</option>
				        </select></td>
				      </tr>
					  <tr>
					    <td align="center">Secuencia</td>
				        <td colspan="4" align="left"><input type="text" name="RHMGsecuencia" size="20" maxlength="3" value="<cfif Len(nextseq.nextseq)>#nextseq.nextseq#<cfelse>10</cfif>" onfocus="this.select();">
						<input type="hidden" name="modoDetalle" value="NA"><!----Input con el ---->
						<input type="submit" value="Agregar" name="AgregarDet" onClick="javascript: funcCurso()">
						</td>
					  </tr>
					  <tr>
					    <td colspan="5" align="center">&nbsp;</td>
				      </tr>
					  <tr>
						<td colspan="5" align="center">&nbsp;</td>
					  </tr>
					  <tr><td colspan="5"><table width="100%">
							  <tr>
							    <td align="center">&nbsp;</td>
							    <td colspan="2"><strong>Materia</strong></td>
							    <td><strong>Periodo</strong></td>
							    <td><strong>Importancia</strong></td>
							    <td><strong>Sec</strong></td>
						      </tr>
							<cfloop query="rsMat">
							  <tr>
								<td align="center">
									<a href="javascript: borrarCurso('#rsMat.Mcodigo#');">
									<img border="0" src="/cfmx/rh/imagenes/Borrar01_S.gif" alt="Eliminar Curso">
									</a>	
								  </td>
								<td>#rsMat.Msiglas# </td>
								
							    <td>#rsMat.Mnombre#</td>
							    <td align="center"><cfif Len(RHMGperiodo)>#RHMGperiodo#<cfelse>-</cfif></td>
							    <td> 
						  <cfif RHMGimportancia eq 10>
						  	Opcional
						  <cfelseif RHMGimportancia eq 20>
						  	Complementario
						  <cfelseif RHMGimportancia eq 30>
						  	Deseable
						  <cfelseif RHMGimportancia eq 40>
						  	Obligatorio
							<cfelse>#RHMGimportancia#
						  </cfif>
								</td>
							    <td>#RHMGsecuencia#</td>
							  </tr>
							</cfloop> </table></td></tr> 			 
					  <tr>
						<td colspan="5" align="center">&nbsp;</td>
					  </tr>	
					</table>				
				</cfif>
			</td>
		</tr>		
		<tr><td colspan="2">&nbsp;</td></tr>		
	</table>

	<cfif modo neq 'ALTA'>
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
		<input type="hidden" name="RHGMid" value="#trim(data.RHGMid)#">
	</cfif>
</form>
</cfoutput>

<script language="JavaScript" type="text/javascript">	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.RHGMcodigo.required = true;
	objForm.RHGMcodigo.description="Código";				
	objForm.Descripcion.required= true;
	objForm.Descripcion.description="Descripción";	

	<cfoutput>
		objForm.RHGMcodigo.description="#JSStringFormat('Código')#";
		objForm.Descripcion.description="#JSStringFormat('Descripción')#";
	</cfoutput>
	
	
	<cfif modo NEQ 'ALTA'>		
		objForm.RHMGimportancia.required = true;
		objForm.RHMGimportancia.description = "Importancia";
		objForm.RHMGsecuencia.required = true;
		objForm.RHMGsecuencia.description = "Secuencia";
	</cfif>
	
	function funcCurso(){
		objForm.Mnombre.required = true;
		objForm.Mnombre.description="Curso";
	}
	
	
	function habilitarValidacion(){
		objForm.RHGMcodigo.required = true;
		objForm.Descripcion.required = true;
	}

	function deshabilitarValidacion(){
		objForm.RHGMcodigo.required = false;
		objForm.Descripcion.required = false;
	}
	
	function borrarCurso(cod){
		if ( confirm('¿Desea borrar este curso del grupo actual ?') ) {
			document.form1.Mcodigo.value = cod;
			document.form1.bandBorrar.value = 1;
			document.form1.submit();
		}		
	}
	
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindow(URLStr, left, top, width, height)
	{
		if(popUpWin)
		{
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
	//Llama el conlis
	function doConlisCursos() {
		var params ="";
		<cfif modo neq 'ALTA'>
			params = "<cfoutput>?form=form1&id=Mcodigo&name=Mnombre&sigla=Msigla&conexion=#session.dsn#&quitar=#ValueList(rsMat.Mcodigo)#</cfoutput>";
			popUpWindow("/cfmx/rh/Utiles/ConlisRHMateria.cfm"+params,250,200,650,400);
		</cfif>
	}	
	
	function funcMnombre(){
		//Cuando bandBorrar vale 2 significa que se va a hacer una insercion
		document.form1.bandBorrar.value = 2;
	}
	
</script>
