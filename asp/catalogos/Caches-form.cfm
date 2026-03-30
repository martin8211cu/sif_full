<cfquery name="rsCaches" datasource="asp">
	select Cid,
		   a.Ccache,
		   a.Cexclusivo
	from Caches a
	where a.Cexclusivo = 0
	and not exists (
		select 1
		from CECaches b
		where b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
		and b.Cid = a.Cid
	)
	
	union
	
	select Cid,
		   a.Ccache,
		   a.Cexclusivo
	from Caches a
	where a.Cexclusivo = 1
	and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
	and not exists (
		select 1
		from CECaches b
		where b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
		and b.Cid = a.Cid
	)
	
	order by 2
	
</cfquery>

<cfquery name="rsCachesAsignados" datasource="asp">
	select CEClinea, 
		   x.Cid, 
		   a.Ccache,
		   a.Cexclusivo
	from CECaches x, Caches a
	where x.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
	and x.Cid = a.Cid
</cfquery>

<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="javascript" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	function buttonOver(obj) {
		obj.className="botonDown";
	}

	function buttonOut(obj) {
		obj.className="botonUp";
	}

	function funcContinuar() {
		document.frmCaches.ACCION.value = "1";
		document.frmCaches.submit();
	}
	
	function funcCancelar() {
		location.href = '/cfmx/asp/index.cfm';
	}
	
	function Eliminar(CEClinea, Ccache) {
		if (confirm('¿Está seguro de que desea quitar la disponibilidad del cache '+Ccache+' en la cuenta empresarial seleccionada?')) {
			document.frmCaches.ACCION.value = "3";
			document.frmCaches.CEClineaDel.value = CEClinea;
			document.frmCaches.submit();
		}
	}
	
</script>

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
  	<td colspan="3" bgcolor="#A0BAD3">
		<table border="0" cellpadding="2" cellspacing="0" style="height: 24px; ">
			<tr>
				<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcContinuar();">
					<img src="../imagenes/r_arrow.gif" border="0" align="top" hspace="2">Continuar
				</td>
				<td>|</td>
				<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcCancelar();">
					<img src="../imagenes/cancel.gif" border="0" align="top" hspace="2">Cancelar
				</td>
			</tr>
		</table>
	</td>
  </tr>
  <tr>
  	<td colspan="3">&nbsp;</td>
  </tr>
  <tr>
    <td class="textoAyuda" width="20%" valign="top">
		Un <strong>cache</strong> es una conexión a base de datos.<br><br>
		En el formulario que se muestra, se listan todos los caches a los cuales tiene acceso la cuenta empresarial seleccionada.<br><br>
		Para agregar un nuevo cache a la lista, seleccione el cache y haga click en el botón <font color="#0000FF">Agregar</font>.<br><br>
		Para eliminar el acceso a uno de los caches en la lista, haga click en la imagen que contiene una <font color="#0000FF">Equis (X)</font>, ubicada al lado derecho del cache que se lista.
	</td>
    <td style="padding-left: 5px; padding-right: 5px;" valign="top" align="center">
		<cfoutput>
		<form name="frmCaches" method="post" action="Caches-sql.cfm" style="margin:0;">
			<input name="ACCION" type="hidden" value="2">
			<input type="hidden" name="CEClineaDel" value="">
			<table border="0" cellspacing="0" cellpadding="3" width="100%">
			  <tr>
				<td width="15%" align="right" nowrap class="etiquetaCampo" style="padding-right: 10px; border-top: 1px solid black; border-bottom: 1px solid black;">
					Cache:
				</td>
				<td align="left" style="border-top: 1px solid black; border-bottom: 1px solid black;">
					<select name="Cid">
					  <cfif rsCaches.recordCount EQ 0>
						<option value="">--No Disponible--</option>
					  </cfif>
					  <cfloop query="rsCaches">
						<option value="#Cid#">#Ccache#</option>
					  </cfloop>
					</select>
				</td>
				<td align="center" nowrap style="border-top: 1px solid black; border-bottom: 1px solid black;">
					<input name="btnAgregar" type="submit" id="btnAgregar" value="Agregar" onmouseover="javascript: this.className='botonDown2';" onmouseout="javascript: this.className='botonUp2';">
				</td>
			  </tr>
			  <tr>
				<td colspan="3" nowrap>&nbsp;</td>
			  </tr>
			  <tr>
				<td align="left" colspan="3">
					<cfif rsCachesAsignados.recordCount GT 0>
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td colspan="2" class="tituloLista">Caches asignados a la cuenta empresarial</td>
							</tr>
							<cfloop query="rsCachesAsignados">
								<tr <cfif rsCachesAsignados.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif> onMouseOver="style.backgroundColor='##E4E8F3';" onMouseOut="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';" >
									<td height="18" nowrap>#rsCachesAsignados.Ccache#</td>
									<td height="18" width="1%" nowrap>
										<a href="javascript:Eliminar('#rsCachesAsignados.CEClinea#', '#rsCachesAsignados.Ccache#');">
											<img border="0" src="/cfmx/asp/imagenes/delete.gif" alt="Eliminar"> 
										</a>
									</td>
								</tr>
							</cfloop>
						</table>
					<cfelse>
						<div class="textoMensajes">
							Actualmente no hay caches asignados a esta cuenta empresarial
						</div>
					</cfif>
				</td>
			  </tr>
			</table>
		</form>
		</cfoutput>
	</td>
    <td width="1%" valign="top">
		<cfinclude template="frame-Progreso.cfm">
		<br>
		<cfinclude template="frame-Proceso.cfm">
	</td>
  </tr>
</table>


<script language="javascript" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("frmCaches");
	
	objForm.Cid.required = true;
	objForm.Cid.description = "Cache";

	function showList(){
		location.href = 'Caches.cfm?selecc=1';
	}	
</script>
