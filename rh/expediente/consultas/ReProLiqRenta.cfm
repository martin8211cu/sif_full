<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_nombre_proceso"  Default="Reimpresión de Proyección y Liquidación de Renta" returnvariable="ReimpresiondeProyeccionyLiquidaciondeRenta"/> 
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Empleado"        Default="Empleado"	       returnvariable="LB_Empleado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Tipo"        	Default="Tipo"	       	   returnvariable="LB_Tipo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Version"        	Default="Versión"      	   returnvariable="LB_Version"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Estado"        	Default="Estado"      	   returnvariable="LB_Estado"/>
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cf_dbfunction name="date_part" returnvariable="AnoDesde" 		args="yyyy,c.EIRdesde">
<cf_dbfunction name="date_part" returnvariable="MesDesde" 		args="mm,c.EIRdesde">
<cf_dbfunction name="dateadd"   returnvariable="FechaHastaTemp" args="d.IRfactormeses, c.EIRdesde,MM">
<cf_dbfunction name="dateadd"   returnvariable="FechaHasta" 	args="-1!#FechaHastaTemp#!DD"                  delimiters="!">
<cf_dbfunction name="date_part" returnvariable="anoHasta" 		args="yyyy;#PreserveSingleQuotes(FechaHasta)#" delimiters = ";" >
<cf_dbfunction name="date_part" returnvariable="mesHasta" 		args="mm;#PreserveSingleQuotes(FechaHasta)#"   delimiters = ";" >

<cfquery name="rsTipo" datasource="#session.DSN#">
	select '-1' as value, '-- Todos -- ' as description from dual
	union all
	select 'P' as value, 'Proyección' as description from dual
    union all
	select 'L' as value, 'Liquidación' as description from dual
</cfquery>
<cfquery name="rsEstado" datasource="#session.DSN#">
	select '-1' as value, '-- Todos -- ' as description from dual
	union all
    select '0' as value, 'En Proceso' as description from dual
	union all
	select '10' as value, 'Aplicado' as description from dual
    union all
	select '20' as value, 'Rechazado' as description from dual
    union all
	select '30' as value, 'Finalizado' as description from dual
</cfquery>
<cfquery name="rsversion" datasource="#session.DSN#">
	select -1 as value, '-- Todas -- ' as description from dual
	union all
    select Distinct a.Nversion as value, 'Versión ' #_Cat# <cf_dbfunction name="to_char" args="a.Nversion"> as description
    from RHLiquidacionRenta a 
		inner join DatosEmpleado b
			on a.DEid = b.DEid
        inner join EImpuestoRenta c
            on c.EIRid = a.EIRid
        inner join ImpuestoRenta d
            on d.IRcodigo = c.IRcodigo
    where a.Ecodigo = #Session.Ecodigo#
    <cfif isdefined('form.FILTRO_TIPO') and form.FILTRO_TIPO NEQ -1>
    	and a.Tipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FILTRO_TIPO#">
    </cfif>
    <cfif isdefined('form.FILTRO_ESTADO') and form.FILTRO_ESTADO NEQ -1>
    	and a.Estado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FILTRO_ESTADO#">
    </cfif>
</cfquery>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/rh/portlets/pNavegacion.cfm">
</cfsavecontent>
<cfquery name="rsProLiqRenta" datasource="#session.dsn#">
	select a.EIRid, a.DEid, a.Periodo, a.Mes, a.Nversion, Tipo,
        case Tipo when 'P' then 'Proyección' when 'L' then 'Liquidación' end as LabelTipo, 
        <cf_dbfunction name="to_char"	args="#AnoDesde#"> as PeriodoD,
        <cf_dbfunction name="to_char"	args="#AnoHasta#"> as PeriodoH,
        <cf_dbfunction name="to_char"	args="#MesDesde#"> as MesD,
        <cf_dbfunction name="to_char"	args="#mesHasta#"> as MesH,
	    b.DEidentificacion  #_Cat# ' - ' #_Cat# b.DEnombre #_Cat# ' ' #_Cat# b.DEapellido1 #_Cat# ' ' #_Cat# b.DEapellido2 Empleado, 
	case Estado 
		when 0 then 'En Proceso' 
		when 10 then 'Aplicado'
		when 20 then 'Rechazado'
		when 30 then 'Finalizado'
	end as Estado, 
    'Periodo de ' #_Cat# 
      Case <cf_dbfunction name="date_part" args="mm,c.EIRdesde">
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
        else 'Otro' end #_Cat# ' del ' #_Cat# <cf_dbfunction name="to_char"	args="#AnoDesde#"> #_Cat# ' a ' #_Cat#
         Case #mesHasta#
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
         #_Cat# ' del ' #_Cat# <cf_dbfunction name="to_char"	args="#AnoHasta#"> as PeriodoLiquidacion
	from RHLiquidacionRenta a 
		inner join DatosEmpleado b
			on a.DEid = b.DEid
        inner join EImpuestoRenta c
            on c.EIRid = a.EIRid
        inner join ImpuestoRenta d
            on d.IRcodigo = c.IRcodigo
    where a.Ecodigo = #Session.Ecodigo#
    <cfif isdefined('form.FILTRO_TIPO') and form.FILTRO_TIPO NEQ -1>
    	and a.Tipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FILTRO_TIPO#">
    </cfif>
    <cfif isdefined('form.FILTRO_ESTADO') and form.FILTRO_ESTADO NEQ -1>
    	and a.Estado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FILTRO_ESTADO#">
    </cfif>
    <cfif isdefined('form.FILTRO_NVERSION') and form.FILTRO_NVERSION NEQ -1>
    	and a.Nversion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FILTRO_NVERSION#">
    </cfif>
    <cfif isdefined('form.FILTRO_EMPLEADO') and LEN(TRIM(form.FILTRO_EMPLEADO))>
    	and upper(b.DEidentificacion  #_Cat# ' - ' #_Cat# b.DEnombre #_Cat# ' ' #_Cat# b.DEapellido1 #_Cat# ' ' #_Cat# b.DEapellido2) 
        like <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="%#TRIM(UCASE(form.FILTRO_EMPLEADO))#%">
    </cfif>
    
    order by 9, 6
</cfquery>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
	<cfoutput>#pNavegacion#</cfoutput>
    <cf_web_portlet_start titulo='#ReimpresiondeProyeccionyLiquidaciondeRenta#'>
		<cfinvoke component="rh.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
                <cfinvokeargument name="query" 			value="#rsProLiqRenta#"/>
                <cfinvokeargument name="desplegar" 		value="LabelTipo, Empleado, Nversion, Estado"/>
                <cfinvokeargument name="etiquetas" 		value="#LB_Tipo#,#LB_Empleado#,#LB_Version#,#LB_Estado#"/>
                <cfinvokeargument name="formatos" 		value="V,V,V,V"/>
                <cfinvokeargument name="align" 			value="left, left, center, center"/>
                <cfinvokeargument name="irA" 			value=""/>
                <cfinvokeargument name="keys" 			value="EIRid,DEid,Periodo,Mes,Tipo"/>
                <cfinvokeargument name="MaxRows" 		value="100"/>
                <cfinvokeargument name="formName" 		value="listaAcciones"/>
                <cfinvokeargument name="navegacion" 	value="#pNavegacion#"/>
                <cfinvokeargument name="incluyeForm"	value="true"/>	
                <cfinvokeargument name="Cortes"			value="PeriodoLiquidacion"/>	
                <cfinvokeargument name="mostrar_filtro"	value="true"/>	
                <cfinvokeargument name="rsLabelTipo"	value="#rsTipo#"/>	
                <cfinvokeargument name="rsEstado"		value="#rsEstado#"/>	
                <cfinvokeargument name="rsNversion"		value="#rsVersion#"/>	
                <cfinvokeargument name="funcion"		value="openReport"/>
                <cfinvokeargument name="fparams"		value="EIRid,DEid,PeriodoD,PeriodoH,MesD,MesH,Tipo,Nversion"/>
            </cfinvoke>
	<cf_web_portlet_end>
<cf_templatefooter>
<script language="javascript" type="text/javascript">
	function openReport(EIRid,DEid,PeriodoD,PeriodoH,MesD,MesH,Tipo,Nversion)
	{
		window.open('/cfmx/rh/autogestion/operacion/ProyLiquiRenta-Report.cfm?EIRid='+EIRid+'&DEid='+DEid+'&PeriodoD='+PeriodoD+'&PeriodoH='+PeriodoH+'&mesD='+MesD+'&mesH='+MesH+'&Tipo='+Tipo+'&version='+Nversion, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=900,height=650,left=130,top=50,screenX=150,screenY=150');
		return false;
	}
</script>