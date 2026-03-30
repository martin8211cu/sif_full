<!--- Responsables por Almacén --->
<!--- Inicio del Mantenimiento --->
<!--- Validaciones Iniciales --->
<cfif not isdefined("Form.Aid")>
	<cf_errorCode	code = "50392" msg = "El Aid no está Definido en el Form. <BR> El Aid, código de Almacén, debe estar definido en Form.">
	<cfabort>
</cfif>

<!--- Asignaciones Iniciales --->
<cfset RequiredKey = -1>
<!--- Validaciones Iniciales --->
<cfif not len(trim(RequiredKey))>
	<cflocation url="../indexSif.cfm">
</cfif>
<cfinclude template="../../Utiles/sifConcat.cfm">
<!--- Consultas Iniciales --->
<cfquery name="rsResponsables" datasource="#Session.DSN#">
	select ar.Aid, ar.Usucodigo, ar.Ulocalizacion,
			(d.Papellido1 #_Cat# ' ' #_Cat# d.Papellido2 #_Cat# ' ' #_Cat# d.Pnombre) as NombreCompleto
	from Usuario u
		inner join DatosPersonales d
			on u.datos_personales = d.datos_personales
		inner join AResponsables ar
			on  u.Usucodigo = ar.Usucodigo
		inner join Almacen a
			on ar.Aid = a.Aid	
				and ar.Ocodigo = a.Ocodigo
				and ar.Ecodigo = a.Ecodigo
	where ar.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#">
	order by d.Papellido1, d.Papellido2, d.Pnombre
</cfquery>

<!--- Forms --->
<cf_templatecss>

<cfoutput>
	<form action="SQLAResponsables.cfm" method="post" name="formResponsables">
	<table width="90%" border="0" cellspacing="0" align="center">
  		<tr>
    		<td nowrap>
				<table width="100%" border="0" cellspacing="0">
			  		<tr>
						<td nowrap>
							<input type="hidden" id="Accion" name="Accion" value="">
							<input type="hidden" id="Ocodigo" name="Ocodigo" value="#rsForm.Ocodigo#">
							<input type="hidden" id="ARactivo" name="ARactivo" value="1">
							<table width="100%" border="0" cellspacing="0">
						  		<tr>
									<td nowrap>
										<input type="hidden" name="Aid" id="Aid" value="#Form.Aid#">
										<cfset UsuCodigos = "">
										<cfif isdefined('rsResponsables') and rsResponsables.recordCount GT 0>
											<cfset UsuCodigos = ValueList(rsResponsables.Usucodigo,',')>
										</cfif>
										<cfset index=1>
										<cf_sifusuario form="formResponsables" quitar="#UsuCodigos#" tabindex="1">
									</td>
									<td nowrap align="right">
										<input type="button" id="btnAddResp" tabindex="1" name="btnAddResp" value="Agregar" onClick="javascript: funcAddResp();">
									</td>
						  		</tr>
							</table>
						</td>
			  		</tr>
			  		<tr>
						<td nowrap>
							<table width="100%" border="0" cellspacing="0" cellpadding="2">
					  			<tr>
									<td nowrap class="subTitulo"  align="center" colspan="2"><b>Listado de Usuarios Asociados al Almacén</b></td>
					  			</tr>
					 			 <tr>
									<td nowrap class="tituloListas">Nombre Completo</td>
									<td nowrap class="tituloListas">&nbsp; </td>
					  			</tr>
					  			
								<cfif rsResponsables.RecordCount>
									<cfloop query="rsResponsables">
										<tr <cfif CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>> 
											<td nowrap>#NombreCompleto#</td>
											<td nowrap>
												<input  name="btnDelResp#Usucodigo#" type="image" alt="Eliminar elemento" 
														onClick="javascript: return funcDelResp('#Aid#', '#Usucodigo#', '#Ulocalizacion#');" 
														src="../../imagenes/Borrar01_T.gif" width="16" height="16">
											</td>
										</tr>
									</cfloop>
					  			<cfelse>
					  				<tr><td nowrap align="center"><b>No existen registros.</b></td></tr>	
					  			</cfif>
							</table>
						</td>
			  		</tr>
				</table>
			</td>
  		</tr>
  		<tr><td nowrap>&nbsp;</td></tr>
	</table>
	</form>
	<script language="JavaScript1.2" type="text/javascript">
	<!--//
		objFormResp = new qForm('formResponsables');
		
		objFormResp.Usucodigo.required = true;
		objFormResp.Usucodigo.description = "#JSStringFormat('Código de Usuario')#";
	
		function funcAddResp() {
			objFormResp.Accion.setValue('Alta');
			objFormResp.submit();
			return true;
		}
	
		function funcDelResp(p1,p2,p3) {
			if (!confirm('¿ Desea eliminar el registro ?'))
				return false;
			objFormResp.Accion.setValue('Baja');
			objFormResp.Aid.setValue(p1);
			objFormResp.Usucodigo.setValue(p2);
			objFormResp.Ulocalizacion.setValue(p3);
			objFormResp.submit();
			return true;
		}
	//--> 
	</script>
</cfoutput>

