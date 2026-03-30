<cfparam name="url.FPE" default="false"><!--- Formulación de Presupuesto Extraordinario --->
<cf_dbfunction name="OP_concat" returnvariable="_Cat">

<cfquery name="Periodos" datasource="#session.dsn#">
	select  CPPid, 
		case CPPtipoPeriodo 
			when 1 then 'Mensual' 
			when 2 then 'Bimestral' 
			when 3 then 'Trimestral' 
			when 4 then 'Cuatrimestral' 
			when 6 then 'Semestral' 
			when 12 then 'Anual' else '' end
			#_Cat# ' de ' #_Cat# 
       case <cf_dbfunction name="date_part" args="MM,CPPfechaDesde">
	        when 1 then 'Enero' 
			when 2 then 'Febrero' 
			when 3 then 'Marzo' 
			when 4 then 'Abril' 
			when 5 then 'Mayo' 
			when 6 then 'Junio' 
			when 7 then 'Julio' 
			when 8 then 'Agosto' 
			when 9 then 'Setiembre' 
			when 10 then 'Octubre' 
			when 11 then 'Noviembre' 
			when 12 then 'Diciembre' else '' end
			#_Cat# ' ' #_Cat# 
		 	<cf_dbfunction name="date_format" args="CPPfechaDesde,YYYY">
			#_Cat# ' a ' #_Cat# 
		case <cf_dbfunction name="date_part" args="MM,CPPfechaHasta">
			when 1 then 'Enero' 
			when 2 then 'Febrero' 
			when 3 then 'Marzo' 
			when 4 then 'Abril' 
			when 5 then 'Mayo' 
			when 6 then 'Junio' 
			when 7 then 'Julio' 
			when 8 then 'Agosto' 
			when 9 then 'Setiembre' 
			when 10 then 'Octubre' 
			when 11 then 'Noviembre' 
			when 12 then 'Diciembre' else '' end
			#_Cat# ' ' #_Cat# <cf_dbfunction name="date_format" args="CPPfechaHasta,YYYY">  as Pdescripcion,
			Mcodigo 
	from CPresupuestoPeriodo
	where Ecodigo = #Session.Ecodigo#
		<cfif url.FPE>
		and CPPestado = 1
		<cfelse>
		and CPPestado = 0
		</cfif>
	order by CPPanoMesDesde,CPPfechaDesde,CPPfechaHasta
</cfquery>

		<cfquery name="rsPeajes" datasource="#session.dsn#">
		   Select 
			  pe.Pdescripcion,
			  pe.Pid
			from Peaje pe
			where Ecodigo = #session.ecodigo#
		</cfquery>	


	<cfoutput>
	<form name="form1" action="EstEnviarFormulacion.cfm" method="get" style="margin:0">
		<table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0" >
			<tr><td>&nbsp;</td></tr> 
			<tr>
				<cfif Periodos.recordcount gt 0>
				<td class="tituloListas" nowrap align="center">
					<select name="CPPid">
					  <cfloop query="Periodos">
						  <option value="#Periodos.CPPid#">#Periodos.Pdescripcion#</option>
					  </cfloop>
					</select>
				<cfelse>
					<strong>No se ha definido el Periodo Presupuestal</strong>
				</cfif>
					<select name="Pid">
					  <cfloop query="rsPeajes">
						  <option value="#rsPeajes.Pid#">#rsPeajes.Pdescripcion#</option>
					  </cfloop>
					</select>
				</td>
			</tr>	
			<tr><td>&nbsp;</td></tr>
			<tr>
				<cfif Periodos.recordcount gt 0>
             	<td colspan="3" align="center"><cf_botones values="Consultar" tabindex="1"></td>
				 <cfelse>
             	<td colspan="3" align="center"><cf_botones values="Regresar" tabindex="1"></td>
				</cfif>
         </tr>
		</table>
	</form>
	</cfoutput>
	
	<cfif Periodos.recordcount gt 0>
		<cf_qforms objForm="objForm1" form="form1">
			<cf_qformsRequiredField name="CPPid" description="CPPid">
		</cf_qforms>
	
		<script language="javascript" type="text/javascript">
			function funcConsultar(){
				objForm1.CPPid.description = "CPPid";
			} 
		</script>
	</cfif>
