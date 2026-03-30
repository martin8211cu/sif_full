<form name="formPES" action="PlanEstudiosBloques_SQL.cfm" method="post" onSubmit="return validaPlanEstVersion(this);">
<cfoutput>
<table width="100%" border="0" cellpadding="0" cellspacing="0" dwcopytype="CopyTableColumn">
	<tr> 
		<td align="right" class="fileLabel">Total Bloques:</td>
		<td align="left" class="fileLabel" nowrap>
			<input name="PESbloques" tabindex="11" style="text-align: right;" type="text" id="PESbloques" <cfif isdefined('LvarModificarBloques') and LvarModificarBloques EQ false>class="Cajasinbordeb" readonly</cfif> size="1" maxlength="2" value="#rsPES.PESbloques#" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,0);"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">		
			#LvarTipoDuracionPlural# 
		<cfif isdefined('LvarModificarBloques') and LvarModificarBloques EQ true>
			<input type="submit" name="btnPESCambio" value="Generar"
				 onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacion) habilitarValidacion();"> 
		</cfif>
		
		<input type="button" name="btnIrALista" value="Ir a Lista de Carreras y Planes"
			onClick="javascript: irALista();">		
		</td>
	</tr>

  <tr> 
	<td colspan="2" align="center"> 
		<input type="hidden" name="botonSel" value="">	
	</td>
  </tr>
</table>
</cfoutput>
<cfoutput>
	<cfparam name="form.modo" default="">
	<cfparam name="form.MPcodigo" default="">
	<cfparam name="form.Mcodigo" default="">

<input type="hidden" name="CILcodigo" value="#rsPES.CILcodigo#">
<input type="hidden" name="CARcodigo" value="#form.CARcodigo#">
<input type="hidden" name="PEScodigo" value="#form.PEScodigo#">
<input type="hidden" name="TipoDuracion" value="#LvarTipoDuracion#">
<input type="hidden" name="PBLsecuencia" value=""> 
<!---<input type="hidden" name="PBLnombre" value=""> --->
<input type="hidden" name="MPcodigo" value="<cfif isdefined("form.MPcodigo")>#form.MPcodigo#</cfif>">
<input type="hidden" name="Mcodigo" value="<cfif isdefined("form.Mcodigo")>#form.Mcodigo#</cfif>">

<input type="hidden" name="modo" value="<cfif isdefined("form.modo")>#form.modo#</cfif>">
<input type="hidden" name="MPmodo" value="<cfif isdefined("form.MPmodo")>#form.MPmodo#</cfif>">
<input type="hidden" name="nivel" value="2">
<input type="hidden" name="T" value="2">
<input type="hidden" name="TabsPlan" value="3">

</cfoutput>

<br>
<TABLE cellSpacing=0 cellPadding=0 border=0 width="100%">
  <tr>
	<td valign="top" width="70%">
		<TABLE cellSpacing=0 cellPadding=1 border=0 width="100%">
			<TR>
				<TD class="tituloListas">Codigo</TD>
				<TD class="tituloListas">Materia</TD>
				<TD class="tituloListas">Tipo</TD>
				<TD class="tituloListas" align="center"><cfoutput>#session.parametros.Creditos#</cfoutput></TD>
				<TD class="tituloListas">Requisitos</TD>
				<TD class="tituloListas"></TD>
			</TR>
			<cfif rsPBL_MP.recordCount EQ 0>
			<TR>
				<TD colSpan=7 class="BloqueMatricula">No existen Bloques definidos en el Plan</TD>
			</TR>
			<cfelse>
			  <cfset LvarPBLsecAnt = "">
			  <cfoutput query="rsPBL_MP">
				<cfif LvarPBLsecAnt NEQ rsPBL_MP.PBLsecuencia>
					<cfset LvarPBLsecAnt = rsPBL_MP.PBLsecuencia>
					<cfif isdefined('LvarModificarBloques') and LvarModificarBloques EQ true>
						<TR>
							<TD colSpan=7 class="BloqueMatricula">
							  <input name="PBLnombre" value="#rsPBL_MP.PBLnombre#" class="BloqueMatricula" size="35">					
							  <input name="PBLnombre_SEC" type="hidden" value="#rsPBL_MP.PBLsecuencia#">
							  <input type="image" name="btnPBLcambiar" src="../../imagenes/iconos/folder_save.gif"
									onclick="javascript: 
										document.formPES.modo.value = 'PBLcambiar';
										document.formPES.submit();"
									title="Modificar la descripción del Bloque"
							  >

							  <input type="image" name="btnMPnuevo" src="../../imagenes/iconos/leave_add.gif"
									onclick="javascript:
										document.formPES.PBLsecuencia.value = '#rsPBL_MP.PBLsecuencia#';
										document.formPES.MPcodigo.value = '';
										document.formPES.Mcodigo.value = '';
										document.formPES.modo.value = 'MPalta';
										document.formPES.action='';
										document.formPES.submit();"
									title="Agregar una Materia al Bloque"
							  > 
							</TD>
						</TR>
					<cfelse>
						<TR bgcolor="##C0D1E4">
							<TD colSpan=7 class="BloqueMatricula">
								<strong>#rsPBL_MP.PBLnombre#</strong>
							</TD>
						</TR>
					</cfif>
					<cfset LvarLista="ListaPar">
				</cfif>
				<cfif rsPBL_MP.MPcodigo EQ "">
				<TR>
					<TD>&nbsp;</TD>
					<TD colSpan=6><strong>No existen Materias definidas en el Bloque</strong></TD>
				</TR>
				<cfelse>
					<cfif LvarLista NEQ "ListaPar">
						<cfset LvarLista="ListaPar">
					<cfelse>
						<cfset LvarLista="ListaNon">
					</cfif>
                <tr class="#LvarLista#" onmouseover="GvarColorLista=style.backgroundColor; style.backgroundColor='##E4E8F3'; style.cursor='hand'" onmouseout="style.backgroundColor=GvarColorLista; style.cursor='default'"> 
<!--- 					<TD nowrap>
						<cfif #rsPBL_MP.MPcodigo# EQ #form.MPcodigo#>
						  <img src="#Session.JSroot#/imagenes/lista/addressGo.gif" width="16" height="16"> 
						</cfif>
					</TD>
 --->					
                <TD nowrap	onClick="javascript: ligaCambio('#rsPBL_MP.MPcodigo#','#rsPBL_MP.PBLsecuencia#','#rsPBL_MP.Mcodigo#','#rsPBL_MP.Mtipo#');"> 
                  #rsPBL_MP.Mcodificacion#</TD>
					<TD nowrap 	onClick="javascript: ligaCambio('#rsPBL_MP.MPcodigo#','#rsPBL_MP.PBLsecuencia#','#rsPBL_MP.Mcodigo#','#rsPBL_MP.Mtipo#');">#rsPBL_MP.Mnombre#</TD>
					<TD nowrap 	onClick="javascript: ligaCambio('#rsPBL_MP.MPcodigo#','#rsPBL_MP.PBLsecuencia#','#rsPBL_MP.Mcodigo#','#rsPBL_MP.Mtipo#');"><cfif rsPBL_MP.Mtipo EQ "M">Regular<cfelse>Electiva</cfif></TD>
					<TD align="center" 	onClick="javascript: ligaCambio('#rsPBL_MP.MPcodigo#','#rsPBL_MP.PBLsecuencia#','#rsPBL_MP.Mcodigo#','#rsPBL_MP.Mtipo#');">#rsPBL_MP.Mcreditos#</TD>
					<TD onClick="javascript: ligaCambio('#rsPBL_MP.MPcodigo#','#rsPBL_MP.PBLsecuencia#','#rsPBL_MP.Mcodigo#','#rsPBL_MP.Mtipo#');" style="text-indent: 0px;"><cfif rsPBL_MP.Mtipo EQ "M">#replace(rsPBL_MP.Mrequisitos,"-","&##8209;","all")#</cfif></TD>
					<TD nowrap>
					<cfif isdefined('LvarModificarBloques') and LvarModificarBloques EQ true>
						<input type="image" src="../../imagenes/iconos/array_up.gif"
								onclick="javascript:
									document.formPES.MPcodigo.value = '#rsPBL_MP.MPcodigo#';
									document.formPES.modo.value = 'MParriba';"
						>
						<input type="image" src="../../imagenes/iconos/array_dwn.gif"
								onclick="javascript:
									document.formPES.MPcodigo.value = '#rsPBL_MP.MPcodigo#';
									document.formPES.modo.value = 'MPabajo';"
						>
						<input name="equisBorraMateria" type="image" src="../../imagenes/iconos/leave_del.gif" onclick="javascript: borraMater('#rsPBL_MP.MPcodigo#','#rsPBL_MP.PBLsecuencia#')" width="16" height="16" border="0">
					</cfif>
					</TD>
				</TR>
				</cfif>
			  </cfoutput>
			</cfif>
		</TABLE>
</form>		
	</TD>
  </tr>
</table>

<script language="JavaScript" type="text/javascript">
	function irALista(){
		location.href='/cfmx/educ/director/planAcademico/CarrerasPlanes.cfm';
	}
//---------------------------------------------------------------------------------------			
	botonActual = "";
	
	function btnSelected(name, f) {
		if (f != null) {
			return (f["botonSel"].value == name)
		} else {
			return (botonActual == name)
		}
	}	
//------------------------------------------------------------------------------------		
	function validaPlanEstVersion(varform){
		if(btnSelected('btnPESCambio',document.formPES)){
			if (document.formPES.PEShasta && document.formPES.btnNuevaVersion && document.formPES.PEShasta.value != ''){
			  alert('Para digitar la vigencia hasta debe utilizar el botón <Nueva Version>');
			  return false;
			}
			if(document.formPES.PESbloques.value == ''){
			  alert('Error, debe digitar la cantidad de bloques');
			  document.formPES.PESbloques.focus();
			  return false;			
			}
			else
			{
				if (parseInt(document.formPES.PESbloques.value) < <cfoutput>#rsPES.PESbloques#</cfoutput>)
				{
					return confirm('El número de bloques es menor al actual, \nse van a borrar bolques existentes con todas sus materias. \n\n¿Desea continuar?');
				}
			}
		}

			
		return true;	
	}
//---------------------------------------------------------------------------	
	function borraMater(cod,secuencia){
		if(confirm('Desea eliminar esta materia del bloque ?')){
 			document.formPES.PBLsecuencia.value = secuencia;
			document.formPES.MPcodigo.value = cod;			
			document.formPES.modo.value = 'MPborrar';
			document.formPES.submit();		
		}else{
			document.formPES.action = 'CarrerasPlanes.cfm';
		}
	}
//----------------------------------------------------------
	function ligaCambio(MPcodigo,PBLsecuencia,Mcodigo,Mtipo){
		<cfif isdefined('LvarModificarBloques') and LvarModificarBloques EQ true>
			document.formPES.MPcodigo.value = MPcodigo;
			document.formPES.PBLsecuencia.value = PBLsecuencia;
			document.formPES.modo.value='MPcambio';
			document.formPES.Mcodigo.value = Mcodigo;
			document.formPES.T.value=Mtipo;			
			document.formPES.action='';
			document.formPES.submit();		
		</cfif>
	}
</script>
   
