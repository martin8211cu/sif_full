<cfset modo = "ALTA">
<cfif isdefined("Form.Cid")>
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
		select Ccache, Cexclusivo, CEcodigo
		from Caches
		where Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">
	</cfquery>
	<cfquery name="rsRepo" datasource="asp">
		Select CidR FROM CacheRepo where Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">
	</cfquery>
	
	<!--- Averiguar si un cache puede ser marcado como exclusivo, tambien sirve para chequear si se puede borrar un cache --->
	<cfquery name="rsExclusividad" datasource="asp">
		select b.CEcodigo,
			   b.CEnombre
		from CECaches a, CuentaEmpresarial b
		where a.Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">
		and a.CEcodigo = b.CEcodigo
	</cfquery>
	
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
							msg  = "La seguridad del administrador de ColdFusion está activada, para poder visualizar esta opción se debe de desactivar momentaneamente la autenticación del administrador y posteriormente restaurarla a su respectivo password"
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
<cfset j = 1 >
<cfloop From="1" To="#ArrayLen(datasources)#" index="i">
	<cfif #find("repo",datasources[i])# eq 0>
		<cfset datasourcesA[j] = datasources[i] >
   <cfset j = j +1 >
    </cfif>
</cfloop>
<cfcatch type="any" >

</cfcatch>
</cftry>
 <cfset ArraySort(datasourcesA, "text") >
</cflock>
<!--- Extrae los registros para el combo de repositorio  --->
<cfquery name="listarepo" datasource="asp">
	select CidR, Ccache from CachesRep
</cfquery>


<cfoutput>
<script language="javascript" type="text/javascript">
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
</script>

<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script type="text/javascript" language="javascript1.2">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>

<form name="frmCaches" action="caches-sql.cfm" method="post">
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
				<select name="Ccache" onchange="addOption(this.value)">
					<cfloop index="ds" from="1" to="#ArrayLen(datasourcesA)#">
						<cfquery name="caches"  datasource="asp">
							select Ccache 
							from Caches 
							where Ccache = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datasourcesA[ds]#">
							<cfif modo neq 'ALTA'>
								and Ccache <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ccache#">
							</cfif>	
						</cfquery>
						
						<cfif caches.RecordCount eq 0>
							<option value="#datasourcesA[ds]#"<cfif modo EQ 'CAMBIO' and rsData.Ccache EQ datasourcesA[ds]> selected</cfif>>#datasourcesA[ds]#</option>
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
		  <td align="right" class="etiquetaCampo" width="50%">Repositorio: </td>
		  <td>
			  <select name="repo" <cfif modo EQ 'CAMBIO' and rsRepo.RecordCount NEQ 0>disabled</cfif>>
				  <option value="0">...Seleccione...</option>
				  <cfif  modo EQ 'CAMBIO'>
					  <option value="-1" <cfif modo EQ 'CAMBIO' and rsRepo.CidR EQ -1> selected</cfif>>#form.Ccache#</option>
					  <cfelse>
					   <option value="-1">Origen</option>
				  </cfif>
				  <cfloop query="listarepo">
					<option value="#CidR#" <cfif modo EQ 'CAMBIO' and rsRepo.CidR EQ listarepo.CidR> selected</cfif>>#Ccache#</option>
				  </cfloop>
			  </select>
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
				<input type="submit" name="btnNuevo" value="Nuevo">
			<cfelse>
				<input type="submit" name="btnAgregar" value="Agregar">
			</cfif>
		</td>
      </tr>
	</table>
</form>

</cfoutput>

<script language="JavaScript1.2" type="text/javascript">

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("frmCaches");

	objForm.Ccache.required = true;
	objForm.Ccache.description = "Cache";
	
	function deshabilitarValidacion(){
		objForm.Ccache.required = false;
	}
	function addOption(valor){
		document.forms['frmCaches'].elements['repo'].options[1].text=valor;
	}
</script>
