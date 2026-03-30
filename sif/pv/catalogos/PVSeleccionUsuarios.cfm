
<!-------------------------------- ASOCIA USUARIO A UNA CAJA --------------->
<cfset var = ''>
<cfif isdefined("sbm_usuarios")>
	<cfset diferencia=#datediff("d",finicial,ffinal)#>
	<!---<cfquery datasource="#session.dsn#" name="rsVerificain">
		Select Usucodigo
		from FAM000
		where FAM01COD=	<cfqueryparam cfsqltype="cf_sql_char" value="#FAM01COD#">
		and Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Usucodigo#">
	</cfquery>
	
	<cfif rsVerificain.recordcount gt 0>
		<script>
			alert("El usuario que usted esta asociando ya se encuentra asociado a esta caja")			
		</script>
	<cfelse>--->
		<!---- rebeca--->
		<cfquery datasource="#session.dsn#" name="rsVerificainCAJAS">
			Select Usucodigo
			from FAM000
			where Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Usucodigo#">
			and FAM00INI = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(finicial)#"<!---"#FAM00INI#"--->>
			and FAM00FIN = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(ffinal)#" <!---#FAM00FIN#"--->>
		</cfquery>
			
		<!---- usuario por caja a la vez--->
		<cfif rsVerificainCAJAS.recordcount NEQ 0>
			<script>
				alert("El usuario que usted esta asociando ya se encuentra asociado a otra caja en este rango de fechas")			
			</script>
		<cfelse>
			<!--- Relaciona de los usuarios a la caja --->
			<cfquery datasource="#session.dsn#" name="rsInclusioncon">
				Insert into FAM000(Ecodigo, Usucodigo, FAM01COD, FAM00INI, FAM00FIN, BMUsucodigo, fechaalta)
				values(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#FAM01COD#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(finicial)#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(ffinal)#">,					
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
			</cfquery>
		</cfif>
	<!---</cfif>--->
</cfif>

<!---------------     FUNCION PARA BORRAR UN REGISTRO DE USUARIOS POR CAJA --------------------->
<cfif isdefined("bandBorrar")>
	<cfquery datasource="#session.dsn#" name="rsBorrarcon">
		Delete from FAM000
		where Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and FAM01COD  = <cfqueryparam cfsqltype="cf_sql_char" value="#B_FAM01COD#">
		  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#B_Usucodigo#">
	</cfquery> 
	<!---<script>alert("El Curso ha sido eliminado")</script>--->
</cfif>


<!------------------ CONSULTA PARA LA LISTA DE LOS USUARIOS POR CAJA SELECCIONDA-------------->
<cfif isdefined("FAM01COD")>
	<!--- Se seleccionan todos los usuarios relacionados a una caja --->
	<cfquery datasource="#session.dsn#" name="rs_Cusuarios">
		Select A.FAM01COD, A.FAM01CODD, B.FAM00INI, B.FAM00FIN, B.Usucodigo, C.Usulogin, D.Pnombre + ' ' + D.Papellido1 + ' ' + D.Papellido2 as Nombre
		from FAM001 A, FAM000 B, Usuario C, DatosPersonales D
		where  A.FAM01COD 	= B.FAM01COD
			and B.Usucodigo 	= C.Usucodigo			   
			and C.datos_personales = D.datos_personales
  			and C.Uestado 	= 1
			and A.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and A.FAM01COD 	= <cfqueryparam cfsqltype="cf_sql_char" value="#FAM01COD#">
			Order by C.Usulogin
	</cfquery>
	
	<cfset nombreqry = "rs_Cusuarios">
	<cfset Uslista= "">
	
	<cfoutput query="rs_Cusuarios">
		<cfif Uslista eq "">
			<cfset Uslista= #Usucodigo#>
		<cfelse>
			<cfset Uslista= Uslista & "," & #Usucodigo#>
		</cfif>
	</cfoutput>

	<!--- Listado de Usuarios de acuerdo a los filtros --->
	<cfquery datasource="#session.dsn#" name="rsUsuarios">
	Select A.Usucodigo, A.Usulogin, B.Pnombre + ' ' + B.Papellido1 + ' ' + B.Papellido2 as Nombre
	from Usuario A, DatosPersonales B
	where A.datos_personales = B.datos_personales
	  and A.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	  <cfif isdefined("F_Usulogin") and trim(F_Usulogin) gt 0>
	  and upper(Usulogin) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(F_Usulogin)#%">
	  </cfif>
	  <cfif isdefined("F_Usunombre") and trim(F_Usunombre) gt 0>
	  and  upper(B.Pnombre + ' ' + B.Papellido1 + ' ' + B.Papellido2) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(F_Usunombre)#%">
	  </cfif>	  
	</cfquery>
	
</cfif>

<!---------------------------------- PINTA   XXXXXXXX ------------------------------------------->

<form name="frm_FiltroUsuarios" action="PVUsariosporCaja.cfm" method="post">
	<input type="hidden" name="F_Usulogin">
	<input type="hidden" name="F_Usunombre">	
	<input type="hidden" name="F_Usucodigo">	
	<input type="hidden" name="btnBuscar">
	<!--- Para que el com entre recargado --->
	<input type="hidden" name="FAM01COD" value="<cfif isdefined("Form.FAM01COD")><cfoutput>#FAM01COD#</cfoutput></cfif>">
	<input type="hidden" name="FAM01CODD" value="<cfif isdefined("Form.FAM01CODD")><cfoutput>#FAM01CODD#</cfoutput></cfif>">
	<input type="hidden" name="FAM01DES" value="<cfif isdefined("Form.FAM01DES")><cfoutput>#FAM01DES#</cfoutput></cfif>">
</form>


<!------------------------- PINTA LA LISTA DE LOS USUARIOS POR CAJA SELECCIONDA------------------->

<form name="frm_UsuariosPC" action="PVUsariosporCaja.cfm" method="post">
<cfoutput>
	<table summary="Tabla de entrada" cellpadding="0" cellspacing="0" width="100%">
		<tr><td colspan="3">&nbsp;</td></tr>
		<tr>
			<td>&nbsp;</td>
			<td class="tituloListas" colspan="3" align="center"><strong>C&oacute;digo:&nbsp;<cfif isdefined("form.FAM01CODD") and len(trim(form.FAM01CODD))>#form.FAM01CODD#</strong></td>
		</tr></cfif></strong></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td class="tituloListas" colspan="3" align="center"><strong>Descripci&oacute;n:&nbsp;<cfif isdefined("form.FAM01DES") and len(trim(form.FAM01DES))>#form.FAM01DES#</cfif></strong></td>
		</tr>
		
		<cfif not isdefined("FAM01COD")>
			<tr>
				<td colspan="4" align="center">
					Seleccione una caja para poder agregar usuarios a la misma.
				</td>
			</tr>
		<cfelse>		
			<tr>
				<td colspan="4">
					<table align="center" summary="Tabla de entrada" cellpadding="0" cellspacing="0" width="90%">
						<tr>
						  <td colspan="5" class="subTitulo" align="center"> <font size="2">Usuarios Relacionados a la caja</font></td>
					  </tr>
						<tr>
						  <td colspan="1">&nbsp;</td>
						  <td colspan="1" >&nbsp;</td>
						  <td colspan="1" >&nbsp;</td>
						  <td colspan="1" >&nbsp;</td>
						  <td colspan="1">&nbsp;</td>
					  </tr>
						<tr>
							<td colspan="1" class="subTitulo"> Login</td>
							<td colspan="1" class="subTitulo"> Usuario</td>
							<td colspan="1" class="subTitulo">&nbsp; </td>
							<td colspan="1" class="subTitulo"> Fecha Inicial</td>
							<td colspan="1" class="subTitulo"> Fecha Final</td>
						</tr>
						<tr><td width="13%">&nbsp;</td></tr>			
						<cfif evaluate(#nombreqry# & ".recordcount") gt 0>
							<cfloop query="#nombreqry#">
							<tr>
							  	  <td>#Usulogin#</td>
								   <td width="42%">#Nombre#</td>
								 
								  <!---<td width="15%">#FAM00FIN#</td>--->
								  <td width="10%" align="left">
								  	  <cfset V_FAM01COD  = #trim(FAM01COD)#>
									  <cfset V_Usucodigo = #Usucodigo#>
									  <a href="javascript: borrarUsuario('#V_FAM01COD#','#V_Usucodigo#');">
									  <img border="0" src="/cfmx/sif/imagenes/Borrar01_S.gif" alt="Eliminar este usuario">
								  </a></td>
								  <td width="19%">#LSDateFormat(FAM00INI,"dd/mm/yy")#</td> 
								  <td width="16%">#LSDateFormat(FAM00FIN,"dd/mm/yy")#
																
							  	</td>
						   </tr>
						  </cfloop>			
					  <cfelse>
							<tr>
								<td colspan="5" align="center">No hay Usuarios Relacionadas a la caja</td>
							</tr>
						</cfif>
					</table>
				</td>
			</tr>
			<tr><td colspan="4">&nbsp;</td></tr>		
			<tr>
				<td colspan="4">
					<table align="center" border="0" summary="Tabla de entrada" cellpadding="0" cellspacing="0" width="90%" ><!---class="areaFiltro"--->
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td colspan="5">
								<table border="0" align="center" summary="Tabla de entrada" cellpadding="0" cellspacing="0" width="100%" ><!---class="areaFiltro"--->
								<tr>
									<td colspan="4" class="subTitulo" align="center">
										Asociaci&oacute;n de Usuarios
									</td>
								</tr>												
								<tr><td>&nbsp;</td></tr>
								<tr>
									<td align="right" width="25%"><strong>Usuario:&nbsp;</strong></td>
									<td colspan="2">								
										<cf_sifusuario name="F_login" form="frm_UsuariosPC">								
									</td>														
								</tr>
								<tr>
									<td align="right"><strong>Fecha Inicial:&nbsp;</strong></td>
									<td colspan="2">
										<cf_sifcalendario name="finicial" form="frm_UsuariosPC" value="#dateformat(Now(),"dd/mm/yyyy")#">
									</td>					
								</tr>
								<tr>
									<td align="right"><strong>Fecha Final:&nbsp;</strong></td>
									<td colspan="2">
										<cf_sifcalendario name="ffinal" form="frm_UsuariosPC" value="#dateformat(Now(),"dd/mm/yyyy")#">
									</td>
								</tr>						
								</table>
							</td>
						</tr>									
						<tr><td>&nbsp;</td></tr>
						<tr><td>&nbsp;</td></tr>				
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td colspan="3" align="center">
								<input type="submit" name="sbm_usuarios" value="Asociar Usuario" style="width:100px" onClick="javascript: return validacampos(document.frm_UsuariosPC.finicial.value,document.frm_UsuariosPC.ffinal.value);">
								<input type="reset" name="rst_usuarios" value="Limpiar" style="width:100px">
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						</table>		
					</td>
				</tr>	
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td align="center" colspan="4">
						<!---<cfif nombreqry eq "rsM_conocimientos">
							<cfset codigocomp = evaluate(#nombreqry# & ".RHCid")> 
						<cfelse>
							<cfset codigocomp = evaluate(#nombreqry# & ".RHHid")> 
						</cfif>
		
						 Para que el com entre recargado --->
						<input type="hidden" name="FAM01COD" value="<cfif isdefined("Form.FAM01COD")>#FAM01COD#</cfif>">
						<input type="hidden" name="FAM01CODD" value="<cfif isdefined("Form.FAM01CODD")>#FAM01CODD#</cfif>">				
						<input type="hidden" name="FAM01DES" value="<cfif isdefined("Form.FAM01DES")>#FAM01DES#</cfif>">				
						<input type="hidden" name="FAM01TIP" value="<cfif isdefined("Form.FAM01TIP")>#FAM01TIP#</cfif>">
										
						<input type="hidden" name="fhoy" value="#dateformat(Now(),'yyyymmdd')#">
						<input type="hidden" name="RHcodigo" value="<cfif isdefined("Form.id")>#id#</cfif>">
					</td>
				</tr>
			</cfif>
		</table>
  </cfoutput>
</form>

<!----------------------------- NO SE QUE HACE   ----------------------------------------------------->
<cfoutput>
	<form action="PVUsariosporCaja.cfm" method="post" name="form1">
		<!--- Para que el com entre recargado --->
		<input type="hidden" name="FAM01COD" value="<cfif isdefined("Form.FAM01COD")>#FAM01COD#</cfif>">
		<input type="hidden" name="FAM01CODD" value="<cfif isdefined("Form.FAM01CODD")>#FAM01CODD#</cfif>">				
		<input type="hidden" name="FAM01DES" value="<cfif isdefined("Form.FAM01DES")>#FAM01DES#</cfif>">				
		<input type="hidden" name="FAM01TIP" value="<cfif isdefined("Form.FAM01TIP")>#FAM01TIP#</cfif>">
		
		<input name="B_FAM01COD" type="hidden">
		<input name="B_Usucodigo" type="hidden">
		<input name="bandBorrar" type="hidden">
	</form>
</cfoutput>

<!---------------------------------------- FUNCIONES -------------------------------------------------->
<script>
	function FiltrarUsr(f_log,f_nom){
		document.frm_FiltroUsuarios.F_Usulogin.value  = f_log;
		document.frm_FiltroUsuarios.F_Usunombre.value = f_nom;
		document.frm_FiltroUsuarios.submit();
	}
	function borrarUsuario(cod,usu){
		if ( confirm('¿Desea eliminar el registro?') ) {
			document.form1.B_FAM01COD.value  = cod;
			document.form1.B_Usucodigo.value = usu;
			document.form1.bandBorrar.value = 1;
			document.form1.submit();
		}		
	}
	function VALIDAFECHAS(INICIO,FIN){
		var valorINICIO=0
		var valorFIN=0
		INICIO = INICIO.substring(6,10) + INICIO.substring(3,5) + INICIO.substring(0,2)
		FIN = FIN.substring(6,10) + FIN.substring(3,5) + FIN.substring(0,2)
		valorINICIO = parseInt(INICIO)
		valorFIN = parseInt(FIN)
		if (valorINICIO > valorFIN)
		   return false;
		return true;
	}		
	function validacampos(INICIO,FIN){
		if (document.frm_UsuariosPC.Usucodigo.value == "") {
			alert("Es necesario seleccionar un usuario");
			return false;
		}
		else {
			if (!VALIDAFECHAS(INICIO,FIN)) {
				alert("El rango de fechas digitado es incorrecto. Verfique");
				return false;
			}
			return true;
		}
		return true;
	}
</script>