<!--- ALmacenes cercanos a éste Almacén --->
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

<!--- Consultas Iniciales --->
<cfquery name="rsAlmacenes" datasource="#Session.DSN#">
	select Aid as Alm_Aid, Ecodigo, Almcodigo, IACcodigo, Ocodigo, Dcodigo, Bdescripcion, Bdireccion, Btelefono, ts_rversion
	from Almacen
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfif isdefined("Form.Aid")>
	<cfquery name="rsCercanos" datasource="#Session.DSN#">
		select a.Alm_Aid, b.Ecodigo, b.Almcodigo , b.IACcodigo,  b.Ocodigo, b.Dcodigo, b.Bdescripcion, b.Bdireccion, b.Btelefono, b.ts_rversion
		from AlmacenCercano a
		   inner join Almacen b
		   on b.Aid = a.Alm_Aid
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
	</cfquery>
</cfif>

<!--- Forms --->
<cf_templatecss>
<cfoutput>
<form action="SQLACercanos.cfm" method="post" name="formCercanos">
	<table width="90%" border="0" cellspacing="0" align="center">
  		<tr>
    		<td nowrap>
				<table width="100%" border="0" cellspacing="0">
			  		<tr>
						<td nowrap>
							<input type="hidden" id="Accion" name="Accion" value="">
							<input type="hidden" id="Alm_Aid" name="Alm_Aid" value="">
							<table width="100%" border="0" cellspacing="0">
						  		<tr>
									<td nowrap>
										<input type="hidden" name="Aid" id="Aid" value="#Form.Aid#">
										<cfset AlmCercanos = "">
										<cfif isdefined('rsCercanos') and rsCercanos.recordCount GT 0>
											<cfset AlmCercanos = ValueList(rsCercanos.Alm_Aid,',')>
										</cfif>
										<!---
										<cf_sifusuario form="formCercanos" quitar="#AlmCercanos#">
										<select name="Alm_Aid" id="Alm_Aid">
											<cfloop query="rsAlmacenes">
									 			 <option value="#rsAlmacenes.Alm_Aid#">#HTMLEditFormat(rsAlmacenes.Bdescripcion)#</option>
											</cfloop>
								  		</select>
										--->
								  		<cf_sifalmacen Aid="AidCercano" Bdescripcion="AidDesc" Almcodigo="CodigoCercano" tabindex="1" form="formCercanos" excluir="#AlmCercanos#">
									</td>
									<td nowrap align="right">
										<input type="button" id="btnAddCercano" name="btnAddCercano" tabindex="1" value="Agregar" onClick="javascript: funcAddCercano();">
									</td>
						  		</tr>
							</table>
						</td>
			  		</tr>
			  		<tr>
						<td nowrap>
							<table width="100%" border="0" cellspacing="0" cellpadding="2">
					  			<tr>
									<td nowrap class="subTitulo"  align="center" colspan="2"><b>Listado de los Almacenes Cercanos </b></td>
					 			</tr>
					  			<tr>
									<td nowrap class="tituloListas">Almac&eacute;n</td>
									<td nowrap class="tituloListas">&nbsp; </td>
					  			</tr>
					  			
								<cfif rsCercanos.RecordCount>
									<cfloop query="rsCercanos">
										<tr <cfif CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>> 
											<td nowrap>#Bdescripcion#</td>
											<td nowrap>
												<input  name="btnDelResp#Aid#" type="image" alt="Eliminar elemento" 
														onClick="javascript: deshabilitarValidacion(); return funcDelAlm(#Alm_Aid#); " 
														src="../../imagenes/Borrar01_T.gif" width="16" height="16">
											</td>
										</tr>
									</cfloop>
					  			<cfelse>
					  				<tr>
										<td nowrap align="center"><strong>No existen registros.</strong></td>
									</tr>	
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
</cfoutput>

<!--- Validaciones con qforms --->
<!--// this code must execute after the end </FORM> tag //--> 
<script language="JavaScript1.2" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objFormCer = new qForm("formCercanos");
	
	objFormCer.AidCercano.required = true;
	objFormCer.AidCercano.description = 'Código de Almacén';
	
	function deshabilitarValidacion(){
		objFormCer.AidCercano.required = false;
	}
	
	function funcAddCercano() {
		objFormCer.Accion.setValue('Alta');
		objFormCer.submit();
		return true;
	}
	
	function funcDelAlm(p1) {
		if (!confirm('¿ Desea eliminar el registro ?'))
			return false;
		objFormCer.Accion.setValue('Baja');
		objFormCer.Alm_Aid.setValue(p1);
		objFormCer.submit();
		return true;
	}

</script>
<!--- Fin del Mantenimiento --->

