<cfif isDefined("form.SalarioPromedioRAS")>
	<cfinclude template="ReporteSalarioPromedioRAS-SQL.cfm">
	<cfabort />
</cfif>
<cf_templatecss>

<style type="text/css">
	.stitulo{
		font-weight:bold;
		font-size:14px;
		text-transform:uppercase;
	}
	.subrayados{
		border-bottom:ridge;
	}
</style>	
<cf_dbfunction name="OP_Concat" returnvariable="concat">
<cfif isdefined("url.CIid") and len(trim(url.CIid)) gt 0>
	<cfset form.CIid=url.CIid>
</cfif>
<cfif isdefined("url.DEid") and len(trim(url.DEid)) gt 0>
	<cfset form.DEid=url.DEid>
</cfif>

<!---- obtiene el Tcodigo de la accion si ya fue o no aplicada----->
<cfif isdefined("url.RHAlinea") and len(trim(url.RHAlinea)) gt 0>
	<cfquery datasource="#session.dsn#" name="rsTcodigo">
	select Tcodigo from RHAcciones where RHAlinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHAlinea#">
	</cfquery>
	<cfset form.Tcodigo=trim(rsTcodigo.Tcodigo)>
</cfif>
<cfif isdefined("url.DLlinea") and len(trim(url.DLlinea)) gt 0>
	<cfquery datasource="#session.dsn#" name="rsTcodigo">
	select Tcodigo from DLaboralesEmpleado where DLlinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DLlinea#">
	</cfquery>
	<cfset form.Tcodigo=trim(rsTcodigo.Tcodigo)>
</cfif>

<cfset existeAplicado=false>	
<cfset provieneReporte=true>	

<cfif isdefined("form.fromForm")>
	<cfset provieneReporte=true>	
</cfif>	
		<cfif (isdefined("url.RHAlinea") and len(trim(url.RHAlinea)) gt 0) or (isdefined("url.DLlinea") and len(trim(url.DLlinea)) gt 0)>
				<!------------- dias promedio parametrizados----->
				<cfset factorDias =0>
				
					<cfquery name="rsParametros" datasource="#Session.DSN#">
						select FactorDiasSalario as Pvalor
						from TiposNomina
						where Ecodigo = #session.Ecodigo#
						  and rtrim(ltrim(Tcodigo)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.Tcodigo)#">
					</cfquery>
					<cfif rsParametros.recordcount gt 0>
						<cfset factorDias =rsParametros.Pvalor>
					</cfif>	
					
		<cfif len(trim(rsParametros.Pvalor)) EQ 0 or rsParametros.RecordCount EQ 0>
			<cfquery name="rsParametros" datasource="#Session.DSN#">
				select Pvalor from RHParametros where Ecodigo = #session.Ecodigo# and Pcodigo = 80
			</cfquery>
						<cfif rsParametros.recordcount gt 0>
							<cfset factorDias =rsParametros.Pvalor>
						</cfif>	
					</cfif>
					
					<cfquery datasource="#session.dsn#" name="rsDatosConcepto">
					select CIcodigo, CIdescripcion
					from CIncidentes
					where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
					</cfquery>
					
				<!----- fin de valores parametrizados-------------->
		</cfif>					
			
	
		<!---- si se esta consultando una accion que no se ha aplicado------------->
		<cfif isdefined("url.RHAlinea") and len(trim(url.RHAlinea)) gt 0>
			<cfquery datasource="#session.dsn#" name="rsAccion">
				select DEid, DLfvigencia
				from RHAcciones
				where RHAlinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHAlinea#">
			</cfquery>
			<cfset form.DEid=rsAccion.DEid>			 
		
				<cfquery name="miSalarioPromedio" datasource="#session.dsn#">
					select b.RHSPAdias as cantPago,
					hrc.Tcodigo, hrc.RCDescripcion,RCdesde, RChasta, 
					cp.CPcodigo,
					coalesce(RHSPAsalariobruto,0) as SEsalariobruto, coalesce(RHSPAincidencias,0) as SEIncidencias, 
					coalesce((RHSPAsalariobruto + RHSPAincidencias),0) as SESalMes,
						coalesce(
						(select coalesce(sum(RHSPAsalariobruto + RHSPAincidencias),0) / coalesce(sum(RHSPAdias),0) * <cfqueryparam cfsqltype="cf_sql_numeric" value="#factorDias#">
						from RHSalPromAccion x
						where x.RHAlinea = b.RHAlinea
						and x.CIid =b.CIid
						),0) as SalarioPromedio,   <!---- se obtiene variable de salario promedio----->
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#factorDias#"> as factorDias,b.CIid
					from RHSalPromAccion b
						inner join HRCalculoNomina hrc
							on b.RCNid=hrc.RCNid	
						inner join CalendarioPagos cp
							on b.RCNid=cp.CPid
						inner join DatosEmpleado de
							on b.DEid=de.DEid	
					where b.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHAlinea#"> 	
					and b.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
				</cfquery>
				
				<cfif miSalarioPromedio.recordcount gt 0>
					<cfset existeAplicado=true>	
				<cfelse>
					<cfquery datasource="#session.dsn#" name="rsDatosConcepto">
					select b.CIsprango, b.CIspcantidad, b.CImescompleto, b.CIcodigo, b.CIdescripcion
					from RHConceptosAccion a
						inner join CIncidentes b
							on a.CIid=b.CIid
					where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHAlinea#"> 	
					and a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
					</cfquery>
				</cfif>
		</cfif>

		<!------ si se esta consultando una accion ya aplicada-------------------->
		<cfif isdefined("url.DLlinea") and len(trim(url.DLlinea)) gt 0>
			<cfquery datasource="#session.dsn#" name="rsAccion">
				select DEid, DLfvigencia
				from DLaboralesEmpleado
				where DLlinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DLlinea#">
			</cfquery>
			
			<cfset form.DEid=rsAccion.DEid>
			<cfset form.Fecha=rsAccion.DLfvigencia>
			
				<cfquery name="miSalarioPromedio" datasource="#session.dsn#">
					select b.RHSPAdias as cantPago,
					hrc.Tcodigo, hrc.RCDescripcion,RCdesde, RChasta, 
					cp.CPcodigo,
					coalesce(RHSPAsalariobruto,0) as SEsalariobruto, coalesce(RHSPAincidencias,0) as SEIncidencias, 
					coalesce((RHSPAsalariobruto + RHSPAincidencias),0) as SESalMes,
						coalesce(
						(select coalesce(sum(RHSPAsalariobruto + RHSPAincidencias),0) / coalesce(sum(RHSPAdias),0) * <cfqueryparam cfsqltype="cf_sql_numeric" value="#factorDias#">
						from DLSalPromAccion x
						where x.DLlinea = b.DLlinea
						and x.CIid =b.CIid
						),0) as SalarioPromedio,   <!---- se obtiene variable de salario promedio----->
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#factorDias#"> as factorDias,b.CIid
					from DLSalPromAccion b
						inner join HRCalculoNomina hrc
							on b.RCNid=hrc.RCNid	
						inner join CalendarioPagos cp
							on b.RCNid=cp.CPid
						inner join DatosEmpleado de
							on b.DEid=de.DEid	
					where b.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DLlinea#"> 	
					and b.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
					order by RCdesde desc
				</cfquery>	
				<cfif miSalarioPromedio.recordcount gt 0>
					<cfset existeAplicado=true>	
				<cfelse>
					<cfquery datasource="#session.dsn#" name="rsDatosConcepto">
					select a.CIsprango, a.CIspcantidad, a.CImescompleto, b.CIcodigo, b.CIdescripcion
					from DDConceptosEmpleado a
						inner join CIncidentes b
							on a.CIid=b.CIid
					where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DLlinea#"> 	
					and a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
					</cfquery>
				</cfif>
		</cfif>
		
		<cfif provieneReporte>
					<cfquery datasource="#session.dsn#" name="rsDatosConcepto">
					select a.CIsprango, a.CIspcantidad, a.CImescompleto, b.CIcodigo, b.CIdescripcion
					from CIncidentesD a
						inner join CIncidentes b
							on a.CIid=b.CIid
					where a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
					</cfquery>
		</cfif>

		<!------------- se consulta por accion------------------------------------->
			<cfif existeAplicado eq false>
					<cfinvoke component="rh.admin.catalogos.calculadora.variables.var_SalarioPromedio" method="getSalarioPromedio" returnvariable="miSalarioPromedio">
						<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>
						<cfinvokeargument name="calc_promedio" value="true"/>
						<cfinvokeargument name="CIsprango" value="#rsDatosConcepto.CIsprango#"/>
						<cfinvokeargument name="CIspcantidad" value="#rsDatosConcepto.CIspcantidad#"/>
						<cfinvokeargument name="CImescompleto" value="#rsDatosConcepto.CImescompleto#"/>
						<cfinvokeargument name="lvarMasivo" value="false"/>
						<cfinvokeargument name="DEid" value="#form.DEid#"/>
						<cfinvokeargument name="lvarCIid" value="#form.CIid#"/>							
						<cfinvokeargument name="Fecha1_Accion" value="#form.Fecha#"/>
						<cfinvokeargument name="report" value="true"/>
					</cfinvoke>
			</cfif>
		
		<!-------- aplica para todas las consultas----------->
					
					
		<cfquery datasource="#session.dsn#" name="rsDatosEmpleado">
			select DEnombre #concat#' '#concat# DEapellido1 #concat#' '#concat# DEapellido2 as NombreEmp
			from DatosEmpleado
			where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		</cfquery>
	

	
<!---------------------------------------------------------------------------- PINTADO DE LOS DATOS-------------------------------------------------->
	<cfinvoke component="sif.Componentes.Translate" method="Translate"
Key="LB_ReportSalarioPromedio"
Default="Reporte de Salario Promedio"
returnvariable="LB_ReportSalarioPromedio"/>	

	<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
	
	<tr>
		<td colspan="17">
			<cfset miIrA="ReporteSalarioPromedio.cfm">
			<cfif isdefined("url.ModoPopUp") and len(trim(url.ModoPopUp)) gt 0>
				<cfset miIrA='/cfmx/rh/nomina/operacion/popUpReporteConceptosPago.cfm?CIid=#url.CIid#&RHAlinea=#url.RHAlinea#'>
			</cfif>	
				<cf_htmlReportsHeaders 
				title="Reporte de Salario Promedio" 
				filename="Reporte_Salario_Promedio_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls"
				irA="#miIrA#">	
		</td>
	</tr>		
	</table>	
	<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">

		<tr>
			<td colspan="17">
			<cf_EncReporte Titulo="#LB_ReportSalarioPromedio# - #rsDatosEmpleado.NombreEmp#"Color="##E3EDEF">
			</td>
		</tr>
		
		<cfif  existeAplicado eq false and provieneReporte eq false>
		<tr><td colspan="17" align="left"></tr>
		<tr>
			<td colspan="17" align="left">
			<i><b><u>Este reporte ha recalculado el Salario Promedio del empleado en la fecha de la Acci&oacute;n, dado que &eacute;ste NO fue almacenado al momento de realizar la Acci&oacute;n</u></b></i>
			</td>
		</tr>
		<tr><td colspan="17" align="left"></tr>
		</cfif>	
		
		<tr>
			<td colspan="7" class="stitulo" align="left">
				Concepto de Pago:&nbsp;<cfoutput>#rsDatosConcepto.CIcodigo# - #rsDatosConcepto.CIdescripcion#</cfoutput>
			</td>
			<td colspan="8" class="stitulo" align="right">
				Vigencia:&nbsp;<cfoutput>#LSDateFormat(form.Fecha, "dd/mm/yyyy")#</cfoutput>
			</td>
		</tr>	
		<tr><td colspan="17">&nbsp;</td></tr>
		<tr class="stitulo">
			<td>Calendario</td>
			<td width="2%">&nbsp;</td>
			<td>Descripcion</td>
			<td width="2%">&nbsp;</td>
			<td>Fecha desde</td>
			<td width="2%">&nbsp;</td>
			<td>Fecha hasta</td>
			<td width="2%">&nbsp;</td>
			<td>Salario Base</td>
			<td width="2%">&nbsp;</td>
			<td>Concepto</td>
			<td width="2%">&nbsp;</td>
			<td>Devengado</td>
			<td width="2%">&nbsp;</td>
			<td>D&iacute;as</td>
		</tr>	
<cfset Tsalariobase=0>
<cfset Tconceptos=0>
<cfset Tdevengado=0>		
<cfset Tdias=0>	

<cfset TsalarioPromedio=0>
<cfset TfactorDias=0>

<cfoutput query="miSalarioPromedio">
			<cfif (not isdefined("url.RHAlinea") or len(trim(url.RHAlinea)) eq 0  )  and (not isdefined("url.DLlinea") or len(trim(url.DLlinea)) eq 0)>
					<tr>
						<td>#CPcodigo#</td>
						<td>&nbsp;</td>
						<td>#RCDescripcion#</td>
						<td>&nbsp;</td>
						<td>#LSDateFormat(RCdesde, "dd/mm/yyyy")#</td>
						<td>&nbsp;</td>
						<td>#LSDateFormat(RChasta, "dd/mm/yyyy")#</td>
						<td>&nbsp;</td>
						<td align="right">#LSNumberFormat(SEsalariobruto, ',9.00')#</td>
						<td>&nbsp;</td>
						<td align="right">#LSNumberFormat(SEIncidencias, ',9.00')#</td>
						<td>&nbsp;</td>
						<td align="right">#LSNumberFormat(SESalMes, ',9.00')#</td>
						<td>&nbsp;</td>
						<td align="right">#LSNumberFormat(cantPago, ',9.00')#</td>
					</tr>	
					
						<cfset Tsalariobase=Tsalariobase+SEsalariobruto>
						<cfset Tconceptos=Tconceptos+SEIncidencias>
						<cfset Tdevengado=Tdevengado+SESalMes>		
						<cfset Tdias=Tdias+cantPago>
						<cfset TsalarioPromedio=SalarioPromedio>
						<cfset TfactorDias=factorDias>
			</cfif>
			
			<cfif isdefined("url.RHAlinea") and len(trim(url.RHAlinea)) gt 0>
					<tr>
						<td>#CPcodigo#</td>
						<td>&nbsp;</td>
						<td>#RCDescripcion#</td>
						<td>&nbsp;</td>
						<td>#LSDateFormat(RCdesde, "dd/mm/yyyy")#</td>
						<td>&nbsp;</td>
						<td>#LSDateFormat(RChasta, "dd/mm/yyyy")#</td>
						<td>&nbsp;</td>
						<td align="right">#LSNumberFormat(SEsalariobruto, ',9.00')#</td>
						<td>&nbsp;</td>
						<td align="right">#LSNumberFormat(SEIncidencias, ',9.00')#</td>
						<td>&nbsp;</td>
						<td align="right">#LSNumberFormat(SESalMes, ',9.00')#</td>
						<td>&nbsp;</td>
						<td align="right">#LSNumberFormat(cantPago, ',9.00')#</td>
					</tr>	
					
						<cfset Tsalariobase=Tsalariobase+SEsalariobruto>
						<cfset Tconceptos=Tconceptos+SEIncidencias>
						<cfset Tdevengado=Tdevengado+SESalMes>		
						<cfset Tdias=Tdias+cantPago>
						<cfset TsalarioPromedio=SalarioPromedio>
						<cfset TfactorDias=factorDias>			
			</cfif>
			
			<cfif isdefined("url.DLlinea") and len(trim(url.DLlinea)) gt 0>
					<tr>
						<td>#CPcodigo#</td>
						<td>&nbsp;</td>
						<td>#RCDescripcion#</td>
						<td>&nbsp;</td>
						<td>#LSDateFormat(RCdesde, "dd/mm/yyyy")#</td>
						<td>&nbsp;</td>
						<td>#LSDateFormat(RChasta, "dd/mm/yyyy")#</td>
						<td>&nbsp;</td>
						<td align="right">#LSNumberFormat(SEsalariobruto, ',9.00')#</td>
						<td>&nbsp;</td>
						<td align="right">#LSNumberFormat(SEIncidencias, ',9.00')#</td>
						<td>&nbsp;</td>
						<td align="right">#LSNumberFormat(SESalMes, ',9.00')#</td>
						<td>&nbsp;</td>
						<td align="right">#LSNumberFormat(cantPago, ',9.00')#</td>
					</tr>	
					
						<cfset Tsalariobase=Tsalariobase+SEsalariobruto>
						<cfset Tconceptos=Tconceptos+SEIncidencias>
						<cfset Tdevengado=Tdevengado+SESalMes>		
						<cfset Tdias=Tdias+cantPago>
						<cfset TsalarioPromedio=SalarioPromedio>
						<cfset TfactorDias=factorDias>
			</cfif>
</cfoutput>
		<cfoutput>
		<tr><td colspan="11"></td></tr>
		<tr class="stitulo">
			<td colspan="4">&nbsp;</td>
			<td colspan="4">&nbsp;</td>
			<td align="right"><strong>#LSNumberFormat(Tsalariobase, ',9.00')#</strong></td>
			<td >&nbsp;</td>
			<td align="right"><strong>#LSNumberFormat(Tconceptos, ',9.00')#</strong></td>
			<td>&nbsp;</td>
			<td align="right"><strong>#LSNumberFormat(Tdevengado, ',9.00')#</strong></td>
			<td>&nbsp;</td>
			<td align="right"><strong>#LSNumberFormat(Tdias, ',9.00')#</strong></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<cfif Tdias neq 0>
			<tr><td colspan="17"><hr /></td></tr>
			<tr><td colspan="17" align="left"><u>Salario Promedio Diario</u>&nbsp;&nbsp;&nbsp;=&nbsp;&nbsp;&nbsp;(<strong>#LSNumberFormat(Tdevengado, ',9.00')#</strong> /  <strong>#LSNumberFormat(Tdias, ',9.00')#</strong>)&nbsp;&nbsp;&nbsp;=&nbsp;&nbsp;&nbsp;<strong>#LSNumberFormat(Tdevengado/Tdias, ',9.00')#</strong></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td>&nbsp;</td></tr>
		</cfif>
		<tr><td colspan="17"><hr /></td></tr>
		<tr>
		
			<td colspan="17" align="center">
			<u>Salario Promedio : <strong>#LSNumberFormat(TsalarioPromedio, ',9.00')#</strong></u>
			</td>
		</tr>	
		<tr><td colspan="17"><hr /></td></tr>
		
		<cfif isdefined("url.ModoPopUp") and len(trim(url.ModoPopUp)) gt 0>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="17" align="center">
			<input type="button" class="btnNormal" 	name="btCerrar"   id="btCerrar" value="Cerrar" 		onClick="javascript: window.close();" />
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		</cfif>
		
		</cfoutput>
</table>