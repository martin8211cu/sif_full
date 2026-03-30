<!--- Consultas para determinar cuales pasos ya fueron cumplidos o están siendo cumplidos --->
<cfif isdefined("FORM.RHRCid") and len(trim(FORM.RHRCid)) gt 0>
	<cfquery name="rsUno" datasource="#Session.DSN#">
		select 1
		from RHRelacionCalificacion
		where RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.RHRCid#">
	</cfquery>
	<cfquery name="rsDos" datasource="#Session.DSN#">
		select count(1) as Cont
		from RHEvaluadoresCalificacion
		where RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.RHRCid#">
	</cfquery>
	<cfquery name="rsTres" datasource="#Session.DSN#">
		select count(1) as Cont
		from RHEvaluadoresCalificacion
		where RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.RHRCid#">
	</cfquery>
	<cfquery name="rsCuatro" datasource="#Session.DSN#">
		select count(1) as Cont
		from RHEmpleadosCF
		where RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.RHRCid#">
	</cfquery>
</cfif>
<cfscript>
	uno.checked = isdefined("rsUno") and rsUno.RecordCount gt 0;
	dos.checked = isdefined("rsDos") and rsDos.Cont gt 0;
	tres.checked = isdefined("rsTres") and rsTres.Cont gt 0;
	cuatro.checked = isdefined("rsTres") and rsTres.Cont gt 0;
	cinco.checked = isdefined("rsCuatro") and rsTres.Cont gt 0;
	seis.checked = isdefined("rsCuatro") and rsTres.Cont gt 0;
</cfscript>

<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Proceso" xmlFile="/rh/generales.xml" default="Proceso" returnvariable="LB_Proceso"/>	
<cf_web_portlet_start border="true" titulo="#LB_Proceso#" skin="#Session.Preferences.Skin#">
<cfoutput>
	<table width="100%"  border="0" cellspacing="3" cellpadding="0">
	  <tr>
		<td width="1%" valign="middle"><div align="center">
		  <cfif form.sel eq 0>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
	      </cfif>
	    </div></td>
		<td width="1%" valign="middle"><div align="center"><a href="actCompetencias.cfm?SEL=0"><img src="/cfmx/rh/imagenes/Home01_T.gif" border="0"></a></div></td>
		<td width="100%" valign="middle" nowrap><strong><a href="actCompetencias.cfm?SEL=0"><cf_translate key="LB_ListaDeRelaciones" xmlFile="/rh/generales.xml">Lista de Relaciones</cf_translate></a></strong></td>
	  </tr>
	  <tr>
		<td width="1%" valign="middle"><div align="center">
		  <cfif form.sel eq 1>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		    <cfelseif uno.checked>
		    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
	      </cfif>
	    </div></td>
		<td width="1%" valign="middle"><div align="center"><a href="actCompetencias.cfm?SEL=1<cfif isdefined('FORM.RHRCid') and FORM.RHRCid NEQ ''>&RHRCid=#FORM.RHRCid#<cfelse>&btnNuevo=btnNuevo</cfif>"><img src="/cfmx/rh/imagenes/number1_16.gif" border="0"></a></div></td>
		<td width="100%" valign="middle" nowrap><strong><a href="actCompetencias.cfm?SEL=1<cfif isdefined('FORM.RHRCid') and FORM.RHRCid NEQ ''>&RHRCid=#FORM.RHRCid#<cfelse>&btnNuevo=btnNuevo</cfif>"><cf_translate key="LB_RegistroDeLaRelacion" xmlFile="/rh/generales.xml">Registro de la Relación</cf_translate> </a></strong></td>
	  </tr>
	  <tr>
		<td valign="middle"><div align="center">
		  <cfif form.sel eq 2>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		    <cfelseif dos.checked>
		    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
	      </cfif>
	    </div></td>
		<td valign="middle">
			<div align="center">
				<a href="javascript: verifYave(2);">
					<img src="/cfmx/rh/imagenes/number2_16.gif" border="0">
				</a>			
			</div>
		</td>
		<td valign="middle" nowrap>
			<strong>
<!--- 				<a href="registro_evaluacion.cfm?SEL=2<cfif isdefined('FORM.RHRCid') and FORM.RHRCid NEQ ''>&RHRCid=#FORM.RHRCid#<cfelse>&btnNuevo=btnNuevo</cfif>"> --->
				<a href="javascript: verifYave(2);">
					<cf_translate key="LB_AsignacionDeEvaluadores" xmlFile="/rh/capacitacion/actComp/actCompetencias.xml">Asignación de Evaluadores</cf_translate>
				</a>
			</strong>
		</td>
	  </tr>
	  <tr>
		<td valign="middle"><div align="center">
		  <cfif form.sel eq 3>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		    <cfelseif dos.checked>
		    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
	      </cfif>
	    </div></td>
		<td valign="middle">
			<div align="center">
				<a href="javascript: verifYave(3);">
					<img src="/cfmx/rh/imagenes/number3_16.gif" border="0">
				</a>				
			</div>
		</td>
		<td valign="middle" nowrap>
			<strong>
				<a href="javascript: verifYave(3);">
					<cf_translate key="LB_ListaDeEvaluadores" xmlFile="/rh/generales.xml">Lista de Evaluadores</cf_translate>
				</a>			
			</strong>
		</td>
	  </tr>	  
	  <tr>
		<td valign="middle"><div align="center">
		  <cfif form.sel eq 4>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		    <cfelseif cuatro.checked>
		    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
	      </cfif>
	    </div></td>
		<td valign="middle">
			<div align="center">
				<a href="javascript: verifYave(4);">
					<img src="/cfmx/rh/imagenes/number4_16.gif" border="0">
				</a>				
			</div>
		</td>
		<td valign="middle" nowrap>
			<strong>
				<a href="javascript: verifYave(4);">
					Asignaci&oacute;n de Centros Funcionales 
				</a>			
			</strong>
		</td>
	  </tr>
	  <tr>
		<td valign="middle"><div align="center">
		  <cfif form.sel eq 5>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		    <cfelseif cinco.checked>
		    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
	      </cfif>
	    </div></td>
		<td valign="middle">
			<div align="center">
				<a href="javascript: verifYave(5);">
					<img src="/cfmx/rh/imagenes/number5_16.gif" border="0">
				</a>				
			</div>
		</td>
		<td valign="middle" nowrap>
			<strong>
				<a href="javascript: verifYave(5);">
					Lista de Empleados
				</a>			
			</strong>
		</td>
	  </tr>
	  <tr>
		<td valign="middle"><div align="center">
		  <cfif form.sel eq 6>
		    <img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
		    <cfelseif seis.checked>
		    <img src="/cfmx/rh/imagenes/w-check.gif" border="0">
	      </cfif>
	    </div></td>
		<td valign="middle">
			<div align="center">
				<a href="javascript: verifYave(6);">
					<img src="/cfmx/rh/imagenes/number6_16.gif" border="0">
				</a>				
			</div>
		</td>
		<td valign="middle" nowrap>
			<strong>
				<a href="javascript: verifYave(6);">
					Finalizar Registro
				</a>			
			</strong>
		</td>
	  </tr>
	</table>
</cfoutput>
<cf_web_portlet_end>
 
 
<script language="javascript" type="text/javascript">
	function verifYave(opt){
		var llave = '';
		<cfif isdefined('FORM.RHRCid') and FORM.RHRCid NEQ ''>
			llave = '<cfoutput>#FORM.RHRCid#</cfoutput>';
		</cfif>

		if(llave != ''){
//			if(opt <= 3){
				location.href = "actCompetencias.cfm?RHRCid=" + llave + "&SEL=" + opt;
		/*	}else{
				if(opt == 6){
					location.href = "actCompetencias.cfm?RHRCid=" + llave + "&SEL=" + opt;
				}else{
					<cfif isdefined('FORM.RHRCid') and FORM.RHRCid NEQ '' and isdefined('FORM.DEid') and FORM.DEid NEQ ''>
						location.href = "actCompetencias.cfm?RHRCid=" + llave + "&SEL=" + opt + "&DEid=<cfoutput>#FORM.DEid#</cfoutput>";
					<cfelse>
						alert('Primero debe seleccionar un evaluador');
					</cfif>				
				}
			}*/
		}else{
			alert('Debe seleccionar una relación de calificación');
		}
	}
</script>