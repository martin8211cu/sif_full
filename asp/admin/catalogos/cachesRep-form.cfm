<cfset modo = "ALTA">
<cfif isdefined("Form.CidR")>
	<cfset modo = "CAMBIO">
</cfif>

<!--- Cuentas Empresariales disponibles --->
<cfquery name="rsCuentas" datasource="asp">
	select CEcodigo, CEnombre
	from CuentaEmpresarial
</cfquery>

<cfquery name="rsCaches" datasource="asp">
	select Ccache from Caches
</cfquery>



<cfif modo EQ "CAMBIO">
	<cfquery name="rsData" datasource="asp">
		select Ccache, CDataSource, Cexclusivo, CEcodigo
		from CachesRep
		where CidR = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CidR#">
	</cfquery>

	<!--- Averiguar si un cache puede ser marcado como exclusivo, tambien sirve para chequear si se puede borrar un cache --->
	<!---cfquery name="rsExclusividad" datasource="asp">
		select b.CEcodigo,
			   b.CEnombre
		from CECaches a, CuentaEmpresarial b
		where a.Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">
		and a.CEcodigo = b.CEcodigo
	</cfquery--->

</cfif>

<!--- Retorna en un arreglo (datasources), los caches definidos en el JRun o CF --->

<cflock name="serviceFactory" type="exclusive" timeout="10">
 <cfscript>
	 factory = CreateObject("java", "coldfusion.server.ServiceFactory");
	 ds_service = factory.datasourceservice;
   </cfscript>

 <!--- obtiene los nombres de los datasources --->
 <cfset caches = ds_service.getNames()>

 <!--- obtiene un struct con la propiedades de los datasources --->
 <cftry>
 	<cfinvoke	component="home.Componentes.DbUtils"
 			method="getColdfusionDatasources"
			DS_Service="#ds_service#"
			returnvariable="ds"
			>
<cfcatch>
	<cf_errorCode	code = "80033"
						msg  = "La seguridad del administrador de ColdFusion est� activada, para poder visualizar esta opci�n se debe de desactivar momentaneamente la autenticaci�n del administrador y posteriormente restaurarla a su respectivo password"
		>
</cfcatch>
</cftry>

 <!--- Crea un arreglo con los datasources validos --->
 <!--- No toma en cuanta los datasources de MSaccess, pues son defindiso por el cf
	   para ejemplos y otros motivos y no corresponden a las aplicaciones nuestras
 --->

 <cfset j = 1 >

<cftry>
 <cfloop From="1" To="#ArrayLen(caches)#" index="i">
  <cfset data = "ds." & caches[i] & ".driver" >

  <cfif UCase(Evaluate(data)) neq 'MSACCESS'
        and ListContainsNoCase("asp,aspsecure,sdc,sifcontrol,sifpublica",caches[i],",") EQ 0>
   <cfset datasources[j] = caches[i] >
   <cfset j = j +1 >
  </cfif>
 </cfloop>

<cfcatch type="any" >

</cfcatch>
</cftry>

 <cfset ArraySort(datasources, "text") >
</cflock>

<cfset j = 1 >
<cfloop From="1" To="#ArrayLen(datasources)#" index="i">
	<cfif #find("repo",datasources[i])# neq 0>
		<cfset datasourcesrep[j] = datasources[i] >
   <cfset j = j +1 >
    </cfif>
</cfloop>



<!---cfset stringToSearch = "The quick brown fox jumped over the lazy dog.">
    <br--->


<cfoutput>
<!---script language="javascript" type="text/javascript">
	function showEmpresas(show) {
		var a = document.getElementById("trCuentas");
		if (a != null) {
			if (show) {
				a.style.display = "";
			} else {
				a.style.display = "none";
			}
		}
	}
</script--->

<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script type="text/javascript" language="javascript1.2">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>

<form name="frmCaches" action="cachesRep-sql.cfm" method="post">
	<cfif isdefined("Form.PageNum")>
		<input type="hidden" name="Pagina" value="#Form.PageNum#">
	</cfif>
	<cfif modo EQ "CAMBIO">
		<input type="hidden" name="CidR" value="#Form.CidR#">
	</cfif>
	<table width="100%"  border="0" cellspacing="0" cellpadding="2">
		<tr>
			<td align="right" class="etiquetaCampo" width="50%">Cache: </td>
			<td>
				<cfif modo eq 'ALTA'>
					<input type="text" name="Ccache" id="Ccache" maxlength="30">
					<cfelse>
				    #form.Ccache#
				    <input type="hidden" name="Ccache" value="#form.Ccache#">
				</cfif>

			</td>
		</tr>
		<tr>
			<td align="right" class="etiquetaCampo" width="50%">DataSource: </td>
			<td>
				<select name="CDataSource">
					<option value="0">...Seleccione...</option>
                    <cfif isdefined("datasourcesrep") and  #ArrayLen(datasourcesrep)# gt 0>
						<cfloop index="ds" from="1" to="#ArrayLen(datasourcesrep)#">
							<option value="#datasourcesrep[ds]#" <cfif modo EQ 'CAMBIO' and rsData.CDataSource EQ datasourcesrep[ds]> selected</cfif>>#datasourcesrep[ds]#</option>
						</cfloop>
					</cfif>
			    </select>
			</td>
		</tr>
		<!---tr>
			<td align="right" class="etiquetaCampo">Exclusivo:</td>
			<td align="left">

				<input name="Cexclusivo" type="checkbox" id="Cexclusivo" style="border: none;" value="1" <cfif modo EQ "CAMBIO" and rsData.Cexclusivo EQ 1> checked</cfif> onClick="javascript: showEmpresas(this.checked);"<!---cfif modo EQ "CAMBIO" and rsExclusividad.recordCount GT 1> disabled</cfif--->>
		    </td>
        </tr--->
		<!---tr id="trCuentas" <cfif not (modo EQ 'CAMBIO' and rsData.Cexclusivo EQ 1)> style="display:none; "</cfif>>
            <td align="right" class="etiquetaCampo">Cuentas Empresariales: </td>
			<td align="left">
				<select name="CEcodigo"--->
					<!---cfif modo EQ "CAMBIO" and rsExclusividad.recordCount EQ 1>
						<option value="#rsExclusividad.CEcodigo#">#rsExclusividad.CEnombre#</option>
						<cfelse--->
						<!---cfloop query="rsCuentas">
							<option value="#CEcodigo#"<cfif modo EQ 'CAMBIO' and rsData.CEcodigo EQ rsCuentas.CEcodigo> selected</cfif>>#CEnombre#</option>
						</cfloop--->
					<!---/cfif--->
				<!---/select>
			</td--->
	    </tr>
		<tr>
			<td colspan="2" align="center">
				<cfif modo EQ "CAMBIO">
					<input type="submit" name="btnCambiar" value="Guardar"  class="btnGuardar">
					<input type="submit" name="btnNuevo" value="Nuevo" class="btnNuevo">
					<input type="submit" name="btnEliminar" value="Eliminar" class="btnEliminar" onClick="javascript: if (confirm('�Est�  seguro de que desea eliminar este cache?')) { deshabilitarValidacion(); return true; } else return false;">
			        <cfelse>
				    <input type="submit" name="btnAgregar" value="Agregar" class="btnGuardar">
				</cfif>
			</td>
      </tr>

	</table>

</form>

<!---form name="frmCaches" action="caches-sql.cfm" method="post">
	<cfif isdefined("Form.PageNum")>
		<input type="hidden" name="Pagina" value="#Form.PageNum#">
	</cfif>
	<cfif modo EQ "CAMBIO">
		<input type="hidden" name="Cid" value="#Form.Cid#">
	</cfif>
	<table width="100%"  border="0" cellspacing="0" cellpadding="2">
	  <tr>
		<td align="right" class="etiquetaCampo" width="50%">Cache: </td>
		<td align="left">

			<cfif modo eq 'ALTA'>
				<select name="Ccache">
					<cfloop index="ds" from="1" to="#ArrayLen(datasources)#">
						<cfquery name="caches"  datasource="asp">
							select Ccache
							from Caches
							where Ccache = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datasources[ds]#">
							<cfif modo neq 'ALTA'>
								and Ccache <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ccache#">
							</cfif>
						</cfquery>

						<cfif caches.RecordCount eq 0>
							<option value="#datasources[ds]#"<cfif modo EQ 'CAMBIO' and rsData.Ccache EQ datasources[ds]> selected</cfif>>#datasources[ds]#</option>
						</cfif>
					</cfloop>
				</select>
			<cfelse>
				#form.Ccache#
				<input type="hidden" name="Ccache" value="#form.Ccache#">
			</cfif>
		</td>
	  </tr>
	  <tr>
	    <td align="right" class="etiquetaCampo">Exclusivo:</td>
	    <td align="left">
			<input name="Cexclusivo" type="checkbox" id="Cexclusivo" style="border: none;" value="1"<cfif modo EQ "CAMBIO" and rsData.Cexclusivo EQ 1> checked</cfif> onClick="javascript: showEmpresas(this.checked);"<cfif modo EQ "CAMBIO" and rsExclusividad.recordCount GT 1> disabled</cfif>>
		</td>
      </tr>
	  <tr id="trCuentas" <cfif not (modo EQ 'CAMBIO' and rsData.Cexclusivo EQ 1)> style="display:none; "</cfif>>
		<td align="right" class="etiquetaCampo">Cuentas Empresariales: </td>
		<td align="left">
			<select name="CEcodigo">
			<cfif modo EQ "CAMBIO" and rsExclusividad.recordCount EQ 1>
				<option value="#rsExclusividad.CEcodigo#">#rsExclusividad.CEnombre#</option>
			<cfelse>
				<cfloop query="rsCuentas">
					<option value="#CEcodigo#"<cfif modo EQ 'CAMBIO' and rsData.CEcodigo EQ rsCuentas.CEcodigo> selected</cfif>>#CEnombre#</option>
				</cfloop>
			</cfif>
			</select>
		</td>
	  </tr>
	  <tr>
	    <td colspan="2">&nbsp;</td>
      </tr>
	  <tr>
	    <td colspan="2" align="center">
			<cfif modo EQ "CAMBIO">
				<input type="submit" name="btnCambiar" value="Guardar">
				<cfif rsExclusividad.recordCount EQ 0>
				<input type="submit" name="btnEliminar" value="Eliminar" onClick="javascript: if (confirm('¿Está seguro de que desea eliminar este cache?')) { deshabilitarValidacion(); return true; } else return false;">
				</cfif>
				<input type="submit" name="btnNuevo" value="Nuevo" class="btnNuevo">
			<cfelse>
				<input type="submit" name="btnAgregar" value="Agregar" class="btnGuardar">
			</cfif>
		</td>
      </tr>
	</table>
</form--->
<cfif IsDefined("er")>
	<cfif #er# eq 1>
		<script language="javascript" type="text/javascript">
			alert('El registro no puede ser eliminado ya que se encuentra relacionado con un cache');
		</script>
	</cfif>
</cfif>
</cfoutput>


<script language="JavaScript1.2" type="text/javascript">

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("frmCaches");

	objForm.Ccache.required = true;
	objForm.Ccache.description = "Cache";

	function deshabilitarValidacion(){
		objForm.Ccache.required = false;
	}

</script>
