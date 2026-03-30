<!--- Lista de Fechas de Inactivación de la cuenta --->
<cfquery name="rsInactivaciones" datasource="#Session.DSN#">
	select CCIid, 
		Ccuenta,
		CCIdesde, CCIhasta, ts_rversion
	from CCInactivas
	where
		Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">		
</cfquery>

<form action="SQLCuentasContables.cfm" method="post"  enctype="multipart/form-data" name="form3" onSubmit="" >
<table width="90%" border="0" cellspacing="1" cellpadding="1" >
<cfoutput>	
	<tr>
		<td>Desde:&nbsp;</td>
		<td>Hasta:&nbsp;</td>
	</tr>
	<tr>
		<td><cf_sifcalendario form="form3" name="CCIdesde" value=""></td>
		<td><cf_sifcalendario form="form3" name="CCIhasta" value=""></td>
	</tr>
	
	<tr>
	    <td colspan="2" align="center">
			<table>
				<tr>
					<td>
						<div id="divD" style="display: none ;">
							<input type="submit" name="btnAceptar" value="Aceptar" onClick="return validaForm3();">
						</div>
						<div id="divE" style="display: none ;">
							<input type="submit" name="btnCambiar" value="Aceptar" onClick="return validaForm3();">
						</div>
					</td>	
						
					<td>
						<div id="divC" style="display: none ;">
							<input type="button" name="btnNuevo" value="Nuevo" onClick="javascript: Limpiar();">
						</div>
					</td>	
				</tr>	
			</table>
		</td>
 	 </tr>
</cfoutput>

  <tr><td colspan="2">
	
	<table width="100%" align="center" cellpadding="0" cellspacing="0">
		<cfoutput query="rsInactivaciones">
			<cfif CurrentRow EQ 1>
				<tr>
					<td width="35%" align="right"><strong>Inactiva:</strong></td>
					<td width="10%" align="right"><strong>Desde</strong></td>
					<td width="5%">&nbsp;-</td>
					<td width="10%">&nbsp;<strong>Hasta</strong></td>
					<td width="5%">&nbsp;</td>
					<td width="35%">&nbsp;</td>
				</tr>
			</cfif>
			<tr <cfif CurrentRow MOD 2> class="listaNon"<cfelse> class="listaPar"</cfif>>
				<cfset ts2 = "">	
				<cfinvoke 
					component="sif.Componentes.DButils"
					method="toTimeStamp"
					returnvariable="ts2">
					<cfinvokeargument name="arTimeStamp" value="#rsInactivaciones.ts_rversion#"/>
				</cfinvoke>
				<td>&nbsp;</td>
				<td nowrap><a href="javascript: Editar(#CCIid#, '#LSDateFormat(CCIdesde,'DD/MM/YYYY')#', '#LSDateFormat(CCIhasta,'DD/MM/YYYY')#', '#ts2#');" title="Haga click para modificar">#LSDateFormat(CCIdesde,'DD/MM/YYYY')#</a></td>
				<td width="5%">-</td>
				<td nowrap><a href="javascript: Editar(#CCIid#,'#LSDateFormat(CCIdesde,'DD/MM/YYYY')#', '#LSDateFormat(CCIhasta,'DD/MM/YYYY')#', '#ts2#');" title="Haga click para modificar">#LSDateFormat(CCIhasta,'DD/MM/YYYY')#</a></td>
				<td nowrap align="center">
					<input  name="btnBorrar" type="image" alt="Eliminar elemento" 
							onClick="javascript: return Borrar(#CCIid#);" 
							src="../../imagenes/Borrar01_T.gif" width="16" height="16">					
				</td>
				<td>&nbsp;</td>
			</tr>
		</cfoutput>
		
		<cfoutput>
		<input name="CCIid" type="hidden" value="">
		<input name="ts_rversion" type="hidden" value="">
		<input name="Ccuenta" type="hidden" value="<cfif isdefined("Form.Ccuenta") and len(trim(Form.Ccuenta))>#Form.Ccuenta#</cfif>">
		<input name="Cmayor" type="hidden" value="<cfif isdefined("Form.Cmayor") and len(trim(Form.Cmayor))>#Form.Cmayor#</cfif>">
		<input name="Cpadre" type="hidden" value="<cfif isdefined("Form.Cpadre") and len(trim(Form.Cpadre))>#Form.Cpadre#</cfif>">
		<input name="formato" type="hidden" value="<cfif isdefined("Form.formato") and len(trim(Form.formato))>#Form.formato#</cfif>">
		</cfoutput>
			
	</table>
	  
  </td></tr>
  
</table>

</form>

<script language="JavaScript1.2">

	function Limpiar() {
		var div_C = document.getElementById("divC");
		var div_D = document.getElementById("divD");
		var div_E = document.getElementById("divE");
		var f = document.form3;
		div_C.style.display = 'none';
		div_D.style.display = '';
		div_E.style.display = 'none';
		f.CCIid.value = '';
		f.CCIdesde.value = '';
		f.CCIhasta.value = '';
		f.ts_rversion.value = '';
	}

	function Editar(CCIid_, CCIdesde_, CCIhasta_, pts2_ ) {
		var div_C = document.getElementById("divC");
		var div_D = document.getElementById("divD");
		var div_E = document.getElementById("divE");
		var f = document.form3;		
		f.CCIid.value = CCIid_;
		f.CCIdesde.value = CCIdesde_;
		f.CCIhasta.value = CCIhasta_;
		f.ts_rversion.value = pts2_;
		div_C.style.display = '';
		div_D.style.display = 'none';
		div_E.style.display = '';
	}

	function validaRangoFechas(f1,f2) {
		var a = f1.split("/");
		var ini = new Date(parseInt(a[2], 10), parseInt(a[1], 10)-1, parseInt(a[0], 10));
		var b = f2.split("/");
		var fin = new Date(parseInt(b[2], 10), parseInt(b[1], 10)-1, parseInt(b[0], 10));
		if (ini > fin)
			return 0;
	}

	function validaForm3() {
		var f = document.form3;		
		if (f.CCIdesde.value == '') {
			alert('¡Debe seleccionar la fecha desde!');
			return false;
		}
		if (f.CCIhasta.value == '') {
			alert('¡Debe seleccionar la fecha hasta!');
			return false;
		}

		if (validaRangoFechas(f.CCIdesde.value,f.CCIhasta.value) == 0) {		
			alert('¡La fecha desde debe ser menor o igual a la fecha hasta!');
			return false;
		}
		
		return true;
	}
	
	function Borrar(id) {
		var f = document.form3;
		f.CCIid.value = id;	
		return (confirm('¿Está seguro de eliminar este registro?'))
	}	
	
	Limpiar();
</script>

