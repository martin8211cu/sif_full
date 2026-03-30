
<cfquery name="rsDatos" datasource="#session.DSN#">

	select de.DEidentificacion,{fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )} as nombre,a.IEfecha,a.IEid 
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
	where a.RHTid  is null
	<cfif isdefined("form.desde") and len(trim(form.desde))>
		and a.IEfecha >= <cfqueryparam value="#LSDateFormat(form.desde,'yyyy/mm/dd')#" cfsqltype="cf_sql_date">
	</cfif>
	<cfif isdefined("form.hasta") and len(trim(form.hasta))>
		and a.IEfecha <= <cfqueryparam value="#LSDateFormat(form.hasta,'yyyy/mm/dd')#" cfsqltype="cf_sql_date">
	</cfif>
	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">	
	
	order by {fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )},a.IEid
	<cfif isdefined("form.DFElinea") and len(trim(form.DFElinea)) and form.DFElinea neq '-1'>
		,c.DFEetiqueta
	</cfif>
</cfquery>

<cfset columnas = 3>
<cfif isdefined("form.DFElinea") and len(trim(form.DFElinea)) and form.DFElinea gt 0 >
	<cfset columnas = 4>
<cfelse>
	<cfset columnas = 3>
</cfif>
<cfset columnasX = columnas -1>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="Detalle_de_citas_por_Colaborador"
	Default="Detalle de citas por Colaborador"
	returnvariable="Detalle_de_citas_por_Colaborador"/>   
    
<cfset LvarFileName = "Detalle_de_citas_por_Colaborador_#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">

<cf_htmlReportsHeaders 
    title="#Detalle_de_citas_por_Colaborador#" 
    filename="#LvarFileName#"
    irA="DetalleCitas-filtro.cfm" >
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
                    <font  style="font-size:14px; font-family:'Arial'">#Detalle_de_citas_por_Colaborador#</font> 
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
				<cfif isdefined("form.DFElinea") and len(trim(form.DFElinea)) and form.DFElinea gt 0 >
					<td bgcolor="##CCCCCC" class="LTtopline"  colspan="1" align="center">
						<font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Fecha">Fecha</cf_translate></font> 
					</td>					
					<td bgcolor="##CCCCCC" class="RLTtopline"  colspan="1" align="left">
						<font  style="font-size:13px; font-family:'Arial'">#rsDatos.DFEetiqueta#</font> 
					</td>
				<cfelse>
					<td bgcolor="##CCCCCC" class="RLTtopline"  colspan="1" align="center">
						<font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Fecha">Fecha</cf_translate></font> 
					</td>				
				</cfif>
			</tr>
			<cfset corte = -1>
			<cfloop query="rsDatos">
				<cfif isdefined("form.DFElinea") and len(trim(form.DFElinea)) and form.DFElinea eq -2>
					<cfif corte neq rsDatos.IEid>
						<tr>
							<td class="LTtopline"  colspan="1" align="left" nowrap="nowrap">
								<font  style="font-size:13px; font-family:'Arial'">#rsDatos.DEidentificacion#</font>&nbsp;&nbsp; 
							</td>
							<td class="LTtopline"  colspan="1" align="left"  nowrap="nowrap">
								<font  style="font-size:13px; font-family:'Arial'">#rsDatos.nombre#</font>&nbsp;&nbsp;
							</td>
							<td class="RLTtopline"  colspan="1" align="center">
								<font  style="font-size:13px; font-family:'Arial'">#LSDateFormat(rsDatos.IEfecha, "dd/mm/yyyy")#</font>&nbsp;&nbsp; 
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
								<font  style="font-size:13px; font-family:'Arial'">#LSDateFormat(rsDatos.IEfecha, "dd/mm/yyyy")#</font>&nbsp;&nbsp; 
							</td>
							<td class="RLTtopline"  colspan="1" align="LEFT">
								<font  style="font-size:13px; font-family:'Arial'">#rsDatos.IVvalor#</font> 
							</td>
						<cfelse>
							<td class="RLTtopline"  colspan="1" align="center">
								<font  style="font-size:13px; font-family:'Arial'">#LSDateFormat(rsDatos.IEfecha, "dd/mm/yyyy")#</font>&nbsp;&nbsp; 
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
