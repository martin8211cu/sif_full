<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="BTN_Modificar" default="Modificar" xmlfile="/rh/generales.xml" returnvariable="BTN_Modificar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Eliminar" default="Eliminar" xmlfile="/rh/generales.xml" returnvariable="BTN_Eliminar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Nuevo" default="Nuevo" xmlfile="/rh/generales.xml" returnvariable="BTN_Nuevo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Agregar" default="Agregar" xmlfile="/rh/generales.xml" returnvariable="BTN_Agregar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Limpiar" default="Limpiar" xmlfile="/rh/generales.xml" returnvariable="BTN_Limpiar" component="sif.Componentes.Translate" method="Translate"/>	

<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_COD_ARTICULO" default="C&oacute;digo" xmlfile="/rh/generales.xml" returnvariable="LB_COD_ARTICULO" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_DESCRIPCION" default="Descripci&oacute;n" xmlfile="/rh/generales.xml" returnvariable="LB_DESCRIPCION" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_COD_EGRESO" default="C&oacute;digo Egreso" xmlfile="/rh/generales.xml" returnvariable="LB_COD_EGRESO" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_COD_ARTICULO_REM" default="C&oacute;digo a Reemplazar" xmlfile="/rh/generales.xml" returnvariable="LB_COD_ARTICULO_REM" component="sif.Componentes.Translate" method="Translate"/>

<!--- FIN VARIABLES DE TRADUCCION --->
<cfif isdefined("Form.Cambio")>  
	<cfset modo="CAMBIO">
<cfelse>  
	<cfif not isdefined("Form.modo")>    
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>  
</cfif>

<cfif isdefined('url.cod_articulo') and url.cod_articulo GT 0 and not isdefined('form.cod_articulo')>
	<cfset form.cod_articulo = url.cod_articulo>
	<cfset modo = "CAMBIO">
<cfelseif isdefined('form.cod_articulo') and LEN(TRIM(form.cod_articulo))>
	<cfset modo = "CAMBIO">
</cfif>

<cfquery name="rsCodigos" datasource="sifinterfaces">
	SELECT cod_articulo
	FROM INTP_Articulos_BNV	
</cfquery> 

<cfif modo neq 'ALTA' >
	<cfquery name="rs" datasource="sifinterfaces">
		select *
		from INTP_Articulos_BNV
		where cod_articulo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.cod_articulo#">
	</cfquery>

</cfif>

<script src="/cfmx/rh/js/utilesMonto.js"></script>

<script language="JavaScript">
	function validaForm(f) {
		var err = '';
		var Vobj1 = ''; 
		var Vobj2 = ''; 
		var Vobj3 = ''; 
		
		/*if (document.getElementById("cod_articulo").value == ''){
			err =  err + 'Codigo de Articulo \n';		
		} 
		if (document.getElementById("descripcion").value == ''){
			err =  err + 'Descripcion de Articulo \n';		
		} 
		if (document.getElementById("cod_egreso").value == ''){
			err = err + 'Codigo de Egreso \n';		
		}*/
		if (err == ''){
			return true;		
		}
		else{
			alert("Los siguientes campos son Requeridos: \n" + err)	
			return false;
		}
	}	
	
</script>

<cfoutput>
<form name="form1" method="post" action="BNVArticulos-sql.cfm" onsubmit="javascript: return validaForm(this);">
 	<table width="100%" border="0" cellspacing="0" cellpadding="3">
		<tr> 
			<td align="left" class="fileLabel" width="30%">#LB_COD_ARTICULO#:</td>
			<td> <input name="cod_articulo" type="text" id="cod_articulo" size="5" maxlength="5" <cfif modo NEQ "ALTA"> readonly </cfif>  value="<cfif modo NEQ "ALTA">#rs.cod_articulo#</cfif>" onfocus="this.select();"></td>			
		</tr>
		<tr> 
			<td align="left" class="fileLabel">#LB_DESCRIPCION#:</td>
			<td> <input name="descripcion" type="text" id="descripcion" size="50" maxlength="80"   value="<cfif modo NEQ "ALTA">#rs.desc_articulo#</cfif>" onfocus="this.select();"></td>
		</tr>
		<tr> 
			<td align="left" class="fileLabel" width="30%">#LB_COD_EGRESO#:</td>
			<td> <input name="cod_egreso" type="text" id="cod_egreso" size="5" maxlength="5"   value="<cfif modo NEQ "ALTA">#rs.cod_egreso#</cfif>" onfocus="this.select();"></td>			
		</tr>
		<tr> 
			<td align="left" class="fileLabel" width="30%">#LB_COD_ARTICULO_REM#:</td>
			<td> <input name="cod_articulo_rem" type="text" id="cod_articulo_rem" size="5" maxlength="5"   value="<cfif modo NEQ "ALTA">#rs.cod_articulo_remp#</cfif>" onfocus="this.select();"></td>			
		</tr>
		<tr> 
        	<td colspan="4" align="center"> 
		
				<script language="JavaScript" type="text/javascript">
					// Funciones para Manejo de Botones
					botonActual = "";
					
					function setBtn(obj) {
						botonActual = obj.name;
					}
					function btnSelected(name, f) {
						if (f != null) {
							return (f["botonSel"].value == name)
						} 
						else {
							return (botonActual == name)
						}
					}
				</script>
		
				<input type="hidden" name="botonSel" value="">				
				
				<cfif modo eq 'CAMBIO'>
					<input type="submit" name="Cambio" value="<cfoutput>#BTN_Modificar#</cfoutput>" onclick="javascript: this.form.botonSel.value = this.name; ">
		
						<input type="submit" name="Baja" value="<cfoutput>#BTN_Eliminar#</cfoutput>" onclick="javascript: this.form.botonSel.value = this.name;if ( confirm('¿Est&aacute;? seguro(a) de que desea eliminar el registro?') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">
					
					<input type="button" name="Nuevo" value="<cfoutput>#BTN_Nuevo#</cfoutput>" onclick="javascript: document.location.href='BNVArticulos.cfm'">
				<cfelse>
					<input type="submit" name="Alta" value="<cfoutput>#BTN_Agregar#</cfoutput>" onclick="javascript: this.form.botonSel.value = this.name">
					<input type="reset" name="Limpiar" value="<cfoutput>#BTN_Limpiar#</cfoutput>" onclick="javascript: this.form.botonSel.value = this.name; limpiaLimites()">
				</cfif>
	</table>
	
	<input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ "">#Pagenum_lista#<cfelseif isdefined("Form.PageNum")>#PageNum#</cfif>">
	
<!--- para mantener la navegacion --->
<cfif isdefined("Form.Fcod_articulo") and Len(Trim(Form.Fcod_articulo)) NEQ 0>
	<input type="hidden" name="Fcod_articulo" value="#form.Fcod_articulo#" >
</cfif>

<cfif isdefined("Form.Fdescripcion") and Len(Trim(Form.Fdescripcion)) NEQ 0>
	<input type="hidden" name="Fdescripcion" value="#form.Fdescripcion#" >
</cfif>
<cfif isdefined("Form.Fcod_egreso") and Len(Trim(Form.Fcod_egreso)) NEQ 0>
	<input type="hidden" name="Fcod_egreso" value="#form.Fcod_egreso#" >
</cfif>

<cfif isdefined("Form.Fcod_articulo_rem") and Len(Trim(Form.Fcod_articulo_rem)) NEQ 0>
	<input type="hidden" name="Fcod_articulo_rem" value="#form.Fcod_articulo_rem#" >
</cfif>

</form>

</cfoutput>
