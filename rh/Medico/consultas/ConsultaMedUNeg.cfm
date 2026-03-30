<cfif  len(trim(form.fdesde)) eq 0 and  len(trim(form.fhasta)) eq 0>
	<cfquery name="rsFechas" datasource="#session.DSN#">
		select 
		min(coalesce(a.IEfecha,a.IEdesde)) as fechamin,
		max(coalesce(a.IEfecha,a.IEdesde)) as fechamax
		from IncidenciasExpediente a
		inner join DatosEmpleado de
			on a.DEid = de.DEid
		inner join LineaTiempo d
			on a.DEid = d.DEid
			and a.Ecodigo = d.Ecodigo
			and coalesce(a.IEfecha,a.IEdesde) between LTdesde and LThasta
		inner join RHPlazas e
			on e.RHPid = d.RHPid 
		inner join CFuncional f
			on e.Ecodigo = f.Ecodigo
			and e.CFid = f.CFid
			<cfif isdefined("form.CFid") and len(trim(form.CFid)) gt 0>
				and e.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
			</cfif>		
		where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">	
	</cfquery>
	<!--- <cf_dump var="#rsFechas#"> ---> 
</cfif>
<cfquery name="rsDatos" datasource="#session.DSN#">
	select de.DEidentificacion,
	{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )} as nombre,
	{fn concat(f.CFcodigo,{fn concat(' ',f.CFdescripcion)})} as  centrofuncional,
	count(a.IEid) as consultas 
	from IncidenciasExpediente a
	inner join DatosEmpleado de
		on a.DEid = de.DEid
	inner join LineaTiempo d
		on a.DEid = d.DEid
		and a.Ecodigo = d.Ecodigo
		and coalesce(a.IEfecha,a.IEdesde) between LTdesde and LThasta
	inner join RHPlazas e
		on e.RHPid = d.RHPid 
	inner join CFuncional f
		on e.Ecodigo = f.Ecodigo
		and e.CFid = f.CFid
		<cfif isdefined("form.CFid") and len(trim(form.CFid)) gt 0>
			and e.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
		</cfif>		
	where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">	
	<cfif isdefined("form.fdesde") and len(trim(form.fdesde)) gt 0>
		and a.IEfecha >= <cfqueryparam value="#LSDateFormat(form.fdesde,'yyyy/mm/dd')#" cfsqltype="cf_sql_date">
	</cfif>
	<cfif isdefined("form.fhasta") and len(trim(form.fhasta)) gt 0>
		and a.IEfecha <= <cfqueryparam value="#LSDateFormat(form.fhasta,'yyyy/mm/dd')#" cfsqltype="cf_sql_date">
	</cfif>
	group by {fn concat(f.CFcodigo,{fn concat(' ',f.CFdescripcion)})},{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )},de.DEidentificacion
	order by {fn concat(f.CFcodigo,{fn concat(' ',f.CFdescripcion)})},{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )},de.DEidentificacion	
</cfquery>

<cfset columnas = 3>
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="consultas_medicas_por_Unidad_de_Negocio"
	Default="Consultas m&eacute;dicas por Unidad de Negocio"
	returnvariable="consultas_medicas_por_Unidad_de_Negocio"/>
    
<cfset LvarFileName = "consultas_medicas_por_Unidad_de_Negocio_#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">

<cf_htmlReportsHeaders 
    title="#consultas_medicas_por_Unidad_de_Negocio#" 
    filename="#LvarFileName#"
    irA="ConsultaMedUNeg-filtro.cfm" >
<style type="text/css">
	.RLTtopline {
		border-bottom-width: none;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}	
	
	.LTtopline {
		border-bottom-width: none;
		border-bottom-width: none;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}	
	.LRTtopline {
		border-bottom-width: none;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}
	
	.RTtopline {
		border-bottom-width: none;
		border-bottom-width: none;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}	
	
	.Completoline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-top-width: 1px;
		border-top-style: solid;
		border-top-color: #000000			
	}	
	
	.topline {
			border-top-width: 1px;
			border-top-style: solid;
			border-top-color: #000000;
			border-right-style: none;
			border-bottom-style: none;
			border-left-style: none;
		}
	
	.bottonline {
			border-bottom-width: 1px;
			border-bottom-style: solid;
			border-bottom-color: #000000;
			border-right-style: none;
			border-top-style: none;
			border-left-style: none;
		}
		
	.RLTbottomline {
		border-top-width: none;
		border-left-width: none;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000			
	}	
	
	.RLTbottomline2 {
		border-top-width: none;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000			
	}
	
	.RLline {
		border-top-width: none;
		border-bottom-width: none;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-right-width: 1px;
		border-right-style: solid;
		border-right-color: #000000;
	}
	
	.LTbottomline {
		border-top-width: none;
		border-left-width: 1px;
		border-left-style: solid;
		border-left-color: #000000;
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-bottom-color: #000000			
	}		
</style>
	<cfoutput>
        <table width="100%" align="center" cellpadding="0" cellspacing="0" border="0">
            <tr>
                <td bgcolor="##CCCCCC" class="RLTtopline" colspan="#columnas#" align="center">
                    <font  style="font-size:15px; font-family:'Arial'">#session.enombre#</font> 
                </td>
            </tr>
			<tr>
                <td bgcolor="##CCCCCC" class="Completoline" colspan="#columnas#" align="center">
                    <font  style="font-size:14px; font-family:'Arial'">#consultas_medicas_por_Unidad_de_Negocio#</font> 
                </td>
            </tr>
			<tr> 
                <td bgcolor="##CCCCCC" class="Completoline" colspan="#columnas#" align="center">
                    <font  style="font-size:14px; font-family:'Arial'">
						<cfif isdefined("form.fdesde") and len(trim(form.fdesde)) gt 0>
							<cf_translate  key="LB_Desde">Desde</cf_translate> : #form.fdesde#&nbsp;&nbsp;
						</cfif>
						<cfif isdefined("form.fhasta") and len(trim(form.fhasta)) gt 0>
							<cf_translate  key="LB_Hasta">Hasta</cf_translate> : #form.fhasta#&nbsp;&nbsp;
						</cfif>
						<cfif  len(trim(form.fdesde)) eq 0 and  len(trim(form.fhasta)) eq 0>
							<cf_translate  key="LB_Desde">Desde</cf_translate>: #LSDateFormat(rsFechas.fechamin, "dd/mm/yyyy")#&nbsp;&nbsp;<cf_translate  key="LB_Hasta">Hasta</cf_translate>: #LSDateFormat(rsFechas.fechamax, "dd/mm/yyyy")#
						</cfif>
					</font> 
                </td>
            </tr>
           <tr>
                <td  colspan="#columnas#" align="center">
                    <font  style="font-size:11px; font-family:'Arial'"></font>&nbsp;
                </td>
            </tr>
            <tr>
				<td bgcolor="##CCCCCC" class="LTtopline"  colspan="1" align="left">
					<font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_cedula">C&eacute;dula</cf_translate></font> 
				</td>
				<td bgcolor="##CCCCCC" class="LTtopline"  colspan="1" align="left">
					<font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Nombre">Nombre</cf_translate></font> 
				</td>
				<td bgcolor="##CCCCCC" class="RLTtopline"  colspan="1" align="right">
					<font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Cantidad_de_Consultas">Cantidad de Consultas</cf_translate></font> 
				</td>
			</tr>
			<cfset  corte_centrofuncional = "">
			<cfset SumaTotal = 0>	
			<cfloop query="rsDatos">
				<cfif corte_centrofuncional neq rsDatos.centrofuncional>
					<tr>
						<td  class="RLTtopline" colspan="#columnas#" align="left">&nbsp;
							
						</td>
					</tr>
					<tr>
						<td  class="RLTtopline" colspan="#columnas#" align="left">
							<font  style="font-size:14px;  font-family:'Arial'"><cf_translate  key="LB_Unidad_Negocio">Unidad de Negocio</cf_translate>:</font><font  style=" color:##0000FF; font-size:14px;  font-family:'Arial'">#rsDatos.centrofuncional#</font> 
						</td>
					</tr>
					<cfset  corte_centrofuncional = rsDatos.centrofuncional> 
				</cfif>				
				<tr>
					<td class="LTtopline"  colspan="1" align="left" nowrap="nowrap">
						<font  style="font-size:13px; font-family:'Arial'">#rsDatos.DEidentificacion#</font>&nbsp;&nbsp; 
					</td>
					<td class="LTtopline"  colspan="1" align="left"  nowrap="nowrap">
						<font  style="font-size:13px; font-family:'Arial'">#rsDatos.nombre#</font>&nbsp;&nbsp;
					</td>
					<td class="RLTtopline"  colspan="1" align="right"  nowrap="nowrap">
						<font  style="font-size:13px; font-family:'Arial'"> #LSNumberFormat(trim(rsDatos.consultas),',')#</font>
					</td>
				</tr>			
				<cfset SumaTotal= SumaTotal + rsDatos.consultas>	
			</cfloop>
			
			<tr>
                <td class="Completoline" colspan="#columnas-1#" align="right">
                    <font  style="font-size:11px; font-family:'Arial'">Total:&nbsp;</font>
                </td>
				<td class="Completoline" colspan="1" align="right">
                    <font  style="font-size:11px; font-family:'Arial'"><cfoutput>#SumaTotal#</cfoutput></font>
                </td>
            </tr>
			<tr>
                <td  bgcolor="##CCCCCC" class="Completoline" colspan="#columnas#" align="center">
                    <font  style="font-size:11px; font-family:'Arial'"></font>&nbsp;
                </td>
            </tr>
        </table>
    </cfoutput>
