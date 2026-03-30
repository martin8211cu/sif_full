<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_Reporte_de_Evaluacion_del_Desempeno"
    Default="Reporte de Evaluaci&oacute;n del Desempe&ntilde;o "
    returnvariable="LB_Reporte_de_Evaluacion_del_Desempeno"/> 


<!--- Informacion general de la evaluacion  --->

 <cfquery datasource="#session.dsn#"  name="Rs_Eval">
    select RHEEdescripcion,RHEEfhasta   from  RHEEvaluacionDes 
    where RHEEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#"> 
</cfquery>

<cfquery datasource="#session.DSN#" name="rsParte1" >
    select 
        coalesce(c.RHPcodigoext, c.RHPcodigo) as RHPcodigo,
        c.RHPdescpuesto,
		<cfif form.RHOrden eq 'N'>
        	{fn concat({fn concat({fn concat({fn concat(b.DEnombre , ' ' )}, b.DEapellido1 )}, ' ' )}, b.DEapellido2 )} 
		<cfelse>
			{fn concat({fn concat({fn concat({fn concat(b.DEapellido1 , ' ' )}, b.DEapellido2 )}, ' ' )}, b.DEnombre )}
		</cfif> as nombre,
         b.DEidentificacion, 
		(RHLEnotaauto *<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHEid#">)/100   as RHLEnotaauto,
		(RHLEnotajefe *<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHEid#">)/100   as RHLEnotajefe,
		(RHLEpromotros *<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHEid#">)/100   as RHLEpromotros,
		(RHLEpromJCS *<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHEid#">)/100   as RHLEpromJCS,
		(
            select min(de.DLfvigencia)
            from DLaboralesEmpleado de
            inner join RHTipoAccion ta 
               on de.RHTid = ta.RHTid
              and de.Ecodigo =  ta.Ecodigo
              and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
              and ta.RHTcomportam = 1
            where de.DEid = a.DEid	) as Ingreso ,
		(select 
			 case when rp.CFid is null then 'Actualmente no se encuentra nombrado(a)' else {fn concat(CFcodigo,{fn concat(' ',CFdescripcion)})} end 
				from  DatosEmpleado datemp 
				left outer join LineaTiempo  lt
					on datemp.DEid = lt.DEid
					and  <cfqueryparam value="#Rs_Eval.RHEEfhasta#" cfsqltype="cf_sql_timestamp">  between LTdesde  and  LThasta 
						left outer join RHPlazas rp
					on lt.RHPid  = rp.RHPid  
					and rp.Ecodigo =  datemp.Ecodigo
				left outer join RHPuestos p
					on rp.RHPpuesto  = p.RHPcodigo
					 and p.Ecodigo =  datemp.Ecodigo
				left outer join CFuncional cf
					on  rp.CFid = cf.CFid            	
				where datemp.DEid  = a.DEid 
			)	as centrofuncional,
			
		(  select case when K.DEideval is null then '' else {fn concat({fn concat({fn concat({fn concat(L.DEnombre , ' ' )}, L.DEapellido1 )}, ' ' )}, L.DEapellido2 )}  end 
			from RHEvaluadoresDes K 
			left outer join DatosEmpleado L
				on K.DEideval = L.DEid
			where 
				K.RHEDtipo = 'J' 
				and K.RHEEid = a.RHEEid   
				and K.DEid = a.DEid)	 as jefe	
    from RHListaEvalDes  a
    inner join DatosEmpleado b
        on a.DEid = b.DEid 
        and a.Ecodigo = b.Ecodigo
    inner join RHPuestos c
        on a.RHPcodigo = c.RHPcodigo 
        and a.Ecodigo = c.Ecodigo
    where a.RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
    and a.Ecodigo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
    <cfif isdefined("form.DEid") and len(trim(form.DEid))>
		and a.DEid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	</cfif>
</cfquery>

<!--- <cfdump var="#rsParte1#">  --->

	

<!--- Informacion general del evaluado --->

<cfset LvarFileName = "Evaluacion-del-Desempeno#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
<cf_htmlReportsHeaders 
	title="#LB_Reporte_de_Evaluacion_del_Desempeno#" 
	filename="#LvarFileName#"
	irA="RepEvalDesemp-filtro.cfm" 
	>
  
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
			<td bgcolor="##CCCCCC" class="RLTtopline" colspan="6" align="center">
				<font  style="font-size:13px; font-family:'Arial'">#session.enombre#</font> 
			</td>
		</tr>
        <tr>
			<td bgcolor="##CCCCCC" class="RLTtopline" colspan="6" align="center">
				<font  style="font-size:13px; font-family:'Arial'">#LB_Reporte_de_Evaluacion_del_Desempeno#</font> 
			</td>
		</tr>
        <tr>
			<td bgcolor="##CCCCCC" class="RLTtopline" colspan="6" align="center">
				<font  style="font-size:13px; font-family:'Arial'">#Rs_Eval.RHEEdescripcion#</font> 
			</td>
		</tr>
       <tr >
			<td  class="topline" colspan="6" align="center">
            	<font  style="font-size:11px; font-family:'Arial'"></font>&nbsp;
			</td>
		</tr>
		<tr>
        	<td colspan="6" align="center">
          		<table align="center"   width="100% "cellpadding="0" cellspacing="0" border="0">
                    <tr>
                        <td bgcolor="##CCCCCC" class="LTtopline"  colspan="1" align="left">
                            <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_JefeEvaluador">Jefe Evaluador</cf_translate></font> 
                        </td>
						<td bgcolor="##CCCCCC" class="LTtopline"  colspan="1" align="left">
                            <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_CentroFuncional">Centro Funcional</cf_translate></font> 
                        </td>
						<td bgcolor="##CCCCCC" class="LTtopline"  colspan="1" align="left">
                            <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Cedula">C&eacute;dula</cf_translate></font> 
                        </td>
                        <td bgcolor="##CCCCCC"class="LTtopline"  colspan="1" align="left">
                            <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_nombre">Nombre</cf_translate></font> 
                        </td>
						<td bgcolor="##CCCCCC"class="LTtopline"  colspan="1" align="center">
                            <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_FechaIngreso">Fecha de Ingreso</cf_translate></font> 
                        </td>
                        <td bgcolor="##CCCCCC" class="LTtopline" colspan="1" align="left">
                            <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Puesto">Puesto</cf_translate></font>
                        </td>
                        <td bgcolor="##CCCCCC" class="LTtopline" colspan="1" align="left">
                            <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Descripcion_del_Puesto<">Descripci&oacute;n del Puesto</cf_translate></font>
                        </td>
                        <td bgcolor="##CCCCCC" class="LTtopline" colspan="1" align="center">
                            <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Autoevaluacion">Auto Evaluaci&oacute;n</cf_translate></font>
                        </td>
                        <td bgcolor="##CCCCCC" class="LTtopline" colspan="1" align="center">
                            <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Jefatura">Jefatura</cf_translate></font>
                        </td>
                        <td bgcolor="##CCCCCC" class="LTtopline" colspan="1" align="center">
                            <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_Otros">Otros</cf_translate></font>
                        </td>
                        <td bgcolor="##CCCCCC" class="RLTtopline" colspan="1" align="center">
                            <font  style="font-size:13px; font-family:'Arial'"><cf_translate  key="LB_J_C_S">J-C-S</cf_translate></font>
                        </td>

                    </tr>  
                    <cfloop query="rsParte1">
                    	<tr>
                            <td  class="LTtopline"  colspan="1" align="left">
                              <font  style="font-size:11px; font-family:'Arial'">#rsParte1.jefe#</font>
                            </td>
							<td  class="LTtopline"  colspan="1" align="left">
                              <font  style="font-size:11px; font-family:'Arial'">#rsParte1.centrofuncional#</font>
                            </td>
							<td  class="LTtopline"  colspan="1" align="left">
                              <font  style="font-size:11px; font-family:'Arial'">#rsParte1.DEidentificacion#</font>
                            </td>
                            <td class="LTtopline"  colspan="1" align="left">
                                <font  style="font-size:11px; font-family:'Arial'">#rsParte1.nombre#</font>
                            </td>
							<td class="LTtopline"  colspan="1" align="center">
                                <font  style="font-size:11px; font-family:'Arial'">#LSDateFormat(rsParte1.Ingreso,'dd/mm/yyyy')#</font>
                            </td>
                            <td  class="LTtopline" colspan="1" align="left">
                              <font  style="font-size:11px; font-family:'Arial'">#rsParte1.RHPcodigo#</font>
                            </td>
                            <td  class="LTtopline" colspan="1" align="left">
                              <font  style="font-size:11px; font-family:'Arial'">#rsParte1.RHPdescpuesto#</font>
                            </td>
                            <td  class="LTtopline" colspan="1" align="right">
                              <font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(rsParte1.RHLEnotaauto, ",_.__")#</font>
                            </td>
                            <td class="LTtopline" colspan="1" align="right">
                              <font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(rsParte1.RHLEnotajefe, ",_.__")#</font>
                            </td>
                            <td class="LTtopline" colspan="1" align="right">
                              <font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(rsParte1.RHLEpromotros, ",_.__")#</font>
                            </td>
                            <td  class="RLTtopline" colspan="1" align="right">
                              <font  style="font-size:11px; font-family:'Arial'">#LSNumberFormat(rsParte1.RHLEpromJCS, ",_.__")#</font>
                            </td>
                        </tr>                      
                    </cfloop> 
                    <tr>
                        <td  class="topline" colspan="11" align="center">
                            <font  style="font-size:11px; font-family:'Arial'">&nbsp;</font>
                        </td>
                    </tr> 
                                 
                </table>
            </td>
        </tr>    
	</table>
</cfoutput>