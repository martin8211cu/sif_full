
<cfquery name="rsDatos" datasource="#session.DSN#">
	select de.DEidentificacion,{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )} as nombre,a.IEdesde,a.IEhasta,a.IEid 
	,{fn concat(f.CFcodigo,{fn concat(' ',f.CFdescripcion)})} as  centrofuncional
	<cfif isdefined("form.DFElinea") and len(trim(form.DFElinea)) and form.DFElinea neq '-1'>
		,b.IVvalor,c.DFEetiqueta 
	</cfif>
	from IncidenciasExpediente a
	<cfif isdefined("form.DFElinea") and len(trim(form.DFElinea)) and form.DFElinea neq '-1'>
		inner join IncidenciasValores b
			on a.IEid = b.IEid
		inner join DFormatosExpediente c
			on b.DFElinea = c.DFElinea
			and c.EFEid = (select <cf_dbfunction name="to_number" args="Pvalor">  from RHParametros where Ecodigo  =<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
			 and Pcodigo = 930 )	
			 <cfif isdefined("form.DFElinea") and len(trim(form.DFElinea)) and form.DFElinea neq '-2'>
			 	and c.DFElinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DFElinea#">
			 </cfif>
	</cfif>
	inner join DatosEmpleado de
		on a.DEid = de.DEid
		<cfif isdefined("form.DEid") and len(trim(form.DEid))>
			and de.DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#">
		</cfif>	
	inner join LineaTiempo d
		on a.DEid = d.DEid
		and a.Ecodigo = d.Ecodigo
		and a.IEdesde between LTdesde and LThasta
	inner join RHPlazas e
		on e.RHPid = d.RHPid 
	inner join CFuncional f
		on e.Ecodigo = f.Ecodigo
		and e.CFid = f.CFid
		<cfif isdefined("form.CFid") and len(trim(form.CFid)) gt 0>
			and e.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
		</cfif>
		
	where a.RHTid  is not null
	<cfif isdefined("form.fdesde") and len(trim(form.fdesde)) gt 0>
		and a.IEfecha >= <cfqueryparam value="#LSDateFormat(form.fdesde,'yyyy/mm/dd')#" cfsqltype="cf_sql_date">
	</cfif>
	<cfif isdefined("form.fhasta") and len(trim(form.fhasta)) gt 0>
		and a.IEfecha <= <cfqueryparam value="#form.fhasta#" cfsqltype="cf_sql_timestamp">
	</cfif>
	
	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">	
	
	order by {fn concat(f.CFcodigo,{fn concat(' ',f.CFdescripcion)})},{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )},a.IEid
	<cfif isdefined("form.DFElinea") and len(trim(form.DFElinea)) and form.DFElinea neq '-1'>
		,c.DFEetiqueta
	</cfif>
</cfquery>
<cfset columnas = 4>
<cfif isdefined("form.DFElinea") and len(trim(form.DFElinea)) and form.DFElinea gt 0 >
	<cfset columnas = 5>
<cfelse>
	<cfset columnas = 4>
</cfif>
<cfset columnasX = columnas -1>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="Incapacidades_por_Unidad_de_Negocio"
	Default="Incapacidades por Unidad de Negocio"
	returnvariable="Incapacidades_por_Unidad_de_Negocio"/>

    
<cfset LvarFileName = "Incapacidades_por_Unidad_de_Negocio_#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">

<cf_htmlReportsHeaders 
    title="#Incapacidades_por_Unidad_de_Negocio#" 
    filename="#LvarFileName#"
    irA="IncapacidadesUNeg-filtro.cfm" >
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
                    <font  style="font-size:14px; font-family:'Arial'">#Incapacidades_por_Unidad_de_Negocio#</font> 
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
				<td bgcolor="##CCCCCC" class="LTtopline"  colspan="1" align="center">
					<font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Fechadesde">Fecha desde</cf_translate></font> 
				</td>
				<cfif isdefined("form.DFElinea") and len(trim(form.DFElinea)) and form.DFElinea gt 0 >
					<td bgcolor="##CCCCCC" class="LTtopline"  colspan="1" align="center">
						<font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_FechaHasta">Fecha hasta</cf_translate></font> 
					</td>					
					<td bgcolor="##CCCCCC" class="RLTtopline"  colspan="1" align="left">
						<font  style="font-size:13px; font-family:'Arial'">#rsDatos.DFEetiqueta#</font> 
					</td>
				<cfelse>
					<td bgcolor="##CCCCCC" class="RLTtopline"  colspan="1" align="center">
						<font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_FechaHasta">Fecha hasta</cf_translate></font> 
					</td>				
				</cfif>
			</tr>
			<cfset corte = -1>
			<cfset  corte_centrofuncional = "">
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
				<cfif isdefined("form.DFElinea") and len(trim(form.DFElinea)) and form.DFElinea eq -2>
					<cfif corte neq rsDatos.IEid>
						<tr>
							<td class="LTtopline"  colspan="1" align="left" nowrap="nowrap">
								<font  style="font-size:13px; font-family:'Arial'">#rsDatos.DEidentificacion#</font>&nbsp;&nbsp; 
							</td>
							<td class="LTtopline"  colspan="1" align="left"  nowrap="nowrap">
								<font  style="font-size:13px; font-family:'Arial'">#rsDatos.nombre#</font>&nbsp;&nbsp;
							</td>
							<td class="LTtopline"  colspan="1" align="left"  nowrap="nowrap">
								<font  style="font-size:13px; font-family:'Arial'">#LSDateFormat(rsDatos.IEdesde, "dd/mm/yyyy")#</font>&nbsp;&nbsp; 
							</td>
							<td class="RLTtopline"  colspan="1" align="center">
								<font  style="font-size:13px; font-family:'Arial'">#LSDateFormat(rsDatos.IEhasta, "dd/mm/yyyy")#</font>&nbsp;&nbsp; 
							</td>
						</tr>
						<cfset corte = rsDatos.IEid>
					</cfif>	
					<tr>
						<td  class="LTtopline"  colspan="1" >&nbsp;
							
						</td>
						<td  class="RLTtopline"  colspan="#columnasX#" >
                    		<table width="100%" align="center" cellpadding="0" cellspacing="0" border="0">
								<td   colspan="1" align="left" width="10%" nowrap="nowrap">
									<font  style="font-size:11px; font-family:'Arial'">#rsDatos.DFEetiqueta#</font>
								</td>
								<td   colspan="1" align="left">
									<font  style="font-size:11px; font-family:'Arial'">#rsDatos.IVvalor#</font>
								</td>
							</table>
                		</td>
					</tr>
				<cfelse>
					<tr>
						<td class="LTtopline"  colspan="1" align="left" nowrap="nowrap">
							<font  style="font-size:13px; font-family:'Arial'">#rsDatos.DEidentificacion#</font>&nbsp;&nbsp; 
						</td>
						<td class="LTtopline"  colspan="1" align="left"  nowrap="nowrap">
							<font  style="font-size:13px; font-family:'Arial'">#rsDatos.nombre#</font>&nbsp;&nbsp;
						</td>
						<cfif isdefined("form.DFElinea") and len(trim(form.DFElinea)) and form.DFElinea gt 0>
							<td class="LTtopline"  colspan="1" align="center">
								<font  style="font-size:13px; font-family:'Arial'">#LSDateFormat(rsDatos.IEdesde, "dd/mm/yyyy")#</font>&nbsp;&nbsp; 
							</td>
							<td class="LTtopline"  colspan="1" align="center">
								<font  style="font-size:13px; font-family:'Arial'">#LSDateFormat(rsDatos.IEhasta, "dd/mm/yyyy")#</font>&nbsp;&nbsp; 
							</td>
							<td class="RLTtopline"  colspan="1" align="LEFT">
								<font  style="font-size:13px; font-family:'Arial'">#rsDatos.IVvalor#</font> 
							</td>
						<cfelse>
							<td class="LTtopline"  colspan="1" align="center">
								<font  style="font-size:13px; font-family:'Arial'">#LSDateFormat(rsDatos.IEdesde, "dd/mm/yyyy")#</font>&nbsp;&nbsp; 
							</td>
							<td class="RLTtopline"  colspan="1" align="center">
								<font  style="font-size:13px; font-family:'Arial'">#LSDateFormat(rsDatos.IEhasta, "dd/mm/yyyy")#</font>&nbsp;&nbsp; 
							</td>
						</cfif> 
					</tr>				
				</cfif>
			</cfloop>
			<tr>
                <td  bgcolor="##CCCCCC" class="Completoline" colspan="#columnas#" align="center">
                    <font  style="font-size:11px; font-family:'Arial'"></font>&nbsp;
                </td>
            </tr>
        </table>
    </cfoutput>
