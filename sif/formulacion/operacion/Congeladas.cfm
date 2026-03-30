<style type="text/css">
	.msgError {font-family: Georgia, "Times New Roman", Times, serif;font-style: italic;font-weight: bold;color: #FF0000;}
</style>

<cfparam name="url.resumido" 	default="false">
<cfparam name="form.tab" 		default="1">
<cfparam name="URL.tab" 		default="#form.tab#">
<cfparam name="param"  			default="">
<cfparam name="ModoDet" 		default="ALTA">
<cfparam name="request.RolAdmin"default="false">
<cfparam name="url.FPEEid"  	default="-1">
<cfparam name="form.FPEEid" 	default="#url.FPEEid#">
<cfparam name="url.FPDElinea"  	default="-1">
<cfparam name="form.FPDElinea" default="#url.FPDElinea#">

<cfparam name="url.FPEPID" 		default="-1">
<cfparam name="form.FPEPID" 	default="#url.FPEPID#">
<cfparam name="form.HV" 		default="0">
<cfparam name="prefijoHV" 		default="">
<cfparam name="filtroHV" 		default="">
<cfparam name="esVariacion" 	default="true">

<cfif form.HV NEQ 0>
	<cfset prefijoHV  = 'V'>
	<cfset filtroHV	  = "and Version = #form.HV#">
</cfif>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>

<cf_dbfunction name="OP_concat" 					  returnvariable="_Cat">
<cf_dbfunction name="to_char"	args="a.FPEEid"  	  returnvariable="V_FPEEid">
<cf_dbfunction name="to_char"	args="a.FPEPid"  	  returnvariable="V_FPEPid">
<cf_dbfunction name="to_char"	args="a.FPDElinea"    returnvariable="V_FPDElinea">
<cf_dbfunction name="to_char"	args="a.FPCCid"       returnvariable="V_FPCCid">

<cfset PCG_ConceptoGastoIngreso = createobject("component","sif.Componentes.PCG_ConceptoGastoIngreso")>
<cfset PlantillaFormulacion = createobject("component","sif.Componentes.PlantillaFormulacion")>		
<cfset FPRES_EstimacionGI    = createobject("component","sif.Componentes.FPRES_EstimacionGI")>	

<cfif isdefined('form.FPEEid') and len(trim(form.FPEEid)) and isdefined('form.FPEPID') and len(trim(form.FPEPID)) and form.FPEPID neq -1 and isdefined('form.FPDElinea') and len(trim(form.FPDElinea)) and form.FPDElinea neq -1>
	<cfset ModoDet = 'CAMBIO'>
</cfif>
<cfset detExtra = "">
<cfif isdefined('form.Equilibrio')>
	<cfset detExtra = "(En Equilibrio)">
</cfif>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}" returnvariable="CPPfechaDesde">
<cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}" returnvariable="CPPfechaHasta">
<cfquery name="rsPeriodos" datasource="#session.DSN#">
	select distinct a.CPPid as value,  case b.CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
							#_Cat# ' de ' #_Cat# 
						 case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
							#_Cat# ' ' #_Cat# #preservesinglequotes(CPPfechaDesde)#
							#_Cat# ' a ' #_Cat# 
						 case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
							#_Cat# ' ' #_Cat# #preservesinglequotes(CPPfechaHasta)#
						 as description, 1 as ord 
	from FPEEstimacion a inner join CPresupuestoPeriodo b on a.Ecodigo = b.Ecodigo and a.CPPid  = b.CPPid
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and FPEEestado in (0,1,2,3,4,5)
	union 
	select -1 as value, '-- todos --' as description, 0 as ord  from dual
	order by ord,description
</cfquery>
<cf_navegacion name="FPECid" navegacion="lvarNavegacion">
<cf_navegacion name="CPPid" navegacion="lvarNavegacion">
<cf_navegacion name="FPTVid" navegacion="lvarNavegacion">	
<cf_templateheader title="Estimación de Presupuesto">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Estimaciones/Variaciones Congeladas">
		<cfif isdefined("form.FPTVid") and len(trim(form.FPTVid)) and form.FPTVid neq -1>
			<cfinclude template="Congeladas-form.cfm">
		<cfelse>		
			<cfinclude template="Congeladas-lista.cfm">
		</cfif>
		<script language="javascript1.2" type="text/javascript">
			function funcAplicar(){
				<!---if(!fnAlgunoMarcadoformCongelados()){
					alert("Debe de haber un registro marcado.")
					return false;
				}
				m = 0;
				if (document.formCongelados.chk) {
					if (document.formCongelados.chk.value) {
						return document.formCongelados.chk.checked;
					} else {
						for (var i=0; i<document.formCongelados.chk.length; i++) {
							if (document.formCongelados.chk[i].checked) { 
								m = m + 1;
							}
						}
					}
				}
				if(m > 1){
					alert("Solo se permite un registro marcado.")
					return false;
				}--->
				if(!confirm("Esta seguro de Descongelar las variaciones asociadas a esta grupo?")){
					return false;
				}
				document.formCongelados.action='EstimacionGI-sql.cfm?btnDescongelar=true';
				return true;
			}
			function funcAnular(){
				if(!confirm("Esta seguro de descartar las variaciones asociadas a esta grupo?")){
					return false;
				}
				document.formCongelados.action='EstimacionGI-sql.cfm?btnDescartar=true';
				return true;
			}
		</script>
	<cf_web_portlet_end>
<cf_templatefooter>