<!--- Expediente --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="DatosFamiliares"
	Default="Familiares"
	Idioma="#session.Idioma#"
	returnvariable="vFamiliares"/>

<cf_web_portlet_start titulo="#vFamiliares#">

<script language="JavaScript" type="text/javascript">
	function showDetail(idx) {
		var tr = document.getElementById("TRdetail_"+idx);
		var img = document.getElementById("img_"+idx);
		img.src = ((tr.style.display == "none") ? "/cfmx/rh/imagenes/abajo.gif" : "/cfmx/rh/imagenes/derecha.gif");
		tr.style.display = ((tr.style.display == "none") ? "" : "none");
	}
</script>

<cfquery name="rsFamiliares" datasource="#Session.DSN#">
	select a.FElinea, 
		   a.DEid, 
		   a.NTIcodigo, 
		   a.FEidentificacion, 
		   a.Pid, 
		   a.FEnombre, 
		   a.FEapellido1, 
		   a.FEapellido2, 
		   a.FEfnac as FechaNacimiento, 
		   case a.FEsexo when 'M' then '<cf_translate key="Masculino">Masculino</cf_translate>' when 'F' then '<cf_translate key="Femenino">Femenino</cf_translate>' else 'N/D' end as Sexo,
		   a.FEdir, 
		   a.FEdiscapacitado, 
		   a.FEfinidiscap as InicioDiscap,
		   a.FEffindiscap as FinDiscap, 
		   a.FEasignacion, 
		   a.FEfiniasignacion as InicioAsigna,
		   a.FEffinasignacion as FinAsigna, 
		   a.FEestudia, 
		   a.FEfiniestudio as InicioEst,
		   a.FEffinestudio as FinEst,
		   a.FEdatos1, 
		   a.FEdatos2, 
		   a.FEdatos3, 
		   a.FEobs1, 
		   a.FEobs2, 
		   a.FEinfo1, 
		   a.FEinfo2, 
		   a.Usucodigo, 
		   a.Ulocalizacion,
		   b.Pdescripcion,
		   c.NTIdescripcion,
		   a.FEdeducrenta,
		   a.FEidconcepto
	from FEmpleado a
	
	inner join RHParentesco b
	on a.Pid = b.Pid	

	inner join NTipoIdentificacion c
	on a.NTIcodigo = c.NTIcodigo
	
	where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleado.DEid#">
</cfquery>

<cfif rsFamiliares.recordCount GT 0>
	<cfquery name="rsEtiquetasFam" datasource="#Session.DSN#">
		select RHEcol,
			   RHEtiqueta,
			   RHrequerido
		from RHEtiquetasEmpresa
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleado.Ecodigo#">
		and RHdisplay = 1
		and RHEcol like 'FE%'
	</cfquery>
	
	<cfoutput>
	<table width="100%" cellpadding="3" cellspacing="0">
	<tr> 
	  <td class="tituloListas" nowrap>&nbsp;</td>
	  <td class="tituloListas" nowrap><cf_translate key="LB_NombreCompleto">Nombre Completo</cf_translate></td>
	  <td class="tituloListas" nowrap><cf_translate key="CedulaExp">Identificación</cf_translate></td>
	  <td class="tituloListas" align="center" nowrap><cf_translate key="AplicaDeduccionRenta">Aplica Deducci&oacute;n Renta</cf_translate></td>
	  <td class="tituloListas" align="center" nowrap><cf_translate key="Discapacitado">Discapacitado</cf_translate></td>
	  <td class="tituloListas" align="center" nowrap><cf_translate key="CobraAsignacionFamiliar">Cobra Asignaci&oacute;n Familiar</cf_translate></td>
	  <td class="tituloListas" align="center" nowrap><cf_translate key="Estudia">Estudia</cf_translate></td>
	</tr>
	
	<cfloop query="rsFamiliares">
	<tr> 
	  <td <cfif #rsFamiliares.CurrentRow# MOD 2><cfoutput>class="listaNon"</cfoutput><cfelse><cfoutput>class="listaPar"</cfoutput></cfif>><a href="javascript: showDetail('#rsFamiliares.FElinea#');"><img id="img_#rsFamiliares.FElinea#" border="0" src="/cfmx/rh/imagenes/derecha.gif"></a></td>
	  <td <cfif #rsFamiliares.CurrentRow# MOD 2><cfoutput>class="listaNon"</cfoutput><cfelse><cfoutput>class="listaPar"</cfoutput></cfif>><a href="javascript: showDetail('#rsFamiliares.FElinea#');">#rsFamiliares.FEnombre# #rsFamiliares.FEapellido1# #rsFamiliares.FEapellido2#</a></td>
	  <td <cfif #rsFamiliares.CurrentRow# MOD 2><cfoutput>class="listaNon"</cfoutput><cfelse><cfoutput>class="listaPar"</cfoutput></cfif>><a href="javascript: showDetail('#rsFamiliares.FElinea#');">#rsFamiliares.FEidentificacion# (#rsFamiliares.NTIdescripcion#)</a></td>
	  <td <cfif #rsFamiliares.CurrentRow# MOD 2><cfoutput>class="listaNon"</cfoutput><cfelse><cfoutput>class="listaPar"</cfoutput></cfif> align="center"><a href="javascript: showDetail('#rsFamiliares.FElinea#');"><cfif rsFamiliares.FEdeducrenta><img border="0" src="/cfmx/rh/imagenes/checked.gif" alt="Aplica Deducci&oacute;n Renta"><cfelse><img border="0" src="/cfmx/rh/imagenes/unchecked.gif" alt="No Discapacitado"></cfif></a></td>
	  <td <cfif #rsFamiliares.CurrentRow# MOD 2><cfoutput>class="listaNon"</cfoutput><cfelse><cfoutput>class="listaPar"</cfoutput></cfif> align="center"><a href="javascript: showDetail('#rsFamiliares.FElinea#');"><cfif rsFamiliares.FEdiscapacitado><img border="0" src="/cfmx/rh/imagenes/checked.gif" alt="Discapacitado"><cfelse><img border="0" src="/cfmx/rh/imagenes/unchecked.gif" alt="No Discapacitado"></cfif></a></td>
	  <td <cfif #rsFamiliares.CurrentRow# MOD 2><cfoutput>class="listaNon"</cfoutput><cfelse><cfoutput>class="listaPar"</cfoutput></cfif> align="center"><a href="javascript: showDetail('#rsFamiliares.FElinea#');"><cfif rsFamiliares.FEasignacion><img border="0" src="/cfmx/rh/imagenes/checked.gif" alt="Cobra Asignaci&oacute;n Familiar"><cfelse><img border="0" src="/cfmx/rh/imagenes/unchecked.gif" alt="No Cobra Asignaci&oacute;n Familiar"></cfif></a></td>
	  <td <cfif #rsFamiliares.CurrentRow# MOD 2><cfoutput>class="listaNon"</cfoutput><cfelse><cfoutput>class="listaPar"</cfoutput></cfif> align="center"><a href="javascript: showDetail('#rsFamiliares.FElinea#');"><cfif rsFamiliares.FEestudia><img border="0" src="/cfmx/rh/imagenes/checked.gif" alt="Estudia"><cfelse><img border="0" src="/cfmx/rh/imagenes/unchecked.gif" alt="No Estudia"></cfif></a></td>
	</tr>
	<tr id="TRdetail_#rsFamiliares.FElinea#" style="display: none;">
	  <td colspan="6">
		
		<table  width="100%" cellpadding="3" cellspacing="0">
			<tr> 
			  <td class="fileLabel" nowrap><cf_translate key="Parentesco">Parentesco</cf_translate>:</td>
			  <td colspan="2">#rsFamiliares.Pdescripcion#</td>
			</tr>
		
			<tr> 
			  <td class="fileLabel" nowrap><cf_translate key="Sexo">Sexo</cf_translate>:</td>
			  <td colspan="2">#rsFamiliares.Sexo#</td>
			</tr>
		
			<tr> 
			  <td class="fileLabel" nowrap><cf_translate key="FechaDeNacimiento">Fecha de Nacimiento</cf_translate>:</td>
			  <td colspan="2">#LSDateFormat(rsFamiliares.FechaNacimiento,'dd/mm/yyyy')#</td>
			</tr>
		
			<tr> 
			  <td class="fileLabel" nowrap><cf_translate key="Direccion">Direcci&oacute;n</cf_translate>:</td>
			  <td colspan="2">#rsFamiliares.FEdir#</td>
			</tr>
			
			<cfif len(trim(rsFamiliares.FEidconcepto)) gt 0>
				<cfquery name="rsConceptoRenta" datasource="#session.DSN#">
					select CDdescripcion
					from ConceptoDeduc
					where CDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFamiliares.FEidconcepto#">
					order by CDdescripcion
				</cfquery>

				<cfif rsConceptoRenta.recordCount>
				<tr> 
				  <td class="fileLabel" nowrap><cf_translate key="ConceptoRenta">Concepto de Renta</cf_translate></td>
				  <td width="30%">
					#rsConceptoRenta.CDdescripcion#
				  </td>
				</tr>
				</cfif>
			</cfif>
	
			<cfif rsFamiliares.FEdiscapacitado>
				<tr> 
				  <td class="fileLabel" nowrap><cf_translate key="Discapacitado">Discapacitado</cf_translate></td>
				  <!--- <td><cfif rsFamiliares.FEdiscapacitado><img border="0" src="/cfmx/rh/imagenes/checked.gif" alt="Discapacitado"><cfelse><img border="0" src="/cfmx/rh/imagenes/unchecked.gif" alt="No Discapacitado"></cfif></td> --->
				  <td width="30%"><cfif rsFamiliares.FEdiscapacitado><b><cf_translate key="Desde">Desde</cf_translate>: </b>&nbsp;#LSDateFormat(rsFamiliares.InicioDiscap,'dd/mm/yyyy')#<cfelse></cfif></td>
				  <td width="30%"><cfif rsFamiliares.FEdiscapacitado><b><cf_translate key="Hasta">Hasta</cf_translate>: </b>&nbsp;<cfif rsFamiliares.FinDiscap NEQ "">#LSDateFormat(rsFamiliares.FinDiscap,'dd/mm/yyyy')#<cfelse><cf_translate key="INDEFINIDO">INDEFINIDO</cf_translate></cfif></cfif></td>
				</tr>
			</cfif>
		
			<cfif rsFamiliares.FEasignacion>
				<tr> 
				  <td class="fileLabel" nowrap><cf_translate key="CobraAsignacionFamiliar">Cobra Asignaci&oacute;n Familiar</cf_translate></td>
				  <!--- <td><cfif rsFamiliares.FEasignacion><img border="0" src="/cfmx/rh/imagenes/checked.gif" alt="Cobra Asignaci&oacute;n Familiar"><cfelse><img border="0" src="/cfmx/rh/imagenes/unchecked.gif" alt="No Cobra Asignaci&oacute;n Familiar"></cfif></td> --->
				  <td width="30%"><cfif rsFamiliares.FEasignacion><b><cf_translate key="Desde">Desde</cf_translate>: </b>&nbsp;#LSDateFormat(rsFamiliares.InicioAsigna,'dd/mm/yyyy')#</cfif></td>
				  <td width="30%"><cfif rsFamiliares.FEasignacion><b><cf_translate key="Desde">Desde</cf_translate>: </b>&nbsp;<cfif rsFamiliares.FinAsigna NEQ "">#LSDateFormat(rsFamiliares.FinAsigna,'dd/mm/yyyy')#<cfelse><cf_translate key="INDEFINIDO">INDEFINIDO</cf_translate></cfif></cfif></td>
				</tr>
			</cfif>
		
			<cfif rsFamiliares.FEestudia>
				<tr> 
				  <td class="fileLabel" nowrap><cf_translate key="Estudia">Estudia</cf_translate></td>
				  <!--- <td><cfif rsFamiliares.FEestudia><img border="0" src="/cfmx/rh/imagenes/checked.gif" alt="Estudia"><cfelse><img border="0" src="/cfmx/rh/imagenes/unchecked.gif" alt="No Estudia"></cfif></td> --->
				  <td width="30%"><cfif rsFamiliares.FEestudia><b><cf_translate key="Desde">Desde</cf_translate>: </b>&nbsp;#LSDateFormat(rsFamiliares.InicioEst,'dd/mm/yyyy')#</cfif></td>
				  <td width="30%"><cfif rsFamiliares.FEestudia><b><cf_translate key="Desde">Desde</cf_translate>: </b>&nbsp;<cfif rsFamiliares.FinEst NEQ "">#LSDateFormat(rsFamiliares.FinEst,'dd/mm/yyyy')#<cfelse><cf_translate key="INDEFINIDO">INDEFINIDO</cf_translate></cfif></cfif></td>
				</tr>
			</cfif>
		
			<cfif rsEtiquetasFam.recordCount GT 0>
				<cfloop query="rsEtiquetasFam">
					<tr> 
					  <td class="fileLabel" nowrap>#rsEtiquetasFam.RHEtiqueta#:</td>
					  <td colspan="2">#Evaluate("rsFamiliares.#rsEtiquetasFam.RHEcol#")#</td>
					</tr>
				</cfloop>
			</cfif>
			
		</table>
		
	  </td>
	  
	</tr>
	</cfloop>
	</table>
	</cfoutput>
	<cfelse>
		<cf_translate key="MSG_ElEmpleadoNoTieneFamiliaresAsociadosAactualmente">El empleado no tiene familiares asociados actualmente</cf_translate>
</cfif>

<cf_web_portlet_end>
