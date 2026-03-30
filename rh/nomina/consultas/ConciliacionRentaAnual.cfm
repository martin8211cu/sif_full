<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ConciliacionderentaAnual"  Default="Conciliación de renta Anual" returnvariable="LB_ConciliacionderentaAnual"/> 
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/rh/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cf_dbfunction name="dateadd"   returnvariable="FechaHastaTemp" args="d.IRfactormeses, c.EIRdesde,MM">
<cf_dbfunction name="dateadd"   returnvariable="FechaHasta" 	args="-1!#FechaHastaTemp#!DD"                delimiters="!">
<cf_dbfunction name="date_part" args="yyyy,c.EIRdesde" returnvariable="AnoDesde">
<cf_dbfunction name="date_part" args="yyyy;#PreserveSingleQuotes(FechaHasta)#" returnvariable="anoHasta"     delimiters = ";" >
<cf_dbfunction name="date_part" args="mm;#PreserveSingleQuotes(FechaHasta)#"   returnvariable="LvarMesHasta" delimiters = ";" >

<cf_dbfunction name="date_part" args="mm,c.EIRdesde"   returnvariable="LvarMesDesde">
<cf_dbfunction name="to_char"	args="#AnoDesde#" 	   returnvariable="LvarAnoDesde">
<cf_dbfunction name="to_char"	args="#AnoHasta#" 	   returnvariable="LvarAnoHasta">

<cfset table="EImpuestoRenta c
        		inner join ImpuestoRenta d
            		on d.IRcodigo = c.IRcodigo
				inner join RHParametros e
					on e.Pvalor = c.IRcodigo">
<cfset table2="CFuncional">
<cfset column="c.EIRid,'Periodo de ' #_Cat# 
				  Case #LvarMesDesde#
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
							   when 12 then 'Diciembre'
					else 'Otro' end #_Cat# ' del ' #_Cat# #LvarAnoDesde# #_Cat# ' a ' #_Cat#
					 Case #LvarMesHasta#
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
								   when 12 then 'Diciembre'
									else 'Otro' end 
					 #_Cat# ' del ' #_Cat# #LvarAnoHasta# as PeriodoLiquidacion,#FechaHasta# as FechaHasta">
<cfset column2="CFid, CFcodigo, CFdescripcion">               
<cf_templateheader title="#LB_ConciliacionderentaAnual#" template="#session.sitio.template#">
	<cfoutput>#pNavegacion#</cfoutput>
    <cf_web_portlet_start titulo='#LB_ConciliacionderentaAnual#'>
    	<form name="form1" method="post" action="ConciliacionRentaAnual-print.cfm">
            <table border="0" align="center">
                <tr>
                    <td>
                        Periodo De Renta:
                    </td>
                    <td>
                        <cf_conlis
                            campos="EIRid,PeriodoLiquidacion,FechaHasta"
                            desplegables="N,S,N"
                            modificables="N,N,N"
                            size="0,68,0"
                            title="Lista de Periodos de Renta"
                            tabla="#PreserveSingleQuotes(table)#"
                            columnas="#PreserveSingleQuotes(column)#"
                            filtro="e.Ecodigo = #session.Ecodigo# order by 1"
                            desplegar="PeriodoLiquidacion"
                            filtrar_por="PeriodoLiquidacion"
                            etiquetas="PeriodoLiquidacion"
                            formatos="S,S,D"
                            align="left,left,left"
                            asignar="EIRid,PeriodoLiquidacion,FechaHasta"
                            asignarformatos="S,S,S"
                            showEmptyListMsg="true"
                            EmptyListMsg="-- No se encontraron Periodos de Renta --"
                            tabindex="1"
                            conexion = "#session.dsn#">	
                    </td>
                </tr>
                <tr>
                    <td>
                        Centro Funcional:
                    </td>
                    <td>
                    	<cf_conlis
                            campos="CFid,CFcodigo,CFdescripcion"
                            desplegables="N,S,S"
                            modificables="N,S,N"
                            size="0,10,55"
                            title="Lista de Centro Funcionales"
                            tabla="#PreserveSingleQuotes(table2)#"
                            columnas="#PreserveSingleQuotes(column2)#"
                            filtro="Ecodigo = #session.Ecodigo#"
                            desplegar="CFcodigo, CFdescripcion"
                            filtrar_por="CFcodigo, CFdescripcion"
                            etiquetas="Codigo, Descripción"
                            formatos="S,S,S"
                            align="left,left,left"
                            asignar="CFid,CFcodigo,CFdescripcion"
                            asignarformatos="S,S,S"
                            showEmptyListMsg="true"
                            EmptyListMsg="-- No se encontraron Periodos de Renta --"
                            tabindex="1"
                            conexion = "#session.dsn#">	
                    </td>
                    <td>
                    	<input type="checkbox" name="ChkIncluyeDep" id="ChkIncluyeDep"/><cf_translate key="LB_IncluirDependencias">Incluir dependencias</cf_translate>
                    </td>
                </tr>
                <tr>
                	<td align="center" colspan="2">
                    	<input name="BtnConsultar" value="Consultar" class="btnImprimir" type="submit" />
                    </td>
                </tr>
            </table>
     	</form>
        <cf_qforms>
            <cf_qformsRequiredField name="EIRid" description="Periodo De Renta">
	</cf_qforms>
	<cf_web_portlet_end>
<cf_templatefooter>